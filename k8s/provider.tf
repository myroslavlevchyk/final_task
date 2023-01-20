provider "google" {
  credentials = "/<PATH>/mygcp-creds.json"  
  project     = "${var.project_id}"
  zone   = "${var.region}"
}
