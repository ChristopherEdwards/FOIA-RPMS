BWMPMAIN ;IHS/CIA/PLS - Main driver for Mammography Project Add/Edit ;01-Oct-2003 16:55;PLS
 ;;2.0;WOMEN'S HEALTH;**9**;04-Apr-2003 11:31
 ;=================================================================
EN D EN1
 Q
 ; Main loop
EN1 ;
 N X,BWQUIT
 F  Q:$$PATSEL=-1
 Q
PATSEL() ;
 D TITLE^BWUTL5("Add/Edit Mammography Project Data")
 ; PATSEL1() ;
 N Y,BWDFN
 W !!,"  Select the patient you wish to add or edit."
 D PATLKUP^BWUTL8(.Y,"ADD")
 Q:Y<0 -1
 S BWDFN=+Y
 D CDCID(BWDFN)
 D ADDEDIT
 Q 0
 ;
ADDEDIT ;
 N DIR
 S DIR(0)="SO^1:Add New Procedure;2:Edit Existing Procedure"
 S DIR("A")="Which function"
 W !
 D ^DIR
 I Y=1 D
 .D ADD
 E  I Y=2 D
 .D LOOKUP
 Q
ADD ; Add a procedure
 N DRSTR,BWPCDDA
 S BWPCDN=$O(^BWPN("B","MAMMOGRAPHY PROJECT",0))
 I 'BWPCDN D  Q
 .W !,"The MAMMOGRAPHY PROJECT procedure is missing."
 .W !,"Contact the computer department."
 I BWPCDN&($$GET1^DIQ(9002086.2,BWPCDN,.18,"I")=1) D  Q
 .I  D
 ..W !,"The MAMMOGRAPHY PROJECT procedure is INACTIVE."
 ..W !,"Contact the site manager."
 ..S BWQUIT=1
 D DATECHK^BWPROC Q:BWPOP
 S BWACC=$$ACCSSN^BWUTL5(BWPCDN)
 I BWACC']"" D  Q
 .W !!?5,*7,"Unable to generate accession number. Contact your site manager."
 .S ERROR=-1 D DIRZ^BWUTL3
 S DRSTR=".02////"_BWDFN_";.03////"_BWPCDT_";.04////"_BWPCDN_";.1////"_$G(DUZ(2))_";.12////"_BWPCDT_";.18////"_DUZ_";.19///"_$$DT^XLFDT_";.34////"_$G(DUZ(2))
 D FILE^BWFMAN(9002086.1,DRSTR,"ML",BWACC,9002086,.BWPCDDA)
 I BWPCDDA=-1 D  Q
 .W !!?5,*7,"Unable to create new procedure. Contact your site manager."
 .S ERROR=-1 D DIRZ^BWUTL3
 ;
EDIT D SCREEN(+BWPCDDA)
 Q
 ; Call ScreenMan interface engine
SCREEN(BWPCDDA) ;
 N DR
 S DR="[BW MP MAIN]"
 D DDS^BWFMAN(9002086.1,DR,BWPCDDA,"","",.BWQUIT)
 Q
LOOKUP ; Lookup existing Mammography Project procedure
 N BWX,FLG
 N D,DIC,Y,X
 S (BWX,FLG)=0
 F  S BWX=$O(^BWPCD("C",BWDFN,BWX)) Q:'BWX!FLG  D
 .S:+$P($G(^BWPCD(BWX,0)),U,4)=44 FLG=1
 I 'FLG D  Q
 .;W !,$$GET1^DIQ(2,BWDFN,.01,"E")," is not enrolled in the Mammography Project."
 .;W !,"She will now be enrolled."
 .D ADD
 E  D  Q
 .S D="C",DIC="^BWPCD(",DIC(0)="EQZ"
 .S X=BWDFN,DIC("S")="I $P(^(0),U,4)=44"
 .D IX^DIC
 .D:Y>0 SCREEN(+Y)
 Q
 ; Assign a CDCID # to this patient
CDCID(BWDFN) ;
 N X
 S X=$$CDCID^BWUTL5(BWDFN,DUZ(2))
 Q:X']""
 D DIE^BWFMAN(9002086,".2////"_X,BWDFN,.BWPOP)
 Q
 ;
HELP Q
