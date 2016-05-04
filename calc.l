%{
	#include "y.tab.h"
	#include <stdlib.h>
	#include <stdio.h>
	void yyerror(char*);
%}

%%
[ \t]+											{ ; }
"exit"											{ return EXIT_CODE; }
(([0-9]+(\.[0-9]*)?)|([0-9]*\.[0-9]+))			{ yylval.num = atof(yytext); return DOUBLE; }
[a-zA-Z]										{ yylval.v = *yytext; return IDENTIFIER; }
"+"												{ return PLUS; }
"-"												{ return MINUS; }
"*"												{ return MULT; }
"/"												{ return DIV; }
[\(\{\[]										{ return LPARENT; }
[\)\}\]]										{ return RPARENT; }
"="												{ return ASSIGN; }
\n												{ return LINEFEED; }
.												{ 
	char msg[25];
	sprintf(msg, "%s <%s>", "invalid character", yytext);
	yyerror(msg);
}
