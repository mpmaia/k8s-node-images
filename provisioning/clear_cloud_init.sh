#!/bin/bash

# cleanup cloud-init data
rm -rf /var/lib/cloud/*

ln -s /var/lib/cloud/instances /var/lib/cloud/instance

# cleanup cloud-init logs
rm -rf /var/log/cloud-init*

