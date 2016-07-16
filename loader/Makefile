#Makefile

OUTPUT=../output/
Pro=$(OUTPUT)loader.bin
SRC=loader.asm

$(Pro):$(SRC)
	nasm -o $(Pro) $(SRC)

.PHONY:clean
clean:
	rm $(Pro)
