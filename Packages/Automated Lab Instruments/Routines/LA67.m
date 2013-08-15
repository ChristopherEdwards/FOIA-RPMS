LA67 ;VA/DALOI/JMC - LA*5.2*67 PATCH ENVIRONMENT CHECK ROUTINE ;5/13/2002
 ;;5.2;AUTOMATED LAB INSTRUMENTS;**1031**;NOV 01, 1997
 ;
 ;;VA LA Patche(s): 67
 ;
EN ; Does not prevent loading of the transport global.
 ; Environment check is done only during the install.
 ;
 N XQA,XQAMSG
 ;
 I '$G(XPDENV) D  Q
 . S XQAMSG="Transport global for patch "_$G(XPDNM,"Unknown patch")_" loaded on "_$$HTE^XLFDT($H),XQA("G.LMI")=""
 . ; D SETUP^XQALERT
 . ; D BMES^XPDUTL($$CJ^XLFSTR("Sending transport global loaded alert to mail group G.LMI",80))
 ;
 S XQAMSG="Installation of patch "_$G(XPDNM,"Unknown patch")_" started on "_$$HTE^XLFDT($H)
 S XQA("G.LMI")=""
 ; D SETUP^XQALERT
 ;
 D BMES^XPDUTL($$CJ^XLFSTR("--- "_XQAMSG_" ---",80))    ; IHS/MSC/MKK - LR*5.2*1031
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
 ; I $G(XPDQUIT) D BMES^XPDUTL($$CJ^XLFSTR("--- Install Environment Check FAILED ---",80))
 ; I '$G(XPDQUIT) D BMES^XPDUTL($$CJ^XLFSTR("--- Environment Check is Ok ---",80))
 ;
 I $G(XPDQUIT) D BMES^XPDUTL($$CJ^XLFSTR("--- Install Environment Check for "_$G(XPDNM,"Unknown patch")_" FAILED ---",80))     ; IHS/MSC/MKK - LR*5.2*1031
 I '$G(XPDQUIT) D BMES^XPDUTL($$CJ^XLFSTR("--- Install Environment Check for "_$G(XPDNM,"Unknown patch")_" is Ok ---",80))     ; IHS/MSC/MKK - LR*5.2*1031
 ;
 Q
 ;
 ;
PRE ; KIDS Pre install for LA*5.2*67
 ;
 N DA,DIK,FDA,LA7ERR,LAI
 ;
 ; D BMES^XPDUTL($$CJ^XLFSTR("Sending install started alert to mail group G.LMI",80))
 D BMES^XPDUTL($$CJ^XLFSTR("*** Pre install started ***",80))
 D BMES^XPDUTL($$CJ^XLFSTR("--- Creating stub entries to file #62.4 and #62.48 ---",80))
 ;
 F LAI=1:1:5 D
 . S FDA(1,62.4,"?+1,",.01)="LA7POC"_LAI
 . D UPDATE^DIE("","FDA(1)","","LA7ERR(1)")
 . S FDA(2,62.48,"?+1,",.01)="LA7POC"_LAI
 . D UPDATE^DIE("","FDA(2)","","LA7ERR(2)")
 ;
 S LAI=$$FIND1^DIC(62.48,"","OX","LA7POC99","B","")
 I LAI S DIK="^LAHM(62.48,",DA=LAI D ^DIK
 ;
 D BMES^XPDUTL($$CJ^XLFSTR("*** Pre install completed ***",80))
 ;
 Q
 ;
 ;
POST ; KIDS Post install for LA*5.2*67
 N DA,DIK,DLAYGO,FDA,IEN,LA7200,LA7FAC,LA7X,LA7Y,LA7I,XQA,XQAMSG
 ;
 D BMES^XPDUTL($$CJ^XLFSTR("*** Post install started ***",80))
 D BMES^XPDUTL($$CJ^XLFSTR("--- Completing LA7POC* entries in file #62.4 ---",80))
 ;
 F LA7I=1:1:5 D
 . S IEN=$$FIND1^DIC(62.4,"","X","LA7POC"_LA7I,"B","","LA7ERRF")
 . S FDA(1,62.4,IEN_",",5)="Accession cross-reference"
 . S FDA(1,62.4,IEN_",",6)="IDE"
 . S FDA(1,62.4,IEN_",",8)="LA7POC"_LA7I
 . D FILE^DIE("E","FDA(1)","LA7ERR(1)")
 D BMES^XPDUTL($$CJ^XLFSTR("*** Updating file #62.4 completed ***",80))
 ;
 ; Set facility station number into FACILITY NAME field in file #771.
 S LA7FAC=$P($$SITE^VASITE(DT),"^",3)
 I LA7FAC'="" D
 . D BMES^XPDUTL($$CJ^XLFSTR("*** Updating facility name for LA7POC* entries in file #771 ***",80))
 . F LA7I=1:1:5,"LA7LAB" D
 . . I LA7I S LA7X="LA7POC"_LA7I
 . . E  S LA7X=LA7I
 . . S LA7Y=$$FIND1^DIC(771,"","",LA7X,"B")
 . . I LA7Y<1 Q
 . . S FDA(1,771,LA7Y_",",3)=LA7FAC
 . . D FILE^DIE("","FDA(1)","LA7DIE(1)")
 . D BMES^XPDUTL($$CJ^XLFSTR("*** Updating facility name completed ***",80))
 ;
 ; Add POC user to file #200 if not entered
 S LA7200=$$FIND1^DIC(200,"","OX","LRLAB,POC","B","")
 I LA7200<1 D
 . D BMES^XPDUTL($$CJ^XLFSTR("*** Adding non-human user 'LRLAB,POC' to NEW PERSON file ***",80))
 . S DIC=200,DIC("DR")="",DIC(0)="L",DLAYGO=200,X="LRLAB,POC"
 . D ^DIC
 . D BMES^XPDUTL($$CJ^XLFSTR("*** Adding 'LRLAB,POC' "_$S(Y<1:"Failed",1:"Successful")_" ***",80))
 ; 
 ;
 ; Add LRLAB,HL user to file #200 if not entered
 S LA7200=$$FIND1^DIC(200,"","OX","LRLAB,HL","B","")
 I LA7200<1 D
 . D BMES^XPDUTL($$CJ^XLFSTR("*** Adding non-human user 'LRLAB,HL' to NEW PERSON file ***",80))
 . S DIC=200,DIC("DR")="",DIC(0)="L",DLAYGO=200,X="LRLAB,HL"
 . D ^DIC
 . D BMES^XPDUTL($$CJ^XLFSTR("*** Adding 'LRLAB,HL' "_$S(Y<1:"Failed",1:"Successful")_" ***",80))
 Q
 ;
 ;
 D BMES^XPDUTL($$CJ^XLFSTR("*** Post install completed ***",80))
 ;
 D BMES^XPDUTL($$CJ^XLFSTR("Sending install completion alert to mail group G.LMI",80))
 S XQAMSG="Installation of patch "_$G(XPDNM,"Unknown patch")_" completed on "_$$HTE^XLFDT($H)
 S XQA("G.LMI")=""
 ; D SETUP^XQALERT
 ;
 D BMES^XPDUTL($$CJ^XLFSTR("--- "_XQAMSG_" ---",80))    ; IHS/MSC/MKK - LR*5.2*1031
 ;
 Q
