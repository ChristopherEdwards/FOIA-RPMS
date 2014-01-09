LR308 ;VA/DALOI/KLL - LR*5.2*308 PATCH ENVIRONMENT CHECK ROUTINE ;07/30/04
 ;;5.2;LAB SERVICE;**1031**;NOV 01, 1997
 ;
 ;;VA LR Patche(s): 308
 ;
EN ; Does not prevent loading of the transport global.
 ; Environment check is done only during the install.
 ;
 I '$G(XPDENV) D  Q
 .N XQA,XQAMSG
 .S XQAMSG="Transport global for patch "_$G(XPDNM,"Unknown patch")
 .S XQAMSG=XQAMSG_" loaded on "_$$HTE^XLFDT($H)
 .S XQA("G.LMI")=""
 .; D SETUP^XQALERT
 .S MSG="Sending transport global loaded alert to mail group G.LMI"
 .; D BMES^XPDUTL($$CJ^XLFSTR(MSG,80)) K MSG
 ;
 D BMES^XPDUTL($$CJ^XLFSTR("--- Installation of patch "_$G(XPDNM,"Unknown patch")_" started on "_$$HTE^XLFDT($H)_" ---",IOM))    ; IHS/MSC/MKK
 ;
 D CHECK
 D EXIT
 Q
 ;
CHECK ; Perform environment check
 D BMES^XPDUTL($$CJ^XLFSTR("--- Environment Check for "_$G(XPDNM,"Unknown patch")_" ---",80))      ; IHS/MSC/MKK
 ;
 I $S('$G(IOM):1,'$G(IOSL):1,$G(U)'="^":1,1:0) D  Q
 .D BMES^XPDUTL($$CJ^XLFSTR("Terminal Device is not defined",80))
 .S XPDQUIT=2
 ;
 I $S('$G(DUZ):1,$D(DUZ)[0:1,$D(DUZ(0))[0:1,1:0) D  Q
 .S MSG="Please log in to set local DUZ... variables"
 .D BMES^XPDUTL($$CJ^XLFSTR(MSG,80)) K MSG
 .S XPDQUIT=2
 ;
 I '$D(^VA(200,$G(DUZ),0))#2 D  Q
 .S MSG="You are not a valid user on this system"
 .D BMES^XPDUTL($$CJ^XLFSTR(MSG,80)) K MSG
 .S XPDQUIT=2
 ;
 S XPDIQ("XPZ1","B")="NO"
 ;
 Q
 ;
EXIT ;
 I $G(XPDQUIT) D
 .S MSG="--- Install Environment Check FAILED ---"
 .; D BMES^XPDUTL($$CJ^XLFSTR(MSG,80)) K MSG
 I '$G(XPDQUIT) D
 .; D BMES^XPDUTL($$CJ^XLFSTR("--- Environment Check is Ok ---",80))
 ;
 I $G(XPDQUIT) D BMES^XPDUTL($$CJ^XLFSTR("--- Install Environment Check for "_$G(XPDNM,"Unknown patch")_" FAILED ---",80))     ; IHS/MSC/MKK
 I '$G(XPDQUIT) D BMES^XPDUTL($$CJ^XLFSTR("--- Install Environment Check for "_$G(XPDNM,"Unknown patch")_" is Ok ---",80))     ; IHS/MSC/MKK
 Q
 ;
PRE ; KIDS Pre install for LR*5.2*308
 ;
 N XQA,XQAMSG
 S XQAMSG="Installation of patch "_$G(XPDNM,"Unknown patch")
 S XQAMSG=XQAMSG_" started on "_$$HTE^XLFDT($H)
 S XQA("G.LMI")=""
 ; D SETUP^XQALERT
 ;
 S MSG="Sending install started alert to mail group G.LMI"
 ; D BMES^XPDUTL($$CJ^XLFSTR(MSG,80)) K MSG
 ;
 ; D BMES^XPDUTL($$CJ^XLFSTR("*** Pre install started ***",80))
 ;
 D BMES^XPDUTL($$CJ^XLFSTR("*** Pre install for "_$G(XPDNM,"Unknown patch")_" started ***",80))    ; IHS/MSC/MKK
 ;
 S Y=$$OPTDE^XPDUTL("LRAP",2)
 S MSG="Disabling Anatomic Pathology [LRAP] option"
 D BMES^XPDUTL($$CJ^XLFSTR(MSG,80)) K MSG
 ;
 ; D BMES^XPDUTL($$CJ^XLFSTR("*** Pre install completed ***",80))
 ;
 D BMES^XPDUTL($$CJ^XLFSTR("*** Pre install for "_$G(XPDNM,"Unknown patch")_" completed ***",80))  ; IHS/MSC/MKK
 Q
 ;
POST ; KIDS Post install for LR*5.2*308
 ;
 N XQA,XQAMSG
 ; D BMES^XPDUTL($$CJ^XLFSTR("*** Post install started ***",80))
 ;
 D BMES^XPDUTL($$CJ^XLFSTR("*** Post install for "_$G(XPDNM,"Unknown patch")_" started ***",80))   ; IHS/MSC/MKK 
 ;
 S Y=$$OPTDE^XPDUTL("LRAP",1)
 S MSG="Enabling Anatomic Pathology [LRAP] option"
 D BMES^XPDUTL($$CJ^XLFSTR(MSG,80)) K MSG
 ;
 ; D BMES^XPDUTL($$CJ^XLFSTR("*** Post install completed ***",80))
 ; 
 D BMES^XPDUTL($$CJ^XLFSTR("*** Post install for "_$G(XPDNM,"Unknown patch")_" completed ***",80))   ; IHS/MSC/MKK 
 ;
 S XQAMSG="Installation of patch "_$G(XPDNM,"Unknown patch")
 S XQAMSG=XQAMSG_" completed on "_$$HTE^XLFDT($H)
 S XQA("G.LMI")=""
 ; D SETUP^XQALERT
 ;
 D BMES^XPDUTL($$CJ^XLFSTR("--- "_XQAMSG_" ---",80))    ; IHS/MSC/MKK
 ;
 S MSG="Sending install completion alert to mail group G.LMI"
 ; D BMES^XPDUTL($$CJ^XLFSTR(MSG,80)) K MSG
 ;
 Q
