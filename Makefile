PROJECT		= mes-template
CFILES		= $(wildcard src/*.c)
INCLUDES	= -I.mes/include -I.mes/cpu/mescpu

update:
	@echo "Updating submodules..."
	cd .mes/; git pull origin main
	cd .udynlink/; git pull origin master
	cd .vmes/Virtual-MES/; git pull origin main
	@echo "Updating files..."
	curl "https://raw.githubusercontent.com/menga-team/MES-Template/main/.vmes/CMakeLists.txt" -o .vmes/CMakeLists.txt
	curl "https://raw.githubusercontent.com/menga-team/MES-Template/main/.asset_packer.py" -o .asset_packer.py
	curl "https://raw.githubusercontent.com/menga-team/MES-Template/main/Makefile" -o Makefile

src/%.asset: $(wildcard assets/*)
	for file in $^ ; do \
		base=$$(basename $${file}) ; \
		python .asset_packer.py $${file} > src/$${base}.asset ; \
	done

$(PROJECT).bin: $(CFILES) src/%.asset
	.udynlink/scripts/mkmodule --name "$(PROJECT)" --includes "$(INCLUDES)" $(CFILES)

$(PROJECT).iso: $(PROJECT).bin
	@echo UNIMPLEMENTED

flash-setup:
	cd .mes/; git submodule update --init
	cd .mes/libopencm3; make
	touch .mes/cpu/mescpu/bin/symbols.inc
	cd .mes/cpu/mescpu; make mescpu.elf
	cd .mes/cpu/mescpu; python extract_symbols.py mescpu.elf > bin/symbols.inc


flash: $(PROJECT).bin
	python .mes/cpu/mescpu/create_dummy_game.py $(PROJECT).bin > .mes/cpu/mescpu/dummy_game.h
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
	cd .vmes; cmake .; make; cp game ../game
