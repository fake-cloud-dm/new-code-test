terraform {
  backend "azurerm" {

    resource_group_name  = "rg-devops-tfstate-uksouth-001"
    storage_account_name = "dmuransmsdntfstate"
    container_name       = "tfstate"
    key                  = "tfstate-london-bourough-of-bexley-testingnewcode"
  }
}
