
%%

%byaccj

%{
  /* store a reference to the parser object */
  private Parser yyparser;

  /* constructor taking an additional parser object */
  public Yylex(java.io.Reader r, Parser yyparser) {
    this(r);
    this.yyparser = yyparser;
  }
%}

NL  = \n | \r | \r\n

%%

/* parentheses */
"[" |
"]" |
"(" | 
")"    { return (int) yycharat(0); }

/* newline */
{NL}   { return Parser.NL; }

.*894628.*      {
                  yyparser.yylval = new ParserVal("894628");
                  return Parser.SKIP;
                }

[a-z]+          {
                  yyparser.yylval = new ParserVal(yytext());
                  return Parser.SKIP;
                }

[A-Z]{2}[a-z]+  {
                  String text = yytext();
                  yyparser.yylval = new ParserVal(text.substring(2));
                  return yycharat(0) == yycharat(1) ? Parser.SKIP: Parser.ERR;
                }

:+[a-z]+        {
                  String text = yytext();
                  int colonCount = text.length() - text.replace(":", "").length();
                  String result = colonCount % 2 == 0 ? text.replace(":", "") : ":" + text.replace(":", "");
                  yyparser.yylval = new ParserVal(result);
                  return Parser.SKIP;
                }

/* ignore */
[^]             {}
