INHSC ;JSH; 11 Jul 94 15:55;Create/Edit a script
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 N DIC,I,NAME,X,Y,DIK,DIE,DA,DR
A S DIC="^INRHS(",DIC(0)="E",DIC("S")="I '$P(^(0),U,5)"
 W !! D ^UTSRD("Select SCRIPT to edit: ",1) Q:X=""!($E(X)="^")
 D ^DIC G:X["?" A I Y>0 S DA=+Y D ED G A
 X $P(^DD(4006,.01,0),U,5,999) I '$D(X) W *7," ??" G A
 W *7 S NAME=X S X=$$YN^UTSRD("                Are you adding a new script? ;1","") I 'X W " ??",*7 G A
 S DA=$$MAKENEW Q:'DA
 S ^DIJUSV(DUZ,"^INRHS(")=DA,^INRHS(DA,0)=NAME,DIK="^INRHS(" D IX1^DIK
 W ! S X=$$YN^UTSRD("Is this script going to be an INCLUDE for another script? ;0","") Q:X["^"
 S $P(^INRHS(DA,0),U,4)=+X G:X 1
 S DR=".02;.03",DIE="^INRHS(" D ^DIE S X=$P(^INRHS(DA,0),U,2,3)
 I X'?1A1"^"1.NP W *7,!?5,"<Script '"_$P(^INRHS(DA,0),U)_"' Deleted>" S DIK=DIE D ^DIK G A
 D TEMP($E(X))
1 D ED G A
 ;
MAKENEW() ;Make a new script and return its IEN
 N I,X
 L +^INRHS(0) F I=1:1 Q:'$D(^INRHS(I))
 I I>99999 W *7,!,"No space for additional scripts.",! L -^INRHS(0) Q ""
 S ^INRHS(I,0)="",X=$P(^INRHS(0),U,4),X=X+1,$P(^INRHS(0),U,4)=X
 S X=$P(^(0),U,3) I I>X S $P(^(0),U,3)=I
 L -^INRHS(0) Q I
 ;
ED ;Edit  DA=script number
 N INDA,INON,INRMAX
 S:$P(^INRHS(DA,0),U,4) INON=1
 S INDA=DA,DIE="^INRHS(",INRMAX=$P(^INRHS(DA,0),U,6)
 I $$SC^INHUTIL1 S DWN="INH SCRIPT EDIT" D ^DWC G:'$D(^INRHS(INDA,0)) SDEL D EDSCR^INHI(INDA) G ED1
 S DR="[INH SCRIPT EDIT]" D ^DIE G:'$D(^INRHS(DA,0)) SDEL
ED1 Q:$P(^INRHS(DA,0),U,4)
 W !! S X=$$YN^UTSRD("Compile Script? ;1","") Q:'X
 S SCR=DA G EN^INHSZ
 ;
SDEL ;Script INDA deleted, INRMAX = number of compiled routines
 S:'$G(INRMAX) INRMAX=10 S R="IS"_$E(INDA#100000+100000,2,6)
 F I=1:1:INRMAX S X=R_$S(I=1:"",1:$C(63+I)) X ^%ZOSF("DEL") W !,X_" routine deleted."
 K I,X,R Q
 ;
KILL(DA) ;Kill script DA
 Q:'$D(^INRHS(DA,0))
 N INRMAX S INRMAX=$P(^INRHS(DA,0),U,6)
 S INDA=DA,DIK="^INRHS(" D ^DIK G SDEL
 ;
TEMP(%M) ;Load initial script template
 ;%M = I or O
 N %,I,X,%1
 D:'$D(DT) SETDT^UTDT
 S %=0 F I=1:1 S X=$T(TEXT+I) Q:'$L(X)  S %1=$P(X,";",2) I '$L(%1)!(%1=%M) S %=%+1,^INRHS(DA,1,%,0)=$P(X,";",3,99)_"|CR|"
 S ^INRHS(DA,1,0)=U_U_%_U_%_U_DT
 Q
 ;
PRINT ;Print a script
 N D0,ROU,ZTSK,IOP,DUOUT,PAGE,FILE,DIR,NAME,INON
 S DIC=4006,DIC(0)="QAEM",DIC("A")="Select SCRIPT to Print: "
 D ^DIC Q:Y<0  S D0=+Y
 K IOP S %ZIS="NMQ" D ^%ZIS Q:POP  S IOP=ION_";"_IOST_";"_IOM_";"_IOSL
 I IO'=IO(0) D  D ^%ZISC Q
 . S ZTSAVE("D0")="",ZTSAVE("DTIME")=""
 . S ZTRTN="ZTSK^INHSC",ZTIO=IOP D ^%ZTLOAD W !?5,"Request "_$S($D(ZTSK):"",1:"NOT ")_"QUEUED."
 S %ZIS="" D ^%ZIS
ZTSK ;TaskMan entry point - enter with D0 set to entry #
 S U="^",PAGE=0
 X $P(^DD(4006,1,0),U,5,99) S ROU=X S FILE=$P($G(^DIC(+$P(^INRHS(D0,0),U,3),0)),U),DIR=$P("IN^OUT",U,$P(^INRHS(D0,0),U,2)="O"+1),NAME=$P(^INRHS(D0,0),U),INON=$P(^(0),U,4)
 K ^UTILITY("IN",$J) D ASBL^INHSZ(D0) ;Assemble lines
 W:'$D(ZTSK) @IOF D HEAD
 S I=0 F  S I=$O(^UTILITY("IN",$J,"L",I)) Q:'I  D  Q:$G(DUOUT)
 . I $Y+3>IOSL D HEAD Q:$G(DUOUT)
 . S L=^(I),N=0 W !,I,".",?7
 . I $L(L)<(IOM-10) W L Q
 . W $E(L,1,IOM-10) S L=$E(L,IOM-9,999)
 . F  Q:'$L(L)&'$O(^UTILITY("IN",$J,"L",I,N))  D  Q:$G(DUOUT)
 .. I $Y+3>IOSL D HEAD Q:$G(DUOUT)
 .. S X=$E(L,1,IOM-10),L=$E(L,IOM-9,999) I $L(X)<(IOM-10),$O(^UTILITY("IN",$J,"L",I,N)) S N=$O(^(N)),L=^(N),X=X_$E(L,1,(IOM-10)-$L(X)),L=$E(L,(IOM-10)-$L(X)+1,999)
 .. W !?10,X
 I $D(ZTSK) K ^%ZTSK(ZTSK) W @IOF
 K ^UTILITY("IN",$J) D ^%ZISC Q
 ;
HEAD ;Script header
 K DUOUT
 I IO=IO(0),'$D(ZTSK),$E(IOST,1,2)="C-",PAGE W !,*7 R X:DTIME S:$E(X)=U DUOUT=1
 Q:$G(DUOUT)
 W:PAGE @IOF S PAGE=PAGE+1
 W !,"Script Name:",?18,NAME
 I 'INON W !,"Compiled Routine:",?18,ROU,!,"File:",?18,$E(FILE,1,30),?50,"Direction: ",DIR
 E  W "   (Include Only)"
 W ! K Z S $P(Z,"-",IOM+1)="" W Z
 Q
TEXT ;Lines of text for initial script
 ;;;
 ;;
 ;;DATA:
 ;;;Data Section
 ;;DELIM=
 ;;SUBDELIM=
 ;;
 ;;
 ;;
 ;I;TRANS:
 ;I;;Transform Section
 ;I;
 ;I;
 ;I;REQUIRED:
 ;I;;Required Section
 ;I;
 ;I;
 ;I;
 ;I;LOOKUP:
 ;I;;Lookup Section
 ;I;IDENT
 ;I;MATCH
 ;I;PARAM
 ;I;
 ;I;STORE:
 ;I;;Store Section
 ;I;ROUTINE=
 ;I;TEMPLATE=
 ;I;
 ;;END:
