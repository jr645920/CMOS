# Compiler
CC = g++

# Compiler flags
CFLAGS = -std=c++11 -Wall

all: cmos scanner

scanner: lex.yy.c
	$(CC) $(CFLAGS) -o $@ $^

cmos: cmos.cpp
	$(CC) $(CFLAGS) -o $@ $^

lex.yy.c: cmos.l
	flex $^


clean:
	rm -f cmos lex.yy.c PlagarismReport.txt tokens.txt scanner

.PHONY: all clean
