BARPUTL ; IHS/SD/LSL - POSTING UTILITIES ; 07/08/2010
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**1,19**;OCT 26, 2005
 ;
 ; IHS/SD/TMM 06/18/10 1.8*19 Add Prepayment functionality.
 ; *********************************************************************
 Q
 ;
SELBILL ; EP
 ; select bill
 ;IM24235 BAR*1.8*1
 I '$D(^BARBL(DUZ(2))) D  Q
 .W !!,$P(^DIC(4,DUZ(2),0),U)," DOES NOT HAVE ANY BILLS TO LIST!"
 .K DIR
 .S DIR(0)="E"
 .D ^DIR
 ;END IM24235
 K DIC
 S DIC=90050.01
 S DIC(0)="AEMQZ"
 ; IHS/SD/PKD 10/21/10
 S DIC("W")="D DISP^BARPUTL"
 D ^DIC
 Q:+Y<0
 S BARPAT=$P(^BARBL(DUZ(2),+Y,1),"^",1)
 S BARSTART=$P(^BARBL(DUZ(2),+Y,1),"^",2)
 S BAREND=$P(^BARBL(DUZ(2),+Y,1),"^",3)
 S:BAREND="" BAREND=BARSTART
 S BARPAT(0)=$P($G(^DPT(+BARPAT,0)),"^",1)
 S BARZ=BARPAT_"^"_BARSTART_"^"_BAREND
 Q
 ; *********************************************************************
 ;
 ; IHS/SD/PKD 1.8*19 10/21/10
DISP  ; New Tag Pt Lookup Display
 ; Naked reference - called from Fileman Display
 N DOS,STAT,CURRAMT
 Q:'$D(^(1))  ; No data,quit
 S DOS=$$SHDT^BARDUTL($P(^(1),U,2))
 S CURRAMT=$P(^(0),U,15)  ;I CURRAMT=0 S CURRAMT="0.00"
 ;Extra spaces after tabs on purpose.  keep fields apart.
 S STAT=$S($D(^BARTBL(+$P(^(0),U,16),0))#2:$P(^(0),U,1),1:"")
 W ?38," ",$J($FN(CURRAMT,"p",2),9),"  ",?48,STAT,?55," ",DOS,?63," ",$P(^BARBL(DUZ(2),Y,1),U,16)
 Q
GETBIL ;EP
 W !
 S DIC="^BARBL(DUZ(2),"
 S DIC(0)="AEQZ"
 S DIC("A")="Select Bill DOS: "
 S D="E"
 D IX^DIC
 K DIC
 Q:+Y<0
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
 K DIC,BARZ
 S DIC="^AUPNPAT("
 S DIC(0)="IAEMQZ"
 S DIC("S")="Select Patient: "
 S DIC("S")="I $D(^BARBL(DUZ(2),""ABC"",Y))"
 D ^DIC
 K DIC
 Q:+Y<0
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
 ;
ASKPATB(DICB) ;EP - select patient
 ; IHS/SD/TMM 1.8*19 7/6/10
 ; Copied from ASKPAT; allows user to pass default value for DIC("B"))
 K DIC,BARZ
 S DIC("B")=DICB
 S DIC="^AUPNPAT("
 S DIC(0)="IAEMQZ"
 S DIC("S")="Select Patient: "
 S DIC("S")="I $D(^BARBL(DUZ(2),""ABC"",Y))"
 D ^DIC
 K DIC
 Q:+Y<0
 S BARPAT=+Y
 S BARPAT(0)=Y(0)
 S BARPAT(0)=$P($G(^DPT(+BARPAT,0)),"^",1)
 D GETDOS
 I '$G(BAROK) K BARPAT Q
 S BARZ=BARPAT_"^"_BARSTART_"^"_BAREND
 Q
 ;
SELBILLB(DICB2) ; EP
 ; IHS/SD/TMM 1.8*19 7/11/10
 ; Copied from SELBILL: allows user to pass default value for DIC("B"))
 ; select bill
 I '$D(^BARBL(DUZ(2))) D  Q
 .W !!,$P(^DIC(4,DUZ(2),0),U)," DOES NOT HAVE ANY BILLS TO LIST!"
 .K DIR
 .S DIR(0)="E"
 .D ^DIR
 K DIC
 S DIC("B")=DICB2
 S DIC=90050.01
 S DIC(0)="AEMQZ"
 D ^DIC
 Q:+Y<0
 S BARPAT=$P(^BARBL(DUZ(2),+Y,1),"^",1)
 S BARSTART=$P(^BARBL(DUZ(2),+Y,1),"^",2)
 S BAREND=$P(^BARBL(DUZ(2),+Y,1),"^",3)
 S:BAREND="" BAREND=BARSTART
 S BARPAT(0)=$P($G(^DPT(+BARPAT,0)),"^",1)
 S BARZ=BARPAT_"^"_BARSTART_"^"_BAREND
 Q
 ; *********************************************************************
 ;
GETBILB(DICB3) ;EP
 ; IHS/SD/TMM 1.8*19 7/11/10
 ; Copied from GETBIL: allows user to pass default value for DIC("B"))
 W !
 S DIC="^BARBL(DUZ(2),"
 S DIC(0)="AEQZ"
 S DIC("A")="Select Bill DOS: "
 S D="E"
 D IX^DIC
 K DIC
 Q:+Y<0
 S BARPAT=$P(^BARBL(DUZ(2),+Y,1),"^",1)
 S BARSTART=$P(^BARBL(DUZ(2),+Y,1),"^",2)
 S BAREND=$P(^BARBL(DUZ(2),+Y,1),"^",3)
 S BARPAT(0)=$P($G(^DPT(+BARPAT,0)),"^",2)
 W "  ",BARPAT(0)
 S BARZ=BARPAT_"^"_BARSTART_"^"_BAREND
 Q
 ; **************************
