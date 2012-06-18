LR281 ;VA/DALOI/CKA - LR*5.2*281 PATCH ENVIRONMENT CHECK ROUTINE ;4/22/2003
 ;;5.2;LAB SERVICE;**1030**;NOV 01, 1997
 ;;5.2;LAB SERVICE;**281**;Sep 27, 1994
 ; Reference to ^ORD(101 supported by IA #872
EN ; Does not prevent loading of the transport global.
 ; Environment check is done only during the install.
 ;
 N XQA,XQAMSG
 ;
 I '$G(XPDENV) D  Q
 . S XQAMSG="Transport global for patch "_$G(XPDNM,"Unknown patch")_" loaded on "_$$HTE^XLFDT($H)
 . S XQA("G.LMI")=""
 . ; D SETUP^XQALERT
 . ; D BMES^XPDUTL($$CJ^XLFSTR("Sending transport global loaded alert to mail group G.LMI",80))
 ;
 S XQAMSG="Installation of patch "_$G(XPDNM,"Unknown patch")_" started on "_$$HTE^XLFDT($H)
 S XQA("G.LMI")=""
 ; D SETUP^XQALERT
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
 Q
 ;
EXIT ;
 I $G(XPDQUIT) D BMES^XPDUTL($$CJ^XLFSTR("--- Install Environment Check FAILED ---",80))
 I '$G(XPDQUIT) D BMES^XPDUTL($$CJ^XLFSTR("--- Environment Check is Ok ---",80))
 I '$G(XPDQUIT) D
 .S XQAMSG="Installation of patch "_$G(XPDNM,"Unknown patch")_" completed on "_$$HTE^XLFDT($H)
 .S XQA("G.LMI")=""
 .; D SETUP^XQALERT
 .D BMES^XPDUTL($$CJ^XLFSTR("Installation of patch "_$G(XPDNM,"Unknown patch")_" completed on "_$$HTE^XLFDT($H),80))
 Q
 ;
 ;
PRE ; KIDS Pre install for LR*5.2*281
 ;Pre-install entry point
 ;Delete NCH entries
 Q:'($O(^LAB(69.5,"B","NCH CHOLESTEROL",0)))
 Q:'($O(^LAB(69.5,"B","NCH PAP SMEAR",0)))
 D BMES^XPDUTL($$CJ^XLFSTR("Deleting NCH entries from LAB/SEARCH EXTRACT file (#69.5)",80))
 S LRNUM(1)=$O(^LAB(69.5,"B","NCH CHOLESTEROL",0))
 S LRNUM(2)=$O(^LAB(69.5,"B","NCH PAP SMEAR",0))
 S DIK="^LAB(69.5," F LRNUM=1:1:2 S DA=LRNUM(LRNUM) D ^DIK
 K DIK,DA,LRNUM
 D BMES^XPDUTL($$CJ^XLFSTR("*** Preinstall completed ***",80))
 Q
 ;
 ;
POST ; KIDS Post install for LR*5.2*281
 ; Set Lag Days =15 for all pathogens
 S LRNUM=0
 F  S LRNUM=$O(^LAB(69.5,LRNUM)) Q:LRNUM'>0  S $P(^LAB(69.5,LRNUM,0),U,3)=15
 ;
 ; Set Previous Cycle field for TB=1
 Q:'$D(^LAB(69.5,5,0))
 Q:$P(^LAB(69.5,5,0),U)'="TUBERCULOSIS"
 S $P(^LAB(69.5,5,0),U,13)=1
 ;Make sure the protocol is correct
 S LREPI=0,LRNUM=0,LREPI=$O(^ORD(101,"B","LREPI",LREPI))
 F  S LRNUM=$O(^LAB(69.5,LRNUM)) Q:LRNUM=""  S $P(^LAB(69.5,LRNUM,0),U,7)=LREPI
 ;delete the NCH protocol from 69.4-all but LREPI deleted
 S LRNUM=0
 F  S LRNUM=$O(^LAB(69.4,LRNUM)) Q:LRNUM=""  I LREPI'=LRNUM D
 .S DIK="^LAB(69.4,",DA=LRNUM
 .D ^DIK
 .K DIK,DA
 K LREPI,LRNUM
 Q
