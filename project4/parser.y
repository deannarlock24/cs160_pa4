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

%type <program_ptr> Start

%type <identifier_ptr> ID
%type <integerliteral_ptr> LITERAL
%type <booleanliteral_ptr> TRUE FALSE


%type <class_list_ptr> Classlst
%type <class_ptr> Class MembersMethodsLst


%type <declaration_list_ptr> Members MethodDeclarations
%type <method_list_ptr> Methods
%type <method_ptr> Method
%type <parameter_list_ptr> Parameters
%type <type_ptr> Type
%type <methodbody_ptr> MethodDeclarationsStatementsReturn
%type <statement_list_ptr> MethodStatements
%type <statement_ptr> MethodStatement
%type <returnstatement_ptr> ReturnStatement
%type <parameter_ptr> Parameter
%type <declaration_ptr> MethodDeclaration Member
%type <declaration_ptr> Declaration
%type <expression_ptr> Expression
%type <assignment_ptr> Assignment
%type <call_ptr> Call
%type <methodcall_ptr> MethodCall
%type <ifelse_ptr> IfElse
%type <while_ptr> WhileLoop
%type <dowhile_ptr> DoWhileLoop
%type <print_ptr> Print
%type <expression_list_ptr> Arguments ArgumentLst




%%

/* WRITEME: This rule is a placeholder. Replace it with your grammar
            rules from Project 3 */


Start : Classlst {$$ = new ProgramNode($1);}
      ;

Classlst : Classlst Class {$$ = $1; $$->push_back($2);}
         | Class {$$ = new std::list<ClassNode*>; $$->push_back($1);}
;

Class: ID LB MembersMethodsLst RB {$$ = $3; $$->identifier_1 = $1; $$->identifier_2 = NULL;}
     | ID EXTENDS ID LB MembersMethodsLst RB {$$ = $5; $$->identifier_1 = $1; $$->identifier_2 = $3;}
;

MembersMethodsLst: Members {$$ = new ClassNode(NULL, NULL, $1, NULL);}
                 | Methods {$$ = new ClassNode(NULL, NULL, NULL, $1);}
                 | Members Methods {$$ = new ClassNode(NULL, NULL, $1, $2);}
                 | /* empty */ {$$ = new ClassNode(NULL, NULL, NULL, NULL);}
;

Members: Members Member {$$ = $1; $$->push_back($2);}
       | Member {$$ = new std::list<DeclarationNode*>; $$->push_back($1);}
;

Methods: Methods Method {$$ = $1; $$->push_back($2);}
       | Method {$$ = new std::list<MethodNode*>; $$->push_back($1);}
;

Member: Type ID SEMI {$$ = new DeclarationNode(NULL, NULL); $$->type = $1; $$->identifier_list->push_back($2);}
;

Method: ID LP Parameters RP FUNCTION Type LB MethodDeclarationsStatementsReturn RB {$$ = new MethodNode($1, $3, $6, $8);}
;



Type: INT {$$ = new IntegerTypeNode;}
    | BOOL {$$ = new BooleanTypeNode;}
    | ID {$$ = new ObjectTypeNode($1);}
    | NONE {$$ = new NoneNode;}
;

ParametersList: Parameters Parameter 
          | Parameter {$$ = new std::list<ParameterNode*>; $$->push_back($1);}
          | /* empty */ {$$ = new std::list<ParameterNode*>;}
;

Parameters: Parameters Parameter COMMA{$$ = $1; $$->push_back($2);}
          | /* empty */ {$$ = new std::list<ParameterNode*>;}


Parameter: Type ID {$$ = new ParameterNode($1, $2);}
;

MethodDeclarationsStatementsReturn: MethodDeclarations ReturnStatement {$$ = new MethodBodyNode($1, NULL, $2);}
                            | MethodStatements ReturnStatement {$$ = new MethodBodyNode(NULL, $1, $2);}
                            | MethodDeclarations MethodStatements ReturnStatement {$$ = new MethodBodyNode($1, $2, $3);}
                            | /* empty */ {$$ = new MethodBodyNode(NULL, NULL, NULL); }
;

MethodDeclarations: MethodDeclarations MethodDeclaration {$$ = $1; $$->push_back($2);}
                  | MethodDeclaration {$$ = new std::list<DeclarationNode*>; $$->push_back($1);}
;

MethodDeclaration: Type Declaration SEMI {$$ = $2; $$->type = $1}
;

Declaration: Declaration COMMA ID {$$ = $1; $$->identifier_list->push_back($3);}
            | ID {$$ = new DeclarationNode(NULL, NULL); $$->identifier_list = new std::list<IdentifierNode*>; $$->identifier_list->push_back($1);}
;

MethodStatements: MethodStatements MethodStatement {$$ = $1; $$->push_back($2);}
                | MethodStatement {$$ = new std::list<StatementNode*>; $$->push_back($1);}
;

MethodStatement: Assignment SEMI {$$ = $1;}
               | Call SEMI {$$ = $1;}
               | IfElse {$$ = $1;}
               | WhileLoop {$$ = $1;}
               | DoWhileLoop {$$ = $1;}
               | Print {$$ = $1;}
;

Assignment: ID ASSIGN Expression {$$ = new AssignmentNode($1, NULL, $3);}
          | ID DOT ID ASSIGN Expression {$$ = new AssignmentNode($1, $3, $5);}
;

Call: ID LP Arguments RP {$$ = new CallNode(new MethodCallNode($1, NULL, $3));}
    | MethodCall {$$ = new CallNode($1);}


MethodCall: ID DOT ID LP Arguments RP {$$ = new MethodCallNode($1, $3, $5);}
;

Arguments: ArgumentLst {$$ = $1;}
         | /* empty */ {$$ = new std::list<ExpressionNode*>;}
;

ArgumentLst: ArgumentLst COMMA Expression {$$ = $1; $$->push_back($3);}
           | Expression {$$ = new std::list<ExpressionNode*>; $$->push_back($1);}
;


IfElse: IF Expression LB MethodStatements RB {$$ = new IfElseNode($2, $4, NULL);}
      | IF Expression LB MethodStatements RB ELSE LB MethodStatements RB {$$ = new IfElseNode($2, $4, $8);}
;

WhileLoop: WHILE Expression LB MethodStatements RB {$$ = new WhileNode($2, $4);}
;

DoWhileLoop: DO LB MethodStatements RB WHILE LP Expression RP SEMI {$$ = new DoWhileNode($3, $7);}
;

Print: PRINT Expression SEMI {$$ = new PrintNode($2);}
;


ReturnStatement: RETURN Expression SEMI {$$ = new ReturnStatementNode($2);}
               | /* empty */ {$$ = NULL;}
;

Expression: Expression PLUS Expression {$$ = new PlusNode($1, $3);}
          | Expression MINUS Expression {$$ = new MinusNode($1, $3);}
          | Expression MULT Expression {$$ = new TimesNode($1, $3);}
          | Expression DIV Expression {$$ = new DivideNode($1, $3);}
          | Expression GT Expression {$$ = new GreaterNode($1, $3);}
          | Expression GTE Expression {$$ = new GreaterEqualNode($1, $3);}
          | Expression EQ Expression {$$ = new EqualNode($1, $3);}
          | Expression AND Expression {$$ = new AndNode($1, $3);}
          | Expression OR Expression {$$ = new OrNode($1, $3);}
          | MINUS Expression %prec NOT {$$ = new NegationNode($2)}
          | NOT Expression {$$ = new NotNode($2)}
          | ID {$$ = new VariableNode($1);}
          | ID DOT ID {$$ = new MemberAccessNode($1, $3);}
          | MethodCall {$$ = $1;}
          | LP Expression RP {$$ = $2;}
          | LITERAL {$$ = new IntegerLiteralNode(*$1);}
          | TRUE {$$ = new BooleanLiteralNode(new IntegerNode(1));}
          | FALSE {$$ = new BooleanLiteralNode(new IntegerNode(0));}
          | NEW ID {$$ = new NewNode($2, NULL);}
          | NEW ID LP Arguments RP  {$$ = new NewNode($2, $4);}
;



%%

extern int yylineno;

void yyerror(const char *s) {
  fprintf(stderr, "%s at line %d\n", s, yylineno);
  exit(0);
}
