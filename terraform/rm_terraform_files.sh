#!/bin/bash

# This script is to remove the terraform environment after the EC2 instance is destroyed

rm -rf .terraform
rm .terraform.lock.hcl
rm terraform.tfstate
rm terraform.tfstate.backup