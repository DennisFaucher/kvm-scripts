#!/bin/bash
if [ -z "$1" ]; then
  echo "Error: No argument supplied."
  echo "Usage: $0 <vm_name>"
  exit 1
fi

echo "Creating root drive from template... (sudo password required)"
sudo cp /var/lib/libvirt/images/debian13-20GB-template.qcow2 /var/lib/libvirt/images/$1.qcow2

echo "Customizing root drive with root password, hostname, updates, dennis user, ssh, sudo..."
sudo virt-customize --add "/var/lib/libvirt/images/$1.qcow2" --root-password password:root --hostname "$1" --firstboot-command 'apt update && apt upgrade -y && apt install openssh-server -y && useradd -m -p "" dennis && chage -d 0 dennis && sudo usermod -aG sudo dennis'

echo "Installing and starting VM..."
sudo virt-install --name $1 --ram 4096 --vcpus 2 --disk path=/var/lib/libvirt/images/$1.qcow2,format=qcow2,bus=virtio --import --os-variant debian13 --network bridge=br0 --graphics spice --noautoconsole

virsh --connect qemu:///system list --all
