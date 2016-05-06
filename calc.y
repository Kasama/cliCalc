%code {

#include <stdlib.h>
#include <stdio.h>
#include <float.h>
#include <ctype.h>

#define NVARS 50

int yylex(void);
void yyerror(char *);
void cleanup_and_exit(int);

int nvars = 0;
int nMalloc = 1;
double * variables = NULL;
char ** varNames = NULL;
int yydebug = 1;

#define PROMPT ">> "
#define DRAW_PROMPT printf("%s", PROMPT)

}

%code provides {
	int accessVariable(char *);
}

%union {
	int v;
	double num;
}

%token <v> IDENTIFIER
%token <num> DOUBLE

%token PLUS
%token MINUS
%token MULT
%token DIV

%token ASSIGN

%token LPARENT
%token RPARENT

%token LINEFEED

%token EXIT_CODE

%type <num> expression
%type <num> mults
%type <num> term
%type <num> number
%type <v> var

%%

program:
	line program
|	line
;

line:
	EXIT_CODE LINEFEED						{ printf("bye\n"); cleanup_and_exit(EXIT_SUCCESS); }
|	IDENTIFIER ASSIGN expression LINEFEED	{ variables[$1] = $3; DRAW_PROMPT; }
|	expression LINEFEED						{ printf("%lf\n%s", $1, PROMPT); }
|	LINEFEED								{ DRAW_PROMPT; }
|	error LINEFEED							{ yyerrok; DRAW_PROMPT; }
;

expression:
	expression PLUS  mults					{ $$ = $1 + $3; }
|	expression MINUS mults					{ $$ = $1 - $3; }
|	mults									{ $$ = $1; }
;

mults:
	mults MULT term							{ $$ = $1 * $3; }
|	mults DIV term							{ if ($3 != 0) $$ = $1 / $3; else { printf("Floating point exception: Division by zero\n"); $$ = DBL_MAX;} }
|	term									{ $$ = $1; }
;

term:
	PLUS term								{ $$ = $2; }
|	MINUS term								{ $$ = -$2; }
|	LPARENT expression RPARENT				{ $$ = $2; }
|	number									{ $$ = $1; }
;

number:
	DOUBLE
|	var										{ $$ = $1; }
;

var:
	IDENTIFIER								{ $$ = variables[$1]; }
;

%%

int accessVariable(char * name){

	int i = 0;
	int invar = 0;
	for (i = 0; i < nvars; i++){
		if (strcmp(name, varNames[i]) == 0)
			return i;
	}
	invar = nvars;
	varNames[invar] = strdup(name);
	variables[invar] = 0;
	nvars++;
	if (nvars >= NVARS * nMalloc){
		nMalloc++;
		varNames = realloc(varNames, sizeof(char *) * NVARS * nMalloc);
	}

	return invar;

}

void yyerror(char *s){
	fprintf(stderr, "%s\n", s);
	return;
}

void cleanup_and_exit(int exit_code){

	int i;
	free(variables);
	for (i = 0; i < nvars; i++){
		free(varNames[i]);
	}
	free(varNames);
	exit(exit_code);

}

int main(int argc, char *argv[]){
	variables = calloc(NVARS * nMalloc, sizeof(double *));
	varNames = calloc(NVARS * nMalloc, sizeof(char **));
	DRAW_PROMPT;
	yyparse();
	cleanup_and_exit(EXIT_SUCCESS);
	return EXIT_FAILURE;
}
