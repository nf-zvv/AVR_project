# Имя программы и собранного бинарника
TARGET = AVR_project

# файлы программы
C_SOURCES = \
src/AVR_project.c \
src/functions.c 

# название контроллера для компилятора
MCU = atmega328p

# параметры для AVRDUDE
DUDE_MCU = m328p
PORT = COM5
PORTSPEED = 115200

# DEFINы
DEFINES = \
-D__AVR_ATmega328P__ \
-DF_CPU=16000000UL

# путь к каталогу с GCC
AVRCCDIR = c:/avr-gcc-11.1.0-x64-windows/bin/

#само название компилятора, мало ли, вдруг оно когда-нибудь поменяется
CC = avr-gcc.exe
OBJCOPY = avr-objcopy.exe
OBJDUMP = avr-objdump.exe

# каталог в который будет осуществляться сборка, что бы не засерать остальные каталоги
BUILD_DIR = build

#флаги для компилятора 
OPT = -Os
C_FLAGS = -mmcu=$(MCU) $(OPT) -Wall

# пути к заголовочным файлам
C_INCLUDES =  \
-Ic:/avr-gcc-11.1.0-x64-windows/avr/include \
-Iinc

# служебные переменные
OBJ_FILES = $(C_SOURCES:.c=.o)
ASM_FILES = $(C_SOURCES:.c=.s)
OUT_OBJ = $(addprefix $(BUILD_DIR)/, $(notdir $(OBJ_FILES)))

## Intel Hex file production flags
HEX_FLASH_FLAGS = -j .text -j .data

HEX_EEPROM_FLAGS = -j .eeprom
HEX_EEPROM_FLAGS += --set-section-flags=.eeprom="alloc,load"
HEX_EEPROM_FLAGS += --change-section-lma .eeprom=0 --no-change-warnings

# правила для сборки

all: $(TARGET).hex $(TARGET).eep $(TARGET).lss

$(TARGET).hex: $(TARGET).elf
	$(AVRCCDIR)$(OBJCOPY) $(HEX_FLASH_FLAGS) -O ihex $(BUILD_DIR)/$< $(BUILD_DIR)/$@

$(TARGET).elf: $(OBJ_FILES) $(ASM_FILES)
	$(AVRCCDIR)$(CC) $(C_FLAGS) $(DEFINES) $(OUT_OBJ) -o $(BUILD_DIR)/$@

$(TARGET).eep:  $(TARGET).elf
	-$(AVRCCDIR)$(OBJCOPY) $(HEX_EEPROM_FLAGS) -O ihex $(BUILD_DIR)/$< $(BUILD_DIR)/$@ || exit 0

$(TARGET).lss: $(TARGET).elf
	$(AVRCCDIR)$(OBJDUMP) -h -S $(BUILD_DIR)/$< > $(BUILD_DIR)/$@

%.o: %.c
	echo $^
	$(AVRCCDIR)$(CC) -c $(C_FLAGS) $(DEFINES) $(C_INCLUDES) $< -o $(BUILD_DIR)/$(@F)

%.s: %.c
	echo $^
	$(AVRCCDIR)$(CC) -S -g3 $(C_FLAGS) $(DEFINES) $(C_INCLUDES) $< -o $(BUILD_DIR)/$(@F)

clean:
	rmdir /S /Q $(BUILD_DIR)

prog: $(TARGET).hex
	$(AVRCCDIR)avrdude -p $(DUDE_MCU) -c arduino -P $(PORT) -b $(PORTSPEED) -U flash:w:$(BUILD_DIR)/$(TARGET).hex

read_eeprom:
	$(AVRCCDIR)avrdude -p $(DUDE_MCU) -c arduino -P $(PORT) -b $(PORTSPEED) -U eeprom:r:eeprom.hex:i

write_eeprom: $(TARGET).eep
	$(AVRCCDIR)avrdude -p $(DUDE_MCU) -c arduino -P $(PORT) -b $(PORTSPEED) -U eeprom:w:$(BUILD_DIR)/$(TARGET).eep

size: $(TARGET).elf
	$(AVRCCDIR)avr-size $(BUILD_DIR)/$<

## Other dependencies
-include $(shell mkdir $(BUILD_DIR) 2>NUL)
