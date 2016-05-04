%{

#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>

#define ALPHABET 26

int yylex(void);
void yyerror(char *);

int variables[ALPHABET*2] = {0};
#define ACCESS(v) variables[islower(v) ? v - 'a' : ALPHABET + v - 'A']

%}

%union {
	char v;
	int num;
}

%token <v> VARIABLE
%token <num> INTEGER

%token PLUS
%token MINUS
%token MULT
%token DIV

%token ASSIGN

%token LPARENT
%token RPARENT

%token LINEFEED

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
	expression LINEFEED						{ printf("%d\n", $1); }
|	var LINEFEED							{ printf("%c = %d\n", $1, ACCESS($1)); }
|	LINEFEED
;

expression:
	var ASSIGN expression					{ $$ = $3; ACCESS($1) = $3; }
|	expression PLUS  mults					{ $$ = $1 + $3; }
|	expression MINUS mults					{ $$ = $1 - $3; }
|	mults									{ $$ = $1; }
;

mults:
	mults MULT term							{ $$ = $1 * $3; }
|	mults DIV term							{ $$ = $1 / $3; }
|	term									{ $$ = $1; }
;

term:
	PLUS term								{ $$ = $2; }
|	MINUS term								{ $$ = -$2; }
|	LPARENT expression RPARENT				{ $$ = $2; }
|	number									{ $$ = $1; }
;

number:
	INTEGER
|	var										{ $$ = ACCESS($1); }
;

var:
	VARIABLE								{ $$ = $1; }
;

%%

void yyerror(char *s){
	fprintf(stderr, "%s\n", s);
	return;
}

int main(int argc, char *argv[]){
	yyparse();
	return EXIT_SUCCESS;
}
