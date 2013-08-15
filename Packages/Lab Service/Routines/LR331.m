LR331 ;VA/DALOI/JMC - LR*5.2*331 PATCH ENVIRONMENT CHECK ROUTINE ; Feb 25, 2005
 ;;5.2;LAB SERVICE;**1031**;NOV 01, 1997
 ;
 ;;VA LR Patche(s): 331
 ;
EN ; Does not prevent loading of the transport global.
 ; Environment check is done only during the install.
 ;
 N XQA,XQAMSG
 ;
 I '$G(XPDENV) D  Q
 . S XQAMSG="Transport global for patch "_$G(XPDNM,"Unknown patch")_" loaded on "_$$HTE^XLFDT($H)
 . S XQA("G.LMI")=""
 . ; D SETUP^XQALERT                                                                               ; IHS/OIT/MKK
 . ; D BMES^XPDUTL($$CJ^XLFSTR("Sending transport global loaded alert to mail group G.LMI",80))    ; IHS/OIT/MKK
 ;
 D BMES^XPDUTL($$CJ^XLFSTR("--- Installation of patch "_$G(XPDNM,"Unknown patch")_" started on "_$$HTE^XLFDT($H)_" ---",IOM))    ; IHS/OIT/MKK
 ;
 S XQAMSG="Installation of patch "_$G(XPDNM,"Unknown patch")_" started on "_$$HTE^XLFDT($H)
 S XQA("G.LMI")=""
 ; D SETUP^XQALERT                                                                                 ; IHS/OIT/MKK
 ; D BMES^XPDUTL($$CJ^XLFSTR("Sending install started alert to mail group G.LMI",80))              ; IHS/OIT/MKK
 ;
 D CHECK
 D EXIT
 Q
 ;
CHECK ; Perform environment check
 D BMES^XPDUTL($$CJ^XLFSTR("--- Environment Check for "_$G(XPDNM,"Unknown patch")_" ---",80))      ; IHS/OIT/MKK
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
 ; I $G(XPDQUIT) D BMES^XPDUTL($$CJ^XLFSTR("--- Install Environment Check FAILED ---",80))
 ; I '$G(XPDQUIT) D BMES^XPDUTL($$CJ^XLFSTR("--- Environment Check is Ok ---",80))
 ;
 I $G(XPDQUIT) D BMES^XPDUTL($$CJ^XLFSTR("--- Install Environment Check for "_$G(XPDNM,"Unknown patch")_" FAILED ---",80))     ; IHS/OIT/MKK
 I '$G(XPDQUIT) D BMES^XPDUTL($$CJ^XLFSTR("--- Install Environment Check for "_$G(XPDNM,"Unknown patch")_" is Ok ---",80))     ; IHS/OIT/MKK
 ;
 Q
 ;
PRE ; KIDS Pre install
 ;
 N DA,DIK
 ; D BMES^XPDUTL($$CJ^XLFSTR("*** Pre install started ***",80))
 D BMES^XPDUTL($$CJ^XLFSTR("*** Pre install for "_$G(XPDNM,"Unknown patch")_" started ***",80))    ; IHS/OIT/MKK
 ;
 D BMES^XPDUTL($$CJ^XLFSTR("Deleting Field #15 in file #68, ACCESSION",80))
 S DIK="^DD(68.02,",DA=15,DA(1)=68 D ^DIK
 D BMES^XPDUTL($$CJ^XLFSTR("Field will be installed as part of KIDS installation",80))
 ;
 ; D BMES^XPDUTL($$CJ^XLFSTR("*** Pre install completed ***",80))
 D BMES^XPDUTL($$CJ^XLFSTR("*** Pre install for "_$G(XPDNM,"Unknown patch")_" completed ***",80))  ; IHS/OIT/MKK
 Q
 ;
POST ; KIDS Post install
 N XQA,XQAMSG
 ; D BMES^XPDUTL($$CJ^XLFSTR("*** Post install started ***",80))
 D BMES^XPDUTL($$CJ^XLFSTR("*** Post install for "_$G(XPDNM,"Unknown patch")_" started ***",80))   ; IHS/OIT/MKK 
 D BMES^XPDUTL($$CJ^XLFSTR("*** No action required ***",80))
 ; D BMES^XPDUTL($$CJ^XLFSTR("*** Post install completed ***",80))
 D BMES^XPDUTL($$CJ^XLFSTR("*** Post install for "_$G(XPDNM,"Unknown patch")_" completed ***",80)) ; IHS/OIT/MKK
 ; D BMES^XPDUTL($$CJ^XLFSTR("Sending install completion alert to mail group G.LMI",80))           ; IHS/OIT/MKK
 S XQAMSG="Installation of patch "_$G(XPDNM,"Unknown patch")_" completed on "_$$HTE^XLFDT($H)
 S XQA("G.LMI")=""
 ; D SETUP^XQALERT                                                                                 ; IHS/OIT/MKK
 S XQAMSG="LIM: Review description for "_$G(XPDNM,"Unknown patch")_" use KIDS:Utilities:Build File Print"
 S XQA("G.LMI")=""
 ; D SETUP^XQALERT                                                                                 ; IHS/OIT/MKK
 Q
