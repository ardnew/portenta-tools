#!/bin/bash

fqbn='portenta-tools:mbed:envie_m7'
loglevel='debug'

buildpath="${HOME}/.tmp/arduino"

sketchpath=$( readlink -f "${0}" )
[[ $# -gt 0 ]] && sketchpath=${1}

if [[ -f "${sketchpath}" ]]; then # is a file
	output=$( dirname "${sketchpath}" )
else # is a directory
	output=${sketchpath} 
fi

sketch=$( basename "${sketchpath}" ".ino" )

arduino-cli compile \
	--fqbn "${fqbn}" \
	--log-level "${loglevel}" \
	--verbose \
	--clean \
	--optimize-for-debug \
	--build-path "${buildpath}/build/${sketch}" \
	--build-cache-path "${buildpath}/cache/${sketch}" \
	--output-dir "${output}" \
	"${sketchpath}"
