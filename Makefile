PROJECT		= mes-template
CFILES		= $(wildcard src/*.c)
INCLUDES	= -I.mes/include -I.mes/cpu/mescpu

src/%.asset: $(wildcard assets/*)
	for file in $^ ; do \
		base=$$(basename $${file}) ; \
		python asset_packer.py $${file} > src/$${base}.asset ; \
	done

$(PROJECT).bin: $(CFILES) src/%.asset
	.udynlink/scripts/mkmodule --name "$(PROJECT)" --includes "$(INCLUDES)" $(CFILES)

$(PROJECT).iso: $(MODULE_NAME).bin
	@echo UNIMPLEMENTED

clean:
	-rm src/*.asset
	-rm src/*.o
	-rm src/*.elf
	-rm src/*.bin
	-rm $(MODULE_NAME).bin
	-rm $(MODULE_NAME).iso

assets: src/%.asset

simulate:
	cd .vmes; cmake .; make; cp game ../game
