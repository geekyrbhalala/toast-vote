terraform {
  backend "s3" {
    bucket       = "terraform-state-toast-vote"
    key          = "toast-vote/terraform.tfstate"
    region       = "ca-central-1"
    use_lockfile = true
    encrypt      = true
  }
}