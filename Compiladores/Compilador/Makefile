all: tokenizer tiny build

tokenizer:
	flex Scanner.l

tiny:
	bison -d tiny.y

build:
	gcc -c *.c -fno-builtin-exp -Wno-implicit-function-declaration
	gcc *.o -lfl -o compiler -fno-builtin-exp

