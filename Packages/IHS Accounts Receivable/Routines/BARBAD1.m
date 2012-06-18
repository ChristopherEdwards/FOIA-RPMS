BARBAD1 ; IHS/SD/LSL - Posting and Adjustments ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**19,21**;OCT 26, 2005
 ;
EN() ; EP
 ; Batch Posting entry
 K BARPAT,BARZ
 D SELBILL
 Q:$D(DTOUT)!$D(DIROUT)!$D(DUOUT) 0
 I $G(BARZ) Q BARZ
 D ASKPAT
 Q:$D(DTOUT)!$D(DIROUT)!$D(DUOUT) 0
 I $G(BARZ) Q BARZ
 D GETBIL
 I $G(BARZ) Q BARZ
 Q 0
 ; *********************************************************************
 ;
TOP(BARV) ; EP
 ; Select Batch 
 W !!!
 W "Select Batch: "_$P(BARCOL(0),U,1)
 S Y=+BARCOL
 D BATW^BARBAD
 D BBAL^BARBAD(BARCOL)
 W !!,"Select Item: "_BARITM
 S Y=+BARITM
 D DICW^BARBAD
 D IBAL^BARBAD(BARITM)
 I $G(BAREOB) D
 .N DA
 .W !!
 .W "Select Visit Location: "
 .S DA=BAREOB
 .S DA(1)=+BARITM
 .S DA(2)=+BARCOL
 .W $$VAL^XBDIQ1(90051.1101601,.DA,.01)
 .D EBAL^BARBAD(BAREOB)
 Q:'BARV
 W !!
 W "Select Patient: "_$P(BARPAT(0),U,1)
 Q
SELBILL ; EP
 ; select bill
 ;IHS/SD/TPF BAR*1.8*21 8/3/2011 HEAT20490
 I $$NOTOPEN^BARUFUT(.DUZ,$G(UFMSESID)) Q  ;IS SESSION STILL OPEN
 ;IM24235 BAR*1.8*1
 I '$D(^BARBL(DUZ(2))) D  Q
 .W !!,$P(^DIC(4,DUZ(2),0),U)," DOES NOT HAVE ANY BILLS TO LIST!"
 .K DIR
 .S DIR(0)="E"
 .D ^DIR
 ;END IM24235
 K DIC
 S DIC=90050.01
 ; IHS/SD/PKD 10/22/10 Selection Display-more info
 S DIC("W")="D DISP^BARPUTL"
 S DIC(0)="AEMQZ"
 D ^DIC
 Q:+Y<0
 Q:$D(DTOUT)!$D(DIROUT)!$D(DUOUT)!(Y="")!(Y=" ")
 S BARPAT=$P(^BARBL(DUZ(2),+Y,1),"^",1)
 S BARSTART=$P(^BARBL(DUZ(2),+Y,1),"^",2)
 S BAREND=$P(^BARBL(DUZ(2),+Y,1),"^",3)
 S:BAREND="" BAREND=BARSTART
 S BARPAT(0)=$P($G(^DPT(+BARPAT,0)),"^",1)
 S BARZ=BARPAT_"^"_BARSTART_"^"_BAREND
 Q
 ; *********************************************************************
 ;
GETBIL ;EP
 ;IHS/SD/TPF BAR*1.8*21 8/3/2011 HEAT20490
 I $$NOTOPEN^BARUFUT(.DUZ,$G(UFMSESID)) Q  ;IS SESSION STILL OPEN
 ;
 W !
 S DIC="^BARBL(DUZ(2),"
 S DIC(0)="AEQZ"
 S DIC("A")="Select Bill DOS: "
 S D="E"
 D IX^DIC
 K DIC
 Q:+Y<0
 Q:$D(DTOUT)!$D(DIROUT)!$D(DUOUT)!(Y="")!(Y=" ")
 S BARPAT=$P(^BARBL(DUZ(2),+Y,1),"^",1)
 S BARSTART=$P(^BARBL(DUZ(2),+Y,1),"^",2)
 S BAREND=$P(^BARBL(DUZ(2),+Y,1),"^",3)
 S BARPAT(0)=$P($G(^DPT(+BARPAT,0)),"^",2)
 W "  ",BARPAT(0)
 S BARZ=BARPAT_"^"_BARSTART_"^"_BAREND
 Q
 ; *********************************************************************
 ;
ASKPAT ;EP - select patient
 ;IHS/SD/TPF BAR*1.8*21 8/3/2011 HEAT20490
 I $$NOTOPEN^BARUFUT(.DUZ,$G(UFMSESID)) Q  ;IS SESSION STILL OPEN
 ;
 K DIC,BARZ
 S DIC="^AUPNPAT("
 S DIC(0)="IAEMQZ"
 S DIC("S")="Select Patient: "
 S DIC("S")="I $D(^BARBL(DUZ(2),""ABC"",Y))"
 D ^DIC
 K DIC
 Q:+Y<0
 Q:$D(DTOUT)!$D(DIROUT)!$D(DUOUT)!(Y="")!(Y=" ")
 S BARPAT=+Y
 S BARPAT(0)=Y(0)
 S BARPAT(0)=$P($G(^DPT(+BARPAT,0)),"^",1)
 D GETDOS
 I '$G(BAROK) K BARPAT Q
 S BARZ=BARPAT_"^"_BARSTART_"^"_BAREND
 Q
 ; *********************************************************************
 ;
GETDOS ; EP
 ; dates of service
 K BARSTART,BAREND,BAROK
 W !
 S BARSTART=$$DATE^BARDUTL(1)
 Q:BARSTART<0
 S %DT("B")=$$MDT2^BARDUTL(BARSTART)
 S BAREND=$$DATE^BARDUTL(2)
 Q:BAREND<0
 I BAREND<BARSTART D  G GETDOS
 .W *7
 .D EOP^BARUTL(2)
 .W !,"The END date must not be before the START date.",!
 S BAROK=1
 Q
