variable "gke_num_nodes" {
  default     = 1
  description = "number of gke nodes"
}

resource "google_container_cluster" "primary" {
  name                     = "${var.project_id}-gke"
  location                 = var.region
  remove_default_node_pool = true
  initial_node_count       = 1
  network                  = google_compute_network.vpc.name
  subnetwork               = google_compute_subnetwork.subnet.name

  addons_config {
    http_load_balancing {
      disabled = true
    }
    horizontal_pod_autoscaling {
      disabled = false
    }
  }
}

resource "google_container_node_pool" "primary_nodes" {
  name    = "${google_container_cluster.primary.name}"
  location   = var.region
  cluster = google_container_cluster.primary.name
  node_count = var.gke_num_nodes

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  autoscaling {
    min_node_count = 0
    max_node_count = 10
  }

  node_config {
    labels = {
      env = var.project_id
    }

    preemptible  = true
    machine_type = "e2-medium"
    tags         = ["gke-node", "${var.project_id}-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}
