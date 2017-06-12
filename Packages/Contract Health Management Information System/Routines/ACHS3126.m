ACHS3126 ;IHS/OIT/FCJ - ACHS 3.1 PATCH 26 ;7/30/10  08:37
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**26**;JUNE 11,2001;Build 37
 ;IHS/OIT/FCJ - COPY OF P25
 ;ENV CHECK TO ACHS31E1
 ;
PRE ;EP - From KIDS.
 I $$NEWCP^XPDUTL("PRE1","AUDS^ACHS3126")
 Q
 ;
POST ;EP - From KIDS.
 ;
 ;PATCH 21 AREA UPDATES
 S %="P21^ACHS3126"
 I $$NEWCP^XPDUTL("POS2-"_%,%)
 ;
 ;PATCH 22 NEW ICD9 REPORT MENU OPTION
 S %="P22^ACHS3126"
 I $$NEWCP^XPDUTL("POS3-"_%,%)
 ;
 ;PATCH 24 Set ICD10 Parameters
 S %="P24^ACHS3126"
 I $$NEWCP^XPDUTL("POS4-"_%,%)
 ;
 ;PATCH 25 Clean up the option
 S %="P25^ACHS3126"
 I $$NEWCP^XPDUTL("POS5-"_%,%)
 ;
 ;PATCH 26 New report options
 S %="P26^ACHS3126"
 I $$NEWCP^XPDUTL("POS6-"_%,%)
 ;
 ; --- Restore dd audit settings.
 S %="AUDR^ACHS3126"
 I $$NEWCP^XPDUTL("POS7-"_%,%)
 ;
 ; --- Send mail message of install.
 S %="MAIL^ACHS3126"
 I $$NEWCP^XPDUTL("POS8-"_%,%)
 ;
 Q
MAIL ;
 D BMES^XPDUTL("BEGIN Delivering MailMan message to select users.")
 NEW DIFROM,XMSUB,XMDUZ,XMTEXT,XMY
 KILL ^TMP("ACHS3126",$J)
 D RSLT(" --- ACHS v 3.1 Patch 26, has been installed into this namespace ---")
 F %=1:1 D RSLT($P($T(GREET+%),";",3)) Q:$P($T(GREET+%+1),";",3)="###"
 S %=0
 F  S %=$O(^XTMP("XPDI",XPDA,"BLD",XPDBLD,1,%)) Q:'%   D RSLT(^(%,0))
 S XMSUB=$P($P($T(+1),";",2)," ",3,99),XMDUZ=$S($G(DUZ):DUZ,1:.5),XMTEXT="^TMP(""ACHS3126"",$J,",XMY(1)="",XMY(DUZ)=""
 F %="ACHSZMENU","XUMGR","XUPROG","XUPROGMODE" D SINGLE(%)
 D ^XMD
 KILL ^TMP("ACHS3126",$J)
 D MES^XPDUTL("END Delivering MailMan message to select users.")
 Q
 ;
RSLT(%) S ^(0)=$G(^TMP("ACHS3126",$J,0))+1,^(^(0))=%
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
 ;;Standard Routines on your RPMS system have been updated.
 ;;  
 ;;You are receiving this message because of the RPMS
 ;;security keys that you hold.  This is for your information.
 ;;Do not respond to this message.
 ;;  
 ;;Questions about this patch may be directed to
 ;;the ITSC Support Center, at 505-248-4297,
 ;;refer to patch "ACHS*3.1*26".
 ;;  
 ;;###;NOTE: This line end of text.
 ; ---------------------------------------------
 ; The global location for dictionary audit is:
 ;           ^DD(FILE,0,"DDA")
 ; value = "Y", dd audit is on.  Any other value, or the
 ; absence of the node, means dd audit is off.
 ;
AUDS ;EP - From KIDS.
 D BMES^XPDUTL("Saving current DD AUDIT settings for files in this patch")
 D MES^XPDUTL("and turning DD AUDIT to 'Y'.")
 S ^XTMP("ACHS3126",0)=$$FMADD^XLFDT(DT,10)_"^"_DT_"^"_$P($P($T(+1),";",2)," ",3,99)
 NEW ACHS
 S ACHS=0
 F  S ACHS=$O(^XTMP("XPDI",XPDA,"FIA",ACHS)) Q:'ACHS  D
 . I '$D(^XTMP("ACHS3126",ACHS,"DDA")) S ^XTMP("ACHS3126",ACHS,"DDA")=$G(^DD(ACHS,0,"DDA"))
 . D MES^XPDUTL(" File "_$$RJ^XLFSTR(ACHS,12)_" - "_$$LJ^XLFSTR(^XTMP("XPDI",XPDA,"FIA",ACHS),30)_"- DD audit was '"_$G(^XTMP("ACHS3126",ACHS,"DDA"))_"'"),MES^XPDUTL($$RJ^XLFSTR("Set to 'Y'",69))
 . S ^DD(ACHS,0,"DDA")="Y"
 D MES^XPDUTL("DD AUDIT settings saved in ^XTMP(.")
 Q
 ;
AUDR ; Restore the file data audit values to their original values.
 D BMES^XPDUTL("Restoring DD AUDIT settings for files in this patch.")
 NEW ACHS
 S ACHS=0
 F  S ACHS=$O(^XTMP("ACHS3126",ACHS)) Q:'ACHS  D
 . S ^DD(ACHS,0,"DDA")=^XTMP("ACHS3126",ACHS,"DDA")
 . D MES^XPDUTL(" File "_$$RJ^XLFSTR(ACHS,12)_" - "_$$LJ^XLFSTR($$GET1^DID(ACHS,"","","NAME"),30)_"- DD AUDIT Set to '"_^DD(ACHS,0,"DDA")_"'")
 .Q
 KILL ^XTMP("ACHS3126")
 D MES^XPDUTL("DD AUDIT settings restored.")
 Q
 ;
P21 ;PATCH 21
 ;REMOVE 2 SPLITOUT MENU OPT NOW COMBINED WITH THE PROCESSING OPTIONS
 Q:$$INSTALLD^ACHS31E1("ACHS*3.1*21")
 D BMES^XPDUTL("Begin Removing split out options.")
 I $$DELETE^XPDMENU("ACHSAREA","ACHSAREA SP/EX") D MES^XPDUTL($J("",5)_"Removed Option: Area CHS Splitout / Export To HAS/FI/CORE")
 I $$DELETE^XPDMENU("ACHSAREAEOBRPROC","ACHSAREAEOBROUT") D MES^XPDUTL($J("",5)_"Remove Option: Area CHS Generate Facility EOBR Files")
 D MES^XPDUTL("END updating options.")
 ;SET PRINT EOBR PARAMETER TO NO
 S ACHS=0
 F  S ACHS=$O(^ACHSF("B",ACHS)) Q:ACHS'?1N.N  D
 .S DA=ACHS,DIE="^ACHSF("
 .S DR="14.14///N"
 .D ^DIE
 Q
 ;
P22 ;PATCH 22
 Q:$$INSTALLD^ACHS31E1("ACHS*3.1*22")
 ;ADD NEW OPTIONS - P22-ICD9 REPORT OPTION
 D BMES^XPDUTL("Begin adding new option.")
 I $$ADD^XPDMENU("ACHSREPORTS","ACHSRPTICDERROR","ICDR") D MES^XPDUTL($J("",5)_"Added ICD9 Report - to reports option")
 D MES^XPDUTL("END updating options.")
 ;SET UP ICD GLOBALS
 D SET^ACHSIC2
 Q
 ;
P24 ;PATCH 24
 Q:$$INSTALLD^ACHS31E1("ACHS*3.1*24")
 ;ADD ICD START DATE IN PARAMETERS
 D BMES^XPDUTL("Checking/Updating ICD10 PARAMETERS.")
 S L=0
 F  S L=$O(^ACHSF(L)) Q:L'?1N.N  D
 .S $P(^ACHSF(L,0),U,17,18)="3151001^3151001"
 ;
 D MES^XPDUTL("END updating Parameters.")
 K L
 Q
 ;
P25 ;PATCH 25
 Q:$$INSTALLD^ACHS31E1("ACHS*3.1*25")
 Q:'$D(^DIC(19,"B","ACHS DEN REP-CARE NOT MED PRI"))
 S L=0,L=$O(^DIC(19,"B","ACHS DEN REP-CARE NOT MED PRI",L))
 S (^DIC(19,L,20),^DIC(19,L,60),^DIC(19,L,62),^DIC(19,L,63),^DIC(19,L,64),^DIC(19,L,69))=""
 Q
P26 ;PATCH 26
 Q:$$INSTALLD^ACHS31E1("ACHS*3.1*26")
 ;ADD NEW REPORT OPTIONS
 D BMES^XPDUTL("Begin adding new option.")
 I $$ADD^XPDMENU("ACHSREPORTS","ACHS MENU SPEC REPORTS","SPEC") D MES^XPDUTL($J("",5)_"Added Special Reports option")
 I $$ADD^XPDMENU("ACHS MENU SPEC REPORTS","ACHSDOCSTATUSREPFY-FILE","DSFY") D MES^XPDUTL($J("",5)_"Added Document Status Report by FY with option to create file")
 I $$ADD^XPDMENU("ACHS MENU SPEC REPORTS","ACHSDOCSTATUSREPFYTOT","DSFT") D MES^XPDUTL($J("",5)_"Added Document Status Report with totals by FY selected")
 I $$ADD^XPDMENU("ACHS MENU SPEC REPORTS","ACHS REPORT DOS","DOSR") D MES^XPDUTL($J("",5)_"Added Report for Estimated and Actual DOS with issue date")
 I $$ADD^XPDMENU("ACHS MENU SPEC REPORTS","ACHSDOCSTATUSSPLOC","DSSP") D MES^XPDUTL($J("",5)_"Added Document Status Report for Special local PO's")
 I $$ADD^XPDMENU("ACHS MENU SPEC REPORTS","ACHSDOCSTATUSREPEOBR","DSEB") D MES^XPDUTL($J("",5)_"Added Document Status Report for Paid PO's with EOBR date")
 I $$ADD^XPDMENU("ACHS MENU VENDOR REPORTS","ACHSVNDRUSAGE-SPECIFIC","VURS") D MES^XPDUTL($J("",5)_"Added Vendor Usage Report by Vendor with option to create file")
 I $$ADD^XPDMENU("ACHS MENU VENDOR REPORTS","ACHSVNDRUSAGEFY","VFY") D MES^XPDUTL($J("",5)_"Added FY Vendor usage report by selected Vendor")
 I $$ADD^XPDMENU("ACHS DEFDEN MENU DEN REPORTS","ACHS DEN PVDRLIST-SPECIFIED","PVDS") D MES^XPDUTL($J("",5)_"Added Denial Report by selected Vendor")
 I $$ADD^XPDMENU("ACHSAD","ACHSDOCUMENTTRANS","TRD") D MES^XPDUTL($J("",5)_"Added Document Transaction report")
 D MES^XPDUTL("END updating options.")
 ;ADD ENTRY TO ZISH PARAMETER FILE
 S X="ACHS REPORTS",DIC="^%ZIB(9888888.93,",DIC(0)="L"
 D ^DIC
 I Y<0 W !,"ZISH SEND PARAMETER FOR THE ACHS UFMS ENTRY COULD NOT BE ADDED, YOU WILL NEED TO THROUGH FILEMAN" Q
 S DA=+Y,DIE=DIC
 S DR=".07////"_"B"_";.08////"_"sendto"
 D ^DIE
 K D,D0,D1,DI,DIADD,DIC,DICR,DIE,DLAYGO,DQ,DR,DINUM,DA
 Q
