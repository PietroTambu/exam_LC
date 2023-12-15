%%
%class Search
%standalone
%%
(a|b)*aab   { System . out . println (" Pattern trovato: " + yytext()); }
\n          { /* non fare niente */ }
.           { /* non fare niente */ }