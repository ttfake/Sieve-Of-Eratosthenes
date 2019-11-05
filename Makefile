prime: clean prime.o 
	gcc -ggdb -fpic -no-pie -o prime prime.o

prime.o: prime.asm
	nasm -f elf64 -ggdb -F stabs prime.asm

clean: 
	rm -f prime prime.o
