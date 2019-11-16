%option yylineno
%pointer

%{
    #include <stdlib.h>
    #include <errno.h>
    #include <limits.h>
    #include "ast.hpp"
    #include "parser.hpp"
    void yyerror(const char *);
%}

/* WRITEME: Copy any definitions and start conditions from Project 3 here */

%x COMMENT
%s INIT

%%

<COMMENT>[^*\n]*

<COMMENT>"*"+[^*/\n]*
<COMMENT>\n
<COMMENT>"*"+"/" BEGIN(INIT);
<COMMENT><<EOF>> {yyerror("EOF inside Comment");}


  /* WRITEME: Copy your Flex rules from Project 3 here */


[ \n\t]+ 
"false" {return FALSE;}
"return" {return RETURN;}
"new" {return NEW;}
"integer" {return INT;}
"boolean" {return BOOL;}
"none" {return NONE;}
"extends" {return EXTENDS;}
"do" {return DO;}
"true" {return TRUE;}
"if" {return IF;}
"else" {return ELSE;}
"not" {return NOT;}
"equals" {return EQ;}
"and" {return AND;}
"or" {return OR;}
"while" {return WHILE;}
"do" {return DO;}
"for" {return FOR;}
"print" {return PRINT;}
"=" {return ASSIGN;}
">" {return GT;}
">=" {return GTE;}
[1-9][0-9]*|0 {return LITERAL;}
[a-z][a-z0-9]* {return ID;}

"{" {return LB;}
"}" {return RB;}
"." {return DOT;}
"->" {return FUNCTION;}
"(" {return LP;}
")" {return RP;}
"," {return COMMA;}
";" {return SEMI;}
"+" {return PLUS;}
"-" {return MINUS;}
"*" {return MULT;}
"/" {return DIV;}



.                 { yyerror("invalid character"); }

%%

int yywrap(void) {
  return 1;
}
