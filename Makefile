# Compiler
CC = g++

# Compiler flags
CFLAGS = -std=c++11 -Wall

all: cmos

cmos: lex.yy.c cmos.cpp
	$(CC) $(CFLAGS) -o $@ $^

lex.yy.c: cmos.l
	flex $^

clean:
	rm -f cmos lex.yy.c

.PHONY: all clean
