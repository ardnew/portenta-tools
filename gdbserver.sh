#!/bin/bash

tools_path=$( readlink -f "${0}" )
tools_path=$( dirname "${tools_path}" )

openocd_path="${tools_path}/openocd"
openocd_bin="${openocd_path}/bin/openocd"
openocd_src="${openocd_path}/share/openocd/scripts"
openocd_interface='interface/stlink.cfg'
openocd_target='target/stm32h7x_dual_bank.cfg'

openocd-command() {
	local cmd
	for (( i=1; i<=${#}; ++i )); do
		cmd="${cmd}${!i}"
		[[ ${i} -lt ${#} ]] && 
			cmd="${cmd};"
	done
	cat <<__CMD__ | tr '\n' ';'
		tcl_port disabled
		telnet_port disabled
		init
		reset init
		halt
		adapter speed 4000
__CMD__
		#${cmd}
		#reset run
		#shutdown
}

if [[ ! -x "${openocd_bin}" ]] ||
	[[ ! -f "${openocd_src}/${openocd_interface}" ]] ||
	[[ ! -f "${openocd_src}/${openocd_target}" ]]; then
	echo "error: missing required file(s)" >&2
	exit 2
fi

if ! "${openocd_bin}" \
	-s "${openocd_src}" \
	-f "${openocd_interface}" \
	-f "${openocd_target}" \
	-c "$(openocd-command "${openocd_cmd_program}")"; then
	echo "Failed to start debugger" >&2
	exit 3
fi

