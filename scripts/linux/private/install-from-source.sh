#!/bin/bash

cores=$(nproc)
packages_dir=/root/packages
install_dir=/usr/local

if [ ! "${1}" = "" ]
then
    packages_dir=${1}
fi

if [ ! "${2}" = "" ]
then
    install_dir=${2}
fi

mkdir -p ${packages_dir}
mkdir -p ${install_dir}

download_file() {
    cd ${packages_dir}
    folder=${packages_dir}/${1}
    url=${2}

    mkdir -p ${folder}
    cd ${folder}
    wget -N ${url}
    cd ${packages_dir}
}

download_packages() {
    googletest_url=https://github.com/google/googletest/archive/release-1.8.0.tar.gz
    oclint_url=https://github.com/oclint/oclint/releases/download/v0.13/oclint-0.13-x86_64-linux-4.4.0-93-generic.tar.gz

    download_file googletest ${googletest_url}
    download_file oclint ${oclint_url}
}

install_googletest() {
    cd ${packages_dir}/googletest
    extracted_folder=googletest-1.8.0
    archive_file=release-1.8.0.tar.gz
    
    if [ ! -e ${extracted_folder} ]
    then
        mkdir -p ${extracted_folder}
        tar xzf ${archive_file} --directory=${extracted_folder} --strip-components=1
    fi
    
    cd ${extracted_folder}
    mkdir -p release
    cd release
    cmake -D CMAKE_BUILD_TYPE=release -D CMAKE_INSTALL_PREFIX=${install_dir} ..
    make -j${cores}
    make install
}

install_oclint() {
    cd ${packages_dir}/oclint
    extracted_folder=oclint-0.13
    archive_file=oclint-0.13-x86_64-linux-4.4.0-93-generic.tar.gz

    if [ ! -e ${extracted_folder} ]
    then
        mkdir -p ${extracted_folder}
        tar xzf ${archive_file} --directory=${extracted_folder} --strip-components=1
    fi

    cd ${extracted_folder}
    cp -vrf bin ${install_dir}
    cp -vrf lib ${install_dir}
}

install_packages() {
    install_googletest
    install_oclint
}

# script starts here
download_packages
install_packages
