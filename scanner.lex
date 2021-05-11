%{
	#include "parser.tab.hpp"
	#include <math.h>
	#include <assert.h>
	#include <string.h>
	#include <stdlib.h>
	// add free for strdup
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
	extern int yylineno;
%}
%option nounput yylineno
%x lnk

INTEGER [0-9]+
FLOAT [0-9]+[.][0-9]+
CHAR \"([^'\\\n]|\\.)\"
STRING \"(\\.|[^"\\])*\"
BOOL true|false
PRIMITIVE char|string|int|float|bool|null
IDENTIFIER [A-Za-z][A-Za-z0-9]*
COMMENT \|[^|]*\|
WHITESPACE [ \t\n]+

%%
^"link"[ \t]*\" 				BEGIN(lnk);

{INTEGER} 						{yylval.integer = atoi(yytext); return TOK_INTEGER_LIT;}	/*							LITERALS								*/
{FLOAT} 						{yylval.floating_point = atof(yytext); return TOK_FLOAT_LIT;}
{CHAR} 							{yylval.character = yytext[1]; return TOK_CHAR_LIT;}
{STRING}      					{stripFirstAndLast(yytext); yylval.string = strdup(yytext); return TOK_STRING_LIT;}
{BOOL}							{
									if(strcmp(yytext, "true") == 0)
									{
										yylval.boolean = 1; 
									}
									else
									{	
										yylval.boolean = 0;
									}
									return TOK_BOOL_LIT;
								}
"char"							return TOK_CHAR_PR;					/*							PRIMITIVES								*/
"string"						return TOK_STRING_PR;
"int"							return TOK_INTEGER_PR;
"float"							return TOK_FLOAT_PR;
"bool"							return TOK_BOOL_PR;
"null"							return TOK_NULL_PR;

"function"						return TOK_FUNCT_KEY;				/*							KEYWORDS								*/
"return"						return TOK_RETURN_KEY;
"until"							return TOK_UNTIL_KEY;
"while"							return TOK_WHILE_KEY;
"for"							return TOK_FOR_KEY;
"do"							return TOK_DO_KEY;
"goto"							return TOK_GOTO_KEY;
"if"							return TOK_IF_KEY;
"else"							return TOK_ELSE_KEY;
"var"							return TOK_VAR_KEY;

"\+="							return TOK_SUMEQ_OP;				/*							OPERATORS								*/
"\-="							return TOK_MINEQ_OP;
"%="							return TOK_MODEQ_OP;
"\*="							return TOK_MULTEQ_OP;
"\/="							return TOK_DIVEQ_OP;
"\+\+"							return TOK_INC_OP;
"--"							return TOK_DEC_OP;
"\+"							return TOK_SUM_OP;
"-"								return TOK_MINUS_OP;
"!"								return TOK_NOT_OP;
"\?"							return TOK_QSTN_OP;
"\*"							return TOK_MULT_OP;
"\/"							return TOK_DIV_OP;
"%"								return TOK_MOD_OP;
"\^\^"							return TOK_EXP_OP;
"\|\|"							return TOK_OR_OP;
"&&"							return TOK_AND_OP;
"\^"							return TOK_BITXOR_OP;
"\|"							return TOK_BITOR_OP;
"&"								return TOK_BITAND_OP;
"=="							return TOK_TEQ_OP;
"<="							return TOK_LEQ_OP;
">="							return TOK_GEQ_OP;
"!="							return TOK_NEQ_OP;
"="								return TOK_EQ_OP;
"put"							return TOK_PUT_OP;
":"								return TOK_COLON_OP;
"<"								return TOK_LESS_OP;
">"								return TOK_GRTR_OP;

"\."							return TOK_DOT_SBL;					/*							SYMBOLS								*/
"\("							return TOK_LPAR_SBL;
"\)"							return TOK_RPAR_SBL;
","								return TOK_COMMA_SBL;
"->"							return TOK_LARROW_SBL;
"<-"							return TOK_RARROW_SBL;
"=>"							return TOK_FATCOMMA_SBL;
"\["							return TOK_LBRACKET_SBL;
"\]"							return TOK_RBRACKET_SBL;
"stdout"						return TOK_STDOUT_STREAM;			/*							MACROS								*/
"stdin"							return TOK_STDIN_STREAM;
<lnk>\"							BEGIN(INITIAL); 
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
"<"{PRIMITIVE}">"				{stripFirstAndLast(yytext); yylval.specifier = strdup(yytext); return TOK_SPECIFIER_PR;}
{IDENTIFIER} 					{yylval.identifier = strdup(yytext); return TOK_IDENTIFIER;}
{IDENTIFIER}: 					{yylval.label = strdup(yytext); return TOK_LABEL_IDENTIFIER;}
"\n"							{yylineno++;}
{COMMENT} 						;
{WHITESPACE} 					;
. 								return UNIDENTIFIED_TOKEN;
%%
int yywrap(void)
{
	return 1;
}