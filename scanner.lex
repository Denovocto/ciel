%{
#include <math.h>
int num_lines = 0;
%}
INTEGER [0-9]+
FLOAT [0-9]+[.][0-9]+
CHAR \"([^'\\\n]|\\.)\"
STRING \"(\\.|[^"\\])*\"
PRIMITIVE char|string|int|float|bool|null
KEYWORD function|return|until|while|for|do|link|goto|if|var|ptr
OPERATOR \+=|-=|%=|\*=|\/=|\+\+|--|\+|-|!|\?|\*|\/|%|\^\^|\|\||&&|\^|\||&|=|put|:|<|>|<=|>=|==|!=
IDENTIFIER [A-Za-z][A-Za-z0-9]*
SYMBOL \.|\(|\)|,|->|<-|=>|\[|\]
COMMENT \|[^|]*\|
WHITESPACE [ \t\n]+
%%
\n 					++num_lines;
{INTEGER} 				printf("Integer: %s (%d)\n", yytext, atoi(yytext));
{FLOAT} 				printf("Float: %s (%g)\n", yytext, atof(yytext));
{CHAR} 					printf("Char: %s\n", yytext);
{STRING}      				printf("String: %s\n", yytext);
{PRIMITIVE} 				printf("Primitive DataType: %s\n", yytext);
"<"{PRIMITIVE}">"|"<"{IDENTIFIER}">" 	printf("DataType Specifier: %s\n", yytext); 
{KEYWORD} 				printf("Keyword: %s\n", yytext);
{OPERATOR} 				printf("Operator: %s\n", yytext);
{IDENTIFIER} 				printf("Identifier: %s\n", yytext);
{SYMBOL} 				printf("Symbol: %s\n", yytext);
{IDENTIFIER}: 				printf("label declaration: %s\n", yytext);
{COMMENT} 				printf("Comment: %s\n", yytext);
{WHITESPACE} 				printf("Whitespace character\n"); 
. 					printf("Unrecognized character: %s\n", yytext);

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

