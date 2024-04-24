DRACUT_MOD_NAME := 99mydebug
INSTALL_DIR := /usr/lib/dracut/modules.d/
MODULE_DIR := ./probe/

.PHONEY: install uninstall clean build

all: build

build:
	$(MAKE) -C $(MODULE_DIR)

clean:
	$(MAKE) -C $(MODULE_DIR) clean

install: build
	rm -rf $(INSTALL_DIR)/99mydebug
	install -D -m 744 -t $(INSTALL_DIR)/$(DRACUT_MOD_NAME)/ ./99mydebug/* 
	install -m 644 -t $(INSTALL_DIR)/$(DRACUT_MOD_NAME)/ $(MODULE_DIR)/probe.ko 

uninstall:
	rm -rf $(INSTALL_DIR)/99mydebug/

