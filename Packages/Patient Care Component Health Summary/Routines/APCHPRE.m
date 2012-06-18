APCHPRE ;IHS/CMI/GRL Patient Health Summary - Pre Visit[ 02/11/2005  11:05 PM ]
 ;;2.0;IHS RPMS/PCC Health Summary;**14**;JUN 24, 1997
 ;
EN ;
 Q  ;NOT READY YET
 W:$D(IOF) @IOF
 W !!,$$CTR("*** Print Patient Medical Handout ***"),!!
 K DIC S DIC="^AUPNPAT(",DIC(0)="AEMQ" D ^DIC K DIC
 I Y=-1 D EXIT Q
 S DFN=+Y
 W !
ZIS ;
 W ! S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) D EXIT Q
 S APCHOPT=Y
 I Y="B" D BROWSE,EXIT Q
 S XBRP="PRINT^APCHPRE",XBRC="",XBRX="EXIT^APCHPRE",XBNS="APCH;DFN"
 D ^XBDBQUE
 D EXIT
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""PRINT^APCHPRE"")"
 S XBRC="",XBRX="EXIT^APCHPRE",XBIOP=0 D ^XBDBQUE
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
 S %=$P(^TMP("APCHPHS",$J,"PHS",0),U)+1,$P(^TMP("APCHPHS",$J,"PHS",0),U)=%
 S ^TMP("APCHPHS",$J,"PHS",%)=X
 Q
PRINT ;
OUTPUT S APCHSCVD="S:Y]"""" Y=+Y,Y=$E(Y,4,5)_""/""_$S($E(Y,6,7):$E(Y,6,7)_""/"",1:"""")_$E(Y,2,3)"
 K ^TMP("APCH",$J)
 S APCHSPAT=DFN
 D EP^APCHPRE1(DFN) ;gather up data
W ;write out array
 W:$D(IOF) @IOF
 K APCHQUIT
 W !,"********** Patient Medical Handout ********** ["_$P(^VA(200,DUZ,0),U,2)_"]  "_$$FMTE^XLFDT(DT)_" **********"
 S APCHX=0 F  S APCHX=$O(^TMP("APCHPHS",$J,"PHS",APCHX)) Q:APCHX'=+APCHX!($D(APCHQUIT))  D
 .I $Y>(IOSL-3) D HEADER Q:$D(APCHQUIT)
 .W !,^TMP("APCHPHS",$J,"PHS",APCHX)
 .Q
 I $D(APCHQUIT) S APCHSQIT=1
 D EOJ
 Q
 ;
EOJ ;
 K ^TMP("APCHPHS",$J)
 K APCHX,APCHQUIT,APCHY,APCHSDFN,APCHSBEG,APCHSTOB,APCHSUPI,APCHSED,APCHTOBN,APCHTOB,APCHSPAT
 K APCHLFGV,APCHLFGD,APCHLGLV,APCHLGLD,APCHLFOB,APCHLBE,APCHLCOL,APCHLSIG,APCHSCRN,APCHCOLO
 K APCHPNV,APCHPND,APCHMNV,APCHMND,APCHIMMN,APCHIMMT,APCHICTR,APCHI,APCHIMDU,APCHIMM,APCHLDRE
 K APCHC,APCHOPT,APCHSCVD
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
 ;
 ;
 ;
SDEP ;entry point from Scheduling Package with DFN defined
 Q  ;;NOT READY YET
 I '$P($G(^APCCCTRL(DUZ(2),0)),U,14)  ;set site parameter in PCC Master Control file has to be set
 I $$V2(DFN,$$FMTE^XLFDT(DT,-1)) Q  ;IF PT HAD A VISIT IN PAST 120 DAYS DON'T BOTHER
 I SDAMEVT,$P($G(^SD(409.66,SDAMEVT,0)),U)="CHECK-IN" D
 . W !!,"Do you wish to print a Patient Medical Handout to give to the patient?"
 . W !,"If so, enter the device to print the handout on, otherwise enter a '^'."
 . S XBRP="PRINT^APCHPRE",XBRC="",XBRX="EXIT^APCHPRE",XBNS="APCH;DFN"
 . D ^XBDBQUE
 Q
 ;
 ;
 ;
V2(P,EDATE) ;
 NEW APCHBDAT,A,B,C,G,V,X
 S APCHBDAT=$$FMADD^XLFDT(DT,-120)
 I '$D(^AUPNVSIT("AC",P)) Q ""
 K ^TMP($J,"A")
 S A="^TMP($J,""A"",",B=P_"^ALL VISITS;DURING "_$$FMTE^XLFDT(APCHBDAT)_"-"_$$FMTE^XLFDT(EDATE),E=$$START1^APCLDF(B,A)
 I '$D(^TMP($J,"A",1)) Q ""
 S (X,G)=0 F  S X=$O(^TMP($J,"A",X)) Q:X'=+X!(G)  S V=$P(^TMP($J,"A",X),U,5) D
 .Q:'$D(^AUPNVSIT(V,0))
 .Q:'$P(^AUPNVSIT(V,0),U,9)
 .Q:$P(^AUPNVSIT(V,0),U,11)
 .Q:"A"'[$P(^AUPNVSIT(V,0),U,7)
 .Q:$P(^AUPNVSIT(V,0),U,6)'=DUZ(2)
 .S T=$O(^ATXAX("B","APCH CLINIC STOP FOR PT HS",0))
 .S C=$P(^AUPNVSIT(V,0),U,8)
 .Q:$G(C)']""
 .Q:$D(^ATXAX(T,21,"B",C))
 .S G=G+1
 .Q
 Q $S(G<1:"",1:1)
 ;
