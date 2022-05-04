data "terraform_remote_state" "master_account_config" {
  backend = "remote"
  config = {
    organization = "karrostech"
    workspaces = {
      name = "terraform-master-account-config"
    }
  }
}
