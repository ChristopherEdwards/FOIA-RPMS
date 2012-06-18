BDMBUL ; cmi/anch/maw - Routine to create bulletin ;
 ;;2.0;DIABETES MANAGEMENT SYSTEM;;AUG 11, 2006
 ;;
 ;;Here's how to make this work:
 ;;
 ;;1. Create your message in subroutine WRITEMSG
 ;;2. Identify recipients in GETRECIP by setting appropriate key
 ;;3. Make changes in SUBJECT and SENDER as desired
 ;;4. Callthis routine on completion of patch or upgrade
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR ZERO.",! Q
 D HOME^%ZIS,DT^DICRW
 ;
 NEW XMSUB,XMDUZ,XMTEXT,XMY,DIFROM
 KILL ^TMP($J,"BDMBUL")
 D WRITEMSG,GETRECIP
 D ADDMENU
 ;Change following lines as desired
SUBJECT S XMSUB="* * * IMPORTANT RPMS INFORMATION * * *"
SENDER S XMDUZ="Diabetes Management System Coordinator" ;IHS/CMI/TMJ PATCH #5
 S XMTEXT="^TMP($J,""BDMBUL"",",XMY(1)="",XMY(DUZ)=""
 I $E(IOST)="C" W !,"Sending Mailman message to holders of the"_" "_BDMKEY_" "_"security key."
 D ^XMD
 KILL ^TMP($J,"BDMBUL"),BDMKEY
 Q
 ;
WRITEMSG ;
 F %=3:1 S X=$P($T(WRITEMSG+%),";",3) Q:X="###"  S ^TMP($J,"BDMBUL",%)=X
 Q
 ;;  
 ;;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ;;+     This message is intended to advise you of changes,        +
 ;;+     upgrades or other important RPMS information
 ;;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ;;  
 ;;PCC Diabetes Management System Version 2.0 has recently been installed, and
 ;;includes the following modifications/enhancements:
 ;;   
 ;;1. Various technical programming changes.
 ;;
 ;;2. Visual Diabetes GUI Client functionality.
 ;;
 ;;
 ;;  
 ;;+++++++++++++++++++++ End of Announcement +++++++++++++++++++++++
 ;;###
 ;
GETRECIP ;
 ;* * * Define key below to identify recipients * * *
 ;
 S CTR=0,BDMKEY="BDMZMENU"
 F  S CTR=$O(^XUSEC(BDMKEY,CTR)) Q:'CTR  S Y=CTR S XMY(Y)=""
 Q
 ;
ADDMENU ;-- readd APCL, APCH, and APCD options to the BDMMENU
 N X
 F BDMX="APCL DM2005 DM AUDIT TAX CHECK" D
 .S BDMY="D5TC"
 .S X=$$ADD^XPDMENU("BDM TAXONOMY SETUP",BDMX,BDMY)
 ;
 F BDMX="APCL DM2005 AUDIT TAX UPDATE" D
 .S BDMY="D5TU"
 .S X=$$ADD^XPDMENU("BDM TAXONOMY SETUP",BDMX,BDMY)
 ;
 F BDMX="APCL DM2005 PREDIAB TAX CHECK" D
 .S BDMY="PDTC"
 .S X=$$ADD^XPDMENU("BDM TAXONOMY SETUP",BDMX,BDMY)
 ;
 F BDMX="APCL DM2005 PREDIAB TAX UPDATE" D
 .S BDMY="PDTU"
 .S X=$$ADD^XPDMENU("BDM TAXONOMY SETUP",BDMX,BDMY)
 ;
 S X=$$ADD^XPDMENU("BDMMENU","APCHSBRW","BHS")
 I 'X W !,"Attempt to add Health Summary Browser Option Failed" H 1
 S X=$$ADD^XPDMENU("BDMMENU","APCL M MAIN DM MENU","DA")
 I 'X W !,"Attempt to add Diabetes Audit Menu Option Failed" H 1
 S X=$$ADD^XPDMENU("BDMMENU","APCDEDMUPD","DMU")
 I 'X W !,"Attempt to add Update Patient Data Option Failed" H 1
 S X=$$ADD^XPDMENU("BDMMENU","APCHSUM","HS")
 I 'X W !,"Attempt to add Health Summary Option Failed" H 1
 S X=$$ADD^XPDMENU("BDMMENU","APCHSUMM","MHS")
 I 'X W !,"Attempt to add Multiple Health Summary Option Failed" H 1
 S X=$$ADD^XPDMENU("BDMMENU","AMQQMENU","QMAN")
 I 'X W !,"Attempt to add Q Man Option Failed" H 1
 S X=$$ADD^XPDMENU("BDM REGISTER MAINTENANCE","APCL TAXONOMY SETUP","TM")
 I 'X W !,"Attempt to add Taxonomy Setup Option Failed" H 1
 S X=$$ADD^XPDMENU("BDM REGISTER MAINTENANCE","APCL FLOW SHEET SETUP","FS")
 I 'X W !,"Attempt to add Flow Sheet Setup Option Failed" H 1
 Q
 ;
