LA64 ;VA/DALOI/JMC - LA*5.2*64 PATCH ENVIRONMENT CHECK ROUTINE ;JUL 06, 2010 3:14 PM
 ;;5.2;AUTOMATED LAB INSTRUMENTS;**64,1027**;NOV 01, 1997
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
 ; S XQA("G.LMI")=""
 ; D SETUP^XQALERT
 ;
 D CHECK
 D EXIT
 Q
 ;
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
PRE ; KIDS Pre install for LA*5.2*64
 ;
 N DA,DIK
 ;
 ; D BMES^XPDUTL($$CJ^XLFSTR("Sending install started alert to mail group G.LMI",80))
 D BMES^XPDUTL($$CJ^XLFSTR("*** Pre install started ***",80))
 D BMES^XPDUTL($$CJ^XLFSTR("--- No actions required for pre install ---",80))
 D BMES^XPDUTL($$CJ^XLFSTR("*** Pre install completed ***",80))
 ;
 Q
 ;
POST ; KIDS Post install for LA*5.2*64
 N DA,DIK,FDA,LA7X,LA7ERR,XQA,XQAMSG
 ;
 D BMES^XPDUTL($$CJ^XLFSTR("*** Post install started ***",80))
 ;
 ; Set new "C" x-ref on .01 field of file #62.8
 D BMES^XPDUTL($$CJ^XLFSTR("*** Starting reindexing of field #.01 of LAB SHIPPING MANIFEST file ***",80))
 S DIK="^LAHM(62.8,",DIK(1)=".01^C"
 D ENALL^DIK
 D BMES^XPDUTL($$CJ^XLFSTR("*** Completed reindexing of field #.01 of LAB SHIPPING MANIFEST file ***",80))
 ;
 ; Update existing LA7V* file 62.48 entries with INTERFACE TYPE.
 S LA7X=0
 F  S LA7X=$O(^LAHM(62.48,LA7X)) Q:'LA7X  D
 . I $E(^LAHM(62.48,LA7X,0),1,4)'="LA7V" Q
 . S FDA(1,62.48,LA7X_",",11)=10
 . D FILE^DIE("E","FDA(1)","LA7ERR(1)")
 D BMES^XPDUTL($$CJ^XLFSTR("*** Set INTERFACE TYPE for LA7V* entries in LA7 MESSAGE PARAMETER file ***",80))
 ;
 D BMES^XPDUTL($$CJ^XLFSTR("*** Post install completed ***",80))
 ; D BMES^XPDUTL($$CJ^XLFSTR("Sending install completion alert to mail group G.LMI",80))
 ;
 S XQAMSG="Installation of patch "_$G(XPDNM,"Unknown patch")_" completed on "_$$HTE^XLFDT($H)
 D BMES^XPDUTL(XQAMSG)
 S XQA("G.LMI")=""
 ; D SETUP^XQALERT
 ;
 S XQAMSG="LIM: Review LEDI Install Guide and User Manual"
 D BMES^XPDUTL(XQAMSG)
 S XQA("G.LMI")=""
 ; D SETUP^XQALERT
 ;
 Q
