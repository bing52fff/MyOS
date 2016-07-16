#!/bin/bash

arg=debug

cd loader
make clean
make
cd -

cd output
dd if=loader.bin of=a.img bs=512 count=1 conv=notrunc
cd -