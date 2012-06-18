PSORXED ;IHS/DSD/JCM-edit rx utility ;03-Oct-2006 09:27;SM
 ;;7.0;OUTPATIENT PHARMACY;**2,16,21,26,56,71,125,1005**;DEC 1997
 ;External reference to ^PSXEDIT supported by DBIA 2209
 ;External reference to ^DD(52 supported by DBIA 999
 ;External reference to ^PSDRUG supported by DBIA 221
 ;External reference to ^PS(55 supported by DBIA 2228
 ; Modified - IHS/CIA/PLS - 12/21/2003 PROCESS+2
 ;                          03/31/2004 LOG+12 and POS API
 ;                          08/29/06 POS+2
 ;                          09/15/06 - reworked the POS API logic
START ;this entry point is no longer used.
 ;D INIT,LKUP G:PSORXED("QFLG") END D PARSE,EOJ G START
END D EOJ
 Q
INIT S PSORXED("QFLG")=0 Q
LKUP ; this line of code is no longer used S PSONUM="RX",PSONUM("A")="EDIT",PSOQFLG=0 D EN1^PSONUM I PSOQFLG!($Q(PSOLIST)']"") S PSORXED("QFLG")=1
 K PSOQFLG Q
 ;
PARSE F PSORXED("LIST")=1:1 Q:'$D(PSOLIST(PSORXED("LIST")))!PSORXED("QFLG")  F PSORXED("I")=1:1:$L(PSOLIST(PSORXED("LIST"))) S PSORXED("IRXN")=$P(PSOLIST(PSORXED("LIST")),",",PSORXED("I")) D:+PSORXED("IRXN") PROCESS
 Q
PROCESS S PSORXED("DFLG")=0 G:$G(^PSRX(PSORXED("IRXN"),0))']"" PROCESSX
 S PSORXED("RX0")=^PSRX(PSORXED("IRXN"),0),PSORXED("RX2")=^(2),PSORXED("RX3")=^(3),PSOSIG=$G(^PSRX(PSORXED("IRXN"),"SIG")),PSODAYS=$P(PSORXED("RX0"),"^",8)
 S PSORXED("RX9999999")=$G(^(9999999))   ; IHS/CIA/PLS 12/21/03 - Need 999999 Node
 ; IHS/CIA/PLS - 12/21/03 - Restructured next line to allow setting of RX19999999 Refill Node
 ;S (I,RFED,RFDT)=0 F  S I=$O(^PSRX(PSORXED("IRXN"),1,I)) Q:'I  S RFED=I,PSORXED("RX1")=^PSRX(PSORXED("IRXN"),1,I,0),RFDT=$P(^(0),"^"),PSODAYS=$P(^(0),"^",10) S:$P(^(0),"^",17) PSONEW("PROVIDER NAME")=$P(^VA(200,$P(^(0),"^",17),0),"^")
 S (I,RFED,RFDT)=0 F  S I=$O(^PSRX(PSORXED("IRXN"),1,I)) Q:'I  D
 .S RFED=I,PSORXED("RX1")=^PSRX(PSORXED("IRXN"),1,I,0)
 .S PSORXED("RX19999999")=$G(^(9999999))
 .S RFDT=$P(^(0),"^"),PSODAYS=$P(^(0),"^",10)
 .S:$P(^(0),"^",17) PSONEW("PROVIDER NAME")=$P(^VA(200,$P(^(0),"^",17),0),"^")
 S PSORXST=+$P($G(^PS(53,+$P(PSORXED("RX0"),"^",3),0)),"^",7) N DA S DA=PSORXED("IRXN") D EN^PSORXPR
 D CHECK G:PSORXED("DFLG") PROCESSX
 N X S X="PSXEDIT" X ^%ZOSF("TEST") K X I $T D ^PSXEDIT I $G(PSXOUT) K PSXOUT G L1
 D DIE^PSORXED1
L1 D LOG,POST
PROCESSX Q
CHECK Q  L +^PSRX(PSORXED("IRXN")):0 I '$T W $C(7),!!,"Rx Number is Locked by Another User!",! S PSORXED("DFLG")=1 H 5 Q
 I $G(^PSDRUG($P(PSORXED("RX0"),"^",6),"I"))]"",^("I")<DT D  G CHECKX
 . W !,$C(7),"This drug has been inactivated. ",! S PSORXED("DFLG")=1 Q
 K PSPOP I $G(PSODIV),$P(PSORXED("RX2"),"^",9)'=PSOSITE S PSPRXN=PSORXED("IRXN") D CHK1^PSOUTLA I $G(PSPOP)=1 S PSORXED("DFLG")=1 G CHECKX
 ;
 I $P(^PSRX(PSORXED("IRXN"),"STA"),"^")=14!($P(^("STA"),"^")=15) S PSORXED("DFLG")=1 W !!,$C(7),"Discontinued prescriptions cannot be edited.",! G CHECKX
 I $D(^PS(52.4,"B",PSORXED("IRXN"))) S PSORXED("DFLG")=1 W !!,$C(7),"Non-verified prescriptions cannot be edited.",!
CHECKX K PSPOP,DIR,DTOUT,DUOUT,Y,X Q
LOG K PSFROM S DA=PSORXED("IRXN"),(PSRX0,RX0)=PSORXED("RX0"),QTY=$P(RX0,"^",7),QTY=QTY-$P(^PSRX(DA,0),"^",7) K ZD(DA) S:'$O(^PSRX(DA,1,0)) ZD(DA)=$P(^PSRX(DA,2),"^",2)
 S COM="" F I=3,4,5:1:13,17 I $P(PSRX0,"^",I)'=$P(^PSRX(DA,0),"^",I) S PSI=$S(I=13:1,1:I),COM=COM_$P(^DD(52,PSI,0),"^")_" ("_$P(PSRX0,"^",I)_"),"
 I $P(PSORXED("RX2"),"^",2)'=$P(^PSRX(DA,2),"^",2) S COM=COM_$P(^DD(52,22,0),"^")_" ("_$P(PSORXED("RX2"),"^",2)_"),"
 ; IHS/CIA/PLS - 12/21/03 - Added field data
 I $P(PSORXED("RX2"),"^",7)'=$P($G(^PSRX(DA,2)),"^",7) S COM=COM_$P(^DD(52,27,0),"^")_" ("_$P(PSORXED("RX2"),"^",7)_"),"   ; Set NDC value
 I $P(PSORXED("RX3"),"^",7)'=$P(^PSRX(DA,3),"^",7) S COM=COM_$P(^DD(52,12,0),"^")_" ("_$P(PSORXED("RX3"),"^",7)_"),"
 I $P($G(PSORXED("RX9999999")),"^",6)'=$P($G(^PSRX(DA,9999999)),"^",6) S COM=COM_$P(^DD(52,9999999.06,0),"^")_" ("_$P($G(PSORXED("RX9999999")),"^",6)_"),"   ; Set AWP value
 I $G(APSQCOM)]"" S COM=COM_APSQCOM K APSQCOM   ; Guarantees printing and billing set in call to OVERRIDE^APSQBRES
 ; IHS/CIA/PLS - 12/21/03 - End of changes
 I PSOSIG'=$P($G(^PSRX(DA,"SIG")),"^") S COM=COM_$P(^DD(52,10,0),"^")_" ("_PSOSIG_"),"
 I PSOTRN'=$G(^PSRX(DA,"TN")) S COM=COM_$P(^DD(52,6.5,0),"^")_" ("_PSOTRN_"),"
 G:COM="" LOGX K PSRX0 S X=$S($D(PSOCLC):PSOCLC,1:DUZ)
 S COM=COM_$$POS(DA)  ;IHS/CIA/PLS - 03/31/04 - Add answer from POS
 D FILL,LBL D:$G(PSOEDITL)=2&($P($G(^PSRX(DA,"STA")),"^")'=5)&('$G(RXRP(DA)))&('$G(PSOSIGFL)) ASKL
 S K=1,D1=0 F Z=0:0 S Z=$O(^PSRX(DA,"A",Z)) Q:'Z  S D1=Z,K=K+1
 S D1=D1+1 S:'($D(^PSRX(DA,"A",0))#2) ^(0)="^52.3DA^^^" S ^(0)=$P(^(0),"^",1,2)_"^"_D1_"^"_K
 S ^PSRX(DA,"A",D1,0)=DT_"^E^"_$G(DUZ)_"^0^"_COM
 I QTY,$P(^PSRX(DA,2),"^",13) S ^PSDRUG($P(^PSRX(DA,0),"^",6),660.1)=$S($D(^PSDRUG(+$P(^PSRX(DA,0),"^",6),660.1)):^(660.1)+QTY,1:QTY)
 S:$P(RX0,"^",6)'=$P(^PSRX(DA,0),"^",6) ^PSDRUG(+$P(^PSRX(DA,0),"^",6),660.1)=$S($D(^PSDRUG(+$P(RX0,"^",6),660.1)):^(660.1)+$P(RX0,"^",7),1:$P(RX0,"^",7))
 S RX0=^PSRX(DA,0),RX2=^(2),J=DA,OEXDT=+$P(RX2,"^",6) D ^PSOEXDT S NEXDT=+$P(RX2,"^",6) I OEXDT'=NEXDT D
 .K ^PSRX("AG",OEXDT,DA) S ^PSRX("AG",NEXDT,DA)=""
 .S D=+$P(RX0,"^",2) K ^PS(55,D,"P","A",OEXDT,DA) S ^PS(55,D,"P","A",NEXDT,DA)=""
 K D,OEXDT,NEXDT
 G:+$P(^PSRX(J,"STA"),"^")!($G(PSOEDITL)=1) LOGX S RXFL(PSORXED("IRXN"))=$S($G(PSOEDITF):$G(PSOEDITF),1:0) I $G(PSORX("PSOL",1))']"" S PSORX("PSOL",1)=PSORXED("IRXN")_"," D SETRP G LOGX
 G:$G(PSOEDITL)=1 LOGX
 F PSOX1=0:0 S PSOX1=$O(PSORX("PSOL",PSOX1)) Q:'PSOX1  S PSOX2=PSOX1
 I $L(PSORX("PSOL",PSOX2))+$L(PSORXED("IRXN"))<220 D  G LOGX
 .I PSORX("PSOL",PSOX2)'[PSORXED("IRXN")_"," S PSORX("PSOL",PSOX2)=PSORX("PSOL",PSOX2)_PSORXED("IRXN")_"," D SETRP
 E  I PSORX("PSOL",PSOX2+1)'[PSORXED("IRXN")_"," S PSORX("PSOL",PSOX2+1)=PSORXED("IRXN")_"," D SETRP
LOGX K PSOEDITF,PSOEDITR,PSOEDITL D:$G(RFED) ^PSORXED1
 Q
 ; Return POS status
POS(RIEN) ; EP
 S ANS=""
 I '$$TEST^APSQBRES("ABSPOSRX"),$G(^TMP("APSPPOS",$J,RIEN)) D
 .N APSQPOS,APSQPOST,APSQIT
 .S APSQIT=0
 .S ANS="CLAIM WAS NOT RESUBMITTED TO POS"
 .S APSQPOS=$$IEN59^ABSPOSRX(RIEN,$G(RFIEN,0)) ; Get IEN in POS File
 .I $G(APSQPOS) S APSQPOST=$O(^ABSPTL("B",APSQPOS,"A"),-1)  ; Last entry in ^ABSPTBL global
 .I $G(APSQPOST),+$$GET1^DIQ(9002313.57,+APSQPOST_",",.15) D   ; >0 indicates entry in Accounts Receivable
 ..S DIR("A",1)="There is an entry for this prescription in the Accounts Receivable Package"
 ..S DIR("A")="Do you really want to reverse this entry and resend it to the insurer and put another entry in the Accounts Receivable Package"
 ..S DIR("B")="YES"
 ..S DIR(0)="Y"
 ..D ^DIR
 ..S:'Y APSQIT=1
 .E  D  ; Block added 9/14/06 pls
 ..S DIR("A")="Do you want to reverse the POS claim?"
 ..S DIR("B")="No"
 ..S DIR(0)="Y"
 ..D ^DIR
 ..S:'Y APSQIT=1
 .I 'APSQIT D
 ..S ANS="CLAIM WAS RESUBMITTED TO POS"
 ..N APSQPST,RFIEN
 ..S RFIEN=$O(^PSRX(RIEN,1,$C(1)),-1)
 ..D CALLPOS^APSPFUNC(RIEN,$S(RFIEN:RFIEN,1:""),"A")
 K ^TMP("APSPPOS",$J,RIEN)
 Q ANS
POST ; D NEXT D:$G(^PSRX(PSORXED("IRXN"),"IB"))]"" COPAY K PSODAYS,PSORXST
 D NEXT D COPAY K PSODAYS,PSORXST
 Q
COPAY S DA=PSORXED("IRXN") I +$G(^PSRX(DA,"IB")),'RFD,PSODAYS'=+$P(^PSRX(DA,0),"^",8) D CPCK G RXST
 I +$G(^PSRX(DA,"IB")),RFD,+$G(^PSRX(DA,1,RFD,0)),PSODAYS'=$P($G(^PSRX(DA,1,RFD,0)),"^",10) D CPCK
RXST G:PSORXST=+$P($G(^PS(53,+$P(^PSRX(DA,0),"^",3),0)),"^",7) COPAYX
 W !,$C(7),"Patient Status field for this Rx has been changed from a ",$S(PSORXST=0:"COPAYMENT ELIGIBLE",PSORXST=1:"COPAYMENT EXEMPT",1:"")
 W !,"patient status."
 W "  The copay status for this Rx will be automatically adjusted."
 W !,"If action needs to be taken to adjust charges you MUST use the"
 W !,"Reset Copay Status/Cancel Charges option."
 W ! K DIR S DIR(0)="E",DIR("A")="Press Return to continue" D ^DIR K DIR
 I +$P($G(^PS(53,+$P(^PSRX(DA,0),"^",3),0)),"^",7)=1 D  ; SET TO NO COPAY AND AUDIT CHANGE
 . I '$D(^PSRX(DA,"IB")) S ^PSRX(DA,"IB")=""
 . S $P(^PSRX(DA,"IB"),"^",1)=""
 . S PSODA=DA
 . S PSOREF=RFD
 . S PSOCOMM="Rx Patient Status Change"
 . S PSOOLD="Copay"
 . S PSONW="No Copay"
 . S PREA="R"
 . D ACTLOG^PSOCPA
COPAYX K DA,PSODAYS,PSO,PSODA,PSOFLAG,PSORXST,RFD,PSOREF,PSOCOMM,PSOOLD,PSONW
 Q
CPCK ;update COPAY
 S PSO=2,PSODA=DA,PSOFLAG=1,PSOPAR7=$G(^PS(59,PSOSITE,"IB")) D RXED^PSOCPA
 Q
NEXT D NEXT^PSOUTIL(.PSORXED) K DIE,DR,DA S DIE="^PSRX(",DA=PSORXED("IRXN")
 S DR="101///"_$P(PSORXED("RX3"),"^")_";102///"_$P(PSORXED("RX3"),"^",2) D ^DIE K DIE,DR,DA,X,Y
 Q
EOJ K PSOSIG,PSORXED,PSOLIST,END,PSRX0
 ; IHS/CIA/PLS - 12/21/03
 K APSP,APSP1,APSP2,APSPDZ,APSPLTYP,APSPM0,APSPPDY,APSPPLOT,APSPPMF,APSPRXX,PSOREF,APSP91,APSPMM,APSPL
 K APSREFF,APSREFD
 K APSAZNDC,APSAZIEN,APSARNDC
 K PSOBXIEN,PSOBRIEN
 D EX^PSORXED1
 Q
FILL ;
 K PSOEDITF,PSOEDITR,PSOERF
 F PSOEZ=0:0 S PSOEZ=$O(^PSRX(DA,1,PSOEZ)) Q:'PSOEZ  S:$D(^PSRX(DA,1,PSOEZ,0)) PSOERF=PSOEZ
 S PSOEDITF=$S($G(PSOERF):+$G(PSOERF),1:0)
 I PSOEDITF S PSOEDITR=$S($P($G(^PSRX(DA,1,PSOEDITF,0)),"^",18):1,1:0) G FILLX
 S PSOEDITR=$S($P($G(^PSRX(DA,2)),"^",13):1,1:0)
FILLX K PSOERF,PSOEZ
 Q
LBL ;
 S PSOEDITL=0
 I COM["PROV"!(COM["QTY")!(COM["DAYS")!(COM["MAIL")!(COM["UNIT")!(COM["FILL DATE")!(COM["REMARKS") I COM'["STATUS",COM'["CLINIC",COM'["DRUG",COM'["REFILLS",COM'["ISSUE",COM'["SIG",COM'["TRADE" D  Q
 .I $G(PSOEDITF) S PSOEDITL=1 Q
 .I '$G(PSOEDITF),$G(PSOEDITR) S PSOEDITL=2
 I '$G(PSOEDITF),$G(PSOEDITR) S PSOEDITL=2 Q
 I '$G(PSOEDITF),'$G(PSOEDITR) S PSOEDITL=0 Q
 I $G(RXRP(DA)) S PSOEDITL=1 Q
 I '$G(RXRP(DA)),$G(PSOEDITR) S PSOEDITL=2 Q
 S PSOEDITL=0
 Q
ASKL ;
 W ! K DIR S DIR("?",1)="You have edited a fill that has already been released. Do you want to",DIR("?",2)="include this prescription as one of the prescriptions to be acted upon",DIR("?",3)="at the label prompt."
 S DIR("?")="Enter 'Yes' to generate a reprint label request."
 S DIR(0)="Y",DIR("A")="The last fill has been released, do you want a reprint label",DIR("B")="Y" D ^DIR K DIR I Y=1 S PSOEDITL=0 Q
 S PSOEDITL=1
 Q
SETRP I $P($G(^PSRX(PSORXED("IRXN"),"STA")),"^")'=5,$G(PSOEDITL)=0 S RXRP(PSORXED("IRXN"))="1^^^1",VALMSG="Label will reprint due to Edit"
 Q
