provider "google" {
 credentials = "${file(var.key_file)}"
 project     = var.projectID
 region      = var.project_region
}

// Firewall creation to allow traffic to the instances:

resource "google_compute_firewall" "firewall" {
  name    = var.firewall_name
  network = "default"

  allow {
    protocol = "tcp"
    ports    = [var.allowed_port]
  }
  target_tags = ["fiverr-firewall"]
  source_ranges = [var.allowed_ip_range]
}

// Virtual Machines creation:

resource "google_compute_instance" "vm_instance1" {
 name         = var.virtual_machine1_name
 machine_type = var.virtual_machine1_type
 zone         = var.virtual_machine1_zone

 tags = ["fiverr-firewall"]

 boot_disk {
   initialize_params {
     image = var.virtual_machine1_os_image
     type = var.virtual_machine1_boot_disk_type 
     size = var.virtual_machine1_boot_disk_size 
   }
 }

 metadata_startup_script = "sudo sed -i 's/#baseurl=/baseurl=/g' /etc/yum.repos.d/CentOS-Base.repo;sudo yum install git -y ;git clone https://github.com/aruntony005/apache-webserver.git ;sh apache-webserver/webserver_install.sh"

 network_interface {
   network = var.vpc_network_name
   access_config {

   }
 }
}

resource "google_compute_instance" "vm_instance2" {
 name         = var.virtual_machine2_name
 machine_type = var.virtual_machine2_type
 zone         = var.virtual_machine2_zone

 tags = ["fiverr-firewall"]

 boot_disk {
   initialize_params {
     image = var.virtual_machine2_os_image
     type = var.virtual_machine2_boot_disk_type
     size = var.virtual_machine2_boot_disk_size
  }
 }

 metadata_startup_script = "sudo sed -i 's/#baseurl=/baseurl=/g' /etc/yum.repos.d/CentOS-Base.repo;sudo yum install git -y ;git clone https://github.com/aruntony005/apache-webserver.git ;sh apache-webserver/webserver_install.sh"

 network_interface {
   network = var.vpc_network_name
   access_config {

   }
 }
}

// Load balancing:

// Frontend of the Load balancer:

resource "google_compute_forwarding_rule" "frontend" {
  name       = var.load_balancer_frontend_name
  target     = google_compute_target_pool.backend.id
  port_range = var.load_balancer_frontend_port
}

// Backend of the Load Balancer. Creation of Instance group pool:

resource "google_compute_target_pool" "backend" {
  name = var.instance_group_pool_name 

  instances = [
    google_compute_instance.vm_instance1.self_link,
    google_compute_instance.vm_instance2.self_link,
  ]

  health_checks = [
    google_compute_http_health_check.webserver-health.name,
  ]
}

// Health check of the target instance pool. This checks the health of the instances and routes the traffic to the healthy ones.

resource "google_compute_http_health_check" "webserver-health" {
  name               = var.load_balancer_health_check_name 
  request_path       = var.load_balancer_health_check_request_path 
  check_interval_sec = 1
  timeout_sec        = 1
  port               = var.health_check_port
}
