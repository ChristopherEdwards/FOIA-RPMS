ACHS3113 ;IHS/OIT/FCJ - ACHS 3.1 PATCH 13 ;
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**13**;JUN 11,2001
 ;3.1*13 12/7/2006;IHS/OIT/FCJ - ORIG RTN P12
 ;               MOVED ENV CHECK TO ACHS31E
 ;
PRE ;EP - From KIDS.
 I $$NEWCP^XPDUTL("PRE1","AUDS^ACHS3113")
 Q
 ;
POST ;EP - From KIDS.
 ; ---Patches 4,5,6,7 Checks installs are done in Install Questions.
 ; ---Question for 3 was removed, need "C" index for lookup of non-registered patients.
 S %="P4^ACHS3113"
 I $$NEWCP^XPDUTL("POS4-"_%,%)
 S %="P5^ACHS3113"
 I $$NEWCP^XPDUTL("POS5-"_%,%)
 ;
 S %="P6^ACHS3113"
 I $$NEWCP^XPDUTL("POS9-"_%,%)
 ;
 S %="P7^ACHS3113"
 I $$NEWCP^XPDUTL("POS12-"_%,%)
 ;
 ;PATCH 12
 S %="P12^ACHS3113"
 I $$NEWCP^XPDUTL("POS14-"_%,%)
 ;       
 ;PATCH 13
 S %="P13^ACHS3113"
 I $$NEWCP^XPDUTL("POS17-"_%,%)
 ;
 ; --- Restore dd audit settings.
 S %="AUDR^ACHS3113"
 I $$NEWCP^XPDUTL("POS18-"_%,%)
 ;
 ; --- Send mail message of install.
 S %="MAIL^ACHS3113"
 I $$NEWCP^XPDUTL("POS19-"_%,%)
 ;
 Q
MAIL ;
 D BMES^XPDUTL("BEGIN Delivering MailMan message to select users.")
 NEW DIFROM,XMSUB,XMDUZ,XMTEXT,XMY
 KILL ^TMP("ACHS3113",$J)
 D RSLT(" --- ACHS v 3.1 Patch 13, has been installed into this uci ---")
 F %=1:1 D RSLT($P($T(GREET+%),";",3)) Q:$P($T(GREET+%+1),";",3)="###"
 S %=0
 F  S %=$O(^XTMP("XPDI",XPDA,"BLD",XPDBLD,1,%)) Q:'%   D RSLT(^(%,0))
 S XMSUB=$P($P($T(+1),";",2)," ",3,99),XMDUZ=$S($G(DUZ):DUZ,1:.5),XMTEXT="^TMP(""ACHS3113"",$J,",XMY(1)="",XMY(DUZ)=""
 F %="ACHSZMENU","XUMGR","XUPROG","XUPROGMODE" D SINGLE(%)
 D ^XMD
 KILL ^TMP("ACHS3113",$J)
 D MES^XPDUTL("END Delivering MailMan message to select users.")
 Q
 ;
RSLT(%) S ^(0)=$G(^TMP("ACHS3113",$J,0))+1,^(^(0))=%
 Q
 ;
SINGLE(K) ; Get holders of a single key K.
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
 ;;You are receiving this message because of the particular RPMS
 ;;security keys that you hold.  This is for your information.
 ;;Do not respond to this message.
 ;;  
 ;;Questions about this patch may be directed to
 ;;the Help Desk,
 ;;refer to patch "ACHS*3.1*13".
 ;;  
 ;;###;NOTE: This line end of text.
 ;
 ; ---------------------------------------------
 ; The global location for dictionary audit is:
 ;           ^DD(FILE,0,"DDA")
 ; If the valuey is "Y", dd audit is on.  Any other value, or the
 ; absence of the node, means dd audit is off.
 ; ---------------------------------------------
AUDS ;EP - From KIDS.
 D BMES^XPDUTL("Saving current DD AUDIT settings for files in this patch")
 D MES^XPDUTL("and turning DD AUDIT to 'Y'.")
 S ^XTMP("ACHS3113",0)=$$FMADD^XLFDT(DT,10)_"^"_DT_"^"_$P($P($T(+1),";",2)," ",3,99)
 NEW ACHS
 S ACHS=0
 F  S ACHS=$O(^XTMP("XPDI",XPDA,"FIA",ACHS)) Q:'ACHS  D
 . I '$D(^XTMP("ACHS3113",ACHS,"DDA")) S ^XTMP("ACHS3113",ACHS,"DDA")=$G(^DD(ACHS,0,"DDA"))
 . D MES^XPDUTL(" File "_$$RJ^XLFSTR(ACHS,12)_" - "_$$LJ^XLFSTR(^XTMP("XPDI",XPDA,"FIA",ACHS),30)_"- DD audit was '"_$G(^XTMP("ACHS3113",ACHS,"DDA"))_"'"),MES^XPDUTL($$RJ^XLFSTR("Set to 'Y'",69))
 . S ^DD(ACHS,0,"DDA")="Y"
 .Q
 D MES^XPDUTL("DD AUDIT settings saved in ^XTMP(.")
 Q
 ; -----------------------------------------------------
AUDR ; Restore the file data audit values to their original values.
 D BMES^XPDUTL("Restoring DD AUDIT settings for files in this patch.")
 NEW ACHS
 S ACHS=0
 F  S ACHS=$O(^XTMP("ACHS3113",ACHS)) Q:'ACHS  D
 . S ^DD(ACHS,0,"DDA")=^XTMP("ACHS3113",ACHS,"DDA")
 . D MES^XPDUTL(" File "_$$RJ^XLFSTR(ACHS,12)_" - "_$$LJ^XLFSTR($$GET1^DID(ACHS,"","","NAME"),30)_"- DD AUDIT Set to '"_^DD(ACHS,0,"DDA")_"'")
 .Q
 KILL ^XTMP("ACHS3113")
 D MES^XPDUTL("DD AUDIT settings restored.")
 Q
 ; ---------------------------------------------
INSTALLD(ACHS) ; Determine if patch ACHS was installed, where ACHS is
 ; the name of the INSTALL.  E.g "AVA*93.2*12".
 ;
 NEW DIC,X,Y
 ;  lookup package.
 S X=$P(ACHS,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 Q 0
 ;  lookup version.
 S DIC=DIC_+Y_",22,",X=$P(ACHS,"*",2)
 D ^DIC
 I Y<1 Q 0
 ;  lookup patch.
 S DIC=DIC_+Y_",""PAH"",",X=$P(ACHS,"*",3)
 D ^DIC
 Q $S(Y<1:0,1:1)
 ; -------------------------------------------
 ; Fields to be deleted.
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
 D BMES^XPDUTL("BEGIN Removing deleted fields from CHS data dictionaries.")
 NEW DA,DIK
 F ACHS=1:1 S X=$P($T(DELFLD+ACHS),";",3) Q:X="END"  D
 .D MES^XPDUTL($J("",5)_"Deleting '"_$$LJ^XLFSTR($P(X,U,4),30,".")_"' from '"_$P(X,U,2)_"'")
 .S DIK="^DD("_$P(X,U,1)_",",DA(1)=$P(X,U,1),DA=$P(X,U,3)
 .D ^DIK
 .; KILL ^DD(9999999.3911) ; 4 of the 0th nodes aren't KILL'd by ^DIK.
 D MES^XPDUTL("END Removing deleted fields from CHS data dictionaries.")
 Q
 ;
DENOPT ; check for 638 facility, and add options if 638
 D BMES^XPDUTL("BEGIN Checking for 638 facility.")
 NEW ACHS
 S ACHS=0
 F  S ACHS=$O(^ACHSF(ACHS)) Q:'ACHS   I $P(^ACHSF(ACHS,0),U,8)="Y" D  Q
 .I $$ADD^XPDMENU("ACHS DEFDEN MENU PARM","ACHSDENPARM","P638") D MES^XPDUTL($J("",5)_"Denial parameter menu option added for 638 facility")
 .I $$ADD^XPDMENU("ACHSDENPARM","ACHSDENPARMREA","AREA") D MES^XPDUTL($J("",5)_"Denial parameter menu option added for 638 facility")
 D MES^XPDUTL("END Checking for 638 facility.")
 Q
 ;
M278 ;
 D BMES^XPDUTL("BEGIN Attaching 278 menu.")
 I $$ADD^XPDMENU("ACHSAA","ACHS 278 MENU","278") D MES^XPDUTL($J("",5)_"278 Menu added to Document Generation menu."),MES^XPDUTL($J("",5)_"Note that the security lock was *NOT* allocated.") I 1
 E  D MES^XPDUTL($J("",5)_"ERROR:   278 menu attachment FAILED.")
 D MES^XPDUTL("END Attaching 278 menu.")
 Q
 ;
P6OPT ;EP - FROM KIDS.
 ;ADD NEW OPTIONS FOR PATCH 6, DENIAL APPEAL,EDITS AND CANCEL, FI FIELD
 D BMES^XPDUTL("Begin adding new options.")
 I $$ADD^XPDMENU("ACHSAA","ACHSFIM","FIM") D MES^XPDUTL($J("",5)_"Send approval Message to FI added to Document Generation Menu")
 I $$ADD^XPDMENU("ACHS DEFDEN MENU","ACHS DEN APPEAL MENU","APP") D MES^XPDUTL($J("",5)_"Denial Appeal menu option added to CHS Denial/Deferred ServciesMenu")
 D MES^XPDUTL("END updating options.")
 Q
NONREG ;EP - from KIDS.
 D BMES^XPDUTL("BEGIN Re-index of Patient Name in Denials.")
 NEW ACHS,DA,DIK
 S ACHS=0
 F  S ACHS=$O(^ACHSDEN(ACHS)) Q:'ACHS  D
 .K ^ACHSDEN(ACHS,"D","C"),^ACHSDEN(ACHS,"D","N")
 .S DIK="^ACHSDEN("_ACHS_",""D"""_",",DA(1)=ACHS
 .F DIK(1)="7^C","10^C" D ENALL^DIK
 D MES^XPDUTL("END Re-index of Patient Name in Denials.")
 Q
DENREV ;EP - From KIDS.  
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
V145DD ;EP - From KIDS
 ;GETS RID OF VERSION 1.45 DD'S LEFT BEHIND
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
 ;Note above line ends loop
 ;
P7OPT ;EP -FROM KIDS
 ;ADD NEW OPTIONS FOR PATCH 7, ELECTRONIC SIGNATURE AND ELECTRONIC 
 ;SIGNATURE REPORTS
 D BMES^XPDUTL("Adding new options.")
 I $$ADD^XPDMENU("ACHSMENU","ACHS E-SIG MENU","EMNU") D MES^XPDUTL($J("",5)_"Electronic Signature Authorization Menu to main CHS Menu")
 I $$ADD^XPDMENU("ACHS E-SIG MENU","ACHS E-SIG AUTHORIZING OFC.","SIGA")
 I $$ADD^XPDMENU("ACHS E-SIG MENU","ACHS E-SIG ORDERING OFC.","SIGO") D MES^XPDUTL($J("",5)_"Electronic Signature for Authorizing Official, Electronic Signature for Ordering Official")
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
UFMS ;EP-from KIDS  PATCH 13
 ;ADD UFMS START DATE TO CHS FAC FILE
 S X=0 F  S X=$O(^ACHSF("B",X)) Q:X'?1N.N  D
 .S X1=0 F  S X1=$O(^ACHSF("B",X,X1)) Q:X1'?1N.N  D
 ..S:$P(^ACHSF(X1,0),U,8)="N" $P(^ACHSF(X1,0),U,13)=3071001
 ;ADD IE SERVER TO ZISH SEND PAR
 S X="ACHS UFMS B",DIC="^%ZIB(9888888.93,",DIC(0)="L"
 D ^DIC
 I Y<0 W !,"ZISH SEND PARAMETER FOR THE ACHS UFMS ENTRY COULD NOT BE ADDED, YOU WILL NEED TO THROUGH FILEMAN" Q
 S DA=+Y,DIE=DIC
 S DR=".02////"_"quovadx-ie.DOMAIN.NAME"_";.03////"_"ufmsuser"_";.04////"_"vjrsshn9"_";.06////"_"-iau"_";.07////"_"B"_";.08////"_"sendto"
 D ^DIE
 K D,D0,D1,DI,DIADD,DIC,DICR,DIE,DLAYGO,DQ,DR,DINUM,DA
 Q
P4 ;EP - from KIDS.
 Q:'$G(XPDQUES("POS4"))
 D BMES^XPDUTL("BEGIN Re-index of Patient Name in Deferred Services.")
 NEW ACHS,DA,DIK
 S ACHS=0
 F  S ACHS=$O(^ACHSDEF(ACHS)) Q:'ACHS  D
 .K ^ACHSDEF(ACHS,"D","C"),^ACHSDEF(ACHS,"D","N")
 .S DIK="^ACHSDEF("_ACHS_",""D"""_",",DA(1)=ACHS
 .F DIK(1)="6^C","7^N" D ENALL^DIK
 D MES^XPDUTL("END Re-index of Patient Name in Deferred Services.")
 Q
 ;
P5 ;EP - from KIDS
 Q:'$G(XPDQUES("POS5"))
 ;
 ; --- Atch Denial ltr edit option at 638 sites.
 S %="DENOPT^ACHS3113"
 I $$NEWCP^XPDUTL("POS5-"_%,%)
 ;
 ; --- Delete fields in CHS files marked for deletion.
 S %="DELFLD^ACHS3113"
 I $$NEWCP^XPDUTL("POS6-"_%,%)
 ;
 ; --- Atch 278 menu to Doc edit option.
 S %="M278^ACHS3113"
 I $$NEWCP^XPDUTL("POS7-"_%,%)
 ;
 ; --- Remove non-standard option auditing from CHS options. 
 S %="POS^ACHS31P0"
 I $$NEWCP^XPDUTL("POS8-"_%,%)
 Q
P6 ;EP - from KIDS
 Q:'$G(XPDQUES("POS9"))
 ;
 ; --- Atch Denial APPEAL option.
 S %="P6OPT^ACHS3113"
 I $$NEWCP^XPDUTL("POS9-"_%,%)
 ;
 ; --- Re-index non-registered patient name.
 S %="NONREG^ACHS3113"
 I $$NEWCP^XPDUTL("POS10-"_%,%)
 ;
 ; --- Set appeal status if denial reversed.
 S %="DENREV^ACHS3113"
 I $$NEWCP^XPDUTL("POS11-"_%,%)
 Q
 ;
P7 ;EP-from KIDS
 Q:'$G(XPDQUES("POS12"))
 ;
 ; --REMOVE OLD DD STUFF LEFT FROM VERSION 1.45 
 S %="V145DD^ACHS3113"
 I $$NEWCP^XPDUTL("POS12-"_%,%)
 ;
 ; ---ATTACH E SIG OPTIONS---
 S %="P7OPT^ACHS3113"
 I $$NEWCP^XPDUTL("POS13-"_%,%)
 Q
 ;
P12 ;EP-from KIDS
 Q:$$INSTALLD("ACHS*3.1*12")
 S %="TEST^ACHSPQTS"
 I $$NEWCP^XPDUTL("POS15-"_%,%)
 ;
 S %="HHS^ACHS3113"
 I $$NEWCP^XPDUTL("POS16-"_%,%)
 Q
P13 ;EP-from KIDS
 Q:$$INSTALLD("ACHS*3.1*13")
 S %="UFMS^ACHS3113"
 I $$NEWCP^XPDUTL("POS17-"_%,%)
 Q
