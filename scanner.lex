%{
#include <math.h>
int num_lines = 0;
%}
INTEGER [0-9]+
FLOAT [0-9]+[.][0-9]+
STRING \"(\\.|[^"\\])*\"
CHAR \"(\\.|[^"\\])?\"
%%
\n 		++num_lines;
{INTEGER} 	printf("Integer: %s (%d)\n", yytext, atoi(yytext));
"+"|"-" 	printf("Operator: %s\n", yytext);
{FLOAT} 	printf("Float: %s (%g)\n", yytext, atof(yytext));
{STRING}      	printf("String: %s (%g)\n", yytext);
%%
int main(int argc, char **argv)
{
	++argv, --argc;
	if (argc > 0)
		yyin = fopen(argv[0], "r");
	else
		yyin = stdin;
	yylex();
	printf("Lines %d", num_lines);
}

