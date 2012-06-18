AMQQTXG1 ; IHS/CMI/THL - LOOKUP FOR TAX ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;-----
PLOOKUP ; ENTRY POINT FROM AMQQTXG
 S DIC=AMQQTLOK
 S DIC(0)="EQM"
 I $G(AMQQSQSN)=617,$G(AMQQSQN)=620 S %=$O(^UTILITY("AMQQ TAX",$J,+$G(AMQQTAX)-1,0)) I '$O(^(%)) S DIC("S")="I $D(^BWDIAG(""P"","_%_",Y))"
 I $D(AMQQNECO) S DIC(0)="M"
 I DIC="^AUTTHF(" S DIC("S")="I $P(^(0),U,10)=""F"""
 D ^DIC
 K DIC,DUOUT,DTOUT
 I Y'=-1 S X=+Y I $D(AMQQTAXI),$D(AMQQTDIC),AMQQTAXI'="",AMQQTDIC'="" D PLK1
 Q
 ;
PLK1 S:$G(AMQQLINK)=32 X=$P(Y,U,2)
 I $D(AMQQTTX),AMQQTTX'="",$D(AMQQTAXT),AMQQTAXT=5 X AMQQTTX
 S %=AMQQTDIC_""""_AMQQTAXI_""",X)"
 I '$D(AMQQNDB),'$D(@%) W !,"  (none found in database so not selected... if you still want to select this",!,"   value enter it with quotes about it" S Y=-1
 K AMQQNDBC
 Q
 ;
PHELP ; ENTRY POINT FROM AMQQTXG
 W !!,"Enter the name of a ",AMQQATNM,"."
 W !,"Enter ""??"" to see your selections or ""???"" to see choices.",!!
 Q
 ;
PHELP1 ; ENTRY POINT FROM AMQQTXG
 S DIC=AMQQTLOK
 S DIC(0)="E"
 S D="B"
 S DZ="??"
 I $G(AMQQSQSN)=617,$G(AMQQSQN)=620 S %=$O(^UTILITY("AMQQ TAX",$J,+$G(AMQQTAX)-1,0)) I '$O(^(%)) S DIC("S")="I $D(^BWDIAG(""P"","_%_",Y))"
 I DIC="^AUTTHF(" S DIC("S")="I $P(^(0),U,10)=""F"""
 D DQ^DICQ
 K DIC,D,DZ
 Q
 ;
GLOOKUP ; ENTRY POINT FROM AMQQTXG
 S Y=$F(AMQQSSET,(";"_X_":"))
 I Y S Z=$E(AMQQSSET,Y,256),Z=$P(Z,";") W "  (",Z,")" S Y=X Q
 S Y=-1
 F %=2:1 S Z=$P(AMQQSSET,";",%) Q:Z=""  I $E($P(Z,":",2),1,$L(X))=X W $E($P(Z,":",2),$L(X)+1,99) S Y=$P(Z,":") Q
 I Y=-1 W *7,"  ??" Q
 S X=Y
 Q
 ;
GHELP1 ; ENTRY POINT FROM AMQQTXG
 S %="You may select one or more of the following =>"
 W !!,%,!
 F %=1:1 S X=$P(AMQQSSET,":",%) W !?5,$P(X,";") I $P(X,";",2)="" Q
 Q
 ;
FHELP ; ENTRY POINT FROM AMQQTXG
 I AMQQTAXI="" W !!,"Enter the name of a ",AMQQATN Q
 S %="You may select one or more of the following =>"
 W !!,%,!
 S %=""
 S X=""
 S T=AMQQTDIC_""""_AMQQTAXI_""")"
 F I=1:1 S %=$O(@T@(%)) Q:%=""  W ! D:'(I#(IOSL-4)) FLIST1 W ?5,% I X=U Q
 Q
 ;
FLIST1 W "<>"
 R X:DTIME W *13,?5,*13
 Q
 ;
FLOOKUP ; ENTRY POINT FROM AMQQTXG
 I AMQQTAXI="" G FEXIT
 S T=AMQQTDIC_""""_AMQQTAXI_""")"
 I '$D(@T@(X)) S %=$O(@T@(X)) I $E(%,1,$L(X))'=X W "  <= Not found in data base",*7 G FEXIT
 I $D(@T@(X)) S %=$O(@T@(X)) I $E(%,1,$L(X))'=X G FEXIT
 I '$D(@T@(X)) S (%,Y)=$O(@T@(X)) I $E(%,1,$L(X))=X S %=$O(^(%)) I $E(%,1,$L(X))'=X W $E(Y,$L(X)+1,99) S X=Y G FEXIT
 S N=0
 S Z=X
 I $D(@T@(X)) S ^UTILITY("AMQQ LOOK",$J,1)=X,N=1
FINCN S Z=$O(@T@(Z))
 I $E(Z,1,$L(X))'=X S N=N+1 D FC1 G:Y'=0 FEXIT G FMORE
 S N=N+1
 I N>1,N#5=1 D FC Q:Y=1  G:Y=-1 FEXIT I Y=0 D FEXIT G FLOOKUP
 W !?5,N,"   ",Z
 S ^UTILITY("AMQQ LOOK",$J,N)=Z
 G FINCN
FMORE S AMQQLMOR=""
FEXIT K T,^UTILITY("AMQQ LOOK",$J),N
 Q
 ;
FC W !,"TYPE <CR> TO SEE MORE CHOICES, '^' TO STOP, OR"
FC1 W !,"CHOOSE 1-",N-1,": "
 R Y:DTIME E  S Y=U
 I Y="" Q
 I Y=U S Y=-1 Q
 I Y?1."?" W !,"Pick a number between 1 and ",N-1,".  You can also enter a new name.",! G FC
 I Y,$D(^UTILITY("AMQQ LOOK",$J,Y)) S X=^(Y) W "  (",X,")" Q
 I Y=+Y W "  ??",*7 G FC1
 S X=Y
 S Y=0
 Q
 ;
RHELP ; ENTRY POINT FROM AMQQTXG
 S X="DIAG"
 I AMQQLINK=31 S Z="diagnosis^diagnoses^ICD9^250.00^250.51^CAUSE or LOCATION"
 I AMQQLINK=174 S Z="procedure^procedures^ADA^AAA^BBB^CCC"
 I AMQQLINK=455 S Z="CPT CODE^CPT CODES^CPT^11040^11044"
 D ^AMQQHEL1
 Q
 ;
RLOOKUP ; ENTRY POINT FROM AMQQTXG
 S AMQQSAVE("X")=X
 S (AMQQONE,AMQQSUB,AMQQA)=0
 S AMQQ("NO DISPLAY")=0
 S AMQQ("NOT TAX")=""
 S AMQQTYP="LOW"
 I $D(AMQQTXEX) D RL1 G REXIT
 I X'["-" S AMQQONE=1 D ^AMQQTXC S:Y>0 ^UTILITY("AMQQ TAX",$J,AMQQURGN,+Y)="" G REXIT
 S X=$P(X,"-")
 W !
 D ^AMQQTXC
 I 'AMQQA S AMQQTYP="HI",X=$P(AMQQSAVE("X"),"-",2) W ! D ^AMQQTXC
REXIT I 'AMQQA,'$D(AMQQQUIT),$D(@AMQQHILO) D RANGES^AMQQTXC
 K AMQQSUB,AMQQTYP,AMQQDFN,DIR,AMQQSAVE,AMQQA,AMQQCNT,AMQQ,AMQQR,AMQQI,AMQQSTP,AMQQX,AMQQTXEX
 Q
 ;
RL1 S AMQQSUB=1
 S AMQQA=0
 I X["-" S X=$P(X,"-") D ^AMQQTXC I 'AMQQA S X=$P(AMQQSAVE("X"),"-",2),AMQQTYP="HI" W ! D ^AMQQTXC Q
 I X'["-" S AMQQTYP="LOW",AMQQONE=1 D ^AMQQTXC I Y>0 K ^UTILITY("AMQQ TAX",$J,AMQQURGN,+Y)
 Q
 ;
RHELP1 ; ENTRY POINT ROM AMQQTXG
 I '$D(@AMQQHILO) W !!,"A code range has yet to be selected.  A display cannot be generated.",! Q
 D SHOW^AMQQTXC
 Q
 ;
