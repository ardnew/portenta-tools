#!/bin/bash

update-tools() {
	pushd "${self_dir}" &> /dev/null 
	git submodule sync --recursive
	git pull --recurse-submodules
#	rsync -avh --info=progress2 --ignore-existing "${mbed_path}/" "${arduino_mbed_path}/"
	popd &> /dev/null
}

build-core() {
	pushd "${platform}" &> /dev/null
	rm -rf "${build_path}" || exit
	set +e
	./mbed-os-to-arduino -a -r "${mbed_path}" "${variant}:${variant}"
	set -e
	./mbed-os-to-arduino -c -r "${mbed_path}" "${variant}:${variant}"
	popd &> /dev/null
}

install-core() {
	pushd "${platform}" &> /dev/null
	mkdir -p "${platform}/variants/${variant}/libs"
	cp "${build_path}/BUILD/${build_name}" "${platform}/variants/${variant}/libs/${core_name}"
	# install the core in arduino runtime
	if [[ -d "${arduino_path}" ]]; then
		pushd "${arduino_path}" &> /dev/null
		mkdir -p "packages/${self_dir}/hardware/mbed"
		[[ -e "packages/${self_dir}/tools" ]] ||
			ln -s "${arduino_path}/packages/arduino/tools" "packages/${self_dir}/"
		[[ -e "packages/${self_dir}/hardware/mbed/${self_version}" ]] &&
			rm -rf "packages/${self_dir}/hardware/mbed/${self_version}"
		ln -s "${platform}" "packages/${self_dir}/hardware/mbed/${self_version}"
		popd &> /dev/null
	fi
	popd &> /dev/null
}

set -xe

self_path=$( readlink -f "${0}" )
self_dir=$( dirname "${self_path}" )
self_version=$( command grep -m 1 '[^[:space:]]' "${self_dir}/VERSION" )
arduino_path='/usr/local/lib/arduino'
platform="${self_dir}/arduino/packages/portenta-tools"
arduino_mbed_path="${platform}/cores/arduino/mbed"
mbed_path="${self_dir}/mbed/os"
build_path='/tmp/mbed-os-program'
build_name='mbed-core-PORTENTA_H7_M7.a'
variant='PORTENTA_H7_M7'
core_name='libmbed.a'

update-tools
build-core
install-core

set +xe
