
CC=g++
LEX=flex
YACC=bison
LEX_SOURCE=scanner.lex
YACC_SOURCE=parser.ypp
EXECUTABLE_NAME=ciel_scanner

all: lexxer parser executable
lexxer: $(LEX_SOURCE)
	$(LEX) $(LEX_SOURCE)
parser: $(YACC_SOURCE)
	$(YACC) -d $(YACC_SOURCE)
executable: lex.yy.c
	$(CC) -o $(EXECUTABLE_NAME) lex.yy.c parser.tab.cpp -ll -lm
clean: 
	rm $(EXECUTABLE_NAME) lex.yy.c parser.tab.cpp parser.tab.hpp
 