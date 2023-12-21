%{
    import java.io.*;
%}

%token NL /* newline */
%token GROUP_OPEN GROUP_CLOSE INDENT PROPERTY_SEPARATOR
%token<sval> GROUP_NAME PROPERTY_NAME PROPERTY_VALUE
%type<sval> groups group line properties property

%%

config      : groups { System.out.print($1); }

groups      : group { $$ = $1; }
            | group groups { $$ = $1 + $2; }
            ;

group       : GROUP_NAME GROUP_OPEN line properties GROUP_CLOSE line { $$ = "[" + $1 + "]" + $3 + $4 + $6; }

line        : NL { $$ = System.lineSeparator(); }
            | line NL { $$ = $1 + System.lineSeparator(); }
            ;

properties  : property line { $$ = $1 + $2; }
            | property line properties { $$ = $1 + $2 + $3; }
            ;

property    : PROPERTY_NAME PROPERTY_SEPARATOR PROPERTY_VALUE { $$ = $1.trim() + "=" + $3; }
            ;

%%

private Yylex lexer;

private int yylex () {
    int yyl_return = -1;
    try {
        yylval = new ParserVal(0);
        yyl_return = lexer.yylex();
    } catch (IOException e) {
        System.err.println("IO error: " + e);
    }
    return yyl_return;
}

public void yyerror (String error) {
    System.err.println("Error: " + error);
}

public Parser(Reader r) {
    lexer = new Yylex(r, this);
}

public static void main(String args[]) throws IOException {
    Parser yyparser;
    if (args.length > 0) {
        yyparser = new Parser(new FileReader(args[0]));
        yyparser.yyparse();
    } else {
        System.out.println("Error: you need to provide a file as argument");
    }
}
