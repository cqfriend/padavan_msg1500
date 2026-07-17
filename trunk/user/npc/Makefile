THISDIR := $(shell pwd)
NPC_URL := https://github.com/cqfriend/padavan_msg1500/raw/refs/heads/main/npc

all: download_test
	@echo "npc build done!"

download_test:
	( if [ ! -f npc_bin ]; then \
		wget -t5 --timeout=20 --no-check-certificate -O npc_bin $(NPC_URL); \
		upx --lzma --best npc_bin || true; \
	fi )

clean:
	rm -f npc_bin

romfs:
ifeq ($(CONFIG_FIRMWARE_INCLUDE_NPC),y)
	$(ROMFSINST) -p +x $(THISDIR)/npc_bin /usr/bin/npc
endif
	$(ROMFSINST) -p +x $(THISDIR)/npc.sh /usr/bin/npc.sh
	$(ROMFSINST) /etc_ro/npc_script.sh
