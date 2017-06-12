LEX2I03P ;IHS/OIT/FCJ - LEXICON UTILITY PATCH 1003 ; 14 Mar 2012  12:44 PM
 ;;2.0;LEXICON UTILITY;**1003**;Sep 23, 1996;Build 10
 ;=================================================================
 ;Original routine from LEX2I02P
 ;
POST ;EP FROM KERNAL
 S %="HIST^LEX2I03P"
 I $$NEWCP^XPDUTL("POS4-"_%,%)
 S %="UNCD^LEX2I03P"
 I $$NEWCP^XPDUTL("POS5-"_%,%)
 S %="MAIL^LEX2I03P"
 I $$NEWCP^XPDUTL("POS6-"_%,%)
 ;
 Q
MAIL ;
 D BMES^XPDUTL("BEGIN Delivering MailMan message to select users.")
 NEW DIFROM,XMSUB,XMDUZ,XMTEXT,XMY
 KILL ^TMP("LEX1003",$J)
 D RSLT(" --- LEX v 2.0 Patch 1003, have been installed into this namespace ---")
 F %=1:1 D RSLT($P($T(GREET+%),";",3)) Q:$P($T(GREET+%+1),";",3)="###"
 S %=0
 F  S %=$O(^XTMP("XPDI",XPDA,"BLD",XPDBLD,1,%)) Q:'%   D RSLT(^(%,0))
 S XMSUB=$P($P($T(+1),";",2)," ",3,99),XMDUZ=$S($G(DUZ):DUZ,1:.5),XMTEXT="^TMP(""LEX1003"",$J,",XMY(1)="",XMY(DUZ)=""
 F %="LEXZMENU","XUMGR","XUPROG","XUPROGMODE" D SINGLE(%)
 D ^XMD
 KILL ^TMP("LEX1003",$J)
 D MES^XPDUTL("END Delivering MailMan message to select users.")
 Q
 ;
RSLT(%) S ^(0)=$G(^TMP("LEX1003",$J,0))+1,^(^(0))=%
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
 ;;refer to patch "LEX*2.1*1003".
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
UNCD ;ADD UNCODED DX CODES
 Q:$D(^LEX(757.02,"CODE",".9999 "))
 F UNCD=".9999","ZZZ.999" D
 .S DIC="^LEX(757.02,",X="Uncoded Diagnosis",DIC(0)="LI",DLAYGO=757.02,DIADD=1
 .S CLS=$S(UNCD=".9999":1,1:30)
 .S DIC("DR")="1////"_UNCD_";2////"_CLS_";3////155739;4////0;6////0"
 .D ^DIC I +Y<0 W !,"Uable to add the uncoded DX ",UNCD Q
 .S DA(1)=+Y,DIC="^LEX(757.02,"_DA(1)_",4,",DIC(0)="LI"
 .S ^LEX(757.02,DA(1),4,0)="^757.28DA^0^0"
 .I UNCD=".9999" D  Q
 ..S DA=1,X=2781001,DIC("DR")="1////1" D ^DIC I +Y<0 W !,"Uable to add the uncoded DX ",UNCD," active date." Q
 ..S DA=2,X=3141001,DIC("DR")="1////0" D ^DIC I +Y<0 W !,"Uable to add the uncoded DX ",UNCD," inactive date." Q
 .S DA=1,X=3141001,DIC("DR")="1////1" D ^DIC I +Y<0 W !,"Uable to add the uncoded DX ",UNCD," active date."
 K UNCD,CLS,DIADD,DIC,DA
 Q
 ;;;;FORMAT - Package name|Version|Patch|Sequence
LEX ;
 ;;LEXICON UTILITY|2.0|79 SEQ #72
 ;;LEXICON UTILITY|2.0|82 SEQ #74
 ;;LEXICON UTILITY|2.0|83 SEQ #75
 ;;LEXICON UTILITY|2.0|84 SEQ #76
 ;;LEXICON UTILITY|2.0|51 SEQ #77
 ;;LEXICON UTILITY|2.0|58 SEQ #78
 ;;LEXICON UTILITY|2.0|89 SEQ #79
 ;;LEXICON UTILITY|2.0|90 SEQ #80
 ;;LEXICON UTILITY|2.0|91 SEQ #81
 ;;LEXICON UTILITY|2.0|93 SEQ #82
 ;;LEXICON UTILITY|2.0|94 SEQ #83
 ;;LEXICON UTILITY|2.0|80
 ;END
