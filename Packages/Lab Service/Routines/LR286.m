LR286 ;VA/DALOI/JMC - LR*5.2*286 PATCH ENVIRONMENT CHECK ROUTINE ;JUL 06, 2010 3:14 PM
 ;;5.2;LAB SERVICE;**286,1027**;NOV 01, 1997
EN ; Does not prevent loading of the transport global.
 ; Environment check is done only during the install.
 ;
 N XQA,XQAMSG
 ;
 I '$G(XPDENV) D  Q
 . S XQAMSG="Transport global for patch "_$G(XPDNM,"Unknown patch")_" loaded on "_$$HTE^XLFDT($H)
 . D BMES^XPDUTL(XQAMSG)
 . S XQA("G.LMI")=""
 . ; D SETUP^XQALERT
 . ; D BMES^XPDUTL($$CJ^XLFSTR("Sending transport global loaded alert to mail group G.LMI",80))
 ;
 S XQAMSG="Installation of patch "_$G(XPDNM,"Unknown patch")_" started on "_$$HTE^XLFDT($H)
 D BMES^XPDUTL(XQAMSG)
 S XQA("G.LMI")=""
 ; D SETUP^XQALERT
 ; D BMES^XPDUTL($$CJ^XLFSTR("Sending install started alert to mail group G.LMI",80))
 ;
 D CHECK
 D EXIT
 Q
 ;
CHECK ; Perform environment check
 I $S('$G(IOM):1,'$G(IOSL):1,$G(U)'="^":1,1:0) D  Q
 . D BMES^XPDUTL($$CJ^XLFSTR("Terminal Device is not defined",80))
 . S XPDQUIT=2
 I $S('$G(DUZ):1,$D(DUZ)[0:1,$D(DUZ(0))[0:1,1:0) D  Q
 . D BMES^XPDUTL($$CJ^XLFSTR("Please log in to set local DUZ... variables",80))
 . S XPDQUIT=2
 I $P($$ACTIVE^XUSER(DUZ),"^")'=1 D  Q
 . D BMES^XPDUTL($$CJ^XLFSTR("You are not a valid user on this system",80))
 . S XPDQUIT=2
 S XPDIQ("XPZ1","B")="NO"
 Q
 ;
 ;
EXIT ;
 I $G(XPDQUIT) D BMES^XPDUTL($$CJ^XLFSTR("--- Install Environment Check FAILED ---",80))
 I '$G(XPDQUIT) D BMES^XPDUTL($$CJ^XLFSTR("--- Environment Check is Ok ---",80))
 Q
 ;
 ;
PRE ; KIDS Pre install
 N DIU
 D BMES^XPDUTL($$CJ^XLFSTR("*** Pre install started ***",80))
 ;
 D BMES^XPDUTL($$CJ^XLFSTR("*** Deleting Data Dictionary for LAB PENDING ORDERS ENTRY file (#69.6) ***",80))
 D BMES^XPDUTL($$CJ^XLFSTR("*** Will be reinstalled by this KIDS build ***",80))
 S DIU="^LRO(69.6,",DIU(0)="" D EN^DIU2
 ;
 D BMES^XPDUTL($$CJ^XLFSTR("*** Pre install completed ***",80))
 Q
 ;
 ;
POST ; KIDS Post install
 N DIK,XQA,XQAMSG,ZTDESC,ZTDTH,ZTIO,ZTRTN,ZTSAVE,ZTSK
 D BMES^XPDUTL($$CJ^XLFSTR("*** Post install started ***",80))
 ;
 ; Reindex "D" x-ref on field #18 of file #69.6.
 D BMES^XPDUTL($$CJ^XLFSTR("*** Tasking reindexing of field #18 of LAB PENDING ORDERS ENTRY file ***",80))
 K ^LRO(69.6,"D")
 S DIK="^LRO(69.6,",DIK(1)="18^D"
 S ZTSAVE("DIK*")="",ZTIO="",ZTDTH=$H
 S ZTDESC="Reindex of 'D' index file 69.6 (LR*5.2*286)"
 S ZTRTN="ENALL^DIK"
 D ^%ZTLOAD
 ;
 D BMES^XPDUTL($$CJ^XLFSTR("*** Post install completed ***",80))
 ; D BMES^XPDUTL($$CJ^XLFSTR("Sending install completion alert to mail group G.LMI",80))
 S XQAMSG="Installation of patch "_$G(XPDNM,"Unknown patch")_" completed on "_$$HTE^XLFDT($H)
 D BMES^XPDUTL(XQAMSG)
 ; S XQA("G.LMI")=""
 ; D SETUP^XQALERT
 Q
