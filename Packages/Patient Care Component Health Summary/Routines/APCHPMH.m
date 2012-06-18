APCHPMH ; IHS/CMI/LAB - Patient Wellness Handout ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
EN ;
 N APCHSEGN,APCHSTYP
 W:$D(IOF) @IOF
 W !!,$$CTR("*** Print Patient Wellness Handout ***"),!!
 K DIC S DIC="^AUPNPAT(",DIC(0)="AEMQ" D ^DIC K DIC
 I Y=-1 D EXIT Q
 S DFN=+Y
 W !
ZIS ;
 W ! S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) D EXIT Q
 S APCHOPT=Y
 I Y="B" D BROWSE,EXIT Q
 S XBRP="PRINT^APCHPMH",XBRC="",XBRX="EXIT^APCHPMH",XBNS="APCH;DFN"
 D ^XBDBQUE
 D EXIT
 Q
 ;
EHR  ;*16*  CMI/GRL support for EHR
 S APCHPWHT=$O(^APCHPWHT("B","ADULT REGULAR",0))
 D EHR^APCHPWHG(DFN,APCHPWHT)
 Q
 D EN^XBNEW("PRINT^APCHPMH","DFN")
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""PRINT^APCHPMH"")"
 S XBRC="",XBRX="EXIT^APCHPMH",XBIOP=0 D ^XBDBQUE
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
 S %=$P(^TMP("APCHPHS",$J,"PMH",0),U)+1,$P(^TMP("APCHPHS",$J,"PMH",0),U)=%
 S ^TMP("APCHPHS",$J,"PMH",%)=X
 Q
PRINT ;
OUTPUT S APCHSCVD="S:Y]"""" Y=+Y,Y=$E(Y,4,5)_""/""_$S($E(Y,6,7):$E(Y,6,7)_""/"",1:"""")_$E(Y,2,3)"
 K ^TMP("APCH",$J)
 S APCHSPAT=DFN
 D EP^APCHPMH1(DFN) ;gather up data
W ;write out array
 ;W:$D(IOF) @IOF
 K APCHQUIT
 W !,"********** Patient Wellness Handout ********** ["_$P(^VA(200,DUZ,0),U,2)_"]  "_$$FMTE^XLFDT(DT)_" **********"
 S APCHX=0 F  S APCHX=$O(^TMP($J,"APCHPWH",APCHX)) Q:APCHX'=+APCHX!($D(APCHQUIT))  D
 .I $Y>(IOSL-3) D HEADER Q:$D(APCHQUIT)
 .W !,^TMP($J,"APCHPWH",APCHX)
 .Q
 I $D(APCHQUIT) S APCHSQIT=1
 D EOJ
 Q
 ;
EOJ ;
 ;
 K ^TMP("APCHPHS",$J)
 K ^TMP($J,"APCHPWH")
 D EN^XBVK("APCH")
 D EN^XBVK("APCD")
 K BIDLLID,BIDLLPRO,BIDLLRUN,BIRESULT,BISITE
 K AUPNDAYS,AUPNDOB,AUPNDOD,AUPNPAT,AUPNSEX
 K N,%,T,F,X,Y,B,C,E,F,H,J,L,N,P,T,W,ST,ST0
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
