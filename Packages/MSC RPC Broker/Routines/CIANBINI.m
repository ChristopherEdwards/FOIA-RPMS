CIANBINI ;MSC/IND/DKM - MSC RPC Broker Installation ;11-May-2010 07:03;DKM
 ;;1.1;CIA NETWORK COMPONENTS;**001007**;Sep 18, 2007
 ;;Copyright 2000-2008, Medsphere Systems Corporation
 ;=================================================================
 ; Environment check
EC D PATCH("XPAREDT2","26,35,52","KERNEL TOOLKIT")
 D RTNTST("CIAU",1.2,"CIA UTILITIES 1.2")
 D OBJCHK
 I '$G(XPDQUIT),$G(XPDENV)=1 D
 .N X
 .L +^XTMP("CIANBLIS"):0
 .I  L -^XTMP("CIANBLIS") Q
 .D MES("One or more broker processes are currently running."),MES()
 .I '$$ASK^CIAU("   Do you wish to continue the installation") S XPDABORT=2
 .E  D:$L($T(+0^CIANBLIS)) STOPALL^CIANBLIS
 .F X="XPI1","XPO1","XPZ1" S XPDDIQ(X)=0
 .S XPDNOQUE=1
 Q
 ; Check if specified routine is installed
RTNTST(RTN,VN,MSG) ;
 D:$$RTNVER(RTN)<VN MES(MSG_" must be installed before proceeding.",2)
 Q
 ; Get version # for specified routine
RTNVER(RTN) ;
 Q $P($T(+2^@RTN),";",3)
 ; Check patch #s for specified routine
PATCH(RTN,PN,MSG) ;
 N X,Y,L,F
 F X=1:1:$L(PN,",") D
 .S Y=$P(PN,",",X),F=0
 .F L=2,3 D  Q:F
 ..S F=$TR($P($T(+L^@RTN),";",5),"*",",")[(","_Y_",")
 .D:'F MES(MSG_" patch #"_Y_" must be installed before proceeding.",2)
 Q
 ; Check binary version against M system
OBJCHK ; EP
 N VER,MSYS
 D GETMSYS(.MSYS,.VER)
 Q:'$D(MSYS)
 I '$D(VER) D
 .D MES("This package contains object code that is not supported on "_MSYS_" installations.",2)
 E  I VER="" D
 .D MES("This package does not contain object code for this version of "_MSYS_" installations.",2)
 Q
 ; Get M system type and target version
GETMSYS(MSYS,VER) ;
 K MSYS,VER
 Q:'$D(@XPDGREF@("OBJ"))
 S MSYS=$$UP^XLFSTR($P($$VERSION^%ZOSV(1)," ")),MSYS(0)=$S(MSYS="CACHE":1,MSYS="JUMPS":2,1:0)
 Q:'$D(@XPDGREF@("OBJ",MSYS(0)))
 S VER=$TR($$VERSION^%ZOSV()," ")
 F  Q:'$L(VER)  Q:$D(@XPDGREF@("OBJ",MSYS(0),VER))  S VER=$P(VER,".",1,$L(VER,".")-1)
 Q
 ; Display message in MSG and optionally set quit flag to QUIT
MES(MSG,QUIT) ;
 D BMES^XPDUTL("  "_$G(MSG))
 S:$G(QUIT) XPDQUIT=QUIT
 Q
 ; Pre-init
PRE S @XPDGREF@("NEW")=$D(^CIANB)<10
 D OBJINST
 X $G(@XPDGREF@("INITIAL"))
 Q
 ; Post-init
POST X ^%ZOSF("EON"),^%ZOSF("TRMOFF")
 D CVT,DEFPAR
 X $G(@XPDGREF@("FINAL"))
 D:$G(@XPDGREF@("NEW")) TEDH^XPAREDIT("CIANB SITE PARAMETERS","BA")
 D CLEANUP^CIANBUTL,STARTALL^CIANBLIS
 K ^DIC(19941.24,0,"RD")
 Q
 ; Convert entries from old event file
CVT N X,FN
 S FN=19941.21
 Q:$O(^CIANB(FN,0))!'$O(^CIAVEVT(0))
 S X=$P(^CIANB(FN,0),U,1,2)
 M ^CIANB(FN)=^CIAVEVT
 S $P(^CIANB(FN,0),U,1,2)=X,X=0
 F  S X=$O(^CIANB(FN,X)) Q:'X  D
 .D CVTX(2,99,99)
 .D CVTX(3,20,"2P")
 Q
 ; Move multiples to new nodes and fix sfn
CVTX(NF,NT,SN) ;
 M ^CIANB(FN,X,NT)=^CIANB(FN,X,NF)
 K ^CIANB(FN,X,NF)
 S $P(^CIANB(FN,X,NT,0),U,2)=FN_SN
 Q
 ; Initializes default parameter values.  Does not affect existing entries.
DEFPAR N V,X,Y,Z
 D MES("Setting up default site parameters...")
 D DEL^XPAR("PKG","CIANB AUTHENTICATION",1)
 F X=0:0 S X=$O(@XPDGREF@("PARAM",X)) Q:'X  M Z=^(X) D
 .S Y=Z,Z=$$MSG^CIAU($P(Y,U,3,999),"|",0),V=$$MSG^CIAU($P(Y,U,2),"|"),Y=$P(Y,U)
 .D ADD^XPAR("PKG",Y,V,.Z)
 Q
 ; Install routine binaries
OBJINST ; EP
 N MSYS,RTN,OBJ,SUB,GBL
 D GETMSYS(.MSYS,.VER)
 Q:'$D(MSYS)
 Q:$D(@XPDGREF@("OBJ",MSYS(0)))<10
 S RTN=""
 D MES("Installing Routine Binaries...")
 F  S RTN=$O(@XPDGREF@("OBJ",MSYS(0),VER,RTN)) Q:'$L(RTN)  D
 .X "ZR  ZS @RTN"
 .S OBJ="",SUB=0,GBL=$NA(@$S(MSYS(0)=1:"^rOBJ(RTN)",1:"^$R(RTN,""OBJECT"")"))
 .F  S SUB=$O(@XPDGREF@("OBJ",MSYS(0),VER,RTN,SUB)) Q:'SUB  S OBJ=OBJ_^(SUB,0)
 .S @GBL=$S(MSYS(0)=1:$$DECODE^CIAUUU(OBJ),1:OBJ)
 .D MES("  "_RTN_" installed.")
 Q
