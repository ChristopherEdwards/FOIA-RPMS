CIAVMRPC ;MSC/IND/DKM - Miscellaneous RPC calls ;22-Oct-2007 13:08;DKM
 ;;1.1V2;VUECENTRIC FRAMEWORK;**1**;Mar 20, 2007
 ;;Copyright 2000-2006, Medsphere Systems Corporation
 ;=================================================================
 ; RPC: Initialize a session
INIT(DATA,CIAVER) ;
 N PAR,MINVER,X
 S MINVER="1.4"
 I $$VERCMP(CIAVER,MINVER,$L(MINVER,"."))<0 S DATA(0)="-2^Client version ("_CIAVER_") is not compatible with server version ("_MINVER_")." Q
 S DATA(0)=0
 F X=0:1 S PAR=$P($T(INITPAR+X),";;",2) Q:'$L(PAR)  D
 .S DATA(X+1)=$$PARAM($P(PAR,U),$P(PAR,U,2),$P(PAR,U,3))
 Q
 ; Initialization parameters to return to caller (do not change order)
 ; Format is param name^low limit^high limit
INITPAR ;;CIAVM DISABLE CCOW^0^1
 ;;
 ; Retrieve a package parameter value
PARAM(PAR,MIN,MAX) ;
 S VAL=+$$GET^XPAR("ALL",PAR)
 S:VAL<MIN VAL=MIN
 S:VAL>MAX VAL=MAX
 Q VAL
 ; RPC: Get/set DISV entry for selected file/IEN
 ; If IEN is specified, entry is set
 ; Returned as IEN^.01 internal value
DISV(DATA,FILE,IEN) ;
 S FILE=$$ROOT^DILFD(+FILE)
 I FILE="" S DATA=0 Q
 S:$G(IEN) ^DISV(DUZ,FILE)=IEN
 S DATA=+$G(^DISV(DUZ,FILE))
 S:DATA $P(DATA,U,2)=$P($G(@(FILE_DATA_",0)")),U)
 Q
 ; RPC: Return version of package
VERSION(DATA,PKG) ;
 S DATA=$$VERSION^XPDUTL(PKG)
 Q
 ; RPC: Return true if patch installed
PATCH(DATA,PATCH) ;
 S DATA=$$PATCH^XPDUTL(PATCH)
 Q
 ; RPC: Returns value for named parameter
GETPAR(DATA,PARAM,ENT,INST,FMT,USR) ;
 N X
 S ENT=$$ENT(PARAM,.ENT,.USR),DATA=$S($L(ENT):$$GET^XPAR(ENT,PARAM,.INST,.FMT),1:"")
 Q
 ; RPC: Get multivalued parameter values
GETPARLI(DATA,PARAM,ENT,FMT,USR) ;
 N TMP,X
 D GETLST^XPAR(.TMP,$$ENT(PARAM,.ENT,.USR),PARAM,.FMT,.ERR)
 I $G(ERR) K TMP S TMP=ERR
 E  S TMP=""
 S DATA=$$TMPGBL
 M @DATA=TMP
 Q
 ; RPC: Get WP parameter value
GETPARWP(DATA,PARAM,ENT,INST,USR) ;
 N TMP,X
 D GETWP^XPAR(.TMP,$$ENT(PARAM,.ENT,.USR),PARAM,.INST,.ERR)
 I $G(ERR) K TMP S TMP=ERR
 E  S TMP=""
 S DATA=$$TMPGBL
 M @DATA=TMP
 Q
 ; Return entity list (if ENT not specified)
ENT(PAR,ENT,USR) ;EP
 N I,X,Y,Z
 Q:$L($G(ENT)) ENT
 I $L(PAR),PAR'=+PAR S PAR=$O(^XTV(8989.51,"B",PAR,0))
 Q:'PAR ""
 S X="",I=0,USR=$G(USR,DUZ)
 F  S I=+$O(^XTV(8989.51,PAR,30,"B",I)) Q:'I  S Y=$O(^(I,0)) D:Y
 .S Y=$P($G(^XTV(8989.518,+$P($G(^XTV(8989.51,PAR,30,Y,0)),U,2),0)),U,2)
 .Q:'$L(Y)
 .I "DIV^SYS^PKG"[Y S X=X_U_Y Q
 .I Y="USR" S X=X_U_"USR.`"_USR Q
 .I Y="SRV" S Z=+$G(^VA(200,USR,5)) S:Z X=X_U_"SRV.`"_Z Q
 .I Y="OTL" Q                                                          ; OE/RR TEAM
 .I Y="TEA" Q                                                          ; TEAM
 .I Y="CLS" D  Q
 ..S Z=0
 ..F  S Z=$O(^USR(8930.3,"AUC",USR,Z)) Q:'Z  D CLS(Z)
 .I Y="LOC",$G(CIA("UID")) D  Q
 ..S Z=+$$GETVAR^CIANBUTL("ENCOUNTER.ID.ALTERNATEVISITID",,"CONTEXT.ENCOUNTER")
 ..S:Z X=X_U_"LOC.`"_Z
 Q $E(X,2,$L(X))
 ; Append user class memberships to entity list
CLS(Z) N Y
 S X=X_U_"CLS.`"_Z,Y=0
 F  S Y=$O(^USR(8930,"AD",Z,Y)) Q:'Y  D CLS(Y)
 Q
 ; RPC: Changes value for named parameter
SETPAR(DATA,PARAM,VAL,ENT,INST) ;
 D EN^XPAR($G(ENT,"PKG"),PARAM,$G(INST,1),VAL,.DATA)
 Q
 ; RPC: Get stored variable(s)
GETVAR(DATA,LIST,NMSP) ;
 N CNT
 S:$L($G(LIST)) LIST(-99)=LIST
 S LIST="",CNT=0
 F  S LIST=$O(LIST(LIST)) Q:'$L(LIST)  D
 .S CNT=CNT+1,DATA(CNT)=LIST(LIST)_"="_$$GETVAR^CIANBUTL(LIST(LIST),,.NMSP)
 Q
 ; RPC: Set stored variable(s)
SETVAR(DATA,LIST,NMSP,RESET) ;
 S:$L($G(LIST)) LIST(-99)=LIST
 S LIST="",DATA=0
 D:$G(RESET) CLRVAR^CIANBUTL(.NMSP)
 F  S LIST=$O(LIST(LIST)) Q:'$L(LIST)  D
 .S DATA=DATA+1
 .D SETVAR^CIANBUTL($P(LIST(LIST),"="),$P(LIST(LIST),"=",2,9999),.NMSP)
 Q
 ; RPC: Get .01 field values from a file
GETIDX(DATA,FN,FLG) ;
 N X,I,Z
 S DATA=$$TMPGBL,X=0,FN=$$ROOT^DILFD(FN,,1),I=0,FLG=+$G(FLG)
 I $L(FN) F  S X=$O(@FN@(X)) Q:'X  D
 .S Z=$P($G(@FN@(X,0)),U)
 .S:$L(Z) I=I+1,@DATA@(I)=$S(FLG:Z,1:X_U_Z)
 Q
 ; RPC: Convert date input to FM format
STRTODAT(DATA,VAL,FMT) ;
 N %DT,X,Y
 I VAL'["@",VAL[" " S VAL=$TR(VAL," ","@")
 I VAL["@",$TR($P(VAL,"@",2),":0")="" S $P(VAL,"@",2)="00:00:01"
 S %DT=$G(FMT,"TS"),X=VAL
 D ^%DT
 S DATA=$S(Y>0:Y,1:"")
 Q
 ; Compare version # VER1 with VER2
 ; Returns -1 if <; 0 if =; 1 if >
VERCMP(VER1,VER2,PC) ;EP
 N X,Y,V1,V2
 S:'$G(PC) PC=4
 S Y=0
 F X=1:1:PC D  Q:Y
 .S V1=+$P(VER1,".",X),V2=+$P(VER2,".",X)
 .S:V1'=V2 Y=$S(V1>V2:1,1:-1)
 Q Y
 ; Get temp global reference
TMPGBL(X) ;EP
 K ^TMP("CIAVMRPC"_$G(X),$J) Q $NA(^($J))
