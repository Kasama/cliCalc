%{

#include <stdlib.h>
#include <stdio.h>
#include <float.h>
#include <ctype.h>

#define ALPHABET 26

int yylex(void);
void yyerror(char *);

double variables[ALPHABET*2] = {0};
#define ACCESS(v) variables[islower(v) ? v - 'a' : ALPHABET + v - 'A']
int yydebug = 1;

#define PROMPT ">> "
#define DRAW_PROMPT printf("%s", PROMPT)

%}

%union {
	char v;
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
	EXIT_CODE LINEFEED						{ printf("bye\n"); exit(EXIT_SUCCESS); }
|	IDENTIFIER ASSIGN expression LINEFEED	{ ACCESS($1) = $3; DRAW_PROMPT; }
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
	IDENTIFIER								{ $$ = ACCESS($1); }
;

%%

void yyerror(char *s){
	fprintf(stderr, "%s\n", s);
	return;
}

int main(int argc, char *argv[]){
	DRAW_PROMPT;
	yyparse();
	return EXIT_SUCCESS;
}
