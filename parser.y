%{
void yyerror (char *s);

#include <stdio.h>                          
#include <string.h>
int intValuesCounter = 0;
int charValuesCounter = 0;
int floatValuesCounter = 0;
int stringValuesCounter = 0;
int boolValuesCounter = 0;
extern int  yylexlinenum;                   /* these are in YYlex      */
extern char *yytext;                        /* current token           */
char identifiers[50][50][5];
int int_values[50];
char char_values[50];
float float_values[50];
int bool_values[50];
char string_values[50][50];
%}

enum dataTypes {
    INTEGER,
    CHARACTER,
    FLOAT,
    BOOL,
    STRING
};

%union
{
    char   identifier[128];
    int    integer;
	int   boolean;
    double floating_point;
    char   string[sizeof(int)];
    char   character;
}
/*							LITERALS								*/
%token <integer>		TOK_INTEGER_LIT
%token <floating_point>	TOK_FLOAT_LIT
%token <character>		TOK_CHAR_LIT  
%token <string>			TOK_STRING_LIT
%token <boolean>		TOK_BOOL_LIT
/*							PRIMITIVES								*/
%token					TOK_SPECIFIER_PR
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

/*							IDENTIFIERS							*/
%token                  TOK_IDENTIFIER_SBL
%token                  TOK_IDENTIFIER
%token                  TOK_LABEL_IDENTIFIER
%token                  UNIDENTIFIED_TOKEN
%%
line    : assignment ';'		{;}
		| exit_command ';'		{exit(EXIT_SUCCESS);}
		| print exp ';'			{printf("Printing %d\n", $2);}
		| line assignment ';'	{;}
		| line print exp ';'	{printf("Printing %d\n", $3);}
		| line exit_command ';'	{exit(EXIT_SUCCESS);}
        ;

assignment  :   TOK_INTEGER_PR  TOK_IDENTIFIER  '=' exp     {   
                                                                strcpy(identifiers[intValuesCounter][0], $2);
           	                         			                int_values[intValuesCounter] = $4;
                                                                intValuesCounter++;
                                                            }
            |   TOK_CHAR_PR TOK_IDENTIFIER  '=' exp         {
                                                                strcpy(identifiers[charValuesCounter][1], $2);
           	                         			                char_values[charValuesCounter] = $4;
                                                                charValuesCounter++;
                                                            }
            |   TOK_FLOAT_PR TOK_IDENTIFIER  '=' exp        {
                                                                strcpy(identifiers[floatValuesCounter][2], $2);
           	                         			                float_values[floatValuesCounter] = $4;
                                                                floatValuesCounter++;
                                                            }
            |   TOK_STRING_PR TOK_IDENTIFIER  '=' exp       {
                                                                strcpy(identifiers[stringValuesCounter][3], $2);
           	                         			                strcpy(string_values[stringValuesCounter], $4);
                                                                stringValuesCounter++;
                                                            }
            |   TOK_BOOL_PR TOK_IDENTIFIER  '=' exp         {
                                                                strcpy(identifiers[boolValuesCounter][4], $2);
           	                         			                bool_values[boolValuesCounter] = $4;
                                                                boolValuesCounter++;
                                                            }
            
            | TOK_IDENTIFIER '=' exp            {
                                                    // Hay que definir una funcion que check q no hay duplicados en los inserts
                                                    // Hay que hacer un nested for para buscar las diferentes variables por cada tipo hasta conseguir la variable
                                                    int varIndex = getVarIndex($1);
                                                    if(varIndex != -1)
                                                    {
                                                        strcpy(identifiers[varIndex], $1);
                                                        itoa($3, varValues[varIndex], 10);
                                                    }
                                                    else
                                                    {
                                                        yyerror("Var hasn't been initialized!");
                                                        exit(0);
                                                    }
           										}
		   ;
exp    	: term                  {$$ = $1;}
       	| exp TOK_SUM_OP term          {$$ = $1 + $3;}
       	| exp TOK_MINUS_OP term          {$$ = $1 - $3;}
	    | exp TOK_MULT_OP term          {$$ = $1 * $3;}
	    | exp TOK_DIV_OP term          {$$ = $1 / $3;} 
        | '(' exp ')'                       {$$ = $2;}
        
       	;
term   	: TOK_INTEGER_LIT                {$$ = $1;}
		| TOK_IDENTIFIER		{int varValue = findVal($1);
								 if(varValue == -1){
								 	yyerror("Var doesn't exist!");
           							exit(0);
								 }
								 else
								 	$$ = varValue;}
									
        ;
%%


int main(int argc, char **argv)
{
	++argv, --argc;
	if (argc > 0)
		yyin = fopen(argv[0], "r");
	else
		yyin = stdin;
	yyparse();
	return 0;
}

int yyerror(char *message)
{
    extern FILE *yyout;
    fprintf(yyout,"\nError at line %5d. (%s) \n", yylexlinenum,message);
}


// 0 INT
// 1 CHAR
// 2 FLOAT
// 3 STRING
// 4 BOOL
dataTypes whichType(char* identifier)
{
	for(int i=0; i<50; i++) {
        for(int j=0; j<5; j++) 
        {
            if(strcmp(identifiers[i][j], identifier) == 0)
            {
                if(j == 0)
                    return INTEGER;
                else if(j == 1)
                    return CHAR;
                else if(j == 2)
                    return FLOAT;
                else if(j == 3)
                    return STRING;
                else if(j == 4)
                    return BOOL;
            }
        }
	}
}
int whichType(char* identifier)
{
	for(int i=0; i<50; i++) {
        for(int j=0; j<5; j++) 
        {
            if(strcmp(identifiers[i][j], identifier) == 0)
            {
                if(j == 0)
                    return INTEGER;
                else if(j == 1)
                    return CHAR;
                else if(j == 2)
                    return FLOAT;
                else if(j == 3)
                    return STRING;
                else if(j == 4)
                    return BOOL;
            }
        }
	}
}