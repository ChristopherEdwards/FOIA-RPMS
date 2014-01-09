LEX2I02P ;IHS/OIT/FCJ - LEXICON UTILITY PATCH 1002 ; 14 Mar 2012  12:44 PM
 ;;2.0;LEXICON UTILITY;**1002**;Sep 23, 1996;Build 15
 ;=================================================================
 ;
 ;
POST ;EP FROM KERNAL
 S %="HIST^LEX2I02P"
 I $$NEWCP^XPDUTL("POS4-"_%,%)
 S %="OPT^LEX2I02P"
 I $$NEWCP^XPDUTL("POS5-"_%,%)
 S %="MAIL^LEX2I02P"
 I $$NEWCP^XPDUTL("POS6-"_%,%)
 ;
 Q
MAIL ;
 D BMES^XPDUTL("BEGIN Delivering MailMan message to select users.")
 NEW DIFROM,XMSUB,XMDUZ,XMTEXT,XMY
 KILL ^TMP("LEX1002",$J)
 D RSLT(" --- LEX v 2.0 Patch 1002, have been installed into this namespace ---")
 F %=1:1 D RSLT($P($T(GREET+%),";",3)) Q:$P($T(GREET+%+1),";",3)="###"
 S %=0
 F  S %=$O(^XTMP("XPDI",XPDA,"BLD",XPDBLD,1,%)) Q:'%   D RSLT(^(%,0))
 S XMSUB=$P($P($T(+1),";",2)," ",3,99),XMDUZ=$S($G(DUZ):DUZ,1:.5),XMTEXT="^TMP(""LEX1002"",$J,",XMY(1)="",XMY(DUZ)=""
 F %="LEXZMENU","XUMGR","XUPROG","XUPROGMODE" D SINGLE(%)
 D ^XMD
 KILL ^TMP("LEX1002",$J)
 D MES^XPDUTL("END Delivering MailMan message to select users.")
 Q
 ;
RSLT(%) S ^(0)=$G(^TMP("LEX1002",$J,0))+1,^(^(0))=%
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
 ;;Routines and/or data dictionaries on your RPMS system have been updated.
 ;;  
 ;;You are receiving this message because of the RPMS
 ;;security keys that you hold.  This is for your information.
 ;;Do not respond to this message.
 ;;  
 ;;Questions about this patch may be directed to
 ;;the ITSC Support Center, at 505-248-4371,
 ;;refer to patch "LEX*2.1*1002".
 ;;  
 ;;###;NOTE: This line end of text.
 ;
HIST ;PATCH HISTORY UPDATE
 D MES^XPDUTL("Begin adding patches to package file.")
 S DDLM=";;",DLM="|",TAG="LEX"
 S PKGNM="LEXICON UTILITY"
 I '$D(^DIC(9.4,"B",PKGNM)) D MES^XPDUTL("Problem with package name.") Q
 S PKGIEN=$O(^DIC(9.4,"B",PKGNM,0))
 F I=1:1  D  Q:TEXT["END"
 .S TEXT=$T(@TAG+I) Q:TEXT["END"
 .S DATA=$P(TEXT,DDLM,2)
 .S VERSION=$P(DATA,DLM,2),PATCH=$P(DATA,DLM,3)
 .S VSB=$O(^DIC(9.4,PKGIEN,22,"B",VERSION,0))
 .Q:'VSB
 .K FDA
 .; Do not update if the patch is already in the patch history
 .Q:$D(^DIC(9.4,PKGIEN,22,VSB,"PAH","B",PATCH))
 .S FDA(9.4901,"+1,"_VSB_","_PKGIEN_",",.01)=$G(PATCH)
 .S FDA(9.4901,"+1,"_VSB_","_PKGIEN_",",.02)=DT
 .S FDA(9.4901,"+1,"_VSB_","_PKGIEN_",",.03)=DUZ
 .D UPDATE^DIE(,"FDA")
 .D:$G(DIERR)'="" MES^XPDUTL("Error adding patch "_PATCH_" to package file.")
 D MES^XPDUTL("Completed adding patches to package file.")
 Q
 ;;;;FORMAT - Package name|Version|Patch|Sequence
LEX ;
 ;;LEXICON UTILITY|2.0|56 SEQ #52
 ;;LEXICON UTILITY|2.0|41 SEQ #53
 ;;LEXICON UTILITY|2.0|60 SEQ #54
 ;;LEXICON UTILITY|2.0|59 SEQ #55
 ;;LEXICON UTILITY|2.0|61 SEQ #56
 ;;LEXICON UTILITY|2.0|63 SEQ #57
 ;;LEXICON UTILITY|2.0|65 SEQ #58
 ;;LEXICON UTILITY|2.0|62 SEQ #59
 ;;LEXICON UTILITY|2.0|66 SEQ #60
 ;;LEXICON UTILITY|2.0|55 SEQ #61
 ;;LEXICON UTILITY|2.0|67 SEQ #62
 ;;LEXICON UTILITY|2.0|68 SEQ #63
 ;;LEXICON UTILITY|2.0|69 SEQ #64
 ;;LEXICON UTILITY|2.0|70 SEQ #65
 ;;LEXICON UTILITY|2.0|72 SEQ #66
 ;;LEXICON UTILITY|2.0|74 SEQ #67
 ;;LEXICON UTILITY|2.0|76 SEQ #68
 ;;LEXICON UTILITY|2.0|73 SEQ #69
 ;;LEXICON UTILITY|2.0|77 SEQ #70
 ;;LEXICON UTILITY|2.0|78 SEQ #71
 ;;LEXICON UTILITY|2.0|81 SEQ #73
 ;END
OPT ;ADD LEXICON OPTION TO AKMOCORE
 D BMES^XPDUTL("BEGIN Adding Lexicon menu to AKMOCORE.")
 I $$ADD^XPDMENU("LEX MGT MENU","Lexicon Management Menu","LEX") D
 .D MES^XPDUTL($J("",5)_"Lexicon Menu added to the IHS Core menu.")
 .D MES^XPDUTL($J("",5)_"Note that the security lock was *NOT* allocated.") I 1
 E  D MES^XPDUTL($J("",5)_"ERROR:   Lexicon menu add FAILED, may already be assigned to CORE.")
 D MES^XPDUTL("END Adding Lexicon menu.")
