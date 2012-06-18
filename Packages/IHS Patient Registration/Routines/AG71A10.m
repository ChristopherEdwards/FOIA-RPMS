AG71A10 ;VNGT/HS/BEE - Patient Registration 7.1 PATCH 10 POST INSTALL ; JUL 05, 2011   
 ;;7.1;PATIENT REGISTRATION;**10**;AUG 25, 2005;Build 7
 ;
 Q
 ;
POST ;EP - From KIDS.
 ;
 N MMSG
 ;
 D TS,BMES^XPDUTL("Beginning post-install routine (POST^AG71A10).")
 ;
 ;Add MPI MENU to AGMENU
 D ADDMENU
 ;
 ;Deliver Mail Message
 S MMSG=" --- AG v 7.1 Patch 10 has been installed into this uci --- "
 D MAIL(MMSG)
 ;
 D TS,BMES^XPDUTL("AG v 7.1 Patch 10 Post-install is complete.")
 Q
 ;
ADDMENU ;EP - ADD MPI MENU TO AGMENU
 ;
 ;I $$VCHK^AG72ENMP("AG","7.2",2) D  ;CHECK FOR VERSION 2 INSTALLED
 I $$VERSION^XPDUTL("AG")>7.1 D  ;Check for version 7.2 installed
 . N RET
 . S RET=$$ADD^XPDMENU("AGMENU","AGMP HLO MPI MANAGER OPTIONS","MPI",13)
 . D BMES^XPDUTL($$CJ^XLFSTR("MPI Manager Options [AGMP HLO MPI MANAGER OPTIONS] option",80))
 . D BMES^XPDUTL($$CJ^XLFSTR("was"_$S(RET:"",1:" NOT")_" added to the Patient Registration Menu [AGMENU] ",80))
 Q
 ;
MAIL(MMSG) ;Send install mail message.
 N %,CNT,DIFROM,XMSUB,XMDUZ,XMTEXT,XMY
 K ^TMP("AG71MS",$J)
 S ^TMP("AG71MS",$J,1)=$G(MMSG)
 S ^TMP("AG71MS",$J,2)=" "
 S CNT=3
 ;
 S %=0
 Q:$G(XPDA)=""
 Q:$G(XPDBLD)=""
 F  S %=$O(^XTMP("XPDI",XPDA,"BLD",XPDBLD,1,%)) Q:'%   S ^TMP("AG71MS",$J,(%+CNT))=" "_^(%,0)
 S XMSUB=$P($P($T(+1),";",2)," ",3,99),XMDUZ=$S($G(DUZ):DUZ,1:.5),XMTEXT="^TMP(""AG71MS"",$J,",XMY(1)="",XMY(DUZ)=""
 F %="AGZMENU","XUMGR","XUPROG","XUPROGMODE" D SINGLE(%)
 D ^XMD
 K ^TMP("AG71MS",$J)
 Q
SINGLE(K) ;EP - Get holders of a single key K.
 N Y
 S Y=0
 Q:'$D(^XUSEC(K))
 F  S Y=$O(^XUSEC(K,Y)) Q:'Y  S XMY(Y)=""
 Q
 ;
TS D MES^XPDUTL($$HTE^XLFDT($H)) Q
