locals {
  default_tags = merge(var.default_tags, {
    environment = var.environment
  })
}

resource "azurerm_resource_group" "exaemple" {
  # Create a resource group per environment
  name     = "exaemple-${var.environment}"
  location = var.location
  tags     = local.default_tags
}

module "mail-function" {
  # This module is from a local source
  source              = "./function_app"
  resource_group_name = azurerm_resource_group.exaemple.name
  location            = azurerm_resource_group.exaemple.location
  source_directory    = "${path.cwd}/../src/output/mailfunction"

  function_app_settings = {
    "MAILJET_API_KEY"     = var.MAILJET_API_KEY
    "MAILJET_SECRET_KEY"  = var.MAILJET_SECRET_KEY
    "MAILJET_SENDER_MAIL" = var.MAILJET_SENDER_MAIL
  }

  tags = local.default_tags
}

module "relay-function" {
  source              = "./function_app"
  resource_group_name = azurerm_resource_group.exaemple.name
  location            = azurerm_resource_group.exaemple.location
  source_directory    = "${path.cwd}/../src/output/relayfunction"

  function_app_settings = {
    # This function app will call the mail function and needs the URL
    # The URL is an output value from the mail module above
    "RELAY_TARGET_URL" = module.mail-function.function_app_url
  }

  tags = local.default_tags
}
