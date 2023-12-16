%{
  import java.io.*;
%}

%token NL;              /* newline */
%token <sval> SKIP;
%token <sval> ERR;

%%

input   : /* empty string */
        | input line
        ;

line    : NL            { System.out.print("line: "); }
        | exp NL
        ;

exp     : val
        | parens val
        | parens
        | exp parens
        ;

val     : SKIP          { successLog($1); }
        | ERR           { successLog("Err: "+$1); }
        ;

parens  : '(' exp ')'
        | '(' ')'
        | '[' exp ']'
        | '[' ']'
        ;

%%

private Yylex lexer;

private int yylex () {
    int yyl_return = -1;

    try {
        yylval = new ParserVal(0);
        yyl_return = lexer.yylex();
    }

    catch (IOException e) {
        System.err.println("IO error :"+e);
    }

    return yyl_return;
}

public void yyerror (String error) {
    System.err.println ("Error: " + error);
}

public Parser(Reader r) {
    lexer = new Yylex(r, this);
}

public void successLog(String s) {
    System.out.println("\033[1;36m"+s+"\033[0m\033[K");
}

public static void main(String args[]) throws IOException {
    System.out.println("Laboratorio 2 - Consegna 1");
    Parser yyparser;
    
    System.out.println("[Quit with CTRL-D]");

    yyparser = new Parser(new InputStreamReader(System.in));

    yyparser.yyparse();
    
    System.out.println("\nTerminated.");
}
