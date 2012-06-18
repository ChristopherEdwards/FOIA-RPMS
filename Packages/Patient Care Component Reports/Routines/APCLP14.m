APCLP14 ; IHS/BJI/GRL - Routine to create bulletin  [ 07/16/03  4:33 PM ]
 ;;3.0;IHS PCC REPORTS;**14**;FEB 15, 1997
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
POST ;EP
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
 S X=$O(^APCLPDES("B","V3P14",0))
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
