terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  token     = "t1.9euelZqcyJPHjsmLzJWNiZWTzpyVmO3rnpWaz5WdnM6WzcbKx52enYuOkInl8_cAACxa-e8MAVsL_t3z90AuKVr57wwBWwv-zef1656VmsiXjZmSk4-dx43Gnp6Sl8yc7_zF656VmsiXjZmSk4-dx43Gnp6Sl8yc.kRH-_I71Z_hmL6wrBah3EUNDrm0D5v_WAct15tVhM9X7ffB35ETTZZJ9QGlVtMzOnY-9AVg8hRi4ERN5T5pNBw"
  cloud_id  = "b1gosu102nmga2hrdem9"
  folder_id = "b1gb3addo3sljhc5megg"
  zone      = "ru-central1-a"
}

resource "yandex_compute_image" "ubuntu_2004" {
  source_family = "ubuntu-2004-lts"
}

resource "yandex_compute_instance" "vm-1" {
  name = "terraform1"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = yandex_compute_image.ubuntu_2004.id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    ssh-keys = "jenkins:${file("/var/lib/jenkins/id_ed25519.pub")}"
  }
}

resource "yandex_compute_instance" "vm-2" {
  name = "terraform2"

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = yandex_compute_image.ubuntu_2004.id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }
  
  metadata = {
    ssh-keys = "jenkins:${file("/var/lib/jenkins/id_ed25519.pub")}"
  }
}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

output "external_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
}

output "external_ip_address_vm_2" {
  value = yandex_compute_instance.vm-2.network_interface.0.nat_ip_address
}

