CIAOINIT ;MSC/IND/DKM - VueCentric Component KIDS support ;26-May-2006 18:19;DKM
 ;;1.1;VUECENTRIC COMPONENTS;;Oct 06, 2004
 ;;Copyright 2000-2006, Medsphere Systems Corporation
 ;=================================================================
 ; Environment check
EC I $G(XPDENV)=1 D
 .N X
 .F X="XPI1","XPO1","XPZ1" S XPDDIQ(X)=0
 .S XPDNOQUE=1
 X $G(@XPDGREF@("EC"))
 D OBJCHK^CIAVINIT
 Q
 ; Generic preinit
PRE D OBJINST^CIAVINIT,INITIAL^CIAVINIT,RENPRGID^CIAVINIT,SAVEREG^CIAVINIT
 Q
 ; Generic postinit
POST D HOME^%ZIS
 X ^%ZOSF("EON"),^%ZOSF("TRMOFF")
 D RESPTR^CIAVINIT,RESTREG^CIAVINIT,REGNMSP,DEFPAR^CIAVINIT,FINAL^CIAVINIT
 Q
 ; Register namespaces
REGNMSP N X
 F X="CIAV","CIAO","BEHO" D REGNMSP^CIAURPC(X,"CIAV VUECENTRIC")
 Q
 ; Check for presence of package or patch
 ;     NAME = Patch or package name and version
 ;   ACTION = See CHKCMN entry point
 ;      MSG = Message to display if check fails
CHKDEP(NAME,ACTION,MSG) ; EP
 N OK,PKG,VER,NUM
 S OK=$$BUILD^XPDUTL(NAME)
 Q:OK
 I NAME?1.E1"*"1.E1"*"1.N D
 .S PKG=+$O(^DIC(9.4,"C",$P(NAME,"*"),0)),VER=$P(NAME,"*",2),NUM=$P(NAME,"*",3)
 .S VER=+$O(^DIC(9.4,PKG,22,"B",VER,0)),OK=+$O(^DIC(9.4,PKG,22,VER,"PAH","B",NUM,0))
 .S:'OK MSG=$G(MSG,"Patch "_NAME_" is required before installation can continue.")
 E  D
 .S NUM=$L(NAME," "),VER=$P(NAME," ",NUM),PKG=$P(NAME," ",1,NUM-1)
 .S PKG=$S('$L(PKG):0,1:+$O(^DIC(9.4,"B",PKG,0)))
 .S OK=+$O(^DIC(9.4,PKG,22,"B",VER,0))
 .S:'OK MSG=$G(MSG,"Package "_NAME_" is required before installation can continue.")
 D:'OK CHKCMN(.ACTION,.MSG)
 Q
 ; Check for completed installation
 ;     NAME = Build name
 ;   ACTION = See CHKCMN entry point
 ;      MSG = Message to display if check fails
CHKINS(NAME,ACTION,MSG) ; EP
 N IEN
 S IEN=""
 F  S IEN=$O(^XPD(9.7,"B",NAME,IEN),-1) Q:'IEN  Q:$$GET1^DIQ(9.7,IEN,.02,"I")=3
 D:'IEN CHKCMN(.ACTION,$G(MSG,"Build "_NAME_" must be installed before installation can continue."))
 Q
 ; Display message and set appropriate flags
 ;   ACTION = Action code if check fails
 ;       -2: Don't install build, leave in cache
 ;       -1: Don't install build, remove from cache
 ;        0: Display warning only
 ;        1: Don't install distribution, remove from cache
 ;        2: Don't install distribution, leave in cache (default)
 ;      MSG = Message to display (optional)
CHKCMN(ACTION,MSG) ;
 D:$L($G(MSG)) BMES^XPDUTL(MSG)
 S ACTION=+$G(ACTION,2)
 I ACTION>0 S:$G(XPDABORT)<ACTION XPDABORT=ACTION K XPDQUIT
 E  I ACTION<0 S:'$G(XPDABORT) XPDQUIT=-ACTION
 Q
