
# 外部ツールやパスの定義
GBA_LLVM ?= /Users/yamakentoc/Desktop/gba-llvm-devkit-1-Darwin-arm64
TOOLCHAIN ?= /Library/Developer/Toolchains/swift-latest.xctoolchain/usr/bin
LLVM_BIN = $(GBA_LLVM)/bin
SWIFT_COMPILER = $(TOOLCHAIN)/swiftc
CC = $(BIN)/clang

# ゲーム名と出力ファイルの定義
GAME_NAME = Sprite
ELF_FILE = $(GAME_NAME).elf
GBA_FILE = $(GAME_NAME).gba

# フラグや設定
SWIFT_FLAGS = -wmo -enable-experimental-feature Embedded -target armv4t-none-none-eabi -parse-as-library -import-objc-header Bridging-Header.h -I$(SYSROOT)/include -Xfrontend -internalize-at-link -lto=llvm-thin  -Xfrontend -disable-stack-protector -Xfrontend -disable-objc-interop
CFLAGS = -mthumb -mfpu=none -fno-exceptions -fno-rtti -D_LIBCPP_AVAILABILITY_HAS_NO_VERBOSE_ABORT -fshort-enums
SYSROOT = $(GBA_LLVM)/lib/clang-runtimes/arm-none-eabi/armv4t
LFLAGS = -lcrt0-gba -ltonc
LINKER_FLAGS = -T gba_cart.ld --sysroot $(SYSROOT) -fuse-ld=lld

# Swiftファイルのpath
SWIFT_FILES = $(wildcard Sources/sprite/*.swift)
SWIFT_OBJ_FILES = $(SWIFT_FILES:.swift=.o)

# Cファイルのpath
C_FILES = $(wildcard asset/*.c)
C_OBJ_FILES = $(C_FILES:.c=.o)

# ターゲット定義
# makeでgbaファイルを生成
all: $(GBA_FILE)

# elfファイルを変換してgbaファイルを生成
$(GBA_FILE): $(ELF_FILE)
	$(LLVM_BIN)/llvm-objcopy -O binary $^ $@
	$(LLVM_BIN)/gbafix $@

# elfファイルを生成
$(ELF_FILE): $(SWIFT_FILES) $(C_OBJ_FILES)
	$(SWIFT_COMPILER) -o $@ $(SWIFT_FILES) $(C_OBJ_FILES) \
		$(SWIFT_FLAGS) $(addprefix -Xcc ,$(CFLAGS)) \
		$(addprefix -Xlinker ,$(LFLAGS)) \
		$(addprefix -Xclang-linker ,$(LINKER_FLAGS))
        
%.o: %.c
	$(CC) $< -o $@ -O3 -mthumb --config armv4t-gba.cfg -c

# make runでgbaファイルを実行
run: $(GBA_FILE)
	mGBA $<

# make cleanで生成物をclean
.PHONY: all clean run
clean:
	rm -f *.o *.elf *.gba *.bc
