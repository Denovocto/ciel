%{
void yyerror (char *s);
int yylex();
#include <stdio.h>     /* C declarations used in actions */
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
int currentVarCounter;
char varNames[50][50];
char varValues[50][50];
char varTypes[50][50];
int findVal(char* myString);
int getVarIndex(char* aVar);
%}

%union {int num; char* myString; char* myType;}         /* Yacc definitions */
%start line
%token print
%token exit_command
%token <num> number
%token <myString> myVar
%token <myType> myDataType
%type <num> line exp term 
%type <myString> assignment

%%

/* descriptions of expected inputs     corresponding actions (in C) */

line    : assignment ';'		{;}
		| exit_command ';'		{exit(EXIT_SUCCESS);}
		| print exp ';'			{printf("Printing %d\n", $2);}
		| line assignment ';'	{;}
		| line print exp ';'	{printf("Printing %d\n", $3);}
		| line exit_command ';'	{exit(EXIT_SUCCESS);}
        ;

assignment : myDataType myVar '=' exp          {strcpy(varNames[currentVarCounter], $2);
           	                         			itoa($4, varValues[currentVarCounter], 10);
           	                         			strcpy(varTypes[currentVarCounter], $1);
           	                        			// printf("Printing %s\n", varValues[currentVarCounter]);
                                     			currentVarCounter++;} 
           | myVar '=' exp                     {int varIndex = getVarIndex($1);
           										if(varIndex != -1)
           										{
           											strcpy(varNames[varIndex], $1);
           	                         				itoa($3, varValues[varIndex], 10);
           										}
           										else
           										{
           											yyerror("Var hasn't been initialized!");
           											exit(0);
           										}} 
		   ;
exp    	: term                  {$$ = $1;}
       	| exp '+' term          {$$ = $1 + $3;}
       	| exp '-' term          {$$ = $1 - $3;}
	    | exp '*' term          {$$ = $1 * $3;}
	    | exp '/' term          {$$ = $1 / $3;} 
       	;
term   	: number                {$$ = $1;}
		| myVar					{int varValue = findVal($1);
								 if(varValue == -1){
								 	yyerror("Var doesn't exist!");
           							exit(0);
								 }
								 else
								 	$$ = varValue;}
									
        ;

%%                     /* C code */

int findVal(char* aVar)
{
	int i;
	for(i=0; i<50; i++) {
		if(strcmp(varNames[i], aVar) == 0)
		{
			return atoi(varValues[i]);
		}
	}
	return -1;
}
int getVarIndex(char* aVar)
{
	int i;
	for(i=0; i<50; i++) {
		if(strcmp(varNames[i], aVar) == 0)
		{
			return i;
		}
	}
	return -1;
}
int main (void) {

	currentVarCounter = 0;
	return yyparse ( );
}

void yyerror (char *s) {fprintf (stderr, "%s\n", s);} 