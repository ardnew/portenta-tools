#!/bin/bash

tools_path=$( readlink -f "${0}" )
tools_path=$( dirname "${tools_path}" )

boot_elf="${tools_path}/arduino/packages/portenta-tools/bootloaders/PORTENTA_H7/portentah7_bootloader_mbed_hs_v2.elf"

# Use bootloader file from command-line if given
[[ ${#} -gt 0 ]] && 
	boot_elf=${1}

if [[ ! -f "${boot_elf}" ]]; then
	echo "error: bootloader (.elf) not found: ${boot_elf}" >&2
	exit 1
fi

openocd_path="${tools_path}/openocd"
openocd_bin="${openocd_path}/bin/openocd"
openocd_src="${openocd_path}/share/openocd/scripts"
openocd_interface='interface/stlink.cfg'
openocd_target='target/stm32h7x_dual_bank.cfg'

openocd_cmd_bootopt='stm32h7x option_write 0 0x01c 0xb86aaf0'
openocd_cmd_program="program ${boot_elf}"

openocd-command() {
	local cmd
	for (( i=1; i<=${#}; ++i )); do
		cmd="${cmd}${!i}"
		[[ ${i} -lt ${#} ]] && 
			cmd="${cmd};"
	done
	cat <<__CMD__ | tr '\n' ';'
		telnet_port disabled
		init
		reset init
		halt
		adapter speed 4000
		${cmd}
		reset run
		shutdown
__CMD__
}

if [[ ! -x "${openocd_bin}" ]] ||
	[[ ! -f "${openocd_src}/${openocd_interface}" ]] ||
	[[ ! -f "${openocd_src}/${openocd_target}" ]] ||
	[[ ! -f "${boot_elf}" ]]; then
	echo "error: missing required file(s)" >&2
	exit 2
fi

echo 'Setting boot option bytes (boot Cortex-M7, gate Cortex-M4) ...'

if ! "${openocd_bin}" \
	-s "${openocd_src}" \
	-f "${openocd_interface}" \
	-f "${openocd_target}" \
	-c "$(openocd-command "${openocd_cmd_bootopt}")"; then
	echo "Failed to write boot option bytes!" >&2
	exit 3
fi

sleep 2
echo 'Programming Portenta H7 bootloader ...'

if ! "${openocd_bin}" \
	-s "${openocd_src}" \
	-f "${openocd_interface}" \
	-f "${openocd_target}" \
	-c "$(openocd-command "${openocd_cmd_program}")"; then
	echo "Failed to program bootloader!" >&2
	exit 4
fi

echo 'Successfully programmed bootloader:'
echo "  ${boot_elf}"

