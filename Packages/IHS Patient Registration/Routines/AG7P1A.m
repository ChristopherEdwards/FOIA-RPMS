AG7P1A ;IHS/ASDST/GTH - Patient Registration 7.0 Patch 1 CONT. ;   [ 06/17/2003  10:49 AM ]
 ;;7.0;IHS PATIENT REGISTRATION;**1**;JUN 13, 2003
 ;
 ; IHS/SD/EFG  AG*7*1  5/8/2003
 ;
PRE ;EP - From KIDS.
 Q
 ;
POST ;EP - From KIDS.
 ;
 D BMES^XPDUTL("Beginning post-install routine (POST^AG7P1A)."),TS
 ;
 D ^AGSETPRT
 ;
 I $$INSTALLD^AG7P1("AG*7.0*1")  D
 . D TS,BMES^XPDUTL("Delivering AG*7.0*1 install message to select users...")
 . D MAIL
 . D BMES^XPDUTL("Post-install routine is complete."),TS
 ;
 Q:$$INSTALLD^AG7P1("AG*7.0*1")
 ;
 D TS,OPTRES("AGMENU")
 ;
 D TS,BMES^XPDUTL("Delivering AG*7.0*1 install message to select users...")
 D MAIL
 ;
 D BMES^XPDUTL("Post-install routine is complete."),TS
 Q
 ;
MAIL ; Send install mail message.
 NEW DIFROM,XMSUB,XMDUZ,XMTEXT,XMY
 KILL ^TMP("AG7P1MS",$J)
 S ^TMP("AG7P1MS",$J,1)=" --- AG v 7.0, has been installed into this uci ---"
 S %=0
 F  S %=$O(^XTMP("XPDI",XPDA,"BLD",XPDBLD,1,%)) Q:'%   S ^TMP("AG7P1MS",$J,(%+1))=" "_^(%,0)
 S XMSUB=$P($P($T(+1),";",2)," ",3,99),XMDUZ=$S($G(DUZ):DUZ,1:.5),XMTEXT="^TMP(""AG7P1MS"",$J,",XMY(1)="",XMY(DUZ)=""
 F %="AGZMENU","XUMGR","XUPROG","XUPROGMODE" D SINGLE(%)
 D ^XMD
 KILL ^TMP("AG7P1MS",$J)
 Q
 ;
SINGLE(K) ;EP - Get holders of a single key K.
 NEW Y
 S Y=0
 Q:'$D(^XUSEC(K))
 F  S Y=$O(^XUSEC(K,Y)) Q:'Y  S XMY(Y)=""
 Q
 ;
OPTRES(AGM) ;
 D BMES^XPDUTL("Restoring '"_AGM_"' option to PRE-install configuration...")
 NEW AG,AGI
 I '$D(^XTMP("AG7P1",7.1,"OPTSAV",AGM)) D BMES^XPDUTL("FAILED.  Option '"_AGM_"' was not previously saved.") Q
 S AG=0
 F  S AG=$O(^XTMP("AG7P1",7.1,"OPTSAV",AGM,AG)) Q:'AG  S AGI=^(AG) I '$$ADD^XPDMENU(AGM,$P(AGI,U,1),$P(AGI,U,2),$P(AGI,U,3)) D BMES^XPDUTL("....FAILED to re-atch "_$P(AGI,U,1)_" to "_AGM_".")
 D BMES^XPDUTL("Attaching ""RHI1"" option to the Registration Reports menu ""RPT"".")
 I $$ADD^XPDMENU("AGREPORTS","AGRHI1","RHI1",20) D BMES^XPDUTL("....successfully atch'd.") I 1
 E  D BMES^XPDUTL("....Attachment *FAILED*.")
 ;
 Q
 ;
TS D MES^XPDUTL($$HTE^XLFDT($H)) Q
 ;
