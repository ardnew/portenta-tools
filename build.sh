#!/bin/bash

update-tools() {
	pushd "${self_dir}" &> /dev/null
	git submodule sync --recursive
	git pull --recurse-submodules
	popd &> /dev/null
}

build-core() {
	pushd "${platform}" &> /dev/null
	./mbed-os-to-arduino -a -r "${mbed_path}" "${variant}:${variant}" 
	./mbed-os-to-arduino -c -r "${mbed_path}" "${variant}:${variant}"
	popd &> /dev/null
}

self_path=$( readlink -f "${0}" )
self_dir=$( dirname "${self_path}" )
platform="${self_dir}/arduino/packages/portenta-tools"
mbed_path="${self_dir}/mbed/os"
variant='PORTENTA_H7_M7'

#update-tools
build-core
