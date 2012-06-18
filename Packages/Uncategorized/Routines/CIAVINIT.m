CIAVINIT ;MSC/IND/DKM - VueCentric KIDS inits ;15-Feb-2008 09:48;DKM
 ;;1.1V2;VUECENTRIC FRAMEWORK;;Mar 20, 2007
 ;;Copyright 2000-2006, Medsphere Systems Corporation
 ;=================================================================
 ; Environment check
EC I $P(^DD(9000010,15001,0),U)'["VISIT ID"!(^DD(9000010,15003,0)'["S:STOP CODE") D
 .D MES("Visit Tracking must be installed before proceeding",2)
 D RTNTST("VADPT1",5.3,"PIMS 5.3")
 D RTNTST("CIAU",1.1,"CIA UTILITIES 1.1")
 D RTNTST("CIANBLIS",1.1,"CIA RPC BROKER 1.1")
 I $$RTNVER("DI")<22 D
 .D PATCH("DIR",41,"FILEMAN 21")
 .D RTNTST("DDR",21,"FILEMAN 21 DELPHI COMPONENTS-RPCs (patch 34)")
 D OBJCHK
 I $G(XPDENV)=1 D
 .N X
 .F X="XPI1","XPO1","XPZ1" S XPDDIQ(X)=0
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
 ; Display message in MSG and optionally set quit flag to QUIT
MES(MSG,QUIT) ;
 D BMES^XPDUTL("  "_$G(MSG))
 S:$G(QUIT) XPDQUIT=QUIT
 Q
 ; Preinit
PRE N CIAX,CIAY
 S @XPDGREF@("NEW")='$D(^CIAVOBJ(19930.2))
 D MES(),OBJINST,SDINIT^CIAVUTIL(,60,1)
 F  D  Q:'CIAX
 .S CIAX=$$SHOWSESS^CIAVUTIL
 .R:CIAX "Waiting for active sessions to terminate...",CIAY:10,!!
 .I CIAX,CIAY=U,$$ASK^CIAU("There are still active sessions.  Are you sure you want to proceed") S CIAX=0
 D MES("Proceeding with installation...")
 F CIAX=19930.2,19930.21,19930.3 D CLEANUP(CIAX)
 D INITIAL,RENPRGID,SAVEREG,SAVEOPT
 Q
 ; Postinit
POST N PAR,Y
 X ^%ZOSF("EON"),^%ZOSF("TRMOFF")
 D RESPTR,DEFPAR
 D:$G(@XPDGREF@("NEW")) TEDH^XPAREDIT("CIAVM POSTINIT","BA")
 D RESTREG,MMSG,RESTOPT,REGISTER^CIAVIN1,FINAL
 D DELFIL(19930.1)
 D MES("Registering VueCentric with Visit Tracking...")
 I $$PKG^VSIT("CIAV",1)
 W !!!
 Q
 ; Execute initial preinit code, if any
INITIAL ; EP
 X $G(@XPDGREF@("INITIAL"))
 Q
 ; Execute final postinit code, if any
FINAL ; EP
 X $G(@XPDGREF@("FINAL"))
 Q
 ; Initializes default parameter values.  Does not affect existing entries.
DEFPAR N PAR,ENT,VAL,INST,LP,Y
 D MES("Setting up default site parameters...")
 F LP=0:0 S LP=$O(@XPDGREF@("PARAM",LP)) Q:'LP  K VAL M VAL=^(LP) D
 .S Y=VAL,VAL=$$MSG^CIAU($P(Y,U,3,999),"|",0),PAR=$P(Y,U),INST=$P(Y,U,2)
 .S ENT=$$ENT^CIAVMRPC(PAR),ENT=$P(ENT,U,$L(ENT,U))
 .D:$L(ENT) ADD^XPAR(ENT,PAR,INST,.VAL)
 Q
 ; Rename specified PROGIDs
RENPRGID ; EP
 N OLD
 S OLD=""
 F  S OLD=$O(@XPDGREF@("RENAME",OLD)) Q:'$L(OLD)  D RENAME(OLD,$O(^(OLD,"")))
 Q
 ; Rename a PROGID
RENAME(OLD,NEW) ; EP
 N R,X,Y
 S R=0,X=+$$PRGID^CIAVMCFG(OLD,.Y)
 I X,'$$PRGID^CIAVMCFG(NEW) D
 .K ^CIAVOBJ(19930.2,"B",Y,X)
 .S $P(^CIAVOBJ(19930.2,X,0),U)=NEW,^CIAVOBJ(19930.2,"B",$E(NEW,1,30),X)="",R=1
 ; Rename any references in templates
 F X=0:0 S X=$O(^CIAVTPL(X)) Q:'X  S R=R!$$RENTPL(X,OLD,NEW)
 D:R MES("Object "_OLD_" renamed to "_NEW_".")
 Q
 ; Rename imbedded PROGIDs in a template
 ;  TPL = Template name or IEN
 ;  OLD = Old progid (if not specified, all aliases are scanned)
 ;  NEW = New progid (as above)
RENTPL(TPL,OLD,NEW) ; EP
 N LN,LO,X,F,R,P1,P2,Z,Z1
 S (X,R)=0
 I '$D(OLD) D
 .F  S X=$O(^CIAVOBJ(19930.2,X)),Z=0 Q:'X  S NEW=$P($G(^(X,0)),U) D:$L(NEW)
 ..F  S Z=$O(^CIAVOBJ(19930.2,X,10,Z)) Q:'Z  S OLD=$TR($G(^(Z,0))," ") D:$L(OLD)
 ...S R=R!$$RENTPL(TPL,OLD,NEW)
 E  D
 .S LN=$L(NEW),LO=$L(OLD)
 .S:TPL'=+TPL TPL=$$TMPL^CIAVMCFG(TPL)
 .F  S X=$O(^CIAVTPL(TPL,1,X)) Q:'X  S Z=$G(^(X,0)) D
 ..S (F,P2)=0,Z1=$$UP^XLFSTR(Z)
 ..F  S P1=$F(Z1,OLD,P2) Q:'P1  D
 ...Q:$E(Z1,P1)?1AN
 ...Q:$E(Z1,P1-LO-1)?1AN
 ...S $E(Z1,P1-LO,P1-1)=NEW,$E(Z,P1-LO,P1-1)=NEW,P2=P1+LN-LO,F=1
 ..S:F ^CIAVTPL(TPL,1,X,0)=Z,R=1
 Q:$Q R
 Q
 ; Delete a file or subfile
 ;   DIU = File or subfile #
DELFIL(DIU) ; EP
 N $ET
 S $ET="",@$$TRAP^CIAUOS("DELERR^CIAVINIT")
 Q:'$D(^DD(DIU))
 S DIU(0)=$S($D(^DIC(DIU)):"D",1:"S")
 D EN^DIU2
 Q
DELERR N ERR
 S ERR=$$EC^%ZOSV
 D MES("An error occurred deleting file #"_$G(DIU))
 D MES("The error was: "_ERR)
 D MES("Please delete the file manually after correcting the problem.")
 Q
 ; Cleanup any duplicate entries in specified file
CLEANUP(FNUM) ;
 N CIAX,CIAY,CIAY1,CIAZ,DIK,DA,GBL,OPN
 S GBL=$$ROOT^DILFD(FNUM,,1),OPN=$$ROOT^DILFD(FNUM)
 I $L(GBL),$D(@GBL) D
 .D MES("Cleaning up "_$$GET1^DID(FNUM,,,"NAME")_"...")
 .K DIK,DA,@GBL@("B")
 .S DIK=OPN,DIK(1)=.01,CIAX=""
 .D ENALL^DIK
 .F  S CIAX=$O(@GBL@("B",CIAX)),CIAY=0 Q:'$L(CIAX)  D
 ..F  S CIAY=$O(@GBL@("B",CIAX,CIAY)) Q:'CIAY  D
 ...S CIAZ=$P(@GBL@(CIAY,0),U),CIAY1=0
 ...F  S CIAY1=$O(@GBL@("B",CIAX,CIAY1)) Q:'CIAY1  D:CIAY'=CIAY1
 ....Q:$P(@GBL@(CIAY1,0),U)'=CIAZ
 ....K DIK,DA
 ....S DIK=OPN,DA=CIAY1
 ....D ^DIK
 Q
 ; Save local settings for object registry and create new categories
SAVEREG ; EP
 N NAM,CAT,IEN,SUB
 D MES("Saving local object registry settings...")
 S NAM=""
 F  S NAM=$O(@XPDGREF@("PTRS",19930.221,NAM)) Q:'$L(NAM)  D
 .S IEN=$$PRGID^CIAVMCFG(NAM)
 .I IEN F SUB=2,3,5 D
 ..Q:$D(@XPDGREF@("OVERWRITE",NAM,SUB))
 ..M @XPDGREF@("REGSAVE",NAM,SUB)=^CIAVOBJ(19930.2,IEN,SUB)
 D MES("Creating new object categories...")
 F  S NAM=$O(@XPDGREF@("PTRS",19930.206,NAM)),CAT="" Q:'$L(NAM)  D
 .F  S CAT=$O(@XPDGREF@("PTRS",19930.206,NAM,CAT)) Q:'$L(CAT)  D
 ..Q:$$FIND1^DIC(19930.21,,"X",CAT)
 ..N FDA
 ..S FDA(19930.21,"+1,",.01)=CAT
 ..D UPDATE^DIE("E","FDA")
 Q
 ; Restore local settings for object registry
RESTREG ; EP
 N NAM,IEN,SUB
 D MES("Restoring local object registry settings...")
 S NAM=""
 F  S NAM=$O(@XPDGREF@("REGSAVE",NAM)) Q:'$L(NAM)  D
 .S IEN=$$PRGID^CIAVMCFG(NAM),SUB=0
 .I IEN F  S SUB=$O(@XPDGREF@("REGSAVE",NAM,SUB)) Q:'SUB  D
 ..K ^CIAVOBJ(19930.2,IEN,SUB)
 ..M ^CIAVOBJ(19930.2,IEN,SUB)=@XPDGREF@("REGSAVE",NAM,SUB)
 Q
 ; Save ITEM and RPC entries for CIAV VUECENTRIC option
SAVEOPT N OPT
 S OPT=$$FIND1^DIC(19,"","X","CIAV VUECENTRIC")
 Q:'OPT
 M @XPDGREF@("ITMSAVE")=^DIC(19,OPT,10,"B")
 M @XPDGREF@("RPCSAVE")=^DIC(19,OPT,"RPC","B")
 Q
 ; Restore ITEM and RPC entries for CIAV VUECENTRIC
RESTOPT N OPT,ITM,RPC
 S OPT=$$FIND1^DIC(19,"","X","CIAV VUECENTRIC")
 Q:'OPT
 F ITM=0:0 S ITM=$O(@XPDGREF@("ITMSAVE",ITM)) Q:'ITM  I $$REGCTX^CIAURPC(ITM,OPT)
 F RPC=0:0 S RPC=$O(@XPDGREF@("RPCSAVE",RPC)) Q:'RPC  I $$REGRPC^CIAURPC(RPC,OPT)
 Q
 ; Resolve pointers in multiples (KIDS doesn't)
RESPTR ; EP
 N TGT,SRC,SUB,NOD,NAM,VAL,IEN,CNT,SGB,PTR
 S SUB=0
 F  S SUB=$O(@XPDGREF@("PTRS",SUB)) Q:'SUB  S X=^(SUB)  D
 .S NOD=+X,SRC=$P(X,U,2),TGT=$P(X,U,3),SGB=$$ROOT^DILFD(SRC,,1),NAM=""
 .F  S NAM=$O(@XPDGREF@("PTRS",SUB,NAM)) Q:'$L(NAM)  D
 ..S IEN=$$FIND1^DIC(SRC,"","QX",NAM),VAL="",CNT=0
 ..Q:IEN'>0
 ..K @SGB@(IEN,NOD)
 ..F  S VAL=$O(@XPDGREF@("PTRS",SUB,NAM,VAL)) Q:'$L(VAL)  D
 ...S PTR=$$FIND1^DIC(TGT,,"X",VAL)
 ...I 'PTR D MES("  Failed to resolve "_VAL) Q
 ...S CNT=CNT+1,@SGB@(IEN,NOD,CNT,0)=PTR,@SGB@(IEN,NOD,"B",PTR,CNT)=""
 ..S:CNT @SGB@(IEN,NOD,0)=U_SUB_"P^"_CNT_U_CNT
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
 ; Install routine binaries
OBJINST ; EP
 N MSYS,RTN,OBJ,SUB,GBL
 D GETMSYS(.MSYS,.VER)
 Q:'$D(MSYS)
 Q:$D(@XPDGREF@("OBJ",MSYS(0)))<10
 S RTN=""
 D MES("Installing routine binaries...")
 F  S RTN=$O(@XPDGREF@("OBJ",MSYS(0),VER,RTN)) Q:'$L(RTN)  D
 .X "ZR  ZS @RTN"
 .S OBJ="",SUB=0,GBL=$NA(@$S(MSYS(0)=1:"^rOBJ(RTN)",1:"^$R(RTN,""OBJECT"")"))
 .F  S SUB=$O(@XPDGREF@("OBJ",MSYS(0),VER,RTN,SUB)) Q:'SUB  S OBJ=OBJ_^(SUB,0)
 .S @GBL=$S(MSYS(0)=1:$$DECODE^CIAUUU(OBJ),1:OBJ)
 Q
 ; Send mail message confirming VueCentric installation
MMSG Q:'$$PATCH^XPDUTL("XM*7.1*50")
 N SUBJ,RECP,GBL
 S GBL=$$TMPGBL^CIAVMRPC
 S SUBJ="VueCentric Installation at "_$G(^XMB("NETNAME"))
 S @GBL@(1)="VueCentric has just been installed at: "_$G(^XMB("NETNAME"))_"."
 S @GBL@(2)="Version #: "_$P($T(+2),";",3)
 S @GBL@(3)="Installer: "_$P($G(^VA(200,+$G(DUZ),0)),U)
 S RECP("mail@ciainformatics.com")=""
 D SENDMSG^XMXAPI(DUZ,SUBJ,GBL,.RECP)
 K @GBL
 Q
