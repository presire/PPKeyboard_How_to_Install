VERSION := $(shell git describe) $(shell git log -1 --format=%cd --date=iso)

OUT ?= /home/mobian/
CFLAGS ?= -O2 -g0
CFLAGS += -DVERSION="\"$(VERSION)\"" -I. -I$(OUT) -Wall -Wno-unused-variable -Wno-unused-function

all: $(OUT)ppkb-usb-flasher $(OUT)ppkb-usb-debugger $(OUT)fw-stock.bin $(OUT)ppkb-i2c-debugger $(OUT)ppkb-i2c-charger-ctl $(OUT)ppkb-i2c-flasher $(OUT)ppkb-i2c-inputd $(OUT)ppkb-i2c-selftest

$(OUT)ppkb-usb-flasher: usb-flasher.c common.c
	@mkdir -p $(OUT)
	$(CC) $(CFLAGS) -o $@ $<

$(OUT)ppkb-usb-debugger: usb-debugger.c common.c
	@mkdir -p $(OUT)
	$(CC) $(CFLAGS) -o $@ $<

$(OUT)kmap.h: keymaps/physical-map.txt keymaps/factory-keymap.txt
	@mkdir -p $(OUT)
	php keymaps/map-to-c.php $^ $@

$(OUT)ppkb-i2c-inputd: i2c-inputd.c $(OUT)kmap.h common.c
	@mkdir -p $(OUT)
	$(CC) $(CFLAGS) -o $@ $<

$(OUT)ppkb-i2c-debugger: i2c-debugger.c common.c
	@mkdir -p $(OUT)
	$(CC) $(CFLAGS) -o $@ $<

$(OUT)ppkb-i2c-charger-ctl: i2c-charger-ctl.c common.c
	@mkdir -p $(OUT)
	$(CC) $(CFLAGS) -o $@ $<

$(OUT)ppkb-i2c-flasher: i2c-flasher.c common.c
	@mkdir -p $(OUT)
	$(CC) $(CFLAGS) -o $@ $<

$(OUT)ppkb-i2c-selftest: i2c-selftest.c common.c
	@mkdir -p $(OUT)
	$(CC) $(CFLAGS) -o $@ $<

$(OUT)fw-stock.bin $(OUT)fw-user.bin: $(wildcard firmware/*.*)
	@mkdir -p $(OUT)
	cd firmware && ./build.sh
	cp -f firmware/build/fw-stock.bin $(OUT)fw-stock.bin
	cp -f firmware/build/fw-user.bin $(OUT)fw-user.bin
