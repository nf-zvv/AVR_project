# Шаблон проекта AVR на C для VSCODE под Windows

Пример программы, приведенной в шаблоне, выполняет простую функцию - мигание светодиодом, подключенным в PB5 с использованием прерывания таймера. Также оставлен код (функция `func.c`) для мигания светодиодом без использования таймера.

## Отредактировать файлы проекта под свои цели

Исходники проекта хранятся в папке `src`. Заголовочные файлы в `inc`. Скомпилированные файлы будут лежать в папке `build`.

Для использования шаблона необходимо выполнить следующие шаги.

### Задать имя проекта

1. В файле `.vscode\c_cpp_properties.json` отредактировать строчку:
```
"name": "AVR_project",
```

2. В файле `Makefile` отредактировать строчку:
```
TARGET = AVR_project
```

3. Переименовать главный файл проекта `src\AVR_project.c`.

### Указать используемый микроконтроллер

1. В файле `.vscode\c_cpp_properties.json` отредактировать строчку, указав используемый микроконтроллер:
```
"__AVR_ATmega328P__"
```

2. В файле `Makefile` отредактировать строчки, указав используемый микроконтроллер:
```
# название контроллера для компилятора
MCU = atmega328p
...

# параметры для AVRDUDE
DUDE_MCU = m328p
...

# DEFINы
DEFINES = \
-D__AVR_ATmega328P__ \
```

### Задать частоту кварцевого резонатора

1. В файле `.vscode\c_cpp_properties.json` отредактировать строчку, указав частоту в герцах:
```
"F_CPU 16000000UL",
```

2. В файле `Makefile` отредактировать строчку, указав частоту в герцах:
```
-DF_CPU=16000000UL
```

### Указать пути до компилятора и заголовочных файлов

1. В файле `.vscode\c_cpp_properties.json` отредактировать строчки:
```
"includePath": [
				...
                "c:/avr-gcc-11.1.0-x64-windows/avr/include/"
...

"compilerPath": "c:/avr-gcc-11.1.0-x64-windows/bin/avr-gcc.exe",
```

2. В файле `Makefile` отредактировать строчки:
```
# путь к каталогу с GCC
AVRCCDIR = c:/avr-gcc-11.1.0-x64-windows/bin/
...

# пути к заголовочным файлам
C_INCLUDES =  \
-Ic:/avr-gcc-11.1.0-x64-windows/avr/include \
```

### Подключить файлы программы

В `Makefile` в переменную `C_SOURCES` добавить используемые файлы.

### Указать порт и скорость для программатора Avrdude

В файле `Makefile` отредактировать строчки:
```
PORT = COM5
PORTSPEED = 115200
```

## Сборка проекта и прошивка микроконтроллера

Для сборки проекта необходимо во встроенном терминале VSCODE (Ctrl+Shift+\`) выполнить команду `make` в каталоге проекта. В результате в папке `build` будут созданы следующие файлы: сама прошивка `*.hex`, EEPROM `*.eep`, ассемблерный листинг `*.lss`.

Другие цели сборки:

- `make prog` - прошивка flash памяти микроконтроллера;
- `make read_eeprom` - считает содержимое EEPROM памяти микроконтроллера;
- `make write_eeprom` - запишет память EEPROM микроконтроллера;
- `make size` - покажет размер прошивки;
- `make clean` - очистка.
