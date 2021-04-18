
CC=gcc
LEX=flex
YACC=bison
LEX_SOURCE=scanner.lex
YACC_SOURCE=parser.y
EXECUTABLE_NAME=ciel_scanner

all: lexxer parser executable
lexxer: $(LEX_SOURCE)
	$(LEX) $(LEX_SOURCE)
parser: $(YACC_SOURCE)
	$(YACC) -d $(YACC_SOURCE)
executable: lex.yy.c
	$(CC) -o $(EXECUTABLE_NAME) lex.yy.c y.tab.c -ll -lm
clean: 
	rm $(EXECUTABLE_NAME) lex.yy.c y.tab.c parser.tab.h
