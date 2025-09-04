#!/bin/bash
if [ -z "$1" ]; then
  echo "Error: No argument supplied."
  echo "Usage: $0 <vm_name>"
  exit 1
fi

echo "Creating root drive from XFCE4 template... (sudo password required)"
sudo cp /var/lib/libvirt/images/template-xfce-kvm.qcow2 /var/lib/libvirt/images/$1.qcow2

echo "Customizing root drive with hostname, updates..."
sudo virt-customize --add "/var/lib/libvirt/images/$1.qcow2" --hostname "$1" --firstboot-command 'apt update && apt upgrade -y'

echo "Installing and starting VM..."
sudo virt-install --name $1 --ram 4096 --vcpus 2 --disk path=/var/lib/libvirt/images/$1.qcow2,format=qcow2,bus=virtio --import --os-variant debian13 --network bridge=br0 --graphics spice --noautoconsole

virsh --connect qemu:///system list --all
