
# make sure qemu is on path

if ! [ -x "$(command -v qemu-system-i386)" ]; then
	echo "Please install qemu."
	exit
fi

qemu-system-i386 -kernel build/kernel/canoos.kernel

