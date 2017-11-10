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
    opencv_url=https://github.com/opencv/opencv/archive/3.3.1.tar.gz
    googletest_url=https://github.com/google/googletest/archive/release-1.8.0.tar.gz

    download_file opencv ${opencv_url}
    download_file googletest ${googletest_url}
}

install_opencv() {
    cd ${packages_dir}/opencv
    extracted_folder=opencv-3.3.1
    archive_file=3.3.1.tar.gz
    
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

install_packages() {
    install_opencv
    install_googletest
}

# script starts here
download_packages
install_packages
