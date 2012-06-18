APCLP20 ; IHS/BJI/GRL - Routine to create bulletin  [ 01/16/05  2:03 PM ]
 ;;3.0;IHS PCC REPORTS;**19**;FEB 05, 1997
 ;;
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0
 I '$$INSTALLD("ATX*5.1*8") D SORRY(2)
 I '$$INSTALLD("APCL*3.0*19") D SORRY(2)
 ;I '$$INSTALLD("AMQQ*2.0*20") D SORRY(2)
 Q
 ;
PRE ;EP
 F DA=1:1:900 S DIK="^APCLVSTS(" D ^DIK
 ;kill off lister entries
 F DA=1:1:40 S DIK="^APCLRECD(" D ^DIK
 F DA=1:1:10 S DIK="^APCLDMTX(" D ^DIK
 F DA=1:1:40 S DIK="^APCLBMI(" D ^DIK
 F DA=1:1:40 S DIK="^APCLCNTL(" D ^DIK
 F DA=1:1:20 S DIK="^APCLPDES(" D ^DIK
 K ^APCLBMI("H")
 S DA=$O(^DIC(19,"B","APCL DM2005 RUN AUDIT",0)) I DA S DIE="^DIC(19,",DR="2///@" D ^DIE K DIE,DA,DR
 Q
POST ;EP
OPT ;add new options
 S X=$$DELETE^XPDMENU("APCL M MAN APC REPORTS/PCC","APCL P APC DX CATEGORY")
 S X=$$DELETE^XPDMENU("APCL M DX/PROC COUNT REPORTS","APCL P QA POVAPC")
 S X=$$ADD^XPDMENU("APCL M MAN PATIENT LISTINGS","APCL P INTERNET ACCESS","PINT")
 I 'X W "Attempt to add Internet access report option failed.." H 3
 ;
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
 S X=$O(^APCLPDES("B","V3P20",0))
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
INSTALLD(APCLSTAL) ;EP - Determine if patch APCLSTAL was installed, where
 ; APCLSTAL is the name of the INSTALL.  E.g "AG*6.0*11".
 ;
 NEW APCLY,DIC,X,Y
 S X=$P(APCLSTAL,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 D IMES Q 0
 S DIC=DIC_+Y_",22,",X=$P(APCLSTAL,"*",2)
 D ^DIC
 I Y<1 D IMES Q 0
 S DIC=DIC_+Y_",""PAH"",",X=$P(APCLSTAL,"*",3)
 D ^DIC
 S APCLY=Y
 D IMES
 Q $S(APCLY<1:0,1:1)
IMES ;
 D MES^XPDUTL($$CJ^XLFSTR("Patch """_APCLSTAL_""" is"_$S(Y<1:" *NOT*",1:"")_" installed.",IOM))
 Q
SORRY(X) ;
 KILL DIFQ
 I X=3 S XPDQUIT=2 Q
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....FIX IT!",IOM)
 Q
