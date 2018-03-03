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
    oclint_url=https://github.com/oclint/oclint/releases/download/v0.13.1/oclint-0.13.1-x86_64-linux-4.4.0-112-generic.tar.gz
    opencv_url=https://github.com/opencv/opencv/archive/3.4.1.tar.gz
    opencv_contrib_url=https://github.com/opencv/opencv_contrib/archive/3.4.1.tar.gz

    download_file googletest ${googletest_url}
    download_file oclint ${oclint_url}
    download_file opencv ${opencv_url}
    download_file opencv_contrib ${opencv_contrib_url}
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
    extracted_folder=oclint-0.13.1
    archive_file=oclint-0.13.1-x86_64-linux-4.4.0-112-generic.tar.gz

    if [ ! -e ${extracted_folder} ]
    then
        mkdir -p ${extracted_folder}
        tar xzf ${archive_file} --directory=${extracted_folder} --strip-components=1
    fi

    cd ${extracted_folder}
    cp -vrf bin ${install_dir}
    cp -vrf lib ${install_dir}
}

install_cv() {
    cd ${packages_dir}
    opencv=opencv-3.4.1
    archive_file_opencv=3.4.1.tar.gz
    opencv_contrib=opencv_contrib-3.4.1

    if [ ! -e ${opencv} ]
    then
        mkdir -p ${opencv}
        tar xzf opencv/${archive_file_opencv} --directory=${opencv} --strip-components=1
    fi

    if [ ! -e ${opencv_contrib} ]
    then
        mkdir -p ${opencv_contrib}
        tar xzf opencv_contrib/${archive_file_opencv} --directory=${opencv_contrib} --strip-components=1
    fi

    mkdir -p cv_release
    cd cv_release

	cmake \
        -D CMAKE_BUILD_TYPE=Release \
        -D CMAKE_INSTALL_PREFIX=${install_dir} \
        -D WITH_TBB=ON \
        -D WITH_V4L=ON \
        -D WITH_QT=ON \
        -D WITH_OPENGL=ON \
        -D OPENCV_EXTRA_MODULES_PATH=../${opencv_contrib}/modules \
        ../${opencv}

    make -j${cores}
    make install
}

install_packages() {
    install_googletest
    install_oclint
    install_cv
}

# script starts here
download_packages
install_packages
