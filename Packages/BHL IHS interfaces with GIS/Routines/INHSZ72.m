INHSZ72 ;JSH; 29 Sep 93 11:42;Script Compiler - FILE command 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
FILE ;Process a FILE command
 I MULT!OTHER!FILEB D ERROR^INHSZ0("Cannot nest a FILE block.",1) Q
 N %1,F,V
 S %1=$$LBTB^UTIL($P(LINE,COMM,2,99)),F=$$LBTB^UTIL($P(%1,";")),V=$$LBTB^UTIL($P(%1,";",2))
 I F="" D ERROR^INHSZ0("File missing from FILE command.",1) Q
 I V="" D ERROR^INHSZ0("Variable missing from FILE command.",1) Q
 I '$D(DICOMPX(V)) D WARN^INHSZ0("Identifier variable in FILE command not known.",1)
 I F,'$D(^DIC(F,0)) D ERROR^INHSZ0("File #"_F_" not found.",1) Q
 I 'F D  Q:ER
 . S DIC=1,DIC(0)="",X=F X "N F,V D ^DIC" I Y<0 D ERROR^INHSZ0("File '"_F_"' is unknown or ambiguous.",1) Q
 . S F=+Y
 S FILE=F_^DIC(F,0,"GL"),FILEB=1,LOOKUP=0
 S A=" ;"_LINE D L
 I '$D(LVARS(V)) D  Q
 . S A=" K MDESC S INDA=0,IDENT=$G(@INV@("""_V_""")),MDESC(2)="".01 = ""_IDENT K FIELD" D L
 . S LPARAM="",IDENT=1,MCNT=2
 ;If var is a loop
 D RLB^INHSZ51
 Q
 ;
ENDFILE ;End of FILE block
 ;I REPEAT S UP^INHSZ1 S SLVL=SLVL-1,FILEB=0
 Q
L ;Should be call to another routine
 Q
 ;
