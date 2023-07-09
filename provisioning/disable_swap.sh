#!/bin/bash
sudo swapoff -a 
sudo sed -e '/swap/ s/^#*/#/' -i /etc/fstab
