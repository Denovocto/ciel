%{
#include "y.tab.h"
#include <string.h>
#include <stdlib.h>
void yyerror (char *s);
int yylex();
%}
%%
"print"				   								{return print;}
"exit"				   								{return exit_command;}
char|string|int|float|bool|null 					{yylval.myType = strdup(yytext); return myDataType;}
[a-zA-Z]*			   								{yylval.myString = strdup(yytext); return myVar;}
[0-9]+                 								{yylval.num = atoi(yytext); return number;}
[ \t\n]                								;
[-+*/=;]           	   								{return yytext[0];}
.                      								{ECHO; yyerror ("unexpected character");}

%%
int yywrap (void) {return 1;}