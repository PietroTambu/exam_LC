%%

%class ContaLinee
%standalone

%{
int linee = 1;
%}

LINEA = .*\n

%%

{LINEA} {
    System.out.print("Nuova linea trovata : " + yytext());
    System.out.println("Numero linea : " + linee);
    linee ++;
}