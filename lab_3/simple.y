%{
  import java.io.*;
%}

/*=========================================================================
TOKENS
=========================================================================*/
%start program
%token <ival> NUMBER /* Simple integer */
%token <ival> IDENTIFIER /* Simple identifier */
%token <ival> IF WHILE /* For backpatching labels */
%token SKIP THEN ELSE FI DO END DONE AND
%token READ WRITE BEGIN DUAL
%token ASSGNOP

/*=========================================================================
OPERATOR PRECEDENCE
=========================================================================*/
%left '-' '+'
%left '*' '/'

/*=========================================================================
GRAMMAR RULES for the Simple language
=========================================================================*/
%type <ival> ifThen

%%
program     : BEGIN { gen_code( I.DATA, 10 ); mark_blank(); }
              commands
              END { gen_code( I.HALT, -99 ); mark_blank(); }
            ;

commands    : /* empty */
            | commands command ';' {mark_blank();}
            ;

ifThen      : IF exp { $1 = reserve_loc(); mark_blank(); }
              THEN commands { $$ = $1; }
            ;

command     : SKIP
            | READ  IDENTIFIER { gen_code( I.READ_INT,  -99 ); gen_code( I.STORE,  $2 ); }
            | WRITE exp        { gen_code( I.WRITE_INT, -99  ); }
            | IDENTIFIER ASSGNOP exp { gen_code( I.STORE, $1 ); }
            | IDENTIFIER IDENTIFIER DUAL exp {
                gen_code( I.STORE, $1 );
                gen_code( I.LD_VAR, $1 );
                gen_code( I.STORE, $2 );
              }
            | ifThen
              FI { back_patch( $1, I.JMP_FALSE, gen_label() ); }
            | ifThen
              ELSE { $1 += 1000*reserve_loc(); mark_blank(); back_patch( $1%1000, I.JMP_FALSE, gen_label() ); }
              commands
              FI   { back_patch( (int)$1/1000, I.GOTO, gen_label() ); }
            | WHILE { $1 = 1000*gen_label(); }
              exp { $1 += reserve_loc(); mark_blank(); }
              DO
              commands
              DONE { gen_code( I.GOTO, (int)$1/1000 ); back_patch( $1%1000, I.JMP_FALSE, gen_label() ); }
            ;

exp         : NUMBER { gen_code( I.LD_INT, $1 ); }
            | IDENTIFIER { gen_code( I.LD_VAR, $1 ); }
            | exp '<' exp { gen_code( I.LT, -99 ); }
            | exp '=' exp { gen_code( I.EQ, -99 ); }
            | exp '>' exp { gen_code( I.GT, -99 ); }
            | exp '+' exp { gen_code( I.ADD, -99 ); }
            | exp '-' exp { gen_code( I.SUB, -99 ); }
            | exp '*' exp { gen_code( I.MULT, -99 ); }
            | exp '/' exp { gen_code( I.DIV, -99 ); }
            | exp AND exp { gen_code( I.MULT, -99); }
            | '(' exp ')'
            ;

%%

public enum I {
  HALT, STORE, JMP_FALSE, GOTO,
  DATA, LD_INT, LD_VAR,
  READ_INT, WRITE_INT,
  LT, EQ, GT, ADD, SUB, MULT, DIV
};

void yyerror(String s) {
  System.out.println("err:"+s);
  System.out.println("   :"+yylval.sval);
}

static Yylex lexer;
int yylex() {
  try {
    return lexer.yylex();
  }
  catch (IOException e) {
    System.err.println("IO error :"+e);
    return -1;
  }
}

public static void main(String args[]) {
  //System.out.println("[Quit with CTRL-D]");
  Parser par = new Parser();
  lexer = new Yylex(new InputStreamReader(System.in), par);
  par.yyparse();
  print_code();
}

private static String text(I istr) {
  String names[]= { "HALT", "STORE", "JMP_FALSE", "GOTO",
    "DATA", "LD_INT", "LD_VAR",
    "READ_INT", "WRITE_INT",
    "LT", "EQ", "GT", "ADD", "SUB", "MULT", "DIV"
  };
  return ""+istr.ordinal()+"/"+names[istr.ordinal()];
}

private static I[] code_op= new I[999];
private static int[] code_arg= new int[999];
private static boolean[] code_mark= new boolean[999];
private static int stC =0;
public static void print_code() {
  I istr;
  int arg;
  int i;
  for (i=0;i<stC;++i) {
    istr=code_op[i];arg=code_arg[i];
    System.out.println(""+(i)+"-"+text(istr)+" "+arg);
    if(code_mark[i])System.out.println();
  }
}

public static void gen_code(I istr, int arg) {
  code_op[stC]=istr;code_arg[stC]=arg;
  stC++;//System.out.println(""+(stC++)+"-"+text(istr)+" "+arg);
}
public static void mark_blank() {
  code_mark[stC-1]=true;
}
public static int gen_label() {
  return stC;
}
public static int reserve_loc() {
  //System.out.println(""+(stC)+"-");
  return stC++;
}
public static void back_patch(int addr, I istr, int arg) {
  code_op[addr]=istr;code_arg[addr]=arg;
  //System.out.println(addr+":"+text(istr)+" "+arg);
}

/*=========================================================================
  symbol:   method gen_code(I,int)
  symbol:   method gen_label()
  symbol:   method reserve_loc()
  symbol:   method back_patch(int,I,int)
{ print_code ();
fetch_execute_cycle(); }
**************************** End Grammar File ***************************/
