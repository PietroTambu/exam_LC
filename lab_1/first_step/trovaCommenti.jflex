%%

%class TrovaCommenti
%standalone
%state COMMENTO

INIZIOCOMMENTO = "/*"
FINECOMMENTO = "*/"

%%

<YYINITIAL> {
    {INIZIOCOMMENTO} { yybegin(COMMENTO); }
    [^] {}
}

<COMMENTO> {
    .* {FINECOMMENTO} {
        System.out.println("Trovato commento: " + yytext().substring(0, yylength() - 2));
        yybegin(YYINITIAL);
    }
}