%option noyywrap

%{
#include <stdio.h>
#include <stdlib.h>

FILE *yyin, *outfile;
%}

%%
"hey"                   { printf("Line %d: Keyword: hey\n", yylineno ); }
"bye"|"done"            { printf("Line %d: Keyword: bye|done\n" , yylineno); }
"ask"                   { printf("Line %d: Keyword: ask\n", yylineno); }
"tell"                  { printf("Line %d: Keyword: tell\n", yylineno); }
"if"                    { printf("Line %d: Keyword: if\n", yylineno); }
"then"                  { printf("Line %d: Keyword: then\n", yylineno); }
"loop"                  { printf("Line %d: Keyword: loop\n", yylineno); }
"counton"               { printf("Line %d: Keyword: counton\n", yylineno); }
"stopit"                { printf("Line %d: Keyword: stopit\n", yylineno); }
"ping"                  { printf("Line %d: Keyword: ping\n", yylineno); }
"returnit"              { printf("Line %d: Keyword: returnit\n", yylineno); }
"otherwise"             { printf("Line %d: Keyword: otherwise\n", yylineno); }        


"whole"                 { printf("Line %d: Type: whole (int)\n", yylineno); }
"pointy"                { printf("Line %d: Type: pointy (float)\n", yylineno); }
"word"                  { printf("Line %d: Type: word (string)\n", yylineno); }
"logic"                 { printf("Line %d: Type: logic (boolean)\n", yylineno); }

"->"                     { printf("Line %d: output arrow: %s\n", yylineno, yytext); }
[+|-]?[0-9]+                  { printf("Line %d: Whole: %s\n", yylineno, yytext); }
[+|-]?[0-9]*[.][0-9]+         { printf("Line %d: Pointy: %s\n", yylineno, yytext); }
"truthy"                   { printf("Line %d: Logic: %s\n", yylineno, yytext); }
"falsy"                    { printf("Line %d: Logic: %s\n", yylineno, yytext); }
\"([^\\\"\n])*\"     { printf("Line %d: Word: %s\n", yylineno, yytext); }

"+"|"-"|"*"|"/"|"++"|"--"|"+="|"-="|"=-"|"=+"         { printf("Line %d: Operator: %s\n", yylineno, yytext); }
"="                     { printf("Line %d: Operator: %s\n", yylineno, yytext); }
"==="|"!=="|"<="|"=>"|"<<"|">>"|"<"|">" { printf("Line %d: Relational OP: %s\n", yylineno, yytext); }
"&&&"               { printf("Line %d: And Operator: %s\n", yylineno, yytext); }
"||"               { printf("Line %d: OR Operator: %s\n", yylineno, yytext); }


")"|"}"|"]"            { printf("Line %d: Right Parenthesis: %s\n", yylineno,yytext); }
"("|"{"|"["            { printf("Line %d: Left Parenthesis: %s\n", yylineno,yytext); }
";"|","|":"            { printf("Line %d: Delimeters: %s\n", yylineno, yytext); }
"//".*                  { /* Ignore single-line comments */ }
"/\*([^*]|\*[^/])*\*/"   { /* Ignore multi-line comments */ }
[ \t\r\n]+              { /* Skip whitespace */ }

[A-Za-z_@][A-Za-z0-9_]*  { printf("Line %d: Identifier: %s\n", yylineno, yytext); }


[0-9][A-Za-z0-9_@]+        { printf("Line %d: Invalid Token: %s\n", yylineno, yytext); }
"+-"|"-+"|"=="               { printf("Line %d: Invalid Token: %s\n", yylineno, yytext); }


.                       { printf("Unknown: %s\n", yytext); }
%%


int main(int argc, char** argv) {
    if (argc < 3) {
        fprintf(stderr, "Usage: %s <input_file> <output_file>\n", argv[0]);
        return 1;
    }

    yyin = fopen(argv[1], "r");
    if (!yyin) {
        fprintf(stderr, "Error opening input file: %s\n", argv[1]);
        return 1;
    }

    outfile = fopen(argv[2], "w");
    if (!outfile) {
        fprintf(stderr, "Error opening output file: %s\n", argv[2]);
        return 1;
    }

    yylex();  

    fclose(yyin);
    fclose(outfile);

    printf(" Tokens written to %s\n", argv[2]);
    return 0;
}
