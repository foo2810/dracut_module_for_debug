obj-m := probe.o
CFLAGS_probe.o := -DDEBUG

PWD := $(CURDIR)

all:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules

clean:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean

help:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) help

install:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules_install
