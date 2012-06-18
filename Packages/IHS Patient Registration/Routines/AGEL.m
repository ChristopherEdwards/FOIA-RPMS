AGEL ; IHS/ASDS/EFG - Add/Edit Eligibility Information ;  
 ;;7.1;PATIENT REGISTRATION;**1,2**;JAN 31, 2007
 ;
HEAD S U="^"
INS ;EP - EDIT AN INSURER
 G INS2:$D(AGNEWINS)
 W !!
 K DIC
 S DIC="^AUTNINS(",DIC(0)="AEMQ",DIC("A")="Select INSURER: "
 I $G(AGELP("TYPE"))="PI" S DIC("S")="I $D(^(1)),$P(^(1),U,7),$P(^(0),U)'=""MEDICAID"",$D(^(2)),""NRDI""'[$P(^(2),U)"
 E  S DIC("S")="I $D(^(1)),$P(^(1),U,7),$D(^(2)),""NDR""'[$P(^(2),U)"
 K DTOUT,DUOUT
 D ^DIC
 G XIT:X=""!$D(DTOUT)!$D(DUOUT),INS:Y=-1
 S AGELP("INS")=+Y
 G PH
INS2 ;
 I $D(AGELP("PDFN")),$D(^AUPNPRVT("I",AGELP("INS"),AGELP("PDFN"))) W *7,!!,"WARNING: If you proceed you will be ADDING an Insurer that the Patient already",!," has an Eligibility Record for!"
 K DTOUT,DUOUT
 I  W ! K DIR S DIR(0)="Y",DIR("A")="         Do you wish to proceed" D ^DIR K DIR W:Y=1 "   (OK, then proceed with caution)"
 I Y=0!$D(DTOUT)!$D(DIRUT)!(Y="^") G XIT
PH K AGEL
 F AGEL="PH","TYPE","INS","MODE","PDFN","HRN" I $D(AGELP(AGEL)) S AGEL(AGEL)=AGELP(AGEL)
 K AGELP
 F AGEL="PH","TYPE","INS","MODE","PDFN","HRN" I $D(AGEL(AGEL)) S AGELP(AGEL)=AGEL(AGEL)
 K AGEL
 W !!,"Enter the NAME of the POLICY HOLDER or the POLICY NUMBER if it already exists."
 I $D(AGELP("PDFN")) W !?10,"(Enter 'SAME' if the PATIENT is the Policy Holder.)"
 K DIR
 W !
 S DIR(0)="FO^1:30",DIR("A")="Select POLICY HOLDER",AGEL("D")="^AUPN3PPH(",AGEL("D0")="QZEM",AGEL("DS")="I $P(^(0),U,3)=AGELP(""INS"")" I $D(AGELP("TYPE")),AGELP("TYPE")="MCD",$D(AG("NUM")) S AGEL("DS")=AGEL("DS")_",$P(^(0),U,4)=AG(""NUM"")"
 S DIR("?",1)="Enter Name of the person in whose name the account is carried or"
 S DIR("?",2)="the Policy Number if the Policy already exists."
 S DIR("?",3)=""
 S DIR("?")="(NOTE: Existing Policy Holders are displayed by entering ""??"")"
 S DIR("??")="^S X=""??"",DIC=AGEL(""D""),DIC(0)=AGEL(""D0""),DIC(""S"")=AGEL(""DS"") D ^DIC"
 D ^DIR
 S:Y="/.,"!(Y="^^") DFOUT=""
 S:Y="" DLOUT=""
 S:Y="^" (DUOUT,Y)=""
 S:Y?1"?".E!(Y["^") (DQOUT,Y)=""
 K DIR
 I $D(DIROUT)!$D(DIRUT)!$D(DUOUT)!$D(DTOUT) W !!,"Not adding insurer...." H 2 G XIT
 I $D(AGELP("PDFN")),X="SAME"!(X="SELF") S (Y,X)=$P(^DPT(AGELP("PDFN"),0),U),AGELP("SAME")=1 D PCHK^AGEL1 G HIT
 E  S AGELP("SAME")=0
 S AGEL("X")=X
 ;BEGIN NEW CODE IHS/SD/TPF AG*7.1*1 ITEM 18
 I $G(AGELP("INS")) D
 .N INSTYP,INSNM
 .S INSTYP=$P($G(^AUTNINS(AGELP("INS"),2)),U)
 .S INSNM=$P($G(^AUTNINS(AGELP("INS"),0)),U)
 ;END NEW CODE 
 W !
 K DIC
 S DIC(0)="EM",DIC="^AUPN3PPH(",DIC("S")="I $P(^(0),U,3)=AGELP(""INS"")"
 D ^DIC
 I +Y<1 D PCHK^AGEL1 G XIT:$D(DIROUT)!$D(DIRUT)!$D(DUOUT)!$D(DTOUT),INS:+Y<1
HIT S AGELP("PH")=+Y,AGELP("Y")=Y
 I $P(^AUPN3PPH(+Y,0),U,2)]"" S AGELP("PHPAT")=$P(^(0),U,2)
 S AGELP("MODE")="E" I $P(Y,U,3)=1 S AGELP("MODE")="A"
 I $D(AGELP("PDFN")),AGELP("TYPE")="MCD" I 0 S AGEL("I")="" F AGZ("I")=1:1 S AGEL("I")=$O(^AUPNMCD("C",AGELP("PH"),AGEL("I"))) Q:'+AGEL("I")  I $P(^AUPNMCD(AGEL("I"),0),U)=AGELP("PDFN") Q
 I  G DISP
 I $D(AGELP("PDFN")),AGELP("TYPE")="PI",$D(^AUPNPRVT("C",AGELP("PH"),AGELP("PDFN"))) G DISP
 D ADD^AGEL1
 S ADDCHK=""
DISP ;EP
 I '$D(AGNEWINS) S AGELP("SAME")=0,AGELP("MODE")="E" D DISP^AGEL0
 I $D(AGNEWINS) S AGELP("SAME")=0,AGELP("MODE")="A" D DISP^AGEL0
XIT S:$G(DFN)'=$G(AGELP("PDFN")) DFN=$G(AGELP("PDFN"))
 K AGEL,AGV,DIC,DR
 Q
