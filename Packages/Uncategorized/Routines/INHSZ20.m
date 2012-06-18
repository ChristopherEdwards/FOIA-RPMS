INHSZ20 ;JSH,DGH; 18 Oct 1999 10:54 ;Interface script compiler (INHSZ2 cont'd) ; 11 Nov 91   6:42 AM
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;CHCS TOOLS_460; GEN 6; 17-JUL-1997
 ;COPYRIGHT 1988, 1989, 1990 SAIC
 ;
L G L^INHSZ1
 ;
LINEO ;LINE command in OUTPUT mode
 S A=" K LINE S LINE="""",CP=0"
 N DLMFLAG
 S I=1,P=1 F  D  Q:ER!OUT  S I=I+1,P=P+1
 . I I=$L(%1,"^"),$O(LINE(LC)) S LC=LC+1,%1=$P(%1,"^",I)_LINE(LC),I=1
 . S %2=$P(%1,"^",I),V=$$LBTB^UTIL($P(%2,"=")),F=$$LBTB^UTIL($P(%2,"=",2))
 . I I>$L(%1,"^")!(I=$L(%1,"^")&(%2="")) S OUT=1 Q
 . Q:%2=""  Q:V=""
 . D:$L(A)>150 L F CON=1:1:$L(V,"_") S V1=$P(V,"_",CON) D  Q:ER!OUT
 .. I V1?1"""".ANP1"""" S A=A_" S L1="_$S(CON=1:"",1:"L1_")_V1 D:$L(A)>150 L Q
 .. I V1?1"@"1.ANP S A=A_" S L1="_$S(CON=1:"",1:"L1_")_"$G(INA("_$$VEXP^INHSZ4($P(V1,"@",2))_$S(V1'["(":WHSUB,1:"")_"))" D:$L(A)>150 L Q
 .. I $D(SET(V1)) S A=A_" S L1="_$S(CON=1:"",1:"L1_")_"$G(@INV@("""_V1_"""))" D:$L(A)>150 L Q
 .. D:A]"" L D ATSET^INHSZ21(V1),DICOMP^INHSZ21(.V1) I $D(V1) S A=" S D0=INDA "_V1_" S L1="_$S(CON=1:"",1:"L1_")_"X" D L Q
 .. D ERROR^INHSZ0("Unable to interpret: "_V,1)
 . Q:ER!OUT  S:F="" F="V" I '$$FORMAT^INHSZ2(F) D ERROR^INHSZ0("Illegal format: '"_F_"'",1) Q
 . S A=A_" S:$TR(L1,$G(SUBDELIM))="""" L1=""""" D:$L(A)>150 L
 . ;if field length is variable, do the following
 . I "Vv"[$E(F) D  Q
 .. ;Normal variable processing
 .. I INSTD'="NC" S A=A_" D SETPIECE^INHU(.LINE,DELIM,"_P_",L1,.CP)" D:$L(A)>150 L Q
 .. ;If NCPDP use special handling. Variable fields will
 .. ;1) will have a delimiter, but must be concatenated to end
 .. ;of line, don't use SETPIECE or the position won't be correct.
 .. ;2) will start with the field id concatenated with the field value
 .. ;3) must be suppressed completely if the value is null
 .. N FID S FID=$P($P(F,"(",2),")")
 .. S A=A_" I $L(L1) S L1=DELIM_"""_FID_"""_L1 D CONCAT^INHU(.LINE,L1,0)" D L
 . ;if Fixed type do
 . ;format is Ft(PC)W where t=Left or R justified, PC=pad char
 . ;W=the fixed width
 . I "Ff"[$E(F) D  Q
 .. S PC=$P($P(F,"(",2),")"),W=+$P(F,")",2),DLMFLAG=+$P($P(F,")",2),",",3) S:PC="" PC=" "
 .. I "Rr"[$E(F,2) S A=A_" K Z S $P(Z,"""_PC_""","_W_"-$L(L1)+1)="""" D CONCAT^INHU(.LINE,$E(Z_L1,1,"_W_"),"_DLMFLAG_")" D:$L(A)>150 L Q
 .. S A=A_" K Z S $P(Z,"""_PC_""","_W_"-$L(L1)+1)="""" D CONCAT^INHU(.LINE,$E(L1_Z,1,"_W_"),"_DLMFLAG_")" D:$L(A)>150 L
 . ;----else format is Minimum/Maximum (needed for X12 support)
 . ;Format is <var>=Mt(PC)W,MM where t=Left or R justified, PC=pad char
 . ;W=maximum length and MM=minimum length. The following algorithm
 . ;assumes that the MM will only be enforced if the field L1 has
 . ;value. So if the min/max field is delimited, a field with a min
 . ;length of 5 and a value of XX would be ^XX___^, but with a value
 . ;of "" would be ^^.
 . S PC=$P($P(F,"(",2),")"),W=+$P(F,")",2),MM=+$P($P(F,")",2),",",2),DLMFLAG=+$P($P(F,")",2),",",3)
 . ;defaults are: Padding character=null, flush=right, min width=max
 . S:PC="" PC=" " S:'MM MM=W
 . I W<MM D ERROR^INHSZ0("Maximum width "_W_" is less than minimum width "_MM,1)
 . I "Rr"[$E(F,2) S A=A_" S Z="""" S:$L(L1) $P(Z,"""_PC_""","_MM_"-$L(L1)+1)="""" D CONCAT^INHU(.LINE,$E(Z_L1,1,"_W_"),"_DLMFLAG_")" D:$L(A)>150 L Q
 . S A=A_" S Z="""" S:$L(L1) $P(Z,"""_PC_""","_MM_"-$L(L1)+1)="""" D CONCAT^INHU(.LINE,$E(L1_Z,1,"_W_"),"_DLMFLAG_")" D:$L(A)>150 L
 D:A]"" L
 I INSTD="X12" S A=" D LINE^INHUT11(.LINE,DELIM,LCT)" D L
PUT ;Put line into message
 I INSTD="X12" S A=" I $L(LINE)'=0 S LCT=LCT+1,^UTILITY(""INH"",$J,LCT)=LINE I $D(LINE)>9 M ^UTILITY(""INH"",$J,LCT)=LINE" D L ;LD
 I INSTD'="X12" S A=" S LCT=LCT+1,^UTILITY(""INH"",$J,LCT)=LINE I $D(LINE)>9 M ^UTILITY(""INH"",$J,LCT)=LINE" D L
 Q
 ;
TEMPLATE ;Invoke a print template to generate lines
 N T
 Q:'$$SYNTAX^INHSZ0($P(LINE,COMM,2,99),"."" ""1""=""."" ""1.ANP")
 S T=$$CASECONV^UTIL($TR($$LBTB^UTIL($P(LINE,"=",2)),"[]"),"U")
 S DIC="^DIPT(",DIC(0)="",DIC("S")="I $P(^DIPT(Y,0),U,4)=+FILE",X=T D ^DIC K DIC
 I Y<0 D ERROR^INHSZ0("Template '"_T_"' does not exist for file #"_+FILE,1) Q
 W !,"Compiling Print Template: ",T D ^INHDIPZ(+Y,$TR(ROU,"S","T"),MAX-1500)
 S A=" S INV=""^UTILITY(""""INH"""",$J)"",INL=0,D0=INDA D ^"_$TR(ROU,"S","T") D L^INHSZ2
 Q
 ;
WHILE ;WHILE statement in Output mode
 ;%E will have remainder of line (and non-null)
 N DIC,Z,FILE1
 I $E(%E)="""",$E(%E,$L(%E))="""" D  Q
 .S FILE(SLVL)=FILE,FILE="",OTHER(SLVL)="U"
 .S A=" S INDA"_(SLVL)_"=INDA,",SLVL=SLVL+1,WHSUB=WHSUB_",INI("_SLVL_")"
 .S A=A_"INI("_SLVL_")=0  F  S INI("_SLVL_")=$O(INDA("_%E_",INI("_SLVL_"))) Q:'INI("_SLVL_")  S INDA=$S(INDA("_%E_",INI("_SLVL_")):INDA("_%E_",INI("_SLVL_")),1:INI("_SLVL_")) D" D L,DOWN^INHSZ1("W")
 S DIC="^DD("_+FILE_",",DIC(0)="Z",X=%E D ^DIC I Y>0,$P(Y(0),U,2) D  G GOT
 . S FILE(SLVL)=FILE,Z=^DD(+FILE,+Y,0),MULT=MULT+1,MNODE(MULT)=$P($P(Z,U,4),";"),X=+$P(Z,U,2),FILE1=FILE(SLVL-MULT+1) S:+MNODE(MULT)'=MNODE(MULT) MNODE(MULT)=""""_MNODE(MULT)_""""
 . D MDOWN^INHSZ71 S OTHER(SLVL)="M"
 S DIC="^DIC(",DIC(0)="M",X=%E D ^DIC
 I Y<0 D ERROR^INHSZ0("Unknown multiple or file.",1) Q
 I SLVL,OTHER(SLVL-1)="M" D ERROR^INHSZ0("Cannot move to an other file from within a multiple.",1) Q
 S (FILE1,FILE(SLVL))=FILE,FILE=+Y_^DIC(+Y,0,"GL"),OTHER(SLVL)=""
GOT N INM S SLVL=SLVL+1,INM=OTHER(SLVL-1)="M",WHSUB=WHSUB_",INI("_SLVL_")"
 D:'INM
 . Q:'$D(^DD(+FILE(SLVL-1),0,"PT",+FILE))
 . N CH,%,I S (%,I)=0 F  S I=$O(^DD(+FILE(SLVL-1),0,"PT",+FILE,I)) Q:'I  S J=0 F  S J=$O(^DD(+FILE,I,1,J)) Q:'J  I $P(^(J,0),U,3)="" S %=%+1,CH(%)=$P(^(0),U,2) Q
 . I '$D(CH) Q   ;W !,*7,"WARNING:  File #"_+FILE_" has no usable backward pointers to file #"_+FILE(SLVL-1),!,"Entry numbers in file #"_+FILE_" will have to be supplied." S WARN=$G(WARN)+1 Q
 . I $O(CH($O(CH(""))))="" D BACKPT(CH($O(CH("")))) Q
 . W !!,"File #"_+FILE_" has more than one pointer back to file #"_FILE(SLVL-1)_".",!?5,"Choose which field or none for no automatic back pointer extraction."
 . W !! D ^UTSRD("Choose (1-"_%_"): ;;;;;1,"_%,"") Q:'X
 . D BACKPT(CH(X))
 I INM S A=" I '$D(INDA("_+FILE_")) S INI=0 F  S INI=$O(^"_$P(FILE,U,2)_"INI)) Q:'INI  S INDA("_+FILE_",INI)=""""" D L
 S A=$S('INM:" S INDA"_(SLVL-1)_"=INDA,",1:" S ")
 S A=A_"INI("_SLVL_")=0  F  S INI("_SLVL_")=$O(INDA("_+FILE_",INI("_SLVL_"))) Q:'INI("_SLVL_")  S INDA=$S(INDA("_+FILE_",INI("_SLVL_")):INDA("_+FILE_",INI("_SLVL_")),1:INI("_SLVL_")) D" D L,DOWN^INHSZ1("W")
 S A=" Q:'$D(^"_$P(FILE,U,2)_"INDA,0))" D L
 Q
 ;
BACKPT(IX) ;Add code to scan back pointer for entry #s
 ;IX = Xref name
 S A=" I '$D(INDA("_+FILE_")) S INI=0 F  S INI=$O(^"_$P(FILE,U,2)_""""_IX_""",INDA,INI)) Q:'INI  S INDA("_+FILE_",INI)=""""" D L
 Q
 ;
ENDWHILE ;End of a WHILE in Output Mode
 S SLVL=SLVL-1 D UP^INHSZ1
 S A=" S INDA=INDA("_SLVL_")"
 S WHSUB=$P(WHSUB,",",1,SLVL+1)
 I OTHER(SLVL)'="M" S FILE=FILE(SLVL),A=" S INDA=INDA"_SLVL_" K INDA"_SLVL D L Q
 N FILE1 S FILE1=FILE(SLVL) D MUP^INHSZ71 Q
 ;
SCREEN ;Screen entries in WHILE loop
 I MODE'="O" D ERROR^INHSZ0("SCREEN command can only be used in OUTPUT mode.",1) Q
 I 'DOTLVL D ERROR^INHSZ0("SCREEN command must be inside a WHILE block.",1) Q
 I $P(INDS(DOTLVL),U)'="W" D ERROR^INHSZ0("SCREEN command must be inside a WHILE block.",1) Q
 N %1
 S %1=$$LBTB^UTIL($P(LINE,COMM,2,99)) Q:'$$SYNTAX^INHSZ0(%1,"1""="".ANP")
 S X=$$LB^UTIL($E(%1,2,999)) D ^DIM I '$D(X) D ERROR^INHSZ0("Invalid M code in screen.",1) Q
 S A=" ;"_LINE D L
 S A=" I $D(^"_$P(FILE,U,2)_"INDA,0)) X """_$$REPLACE^UTIL(X,"""","""""")_""" E  Q" D L
 Q
