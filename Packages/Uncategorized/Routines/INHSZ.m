INHSZ ;JSH; 15 Oct 1999 15:41 ;Interface Script compiler  
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;CHCS TOOLS_460; GEN 6; 8-APR-1997
 ;COPYRIGHT 1988, 1989, 1990 SAIC
 ;
 I $G(^DD("OS",^DD("OS"),"ZS"))="" W *7,!,"Your operating system does not allow saving a routine.",!! Q
 N SCR,DIC,Y,STR
 S DIC="^INRHS(",DIC(0)="QAE",DIC("A")="Select SCRIPT to Compile: ",DIC("S")="I '$P(^(0),U,4)" D ^DIC Q:Y<0  S SCR=+Y
EN ;Enter here with SCR = script # to compile
 Q:'$D(^INRHS(SCR))
 L +^INRHS(SCR):0 E  W !,*7,"Another user is working with this script." Q
 N INDUZ M INDUZ=DUZ N DUZ S DUZ(0)="@",DUZ("AG")=$G(INDUZ("AG"))
 N DOT,INDL,MAX,INDS,INDE,ROU,INSTD,STR
 ;S MAX=+$G(^DD("ROU")) S:'MAX MAX=6000 S MAX=MAX-500 cmi/maw orig
 S MAX=+$G(^DD("ROU")) S:'MAX MAX=10000 S MAX=MAX-500  ;cmi/maw mod
 S DT=$$DT^UTDT
 ;Set flag for interface standard (stored in field .07)
 S INSTD=$P(^INRHS(SCR,0),U,7),INSTD=$S(INSTD="NCPDP":"NC",INSTD="X12":"X12",INSTD="HL7":"HL",1:"HL")
 W !!,"Compiling Script: ",$P(^INRHS(SCR,0),U),!
 S ROU="IS"_$E(SCR#100000+100000,2,6) K ^UTILITY("IN",$J)
 I $$^INHSZ1(SCR) D
 .D FILE
 E  D:$G(^UTILITY("INHSYS_FILERR",$J)) SUMERR^INHSYS11($P(^INRHS(SCR,0),U)_" not compiled.")
 L -^INRHS(SCR)
 Q
 ;
ASBL(SCR) ;Assemble script lines   SCR = script #
 S L="",V="^UTILITY(""IN"",$J,""L"")",(C0,C1,C,LVL)=0
 S I=0 F  S I=$O(^INRHS(SCR,1,I)) Q:'I  S X=^(I,0) S:'$O(^INRHS(SCR,1,I)) X=X_"|CR|" D
 . I X'["|CR|" D  Q
 .. I $L(L)+$L(X)'>255 S L=L_X Q
 .. F  Q:X=""  D
 ... S Z=255-$L(L),L=L_$E(X,1,Z),X=$E(X,Z+1,999) Q:$L(L)'=255
 ... S C=C+1,@V@(C)=L,L="" D:'LVL DOWN Q
 .; X now contains a |CR|
 . F  Q:X'["|CR|"  D
 .. S L1=$P(X,"|CR|"),X=$P(X,"|CR|",2,999)
 .. I $L(L1)+$L(L)<256 S C=C+1,@V@(C)=L_L1 D:LVL UP S L="" Q
 .. S Z=255-$L(L),L=L_$E(L1,1,Z),L1=$E(L1,Z+1,999),C=C+1,@V@(C)=L D:'LVL DOWN S C=C+1,@V@(C)=L1,L="" D UP Q
 Q
 ;
DOWN ;Move down 1 level
 S C0=C,V="^UTILITY(""IN"",$J,""L"","_C0_")",C=0,LVL=1 Q
 ;
UP ;Move up to top level
 S V="^UTILITY(""IN"",$J,""L"")",C=C0,LVL=0 Q
 ;
FILE ;File the routine(s) created
 W !,"Linking... "
 N C,RN,LC,LVL,DOT,CS,MODE,STRIP,INZS,%REF,DATE,RMAX
 S MODE=$E($P(^INRHS(SCR,0),U,2))
 S C=0,RN=1,(LC,LVL,STRIP)=0,Y=DT D DD^%DT S DATE=Y K DOT
 F  D  Q:'$O(^UTILITY("IN",$J,"R",C))
 . ;S (A,CS)=0,L=1 S X=ROU_$S(RN=1:"",1:$C(RN+63)) K ^UTILITY("IN",$J,RN) maw orig line
 . S (A,CS)=0,L=1 S X=ROU_$S(RN=1:"",RN>27:$C(RN+69),1:$C(RN+63)) K ^UTILITY("IN",$J,RN)  ;cmi/sitka/maw modified for more routines
 . I RN=1 D
 .. I MODE="O" S X=X_"(INTT,INDA,INA,INDEST,INQUE,INORDUZ,INORDIV)"
 .. E  S X=X_"(UIF,INOA,INODA)"
 .. S X=X_" ;Compiled from script '"_$P(^INRHS(SCR,0),U)_"' on "_DATE,^UTILITY("IN",$J,RN,L)=X,CS=CS+X
 . E  S ^UTILITY("IN",$J,RN,L)=X_" ;Compiled from script '"_$P(^INRHS(SCR,0),U)_"' on "_DATE,CS=CS+$L(^UTILITY("IN",$J,RN,L))+2
 . S L=L+1,^UTILITY("IN",$J,RN,L)=" ;Part "_RN,CS=CS+$L(^(L))+2
 . S L=L+1,^UTILITY("IN",$J,RN,L)=" ;Copyright "_$$DATEFMT^UTDT(DT,"YYYY")_" SAIC",CS=CS+$L(^UTILITY("IN",$J,RN,L))+2 I $P(^UTILITY("IN",$J,"R",C+1)," ")="" S $P(^(C+1)," ")="EN",STRIP=$$NUMDOTS(^(C+1))
 . F  S C=C+1 Q:'$D(^UTILITY("IN",$J,"R",C))  Q:CS+$L($G(^UTILITY("IN",$J,"R",C)))+13>MAX&'A  D
 .. S A=0
 .. S L=L+1,^UTILITY("IN",$J,RN,L)=$$STRIP(^UTILITY("IN",$J,"R",C),STRIP),CS=CS+$L(^UTILITY("IN",$J,RN,L))+2
 .. I $D(INDL(C)) S $P(INDL(C),U,2)=RN_U_(LVL-STRIP) S LVL=LVL+1
 .. I $D(INDE(C)) S LVL0=$P(INDL(+INDE(C)),U,3),SR=$P(INDL(+INDE(C)),U,2) S:SR'=RN TAG=$$TAG(LC)_LVL,$P(INDE(C),U,2)=TAG,DOT(SR,999-LVL0)=LVL0_U_RN_U_TAG S LVL=LVL-1,A=1 S:'LVL LC=LC+1 D:SR'=RN
 ... S $P(^UTILITY("IN",$J,"R",C+1)," ")=TAG,STRIP=$$NUMDOTS(^(C+1))
 . S C=C-1
 . I $O(^UTILITY("IN",$J,"R",C)),'$D(INDE(C+1)) D
 .. ;S L=L+1,^UTILITY("IN",$J,RN,L)="9 "_$E("...............",1,LVL-STRIP)_$S(LVL-STRIP:"D",1:"G")_" EN^"_ROU_$C(RN+64) maw orig
 .. S L=L+1,^UTILITY("IN",$J,RN,L)="9 "_$E("...............",1,LVL-STRIP)_$S(LVL-STRIP:"D",1:"G")_" EN^"_ROU_$S(RN>26:$C(RN+70),1:$C(RN+64))  ;maw mod for more routines
 . S ^UTILITY("IN",$J,RN)=L,RN=RN+1
F1 ;Do the filing
 W " Filing generated routines...",!
 S INZS=$$REPLACE^UTIL(^DD("OS",^DD("OS"),"ZS"),"^UTILITY($J,0,","@%REF@("),I=0 F  S I=$O(^UTILITY("IN",$J,I)) Q:'I  S RMAX=I D
 . S %REF="^UTILITY(""IN"",$J,"_I_")"
 . ;S X=ROU_$S(I=1:"",1:$C(I+63)) maw orig
 . S X=ROU_$S(I=1:"",I>27:$C(I+69),1:$C(I+63))  ;maw modified
 . I $D(DOT(I)) D
 .. S L=^UTILITY("IN",$J,I)
 .. ;S J=0 F  S J=$O(DOT(I,J)) Q:'J  S LVL=999-J,L=L+1,@%REF@(L)=" "_$E("...............",1,LVL)_$S(LVL:"D",1:"G")_" "_$P(DOT(I,J),U,3)_"^"_ROU_$C(63+$P(DOT(I,J),U,2)) ;maw orig
 .. S J=0 F  S J=$O(DOT(I,J)) Q:'J  S LVL=999-J,L=L+1,@%REF@(L)=" "_$E("...............",1,LVL)_$S(LVL:"D",1:"G")_" "_$P(DOT(I,J),U,3)_"^"_ROU_$S($P(DOT(I,J),U,2)>27:$C(69+$P(DOT(I,J),U,2)),1:$C(63+$P(DOT(I,J),U,2)))  ;maw modified
 . X INZS W !,"Routine ",X,?19,"...Filed"
 S $P(^INRHS(SCR,0),U,6)=RMAX K ^UTILITY("IN",$J),^UTILITY($J)
 Q
 ;
TAG(X) ;Return tag for #X
 I X<52 Q $C($S(X<26:65,1:71)+X)
 Q $C(64+(X\52))_$C($S((X#52)<26:65,1:71)+(X#52))
 ;
RECOMP ;Recompile all scripts
 F SCR=0:0 S SCR=$O(^INRHS(SCR)) Q:'SCR  D EN:'$P(^(SCR,0),U,4)
 Q
 ;
NUMDOTS(%L) ;Returns number of dots at start of %L
 N X S %L=$P(%L," ",2,999),X=1
NM0 Q:$E(%L,X)'="." X-1 S X=X+1 G NM0
 ;
STRIP(%L,%N) ;Strip %N dots from front of %L
 Q:'%N %L
 Q $P(%L," ")_" "_$P($P(%L," ",2,999),$E("..............",1,%N),2,999)
