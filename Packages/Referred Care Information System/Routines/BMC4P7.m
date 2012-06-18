BMC4P7 ;IHS/OIT/FCJ - BMC 4.0 PATCH 7 ; 16 Feb 2011  2:54 PM
 ;;4.0;REFERRED CARE INFO SYSTEM;**7**;JAN 09, 2006;Build 3
 ;ORIGINAL ROUTINE FR BMC4P6
 ;
 I '$G(IOM) D HOME^%ZIS
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR 0." D SORRY(2) Q
 ;
 I '$L($G(DUZ(0))) W !,"DUZ(0) UNDEFINED OR NULL." D SORRY(2) Q
 ;
 I '(DUZ(0)["@") W:'$D(ZTQUEUED) !,"DUZ(0) DOES NOT CONTAIN AN '@'." D SORRY(2) Q
 ;
 S X=$$GET1^DIQ(200,DUZ,.01)
 W !!,$$CJ^XLFSTR("Hello, "_$P(X,",",2)_" "_$P(X,","),IOM)
 W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_" V "_$P($T(+2),";",3)_".",IOM)
 ;
 NEW IORVON,IORVOFF
 S X="IORVON;IORVOFF"
 D ENDR^%ZISS
 ;
 I $$VCHK("BMC","4.0",2,"'=")
 I $$VCHK("XU","8.0",2,"<")
 I $$VCHK("DI","22.0",2,"<")
 I '$$INSTALLD("AUPN*99.1*16") S BMCQUIT=2 D SORRY(BMCQUIT)
 I '$$INSTALLD("ATX*5.1*5") S BMCQUIT=2 D SORRY(BMCQUIT)
 I '$$INSTALLD("AUT*98.1*20") S BMCQUIT=2 D SORRY(BMCQUIT)
 I $$VCHK("LEX","2.0",2,"<")
 I '$$INSTALLD("AICD*3.51*7") S BMCQUIT=2 D SORRY(BMCQUIT)
 I '$$INSTALLD("OR*3.0*190") S BMCQUIT=2 D SORRY(BMCQUIT)
 I '$$VCHK("BQI","2.0",2,"<")
 I '$O(^DIC(19,"B","AGGRPC","")) W !!,"AGG GUI REGISTRATION 1.0 not installed" S BMCQUIT=2 D SORRY(BMCQUIT)
 E  W !,"                   AGG GUI REGISTRATION ..... Present"
 ;
 NEW DA,DIC
 S X="BMC",DIC="^DIC(9.4,",DIC(0)="",D="C"
 D IX^DIC
 I Y<0,$D(^DIC(9.4,"C","BMC")) D
 . W !!,*7,*7,$$CJ^XLFSTR("You Have More Than One Entry In The",IOM),!,$$CJ^XLFSTR("PACKAGE File with an ""BMC"" prefix.",IOM)
 . W !,$$CJ^XLFSTR(IORVON_"One entry needs to be deleted."_IORVOFF,IOM)
 . D SORRY(2)
 ;
 I $G(XPDQUIT) W !,$$CJ^XLFSTR(IORVON_"You will need to update package(s) before proceeding."_IORVOFF,IOM),!!,*7,*7,*7 Q
 W !!,$$CJ^XLFSTR("ENVIRONMENT OK.",IOM)
 D HELP^XBHELP("INTROE","BMC4P7")
 I '$$DIR^XBDIR("E","","","","","",1) D SORRY(2) Q
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0 D HELP^XBHELP("INTROI","BMC4P7") I '$$DIR^XBDIR("E","","","","","",1) D SORRY(2)
 Q
 ;
SORRY(X) ;
 KILL DIFQ
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....Need to update package!",IOM)
 Q
 ;
VCHK(BMCPRE,BMCVER,BMCQUIT,BMCCOMP) ; Check versions needed.
 ;  
 NEW BMCV
 S BMCV=$$VERSION^XPDUTL(BMCPRE)
 W !,$$CJ^XLFSTR("Need "_$S(BMCCOMP="<":"at least ",1:"")_BMCPRE_" v "_BMCVER_"....."_BMCPRE_" v "_BMCV_" Present",IOM)
 I @(BMCV_BMCCOMP_BMCVER) D SORRY(BMCQUIT) Q 0
 Q 1
 ;
INSTALLD(BMC) ; Determine if patch BMC was installed, where BMC is
 ; the name of the INSTALL.  E.g "AVA*93.2*12".
 ;
 NEW DIC,X,Y,P
 ;  lookup package.
 S X=$P(BMC,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 Q 0
 ;  lookup version.
 S DIC=DIC_+Y_",22,",X=$P(BMC,"*",2)
 D ^DIC
 I Y<1 Q 0
 ;  lookup patch.
 S DIC=DIC_+Y_",""PAH"",",X=$P(BMC,"*",3)
 D ^DIC
 I Y<1 S P=DIC_"""B"","_X_")" I $O(@P)'="" S Y=1
 I Y>0 W !,$$CJ^XLFSTR("Need at least "_BMC_"....."_BMC_" Present",IOM)
 I Y<0 W !,$$CJ^XLFSTR("Need at least "_BMC_".....",IOM)
 Q $S(Y<1:0,1:1)
 ;
 ; -----------------------------------------------------
PRE ;EP - From KIDS.
 I $$NEWCP^XPDUTL("PRE1","AUDS^BMC4P7")
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 Q
 ;
POST ;EP - From KIDS.
 ; --- Restore dd audit settings.
 S %="AUDR^BMC4P7"
 I $$NEWCP^XPDUTL("POS1-"_%,%)
 ;
 ; --- Set new Index "BA" and "BB"
 S %="INDX^BMC4P7"
 I $$NEWCP^XPDUTL("POS2-"_%,%)
 ;
 ; --- Add Provider/Vendor Option
 S %="P5^BMC4P7"
 I $$NEWCP^XPDUTL("POS3-"_%,%)
 ;
 ; --- Add MED HX Option and fx CHS 2010 PO #'s
 S %="P6^BMC4P7"
 I $$NEWCP^XPDUTL("POS4-"_%,%)
 ;
 ; --- Add Report Option for printing C32s for Active referrals
 S %="P7^BMC4P7"
 I $$NEWCP^XPDUTL("POS5-"_%,%)
 ;
 ; --- Send mail message of install.
 S %="MAIL^BMC4P7"
 I $$NEWCP^XPDUTL("POS6-"_%,%)
 ;
 Q
 ;
MAIL ;
 D BMES^XPDUTL("BEGIN Delivering MailMan message to select users.")
 NEW DIFROM,XMSUB,XMDUZ,XMTEXT,XMY
 KILL ^TMP("BMC4P7",$J)
 D RSLT(" --- BMC v 4.0 Patch 1, has been installed into this uci ---")
 F %=1:1 D RSLT($P($T(GREET+%),";",3)) Q:$P($T(GREET+%+1),";",3)="###"
 S %=0
 F  S %=$O(^XTMP("XPDI",XPDA,"BLD",XPDBLD,1,%)) Q:'%   D RSLT(^(%,0))
 S XMSUB=$P($P($T(+1),";",2)," ",3,99),XMDUZ=$S($G(DUZ):DUZ,1:.5),XMTEXT="^TMP(""BMC4P7"",$J,",XMY(1)="",XMY(DUZ)=""
 F %="BMCZMENU","XUMGR","XUPROG","XUPROGMODE" D SINGLE(%)
 D ^XMD
 KILL ^TMP("BMC4P7",$J)
 D MES^XPDUTL("END Delivering MailMan message to select users.")
 Q
 ;
RSLT(%) S ^(0)=$G(^TMP("BMC4P7",$J,0))+1,^(^(0))=%
 Q
 ;
SINGLE(K) ; Get holders of a single key K.
 NEW Y
 S Y=0
 Q:'$D(^XUSEC(K))
 F  S Y=$O(^XUSEC(K,Y)) Q:'Y  S XMY(Y)=""
 Q
 ;
INTROE ; Intro text during KIDS Environment check.
 ;;In this distribution:
 ;;(1) Added new C32 Report option to print Referrals that do not have
 ;;    a C32 printed. Option is located under the Administrative reports
 ;;    option.
 ;;(2) Additional routines for the EHR RCIS provider interface.
 ;;
 ;;
 ;;###
 ;
INTROI ; Intro text during KIDS Install.
 ;;A standard message will be produced by this update.
 ;;  
 ;;If you run interactively, results will be displayed on your screen,
 ;;as well as in the mail message and the entry in the INSTALL file.
 ;;If you queue to TaskMan, please read the mail message for results of
 ;;this update, and remember not to Q to the HOME device.
 ;;###
 ;
GREET ;;To add to mail message.
 ;;  
 ;;Greetings.
 ;;  
 ;;The RCIS package on your RPMS system has been updated.
 ;;  
 ;;You are receiving this message because of the particular RPMS
 ;;security keys that you hold.  This is for your information, only.
 ;;You need do nothing in response to this message.
 ;;  
 ;;Questions about this patch, which is a product of the RPMS developer
 ;;(Fonda Jackson at 971.235.5714),
 ;;can be directed to the DIR/RPMS Support Center, at 505-248-4371,
 ;;or via e-mail to "oithelp@ihs.gov".
 ;;Please refer to patch "bmc*4.0*6".
 ;;  
 ;;###;NOTE: This line indicates the end of text in this message.
 ;
 ; -----------------------------------------------------
 ; The global location for dictionary audit is:
 ;           ^DD(FILE,0,"DDA")
 ; If the valuey is "Y", dd audit is on.  Any other value, or the
 ; absence of the node, means dd audit is off.
 ; -----------------------------------------------------
AUDS ;EP - From KIDS.
 D BMES^XPDUTL("Saving current DD AUDIT settings for files in this patch")
 D MES^XPDUTL("and turning DD AUDIT to 'Y'.")
 S ^XTMP("BMC4P7",0)=$$FMADD^XLFDT(DT,10)_"^"_DT_"^"_$P($P($T(+1),";",2)," ",3,99)
 NEW BMC
 S BMC=0
 F  S BMC=$O(^XTMP("XPDI",XPDA,"FIA",BMC)) Q:'BMC  D
 . I '$D(^XTMP("BMC4P7",BMC,"DDA")) S ^XTMP("BMC4P7",BMC,"DDA")=$G(^DD(BMC,0,"DDA"))
 . D MES^XPDUTL(" File "_$$RJ^XLFSTR(BMC,12)_" - "_$$LJ^XLFSTR(^XTMP("XPDI",XPDA,"FIA",BMC),30)_"- DD audit was '"_$G(^XTMP("BMC4P7",BMC,"DDA"))_"'"),MES^XPDUTL($$RJ^XLFSTR("Set to 'Y'",69))
 . S ^DD(BMC,0,"DDA")="Y"
 .Q
 D MES^XPDUTL("DD AUDIT settings saved in ^XTMP(.")
 Q
 ; -----------------------------------------------------
AUDR ; Restore the file data audit values to their original values.
 D BMES^XPDUTL("Restoring DD AUDIT settings for files in this patch.")
 NEW BMC
 S BMC=0
 F  S BMC=$O(^XTMP("BMC4P7",BMC)) Q:'BMC  D
 . S ^DD(BMC,0,"DDA")=^XTMP("BMC4P7",BMC,"DDA")
 . D MES^XPDUTL(" File "_$$RJ^XLFSTR(BMC,12)_" - "_$$LJ^XLFSTR($$GET1^DID(BMC,"","","NAME"),30)_"- DD AUDIT Set to '"_^DD(BMC,0,"DDA")_"'")
 .Q
 KILL ^XTMP("BMC4P7")
 D MES^XPDUTL("DD AUDIT settings restored.")
 Q
 ; -----------------------------------------------------
INDX ;INDEX NEW INDECIES "BA", "BB" AND "CD" ;Patch 2
 S BMC="BMC*4.0*2" Q:$$INSTALLD^BMC4P0(BMC)
 D BMES^XPDUTL("BEGIN Indexing Expected Begining Date of Service.")
 S DIK="^BMCREF("
 S DIK(1)="1105^BA"
 D ENALL^DIK
 D BMES^XPDUTL("BEGIN Indexing Actual Appointment/begin DOS.")
 S DIK(1)="1106^BB"
 D ENALL^DIK
 D BMES^XPDUTL("BEGIN Indexing CHS Denial Number.")
 S DIK(1)="1128^CD"
 D ENALL^DIK
 D BMES^XPDUTL("Completed updating new indexes.")
 K DA,DIC,DIK,X
 Q
 ; -----------------------------------------------------
P5 ;Add Menu option for Vendor
 S BMC="BMC*4.0*5" Q:$$INSTALLD^BMC4P0(BMC)
 D BMES^XPDUTL("Begin adding new Provider/Vendor option.")
 I $$ADD^XPDMENU("BMCMENU","BMCVEN","VEN") D MES^XPDUTL($J("",5)_"Provider/Vendor add/edit Menu added to RCIS Main Menu")
 D MES^XPDUTL("END updating option.")
 Q
 ; -----------------------------------------------------
P6 ;FX CHS PO'S WITH FY 00 INSTEAD OF FY 10
 S BMC="BMC*4.0*6" Q:$$INSTALLD^BMC4P0(BMC)
 D MES^XPDUTL("Updating CHS 2010 PO Numbers.")
 S BMC=3090900 F  S BMC=$O(^BMCREF("B",BMC)) Q:BMC'?1N.N  D
 .S BMC1="" F  S BMC1=$O(^BMCREF("B",BMC,BMC1)) Q:BMC1'?1N.N  D
 ..I $D(^BMCREF(BMC1,41)) S BMC2=0 F  S BMC2=$O(^BMCREF(BMC1,41,BMC2)) Q:BMC2'?1N.N  D
 ...S BMCPO=$P(^BMCREF(BMC1,41,BMC2,0),U,8)
 ...I $E(BMCPO,1,2)="00",$L(BMCPO)=12 D
 ....S $P(^BMCREF(BMC1,41,BMC2,0),U,8)="10"_$E(BMCPO,3,12)
 ....S $P(^BMCREF(BMC1,41,BMC2,11),U)=10
 D BMES^XPDUTL("Begin adding option for Adding Med Hx comments.")
 I $$ADD^XPDMENU("BMC MENU EDIT REFERRAL","BMC MED HX COMMENTS","MED") D MES^XPDUTL($J("",5)_"Enter Medical Hx Comments Menu added to RCIS Edit Menu")
 D MES^XPDUTL("END updating option.")
 Q
 ; ------------------------------------------------------
P7 ;Adding new Report menu option for the printed C32
 S BMC="BMC*4.0*7" Q:$$INSTALLD^BMC4P0(BMC)
 D BMES^XPDUTL("Begin adding option for Active referrals without a printed C32.")
 I $$ADD^XPDMENU("BMC MENU-RPTS ADMINISTRATIVE","BMC RPT-ACTIVE REFERRALS-C32","ARC") D MES^XPDUTL($J("",5)_"Report for Active ref w/o a C32 Menu added to Adm Report option")
 D MES^XPDUTL("END updating option.")
 Q
 ; ------------------------------------------------------
