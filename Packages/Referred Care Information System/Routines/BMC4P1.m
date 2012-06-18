BMC4P1 ;IHS/ITSC/FCJ - BMC 4.0 PATCH 1 ;  [ 06/02/2006  2:07 PM ]
 ;;4.0;REFERRED CARE INFO SYSTEM;**1**;JUN 01, 2006
 ;
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
 I $$VCHK("DI","21.0",2,"<")
 I $$VCHK("ATX","5.1",2,"<")
 I $$VCHK("AUPN","99.1",2,"<")
 ;
 NEW DA,DIC
 S X="BMC",DIC="^DIC(9.4,",DIC(0)="",D="C"
 D IX^DIC
 I Y<0,$D(^DIC(9.4,"C","BMC")) D
 . W !!,*7,*7,$$CJ^XLFSTR("You Have More Than One Entry In The",IOM),!,$$CJ^XLFSTR("PACKAGE File with an ""BMC"" prefix.",IOM)
 . W !,$$CJ^XLFSTR(IORVON_"One entry needs to be deleted."_IORVOFF,IOM)
 . D SORRY(2)
 ;
 I $G(XPDQUIT) W !,$$CJ^XLFSTR(IORVON_"FIX IT! Before Proceeding."_IORVOFF,IOM),!!,*7,*7,*7 Q
 ;
 W !!,$$CJ^XLFSTR("ENVIRONMENT OK.",IOM)
 ;
 D HELP^XBHELP("INTROE","BMC4P1")
 I '$$DIR^XBDIR("E","","","","","",1) D SORRY(2) Q
 ;
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0 D HELP^XBHELP("INTROI","BMC4P1") I '$$DIR^XBDIR("E","","","","","",1) D SORRY(2)
 ;
 Q
 ;
SORRY(X) ;
 KILL DIFQ
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....FIX IT!",IOM)
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
PRE ;EP - From KIDS.
 I $$NEWCP^XPDUTL("PRE1","AUDS^BMC4P1")
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 ;
 Q
 ;
POST ;EP - From KIDS.
 ;
 ; --- Restore dd audit settings.
 S %="AUDR^BMC4P1"
 I $$NEWCP^XPDUTL("POS1-"_%,%)
 ;
 ; --- Send mail message of install.
 S %="MAIL^BMC4P1"
 I $$NEWCP^XPDUTL("POS2-"_%,%)
 ;
 Q
 ;
MAIL ;
 D BMES^XPDUTL("BEGIN Delivering MailMan message to select users.")
 NEW DIFROM,XMSUB,XMDUZ,XMTEXT,XMY
 KILL ^TMP("BMC4P1",$J)
 D RSLT(" --- BMC v 4.0 Patch 1, has been installed into this uci ---")
 F %=1:1 D RSLT($P($T(GREET+%),";",3)) Q:$P($T(GREET+%+1),";",3)="###"
 S %=0
 F  S %=$O(^XTMP("XPDI",XPDA,"BLD",XPDBLD,1,%)) Q:'%   D RSLT(^(%,0))
 S XMSUB=$P($P($T(+1),";",2)," ",3,99),XMDUZ=$S($G(DUZ):DUZ,1:.5),XMTEXT="^TMP(""BMC4P1"",$J,",XMY(1)="",XMY(DUZ)=""
 F %="BMCZMENU","XUMGR","XUPROG","XUPROGMODE" D SINGLE(%)
 D ^XMD
 KILL ^TMP("BMC4P1",$J)
 D MES^XPDUTL("END Delivering MailMan message to select users.")
 Q
 ;
RSLT(%) S ^(0)=$G(^TMP("BMC4P1",$J,0))+1,^(^(0))=%
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
 ;;(1) General Retrieval Report:
 ;;    a. Changed CHS PDO issue date to print in format xx/xx/xx
 ;;    b. Added CHS Approval/Denial date to search, sort and print
 ;;    c. Changed heading from Select screen to Search Screen
 ;;(2) Added following Major DX Category:
 ;;    a. Skin and Subcutaneous Tissue
 ;;    b. Complications of Pregnancy, Childbirth and the Puerperium
 ;;(3) Referral Facility Address
 ;;    a. Address fields added to the Rcis Site Parameter file
 ;;    b. If fields are not populated will default to Location file
 ;;    c. Edit and Display Site parameter options were modified
 ;;    d. All letters updated to use new address fields
 ;;(4) Case Management Reports:
 ;;    a. Added total to Print Case Review Comments report
 ;;    b. Added Report run date to the Inpatient Log Report
 ;;    c. Added Date Range to the Area Discharge report
 ;;    d. Added Date Range to the List of High Cost Users Report
 ;;    e. Added Date Range to Potential High Cost Cases
 ;;    f. Added Report Run Date to Patient Dish/Cons Sum not rec'd
 ;;(5) Trending reports now print in Alpha order for providers
 ;;    a. Referral Patterns by Provider or Facility
 ;;    b. CHS Referral Costs By Requesting Prov/Facility
 ;;(6) Display a Referral; when selecting by patient name will display
 ;;    most recent referral entered
 ;;(7) Miscellaneous routine modifications
 ;;    a. Fixed Entering final values when Closing referral
 ;;    b. If Insurance data entered, but not the "insurance plan"
 ;;       letter will error out, will now print 'unknown"
 ;;    c. Sec Ref data entry; fixed space bar at prompt
 ;;    d. Letters now printing elg and coverage for Medicaid/Medicare
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
 ;;Standard data dictionaries on your RPMS system have been updated.
 ;;  
 ;;You are receiving this message because of the particular RPMS
 ;;security keys that you hold.  This is for your information, only.
 ;;You need do nothing in response to this message.
 ;;  
 ;;Questions about this patch, which is a product of the RPMS DBA
 ;;,
 ;;can be directed to the Help Desk,
 ;;
 ;;Please refer to patch "bmc*4.0*1".
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
 S ^XTMP("BMC4P1",0)=$$FMADD^XLFDT(DT,10)_"^"_DT_"^"_$P($P($T(+1),";",2)," ",3,99)
 NEW BMC
 S BMC=0
 F  S BMC=$O(^XTMP("XPDI",XPDA,"FIA",BMC)) Q:'BMC  D
 . I '$D(^XTMP("BMC4P1",BMC,"DDA")) S ^XTMP("BMC4P1",BMC,"DDA")=$G(^DD(BMC,0,"DDA"))
 . D MES^XPDUTL(" File "_$$RJ^XLFSTR(BMC,12)_" - "_$$LJ^XLFSTR(^XTMP("XPDI",XPDA,"FIA",BMC),30)_"- DD audit was '"_$G(^XTMP("BMC4P1",BMC,"DDA"))_"'"),MES^XPDUTL($$RJ^XLFSTR("Set to 'Y'",69))
 . S ^DD(BMC,0,"DDA")="Y"
 .Q
 D MES^XPDUTL("DD AUDIT settings saved in ^XTMP(.")
 ;TEST FOR MIS SPELLED DX CATE DURING BETA TESTING
 I $D(^BMCTDXC("B","COMPLICATIONS FO PREGNANCY,CHI")) D
 .S DA=0,DA=$O(^BMCTDXC("B","COMPLICATIONS FO PREGNANCY,CHI",DA))
 .S DR=".01////COMPLICATIONS OF PREGNANCY,CHILDBIRTH AND PUERPERIUM"
 .S DIE="^BMCTDXC(" I DA D ^DIE
 .K D0,DA,DA,DIE,DR
 Q
 ; -----------------------------------------------------
AUDR ; Restore the file data audit values to their original values.
 D BMES^XPDUTL("Restoring DD AUDIT settings for files in this patch.")
 NEW BMC
 S BMC=0
 F  S BMC=$O(^XTMP("BMC4P1",BMC)) Q:'BMC  D
 . S ^DD(BMC,0,"DDA")=^XTMP("BMC4P1",BMC,"DDA")
 . D MES^XPDUTL(" File "_$$RJ^XLFSTR(BMC,12)_" - "_$$LJ^XLFSTR($$GET1^DID(BMC,"","","NAME"),30)_"- DD AUDIT Set to '"_^DD(BMC,0,"DDA")_"'")
 .Q
 KILL ^XTMP("BMC4P1")
 D MES^XPDUTL("DD AUDIT settings restored.")
 Q
 ; -----------------------------------------------------
 ;
INSTALLD(BMC) ; Determine if patch BMC was installed, where BMC is
 ; the name of the INSTALL.  E.g "AVA*93.2*12".
 ;
 NEW DIC,X,Y
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
 Q $S(Y<1:0,1:1)
 ;
 ; -----------------------------------------------------
