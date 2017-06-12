LEX2I04P ;IHS/OIT/FCJ - LEXICON UTILITY PATCH 1004 ; 14 Mar 2012  12:44 PM
 ;;2.0;LEXICON UTILITY;**1004**;Sep 23, 1996;Build 5
 ;=================================================================
 ;Original routine from LEX2I02P
 ;
POST ;EP FROM KERNAL
 ;
MAIL ;
 D BMES^XPDUTL("BEGIN Delivering MailMan message to select users.")
 NEW DIFROM,XMSUB,XMDUZ,XMTEXT,XMY
 KILL ^TMP("LEX1004",$J)
 D RSLT(" --- LEX v 2.0 Patch 1004, have been installed into this namespace ---")
 F %=1:1 D RSLT($P($T(GREET+%),";",3)) Q:$P($T(GREET+%+1),";",3)="###"
 S %=0
 F  S %=$O(^XTMP("XPDI",XPDA,"BLD",XPDBLD,1,%)) Q:'%   D RSLT(^(%,0))
 S XMSUB=$P($P($T(+1),";",2)," ",3,99),XMDUZ=$S($G(DUZ):DUZ,1:.5),XMTEXT="^TMP(""LEX1004"",$J,",XMY(1)="",XMY(DUZ)=""
 F %="LEXZMENU","XUMGR","XUPROG","XUPROGMODE" D SINGLE(%)
 D ^XMD
 KILL ^TMP("LEX1004",$J)
 D MES^XPDUTL("END Delivering MailMan message to select users.")
 Q
 ;
RSLT(%) S ^(0)=$G(^TMP("LEX1004",$J,0))+1,^(^(0))=%
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
 ;;refer to patch "LEX*2.1*1004".
 ;;  
 ;;###;NOTE: This line end of text.
 ;
