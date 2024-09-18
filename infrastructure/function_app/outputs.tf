output "function_app_url" {
    # Output blocks are used to return information from the module
    description = "The URL of the deployed function app"
    value       = azurerm_windows_function_app.fa.default_hostname
}