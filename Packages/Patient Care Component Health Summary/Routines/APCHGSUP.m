APCHGSUP ; IHS/CMI/LAB - display SUPPLEMENT ;
 ;;2.0;IHS PCC SUITE;**7**;MAY 14, 2009
 ;
EN ;
 W:$D(IOF) @IOF
 W !!,$$CTR("*** Print Health Summary Supplement ***"),!!
GETPAT ;
 S DIC="^AUPNPAT(",DIC(0)="AEMQ" D ^DIC K DIC
 I Y=-1 D EXIT Q
 S (APCHSDFN,APCHSPAT,DFN)=+Y
 W !
SUPP ;
 S APCHSUPT="",APCHSUPI=""
 S DIC="^APCHSUP(",DIC(0)="AEMQ",DIC("S")="I $G(^(14))]""""",DIC("A")="Select HEALTH SUMMARY SUPPLEMENT: " D ^DIC K DIC
 I Y=-1 G GETPAT
 S (APCHSUPT,APCHSUPI)=+Y
 I $D(^APCHSUP(APCHSUPI,15)) X ^APCHSUP(APCHSUPI,15) I $D(APCHSUPQ) W !!,"Supplement will not be generated." D EXIT Q
 I '$D(^APCHSUP(APCHSUPI,14)) W !!,"That supplement is not available with this option, you will need to",!,"display this supplement with a health summary.",! D EXIT Q
ZIS ;
 W ! S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) D EXIT Q
 S APCHOPT=Y
 I Y="B" D BROWSE,EXIT Q
 S XBRP="PRINT^APCHGSUP",XBRC="",XBRX="EXIT^APCHGSUP",XBNS="APCH;DFN"
 D ^XBDBQUE
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""PRINT^APCHGSUP"")"
 S XBRC="",XBRX="EXIT^APCHGSUP",XBIOP=0 D ^XBDBQUE
 Q
EXIT ;
 D EN^XBVK("APCH")
 D ^XBFMK
 Q
S(Y,F,C,T) ;set up array
 I '$G(F) S F=0
 I '$G(T) S T=0
 NEW %,X
 ;blank lines
 F F=1:1:F S X="" D S1
 S X=Y
 I $G(C) S L=$L(Y),T=(80-L)/2 D  D S1 Q
 .F %=1:1:(T-1) S X=" "_X
 F %=1:1:T S X=" "_Y
 D S1
 Q
S1 ;
 S %=$P(^TMP("APCHS",$J,"DCS",0),U)+1,$P(^TMP("APCHS",$J,"DCS",0),U)=%
 S ^TMP("APCHS",$J,"DCS",%)=X
 Q
PRINT ;
OUTPUT ;
 K APCHSUPQ
 S Y=DT X ^DD("DD") S APCHSDAT=Y D NOW^%DTC S X=% X ^DD("FUNC",2,1) S APCHSTIM=X
 S APCHSCVD="S:Y]"""" Y=+Y,Y=$E(Y,4,5)_""/""_$S($E(Y,6,7):$E(Y,6,7)_""/"",1:"""")_$E(Y,2,3)"
 S APCHSHDR="CONFIDENTIAL PATIENT INFORMATION -- "_$$FMTE^XLFDT(DT,5)_$J(APCHSTIM,9)_"  ["_$P(^VA(200,DUZ,0),U,2)_"]" S X="",$P(X,"*",((IOM-6-$L(APCHSHDR))\2)+1)="*" S APCHSHDR=X_" "_APCHSHDR_" "_X
 K APCHQUIT
 S APCHPAGE=0,APCHQUIT=0
 K ^TMP("APCHS",$J)
 X ^APCHSUP(APCHSUPI,14)
 Q:$G(APCHSUPQ)
W ;write out array
 W:$D(IOF) @IOF
 K APCHQUIT
 W !,"********** CONFIDENTIAL PATIENT INFORMATION ["_$P(^VA(200,DUZ,0),U,2)_"]  "_$$FMTE^XLFDT(DT)_" **********"
 S APCHX=0 F  S APCHX=$O(^TMP("APCHS",$J,"DCS",APCHX)) Q:APCHX'=+APCHX!($D(APCHQUIT))  D
 .I $Y>(IOSL-3) D HEADER Q:$D(APCHQUIT)
 .W !,^TMP("APCHS",$J,"DCS",APCHX)
 .Q
 I $D(APCHQUIT) S APCHSQIT=1
 D EOJ
 Q
 ;
EOJ ;
 D PAUSE^APCHMT1
 K ^TMP("APCHS",$J)
 D EN^XBVK("APCH")
 K N,%,T,F,X,Y,B,C,E,F,H,L,N,P,T,W
 Q
HEADER ;
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCHQUIT="" Q
HEAD1 ;
 W:$D(IOF) @IOF
 W !,"********** CONFIDENTIAL PATIENT INFORMATION ["_$P(^VA(200,DUZ,0),U,2)_"]  "_$$FMTE^XLFDT(DT)_" **********",!!
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
