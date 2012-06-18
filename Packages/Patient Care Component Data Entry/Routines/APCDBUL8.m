APCDBUL8 ; IHS/CMI/LAB - Routine to create bulletin ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;;Borrowed from ACHSP1, ACHSP1A
 ;;
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR ZERO.",! Q
 D HOME^%ZIS,DT^DICRW
 ;
 NEW XMSUB,XMDUZ,XMTEXT,XMY,DIFROM
 KILL ^TMP($J,"APCDBUL")
 D WRITEMSG,GETRECIP
 ;Change following lines as desired
SUBJECT S XMSUB="* * * IMPORTANT RPMS INFORMATION * * *"
SENDER S XMDUZ="Cimarron Medical Informatics"
 S XMTEXT="^TMP($J,""APCDBUL"",",XMY(1)="",XMY(DUZ)=""
 I $E(IOST)="C" W !,"Sending Mailman message to holders of the"_" "_APCDKEY_" "_"security key."
 D ^XMD
 KILL ^TMP($J,"APCDBUL"),APCDKEY
 Q
 ;
WRITEMSG ;
 S %=0
 S APCDDA=$O(^APCDSUPP("B","APCD*2.0*8",0))
 Q:'APCDDA
 S APCDX=0 F  S APCDX=$O(^APCDSUPP(APCDDA,11,APCDX)) Q:APCDX'=+APCDX  D
 .S %=%+1
 .S ^TMP($J,"APCDBUL",%)=$G(^APCDSUPP(APCDDA,11,APCDX,0))
 Q
 ;;  
 ;;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ;;+     This message is intended to advise you of changes,        +
 ;;+     upgrades or other important RPMS information
 ;;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ;;  
 ;;###
 ;
GETRECIP ;
 ;* * * Define key below to identify recipients * * *
 ;
 S CTR=0,APCDKEY="APCDZMENU"
 F  S CTR=$O(^XUSEC(APCDKEY,CTR)) Q:'CTR  S Y=CTR S XMY(Y)=""
 Q
