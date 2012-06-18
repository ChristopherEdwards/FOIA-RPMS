APCLLT ; IHS/CMI/LAB - VIEW PT RECORD LT ; 
 ;;2.0;IHS PCC SUITE;**5**;MAY 14, 2009
 ;
EN ;
 D EN^XBVK("APCL")
 S APCLLTVM="APCLLT LETTER"
 D VALM(APCLLTVM)
 Q
NOREG ;EP;CREATE LETTER WITHOUT REGISTER
 N APCLLT
 S APCLLT("NOREG")=""
 S APCLLTVM="APCLLT LETTER"
 D VALM(APCLLTVM)
 Q
VALM(APCLLTVM) ;EP; -- main entry point for list templates
 ;D:'$D(APCLLT("NOREG")) REG
 Q:$D(APCLLTQT)
 K APCLREG
 S VALMCC=1 ;1=screen mode, 0=scrolling mode
 D TERM^VALM0
 D CLEAR^VALM1
 D EN^VALM(APCLLTVM)
 D CLEAR^VALM1
 D EXIT
 Q
 ;
HDR ;EP
 K VALMHDR
 S VALMHDR(1)="Enter/Edit Letters"
 Q
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXPND ; -- expand code
 Q
EXIT ;
 K APCLLTQT,APCLLTOT,APCLLTLD
 ;D EN^XBVK("APCL")
 K ^TMP($J,"APCLLTVR")
 Q
ADD ;EP;TO ADD APCLLT LETTERS
 D EXIT
 D A1
 D E11:$G(APCLLTLD)
 Q
A1 D CLEAR^VALM1
 K APCLLTLD
 S:$G(DIC(0))="" DIC(0)="AELMQZ"
 S DIC="^APCLLET("
 S DIC("A")="NAME OF LETTER: "
 S:DIC(0)["L" DIC("DR")=".02////"_DUZ_";.03////"_DT,DLAYGO=9001004.6
 W !?16,"------------------------------"
 D DIC^APCLLTD
 S:+Y>0 APCLLTLD=+Y
 I Y=-1 G BACK
 ;tie to register??
 D FULL^VALM1
 W !!,"You can associate this letter with a Case Management System letter if you wish."
 W !,"If you tie it to a CMS Register you will be able to pull items such"
 W !,"as Where Followed and Case Manager from the register to insert in your"
 W !,"letter."
 W !
 S APCLREG=""
 S DIR(0)="Y",DIR("A")="Would you like to tie this letter to a CMS Register",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G BACK
 I 'Y G BACK
 D ^XBFMK
 S DIC(0)="AEMQ"
 S (DIC,DIE)="^ACM(41.1,",DIC("A")="REGISTER: "
 S APCLZDIC="^ACM(41.1)",DIC("S")="I $D(@APCLZDIC@(+Y,""AU"",""B"",DUZ))"
 D ^DIC
 I Y=-1 W !!,"No register selected." G BACK
 S APCLREG=+Y
 D EN^XBVK("ACM")
 D ^XBFMK
 S DIE="^APCLLET(",DA=APCLLTLD,DR=".04///`"_APCLREG D ^DIE,^XBFMK
BACK S VALMBCK="R"
 Q
WHICH ;EP;TO IDENTIFY WHICH LETTER TO USE
 S DIC(0)="AEMQZ"
 D A1
 Q
SELECT ;EP;TO SELECT APCLLT LETTER
 K APCLLTQT,APCLLTOT
 D LIST
S1 S DIR(0)="NO^1:"_APCLLTJ
 S DIR("A")="Select LETTER NO."
 W !
 D DIR^APCLLTD
 I +Y<1!'$G(APCLLTTP(+Y)) S APCLLTQT="" Q
 S APCLLTLD=+APCLLTTP(+Y)
 Q
EDIT ;EP;TO EDIT APCLLT LETTER
 D EXIT
 D S1
 I $D(APCLLTQT) K APCLLTQT D BACK Q
E11 D CLEAR^VALM1
 S DA=APCLLTLD
 S DIE="^APCLLET("
 S DR=1
 D DIE^APCLLTD
 D PARSE
 D BACK
 Q
PRINT ;EP;TO PRINT APCLLT LETTER
 Q:'$G(APCLLTLD)!'$G(DFN)
 D CLEAR^VALM1:IO=IO(0)&(IOST["C-")
 I APCLXCNT'=1 W @IOF
 N A,B,C,D,X,Y,Z
 S X=0
 F  S X=$O(^APCLLET(APCLLTLD,1,X)) Q:'X  D
 .S Y=$G(^APCLLET(APCLLTLD,1,X,0))
 .I Y["|" D INTP
 .W !,Y
 Q
INTP ;INTERPRET VARIABLES
 N ZZ,APCLZZZ,X,K
 S X=Y
 X ^%ZOSF("UPPERCASE")
 S ZZ=Y
 S APCLZZZ=$P(Y,"|")
 F I=2:2 S J=$P(Y,"|",I) Q:J=""  D
 .S K=$P(J," ")
 .I $T(@K)="" S ZZ="" Q
 .D @K
 .S ZZ=$P(ZZ,("|"_J_"|"))_Z_$P(ZZ,("|"_J_"|"),2)
 S Y=ZZ
 Q
ZIS ;EP;TO SELECT DEVICE ON WHICH TO PRINT APCLLT LETTER
 S:$G(APCLRTN)="" (ZTRTN,APCLRTN)="PRINT^APCLLT"
 S ZTDESC="PRINT APCLLT PATIENT LETTER"
 S ZTSAVE("ACM*")=""
 S ZTSAVE("DFN")=""
 D ^APCLLTZ
 Q
MULTIPLE ;EP;UTILTIY TO SELECT MULTIPLE PATIENTS FOR WHICH TO PRINT APCLLT LETTER
 Q
LINIT ;EP;TO CREATE ARRAY OF NAMES OF EXISTING LETTERS
 N X
 K ^TMP($J,"APCLLTVR"),APCLLTJ
 S VALMCNT=0
 K X
 S $E(X,5)="NO.  LETTER"
 D Z(X)
 K X
 S $E(X,5)="---  ------------------------------"
 D Z(X)
 S APCLLTJ=0
 S Y=""
 F  S Y=$O(^APCLLET("B",Y)) Q:Y=""  D
 .S Z=0
 .F  S Z=$O(^APCLLET("B",Y,Z)) Q:'Z  D
 ..S APCLLTJ=APCLLTJ+1
 ..K X
 ..S $E(X,5)=APCLLTJ
 ..S $E(X,10)=Y
 ..D Z(X)
 ..S APCLLTTP(APCLLTJ)=Z
 Q
ITEXT ;;
I1 ;;FIRST NAME;;2
I2 ;;LAST NAME;;2
I3 ;;CHART
I4 ;;ADDRESS;;2
I5 ;;DATE
I6 ;;PRIMARY PROVIDER NAME;;16
I7 ;;PHN;;16
I8 ;;CASE MANAGER NAME;;16
 ;;
INSERT ;EP;TO LIST INSERT ITEMS
 S APCLLTVM="APCLLT LETTER ITEMS"
 D VALM(APCLLTVM)
 D BACK
 Q
ILIST ;LIST ITEM TEXT
 K ^TMP($J,"APCLLTVR")
 N J,X,Y,Z,ZZ
 S ZZ="ZL APCLLT S A=""I""_J,A=$T(@A)"
 S VALMCNT=0
 K X
 S $E(X,5)="NO.  INSERT"
 D Z(X)
 K X
 S $E(X,5)="---  --------------------"
 D Z(X)
 ;F J=3:1:7 D
 F J=1:1:7 D
 .X ZZ
 .Q:A=""
 .S A=$P(A,";;",2)
 .K X
 .S $E(X,5)=J
 .S $E(X,10)=A
 .D Z(X)
 S X=""
 D Z(X)
 S X="You can include any of the INSERTS listed above by entering the NO. surrounded"
 D Z(X)
 S X="by the '|' character.  For example, to include the patient's name and address"
 D Z(X)
 S X="you can add 2 lines to your letter such as:"
 D Z(X)
 S X=""
 D Z(X)
 S X="|1| |2| (or you can use |FIRST NAME| |LAST NAME|)"
 D Z(X)
 S X="|4| (or you can use |ADDRESS|)"
 D Z(X)
 S X=""
 D Z(X)
 S X="This will add 1 line for the name and multiple lines for street, city, etc."
 D Z(X)
 S X=""
 D Z(X)
 S X="Please note that you can only use inserts from the list above."
 D Z(X)
 Q
PARSE ;DIVIDE UP THE LETTER CONTENT
 N I,J,K,X,Y,Z,ZZ,APCLLTTP
 S (Z,ZZ)=""
 S (J,X)=0
 F  S X=$O(^APCLLET(APCLLTLD,1,X)) Q:'X  D
 .S Y=$G(^APCLLET(APCLLTLD,1,X,0))
 .Q:Y=""
 .I Y["|" D VARS
 .D LINE
 Q:'$D(APCLLTTP)
 S %X="APCLLTTP("
 S %Y="^APCLLET("_APCLLTLD_",1,"
 D %XY^%RCR
 Q
VARS ;CONVERT VARIABLES
 N I,J,K,X,Z
 S ZZ="ZL APCLLT S X=""I""_J,X=$T(@X)"
 F I=2:2 S J=$P(Y,"|",I) Q:J=""  D:J
 .X ZZ
 .S Z=$P(X,";;",3)
 .S X=$P(X,";;",2)
 .S Y=$P(Y,("|"_J_"|"))_"|"_X_"|"_$P(Y,("|"_J_"|"),2)
 Q
LINE ;
 I $L(Y)<81 D  Q
 .S J=J+1
 .S APCLLTTP(J,0)=Y
 F I=1:1 S K=$P(Y," ",I) Q:$P(Y," ",I,99)=""  D
 .I $L(Z_" "_K)>80 D  Q
 ..S J=J+1
 ..S APCLLTTP(J,0)=Z
 ..S Z=""
 .I Z="" S Z=K
 .E  S Z=Z_" "_K
 I $L(Z) S J=J+1,APCLLTTP(J,0)=Z
 Q
PATLET ;EP;TO SELECT AND PROCESS PATIENT LETTER
 D SELECT
 Q:'$G(APCLLTLD)
 S APCLLTJB=$H_$J
 D ZIS
 Q
LIST ;LIST LETTERS
 K APCLLTTP
 N APCL,APCLLTX,APCLLTY,APCLLTZ
 W @IOF
 W !!?5,"APCLLT letters currently on file:"
 W !!,"NO.  LETTER"
 W ?27,"NO.  LETTER"
 W ?54,"NO.  LETTER"
 W !,"---  --------------------"
 W ?27,"---  --------------------"
 W ?54,"---  --------------------"
 S APCLLTJ=0
 S APCL=""
 F  S APCL=$O(^APCLLET("B",APCL)) Q:APCL=""  D
 .S APCLLTX=0
 .F  S APCLLTX=$O(^APCLLET("B",APCL,APCLLTX)) Q:'APCLLTX  D
 ..S APCLLTY=$G(^APCLLET(APCLLTX,0))
 ..Q:APCLLTY=""
 ..I $G(APCLREG),$P(APCLLTY,U,4)'=APCLREG Q
 ..S APCLLTJ=APCLLTJ+1
 ..S APCLLTTP(APCLLTJ)=APCLLTX_U_APCL
 ..W:APCLLTJ#3=1 !
 ..W:APCLLTJ#3=2 ?27
 ..W:APCLLTJ#3=0 ?53
 ..W $J(APCLLTJ,2),"   "
 ..W $E(APCL,1,20)
 Q
FIRST ;EP;TO PRINT PATIENT NAME IN A LETTER
 S Z=$P($G(^DPT(DFN,0)),U)
 S Z=$P($P(Z,",",2)," ")
 Q
LAST ;EP;TO PRINT PATIENT NAME IN A LETTER
 S Z=$P($G(^DPT(DFN,0)),U)
 S Z=$P(Z,",")
 Q
CHART ;EP;TO PRINT PATIENT CHART NUMBER
 S Z="CHART NO.: "_$P($G(^AUPNPAT(DFN,41,DUZ(2),0)),U,2)
 Q
ADDRESS ;EP;TO PRINT PATIENT'S ADDRESS IN A LETTER
 S Z=$G(^DPT(DFN,.11))
 W !
 W:$G(APCLZZZ)]"" ?$L(APCLZZZ)
 W $P(Z,U)
 I $P(Z,U,2) D
 .W !
 .W:$G(APCLZZZ)]"" ?$L(APCLZZZ)
 .W $P(Z,U,2)
 I $P(Z,U,3) D
 .W !
 .W:$G(APCLZZZ)]"" ?$L(APCLZZZ)
 .W $P(Z,U,3)
 W !
 W:$G(APCLZZZ)]"" ?$L(APCLZZZ)
 W $P(Z,U,4),", ",$P($G(^DIC(5,+$P(Z,U,5),0)),U,2),"  ",$P(Z,U,6)
 S (Z,ZZ)=""
 Q
FOLLOW ;EP;TO PRINT FOLLOW-UP MESSAGE
 S APCLLT("STATUS")=$E($G(APCLLT("STATUS")))
 Q
PRIMARY ;EP;TO PRINT PROVIDER NAME IN A LETTER
 S Z=+$P($G(^AUPNPAT(DFN,0)),U,14)
 S Z=$P($G(^VA(200,Z,0)),U)
 S Z=$P($P(Z,",",2)," ")_" "_$P(Z,",")
 Q
CASE ;EP;TO PRINT PROVIDER NAME IN A LETTER
 Q:'$G(APCLREG)
 S Z=+$P($G(^ACM(41,APCLREG,"DT")),U,6)
 S Z=$P($G(^VA(200,Z,0)),U)
 S Z=$P($P(Z,",",2)," ")_" "_$P(Z,",")
 Q
PHN ;EP;TO PRINT PHN NAME IN A LETTER
 Q:'$G(APCLREG)
 S Z=+$P($G(^ACM(41,APCLREG,"DT")),U,7)
 S Z=$P($G(^VA(200,Z,0)),U)
 S Z=$P($P(Z,",",2)," ")_" "_$P(Z,",")
 Q
DELETE ;DELETE LETTER
 D S1
 I $D(APCLLTQT) K APCLLTQT D BACK Q
 S DA=APCLLTLD
 S DIK="^APCLLET("
 D ^DIK
 D BACK
 Q
Z(X) ;SET TMP NODE    
 S VALMCNT=VALMCNT+1
 S ^TMP($J,"APCLLTVR",VALMCNT,0)=X
 Q
DATE ;EP;TO PRINT LETTER DATE
 N Y
 S Y=DT
 X ^DD("DD")
 S Z=Y
 Q
COHORT ;EP;TO ESTABLISH COHORT OF PATIENTS TO PRINT
 D SELECT
 Q:'$G(APCLLTLD)
 D C1
 Q:$D(APCLLTQT)
 S APCLBROW=""
 Q:'$D(^TMP($J,"APCLLT CUSTOM LETTER",APCLLTJB))
 S APCLRTN="CPRINT^APCLLT"
 D ZIS
 Q
C1 K ^TMP($J,"APCLLT CUSTOM LETTER")
 S APCLLTJB=$H_$J
 N DIR
 S DIR(0)="SO^1:Individual Patient(s);2:Search Template of Patients;3:Members of a Case Management Register"
 S DIR("A")="Create list for letters by"
 D ^DIR
 K DIR
 I 'Y S APCLLTQT="" Q
 I Y=1 D PATIENT
 I Y=2 D TEMPLATE
 I Y=3 D REGISTER K APCLREG
 I '$D(^TMP($J,"APCLLT CUSTOM LETTER")) W !!,"No patients selected." D PAUSE Q
 Q
PATIENT ;SELECT INDIVIDUAL PATIENTS TO PRINT LETTER
 K APCLLTQT
 F  D P1 Q:$D(APCLLTQT)
 K APCLLTQT
 Q
P1 ;
 N DIC
 S DIC="^AUPNPAT("
 S DIC(0)="AEMQZ"
 S DIC("S")="I '$G(^DPT(+Y,.35))"
 S DIC("A")="Name, Chart No. or DOB: "
 D ^DIC
 K DIC
 I Y<1 S APCLLTQT="" Q
 S ^TMP($J,"APCLLT CUSTOM LETTER",APCLLTJB,+Y)=""
 Q
TEMPLATE ;SELECT SEARCH TEMPLATE
 N DIC
 S DIC="^DIBT("
 S DIC(0)="AEMQZ"
 S DIC("S")="I $O(^DIBT(+Y,1,0))"
 D ^DIC
 K DIC
 Q:'+Y
 M ^TMP($J,"APCLLT CUSTOM LETTER",APCLLTJB)=^DIBT(+Y,1)
 Q
CPRINT ;EP;TO PRINT LETTERS FROM LIST OR TEMPLATE
 S DFN=0,APCLXCNT=0
 F  S DFN=$O(^TMP($J,"APCLLT CUSTOM LETTER",APCLLTJB,DFN)) Q:'DFN  S APCLXCNT=APCLXCNT+1 D PRINT
 Q
PAUSE ;EP
 S DIR(0)="EO",DIR("A")="Press enter to continue...." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
REGISTER ;
 K DIC,APCLREG
 S DIC(0)="AEMQ"
 S (DIC,DIE)="^ACM(41.1,",DIC("A")="REGISTER: "
 S APCLZDIC="^ACM(41.1)",DIC("S")="I $D(@APCLZDIC@(+Y,""AU"",""B"",DUZ))"
 D ^DIC
 I Y=-1 W !!,"No register selected." Q
 S APCLREG=+Y
  ;which status
 S DIR(0)="9002241,1",DIR("A")="Which status",DIR("B")="A" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) Q
 S APCLSTAT=Y
REG1 ;
 ;gather up patients from register in ^XTMP
 K ^TMP($J,"APCLLT CUSTOM LETTER",APCLLTJB) S APCLCNT=0,X=0 F  S X=$O(^ACM(41,"B",APCLREG,X)) Q:X'=+X  D
 .I APCLSTAT]"",$P($G(^ACM(41,X,"DT")),U,1)=APCLSTAT S APCLCNT=APCLCNT+1,^TMP($J,"APCLLT CUSTOM LETTER",APCLLTJB,$P(^ACM(41,X,0),U,2))="" Q
 .I APCLSTAT="" S APCLCNT=APCLCNT+1,^TMP($J,"APCLLT CUSTOM LETTER",APCLLTJB,$P(^ACM(41,X,0),U,2))=""
 I '$D(^TMP($J,"APCLLT CUSTOM LETTER",APCLLTJB)) W !,"No patients with that status in that register!" Q
 W !!,"There are ",APCLCNT," patients in the ",$P(^ACM(41.1,APCLREG,0),U)," register with a status of ",APCLSTAT,".",!!
 D PAUSE
 Q
