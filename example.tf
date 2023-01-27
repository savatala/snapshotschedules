module "project-services" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 14.1"

  project_id                  = "my-project-id"

  activate_apis = [
    "compute.googleapis.com",
    "iam.googleapis.com",
  ]
}