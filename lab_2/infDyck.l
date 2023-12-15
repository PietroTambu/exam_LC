
%%

%byaccj

%{
  /* store a reference to the parser object */
  private Parser yyparser;
  private int colonCount = 0;
  /* constructor taking an additional parser object */
  public Yylex(java.io.Reader r, Parser yyparser) {
    this(r);
    this.yyparser = yyparser;
  }
%}

%%

"("                   { yyparser.yylval = new ParserVal(""+yycharat(0));
                        return Parser.OPEN_PAREN; }
")"                   { yyparser.yylval = new ParserVal(""+yycharat(0));
                        return Parser.CLOSE_PAREN; }
[a-z]+               { yyparser.yylval = new ParserVal(yytext());
                        return Parser.SKIP; }
[A-Z]{2}[a-z]+        { yyparser.yylval = new ParserVal(yytext());
                        return Parser.SKIP; }
":"[a-z]+            { yyparser.yylval = new ParserVal(yytext());
                        return Parser.SKIP; }
":"[0-9]+            { yyparser.yylval = new ParserVal(yytext());
                        return Parser.SKIP; }
":"                  { colonCount++; return -1; /* Ignora i caratteri ':' */ }

\n                   { colonCount = 0; } /* Resetta il conteggio dei caratteri ':' alla fine di ogni riga */

.                    { /* Ignora altri caratteri non corrispondenti ai token definiti */ }

"("                   { yyparser.yylval = new ParserVal(""+yycharat(0));
                        return Parser.OPEN_PAREN; }
")"                   { yyparser.yylval = new ParserVal(""+yycharat(0));
                        return Parser.CLOSE_PAREN; }
[a-z]+            { yyparser.yylval = new ParserVal(yytext());
                        return Parser.SKIP; }

[^] {} /*butta il resto*/
