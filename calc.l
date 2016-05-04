%{
	#include "y.tab.h"
	#include <stdlib.h>
	#include <stdio.h>
	void yyerror(char*);
%}

%%
[ \t]+			{ ; }
[0-9]+			{ yylval.num = atoi(yytext); return INTEGER; }
"+"				{ return PLUS; }
"-"				{ return MINUS; }
"*"				{ return MULT; }
"/"				{ return DIV; }
"("				{ return LPARENT; }
")"				{ return RPARENT; }
"="				{ return ASSIGN; }
\n				{ return LINEFEED; }
[a-zA-Z]		{ yylval.v = *yytext; return VARIABLE; }
.				{ char msg[25]; sprintf(msg, "%s <%s>", "invalid character", yytext); yyerror(msg); }