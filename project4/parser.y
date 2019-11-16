%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <iostream>

    #include "ast.hpp"
    
    #define YYDEBUG 1
    int yylex(void);
    void yyerror(const char *);
    
    extern ASTNode* astRoot;
%}

%error-verbose

/* WRITEME: Copy your token and precedence specifiers from Project 3 here */

%token FALSE
%token RETURN
%token NEW
%token INT
%token BOOL
%token NONE
%token EXTENDS
%token REPEAT
%token TRUE
%token IF
%token ELSE
%token NOT
%token EQ
%token AND
%token OR
%token WHILE
%token DO
%token FOR
%token PRINT
%token ASSIGN
%token GT
%token GTE
%token LITERAL
%token ID
%token LB
%token RB
%token DOT
%token FUNCTION
%token LP
%token RP
%token COMMA
%token SEMI
%token PLUS
%token MINUS
%token MULT
%token DIV


%left OR
%left AND
%left GT GTE EQ
%left PLUS MINUS
%left MULT DIV
%right NOT


/* WRITEME: Specify types for all nonterminals and necessary terminals here */

%%

/* WRITEME: This rule is a placeholder. Replace it with your grammar
            rules from Project 3 */


Start : Classlst
      ;

Classlst : Classlst Class
         | Class
;

Class: ID LB MembersMethodsLst RB
     | ID EXTENDS ID LB MembersMethodsLst RB
;

MembersMethodsLst: Members
                 | Methods
                 | Members Methods
                 | %empty
;

Members: Members Member
       | Member
;

Methods: Methods Method
       | Method
;

Member: Type ID SEMI
;

Method: ID LP Parameters RP FUNCTION Type LB MethodDeclarationsStatements ReturnStatement RB
;

Type: INT
    | BOOL
    | ID
    | NONE
;

Parameters: Parameters Parameter
          | %empty
;

Parameter: Type ID
         | Type ID COMMA Parameter
;

MethodDeclarationsStatements: MethodDeclarations
                            | MethodStatements
                            | MethodDeclarations MethodStatements
                            | %empty
;

MethodDeclarations: MethodDeclarations MethodDeclaration
                  | MethodDeclaration
;

MethodDeclaration: Type Declaration SEMI
;

Declaration: Declaration COMMA ID
            | ID
;

MethodStatements: MethodStatements MethodStatement
                | MethodStatement
;

MethodStatement: Assignment SEMI
               | Call SEMI
               | IfElse
               | WhileLoop
               | DoWhileLoop
               | Print
;

Assignment: ID ASSIGN Expression
          | ID DOT ID ASSIGN Expression
;

Call: ID LP Arguments RP
    | ID DOT ID LP Arguments RP
;

Arguments: ArgumentLst
         | %empty
;

ArgumentLst: ArgumentLst COMMA Expression
           | Expression
;


IfElse: IF Expression LB MethodStatements RB
      | IF Expression LB MethodStatements RB ELSE LB MethodStatements RB
;

WhileLoop: WHILE Expression LB MethodStatements RB
;

DoWhileLoop: DO LB MethodStatements RB WHILE LP Expression RP SEMI
;

Print: PRINT Expression SEMI
;


ReturnStatement: RETURN Expression SEMI
               | %empty
;

Expression: Expression PLUS Expression
          | Expression MINUS Expression
          | Expression MULT Expression
          | Expression DIV Expression
          | Expression GT Expression
          | Expression GTE Expression
          | Expression EQ Expression
          | Expression AND Expression
          | Expression OR Expression
          | MINUS Expression %prec NOT
          | NOT Expression
          | ID
          | ID DOT ID
          | Call
          | LP Expression RP
          | LITERAL
          | TRUE
          | FALSE
          | NEW ID
          | NEW ID LP Arguments RP
;



%%

extern int yylineno;

void yyerror(const char *s) {
  fprintf(stderr, "%s at line %d\n", s, yylineno);
  exit(0);
}
