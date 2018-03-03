#!/bin/bash

script_dir=$(realpath $(dirname $0))

# Update packages list
apt-get update --fix-missing

# Install packages
apt-get install -y $(cat ${script_dir}/packages.txt)
