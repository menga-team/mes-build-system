PROJECT		= mes-template
CFILES		= $(wildcard src/*.c)
INCLUDES	= -I.mes/include -I.mes/cpu/mescpu

src/%.asset: $(wildcard assets/*)
	for file in $^ ; do \
		base=$$(basename $${file}) ; \
		python3 .mbs/asset_packer.py $${file} > src/$${base}.asset ; \
	done

$(PROJECT).bin: $(CFILES) src/%.asset
	.mes/cpu/mescpu/udynlink/scripts/mkmodule --name "$(PROJECT)" --includes "$(INCLUDES)" $(CFILES)

$(PROJECT).iso: $(PROJECT).bin
	@echo UNIMPLEMENTED

# move to mvm
flash-setup:
	cd .mes/; git submodule update --init
	cd .mes/libopencm3; make
	touch .mes/cpu/mescpu/bin/symbols.inc
	cd .mes/cpu/mescpu; make mescpu.elf
	cd .mes/cpu/mescpu; python extract_symbols.py mescpu.elf > bin/symbols.inc


flash: $(PROJECT).bin
	python3 .mes/cpu/mescpu/create_dummy_game.py $(PROJECT).bin > .mes/cpu/mescpu/dummy_game.h
	cd .mes/cpu/mescpu; make flash

clean:
	-rm src/*.asset
	-rm src/*.o
	-rm src/*.elf
	-rm src/*.bin
	-rm $(MODULE_NAME).bin
	-rm $(MODULE_NAME).iso

assets: src/%.asset

simulate:
	cd .mbs/vmes; cmake .; make; cp game ../.../game
