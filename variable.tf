/*variable "disk_list_windows"{
    type = set(string)
    description = "please enter the disk list"
    default = ["gcpiagaddvw08", "gcpiagdcdvw01", "gcpiagdcdvw02"]
}*/

variable "disk_list_linux"{
    type = set(string)
    description = "please enter the disk list"
    default = ["gcpactvltvl01", "gcpactvldvl01"] # "gcpacsiemdvl01", "gcpacsftpdvl01", "gcpacsftpdvl01-data", "gcpacgitdvl01", "gcpacgitdvl01-data", "ad-test-gn"]
}


#Create Snapshot Policy
#Dev/Test will retain snapshots for 7 days.
/*resource "google_compute_resource_policy" "dev-test-policy" {
  name = "actc-dev-test-snapshot-schedule"
  region = "us-central1"
  snapshot_schedule_policy {
    schedule {
      hourly_schedule {
        hours_in_cycle = 23
        start_time     = "04:00" #11PM CST
      }
    }
    retention_policy {
      max_retention_days    = 7
      on_source_disk_delete = "APPLY_RETENTION_POLICY"
    }
    snapshot_properties {
      labels = {
        env = "dev-test"
        client = "actc"
      }
      storage_locations = ["us"]
      guest_flush       = true
    }
  }
}*/



#Create Snapshot Policy for linux vms
#Dev/Test will retain snapshots for 7 days.
resource "google_compute_resource_policy" "dev-test-linux-policy" {
  name = "actc-dev-test-linux-snapshot-schedule" 
  region = "us-central1"
  snapshot_schedule_policy {
    schedule {
      hourly_schedule {
        hours_in_cycle = 23
        start_time     = "04:00" #11PM CST
      }
    }
    retention_policy {
      max_retention_days    = 7
      on_source_disk_delete = "APPLY_RETENTION_POLICY"
    }
    snapshot_properties {
      labels = {
        env = "dev-test"
        client = "dvt"
      }
      storage_locations = ["us"]
      guest_flush       = false
    }
  }
}

/*resource "google_compute_disk_resource_policy_attachment" "git-dev-test-windows" {
  for_each = var.disk_list_windows  
  name = google_compute_resource_policy.dev-test-policy.name
  disk = each.value #Disk is same name as VM
#   zone = google_compute_instance.git-dev-test.zone
  project = "actc-dev-test"
}*/

resource "google_compute_disk_resource_policy_attachment" "git-dev-test-linux" {
  for_each = var.disk_list_linux 
  name = google_compute_resource_policy.dev-test-linux-policy.name
  disk = each.value #Disk is same name as VM
  zone = "us-central1-a"
  project = "dvt-prj"
}

