LR305 ;DALOI/WTY - LR*5.2*305 PATCH ENVIRONMENT CHECK ROUTINE;02/18/2004
 ;;5.2;LR;**305,1022**;September 20, 2007
 ;;
 ; VA PATCH 305 included in IHS LAB PATCH 1022
 ;;
EN ; Does not prevent loading of the transport global.
 ; Environment check is done only during the install.
 ;
 N XQA,XQAMSG,LRAMSG
 ;
 I '$G(XPDENV) D  Q
 . S XQAMSG="Transport global for patch "_$G(XPDNM,"Unknown patch")
 . S XQAMSG=XQAMSG_" loaded on "_$$HTE^XLFDT($H)
 . S XQA("G.LMI")=""
 . D SETUP^XQALERT
 . S LRAMSG="Sending transport global loaded alert to mail group G.LMI"
 . D BMES^XPDUTL($$CJ^XLFSTR(LRAMSG,80))
 ;
 S XQAMSG="Installation of patch "_$G(XPDNM,"Unknown patch")_" started "
 S XQAMSG=XQAMSG_"on "_$$HTE^XLFDT($H)
 S XQA("G.LMI")=""
 D SETUP^XQALERT
 S LRAMSG="Sending install started alert to mail group G.LMI"
 D BMES^XPDUTL($$CJ^XLFSTR(LRAMSG,80))
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
 . S LRAMSG="Please log in to set local DUZ... variables"
 . D BMES^XPDUTL($$CJ^XLFSTR(LRAMSG,80))
 . S XPDQUIT=2
 I $P($$ACTIVE^XUSER(DUZ),"^")'=1 D  Q
 . S LRAMSG="You are not a valid user on this system"
 . D BMES^XPDUTL($$CJ^XLFSTR(LRAMSG,80))
 . S XPDQUIT=2
 S XPDIQ("XPZ1","B")="NO"
 Q
 ;
 ;
EXIT ;
 I $G(XPDQUIT) D
 .D BMES^XPDUTL($$CJ^XLFSTR("--- Install Environment Check FAILED ---",80))
 I '$G(XPDQUIT) D
 .D BMES^XPDUTL($$CJ^XLFSTR("--- Environment Check is OK ---",80))
 Q
 ;
 ;
PRE ; KIDS Pre install
 D BMES^XPDUTL($$CJ^XLFSTR("*** Pre install started ***",80))
 D BMES^XPDUTL($$CJ^XLFSTR("*** No action required ***",80))
 D BMES^XPDUTL($$CJ^XLFSTR("*** Pre install completed ***",80))
 Q
 ;
 ;
POST ; KIDS Post install
 N XQA,XQAMSG,LRNUM,LRFDA,LRERR,LREND
 D BMES^XPDUTL($$CJ^XLFSTR("*** Post install started ***",80))
 S LRAMSG="Set ALLOW LAB TO ADD PATIENTS (#13) field of the"
 D BMES^XPDUTL($$CJ^XLFSTR(LRAMSG,80))
 S LRAMSG="LABORATORY SITE (#69.9) file to 'NO'"
 D MES^XPDUTL($$CJ^XLFSTR(LRAMSG,80))
 ;Set field #13 of file 69.9 to 'No'
 S (LRNUM,LREND)=0
 F  S LRNUM=$O(^LAB(69.9,LRNUM)) Q:'LRNUM  D
 .L +^LAB(69.9,LRNUM,0):5 I '$T D  Q
 ..S LRAMSG="The record is locked by another user.  "
 ..S LRAMSG=LRAMSG_"Record cannot be updated."
 ..D BMES^XPDUTL($$CJ^XLFSTR(LRAMSG,80))
 ..S LRAMSG="Please contact IRM for assistance."
 ..D MES^XPDUTL($$CJ^XLFSTR(LRAMSG,80))
 .K LRFDA,LRERR
 .Q:'$D(^LAB(69.9,LRNUM,0))
 .S LRFDA(69.9,LRNUM_",",13)=0
 .D FILE^DIE("","LRFDA","LRERR")
 .I $D(LRERR) D
 ..S LREND=1
 ..S LRAMSG="An error occurred while attempting to update "
 ..S LRAMSG=LRAMSG_"the file."
 ..D BMES^XPDUTL($$CJ^XLFSTR(LRAMSG,80))
 ..S LRAMSG="Please contact IRM for assistance."
 ..D MES^XPDUTL($$CJ^XLFSTR(LRAMSG,80))
 .I 'LREND D
 ..S LRAMSG="File Update Completed"
 ..D BMES^XPDUTL($$CJ^XLFSTR(LRAMSG,80))
 .L -^LAB(69.9,LRNUM,0)
 D BMES^XPDUTL($$CJ^XLFSTR("*** Post install completed ***",80))
 S LRAMSG="Sending install completion alert to mail group G.LMI"
 D BMES^XPDUTL($$CJ^XLFSTR(LRAMSG,80))
 S XQAMSG="Installation of patch "_$G(XPDNM,"Unknown patch")
 S XQAMSG=XQAMSG_" completed on "_$$HTE^XLFDT($H)
 S XQA("G.LMI")=""
 D SETUP^XQALERT
 Q
