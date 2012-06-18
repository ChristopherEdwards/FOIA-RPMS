BLRMERGI ;IHS/ISD/EDE - LR*5.2*1005` PATCH ENVIRONMENT CHECK/POST INIT ROUTINE  [ 01/25/1999  10:30 AM ]
 ;;5.2;BLR;**1005**;DEC 14, 1998
 ;
START ; Does not prevent loading of the transport global.
 ; Environment check is done only during the install.
 Q:'$G(XPDENV)
 D CHECK
 D EXIT
 Q
 ;
CHECK ; Perform environment check
 N BLRVER
 I $S('$G(IOM):1,'$G(IOSL):1,$G(U)'="^":1,1:0) D  Q
 . D BMES^XPDUTL($$CJ^XLFSTR("Terminal Device is not defined",80))
 . S XPDQUIT=2
 . Q
 I $S('$G(DUZ):1,$D(DUZ)[0:1,$D(DUZ(0))[0:1,1:0) D  Q
 . D BMES^XPDUTL($$CJ^XLFSTR("Please log in to set local DUZ... variables",80))
 . S XPDQUIT=2
 . Q
 I '$D(^VA(200,$G(DUZ),0))#2 D  Q
 . D BMES^XPDUTL($$CJ^XLFSTR("You are not a valid user on this system",80))
 . S XPDQUIT=2
 . Q
 S BLRVER=$$VERSION^XPDUTL("LR")
 I BLRVER'[5.2 D  Q
 . D BMES^XPDUTL($$CJ^XLFSTR("You must have LAB MESSAGING V5.2 Installed",80))
 . S XPDQUIT=2
 . Q
 S XPDIQ("XPZ1","B")="NO"
 Q
 ;
EXIT ;
 I $G(XPDQUIT) D BMES^XPDUTL($$CJ^XLFSTR("--- Install Environment Check FAILED ---",80))
 I '$G(XPDQUIT) D BMES^XPDUTL($$CJ^XLFSTR("--- Environment Check is Ok ---",80))
 Q
 ;
POST ; PEP - ENTRY POINT FOR POST INITITALIZATION
 N BLRPKIEN
 S BLRPKIEN=$O(^DIC(9.4,"C","LR",0))
 Q:'BLRPKIEN
 ; if AFFECTS RECORD MERGE for file 2 already in Package entry
 ;   edit data, else add subfile entry.
 D:'$D(^DIC(9.4,BLRPKIEN,20,2,0)) ADD ;  add subfile entry if not there
 D EDIT
 Q
 ;
ADD ; ADD AFFECTS RECORD MERGE ENTRY     
 S DIC="^DIC(9.4,26,20," ;                global root of subfile
 S DIC(0)="L" ;                           allow laygo
 S DIC("P")=$P(^DD(9.4,20,0),"^",2) ;     subfile bookeeper node
 S DA(1)=26 ;                             entry # subfile
 S DINUM=2 ;                              force entry in subfile
 S X=2 ;                                  entry # of file affected
 D FILE^DICN
 Q
 ;
EDIT ; EDIT EXISTING AFFECTS RECORD MERGE ENTRY
 S DIE="^DIC(9.4,"_BLRPKIEN_",20," ;      global root of subfile
 S DA(1)=BLRPKIEN ;                       entry # in file
 S DA=2 ;                                 entry # in subfile
 S DR="3////BLRMERG;4////I $D(^DPT(XDRMRG(""FR""),""LR"")) S XDRZ=1"
 D ^DIE
 Q
