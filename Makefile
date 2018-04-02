# flags
CC = gcc
ASM = nasm
ASM_FLAGS = -f elf64


# All Targets
all: calc

# link and build program
calc: bin/add.o bin/sub.o bin/mul.o bin/div.o bin/bignum_stack.o
	@echo 'Building targets'
	$(CC) -o bin/calc bin/add.o bin/sub.o bin/div.o bin/mul.o bin/bignum_stack.o 
	@echo 'Finished building targets'
	@echo ' '

# compile each file
bin/add.o: add.s
	$(ASM) $(ASM_FLAGS)  add.s -o bin/add.o
	
bin/sub.o: sub.s
	$(ASM) $(ASM_FLAGS)  sub.s -o bin/sub.o
	
bin/mul.o: mul.s
	$(ASM) $(ASM_FLAGS)  mul.s -o bin/mul.o
	
bin/div.o: mul.s
	$(ASM) $(ASM_FLAGS)  div.s -o bin/div.o	
	
bin/bignum_stack.o: bignum_stack.c
	$(CC) -c bignum_stack.c -o bin/bignum_stack.o
	
# Clean the build directory
clean: 
	rm -f bin/*

# Run program
run:
	./bin/calc