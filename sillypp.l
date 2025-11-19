
%{
#include <stdio.h>

FILE *yyin, *outfile;
%}

%option yylineno


%%
"hey"                   { fprintf(outfile, "Line %d: Keyword: hey\n", yylineno ); }
"bye"|"done"            { fprintf(outfile, "Line %d: Keyword: bye|done\n" , yylineno); }
"ask"                   { fprintf(outfile, "Line %d: Keyword: ask\n", yylineno); }
"tell"                  { fprintf(outfile, "Line %d: Keyword: tell\n", yylineno); }
"if"                    { fprintf(outfile, "Line %d: Keyword: if\n", yylineno); }
"then"                  { fprintf(outfile, "Line %d: Keyword: then\n", yylineno); }
"loop"                  { fprintf(outfile, "Line %d: Keyword: loop\n", yylineno); }
"counton"               { fprintf(outfile, "Line %d: Keyword: counton\n", yylineno); }
"stopit"                { fprintf(outfile, "Line %d: Keyword: stopit\n", yylineno); }
"ping"                  { fprintf(outfile, "Line %d: Keyword: ping\n", yylineno); }
"returnit"              { fprintf(outfile, "Line %d: Keyword: returnit\n", yylineno); }
"otherwise"             { fprintf(outfile, "Line %d: Keyword: otherwise\n", yylineno); }        


"whole"                 { fprintf(outfile, "Line %d: Type: whole (int)\n", yylineno); }
"pointy"                { fprintf(outfile, "Line %d: Type: pointy (float)\n", yylineno); }
"word"                  { fprintf(outfile, "Line %d: Type: word (string)\n", yylineno); }
"logic"                 { fprintf(outfile, "Line %d: Type: logic (boolean)\n", yylineno); }

"->"                     { fprintf(outfile, "Line %d: output arrow: %s\n", yylineno, yytext); }
[+|-]?[0-9]+                  { fprintf(outfile, "Line %d: Whole: %s\n", yylineno, yytext); }
[+|-]?[0-9]*[.][0-9]+         { fprintf(outfile, "Line %d: Pointy: %s\n", yylineno, yytext); }
"truthy"                   { fprintf(outfile, "Line %d: Logic: %s\n", yylineno, yytext); }
"falsy"                    { fprintf(outfile, "Line %d: Logic: %s\n", yylineno, yytext); }
\"([^\\\"\n])*\"     { fprintf(outfile, "Line %d: Word: %s\n", yylineno, yytext); }

"+"|"-"|"*"|"/"|"++"|"--"|"+="|"-="|"=-"|"=+"         { fprintf(outfile, "Line %d: Operator: %s\n", yylineno, yytext); }
"="                     { fprintf(outfile, "Line %d: Operator: %s\n", yylineno, yytext); }
"==="|"!=="|"<="|"=>"|"<<"|">>"|"<"|">" { fprintf(outfile, "Line %d: Relational OP: %s\n", yylineno, yytext); }
"&&&"               { fprintf(outfile, "Line %d: And Operator: %s\n", yylineno, yytext); }
"||"               { fprintf(outfile, "Line %d: OR Operator: %s\n", yylineno, yytext); }


")"|"}"|"]"            { fprintf(outfile, "Line %d: Right Parenthesis: %s\n", yylineno,yytext); }
"("|"{"|"["            { fprintf(outfile, "Line %d: Left Parenthesis: %s\n", yylineno,yytext); }
";"|","|":"            { fprintf(outfile, "Line %d: Delimeters: %s\n", yylineno, yytext); }
"//".*                  { /* Ignore single-line comments */ }
"/\*([^*]|\*[^/])*\*/"   { /* Ignore multi-line comments */ }

[ \t\r]+         { /* Ignore spaces, tabs, carriage return */ }
\n               { /* Newline: let yylineno increment automatically */ }


[A-Za-z_@][A-Za-z0-9_]*  { fprintf(outfile, "Line %d: Identifier: %s\n", yylineno, yytext); }


[0-9][A-Za-z0-9_@]+        { fprintf(outfile, "Line %d: Invalid Token: %s\n", yylineno, yytext); }
"+-"|"-+"|"=="               { fprintf(outfile, "Line %d: Invalid Token: %s\n", yylineno, yytext); }


.                       { fprintf(outfile, "Unknown: %s\n", yytext); }
%%


int main(void) {
    yyin = fopen("input.txt", "r");
    if (!yyin) {
        perror("input.txt");
        return 1;
    }

    outfile = fopen("output.txt", "w");
    if (!outfile) {
        perror("output.txt");
        fclose(yyin);
        return 1;
    }

    yylex();

    fclose(yyin);
    fclose(outfile);
    return 0;
}
