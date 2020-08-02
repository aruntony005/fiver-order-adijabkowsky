projectID          = "terraform-v2-267811"
key_file           = "fiverr.json"
project_region     = "us-central1"


firewall_name      = "fiverr-firewall"
allowed_ip_range   = "0.0.0.0/0"
allowed_port       = "8080"
vpc_network_name   = "default"


virtual_machine1_name           = "fiverr-instance1"
virtual_machine1_type           = "n1-standard-2"
virtual_machine1_zone           = "us-central1-a"
virtual_machine1_os_image       = "centos-cloud/centos-7"
virtual_machine1_boot_disk_type = "pd-standard"
virtual_machine1_boot_disk_size = "20"


virtual_machine2_name           = "fiverr-instance2"
virtual_machine2_type           = "n1-standard-2"
virtual_machine2_zone           = "us-central1-a"
virtual_machine2_os_image       = "centos-cloud/centos-7"
virtual_machine2_boot_disk_type = "pd-standard"
virtual_machine2_boot_disk_size = "20"


load_balancer_frontend_name             = "website-forwarding-rule"
load_balancer_frontend_port             = "8080"
instance_group_pool_name                = "instance-pool"
load_balancer_health_check_name         = "default"
load_balancer_health_check_request_path = "/sample"
health_check_port                       = "8080"
