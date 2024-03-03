# Compiler
CC = g++

# Compiler flags
CFLAGS = -std=c++11 -Wall

# Source files
LEX_SOURCE = cmos.l
CPP_SOURCE = cmos.cpp

# Executable
EXECUTABLE = cmos

all: $(EXECUTABLE)

$(EXECUTABLE): lex.yy.c $(CPP_SOURCE)
	$(CC) $(CFLAGS) -o $@ $^

lex.yy.c: $(LEX_SOURCE)
	flex $^

clean:
	rm -f $(EXECUTABLE) lex.yy.c

.PHONY: all clean
