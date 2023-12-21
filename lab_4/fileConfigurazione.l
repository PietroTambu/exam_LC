/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * Author: Pietro Tamburini 2023                                           *
 *                                                                         *
 * GitHub repository: https://github.com/PietroTambu/exam_LC               *
 *                                                                         *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
%%

%byaccj

%{
    private Parser yyparser;

    public Yylex(java.io.Reader r, Parser yyparser) {
        this(r);
        this.yyparser = yyparser;
    }
%}

%x IN_GROUP IN_PROPERTY

NL  = \n | \r | \r\n

GROUP_NAME = [a-zA-Z0-9\-_]+
GROUP_OPEN = (:[ \t]*\{)
GROUP_CLOSE = "\};"

PROPERTY_NAME = [a-zA-Z0-9\-_ \t]+
PROPERTY_SEPARATOR = (:[ \t]*)
PROPERTY_VALUE = [^;\n]+

%%

<YYINITIAL,IN_GROUP,IN_PROPERTY>{NL} { return Parser.NL; }

{GROUP_NAME} { 
    yyparser.yylval = new ParserVal(yytext()); 
    return Parser.GROUP_NAME; 
}

{GROUP_OPEN} { 
    yybegin(IN_GROUP); 
    return Parser.GROUP_OPEN; 
}

<IN_GROUP>{GROUP_CLOSE} {
    yybegin(YYINITIAL);
    return Parser.GROUP_CLOSE;
}

<IN_GROUP>{PROPERTY_NAME} { 
    yyparser.yylval = new ParserVal(yytext()); 
    return Parser.PROPERTY_NAME; 
}

<IN_GROUP>{PROPERTY_SEPARATOR} {
    yybegin(IN_PROPERTY); 
    return Parser.PROPERTY_SEPARATOR; 
}

<IN_PROPERTY>{PROPERTY_VALUE} { 
    yyparser.yylval = new ParserVal(yytext()); 
    yybegin(IN_GROUP); 
    return Parser.PROPERTY_VALUE; 
}

[ \t]+ { }

\b { System.err.println("Sorry, backspace doesn't work"); }

[^] { System.err.println("error: unexpected character" + yytext()); return -1;}

