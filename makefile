
CC=gcc
LEX=flex
LEX_SOURCE=scanner.lex
LEX_RESULT=scanner.c
LEX_HEADER=scanner.h
EXECUTABLE_NAME=ciel_scanner

all: lexxer executable
lexxer: $(LEX_SOURCE)
	$(LEX) --outfile=$(LEX_RESULT) --header-file=$(LEX_HEADER) $(LEX_SOURCE)
executable: 
	$(CC) -o $(EXECUTABLE_NAME) $(LEX_RESULT) -ll
clean: 
	rm $(EXECUTABLE_NAME) $(LEX_HEADER) $(LEX_RESULT) $(LEX_TABLES)
