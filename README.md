# libvirt multi-node testbed

This allows to set up easy local testbeds using libvirt and Terraform

## Prerequisites

- libvirt
- Terraform

## Usage

- `make up` to start up the testbed
  - `make up SINGLE_NODE=y` to use only a single node
- `make down` to stop the testbed
- `make restart` to recreate the testbed machines

## Configuration

The configurable variables can be seen in the `vars.tf` file.

The default configuration creates three nodes on the `172.16.42.0/24` subnet with an MTU of `9000`. 

## Amenities

After `make up` you will find in the `outputs` folder:

- `ansible_inventory` a pre-populated ansible inventory with the provisioned machines
- `ssh_script.sh` a script allowing to connect to each provisioned machine
- `ssh_key` the OpenSSH private key used for connection
- `ssh_key.pub` the OpenSSH public key used for connection
