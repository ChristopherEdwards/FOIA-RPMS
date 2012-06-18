BEHORXFM ;IHS/MSC/PLS - Med Component print layout support;13-Oct-2011 16:53;PLS
 ;;1.1;BEH COMPONENTS;**009007**;Mar 20, 2007;Build 1
 ;=================================================================
 ; Return list of templates
GETLIST(DATA,TYPE) ;EP-
 N CNT,IEN
 S TYPE=$G(TYPE)
 S DATA=$$TMPGBL()
 S (CNT,IEN)=0
 F  S IEN=$O(^BEHORX(90460.07,IEN)) Q:'IEN  D
 .Q:TYPE'=""&($P(^BEHORX(90460.07,IEN,0),U,2)'=TYPE)
 .S CNT=CNT+1,@DATA@(CNT)=^(0)
 Q
 ; Return template data
GETTEMPL(DATA,TMPL) ;
 ;TODO - Add flag and check for active status
 S DATA=$$TMPGBL
 S:TMPL'=+TMPL TMPL=$$TMPL(TMPL)
 M:TMPL @DATA=^BEHORX(90460.07,TMPL,1)
 K @DATA@(0)
 Q
 ; Set template data
 ; TMPL- Name of template
 ;  CNT- Line count of template data
 ;   IN- Input array of field data
 ;       Examples: IN(.02)="PC"
 ;  VAL- (1,0) array of template data
 ;
SETTEMPL(DATA,TMPL,CNT,IN,VAL) ;
 N X,Y,Z
 S DATA=$$TMPL(.TMPL,.Z)
 I 'DATA,CNT D
 .L +^BEHORX(90460.07,0):5
 .E  Q
 .S DATA=$O(^BEHORX(90460.07,$C(1)),-1)+1,$P(^(0),U,3,4)=DATA_U_($P(^(0),U,4)+1),^(DATA,0)=TMPL,^BEHORX(90460.07,"B",Z,DATA)=""
 .L -^BEHORX(90460.07,0)
 Q:'DATA
 L +^BEHORX(90460.07,DATA):5
 E  S DATA=0 Q
 I 'CNT D
 .D TMPLDEL(TMPL)
 E  D
 .D WP^DIE(90460.07,DATA_",",1,,"VAL")
 .S:$L($G(IN(.02))) $P(^BEHORX(90460.07,+DATA,0),U,2)=IN(.02)
 .S:$L($G(IN(.03))) $P(^BEHORX(90460.07,+DATA,0),U,3)=$P(IN(.03),".")
 L -^BEHORX(90460.07,DATA)
 Q
 ; Mark a template inactive and remove all associations
TMPLDEL(TMPL) ;
 N ENT
 D TMPLPAR(.ENT,.TMPL)
 S ENT=""
 F  S ENT=$O(ENT(ENT)) Q:'$L(ENT)  D
 .D DEL^XPAR(ENT,"BEHORX PRINT FORMATS",$P(^BEHORX(90460.07,TMPL,0),U,2))
 S $P(^BEHORX(90460.07,TMPL,0),U,4)=DT
 Q
 ; Get parameters associated with a template
 ; Return format is DATA(<entity>,1)=<template IEN>
TMPLPAR(DATA,TMPL) ;
 N X,INT
 K DATA
 S:TMPL'=+TMPL TMPL=$$TMPL(TMPL)
 Q:'TMPL
 S INT=$P(^BEHORX(90460.07,TMPL,0),U,2)
 D ENVAL^XPAR(.DATA,"BEHORX PRINT FORMATS",INT)
 S X=""
 F  S X=$O(DATA(X)) Q:'$L(X)  D:$G(DATA(X,INT))'=TMPL
 .K DATA(X)
 .S DATA=DATA-1
 Q
 ; Convert template name to IEN
TMPL(X,Y) ;
 Q $$GETIEN(90460.07,.X,.Y)
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
 ..S TRC=$E(VAL,1,50)
 ..F  S RTN=+$O(@GBL@("B",TRC,RTN)) Q:'RTN  Q:$P($G(@GBL@(RTN,0)),U)=VAL
 Q RTN
 ; Return temp global reference
TMPGBL() N GBL
 S GBL=$NA(^TMP("BEHORXFM",$J))
 K @GBL
 Q GBL
 ; Return selectable instance types
INSTTYP() ;
 Q "PC:RX CII;PN:RX NON-CII;OC:ORDER CII;ON:ORDER NON-CII;RC:RECEIPT CII;RN:RECEIPT NON-CII;LC:LABEL CII;LN:LABEL NON-CII"
 ; Screen logic for value field of BEHORX PRINT FORMATS parameter
SCRNPF(INST) ;EP-
 Q $P(^(0),U,2)=INST&('$P(^(0),U,4))&($P(^(0),U,3))&($P(^(0),U,3)'>DT)
 ;
