BEHUTIL ;MSC/IND/DKM - General Purpose Utilities ;25-Nov-2007 10:49;DKM
 ;;1.2;BEH UTILITIES;**1**;Mar 20, 2007
 ;=================================================================
 ; Display required header for menus
TITLE(PKG,VER) ;EP
 Q:$E($G(IOST),1,2)'="C-"
 N X,%ZIS,IORVON,IORVOFF,MNU
 S MNU=$P(XQY0,U,2),VER="Version "_$G(VER,1.1),PKG=$G(PKG,"RPMS-EHR Management")
 S X="IORVON;IORVOFF"
 D ENDR^%ZISS
 U IO
 W @IOF,IORVON,$$GET1^DIQ(4,DUZ(2),.01),?(IOM-$L(PKG)\2),PKG,?(IOM-$L(VER)),VER,!,IORVOFF,?(IOM-$L(MNU)\2-$X),MNU
 Q
 ; Pause for user response
PAUSE ;EP
 N X
 R !!,"Press ENTER or RETURN to continue...",X:$G(DTIME,300),!
 Q
 ; Edit a parameter from a menu option
EDITPAR(PARAM) ;EP
 S PARAM=$G(PARAM,$P(XQY0,U))
 D TITLE(),EDITPAR^XPAREDIT(PARAM):$$CHECK(8989.51,PARAM,"Parameter")
 Q
 ; Edit a parameter template from a menu option
EDITTMPL(TMPL) ;EP
 S TMPL=$G(TMPL,$P(XQY0,U))
 D TITLE(),TEDH^XPAREDIT(TMPL,"BA"):$$CHECK(8989.52,TMPL,"Parameter template")
 Q
 ; Edit a security key assignment
EDITKEY(KEY) ;EP
 N USR,X,%,XQKEYT,XQPROV,XQFDA,XQIEN
 S KEY=$G(KEY,$P(XQY0,U)),KEY(0)=$$FIND1^DIC(19.1,,"X",KEY)
 I 'KEY(0) D  Q
 .W !,"Key ",KEY," was not found.",!
 .R "Press ENTER to continue...",X:DTIME,!
 F  D  Q:USR'>0
 .D TITLE()
 .W !!!,KEY," Key Management",!
 .S USR=$$LOOKUP(200,"Select a user for key assignment")
 .Q:USR'>0
 .I $D(^XUSEC(KEY,USR)) D
 ..W !,"This user already has the ",KEY," key.",!
 ..S X=$$ASK^CIAU("Do you wish to remove the key assignment","N")
 ..Q:X'>0
 ..I $$DEL^XQKEY(USR,KEY(0))
 ..K ^XUSEC(KEY,USR)
 .E  D
 ..W !,"This user does not currently have the ",KEY," key.",!
 ..S X=$$ASK^CIAU("Do you wish to assign this key to the selected user","N")
 ..Q:X'>0
 ..I $$ADD^XQKEY(USR,KEY(0))
 ..S ^XUSEC(KEY,USR)=""
 Q
 ; Execute an option
EXECOPT(OPT,PAUSE) ;EP
 S:OPT'=+OPT OPT=+$$FIND1^DIC(19,,"X",OPT)
 D EO(20),EO(25),EO(15),PAUSE:$G(PAUSE)
 Q
 ; Check to make sure entry exists
CHECK(FIL,VAL,ENT) ;
 Q:$$FIND1^DIC(FIL,,"X",VAL) 1
 W !,ENT," ",VAL," was not found.",!
 D PAUSE
 Q 0
EO(NODE) ;
 N X
 S X=$G(^DIC(19,OPT,NODE))
 Q:'$L(X)
 S:NODE=25 X="D "_$S(X[U:"",1:U)_X
 X X
 Q
 ; Rename a file entry
RENENTRY(FIL,OLD,NEW) ;PEP - Rename file entry
 N IEN,FDA
 Q:$$FIND1^DIC(FIL,,"X",NEW)
 S IEN=$$FIND1^DIC(FIL,,"X",OLD)
 Q:'IEN
 S FDA(FIL,IEN_",",.01)=NEW
 D FILE^DIE("E","FDA")
 Q
 ; Rename a parameter
 ; Renames the parameter definition and the associated package for
 ; any package-associated instances.
 ;   OLD = Old parameter name
 ;   NEW = New parameter name
RENPARAM(OLD,NEW) ;EP
 N DEFIEN,PARIEN,OLDPKG,NEWPKG,INST,FDA
 D RENENTRY(8989.51,OLD,NEW)
 S DEFIEN=$$FIND1^DIC(8989.51,,"XQ",NEW)
 S OLDPKG=$$PARAMPKG(OLD)
 S NEWPKG=$$PARAMPKG(NEW)
 Q:'DEFIEN!'OLDPKG!'NEWPKG
 S INST=""
 F  S INST=$O(^XTV(8989.5,"AC",DEFIEN,OLDPKG,INST)),PARIEN=0 Q:'$L(INST)  D
 .F  S PARIEN=$O(^XTV(8989.5,"AC",DEFIEN,OLDPKG,INST,PARIEN)) Q:'PARIEN  D
 ..S FDA(8989.5,PARIEN_",",.01)=NEWPKG
 D:$D(FDA) FILE^DIE(,"FDA")
 Q
 ; Return package reference from param name
PARAMPKG(PARAM) ;
 N PKG
 S PKG=PARAM
 F  S PKG=$O(^DIC(9.4,"C",PKG),-1) Q:$E(PARAM,1,$L(PKG))=PKG
 S:$L(PKG) PKG=$O(^DIC(9.4,"C",PKG,0))
 Q $S(PKG:PKG_";DIC(9.4,",1:"")
 ; Register a submenu under parent menu
REGMENU(MNU,SEQ,SYN,PAR) ;PEP - Register submenu
 N FDA,ITM
 S MNU=$$FIND1^DIC(19,,"BX",MNU),PAR=$$FIND1^DIC(19,,"BX",$G(PAR,"BEHOMENU")),SEQ=+$G(SEQ)
 Q:'MNU!'PAR
 S ITM=$O(^DIC(19,PAR,10,"B",MNU,0))
 S:'ITM ITM="+1"
 S FDA=$NA(FDA(19.01,ITM_","_PAR_","))
 S @FDA@(.01)=MNU,@FDA@(2)=SYN,@FDA@(3)=$S(SEQ<1:"@",SEQ>99:99,1:SEQ)
 D UPDATE^DIE("","FDA")
 Q
 ; Lookup an entry in file #FN using prompt PM.
LOOKUP(FN,PM,FL,SC) ;EP
 Q:'FN -1
 N DIC,DLAYGO,X,Y
 W !
 F FL=''$G(FL):-1:0 D
 .S DIC=FN,DIC(0)=$S(FL:"E",1:"AE"),DIC("A")=PM_": ",X="??"
 .S:$L($G(SC)) DIC("S")=SC
 .D ^DIC
 W !
 Q $S(Y>0:+Y,1:0)
