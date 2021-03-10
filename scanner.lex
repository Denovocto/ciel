%{
#include "tokens.h"
#include <math.h>
#include <assert.h>


// Used for stripping first and last character of a string 
// Destructive modify
void stripFirstAndLast(char* str)
{
	assert(str != 0);
	size_t len = strlen(str);
	memmove(str, str+1, len); // strips first character
	str[strlen(str) - 1] = 0; // strips last character
}

// Defining Maximum include stack depth
#define MAX_INCLUDE_DEPTH 15
YY_BUFFER_STATE include_stack[MAX_INCLUDE_DEPTH];
int include_count = 0;

%}
%option nounput yylineno
%x lnk
INTEGER [0-9]+
FLOAT [0-9]+[.][0-9]+
CHAR \"([^'\\\n]|\\.)\"
STRING \"(\\.|[^"\\])*\"
PRIMITIVE char|string|int|float|bool|null
KEYWORD function|return|until|while|for|do|goto|if|var|ptr
OPERATOR \+=|-=|%=|\*=|\/=|\+\+|--|\+|-|!|\?|\*|\/|%|\^\^|\|\||&&|\^|\||&|=|put|:|<|>|<=|>=|==|!=
IDENTIFIER [A-Za-z][A-Za-z0-9]*
SYMBOL \.|\(|\)|,|->|<-|=>|\[|\]
COMMENT \|[^|]*\|
WHITESPACE [ \t\n]+
%%
^"link"[ \t]*\" 				BEGIN(lnk);
{INTEGER} 						return INTEGER_TOKEN;
{FLOAT} 						return FLOAT_TOKEN;
{CHAR} 							return CHAR_TOKEN;
{STRING}      					return STRING_TOKEN;
{PRIMITIVE} 					return PRIMITIVE_TOKEN;
<lnk>\"          				BEGIN(INITIAL); 
<lnk>[ \t]* 					/* Eat Whitespace */
<lnk>[^\"]+ 					{
									if ( include_count >= MAX_INCLUDE_DEPTH )
									{
										fprintf(stderr, "Includes nested too deeply");
										exit(1);
									}
									include_stack[include_count++] = YY_CURRENT_BUFFER;
									yyin = fopen( yytext, "r" );
									if ( ! yyin )
									{
										fprintf( stderr, "Unable to open file \"%s\"\n",yytext);
										exit( 1 );
									}
									yy_switch_to_buffer(yy_create_buffer(yyin,YY_BUF_SIZE));
									BEGIN(INITIAL);
								}
<lnk><<EOF>> 					{
									fprintf( stderr, "EOF in include" );
									yyterminate();
								}
<<EOF>> 						{
									if ( include_count <= 0 )
										yyterminate();
									else 
									{
										yy_delete_buffer(include_stack[include_count--]);
										yy_switch_to_buffer(include_stack[include_count]);
										BEGIN(lnk);
									}
								}
"<"{PRIMITIVE}">"|"<"{IDENTIFIER}">" return DATATYPE_SPECIFIER_TOKEN;
{KEYWORD} 						return KEYWORD_TOKEN;
{OPERATOR} 						return OPERATOR_TOKEN;
{IDENTIFIER} 					return IDENTIFIER_TOKEN;
{SYMBOL} 						return SYMBOL_TOKEN;
{IDENTIFIER}: 					return LABEL_TOKEN;
{COMMENT} 						;
{WHITESPACE} 					;
. 								return UNIDENTIFIED_TOKEN;

%%
int yywrap(void)
{
	return 1;
}
char* tokens[] = {NULL, "INTEGER", "FLOAT", "CHAR", "STRING", "PRIMITIVE",
				"DATATYPE_SPECIFIER", "KEYWORD", "OPERATOR", "IDENTIFIER",
				"SYMBOL", "LABEL", "UNIDENTIFIED"};
int main(int argc, char **argv)
{
	++argv, --argc;
	if (argc > 0)
		yyin = fopen(argv[0], "r");
	else
		yyin = stdin;
	int tokenNumber, tokenValue;
	tokenNumber = yylex();
	while(tokenNumber)
	{
		printf("tokenID: %d\n", tokenNumber);
		printf("token: %s\n", tokens[tokenNumber]);
		switch(tokenNumber)
		{
			case UNIDENTIFIED_TOKEN:
			{
				printf("Unexpected character found: %s in line %d\n", yytext, yylineno);
				exit(1);
			}
			default:
				;
		}
		tokenNumber = yylex();
	}
	return 0;
}

