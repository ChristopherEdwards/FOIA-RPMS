CIANBUTL ;MSC/IND/DKM - MSC RPC Broker Utilities ;09-Jul-2008 10:37;PLS
 ;;1.1;CIA NETWORK COMPONENTS;**001007**;Sep 18, 2007
 ;;Copyright 2000-2008, Medsphere Systems Corporation
 ;=================================================================
 ; Cleanup stray global nodes
CLEANUP ;EP
 N UID
 F  Q:'$$NXTUID(.UID,0)  K ^XTMP("CIA",UID)
 Q
 ; Force RPC context tables to be rebuilt for all active sessions
REBLDCTX ;EP
 N UID,CTX
 F  Q:'$$NXTUID(.UID)  D
 .F CTX=0:0 S CTX=$O(^XTMP("CIA",UID,"C",CTX)) Q:'CTX  S ^(CTX)=0
 Q
 ; Get globally unique instance ID
UID() N UID,FLG
 L +^XTMP("CIA",0):5
 E  Q "-3^Cannot initialize environment"
 S FLG=0
 F UID=$P($G(^XTMP("CIA",0)),U,3)+1:1 D  Q:(UID<1)!(FLG=2)
 .I (UID<1)!(UID>999999) D  Q:UID<1
 ..S UID=$S('FLG:1,1:"-4^Lock table is full"),FLG=1
 .S:'$$ISACTIVE(UID,1) FLG=2
 S:UID>0 ^XTMP("CIA",0)=(DT+10000)_U_DT_U_UID
 L -^XTMP("CIA",0)
 Q UID
 ; Verifies that a session is truly active
 ;   UID = Unique id of session
 ;   LCK = If nonzero, leave lock active (defaults to 0)
 ;   TMO = Optional lock timeout (defaults to 0)
ISACTIVE(UID,LCK,TMO) ;EP
 Q:'$G(UID) 0
 Q:UID=$G(CIA("UID")) 1
 L +^XTMP("CIA",UID,0):+$G(TMO)
 E  Q 1
 L:'$G(LCK) -^XTMP("CIA",UID,0)
 Q 0
 ; Gets the session ID associated with this process
 ; If not in session context, attempt answerback from client
GETUID() ;EP
 I '$D(CIA("UID")) D
 .S CIA("UID")=""
 .Q:$D(ZTQUEUED)
 .N X,UID,I
 .S I=$I,UID=""
 .U $S($D(IO(0)):IO(0),1:$P)                                           ; Use home device
 .X ^%ZOSF("EOFF")                                                     ; Suppress echo
 .F  R X#1:0 Q:'$T                                                     ; Flush keyboard buffer
 .W $C(5)                                                              ; Send answerback request
 .F  R X:4 Q:'$T&'$L(X)  S UID=UID_X                                   ; Listen for response
 .S UID=$P(UID,"CIA#",2)
 .X ^%ZOSF("EON")                                                      ; Restore echo
 .U I                                                                  ; Restore previous device
 .I $$ISACTIVE(UID),$$GETVAR("DUZ",,,UID)=DUZ S CIA("UID")=UID
 .E  S CIA("UID")=""
 Q:$Q CIA("UID")
 Q
 ; Retrieve next session ID from list
 ;   UID passed as last ID processed, returned as next ID or null
 ;   FLT = <0=all; 0=inactive only; >0=active only (default)
 ;   AID = Application ID (optional)
 ;   Return value is true if ID found
NXTUID(UID,FLT,AID) ;EP
 N PFX,FND,ALL,ACT
 S FLT=+$G(FLT,1),FND=0,ALL=FLT<0,ACT=FLT>0,AID=$$OPTLKP(.AID),UID=+$G(UID)
 I $L(AID) F  S UID=$O(^XTMP("CIA",UID)) Q:'UID  D  Q:FND
 .I AID,$$GETVAR("AID0",,,UID)'=AID Q
 .I 'ALL,$$ISACTIVE(UID)'=ACT Q
 .S FND=1
 S:'FND UID=""
 Q:$Q FND
 Q
 ; Retrieve a package parameter value
PARAM(PAR,MIN,MAX) ;EP
 S VAL=+$$GET^XPAR("ALL",PAR)
 S:VAL<MIN VAL=MIN
 S:VAL>MAX VAL=MAX
 Q VAL
 ; Return free resource device
RESDEV() ;EP
 N RD,MX,SL,UID,X,C
 S MX=$$PARAM("CIANB RESOURCE DEVICE COUNT",1,20)
 S SL=$$PARAM("CIANB RESOURCE DEVICE SLOTS",1,20)
 F  Q:'$$NXTUID(.UID)  D
 .S RD=$$GETVAR("RDEV",,,UID)
 .S:RD RD(RD)=$G(RD(RD))+1
 S RD=1,C=999999
 F X=1:1:MX S:+$G(RD(X))<C RD=X,C=+$G(RD(X))
 S X=$$RES^XUDHSET("CIANB THREAD RESOURCE #"_RD,,SL,"CIA Broker Asynchronous Callbacks")
 Q RD
 ; Set maximum slots for resource devices
SETSLOTS(CNT) ;EP
 N RES,IEN,FDA,X,Y
 Q:CNT<2!(CNT>20)
 D FIND^DIC(3.5,,"@","UP","CIANB THREAD RESOURCE #",,"B")
 F RES=0:0 S RES=$O(^TMP("DILIST",$J,RES)) Q:'RES  S IEN=+$G(^(RES,0)) D:IEN
 .S FDA(3.5,IEN_",",35)=CNT
 D FILE^DIE("K","FDA")
 K ^TMP("DILIST",$J),^TMP("DIERR",$J)
 Q
 ; Return info for session
SESSION(UID,VAR) ;EP
 N X,Y,Z
 S (X,Y)=""
 S:'$L($G(VAR)) VAR="UID^WID^AID^DUZ^USER^LDT^JOB"
 F Z=1:1:$L(VAR,U) S X=X_Y_$$GETVAR($P(VAR,U,Z),,,.UID),Y=U
 Q X
 ; Show active sessions
 ;   AID = optional application id
 ;   FLT = <0=all; 0=inactive only; >0=active only (default)
SHOWSESS(AID,FLT) ;EP
 N C,X,Z
 F C=0:1 Q:'$$NXTUID(.X,.FLT,.AID)  D
 .W "#",X,?10,$$HTE^XLFDT($$GETVAR("LDT",,,X)),?40,$$GETVAR("WID",,,X),?60,$$GETVAR("USER",,,X),!
 W !,$S('C:"No sessions are",C=1:"One session is",1:C_" sessions are")," ",$S(FLT>0:"active",FLT<0:"present",1:"inactive"),".",!
 Q:$Q C
 Q
 ; Fetch an environment variable
 ;   NAME = Variable name
 ;   DFLT = Optional default value
 ;   NMSP = Optional namespace (defaults to global)
 ;   UID  = Optional session id (default to current)
GETVAR(NAME,DFLT,NMSP,UID) ;EP
 D FMTVAR(.UID,.NMSP,.NAME)
 Q $S('UID:"",1:$G(^XTMP("CIA",UID,"V",NMSP,NAME),$G(DFLT)))
 ; Save an environment variable
 ;   NAME = Variable name
 ;   VALUE = Value to be assigned (if not specified, entry is deleted)
 ;   NMSP = Optional namespace (defaults to global)
SETVAR(NAME,VALUE,NMSP,UID) ;EP
 N $ET
 S $ET="S $EC="""" G ERRVAR^CIANBUTL"
 D FMTVAR(.UID,.NMSP,.NAME)
 I 'UID Q:$Q 0 Q
 L +^XTMP("CIA",UID,"V",NMSP,NAME):1
 ;E  Q:$Q 0 Q
 I $D(VALUE) S:NMSP=-1 @NAME=VALUE S ^XTMP("CIA",UID,"V",NMSP,NAME)=VALUE
 E  K:NMSP=-1 @NAME K ^XTMP("CIA",UID,"V",NMSP,NAME)
 L -^XTMP("CIA",UID,"V",NMSP,NAME)
 Q:$Q 1
 Q
 ; Clear all variables in a namespace
CLRVAR(NMSP,UID) ;EP
 N NAME,RES
 D FMTVAR(.UID,.NMSP)
 L +^XTMP("CIA",UID,"V",NMSP):1
 ;E  Q:$Q 0 Q
 S NAME="",RES=1
 F  S NAME=$O(^XTMP("CIA",UID,"V",NMSP,NAME)) Q:'$L(NAME)  S RES=RES&$$SETVAR(NAME,,NMSP,UID)
 L -^XTMP("CIA",UID,"V",NMSP)
 Q:$Q RES
 Q
 ; Restore variables from local variable namespace
RESVAR N NAME,UID
 D FMTVAR(.UID)
 S NAME=""
 F  S NAME=$O(^XTMP("CIA",UID,"V",-1,NAME)) Q:'$L(NAME)  S @NAME=^(NAME)
 Q
 ; Error handler for var calls
ERRVAR L -^XTMP("CIA",UID,"V",NMSP,NAME)
 Q:$Q 0
 Q
 ; Format arguments for var calls
FMTVAR(UID,NMSP,NAME) ;
 S UID=$G(UID,$G(CIA("UID")))
 S NMSP=$$UP^XLFSTR($G(NMSP,0))
 S NAME=$$UP^XLFSTR($G(NAME))
 S:NMSP=-1&$L(NAME) NAME=$NA(@NAME)
 Q
 ; Retrieve dialog text
 ;  NUM = Dialog number (relative or absolute)
 ; .DLG = Array to receive text
 ;  Pn  = Optional parameters (up to 3)
GETDLG(NUM,DLG,P1,P2,P3) ;
 N PAR
 K DLG
 S:NUM<10000 NUM=NUM+199412000
 S PAR(1)=$G(P1,$G(CIA("RPC"))),PAR(2)=$G(P2),PAR(3)=$G(P3)
 D BLD^DIALOG(NUM,.PAR,,"DLG")
 Q:$Q $G(DLG(1))
 Q
 ; Lookup option, returning IEN
OPTLKP(OPT) ;EP
 Q $S('$L($G(OPT)):0,OPT=+OPT:OPT,1:$O(^DIC(19,"B",OPT,0)))
 ; Get/set out-of-order message for option
 ;   MSG = New message (if passed, a set is performed, otherwise a get)
 ;   Returns current message text
OPTMSG(OPT,MSG) ;EP
 S OPT=+$$OPTLKP(.OPT)
 I OPT,$D(^DIC(19,OPT,0)) D                                            ; Sets naked ref
 .I $D(MSG) S $P(^(0),U,3)=MSG
 .E  S MSG=$P(^(0),U,3)
 E  S MSG=""
 Q:$Q MSG
 Q
 ; Check option for valid access
 ;   OPT=Option IEN or name
 ;   TYP=Optional option type to check
 ;   Returns 0 if OK, <err code>^<err param> otherwise
OPTCHK(OPT,TYP) ;EP
 N XQY,X,Y,Z
 S XQY=$S(OPT=+OPT:OPT,1:$$OPTLKP(OPT))
 Q:XQY'>0 "2^"_OPT
 S X=$G(^DIC(19,XQY,0)),Y=$P($G(^(3)),U),Z=$P(X,U,3)
 Q:$L(Z) "19^"_Z
 I $L($G(TYP)),$P(X,U,4)'=TYP Q "20^"_OPT_U_TYP
 I $P(X,U,16),$L(Y),$$KCHK^XUSRB(Y) Q "21^"_OPT_U_Y
 S Y=$P(X,U,6)
 I $L(Y),'$$KCHK^XUSRB(Y) Q "22^"_OPT_U_Y
 S X=$$NOW^XLFDT
 D ENTRY^XQ92
 Q:'X "23^"_OPT
 Q 0
 ; Nightly task to perform various cleanup procedures.
NIGHTLY ;EP
 D CLEANUP
 D DOPURGE^CIANBEVT(1)
 D DOPURGE^CIANBLOG
 Q
