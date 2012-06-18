CIAVMCFG ;MSC/IND/DKM - VueCentric Configuration RPC's ;03-Oct-2007 12:47;DKM
 ;;1.1V2;VUECENTRIC FRAMEWORK;;Mar 20, 2007
 ;;Copyright 2000-2006, Medsphere Systems Corporation
 ;=================================================================
 ; Fetch object registry info
GETREG(DATA) ;
 N X,Z,CT,FL,ML,ND,PC,KC,HK,PM,AK,ID,DS,SP,SC,DF
 S SC=";"
 F X=0:1 S Z=$P($T(CTL+X),SC,3,99) Q:'$L(Z)  D
 .S FL($P(Z,SC,2),$P(Z,SC,3))=+Z_SC_$P(Z,SC,4,5)
 S DATA=$$TMPGBL,X=0,CT=0,PM=$$KCHK^XUSRB("XUPROGMODE")
 F  S X=$O(^CIAVOBJ(19930.2,X)),ND="",(KC,HK,AK,DS)=0 Q:'X  D
 .F  S ND=$O(^CIAVOBJ(19930.2,X,ND)),PC="" D  Q:ND=-1
 ..I ND="" S Z="",ND=-1
 ..E  S Z=$G(^CIAVOBJ(19930.2,X,ND))
 ..F  S PC=$O(FL(ND,PC)) Q:PC=""  D
 ...S ID=FL(ND,PC),DF=$P(ID,SC,2),SP=$P(ID,SC,3),ID=+ID,ML=0
 ...I PC D ADDIT(ID,$P(Z,U,PC),SP) Q
 ...F  S ML=$O(^CIAVOBJ(19930.2,X,ND,ML)) Q:'ML  D ADDIT(ID,$G(^(ML,0)),SP)
 Q
 ; Process field value where
 ;   ID = unique id
 ;  VAL = field value
 ;   SP = optional special processing entry point
ADDIT(ID,VAL,SP) ;
 I $G(SP)="" S:$L(VAL)&(VAL'=DF) CT=CT+1,@DATA@(CT)=ID_"="_VAL
 E  D @SP
 Q
 ; CATEGORY multiple
SPCAT D ADDIT(ID,$$GETNAM(19930.21,+VAL))
 Q
 ; USES multiple
SPUSES D ADDIT(ID,$P($G(^CIAVOBJ(19930.2,+VAL,0)),U))
 Q
 ; INITIALIZATION multiple
SPINIT S VAL=$$TRIM^CIAU(VAL)
 S:VAL["=@" VAL=$P(VAL,"=@")_"="_$$GET^XPAR("ALL",$P(VAL,"=@",2,99))
 D ADDIT(ID,VAL)
 Q
 ; Disabled flag
SPDIS S DS=+VAL
 Q
 ; Process ALLKEYS field
SPALL S AK=+VAL
 Q
 ; Check security keys
SPKEY S KC=KC+1,HK=HK+$$HASKEY(VAL)
 Q
 ; Compute accessibility of object
 ;  0 = object enabled
 ;  1 = object disabled
 ;  2 = object access denied
SPACC D ADDIT(ID,$S(DS:1,PM:0,'KC:0,AK:HK<KC*2,1:'HK*2))
 Q
 ; Return true if user has key
HASKEY(KEY) ;
 S:KEY=+KEY KEY=$$LKUP^XPDKEY(KEY)
 Q $S($L(KEY):''$$KCHK^XUSRB(KEY),1:0)
 ; Set security keys for entry in object registry
SETKEYS(DATA,IEN,VALS,BRD) ;
 D SETMULT(3,19930.204)
 Q
 ; Set uses multiple for entry in object registry
SETUSES(DATA,IEN,VALS,BRD) ;
 D SETMULT(9,19930.221)
 Q
 ; Set category multiple for entry in object registry
SETCAT(DATA,IEN,VALS,BRD) ;
 D SETMULT(2,19930.206)
 Q
 ; Set specified multiple field
SETMULT(NODE,SUB) ;
 N VAL,CNT
 S IEN=+IEN,DATA=$D(^CIAVOBJ(19930.2,IEN,0)),VALS="",CNT=0
 Q:'DATA
 L +^CIAVOBJ(19930.2,IEN):5
 E  S DATA=0 Q
 K ^CIAVOBJ(19930.2,IEN,NODE)
 F  S VALS=$O(VALS(VALS)) Q:VALS=""  D
 .S VAL=$G(VALS(VALS),$G(VALS(VALS,0)))
 .S:$L(VAL) VAL=+$S(NODE=3:$$LKUP^XPDKEY(VAL),NODE=9:$$GETIEN(19930.2,VAL),NODE=2:$$GETIEN(19930.21,VAL),1:0)
 .S:VAL>0 CNT=CNT+1,^CIAVOBJ(19930.2,IEN,NODE,CNT,0)=VAL,^CIAVOBJ(19930.2,IEN,NODE,"B",VAL,CNT)=""
 S:CNT ^CIAVOBJ(19930.2,IEN,NODE,0)=U_SUB_"P^"_CNT_U_CNT
 L -^CIAVOBJ(19930.2,IEN)
 D:$G(BRD) BRDCAST^CIANBEVT("REGISTRY.OBJECT","")
 Q
 ; Return template data
GETTEMPL(DATA,TMPL) ;
 S DATA=$$TMPGBL,TMPL=$$TMPL(TMPL)
 M:TMPL @DATA=^CIAVTPL(TMPL,1)
 K @DATA@(0)
 Q
 ; Set template data
SETTEMPL(DATA,TMPL,CNT,VAL) ;
 N X,Y,Z
 S DATA=$$TMPL(.TMPL,.Z)
 I 'DATA,CNT D
 .L +^CIAVTPL(0):5
 .E  Q
 .S DATA=$O(^CIAVTPL($C(1)),-1)+1,$P(^(0),U,3,4)=DATA_U_($P(^(0),U,4)+1),^(DATA,0)=TMPL,^CIAVTPL("B",Z,DATA)=""
 .L -^CIAVTPL(0)
 Q:'DATA
 L +^CIAVTPL(DATA):5
 E  S DATA=0 Q
 I 'CNT D
 .D TMPLDEL(TMPL)
 E  D WP^DIE(19930.3,DATA_",",1,,"VAL"),RENTPL^CIAVINIT(DATA)
 L -^CIAVTPL(DATA)
 D BRDCAST^CIANBEVT("REGISTRY.TEMPLATE","")
 Q
 ; Delete a template and all its associations
TMPLDEL(TMPL) ;
 N DIK,DA,ENT
 D TMPLPAR(.ENT,.TMPL)
 S ENT=""
 F  S ENT=$O(ENT(ENT)) Q:'$L(ENT)  D
 .D DEL^XPAR(ENT,"CIAVM DEFAULT TEMPLATE")
 S DIK="^CIAVTPL(",DA=TMPL
 D ^DIK
 Q
 ; Get parameters associated with a template
 ; Return format is DATA(<entity>,1)=<template IEN>
TMPLPAR(DATA,TMPL) ;
 N X
 K DATA
 S:TMPL'=+TMPL TMPL=$$TMPL(TMPL)
 Q:'TMPL
 D ENVAL^XPAR(.DATA,"CIAVM DEFAULT TEMPLATE")
 S X=""
 F  S X=$O(DATA(X)) Q:'$L(X)  D:$G(DATA(X,1))'=TMPL
 .K DATA(X)
 .S DATA=DATA-1
 Q
 ; Return all template default associations
 ; Return format is DATA(n)=<template name>^<entity type>^<entity external value>^<entity internal value>
TMPLPARX(DATA) ;
 N X,TMP,TMPL,IEN,ENT,TYP,XRF,CNT
 S DATA=$$TMPGBL^CIAVMRPC,TMP="",CNT=0
 F  S TMP=$O(^XTV(8989.518,"C",TMP)) Q:'$L(TMP)  S XRF=$O(^(TMP,0)) D
 .S XRF=$$ROOT^DILFD(XRF)
 .S:$L(XRF) XRF(XRF)=TMP
 D ENVAL^XPAR(.TMP,"CIAVM DEFAULT TEMPLATE")
 S X="",TMP=0
 F  S X=$O(TMP(X)) Q:'$L(X)  D
 .S TMPL=$P($G(^CIAVTPL(+$G(TMP(X,1)),0)),U)
 .S:'$L(TMPL) TMPL="<Deleted Template #"_+$G(TMP(X,1))_">"
 .S IEN=+X,TYP=U_$P(X,";",2),ENT=$P($G(@(TYP_IEN_",0)")),U),TYP=$G(XRF(TYP))
 .S CNT=CNT+1,@DATA@(CNT)=TMPL_U_TYP_U_ENT_U_IEN
 Q
 ; Convert template name to IEN
TMPL(X,Y) ;
 Q $$GETIEN(19930.3,.X,.Y)
 ; Convert object name to IEN
PRGID(X,Y) ;
 Q $$GETIEN(19930.2,.X,.Y)
 ; Convert IEN to .01 value
GETNAM(FNUM,IEN) ;
 Q $P($G(@$$ROOT^DILFD(FNUM,,1)@(IEN,0)),U)
 ; Convert .01 value to IEN
GETIEN(FNUM,VAL,TRC) ;
 N RTN,GBL,PASS
 S GBL=$$ROOT^DILFD(FNUM,,1),RTN=0
 I $L(GBL),$L(VAL),VAL'=+VAL D
 .F PASS=0,1 D  Q:RTN
 ..S:PASS VAL=$$UP^XLFSTR(VAL)
 ..S TRC=$E(VAL,1,30)
 ..F  S RTN=+$O(@GBL@("B",TRC,RTN)) Q:'RTN  Q:$P($G(@GBL@(RTN,0)),U)=VAL
 Q RTN
 ; Return temp global reference
TMPGBL() N GBL
 S GBL=$NA(^TMP("CIAVMCFG",$J))
 K @GBL
 Q GBL
 ; Input transform for CLSID
XFCLSID(X) ;
 S X=$$UP^XLFSTR($TR(X,"{}- "))
 I $L(X)>32 K X Q
 I $L($TR(X,"0123456789ABCDEF")) K X Q
 S X=$$RJ^XLFSTR(X,32,0),X="{"_$E(X,1,8)_"-"_$E(X,9,12)_"-"_$E(X,13,16)_"-"_$E(X,17,20)_"-"_$E(X,21,32)_"}"
 Q
 ; Control info for object registry output
 ; Format is: id;node;piece;dflt;spec
 ;   id    = unique id for data element
 ;   node  = global node for data element
 ;           if -1, processed at end of each record
 ;   piece = piece # within node
 ;           if 0, indicates WP or multiple field
 ;   dflt  = default value
 ;   spec  = entry point for special processing
CTL ;;0;0;1
 ;;1;0;2
 ;;2;0;3
 ;;3;0;4;0
 ;;4;0;5;0
 ;;5;1;1
 ;;6;2;0;;SPCAT
 ;;7;7;9;0
 ;;8;7;1;0
 ;;9;7;2;0
 ;;10;-1;1;0;SPACC
 ;;11;4;0
 ;;12;5;0;;SPINIT
 ;;13;6;0
 ;;14;7;5;0
 ;;15;9;0;;SPUSES
 ;;16;7;6;0
 ;;17;7;7;0
 ;;18;7;8;0
 ;;19;.5;1
 ;;20;7;10;0
 ;;21;0;6
 ;;97;7;3;;SPDIS
 ;;98;7;4;;SPALL
 ;;99;3;0;;SPKEY
 ;;
