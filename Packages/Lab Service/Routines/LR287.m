LR287 ;DALOI/JMC - LR*5.2*287 PATCH ENVIRONMENT CHECK ROUTINE ;5/13/2002
 ;;5.2;LR;**287,1022**;September 20, 2007
 ;
 ; This VA Patch is being included as part of IHS Lab Patch 1022
 ; 
EN ; Does not prevent loading of the transport global.
 ; Environment check is done only during the install.
 ;
 N XQA,XQAMSG
 ;
 I '$G(XPDENV) D  Q
 . S XQAMSG="Transport global for patch "_$G(XPDNM,"Unknown patch")_" loaded on "_$$HTE^XLFDT($H)
 . S XQA("G.LMI")=""
 . D SETUP^XQALERT
 . D BMES^XPDUTL($$CJ^XLFSTR("Sending transport global loaded alert to mail group G.LMI",80))
 ;
 S XQAMSG="Installation of patch "_$G(XPDNM,"Unknown patch")_" started on "_$$HTE^XLFDT($H)
 S XQA("G.LMI")=""
 D SETUP^XQALERT
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
EXIT ;
 I $G(XPDQUIT) D BMES^XPDUTL($$CJ^XLFSTR("--- Install Environment Check FAILED ---",80))
 I '$G(XPDQUIT) D BMES^XPDUTL($$CJ^XLFSTR("--- Environment Check is Ok ---",80))
 Q
 ;
 ;
PRE ; KIDS Pre install for LR*5.2*287
 ;
 N DA,DIK,LRACT
 S LRACT=0 ; flag if pre did anything
 ;
 D BMES^XPDUTL($$CJ^XLFSTR("Sending install started alert to mail group G.LMI",80))
 D BMES^XPDUTL($$CJ^XLFSTR("*** Pre install started ***",80))
 ;
 I $$VFIELD^DILFD(68.2,.13) D
 . D BMES^XPDUTL($$CJ^XLFSTR("Deleting field STORE DUPLICATE COMMENTS (#.13) from file LOAD/WORK LIST (#68.2)",80))
 . S LRACT=1,DIK="^DD(68.2,",DA=.13,DA(1)=68.2
 . D ^DIK
 . S DA=0
 . F  S DA=$O(^LRO(68.2,DA)) Q:'DA  S $P(^LRO(68.2,DA,0),"^",14)=""
 I 'LRACT D BMES^XPDUTL($$CJ^XLFSTR("--- No action required---",80))
 D BMES^XPDUTL($$CJ^XLFSTR("*** Pre install completed ***",80))
 ;
 Q
 ;
 ;
POST ; KIDS Post install for LR*5.2*287
 N DA,DIK,XQA,XQAMSG
 ;
 D BMES^XPDUTL($$CJ^XLFSTR("*** Post install started ***",80))
 D BMES^XPDUTL($$CJ^XLFSTR("--- No actions required for post install ---",80))
 D BMES^XPDUTL($$CJ^XLFSTR("*** Post install completed ***",80))
 ;
 D BMES^XPDUTL($$CJ^XLFSTR("Sending install completion alert to mail group G.LMI",80))
 S XQAMSG="Installation of patch "_$G(XPDNM,"Unknown patch")_" completed on "_$$HTE^XLFDT($H)
 S XQA("G.LMI")=""
 D SETUP^XQALERT
 ;
 Q
 
