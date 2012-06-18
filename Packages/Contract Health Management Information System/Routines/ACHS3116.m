ACHS3116 ;IHS/OIT/FCJ - ACHS 3.1 PATCH 16 and 17 ; JUL 10, 2008
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**16,17**;JUNE 11,2001
 ;3.1*16 12/1/2009;IHS/OIT/FCJ - ORIG RTN P15 MOVED ENV CHECK TO ACHS31E1
 ;
PRE ;EP - From KIDS.
 I $$NEWCP^XPDUTL("PRE1","AUDS^ACHS3116")
 Q
 ;
POST ;EP - From KIDS.
 ; --Patches 4,5,6,7 Checks installs in Kids Install Questions.
 ; --Question for 3 was removed, need "C" index for lookup of non-registered patients
 S %="P4^ACHS3116"
 I $$NEWCP^XPDUTL("POS4-"_%,%)
 S %="P5^ACHS3116"
 I $$NEWCP^XPDUTL("POS5-"_%,%)
 S %="P6^ACHS3116"
 I $$NEWCP^XPDUTL("POS9-"_%,%)
 S %="P7^ACHS3116"
 I $$NEWCP^XPDUTL("POS12-"_%,%)
 ;PATCH 12
 S %="P12^ACHS3116"
 I $$NEWCP^XPDUTL("POS14-"_%,%)
 ;PATCH 13
 S %="P13^ACHS3116"
 I $$NEWCP^XPDUTL("POS17-"_%,%)
 ;PATCH 14
 S %="P14^ACHS3116"
 I $$NEWCP^XPDUTL("POS18-"_%,%)
 ;PATCH 15
 S %="P15^ACHS3116"
 I $$NEWCP^XPDUTL("POS19-"_%,%)
 ;PATCH 16
 S %="P16^ACHS3116"
 I $$NEWCP^XPDUTL("POS20-"_%,%)
 ; --- Restore dd audit settings.
 S %="AUDR^ACHS3116"
 I $$NEWCP^XPDUTL("POS21-"_%,%)
 ; --- Send mail message of install.
 S %="MAIL^ACHS3116"
 I $$NEWCP^XPDUTL("POS22-"_%,%)
 ;
 Q
MAIL ;
 D BMES^XPDUTL("BEGIN Delivering MailMan message to select users.")
 NEW DIFROM,XMSUB,XMDUZ,XMTEXT,XMY
 KILL ^TMP("ACHS3116",$J)
 D RSLT(" --- ACHS v 3.1 Patch 15, has been installed into this namespace ---")
 F %=1:1 D RSLT($P($T(GREET+%),";",3)) Q:$P($T(GREET+%+1),";",3)="###"
 S %=0
 F  S %=$O(^XTMP("XPDI",XPDA,"BLD",XPDBLD,1,%)) Q:'%   D RSLT(^(%,0))
 S XMSUB=$P($P($T(+1),";",2)," ",3,99),XMDUZ=$S($G(DUZ):DUZ,1:.5),XMTEXT="^TMP(""ACHS3116"",$J,",XMY(1)="",XMY(DUZ)=""
 F %="ACHSZMENU","XUMGR","XUPROG","XUPROGMODE" D SINGLE(%)
 D ^XMD
 KILL ^TMP("ACHS3116",$J)
 D MES^XPDUTL("END Delivering MailMan message to select users.")
 Q
 ;
RSLT(%) S ^(0)=$G(^TMP("ACHS3116",$J,0))+1,^(^(0))=%
 Q
 ;
SINGLE(K) ; Get holders of a key
 NEW Y
 S Y=0
 Q:'$D(^XUSEC(K))
 F  S Y=$O(^XUSEC(K,Y)) Q:'Y  S XMY(Y)=""
 Q
 ;
GREET ;;To add to mail message.
 ;;  
 ;;Standard data dictionaries on your RPMS system have been updated.
 ;;  
 ;;You are receiving this message because of the RPMS
 ;;security keys that you hold.  This is for your information.
 ;;Do not respond to this message.
 ;;  
 ;;Questions about this patch may be directed to
 ;;the ITSC Support Center, at 505-248-4371,
 ;;refer to patch "ACHS*3.1*17".
 ;;  
 ;;###;NOTE: This line end of text.
 ;
 ; ---------------------------------------------
 ; The global location for dictionary audit is:
 ;           ^DD(FILE,0,"DDA")
 ; If the valuey is "Y", dd audit is on.  Any other value, or the
 ; absence of the node, means dd audit is off.
 ;
AUDS ;EP - From KIDS.
 D BMES^XPDUTL("Saving current DD AUDIT settings for files in this patch")
 D MES^XPDUTL("and turning DD AUDIT to 'Y'.")
 S ^XTMP("ACHS3116",0)=$$FMADD^XLFDT(DT,10)_"^"_DT_"^"_$P($P($T(+1),";",2)," ",3,99)
 NEW ACHS
 S ACHS=0
 F  S ACHS=$O(^XTMP("XPDI",XPDA,"FIA",ACHS)) Q:'ACHS  D
 . I '$D(^XTMP("ACHS3116",ACHS,"DDA")) S ^XTMP("ACHS3116",ACHS,"DDA")=$G(^DD(ACHS,0,"DDA"))
 . D MES^XPDUTL(" File "_$$RJ^XLFSTR(ACHS,12)_" - "_$$LJ^XLFSTR(^XTMP("XPDI",XPDA,"FIA",ACHS),30)_"- DD audit was '"_$G(^XTMP("ACHS3116",ACHS,"DDA"))_"'"),MES^XPDUTL($$RJ^XLFSTR("Set to 'Y'",69))
 . S ^DD(ACHS,0,"DDA")="Y"
 D MES^XPDUTL("DD AUDIT settings saved in ^XTMP(.")
 Q
 ;
AUDR ; Restore the file data audit values to their original values.
 D BMES^XPDUTL("Restoring DD AUDIT settings for files in this patch.")
 NEW ACHS
 S ACHS=0
 F  S ACHS=$O(^XTMP("ACHS3116",ACHS)) Q:'ACHS  D
 . S ^DD(ACHS,0,"DDA")=^XTMP("ACHS3116",ACHS,"DDA")
 . D MES^XPDUTL(" File "_$$RJ^XLFSTR(ACHS,12)_" - "_$$LJ^XLFSTR($$GET1^DID(ACHS,"","","NAME"),30)_"- DD AUDIT Set to '"_^DD(ACHS,0,"DDA")_"'")
 .Q
 KILL ^XTMP("ACHS3116")
 D MES^XPDUTL("DD AUDIT settings restored.")
 Q
 ;
 ;Fields to be deleted.
 ;File#^FileName^Field#^FieldName
DELFLD ;
 ;;9002069^CHS DATA CONTROL^1^*RESERVED-1
 ;;9002069^CHS DATA CONTROL^3^*BUDGET INDIVIDUAL ACCOU
 ;;9002069.03^PIGGYBACK FACILITIES^.01^PIGGYBACK FACILITIES
 ;;9002069^CHS DATA CONTROL^9^*PIGGYBACK FACILITIES
 ;;9002071.63^* DIAGNOSIS (APC) COMMENT^.01^* DIAGNOSIS (APC) COMMENT
 ;;9002071.06^* DIAGNOSIS (APC)^.01^* DIAGNOSIS (APC)
 ;;9002071.06^* DIAGNOSIS (APC)^2^* DIAGNOSIS (APC) NARRATIVE
 ;;9002071.06^* DIAGNOSIS (APC)^3^* DIAGNOSIS (APC) COMMENT
 ;;9002071.01^DENIAL NUMBER^600^* DIAGNOSIS (APC)
 ;;9002080^CHS FACILITY^14.1^*PROCESS PAT FOR AREA NC
 ;;9002080^CHS FACILITY^14.13^*PROCESS DOCUMENT RECS F
 ;;9002080.01^DOCUMENT^13.66^* VEND AGR NUMB (NOT USE
 ;;9002080.01^DOCUMENT^77^*DENTAL SERVICES
 ;;END
 ; Note:  above line is a loop ender.
 D BMES^XPDUTL("BEGIN Removing deleted fields from CHS Files.")
 NEW DA,DIK
 F ACHS=1:1 S X=$P($T(DELFLD+ACHS),";",3) Q:X="END"  D
 .D MES^XPDUTL($J("",5)_"Deleting '"_$$LJ^XLFSTR($P(X,U,4),30,".")_"' from '"_$P(X,U,2)_"'")
 .S DIK="^DD("_$P(X,U,1)_",",DA(1)=$P(X,U,1),DA=$P(X,U,3)
 .D ^DIK
 .; KILL ^DD(9999999.3911) ; 4 of the 0th nodes aren't KILL'd by ^DIK.
 D MES^XPDUTL("END Removing deleted fields from CHS Files.")
 Q
 ;
DENOPT ;638 facility then add options
 D BMES^XPDUTL("BEGIN Checking for 638 facility.")
 NEW ACHS
 S ACHS=0
 F  S ACHS=$O(^ACHSF(ACHS)) Q:'ACHS   I $P(^ACHSF(ACHS,0),U,8)="Y" D  Q
 .I $$ADD^XPDMENU("ACHS DEFDEN MENU PARM","ACHSDENPARM","P638") D MES^XPDUTL($J("",5)_"Denial par menu added for 638 facility")
 .I $$ADD^XPDMENU("ACHSDENPARM","ACHSDENPARMREA","AREA") D MES^XPDUTL($J("",5)_"Denial par menu added for 638 facility")
 D MES^XPDUTL("END Checking for 638 facility.")
 Q
 ;
M278 ;
 D BMES^XPDUTL("BEGIN Attaching 278 menu.")
 I $$ADD^XPDMENU("ACHSAA","ACHS 278 MENU","278") D MES^XPDUTL($J("",5)_"278 Menu added to Doc Gen menu."),MES^XPDUTL($J("",5)_"Note that the security lock was *NOT* allocated.") I 1
 E  D MES^XPDUTL($J("",5)_"ERROR:   278 menu attachment FAILED.")
 D MES^XPDUTL("END Attaching 278 menu.")
 Q
 ;
P6OPT ;EP - FR KIDS
 ;ADD NEW OPTIONS - PATCH 6, DENIAL APPEAL,EDITS AND CANCEL, FI FIELD
 D BMES^XPDUTL("Begin adding new options.")
 I $$ADD^XPDMENU("ACHSAA","ACHSFIM","FIM") D MES^XPDUTL($J("",5)_"Approval Message to FI added to Doc Gen Menu")
 I $$ADD^XPDMENU("ACHS DEFDEN MENU","ACHS DEN APPEAL MENU","APP") D MES^XPDUTL($J("",5)_"Denial Appeal menu added to CHS Denial/Deferred Servcies Menu")
 D MES^XPDUTL("END updating options.")
 Q
NONREG ;EP - fr KIDS
 D BMES^XPDUTL("BEGIN Re-index of Patient Name in Denials.")
 NEW ACHS,DA,DIK
 S ACHS=0
 F  S ACHS=$O(^ACHSDEN(ACHS)) Q:'ACHS  D
 .K ^ACHSDEN(ACHS,"D","C"),^ACHSDEN(ACHS,"D","N")
 .S DIK="^ACHSDEN("_ACHS_",""D"""_",",DA(1)=ACHS
 .F DIK(1)="7^C","10^C" D ENALL^DIK
 D MES^XPDUTL("END Re-index of Patient Name in Denials.")
 Q
DENREV ;EP - Fr KIDS
 ;SETS DENIAL STATUS IF DENIAL WAS REVERSED
 NEW ACHS
 S ACHSASTA=0,ACHSDA=0,ACHS=0
 S ACHSASTA=$O(^ACHSDENA("B","REVERSED AFTER APPEAL",ACHSASTA))
 F  S ACHS=$O(^ACHSDEN(ACHS)) Q:ACHS'?1N.N  D
 .S ACHSDA=0
 .F  S ACHSDA=$O(^ACHSDEN(ACHS,"D",ACHSDA)) Q:ACHSDA'?1N.N  D
 ..S ACHSDSTA=$P(^ACHSDEN(ACHS,"D",ACHSDA,0),U,8)
 ..Q:'$D(^ACHSDEN(ACHS,"D",ACHSDA,400,0))
 ..I ACHSDSTA["R" S $P(^ACHSDEN(ACHS,"D",ACHSDA,400,0),U,3)=ACHSASTA
 K ACHSASTA,ACHSDA
 Q
V145DD ;EP - FR KIDS
 ;Removes V 1.45 DD'S LEFT BEHIND
 K ^UTILITY("XBDSET",$J)
 F XBBPI=1:1 S XBBPIX=$P($T(LIST+XBBPI),";;",2) Q:XBBPIX="END"  S XBBPIY=$P(XBBPIX,"=",2,99),XBBPIX=$P(XBBPIX,"=",1) S @XBBPIX=XBBPIY
 K XBBPI,XBBPIX,XBBPIY D EN2^XBKD
 Q
LIST ;
 ;;^UTILITY("XBDSET",$J,1803100)=S^S
 ;;^UTILITY("XBDSET",$J,1803101)=S^S
 ;;^UTILITY("XBDSET",$J,1803102)=S^S
 ;;^UTILITY("XBDSET",$J,1803103)=S^S
 ;;^UTILITY("XBDSET",$J,1803104)=S^S
 ;;^UTILITY("XBDSET",$J,1803107)=S^S
 ;;^UTILITY("XBDSET",$J,1803109)=S^S
 ;;^UTILITY("XBDSET",$J,1803110)=S^S
 ;;^UTILITY("XBDSET",$J,1803111)=S^S
 ;;^UTILITY("XBDSET",$J,1803112)=S^S
 ;;^UTILITY("XBDSET",$J,1803113)=S^S
 ;;^UTILITY("XBDSET",$J,1803114)=S^S
 ;;^UTILITY("XBDSET",$J,1803115)=S^S
 ;;END
 ;Above line ends loop
 ;
P7OPT ;EP -FR KIDS
 ;NEW OPTIONS P7 ELECTRONIC SIG AND REPORTS
 D BMES^XPDUTL("Adding new options.")
 I $$ADD^XPDMENU("ACHSMENU","ACHS E-SIG MENU","EMNU") D MES^XPDUTL($J("",5)_"Electronic Signature Auth Menu to CHS Menu")
 I $$ADD^XPDMENU("ACHS E-SIG MENU","ACHS E-SIG AUTHORIZING OFC.","SIGA")
 I $$ADD^XPDMENU("ACHS E-SIG MENU","ACHS E-SIG ORDERING OFC.","SIGO") D MES^XPDUTL($J("",5)_"Electronic Sig for Authorizing Official, Electronic Sig for Ordering Official")
 I $$ADD^XPDMENU("ACHSREPORTS","ACHS E-SIG REPORTS","ERPT")
 I $$ADD^XPDMENU("ACHS E-SIG REPORTS","ACHS E-SIG APPROVED REPORT","ESAP")
 I $$ADD^XPDMENU("ACHS E-SIG REPORTS","ACHS E-SIG PENDING SIG REPORT","ESPD")
 D MES^XPDUTL($J("",5)_"Options in E-Signature Reports added")
 I $$ADD^XPDMENU("ACHSMGPAR","ACHS E-SIG ADD EDIT USERS","EOFF")
 I $$ADD^XPDMENU("ACHSMGPAR","ACHS E-SIG SITE PARAMETER","ESIT") D MES^XPDUTL($J("",5)_"Option for adding Authorized E-Signature users and E-Site Paramaters added to facility management options")
 I $$ADD^XPDMENU("ACHSMGR","ACHSMGPAR") D MES^XPDUTL($J("",5)_"Attach E-Sig to facility Management")
 D MES^XPDUTL("Key for E-Sig Menu is ACHSZESIG,for Adding authorized users is ACHSZPARM.")
 D MES^XPDUTL("END updating options.")
 Q
 ;
HHS ;
 D BMES^XPDUTL("BEGIN Checking for IHS facility.")
 N ACHSI
 S ACHSI=0
 F  S ACHSI=$O(^ACHSF(ACHSI)) Q:ACHSI'?1N.N  I $P(^ACHSF(ACHSI,0),U,8)'="Y" D  Q
 .I $$ADD^XPDMENU("ACHSMGR","ACHSHHS","HHS") D MES^XPDUTL($J("",5)_"HHS Contract Action Type edit added for IHS facilities")
 D MES^XPDUTL("END Checking for IHS facilities.")
 Q
UFMS ;EP-fr KIDS P 13
 ;ADD UFMS START DATE TO CHS FAC FILE
 S X=0 F  S X=$O(^ACHSF("B",X)) Q:X'?1N.N  D
 .S X1=0 F  S X1=$O(^ACHSF("B",X,X1)) Q:X1'?1N.N  D
 ..S:$P(^ACHSF(X1,0),U,8)="N" $P(^ACHSF(X1,0),U,13)=3071001
 ;ADD IE SERVER TO ZISH SEND PAR
 S X="ACHS UFMS B",DIC="^%ZIB(9888888.93,",DIC(0)="L"
 D ^DIC
 I Y<0 W !,"ZISH SEND PARAMETER FOR THE ACHS UFMS ENTRY COULD NOT BE ADDED, YOU WILL NEED TO THROUGH FILEMAN" Q
 S DA=+Y,DIE=DIC
 S DR=".02////"_"quovadx-ie.ihs.gov"_";.03////"_"ufmsuser"_";.04////"_"vjrsshn9"_";.06////"_"-iau"_";.07////"_"B"_";.08////"_"sendto"
 D ^DIE
 K D,D0,D1,DI,DIADD,DIC,DICR,DIE,DLAYGO,DQ,DR,DINUM,DA
 Q
DCIS ;EP-FR kids P14
 N X,Y
 S ACHSUNM="",ACHSUNM=$S($$OS^ACHS=1:"D1/WEBFRS_CHS",1:"D1\WEBFRS_CHS")
 S X="ACHS WEBFRS B",DIC="^%ZIB(9888888.93,",DIC(0)="L"
 D ^DIC
 I Y<0 W !,"ZISH SEND PARAMETER FOR THE ACHS WEBFRS ENTRY COULD NOT BE ADDED, YOU WILL NEED TO EDIT USING FILEMAN" Q
 S DA=+Y,DIE=DIC
 S DR=".02////"_"INTRANETFTP.IHS.GOV"_";.03////"_ACHSUNM_";.04////"_"oFRkd9UXaIIob0e"_";.06////"_"-iaun"_";.07////"_"B"_";.08////"_"sendto"
 D ^DIE
 K D,D0,D1,DI,DIADD,DIC,DICR,DIE,DLAYGO,DQ,DR,DINUM,DA,ACHSUNM
SSC ;ADD NAICS CODES TO SSC P14
 S ACHSFAC=""
 F  S ACHSFAC=$O(^ACHS(3,"B",ACHSFAC)) Q:ACHSFAC'?1N.N  D
 .S ACHSSSC="" F  S ACHSSSC=$O(^ACHS(3,ACHSFAC,1,"B",ACHSSSC)) Q:ACHSSSC=""  D
 ..S X=""
 ..I (ACHSSSC=2185)!(ACHSSSC=4319) S X=621999
 ..I (ACHSSSC="252A")!(ACHSSSC="252B") S X=621511
 ..I (ACHSSSC="252D") S X=339116
 ..I (ACHSSSC="252G")!(ACHSSSC="252L")!(ACHSSSC="252Q") S X=622110
 ..I (ACHSSSC="252M") S X=623110
 ..I (ACHSSSC="252S") S X=621340
 ..I (ACHSSSC="252H")!(ACHSSSC="252J") S X=621512
 ..I (ACHSSSC="254A")!(ACHSSSC="254B")!(ACHSSSC="254C")!(ACHSSSC="254D") S X=621111
 ..I (ACHSSSC="254E") S X=621210
 ..I (ACHSSSC="254G")!(ACHSSSC="254J") S X=622310
 ..I (ACHSSSC="254L")!(ACHSSSC="263K") S X=621320
 ..I (ACHSSSC="253A")!(ACHSSSC="253G") S X=621999
 ..I (ACHSSSC="263L") S X=621340
 ..Q:X=""
 ..S DIC="^ACHS(3.1," D ^DIC
 ..S X="" S X=$O(^ACHS(3,ACHSFAC,1,"B",ACHSSSC,X))
 ..S $P(^ACHS(3,ACHSFAC,1,X,0),U,6)=$P(Y,U)
 Q
ZISHOS ;EP-P 15 IF OS=UNIX UPDATE PAR TO NOT SEND ZIPPED FILE
 I $$OS^ACHS=1 D
 .S X="ACHS WEBFRS B",(DIE,DIC)="^%ZIB(9888888.93,"
 .D ^DIC
 .I Y<0 W !,"ACHS WEBFRS B ZISH PARAMETER ENTRY NOT FOUND, FEDERAL SITES-ENTRY IS REQUIRED." Q
 .S DA=+Y,DR=".06////"_"-iaun" D ^DIE
 .K D,D0,D1,DI,DIADD,DIC,DICR,DIE,DLAYGO,DQ,DR,DINUM,Y,X
DRPT ;ADD DCIS ERROR REPORT OPT P15
 I $$ADD^XPDMENU("ACHSREPORTS","ACHSRPTDCISERROR","DCIS") D MES^XPDUTL($J("",5)_"DCIS Error Report Option added to the Report Menu")
 Q
P16OPT ;EP - FR KIDS
 ;ADD NEW OPTIONS - P16, DENIAL REPORT, 2-SSC REPORTS
 D BMES^XPDUTL("Begin adding new options.")
 I $$ADD^XPDMENU("ACHS DEFDEN MENU DEN REPORTS","ACHS DEN REP-CARE NOT MED PRI","CARE") D MES^XPDUTL($J("",5)_"Added to Denial Reports - Care not within Medical Priority")
 I $$ADD^XPDMENU("ACHS MENU SCC REPORTS","ACHSRPTOBJPAY","PAY") D MES^XPDUTL($J("",5)_"Added to SSC Reports - Payment Report by Object Classification")
 I $$ADD^XPDMENU("ACHS MENU SCC REPORTS","ACHSRPTOBJPAYSUM","SUM") D MES^XPDUTL($J("",5)_"Added to SSC Reports - Payment Summary Report by Object Classification")
 D MES^XPDUTL("END updating options.")
 Q
P4 ;EP - fr KIDS
 Q:'$G(XPDQUES("POS4"))
 D BMES^XPDUTL("BEGIN Re-index of Pat Name in Deferred Services.")
 NEW ACHS,DA,DIK
 S ACHS=0
 F  S ACHS=$O(^ACHSDEF(ACHS)) Q:'ACHS  D
 .K ^ACHSDEF(ACHS,"D","C"),^ACHSDEF(ACHS,"D","N")
 .S DIK="^ACHSDEF("_ACHS_",""D"""_",",DA(1)=ACHS
 .F DIK(1)="6^C","7^N" D ENALL^DIK
 D MES^XPDUTL("END Re-index of Pat Name.")
 Q
 ;
P5 ;EP - from KIDS
 Q:'$G(XPDQUES("POS5"))
 ; ---Denial ltr edit option
 S %="DENOPT^ACHS3116"
 I $$NEWCP^XPDUTL("POS5-"_%,%)
 ; ---Del fields in CHS files marked for deletion
 S %="DELFLD^ACHS3116"
 I $$NEWCP^XPDUTL("POS6-"_%,%)
 ; --- 278 menu
 S %="M278^ACHS3116"
 I $$NEWCP^XPDUTL("POS7-"_%,%)
 ; ---Remove non-standard opt auditing from CHS 
 S %="POS^ACHS31P0"
 I $$NEWCP^XPDUTL("POS8-"_%,%)
 Q
P6 ;EP - from KIDS
 Q:'$G(XPDQUES("POS9"))
 ; ---Denial APPEAL option
 S %="P6OPT^ACHS3116"
 I $$NEWCP^XPDUTL("POS9-"_%,%)
 ; --- Re-index non-reg pat name
 S %="NONREG^ACHS3116"
 I $$NEWCP^XPDUTL("POS10-"_%,%)
 ; --- Set appeal status.
 S %="DENREV^ACHS3116"
 I $$NEWCP^XPDUTL("POS11-"_%,%)
 Q
P7 ;EP-from KIDS
 Q:'$G(XPDQUES("POS12"))
 ; --REMOVE OLD DD FR V1.45 
 S %="V145DD^ACHS3116"
 I $$NEWCP^XPDUTL("POS12-"_%,%)
 ; ---E SIG OPTIONS
 S %="P7OPT^ACHS3116"
 I $$NEWCP^XPDUTL("POS13-"_%,%)
 Q
P12 ;EP-fr KIDS
 Q:$$INSTALLD^ACHS31E1("ACHS*3.1*12")
 S %="TEST^ACHSPQTS"
 I $$NEWCP^XPDUTL("POS15-"_%,%)
 ;
 S %="HHS^ACHS3116"
 I $$NEWCP^XPDUTL("POS16-"_%,%)
 Q
P13 ;EP-fr KIDS
 Q:$$INSTALLD^ACHS31E1("ACHS*3.1*13")
 S %="UFMS^ACHS3116"
 I $$NEWCP^XPDUTL("POS17-"_%,%)
 Q
P14 ;EP-fr KIDS
 Q:$$INSTALLD^ACHS31E1("ACHS*3.1*14")
 S %="DCIS^ACHS3116"
 I $$NEWCP^XPDUTL("POS18-"_%,%)
 Q
P15 ;EP-fr KIDS
 Q:$$INSTALLD^ACHS31E1("ACHS*3.1*15")
 S %="ZISHOS^ACHS3116"
 I $$NEWCP^XPDUTL("POS19-"_%,%)
 Q
P16 ;EP-fr KIDS
 Q:$$INSTALLD^ACHS31E1("ACHS*3.1*16")
 S %="P16OPT^ACHS3116"
 I $$NEWCP^XPDUTL("POS20-"_%,%)
 Q
