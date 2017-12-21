#!/bin/bash

script_dir=$(realpath $(dirname $0))

# Update packages list
apt-get update

# Install packages
apt-get install -y $(cat ${script_dir}/packages.txt)

# Clean up
apt-get -y autoremove
apt-get -y autoclean
rm -rf /var/lib/apt/lists/*
