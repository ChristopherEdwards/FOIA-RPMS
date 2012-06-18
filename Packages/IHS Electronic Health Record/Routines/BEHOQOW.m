BEHOQOW ;MSC/IND/PLS - Quick Order Wizard Support ;20-Jun-2007 10:36;DKM
 ;;1.1;BEH COMPONENTS;**039001**;Mar 20, 2007
 ;=================================================================
 ; Return List of Display Groups
 ; Input: GRPTYP - 0 = common, 1=user
 ;        GRPUSR - if GRPTYP=1, use this user to retrieve groups
DISGRP(DATA,GRPTYP,GRPUSR) ;EP
 N IEN,NODE,CNT,NAME
 S GRPTYP=$G(GRPTYP,0)  ; default to all users
 S DATA=$$TMPGBL^CIAVMRPC()
 Q:GRPTYP&'$G(GRPUSR)   ; if type is of user, must have a user
 S CNT=0
 S IEN=0 F  S IEN=$O(^ORD(100.98,IEN)) Q:'IEN  D
 .S NODE=^ORD(100.98,IEN,0)
 .;Q:'$P(^ORD(100.98,IEN,0),U,4)  ; Must have a default dialog
 .Q:'$$VALIDGP(IEN)
 .S CNT=CNT+1,@DATA@(CNT)=IEN_U_$P(NODE,U)_U_$P(NODE,U,2)_U_$S(GRPTYP=1:+$$CNTFUSR(IEN,GRPUSR),1:+$$CNTGRP(IEN))
 Q
 ; Return true if group should be included in the list of groups
VALIDGP(IEN) ;
 N FLG
 S FLG=''$P(^ORD(100.98,IEN,0),U,4)
 I 'FLG D
 .S FLG=$$CHKGPH(IEN)
 Q FLG
 ; Return true if group has a hierarchical link to a default dialog
CHKGPH(IEN) ;
 N FLG,LP
 S LP=0,FLG=0
 F  S LP=$O(^ORD(100.98,"AD",IEN,LP)) Q:'LP!FLG  D
 .S FLG=$$VALIDGP(LP)
 Q FLG
 ; Return Main Display Group
DEFDISGP(DATA,GRP) ;EP
 S DATA=+$P($G(^ORD(100.98,GRP,0)),U,4)
 S DATA=$S('DATA:+$O(^ORD(100.98,"AD",GRP,0)),1:GRP)
 Q:$Q DATA
 ;I 'DATA S DATA=+$O(^ORD(100.98,"AD",GRP,0))
 ;E  S DATA=GRP
 Q
 ; Return list of Quick Orders from Order Dialog File
 ; Input:  GRP - Display Group IEN (default=all groups)
 ;         USR - IEN of User (default=all users)
QOITEMS(DATA,GRP,USR) ;EP
 N IEN,NODE,CNT,NAM,QOV,LP
 S GRP=$G(GRP,0)
 S USR=$G(USR,0)
 S DATA=$$TMPGBL^CIAVMRPC()
 S CNT=0
 I 'USR D
 .S NAM="" F  S NAM=$O(^ORD(101.41,"C",NAM)) Q:NAM=""  D
 ..S IEN=0 F  S IEN=$O(^ORD(101.41,"C",NAM,IEN)) Q:'IEN  D
 ...S NODE=^ORD(101.41,IEN,0)
 ...Q:$P(NODE,U,4)'="Q"
 ...I GRP,$P(NODE,U,5)'=GRP Q
 ...;S CNT=CNT+1,@DATA@(CNT)=IEN_U_NAM_U_$P(NODE,U,5)_U_$P(NODE,U,1)
 ...S CNT=CNT+1,@DATA@(CNT)=IEN_U_$P(NODE,U,1)_U_$P(NODE,U,5)_U_NAM
 E  D
 .S QOV=+$P($$GETQOV(GRP,USR),U,2)
 .I QOV D
 ..S LP=0 F  S LP=$O(^ORD(101.44,+QOV,10,LP)) Q:'LP  S IEN=+^(LP,0) D
 ...S NODE=$G(^ORD(101.41,IEN,0))
 ...Q:$P(NODE,U,4)'="Q"
 ...S CNT=CNT+1,@DATA@(CNT)=IEN_U_$P(NODE,U)_U_$P(NODE,U,5)_U_$P(^ORD(101.44,+QOV,10,LP,0),U,2)  ;$P(NODE,U,2)
 Q
 ; Return value of field for given quick order
 ; Input: IEN - IEN to File 101.41
 ;        FLD - Field Number (defaults to .01)
 ;        FLG - 0=actual (default), 1=Uppercase
QOFVAL(DATA,IEN,FLD,FLG) ;EP
 S FLD=$G(FLD,.01)
 S FLG=$G(FLG,0)
 S DATA=$$GET1^DIQ(101.41,IEN,FLD)
 S:FLG DATA=$$UP^XLFSTR(DATA)
 Q
 ; Count quick orders for a given display group
 ; Input: GRP - Display Group IEN
CNTGRP(GRP) ;
 N CNT,IEN
 S CNT=0
 S IEN=0 F  S IEN=$O(^ORD(101.41,IEN)) Q:'IEN  D
 .Q:$P($G(^ORD(101.41,IEN,0)),U,4)'="Q"
 .Q:$P($G(^ORD(101.41,IEN,0)),U,5)'=GRP
 .S CNT=CNT+1
 Q CNT
 ; Returns Quick Order View information for given Display Group and User.
 ; Input:  DGIEN - Display Group IEN
 ;        GRPUSR - User IEN
 ; Output: Count of Order Dialogs^IEN to Quick Order View for user
CNTFUSR(DGIEN,GRPUSR) ;
 N QOV,VAL
 S VAL="0^0"
 S QOV=$$GETQOV(DGIEN,GRPUSR)
 Q +$$QVCNT(+$P(QOV,U,2))_U_+$P(QOV,U,2)
 ; Returns Item Count for given Quick Order View
QVCNT(QOV) ;
 N LP,CNT
 S:'QOV QOV=$O(^ORD(101.44,"B",QOV,0))
 Q:'QOV 0
 S (CNT,LP)=0 F  S LP=$O(^ORD(101.44,QOV,10,LP)) Q:'LP  D
 .S:$D(^ORD(101.41,+^ORD(101.44,QOV,10,LP,0),0)) CNT=CNT+1
 Q CNT
 ; Return Quick Order View entry for given user
 ; Input: DGIEN - IEN to Display Group (File 100.98)
 ;        USR - IEN to File 200
 ; Output: QOV Name^QOV IEN
GETQOV(DGIEN,USR) ;
 N QOV
 S QOV=$$GET^XPAR("USR.`"_USR,"ORWDQ QUICK VIEW",DGIEN,"I")
 S:$L(QOV) QOV=QOV_U_+$O(^ORD(101.44,"B",QOV,0))
 Q QOV
 ; Return Disabled Status of Order Dialog
 ; Input: BEHOQO - IEN to Order Dialog File (101.41)
GETDISAB(DATA,BEHOQO) ;EP
 S DATA=$L($$GET1^DIQ(101.41,BEHOQO,3))>0
 Q
 ; Set Disabled Message for given Order Dialog
 ; Input: BEHOQO - IEN to Order Dialog File (101.41)
 ;           MSG - Message set (Text will disable; '@' will clear);
SETDISAB(DATA,BEHOQO,MSG) ;EP
 N FDA,F,IENS,ERR
 S F=101.41
 S FDA(F,BEHOQO_",",3)=MSG
 D UPDATE^DIE("","FDA","IENS","ERR")
 S DATA(1)=$S($G(ERR):"Unable to perform action.",1:"")
 Q
 ; Return Delete Status of Order Dialog
 ; Input: BEHOQO - IEN to Order Dialog File (101.41)
 ;           USR - IEN to File 200 - If >0, always return ability to delete.
CANDEL(DATA,BEHOQO,USR) ;EP
 S DATA=0
 S:USR DATA=1
 S:'DATA DATA='($D(^ORD(101.41,"AD",BEHOQO))!($$INUSE^ORCMEDT5(BEHOQO))!($E($$GET1^DIQ(101.41,BEHOQO,.01),1,6)="ORWDQ "))
 Q:$Q DATA
 Q
 ; Delete given Order Dialog
 ; Input: BEHOQO - IEN to Order Dialog File (101.41)
 ;           USR - File 200 IEN. If >0 indicates operation is to be done on
 ;                 user quick view list vs Order Dialog File.
 ;                 (Default = 0)
 ;          DGRP - Display Group
 ;           DNM - Display Name
DELETEQO(DATA,BEHOQO,USR,DGRP,DNM) ;EP
 N DA,DIK
 S USR=$G(USR,0)
 I USR D
 .S DATA=$$DUSRQVI(BEHOQO,USR,DGRP,DNM)
 E  D
 .S DA=BEHOQO,DIK="^ORD(101.41," D ^DIK
 .S DATA='$D(^ORD(101.41,DA,0))
 Q
 ; Delete Order Quick View entry for given user, order dialog and display group.
 ; Input: QOIEN - IEN to File 101.41
 ;          USR - IEN to File 200
 ;         DGRP - IEN to File 100.98
DUSRQVI(QOIEN,USR,DGRP,DNM) ;
 N DFLG,SNM,QVNM,QVIEN,DA,DIK,ROOT
 S DFLG=0
 Q:'QOIEN!'USR!'DGRP!'$L(DNM) DFLG
 S SNM=$$GET1^DIQ(100.98,DGRP,3)
 S QVIEN=$$FIND1^DIC(101.44,"","X","ORWDQ USR"_USR_" "_SNM)
 Q:'QVIEN DFLG
 S DA(1)=QVIEN
 S ROOT="^ORD(101.44,"_DA(1)_",10)"
 S DIK=$P(ROOT,")")_",",DA=0
 F  S DA=$O(@ROOT@(DA)) Q:'DA!DFLG  D
 .I $P(@ROOT@(DA,0),U,1,2)=(QOIEN_U_DNM) D
 ..D ^DIK
 ..S DFLG=1
 Q DFLG
 ; Return Window Form ID for given Display Group default dialog
GRPDEFWD(DATA,GRP) ;EP
 S DATA=+$$GET1^DIQ(101.41,$$DEFDLG^ORWDXQ(GRP),55,"I")
 Q:$Q DATA
 Q
 ; Return properties of given quick order
 ; Input: CIAQO - IEN to Order Dialog File (101.41)
PROPERTY(DATA,CIAQO) ;EP
 N ORDIALOG,F
 S DATA=$$TMPGBL^CIAVMRPC()
 I '$G(CIAQO,0) D  Q
 .S @DATA@(1)="Quick Order entry not available."
 D GETQDLG^ORCD(CIAQO)
 D CAPTURE^CIAUHFS("D DISPLAY^ORCDLG",DATA,50)
 S F=101.41
 S @DATA@(1.01)="Number: "_CIAQO
 S @DATA@(1.1)="Name: "_$$GET1^DIQ(F,CIAQO,.01)
 S @DATA@(1.11)="Display Text: "_$$GET1^DIQ(F,CIAQO,2)
 S @DATA@(1.12)="Disable: "_$$GET1^DIQ(F,CIAQO,3)
 S @DATA@(1.13)="Type: "_$$UP^XLFSTR($$GET1^DIQ(F,CIAQO,4))
 S @DATA@(1.14)="Display Group: "_$$GET1^DIQ(F,CIAQO,5)
 S @DATA@(1.15)="Signature Required: "_$$GET1^DIQ(F,CIAQO,6)
 S @DATA@(1.16)="Package: "_$$GET1^DIQ(F,CIAQO,7)
 S @DATA@(1.17)="Verify Order: "_$$GET1^DIQ(F,CIAQO,8)
 S @DATA@(1.18)="Ask For Another Order: "_$$GET1^DIQ(F,CIAQO,9)
 S @DATA@(1.19)="Auto-Accept Quick Order: "_$$GET1^DIQ(F,CIAQO,58)
 S @DATA@(1.2)=""
 S @DATA@(1.3)="Order Dialog Responses:"
 S @DATA@(1.4)=""
 Q
 ; Save Order Dialog
 ; Input:
 ;       IEN - IEN to 101.41 or 0 for new dialog
 ;       TYP - Common QO (0) or User QO (1) (Default: 0)
 ;        NM - Order Dialog Name
 ;       DNM - Display Text
 ;      DGRP - Display Group
 ;      EACT - Entry Action
 ;       VER - Verify Order
 ;       RSP - Dialog Responses
SAVEDLG(DATA,IEN,TYP,NM,DNM,DGRP,EACT,VER,RSP) ;EP
 S DATA=0,RSP=$$DEFDLG^ORWDXQ(DGRP) Q:'RSP
 S TYP=$G(TYP,0)
 D GETDLG1^ORCD(RSP)
 N FDA,FDAIEN,DIERR,ORDG,ORQDLG,NODE
 S:IEN FDAIEN(1)=IEN
 S NODE=$S(IEN:IEN,1:"+1")_","
 S FDA(101.41,NODE,.01)=NM
 S FDA(101.41,NODE,2)=DNM
 S FDA(101.41,NODE,4)="Q"
 S FDA(101.41,NODE,5)=DGRP
 S FDA(101.41,NODE,8)=VER
 S FDA(101.41,NODE,30)=EACT
 I IEN D
 .D FILE^DIE("","FDA","DIERR")
 E  D
 .D UPDATE^DIE("","FDA","FDAIEN","DIERR")
 S DATA=+$G(FDAIEN(1))
 I '$D(DIERR) D
 .S ORQDLG=FDAIEN(1)
 .D SAVE^ORCMEDT1
 Q
 ; Update Quick Order Responses
 ; Always returns 0
UPDRSP(DATA,IEN,DGRP,ORDIALOG) ;EP
 N ORQDLG
 S DATA=0,ORDIALOG=$$DEFDLG^ORWDXQ(DGRP) Q:'ORDIALOG
 D GETDLG1^ORCD(ORDIALOG)
 S ORQDLG=IEN
 D SAVE^ORCMEDT1
 Q
 ;
 ;Return Package IEN for given Display Group
GETPKG(DATA,DISGRP) ;EP
 N DEFGRP,DLG,PKG
 S DLG=$$DEFDLG^ORWDXQ(DISGRP)
 S DATA=$$GET1^DIQ(101.41,DLG,7,"I")
 ;S DEFGRP=$$DEFDISGP(DISGRP)
 ;S DLG=
 ;S DATA=PKG
 Q:$Q DATA
 Q
 ; Move Reponses to Cloned Entry
 ; Input: FIEN - IEN in 101.41 of entry to clone
 ;        TIEN - IEN in 101.41 of new entry
CLONE(DATA,FIEN,TIEN) ;EP
 S DATA=0
 Q:'FIEN!('TIEN)
 Q:'$D(^ORD(101.41,FIEN))!('$D(^ORD(101.41,TIEN)))
 M ^ORD(101.41,TIEN,6)=^ORD(101.41,FIEN,6)
 S DATA=1
 Q
