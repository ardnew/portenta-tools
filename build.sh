#!/bin/bash

update-tools() {
	echo "---"
	echo "--- UPDATING BUILD SOURCE"
	echo "---"
	pushd "${self_dir}" &> /dev/null 
	git submodule sync --recursive || exit 1
	git pull --recurse-submodules || exit 2
	rsync -avh --info=progress2 --ignore-existing "${mbed_path}/" "${arduino_mbed_path}/"
	popd &> /dev/null
}

build-core() {
	echo "---"
	echo "--- BUILDING PORTENTA H7 CORE"
	echo "---"
	pushd "${platform}" &> /dev/null
	rm -rf "${build_path}" || exit 3
	./mbed-os-to-arduino -a -r "${mbed_path}" "${variant}:${variant}"
	./mbed-os-to-arduino -c -r "${mbed_path}" "${variant}:${variant}" || exit 4
	popd &> /dev/null
}

install-core() {
	echo "---"
	echo "--- INSTALLING PORTENTA H7 CORE"
	echo "---"
	push "${platform}" &> /dev/null
	mkdir -p "${platform}/variants/${variant}/libs" || exit 5
	cp -v "${build_path}/BUILD/${build_name}" "${platform}/variants/${variant}/libs/${core_name}" || exit 6
	popd &> /dev/null
}

self_path=$( readlink -f "${0}" )
self_dir=$( dirname "${self_path}" )
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
