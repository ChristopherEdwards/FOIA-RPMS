LR326 ;VA/DALOI/FHS - LR*5.2*326 PATCH ENVIRONMENT CHECK ROUTINE;31 -AUG-2001
 ;;5.2;LAB SERVICE;**1030**;NOV 01, 1997
 ;;5.2;LAB SERVICE;**326**;Sep 27,1994
 Q
ENV ; Does not prevent loading of the transport global.
 ; Environment check is done only during the install.
 ;
 N XQA,XQAMSG
 ;
CHKNM ; Make sure the patch name exist
 I '$D(XPDNM) D  G EXIT
 . D BMES("No valid patch name exist")
 . S XPDQUIT=2
 ;
 D CHECK
 D EXIT
 Q
 ;
CHECK ; Perform environment check
 I $S('$G(IOM):1,'$G(IOSL):1,$G(U)'="^":1,1:0) D
 . D BMES("Terminal Device is not defined")
 . S XPDQUIT=2
 I $S('$G(DUZ):1,$D(DUZ)[0:1,$D(DUZ(0))[0:1,1:0) D
 . D BMES("Please log in to set local DUZ... variables")
 . S XPDQUIT=2
 I $P($$ACTIVE^XUSER(DUZ),"^")'=1 D
 . D BMES("You are not a valid user on this system")
 . S XPDQUIT=2
 S XPDIQ("XPZ1","B")="NO"
 Q
 ;
EXIT ;
 N XQA
 I $G(XPDQUIT) D BMES("--- Install Environment Check FAILED ---") Q
 D BMES("--- Environment Check is Ok ---")
 S XQAMSG="Loading of patch "_$G(XPDNM,"Unknown patch")_" completed on "_$$HTE^XLFDT($H)
 ; D BMES("Sending install loaded alert to mail group G.LMI")
 ; S XQA("G.LMI")=""
 ; D SETUP^XQALERT
 Q
POST ;Post Install
 N XQA
 I $G(XPDQUIT) D BMES("--- Install FAILED ---") Q
 D BMES("--- Install completed ---")
 S XQAMSG="Install of patch "_$G(XPDNM,"Unknown patch")_" completed on "_$$HTE^XLFDT($H)
 ; D BMES("Sending install complete alert to mail group G.LMI")
 ; S XQA("G.LMI")=""
 ; D SETUP^XQALERT
 Q
BMES(STR) ;Write BMES^XPDUTL statements
 D BMES^XPDUTL($$CJ^XLFSTR(STR,IOM))
 Q
