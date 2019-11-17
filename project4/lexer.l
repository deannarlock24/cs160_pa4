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
"false" {yylval.base_char_ptr = strdup(yytext); return FALSE;}
"return" {yylval.base_char_ptr = strdup(yytext); return RETURN;}
"new" {yylval.base_char_ptr = strdup(yytext); return NEW;}
"integer" {yylval.base_char_ptr = strdup(yytext); return INT;}
"boolean" {yylval.base_char_ptr = strdup(yytext); return BOOL;}
"none" {yylval.base_char_ptr = strdup(yytext); return NONE;}
"extends" {yylval.base_char_ptr = strdup(yytext); return EXTENDS;}
"do" {yylval.base_char_ptr = strdup(yytext); return DO;}
"true" {yylval.base_char_ptr = strdup(yytext); return TRUE;}
"if" {yylval.base_char_ptr = strdup(yytext); return IF;}
"else" {yylval.base_char_ptr = strdup(yytext); return ELSE;}
"not" {yylval.base_char_ptr = strdup(yytext); return NOT;}
"equals" {yylval.base_char_ptr = strdup(yytext); return EQ;}
"and" {yylval.base_char_ptr = strdup(yytext); return AND;}
"or" {yylval.base_char_ptr = strdup(yytext); return OR;}
"while" {yylval.base_char_ptr = strdup(yytext); return WHILE;}
"do" {yylval.base_char_ptr = strdup(yytext); return DO;}
"for" {yylval.base_char_ptr = strdup(yytext); return FOR;}
"print" {yylval.base_char_ptr = strdup(yytext); return PRINT;}
"=" {yylval.base_char_ptr = strdup(yytext); return ASSIGN;}
">" {yylval.base_char_ptr = strdup(yytext); return GT;}
">=" {yylval.base_char_ptr = strdup(yytext); return GTE;}
[1-9][0-9]*|0 {yylval.base_int = atoi(yytext); return LITERAL;}
[a-z][a-z0-9]* {yylval.base_char_ptr = strdup(yytext); return ID;}

"{" {yylval.base_char_ptr = strdup(yytext); return LB;}
"}" {yylval.base_char_ptr = strdup(yytext); return RB;}
"." {yylval.base_char_ptr = strdup(yytext); return DOT;}
"->" {yylval.base_char_ptr = strdup(yytext); return FUNCTION;}
"(" {yylval.base_char_ptr = strdup(yytext); return LP;}
")" {yylval.base_char_ptr = strdup(yytext); return RP;}
"," {yylval.base_char_ptr = strdup(yytext); return COMMA;}
";" {yylval.base_char_ptr = strdup(yytext); return SEMI;}
"+" {yylval.base_char_ptr = strdup(yytext); return PLUS;}
"-" {yylval.base_char_ptr = strdup(yytext); return MINUS;}
"*" {yylval.base_char_ptr = strdup(yytext); return MULT;}
"/" {yylval.base_char_ptr = strdup(yytext); return DIV;}



.                 { yyerror("invalid character"); }

%%

int yywrap(void) {
  return 1;
}
