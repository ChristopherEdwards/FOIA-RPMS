INHSZ51 ;JSH; 3 Feb 92 08:28;Interface - INHSZ5 continued ; 11 Nov 91   6:42 AM
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
L G L^INHSZ1
 ;
LAYGO ;Create new entry
 D DOWN^INHSZ1("")
 S A=" K DA F I=1:1:MULT S DA(I)=INDA(I)" D L
 S A=" K DO,DIC "_$S(MULT:"S DIC(""P"")="""_MULT0_""" ",1:"")_"S DIC=""^"_$$REPLACE^UTIL($P(FILE,U,2,99),"""","""""")_""",DIC(0)=""L""" D L
 I MULT,MULT0["P" S A=" I $D(@INV@(""IDENT.001"")) S X=@INV@(""IDENT.001""),DLAYGO="_+MULT0_" D ^DICN S INDA=+Y,INLAYGO=1" D L
 S A=" S X=""""""""_IDENT_"""""""" D ^DIC S INDA=+Y,INLAYGO=1"
 I MULT,MULT0["P" S A=" I '$D(@INV@(""IDENT.001"")) "_$E(A,2,999)
 D L,UP^INHSZ1 Q
 ;
REPEAT ;Initiate a REPEAT block
 I REPEAT D ERROR^INHSZ0("Cannot nest REPEAT commands",1) Q
 Q:'$$SYNTAX^INHSZ0($P(LINE,COMM,2,99),"1."" ""1.ANP")
 N V
 S V=$$LBTB^UTIL($P(LINE,COMM,2,99))
 I '$D(DICOMPX(V)) D ERROR^INHSZ0("Unknown identifying variable: "_V,1) Q
 I '$D(LVARS(V)) D ERROR^INHSZ0("Repeat variable was not created in a loop. It cannot function as the control   variable for a REPEAT command.",1) Q
 S A=" ;"_LINE D L
RLB ;Build repeating loop
 S SLVL=SLVL+1
 N V1 S V1=$$VEXP(V)
 S A=" S INI("_SLVL_")=0 F  Q:'$O("_V1_")  S INI("_SLVL_")=$O("_V1_") D" D L,DOWN^INHSZ1("R")
 S A=" N INLAYGO,MDESC,DIPA,FIELD S INI=INI("_SLVL_"),INDA=0,IDENT=$G("_V1_"),MDESC(2)="" .01 = ""_IDENT" D L S MCNT=2,LPARAM=""
 S (REPEAT1,REPEAT,IDENT)=1 Q
 ;
VEXP(V,Q) ;Return expanded variable reference using SLVL levels
 ;If $G(Q) then quotes will be omitted around first subscript
 N X,I
 S X=$S('$G(Q):"@INV@("""_V_"""",1:"@INV@("_V) F I=1:1:SLVL S X=X_",INI("_I_")"
 S X=X_")"
 Q X
 ;
ENDREPEA ;End a REPEAT section
 I 'REPEAT D ERROR^INHSZ0("No active REPEAT command to end.",1) Q
 D UP^INHSZ1 S REPEAT=0,SLVL=SLVL-1
 Q
 ;
TEMPLATE ;Invoke an input template
 I 'REPEAT D ERROR^INHSZ0("TEMPLATE command only allowed within a REPEAT block in the LOOKUP section.",1) Q
 I 'LOOKUP D ERROR^INHSZ0("LOOK command must precede a TEMPLATE command.",1) Q
 G TEMPLATE^INHSZ7
 ;
DIPA ;Set DIPA array when not in a loop state
 S A=" K DIPA S I="""" F  S I=$O(@INV@(I)) Q:I=""""  S:$D(@INV@(I))<9 DIPA(I)=@INV@(I)" D L
 Q
 ;
RDIPA ;Set the DIPA array for all script variables defined for this REPEAT value
 S A=" K DIPA S I="""" F  S I=$O(@INV@(I)) Q:I=""""  S:$D("_$$VEXP("I",1)_")#2 DIPA(I)="_$$VEXP("I",1) D L
 Q
 ;
ROUTINE ;Call a routine
 I 'REPEAT D ERROR^INHSZ0("ROUTINE command only allowed within a REPEAT block in the LOOKUP section.",1) Q
 I 'LOOKUP D ERROR^INHSZ0("LOOK command must precede a ROUTINE command.",1) Q
 G ROUTINE^INHSZ7
 ;
SAVE ;Save entry number into a script variable
 N %2
 S %2=$$LBTB^UTIL($P(LINE,COMM,2,99))
 Q:'$$SYNTAX^INHSZ0(%2,"1.ANP")
 D DOIT^INHSZ5
 S A=" S @INV@("""_%2_""")=INDA" D L S DICOMPX(%2)="$G(@INV@("""_%2_"""))"
 Q
