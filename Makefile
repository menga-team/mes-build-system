PROJECT		= game
CFILES		= $(wildcard ../src/*.c)
INCLUDES	= -I../.mes/include -I../.mes/cpu/mescpu -I../.mes/cpu/mescpu/TinyMT/tinymt

../src/%.asset: $(wildcard ../assets/*)
	for file in $^ ; do \
		base=$$(basename $${file}) ; \
		python3 asset_packer.py $${file} > ../src/$${base}.asset ; \
	done

../$(PROJECT).bin: $(CFILES) ../src/%.asset
	../.mes/cpu/mescpu/udynlink/scripts/mkmodule --name "$(PROJECT)" --includes "$(INCLUDES)" $(CFILES)
	-rm ../$(PROJECT).bin
	cp $(PROJECT).bin ..

../$(PROJECT).iso: ../$(PROJECT).bin ../assets/icon.m3ifp
	cd ../.mes/sdformat; cargo run -- iso ../.. "$(PROJECT).iso"

iso: ../$(PROJECT).iso

../assets/icon.m3ifp: ../icon.png
	mkdir -p ../assets
	cd ../.mes/gpu/image2mes; cargo run -- -i ../../../icon.png -c '$(shell jq .sd_information.colormap ../mesproj.json -c)' -t bin -e -o ../../../assets/icon_full.m3ifp
	convert ../icon.png -crop 29x26+3+6 ../assets/icon_cropped.png
	cd ../.mes/gpu/image2mes; cargo run -- -i ../../../assets/icon_cropped.png -c '$(shell jq .sd_information.colormap ../mesproj.json -c)' -t bin -e -o ../../../assets/icon.m3ifp

flash-setup:
	cd ../.mes/; git submodule update --init
	cd ../.mes/libopencm3; make TARGETS='stm32/f1'
	mkdir -p ../.mes/cpu/mescpu/bin
	touch ../.mes/cpu/mescpu/bin/symbols.inc
	cd ../.mes/cpu/mescpu; make mescpu.elf
	cd ../.mes/cpu/mescpu; python3 extract_symbols.py mescpu.elf > bin/symbols.inc

flash: ../$(PROJECT).bin
	python3 ../.mes/cpu/mescpu/create_dummy_game.py $(PROJECT).bin > ../.mes/cpu/mescpu/dummy_game.h
	cd ../.mes/cpu/mescpu; make flash

clean:
	-rm ../src/*.asset
	-rm ../src/*.o
	-rm ../src/*.elf
	-rm ../src/*.bin
	-rm $(MODULE_NAME).bin
	-rm $(MODULE_NAME).iso

assets: ../src/%.asset

simulate:
	cd vmes; cmake .; make && cp game ../../game && ./../../game
