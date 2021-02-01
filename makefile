
CC=gcc
LEX=flex
LEX_SOURCE=ciel.lex
EXECUTABLE_NAME=ciel

all: lexxer executable
lexxer: $(LEX_SOURCE)
	$(LEX) $(LEX_SOURCE)
executable: lex.yy.c
	$(CC) -o $(EXECUTABLE_NAME) lex.yy.c -ll
clean: 
	rm $(EXECUTABLE_NAME) lex.yy.c
