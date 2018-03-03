#!/bin/bash

apt-get -y autoremove
apt-get -y autoclean
rm -rf /var/lib/apt/lists/*

packages_dir=/root/packages
if [ ! "${1}" = "" ]
then
    packages_dir=${1}
fi

rm -rf ${packages_dir}
