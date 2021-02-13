
CC=gcc
LEX=flex
LEX_SOURCE=scanner.lex
EXECUTABLE_NAME=ciel_scanner

all: lexxer executable
lexxer: $(LEX_SOURCE)
	$(LEX) $(LEX_SOURCE)
executable: lex.yy.c
	$(CC) -o $(EXECUTABLE_NAME) lex.yy.c -lfl
clean: 
	rm $(EXECUTABLE_NAME) lex.yy.c
