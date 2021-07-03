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
	#set +e
	#./mbed-os-to-arduino -a -r "${mbed_path}" "${variant}:${variant}"
	#set -e
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
		mkdir -p "packages/${self_name}/hardware/mbed"
		[[ -e "packages/${self_name}/tools" ]] ||
			ln -s "${arduino_path}/packages/arduino/tools" "packages/${self_name}/"
		[[ -e "packages/${self_name}/hardware/mbed/${self_version}" ]] &&
			rm -rf "packages/${self_name}/hardware/mbed/${self_version}"
		ln -s "${platform}" "packages/${self_name}/hardware/mbed/${self_version}"
		[[ -e "packages/${self_name}/hardware/mbed/${self_version}/cores/arduino/api" ]] ||
			ln -s  "../../core-api/api" \
				"packages/${self_name}/hardware/mbed/${self_version}/cores/arduino/api"
		popd &> /dev/null
	fi
	popd &> /dev/null
}

set -xe

arduino_path='/usr/local/lib/arduino'
variant='PORTENTA_H7_M7'

self_path=$( readlink -f "${0}" )
self_dir=$( dirname "${self_path}" )
self_name=$( basename "${self_dir}" )
self_version=$( command grep -m 1 '[^[:space:]]' "${self_dir}/VERSION" )
platform="${self_dir}/arduino/packages/${self_name}"
arduino_mbed_path="${platform}/cores/arduino/mbed"
mbed_path="${self_dir}/mbed/os"
build_path='/tmp/mbed-os-program'
build_name="mbed-core-${variant}.a"
core_name='libmbed.a'

update-tools
build-core
install-core

set +xe
