BUILDS			= alma9 fedora39_btrfs rocky8 rocky9 debian11 debian12
BUILDS_BASE		= $(addprefix base-, $(BUILDS))
BUILDS_CLONE 	= $(addsuffix _packer, $(BUILDS))
REMOTE_DIR		= /var/lib/libvirt/images

export PACKER_KEY_INTERVAL=25ms
UNAME := $(shell uname -s)

ifeq ($(UNAME),Linux)
	VARS_FILE = arch.pkrvars.hcl
endif
ifeq ($(UNAME),Darwin)
	VARS_FILE = mac.pkrvars.hcl
endif

.PHONY: clean-base clean-clone clean info

info:
	@echo "Builds: $(BUILDS)"
	@echo "Base images: $(BUILDS_BASE)"
	@echo "Clone images: $(BUILDS_CLONE)"

clean-base:
	rm -rf artifacts/base-*

clean-clone:
	rm -rf artifacts/*_packer
clean: clean-base clean-clone

clean-base-%:
	rm -rfv "artifacts/base-$*"

base: $(BUILDS_BASE)

clone: $(BUILDS_CLONE)

base-%:
	test -f "artifacts/base-$*/base-$*.raw" || packer build -var-file $(VARS_FILE) -only "qemu.base-$*" .

clone-%:
	test -f "artifacts/$*_packer/$*_packer.raw" || packer build -var-file $(VARS_FILE) -only "qemu.$*_packer" .

copy-%:
	find ./artifacts -type f -name '*_packer.raw' -exec sh -c 'rsync -zvhu --progress {} root@"$*":$(REMOTE_DIR)/"$$(basename {})"' \;
