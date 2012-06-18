BEHOXQ ;MSC/IND/DKM - Notification Support ;13-Apr-2011 22:28;PLS
 ;;1.1;BEH COMPONENTS;**002003,002004,002006**;Mar 20, 2007;Build 1
 ;=================================================================
 ; RPC: Get alerts for user
 ;   DFN = If specified, limit alerts to only that patient
 ;   ST  = If specified, starting date/time for alert retrieval
 ;   Return format is:
 ;    Priority^Info Only^Patient Name^Pt Location^Display Text^Date Delivered^Sender Name^DFN^Alert Type^Alert ID^Can Delete^Extra Info
ALRLIST(DATA,DFN,ST) ;EP
 N ALX,TOT,ALL,TMP,FN,NOW,QUALS,X,X3
 D SETVAR^CIANBUTL("DFN",$G(DFN),"BEHOXQ")
 S ALL='$L($G(DFN)),DFN=+$G(DFN),(ALX,TOT)=0,TMP=$$TMPGBL^CIAVMRPC,FN=90460.021,NOW=$$NOW^XLFDT,ST=+$G(ST)
 D:'ST CLRVAR^CIANBUTL("BEHOXQ.AID")
 D FIXXQA(DUZ)
 F  S ALX=$O(^BEHOXQ(FN,ALX)) Q:'ALX  X $G(^(ALX,4))
 S ALX=0
 F  S ST=$O(^XTV(8992,DUZ,"XQA",ST)) Q:'ST  S X=$G(^(ST,0)),X3=$G(^(3)) D:$L(X)
 .S ALX=ALX+1,@TMP@(ALX)=$S(X3'="":"G  ",$P(X,U,7,8)="^ ":"I  ",1:"   ")_$P(X,U,3)_U_$P(X,U,2)_U_$P(X,U)_U_$P(X,U,10)
 S ALX=0
 F  S ALX=$O(@TMP@(ALX)) Q:'ALX  D
 .N ALR,ALY,ALD,ALW,ALS,AID,ALT,DFN2,INF,DEL,LOC
 .S ALD=$G(@TMP@(ALX)),AID=$P(ALD,U,2),ALY=$$ALRIEN(AID),ALW=$P(ALD,U,3),DEL=''$P(ALD,U,4)
 .Q:'ALY
 .X $G(^BEHOXQ(FN,ALY,2))
 .S ALT=$P(^BEHOXQ(FN,ALY,0),U),DFN2=+$G(ALR("DFN")),INF=''$G(ALR("INF"))
 .S:INF DEL=1
 .;I DFN2,'$$ISACTIVE^BEHOPTCX(DFN2,.QUALS) Q  ;P7
 .I 'ALL,DFN2,DFN'=DFN2 Q
 .S TOT=TOT+1,ALD=$E($P(ALD,U),4,999)
 .S:ALD["): " ALD=$P(ALD,"): ",2,99)
 .S ALR("TYP")=ALT_$S($L($G(ALR("TYP"))):"."_ALR("TYP"),1:"")
 .S X=+$O(^XTV(8992.1,"B",AID,0)),X3=$G(^XTV(8992.1,X,20,+$O(^XTV(8992.1,X,20,"B",DUZ,$C(1)),-1),0)),ALS=+$P(X3,U,7)
 .I ALS S ALW=$P(X3,U,8)  ; Alert was forwarded
 .E  S ALS=$P($G(^XTV(8992.1,X,0)),U,5)
 .S ALS=$$GET1^DIQ(200,+ALS,.01)
 .S X=$P($G(^DPT(DFN2,0)),U),X3=$$HRN^BEHOPTCX(DFN2)
 .;Added Patient Location (Room/Bed)
 .S LOC=$G(^DPT(DFN2,.1))_"  "_$G(^DPT(DFN2,.101))
 .S:$L(X3) X=X_"    ("_X3_")"
 .S @DATA@(DFN2,TOT)=$G(ALR("PRI"),2)_U_INF_U_X_U_LOC_U_ALD_U_ALW_U_ALS_U_DFN2_U_ALR("TYP")_U_AID_U_DEL_U_$G(ALR("XTR"))
 .D SETVAR^CIANBUTL(AID,1,"BEHOXQ.AID")
 D SETVAR^CIANBUTL("START",NOW,"BEHOXQ")
 K @TMP
 Q
 ; RPC: Retrieve comment and message text associated with an alert.
ALRMSG(DATA,AID) ;EP
 N CMT
 I $$TEST^CIAUOS("XQALGUI") D
 .N FNC
 .S FNC("XQAID")=AID,FNC("LOC")="GETLONG"
 .D ENTRY^XQALGUI(.DATA,.FNC)
 S CMT=$P($G(^XTV(8992,DUZ,"XQA",$$XTVIEN(AID),2)),U,3)
 S:$L(CMT) @DATA@(-2)=CMT,@DATA@(-1)=""
 Q
 ; RPC: Forward an alert
FORWARD(DATA,AID,USR,CMT) ;EP
 D FORWARD^XQALFWD(.AID,.USR,"A",$G(CMT))
 S DATA=0
 Q
 ; Check for new and deleted alerts
ALRCHECK N ST,TMP,X,Y
 S ST=$$GETVAR^CIANBUTL("START",0,"BEHOXQ"),TMP=$$TMPGBL^CIAVMRPC(1),X=""
 D ALRLIST(TMP,$$GETVAR^CIANBUTL("DFN",,"BEHOXQ"),ST)
 F  S X=$O(@TMP@(X)),Y=0 Q:'$L(X)  D
 .F  S Y=$O(@TMP@(X,Y)) Q:'Y  D
 ..D QUEUE^CIANBEVT("ALERT.ADD",@TMP@(X,Y))
 K @TMP
 F  S X=$O(^XTMP("CIA",CIA("UID"),"V","BEHOXQ.AID",X)) Q:'$L(X)  D
 .Q:$D(^XTV(8992,"AXQA",X))
 .D QUEUE^CIANBEVT("ALERT.DELETE",X),SETVAR^CIANBUTL(X,,"BEHOXQ.AID")
 Q
 ; RPC: Alert post processing
ALRPP(DATA,AID) ;EP
 S DATA=$$ALRIEN(AID)
 X:DATA $G(^BEHOXQ(90460.021,DATA,3))
 Q
 ; Return IEN of alert handler
ALRIEN(AID) ;
 N ALY,FN,IEN
 S (ALY,IEN)=0,FN=90460.021
 F  S ALY=$O(^BEHOXQ(FN,ALY)) Q:'ALY  D  Q:IEN
 .I 0
 .X $G(^BEHOXQ(FN,ALY,1))
 .I  S IEN=ALY
 Q IEN
 ; Return IEN of alert in ALERT file
XTVIEN(AID) ;
 Q +$O(^XTV(8992,"AXQA",AID,DUZ,$C(1)),-1)
 ; Parse an order alert
ORPARSE(AID,ALR) ;
 N ORN,PRI
 S ORN=$P($P(AID,";"),",",3)
 D URGENCY^ORQORB(.PRI,ORN)
 S ALR("INF")=$P($G(^ORD(100.9,ORN,0)),U,6,7)="INFODEL^ORB3FUP2"
 S ALR("DFN")=+$P(AID,",",2),ALR("TYP")=+$P($P(AID,";"),",",3),ALR("PRI")=$S(PRI>0:PRI,1:2)
 Q
 ; Parse a TIU alert
TIUPARSE(AID,ALR) ;
 N X
 D GETALRT^TIUSRVR(.X,AID)
 S ALR("XTR")=$P(X,U,3),ALR("TYP")=+ALR("XTR"),ALR("DFN")=+$P(X,U,2),ALR("PRI")=2
 S ALR("XTR")=ALR("XTR")_U_"VSIT="_$P($G(^TIU(8925,+X,0)),U,3)
 Q
 ; Parse a BEH alert
BEHPARSE(AID,ALR) ;EP
 N XQAID,XQADATA,XQAROU,XQAOPT,X,Y,Z
 D GETACT^XQALERT(AID)
 S ALR("INF")=XQAROU="^ ",ALR("XTR")=XQADATA
 F Z=1:1:$L(XQADATA,U) D
 .S X=$P(XQADATA,U,Z),Y=$P(X,"=",2,999),X=$P(X,"=")
 .S:$L(X) ALR(X)=Y
 Q
 ; Delete a BEH alert
BEHDEL(XQAID,XQAKILL) ;EP
 N XQAFOUND
 D DELETE^XQALERT
 Q:$Q +$G(XQAFOUND)
 Q
 ; RPC: Schedule an alert
SCHALR(DATA,DAT,ID,SBJ,XTR,MSG,RCP) ;EP
 N FDA,ERR,SUB,X,Y
 S FDA=$NA(FDA(90460.022,"+1,"))
 S @FDA@(.01)=DAT
 S @FDA@(1)=ID
 S @FDA@(2)="`"_DUZ
 S @FDA@(5)=$G(SBJ)
 S @FDA@(6)=$G(XTR)
 S:$D(MSG)>1 @FDA@(20)="MSG"
 S:'$D(RCP) RCP=DUZ
 S:$G(RCP) RCP(-1)=RCP
 S X="",Y=2
 F  S X=$O(RCP(X)) Q:'$L(X)  D
 .S RCP=RCP(X),RCP=$S('RCP:"",RCP<0:"G.`"_-RCP,1:"U.`"_RCP)
 .S:$L(RCP) FDA(90460.0221,"+"_Y_",+1,",.01)=RCP,Y=Y+1
 D UPDATE^DIE("UE","FDA",,"ERR")
 S DATA='$D(ERR),SUB("DUZ",DUZ)=""
 D:DATA BRDCAST^CIANBEVT("ALERT.SCHEDULE.ADD","",.SUB)
 Q
 ; Check for scheduled alerts
SCHCHECK N DAT,NOW,IEN,FN
 S DAT=0,NOW=$$NOW^XLFDT,FN=90460.022
 F  S DAT=$O(^BEHOXQ(FN,"B",DAT)),IEN=0 Q:'DAT!(DAT>NOW)  D
 .F  S IEN=$O(^BEHOXQ(FN,"B",DAT,IEN)) Q:'IEN  D
 ..L +^BEHOXQ(FN,IEN):0
 ..E  Q
 ..N X,XQA,XQAMSG,XQAOPT,XQAROU,XQAID,XQADATA,XQAFLG,XQAARCH,XQASURO,XQASUPV,XQATEXT,DUZ,RCP
 ..S X=$G(^BEHOXQ(FN,IEN,0)),XQAMSG=$G(^(5)),XQADATA=$G(^(6)),XQAID=$P(X,U,2),DUZ=$P(X,U,3),XQATEXT=$NA(^(20)),RCP="",DUZ(2)=+$$GETDIV(DUZ)  ;IHSDIV^XUS1(DUZ)
 ..I $$PATCH^XPDUTL("XU*8.0*285") D
 ...N TMP S TMP=XQATEXT
 ...K XQATEXT
 ...M XQATEXT=@TMP
 ..F  S RCP=$O(^BEHOXQ(FN,IEN,10,"B",RCP)) Q:'$L(RCP)  D
 ...I RCP[";VA(200," S XQA(+RCP)=""
 ...E  S XQA("G."_$$GET1^DIQ(3.8,+RCP,.01))=""
 ..D SETUP^XQALERT,SCHDEL(,IEN)
 ..L -^BEHOXQ(FN,IEN)
 Q
 ; RPC: Delete a scheduled alert
 ;   DATA = True if entry deleted
SCHDEL(DATA,IEN) ;EP
 N FN,SUB
 S FN=90460.022,DATA=0,SUB("DUZ",+$P($G(^BEHOXQ(FN,IEN,0)),U,3))=""
 L +^BEHOXQ(FN,IEN):0
 E  Q
 D DIK(90460.022,IEN)
 L -^BEHOXQ(FN,IEN)
 S DATA='$D(^BEHOXQ(FN,IEN))
 D:DATA BRDCAST^CIANBEVT("ALERT.SCHEDULE.DELETE",IEN,.SUB)
 Q
 ; RPC: List alerts scheduled by user.
 ;  ID  = Alert ID
 ;  USR = IEN of user (defaults to current)
 ;  Return format is: IEN^Date^Patient Name^Subject^Data
SCHLIST(DATA,ID,USR) ;EP
 N X,IEN,CNT,DAT,DFN,SBJ,XTR
 S:'$G(USR) USR=DUZ
 S (IEN,CNT)=0
 F  S IEN=$O(^BEHOXQ(90460.022,"C",USR,IEN)) Q:'IEN  D
 .S X=$G(^BEHOXQ(90460.022,IEN,0)),SBJ=$G(^(5)),XTR=$G(^(6))
 .Q:$P(X,U,2)'=ID
 .S DAT=+X,DFN=+$P(U_XTR,"^DFN=",2),CNT=CNT+1
 .S @DATA@(CNT)=IEN_U_DAT_U_$P($G(^DPT(DFN,0)),U)_U_SBJ_U_XTR
 Q
 ; RPC: Return list of recipients
SCHRECIP(DATA,IEN) ;EP
 N RCP,CNT,X
 S RCP="",CNT=0
 F  S RCP=$O(^BEHOXQ(90460.022,IEN,10,"B",RCP)) Q:'$L(RCP)  D
 .I RCP[";VA(200," S X=+RCP_U_$$GET1^DIQ(200,+RCP,.01)
 .E  S X=-RCP_U_"G."_$$GET1^DIQ(3.8,+RCP,.01)
 .S CNT=CNT+1,@DATA@(CNT)=X
 Q
 ; RPC: Return message text associated with a scheduled alert.
SCHMSG(DATA,IEN) ;EP
 M @DATA=^BEHOXQ(90460.022,IEN,20)
 K @DATA@(0)
 Q
 ; Delete a file entry
DIK(DIK,DA) ;EP
 S:DIK=+DIK DIK=$$ROOT^DILFD(DIK)
 D ^DIK
 Q
 ; Return true if notification type is enabled
 ;   ORN = IEN in OE/RR NOTIFICATION file
 ;   USR = Potential recipient of notification
ENABLED(ORN,USR) ;EP
 Q:'ORN 1
 Q:'$D(^ORD(100.9,ORN,0)) 1
 I $$PATCH^XPDUTL("OR*3.0*220") Q:$$GET^XPAR($$ENTITY^ORB31(ORN),"ORB SYSTEM ENABLE/DISABLE",1,"I")="D" 0
 E  Q:$$GET^XPAR($$ENTITY^ORB31(ORN,USR),"ORB SYSTEM ENABLE/DISABLE",1,"I")="D" 0
 Q $$GET^XPAR($$ENT^CIAVMRPC("ORB PROCESSING FLAG",,USR),"ORB PROCESSING FLAG",ORN)'="D"
 ; Fix XQA node in Alert File for user
FIXXQA(USER) ;
 I $D(^XTV(8992,USER,"XQA",0))#2,'$P(^(0),U,2) S $P(^(0),U,2)="8992.01DA"
 Q
 ; Return mail group IEN if user is a member of the specified mail group
 ; or indirectly through a member mail group.
ISMBR(MGRP,USER,EXCL) ;PEP - See comment above
 S USER=$G(USER,DUZ)
 S:MGRP'=+MGRP MGRP=$O(^XMB(3.8,"B",MGRP,0))
 Q:'MGRP 0
 Q:$D(EXCL(MGRP)) 0
 Q:$D(^XMB(3.8,MGRP,1,"B",USER)) MGRP
 N GRP
 S EXCL(MGRP)="",GRP=0
 F  S GRP=$O(^XMB(3.8,MGRP,5,"B",GRP)) Q:'GRP  Q:$$ISMBR(GRP,USER,.EXCL)
 Q +GRP
GETDIV(USR) ;EP
 Q:$G(DUZ("AG"))="I" $$IHSDIV^XUS1(USR)
 N X
 ; Default Division in file 200, "AX1" x-ref
 S X=+$O(^VA(200,USR,2,"AX1",1,0))
 ; If only one division get that one
 I 'X D
 .S X=+$O(^VA(200,USR,2,0))
 .S:$O(^VA(200,USR,2,X)) X=0
 Q X
CANCHGPT(DATA,DFN) ; EP-
 S DATA=$$ISACTIVE^BEHOPTCX(DFN)
 Q
