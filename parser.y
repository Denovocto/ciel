%{
void yyerror (char *s);

#include <stdio.h>                          
#include <string.h>

extern int  yylexlinenum;                   /* these are in YYlex      */
extern char *yytext;                        /* current token           */

%}

%union
{
    char   identifier[128];
    int    integer;
	int   boolean;
    double floating_point;
    char   string[sizeof(uint32_t)];
    char   character;
}
/*							LITERALS								*/
%token <integer>		TOK_INTEGER_LIT
%token <floating_point>	TOK_FLOAT_LIT
%token <character>		TOK_CHAR_LIT  
%token <string>			TOK_STRING_LIT
%token <boolean>		TOK_BOOL_LIT
/*							PRIMITIVES								*/
%token					TOK_CHAR_PR
%token					TOK_STRING_PR
%token                  TOK_INTEGER_PR
%token                  TOK_FLOAT_PR
%token                  TOK_BOOL_PR
%token                  TOK_NULL_PR
/*							KEYWORDS								*/
%token					TOK_FUNCT_KEY
%token					TOK_RETURN_KEY
%token					TOK_UNTIL_KEY
%token					TOK_WHILE_KEY
%token					TOK_FOR_KEY
%token					TOK_DO_KEY
%token					TOK_GOTO_KEY
%token					TOK_IF_KEY
%token					TOK_VAR_KEY
%token					TOK_PTR_KEY
/*							OPERATORS								*/
%token					TOK_SUMEQ_OP
%token					TOK_MINEQ_OP
%token					TOK_MODEQ_OP
%token					TOK_MULTEQ_OP
%token					TOK_DIVEQ_OP
%token					TOK_INC_OP
%token					TOK_DEC_OP
%token					TOK_SUM_OP
%token					TOK_MINUS_OP
%token					TOK_NOT_OP
%token					TOK_QSTN_OP
%token					TOK_MULT_OP
%token					TOK_DIV_OP
%token					TOK_MOD_OP
%token					TOK_EXP_OP
%token					TOK_OR_OP
%token					TOK_AND_OP
%token					TOK_BITXOR_OP
%token					TOK_BITOR_OP
%token					TOK_BITAND_OP
%token					TOK_TEQ_OP
%token					TOK_LEQ_OP
%token					TOK_GEQ_OP
%token					TOK_NEQ_OP
%token					TOK_EQ_OP
%token					TOK_PUT_OP
%token					TOK_COLON_OP
%token					TOK_LESS_OP
%token					TOK_GRTR_OP
/*							SYMBOLS								*/
%token					TOK_DOT_SBL
%token					TOK_LPAR_SBL
%token					TOK_RPAR_SBL
%token					TOK_COMMA_SBL
%token					TOK_LARROW_SBL
%token					TOK_RARROW_SBL
%token					TOK_FATCOMMA_SBL
%token					TOK_LBRACKET_SBL
%token					TOK_RBRACKET_SBL
/*							TYPES								*/
%token					TOK_FLOAT

%left  TOK_MINUS_OP TOK_PLUS_OP
%left  TOK_MULT_OP TOK_DIV_OP
%right TOK_EXP_OP

%type  <floating_point> exp TOK_FLOAT
%%
input   :
        | input line
        ;

line    : TOK_DOT_SBL
        | exp TOK_DOT_SBL { printf("%g\n",$1);}

exp     : TOK_FLOAT                 { $$ = $1; }
        | exp TOK_SUM_OP  exp          { $$ = $1 + $3;   }
        | exp TOK_MINUS_OP exp          { $$ = $1 - $3;   }
        | exp TOK_MULT_OP  exp          { $$ = $1 * $3;   }
        | exp TOK_DIV_OP   exp          { $$ = $1 / $3;   }
        | TOK_MINUS_OP  exp %prec TOK_MINUS_OP { $$ = -$2;       }
        | exp TOK_EXP_OP exp          { $$ = pow($1,$3);}
        | TOK_LPAR_SBL exp TOK_LPAR_SBL                      { $$ = $2;        }
        ;

%%


int main(int argc, char *argv[])
{
    yyparse();
    return(0);
}

int yyerror(char *message)
{
    extern FILE *yyout;
    fprintf(yyout,"\nError at line %5d. (%s) \n", yylexlinenum,message);
}