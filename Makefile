DPO_VERSION = $(shell sed -n 's/^[ 	]*MODULE_VERSION[ 	]*([ 	]*"\([^"]*\)"[ 	]*)[ 	]*;[ 	]*$$/\1/p' delay_power_off.c)
DPO_DESCRIPTION = $(shell sed -n 's/^[ 	]*MODULE_DESCRIPTION[ 	]*([ 	]*"\([^"]*\)"[ 	]*)[ 	]*;[ 	]*$$/\1/p' delay_power_off.c)
.PHONY: clean install-src dkms-install
clean:
	rm -f dkms.conf PKGBUILD
dkms.conf: dkms.conf.in delay_power_off.c
	sed -e 's/@@DPO_VERSION@@/$(DPO_VERSION)/g' $@.in > $@
PKGBUILD: PKGBUILD.in delay_power_off.c
	sed -e 's/@@DPO_DESCRIPTION@@/$(DPO_DESCRIPTION)/g' -e 's/@@DPO_VERSION@@/$(DPO_VERSION)/g' $@.in > $@
	makepkg --geninteg >> $@
install-src: dkms.conf
	install -d $(DESTDIR)/usr/src/delay_power_off-$(DPO_VERSION)
	install -m 0644 -t $(DESTDIR)/usr/src/delay_power_off-$(DPO_VERSION) delay_power_off.c dkms.conf
	install -m 0644 -T Makefile.dkms $(DESTDIR)/usr/src/delay_power_off-$(DPO_VERSION)/Makefile
dkms-install: install-src
	dkms install --force -m delay_power_off/$(DPO_VERSION)
