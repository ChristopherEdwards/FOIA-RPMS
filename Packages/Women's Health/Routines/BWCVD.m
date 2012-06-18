BWCVD ;IHS/CIM/THL/CIA - WISE WOMEN'S PROJECT;10-Mar-2003 13:39;PLS
 ;;2.0;WOMEN'S HEALTH;**3,5,7,8**;MAY 16, 1996
 ;
EN D EN1
EXIT ;EP;
 K BWCVD,BWQUIT,BWPCDDA,BWTYPE,BWPCDN,BWX
 D KILLALL^BWUTL8
 Q
EN1 ;
 D EXIT
 D SETVARS^BWUTL5
 N ERROR
 F  D PATIENT Q:$D(BWQUIT)
 Q
PATIENT ;EP
 D TITLE^BWUTL5("Add/Edit CVD Patient Case Data")
PATIENT1 ;EP
 ;---> TO AVOID @IOF AND TITLE.
 ;---> SELECT PATIENT.
 N Y
 W !!,"   Select the patient you wish to add or edit."
 D PATLKUP^BWUTL8(.Y,"ADD")
 I Y<0 S BWQUIT=1 Q
 S BWDFN=+Y
 D CDCID(BWDFN)
 D ADDEDIT
 Q
ADDEDIT ;
 K DIR
 S DIR(0)="SO^1:Add New Procedure;2:Edit Existing Procedure"
 S DIR("A")="Which function"
 W !
 D ^DIR
 K DIR
 Q:Y<1
 I Y=1 D ADD Q
 I Y=2 D LOOKUP
 Q
ADD ;ADD A PROCEDURE
 S DIR(0)="SO^1:Enrollment;2:Annual Follow-up"
 S DIR("A")="Which type of Visit"
 W !
 D ^DIR
 K DIR
 Q:Y<1
 S BWTYPE=Y
 I BWTYPE=1 D  Q:$G(BWPCDDA)
 .S BWX=0
 .F  S BWX=$O(^BWPCD("C",BWDFN,BWX)) Q:'BWX!$G(BWPCDDA)  D
 ..S X=+$G(^BWPCD(BWX,4))
 ..Q:X'=1
 ..W !,$P(^DPT(BWDFN,0),U)," Enrolled in Wise Women Project on "
 ..S Y=$P($G(^BWPCD(BWX,4)),U,2)
 ..X ^DD("DD")
 ..W Y
 ..H 3
 ..S BWPCDDA=BWX
 ..D EDIT
ADD1 ;K DIR
 ;S DIR(0)="DO"
 ;S DIR("A")="WW Enrollment Date"
 ;S Y=DT
 ;X ^DD("DD")
 ;S DIR("B")=Y
 ;D ^DIR
 ;K DIR
 ;Q:'Y
 ;S BWDATE=Y
 S BWPCDN=$O(^BWPN("B","WISE WOMAN",0))
 I 'BWPCDN D  Q
 .W !,"The WISE WOMAN procedure is missing."
 .W !,"Contact the computer department."
 D DATECHK^BWPROC Q:BWPOP
 S BWACC=$$ACCSSN^BWUTL5(BWPCDN)
 I BWACC']"" D  Q
 .W !!?5,*7,"Unable to generate accession number. Contact your site manager."
 .S ERROR=-1 D DIRZ^BWUTL3
 ;K DA,DR,DIE
 N DRSTR
 S DRSTR=".02////"_BWDFN_";.03////"_BWPCDT_";.04////"_BWPCDN_";.1////"_$G(DUZ(2))_";.18////"_DUZ_";.19///"_$$DT^XLFDT_";.34////"_$G(DUZ(2))_";4.01////"_BWTYPE_";4.02////"_BWPCDT_";.12////"_BWPCDT_";4.33////1"
 D FILE^BWFMAN(9002086.1,DRSTR,"ML",BWACC,9002086,.Y)
 ;S DIC="^BWPCD("
 ;S DIC(0)="L"
 ;S DIC("DR")=".02////"_BWDFN_";.03////"_BWDATE_";4.01////"_BWTYPE_";4.02////"_BWDATE_";.12////"_BWDATE_";4.33////1"
 ;D FILE^DICN
 ;K DIC
 S BWPCDDA=+Y
 I BWPCDDA=-1 D  Q
 .W !!?5,*7,"Unable to create new procedure. Contact your site manager."
 .S ERROR=-1 D DIRZ^BWUTL3
EDIT D SCREEN(BWPCDDA)
 Q
LOOKUP ;LOOKUP EXISTING WW PROCEDURE
 S (BWX,X)=0
 F  S BWX=$O(^BWPCD("C",BWDFN,BWX)) Q:'BWX!X  D
 .I +$G(^BWPCD(BWX,4))=1 S X=1 Q
 I X'=1 D  Q
 .W !,$P(^DPT(BWDFN,0),U)," is not Enrolled in Wise Women Project."
 .W !,"She will now be enrolled."
 .H 3
 .S BWTYPE=1
 .D ADD1
 S X=BWDFN
 S D="C"
 S DIC="^BWPCD("
 S DIC(0)="EQZ"
 S DIC("S")="I $E(^(0),1,2)=""WW"",+$G(^(4))'=3"
 D IX^DIC
 Q:Y<1
 D SCREEN(+Y)
 Q
 ;
SCREEN(BWPCDDA) ;EP
 ;---> EDIT PATIENT CASE DATA WITH SCREENMAN.
 ;---> REQUIRED VARIABLES: BWDFN=DFN OF PATIENT.
 N DR,DIR,STATUS
 S DR="[BW CVD PAGE 1]"
 D DDS^BWFMAN(9002086.1,DR,BWPCDDA,"","",.BWQUIT)
 S STATUS=+$$GET1^DIQ(9002086.1,BWPCDDA,4.33,"I")
 I STATUS'=2 D
 .W !,"Do you wish to CLOSE this procedure?"
 .S DIR(0)="Y",DIR("B")="NO" D ^DIR K DIR W !
 .I Y D
 ..D DIE^BWFMAN(9002086.1,"4.33////2",BWPCDDA,.BWPOP)
 .E  I 'STATUS D
 ..D DIE^BWFMAN(9002086.1,"4.33////1",BWPCDDA,.BWPOP)
 Q
 Q:BWPOP
 K DIR
 W !,"Do you wish to PRINT this patient's Case Data?"
 S DIR(0)="Y"
 S DIR("B")="NO"
 D ^DIR
 K DIR
 W !
 D:Y PRTCASE^BWPATP(BWDFN)
 Q
 ;
CDCID(BWDFN) ;
 ;---> ASSIGN A CDCID# TO THIS PATIENT.
 N X S X=$$CDCID^BWUTL5(BWDFN,DUZ(2))
 Q:X']""
 D DIE^BWFMAN(9002086,".2////"_X,BWDFN,.BWPOP)
 Q
NAV(DA) ;EP;TO CALCULATE THE AVERAGE NUTRITION SCORE
 Q:'$G(DA)
 N X,Y,Z,J
 S X=$G(^BWPCD(DA,8))
 S Y=0
 F J=1:1:5 S:$P(X,U,J)'=99 Y=Y+$P(X,U,J)
 Q:'Y 0
 S Z=0
 F J=1:1:5 S:$P(X,U,J)&($P(X,U,J)'=99) Z=Z+1
 Q:'Z 0
 S SCORE=$E(Y/Z,1,4)
 Q SCORE
PAV(DA) ;EP;TO CALCULATE THE AVERAGE PHYSICAL ACTIVITY SCORE
 Q:'$G(DA)
 N X,Y,Z,J
 S X=$G(^BWPCD(DA,6))
 S Y=0
 F J=1:1:8 S:$P(X,U,J)'=99 Y=Y+$P(X,U,J)
 Q:'Y 0
 S Z=0
 F J=1:1:8 S:$P(X,U,J)&($P(X,U,J)'=99) Z=Z+1
 Q:'Z 0
 S SCORE=$E(Y/Z,1,4)
 Q SCORE
