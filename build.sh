#!/bin/bash

update-tools() {
	echo "---"
	echo "--- UPDATING BUILD SOURCE"
	echo "---"
	pushd "${self_dir}" &> /dev/null 
	git submodule sync --recursive || exit 1
	git pull --recurse-submodules || exit 2
	popd &> /dev/null
}

build-core() {
	echo "---"
	echo "--- BUILDING PORTENTA H7 CORE"
	echo "---"
	pushd "${platform}" &> /dev/null
	./mbed-os-to-arduino -a -r "${mbed_path}" "${variant}:${variant}"
	./mbed-os-to-arduino -c -r "${mbed_path}" "${variant}:${variant}" || exit 3
	popd &> /dev/null
}

install-core() {
	echo "---"
	echo "--- INSTALLING PORTENTA H7 CORE"
	echo "---"
	push "${platform}" &> /dev/null
	mkdir -p "${platform}/variants/${variant}/libs" || exit 4
	cp -v "${build_path}/${build_name}" "${platform}/variants/${variant}/libs/${core_name}" || exit 5
	popd &> /dev/null
}

self_path=$( readlink -f "${0}" )
self_dir=$( dirname "${self_path}" )
platform="${self_dir}/arduino/packages/portenta-tools"
mbed_path="${self_dir}/mbed/os"
build_path='/tmp/mbed-os-program/BUILD'
build_name='mbed-core-PORTENTA_H7_M7.a'
variant='PORTENTA_H7_M7'
core_name='libmbed.a'

update-tools
build-core
install-core
