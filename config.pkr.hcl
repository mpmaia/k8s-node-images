source "qemu" "ubuntu-2004-amd64-qemu" {
  vm_name           = "ubuntu-2004-amd64-qemu"
  iso_url           = "http://www.releases.ubuntu.com/20.04/ubuntu-20.04.6-live-server-amd64.iso"
  iso_checksum      = "sha256:b8f31413336b9393ad5d8ef0282717b2ab19f007df2e9ed5196c13d8f9153c8b"
  disk_image        = false
  memory            = 1024
  output_directory  = "ubuntu-2004-amd64-qemu"
  accelerator       = "kvm"
  disk_size         = "20000M"
  disk_interface    = "virtio"
  format            = "qcow2"
  net_device        = "virtio-net"
  boot_wait         = "2s"
  headless	    = "true"
  boot_command      = [
    # show language selector
    " <up><wait>",

    # skip selection
    " <up><wait><esc><wait>",

    # show installation options
    "<f6><wait><esc><wait>",

    # clear existing kernel command-line
    "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
    "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
    "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",

    # kernel command-line pointing to our cloud-init script
    "/casper/vmlinuz ",
    "initrd=/casper/initrd ",
    "autoinstall ",
    "ds=nocloud-net;s=http://{{.HTTPIP}}:{{.HTTPPort}}/ ",
    "<enter>",
  ]
  http_directory    = "www"
  shutdown_command  = "echo 'packer' | sudo -S shutdown -P now"
  ssh_username      = "k8s"
  ssh_password      = "k8s123"
  ssh_timeout       = "30m"
}

build {
  sources = ["source.qemu.ubuntu-2004-amd64-qemu"]

  provisioner "shell" {
    scripts         = [
       "provisioning/disable_swap.sh",
       "provisioning/iptables.sh",
       "provisioning/containerd.sh",
       "provisioning/k8s.sh",
       "provisioning/clear_cloud_init.sh"    
    ]
    execute_command = "sudo bash {{.Path}}"
  }
}
