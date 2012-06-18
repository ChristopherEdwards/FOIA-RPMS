APCLP13 ; IHS/CMI/LAB - Routine to create bulletin ; [ 05/20/03 10:01 AM ]
 ;;3.0;IHS PCC REPORTS;**13**;FEB 15, 1997
 ;;
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 Q
 ;
PRE ;EP
 F DA=1:1:900 S DIK="^APCLVSTS(" D ^DIK
 ;kill off lister entries
 F DA=1:1:40 S DIK="^APCLRECD(" D ^DIK
 F DA=1:1:4 S DIK="^APCLDMTX(" D ^DIK
 F DA=1:1:40 S DIK="^APCLBMI(" D ^DIK
 K ^APCLBMI("H")
 Q
DRUGS ;set up drug taxonomies
 S ATXFLG=1
 S APCLX="DM AUDIT ANTI-PLATELET DRUGS" D DRUG1
 S APCLX="DM AUDIT STATIN DRUGS" D DRUG1
 Q
DRUG1 ;
 W !,"Creating ",APCLX," Taxonomy..."
 S APCLDA=$O(^ATXAX("B",APCLX,0))
 Q:APCLDA  ;taxonomy already exisits
 S X=APCLX,DIC="^ATXAX(",DIC(0)="L",DIADD=1,DLAYGO=9002226 D ^DIC K DIC,DA,DIADD,DLAYGO,I
 I Y=-1 W !!,"ERROR IN CREATING ",APCLX," TAX" Q
 S APCLTX=+Y,$P(^ATXAX(APCLTX,0),U,2)=APCLX,$P(^(0),U,5)=DUZ,$P(^(0),U,8)=0,$P(^(0),U,9)=DT,$P(^(0),U,12)=173,$P(^(0),U,13)=0,$P(^(0),U,15)=50,^ATXAX(APCLTX,21,0)="^9002226.02101A^0^0"
 S DA=APCLTX,DIK="^ATXAX(" D IX1^DIK
 Q
POST ;EP
 D ^APCLP13A
 D DRUGS
 ;*** REMEMBER TO SEND APCLVSTS GLOBAL AS GLOBAL OR AS KIDS
OPT ;add 2 new options (supplement, report)
 NEW X
 S X=$$ADD^XPDMENU("APCL M MAIN DM MENU","APCL DM2003 AUDIT MENU","DM03",3)
 I 'X W "Attempt to add DM 2003 Audit Menu option failed.." H 3
 S X=$$ADD^XPDMENU("APCLMENU","APCL P QA DELETE REP DEF","RDD")
 I 'X W "Attempt to add delete option for vgen/pgen failed.." H 3
 S X=$$ADD^XPDMENU("APCLMENU","APCL M MAN DELIMITED REPORTS","DELR")
 I 'X W "Attempt to delimited reports menu failed.." H 3
 ;;Here's how to make this work:
 ;;
 ;;1. Create your message in subroutine WRITEMSG
 ;;2. Identify recipients in GETRECIP by setting APCLKEY
 ;;3. Make changes in SUBJECT and SENDER as desired
 ;;4. Rename this routine in appropriate namespace and 
 ;;   call on completion of patch or upgrade
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR ZERO.",! Q
 D HOME^%ZIS,DT^DICRW
 ;
 NEW XMSUB,XMDUZ,XMTEXT,XMY,DIFROM
 KILL ^TMP($J,"APCLBUL")
 D WRITEMSG,GETRECIP
 ;Change following lines as desired
SUBJECT S XMSUB="* * * IMPORTANT RPMS INFORMATION * * *"
SENDER S XMDUZ="Cimarron Medical Informatics"
 S XMTEXT="^TMP($J,""APCLBUL"",",XMY(1)="",XMY(DUZ)=""
 I $E(IOST)="C" W !,"Sending Mailman message to holders of the"_" "_APCLKEY_" "_"security key."
 D ^XMD
 KILL ^TMP($J,"APCLBUL"),APCLKEY
 Q
 ;
WRITEMSG ;
 S X=$O(^APCLPDES("B","V3P13",0))
 Q:'X
 S Y=0 F  S Y=$O(^APCLPDES(X,11,Y)) Q:Y'=+Y  S ^TMP($J,"APCLBUL",Y)=^APCLPDES(X,11,Y,0)
 Q
 ;
GETRECIP ;
 ;* * * Define key below to identify recipients * * *
 ;
 S CTR=0,APCLKEY="APCLZMENU"
 F  S CTR=$O(^XUSEC(APCLKEY,CTR)) Q:'CTR  S Y=CTR S XMY(Y)=""
 Q
