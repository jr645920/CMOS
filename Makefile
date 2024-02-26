cmos: cmos.cpp lex.yy.c
    g++ -o cmos cmos.cpp lex.yy.c -lfl

lex.yy.c: cmos.l
    flex cmos.l