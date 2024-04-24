#!/usr/bin/bash

# Decide whether or not include this module in initramfs. (called by dracut)
# [Return value]
# - 0: Include this module
# - 1: Not include this module
# - 255: Only if othrer module depends on this module, include this module
check() {
	# Port from 99kdumpbase/module-setup.sh
	[[ $debug ]] && set -x
    #kdumpctl sets this explicitly
    if [[ -z $IN_KDUMP ]] || [[ ! -f /etc/kdump.conf ]]; then
        return 1
    fi
	return 0
}

# Print other module names that this module depends on. (called by dracut)
# Format: "<mod1> <mod2>"
depends() {
	echo ""
	return 0
}

# Print kernel command line options that are needed at boot? (called by dracut)
# Format: " <option1> <option2>" (start with a space)
cmdline() {
	echo -n " "
	return 0
}

# Install binalies, scripts, and files related to kernel. (called by dracut)
installkernel() {
	destmods=$srcmods

	# Install probe.ko into /lib/modules/<uname -r>/extra/ at initramfs
	inst "$moddir/probe.ko" "$destmods/extra/"

	# Install hook-pre-pivot-kernel.sh in the dracut hook "pre-pivot"
	inst_hook pre-pivot 01 "$moddir/hook-pre-pivot-kernel.sh"
}

# Install binalies, scripts, and files not related to kernel. (called by dracut)
install() {
	# Install cat command
	inst "/bin/cat" "/bin/cat"

	# Install hook-pre-pivot.sh in the dracut hook "pre-pivot"
	inst_hook pre-pivot 01 "$moddir/hook-pre-pivot.sh"
}
