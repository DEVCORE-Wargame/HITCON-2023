BUILD_DIR=./build
LIB=-I include/ 
all:img


img:asm
	dd if=$(BUILD_DIR)/mbr.bin of=$(BUILD_DIR)/redpill count=1 bs=512 conv=notrunc
	dd if=$(BUILD_DIR)/loader.bin of=$(BUILD_DIR)/redpill bs=512 count=200 seek=1 conv=notrunc 

asm:
	nasm  $(LIB) -o $(BUILD_DIR)/loader.bin loader.S
	$(eval num_sectors := $(shell BLOCKSIZE=512 du ./build/loader.bin | cut -f1))
	nasm $(LIB) -Wall -D NUM_SECTORS=$(num_sectors) -f bin -o $(BUILD_DIR)/mbr.bin mbr.S

.PHONY:clean
clean:
	rm $(BUILD_DIR)/*.*
