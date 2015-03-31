ICD002P ;IHS/OIT/FCJ - ICD UPDATES PATCH 1002 ; 14 Mar 2012  12:32 PM
 ;;18.0;DRG Grouper;**1002**;Oct 20, 2000;Build 9
 ;
 ;
 ;
POST ;EP FROM KERNAL
 S %="HIST^ICD002P"
 I $$NEWCP^XPDUTL("POS4-"_%,%)
 S %="MAIL^ICD002P"
 I $$NEWCP^XPDUTL("POS5-"_%,%)
 ;
 Q
MAIL ;
 D BMES^XPDUTL("BEGIN Delivering MailMan message to select users.")
 NEW DIFROM,XMSUB,XMDUZ,XMTEXT,XMY
 KILL ^TMP("ICD002",$J)
 D RSLT(" --- ICD v 18.0 Patch 1002, have been installed into this namespace ---")
 F %=1:1 D RSLT($P($T(GREET+%),";",3)) Q:$P($T(GREET+%+1),";",3)="###"
 S %=0
 F  S %=$O(^XTMP("XPDI",XPDA,"BLD",XPDBLD,1,%)) Q:'%   D RSLT(^(%,0))
 S XMSUB=$P($P($T(+1),";",2)," ",3,99),XMDUZ=$S($G(DUZ):DUZ,1:.5),XMTEXT="^TMP(""ICD002"",$J,",XMY(1)="",XMY(DUZ)=""
 F %="XUMGR","XUPROG","XUPROGMODE" D SINGLE(%)
 D ^XMD
 KILL ^TMP("ICD002",$J)
 D MES^XPDUTL("END Delivering MailMan message to select users.")
 Q
 ;
RSLT(%) S ^(0)=$G(^TMP("ICD002",$J,0))+1,^(^(0))=%
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
 ;;refer to patch "ICD*18.0*1002".
 ;;  
 ;;###;NOTE: This line end of text.
 ;
HIST ;PATCH HISTORY UPDATE
 D MES^XPDUTL("Begin adding patches to package file.")
 S DDLM=";;",DLM="|",TAG="ICD"
 S PKGNM="DRG GROUPER"
 I '$D(^DIC(9.4,"B",PKGNM)) D MES^XPDUTL("Problem with package name.") Q
 S PKGIEN=$O(^DIC(9.4,"B",PKGNM,0))
 S:$$GET1^DIQ(9.4,PKGIEN,13)'="18.0" FDA(9.4,PKGIEN_",",13)="18.0" D FILE^DIE(,"FDA")
 K FDA
 F I=1:1 D  Q:TEXT["END"
 .S TEXT=$T(@TAG+I) Q:TEXT["END"
 .S DATA=$P(TEXT,DDLM,2)
 .S VERSION=$P(DATA,DLM,2),PATCH=$P(DATA,DLM,3)
 .S VSB=$O(^DIC(9.4,PKGIEN,22,"B",VERSION,0))
 .Q:'VSB
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
ICD ;
 ;;DRG GROUPER|18.0|33 SEQ #32
 ;;DRG GROUPER|18.0|35 SEQ #33
 ;;DRG GROUPER|18.0|36 SEQ #34
 ;;DRG GROUPER|18.0|38 SEQ #35
 ;;DRG GROUPER|18.0|37 SEQ #36
 ;;DRG GROUPER|18.0|34 SEQ #37
 ;;DRG GROUPER|18.0|41 SEQ #38
 ;;DRG GROUPER|18.0|39 SEQ #39
 ;;DRG GROUPER|18.0|42 SEQ #40
 ;;DRG GROUPER|18.0|43 SEQ #41
 ;;DRG GROUPER|18.0|44 SEQ #42
 ;;DRG GROUPER|18.0|45 SEQ #43
 ;;DRG GROUPER|18.0|47 SEQ #44
 ;;DRG GROUPER|18.0|49 SEQ #50
 ;;DRG GROUPER|18.0|53 SEQ #51
 ;;DRG GROUPER|18.0|54 SEQ #52
 ;;DRG GROUPER|18.0|59 SEQ #53
 ;END
