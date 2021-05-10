
CC=gcc
GCC=g++
LEX=flex
YACC=bison
LEX_SOURCE=scanner.lex
YACC_SOURCE=parser.ypp
EXECUTABLE_NAME=ciel

all: lexxer parser scanner_exe executable
lexxer: $(LEX_SOURCE)
	$(LEX) $(LEX_SOURCE)
parser: $(YACC_SOURCE)
	$(YACC) -d $(YACC_SOURCE)
scanner_exe: lex.yy.c
	$(CC) -c -g lex.yy.c -ll -lm
executable:
	$(GCC) -g -o $(EXECUTABLE_NAME) lex.yy.o parser.tab.cpp -ll -lm
clean: 
	rm $(EXECUTABLE_NAME) lex.yy.c lex.yy.o parser.tab.cpp parser.tab.hpp