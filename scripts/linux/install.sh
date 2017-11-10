#!/bin/bash

if [ ! "${EUID}" = "0" ]
then
   echo "ERROR: ${0} must be run as root" 
   exit 1
fi

script_dir=$(realpath $(dirname $0))
${script_dir}/private/install-from-apt.sh
${script_dir}/private/install-from-source.sh
