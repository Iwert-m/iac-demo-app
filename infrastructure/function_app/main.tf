locals {
  # The merge function merges maps
  function_tags              = merge(var.tags, { module = "function-app" })
  generated_funtion_app_name = random_pet.function_app[0].id
  # The coalesce function returns the first non-null value
  # Here it is used to set the function app name to the generated name if it is not provided
  function_app_name          = coalesce(var.function_app_name, local.generated_funtion_app_name)
  function_app_settings = merge(var.function_app_settings,
    {
      # we will deploy this function app from a package stored in a blob storage
      "WEBSITE_RUN_FROM_PACKAGE" = azurerm_storage_blob.storage_blob_function.url
  })
}

resource "random_pet" "function_app" {
  # The count block can be used to conditionally create a resource
  # 1 or 0 instances of the resource are created based on the condition
  # ! It does turn the resource into a list
  count = var.function_app_name == null ? 1 : 0
}

data "archive_file" "function_bundle" {
  type        = "zip"
  output_path = "${path.cwd}/../${local.function_app_name}.zip"
  source_dir  = var.source_directory
}

data "azurerm_storage_account" "functionsa" {
  # Data blocks allow data to be fetched or computed for use elsewhere 
  name                = coalesce(var.storage_account_name, azurerm_storage_account.functionsa[0].name)
  resource_group_name = var.resource_group_name
}

resource "azurerm_storage_account" "functionsa" {
  count                    = var.storage_account_name == null ? 1 : 0
  # All the string functions are used to ensure the storage account name is valid
  name                     = "sa${replace(lower(substr(local.function_app_name, 0, 24)), "-", "")}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = local.function_tags
}

resource "azurerm_storage_container" "fa-container" {
  # This resource creates a container in the storage account to store the function app package
  name                  = "${local.function_app_name}-source"
  storage_account_name  = data.azurerm_storage_account.functionsa.name
  # The container_access_type is set to blob to allow access to the blobs in the container
  # Normally it is set to private and an access key is created to access the blobs (cfr. azurerm_storage_account_sas)
  container_access_type = "blob"
}

resource "azurerm_storage_blob" "storage_blob_function" {
  # This resource creates a blob in the storage account with the function app package
  name                   = "${local.function_app_name}.zip"
  storage_account_name   = data.azurerm_storage_account.functionsa.name
  storage_container_name = azurerm_storage_container.fa-container.name
  type                   = "Block"
  source                 = data.archive_file.function_bundle.output_path
}

resource "azurerm_service_plan" "functionappplan" {
  # This resource creates a service plan for the function app
  name                = "serviceplan-${local.function_app_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "Y1"
  os_type             = "Windows"

  tags = local.function_tags
}

resource "azurerm_windows_function_app" "fa" {
  name                       = local.function_app_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  service_plan_id            = azurerm_service_plan.functionappplan.id
  storage_account_name       = data.azurerm_storage_account.functionsa.name
  storage_account_access_key = data.azurerm_storage_account.functionsa.primary_access_key

  site_config {
    application_stack {
      # The function app is a Go app in this case and the runtime is set to custom
      use_custom_runtime = true
    }
  }

  app_settings = local.function_app_settings
  tags         = local.function_tags
}

