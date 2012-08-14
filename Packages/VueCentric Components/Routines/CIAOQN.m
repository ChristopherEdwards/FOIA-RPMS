CIAOQN ;MSC/IND/PLS - TIU QUICK NOTES ;04-May-2006 08:19;DKM
 ;;1.1;VUECENTRIC COMPONENTS;**010002**;12-Aug-2004 22:06
 ;;Copyright 2000-2006, Medsphere Systems Corporation
 ;=================================================================
 ; Quick Note management API
MANAGE(DATA,ACTION,NAME,VAL,ENT) ;
 N ENT1
 S ENT1=$S(ENT="DIV":+DUZ(2)_";DIC(4,",1:+DUZ_";VA(200,")
 S DATA=$$VALIDATE(.NAME,ACTION="C",.ENT)
 Q:DATA
 I ACTION="C" D SETLST(.DATA,NAME) Q
 I ACTION="R" D RENLST(.DATA,NAME,.VAL) Q
 I ACTION="S" D SETLST(.DATA,NAME,.VAL) Q
 I ACTION="D" D DELLST(.DATA,NAME) Q
 S DATA="-1^Unknown action"
 Q
 ; Validate Quick Note Name
VALIDATE(NAME,DUP,ENT) ;
 N L
 S NAME=$$TRIM^CIAU(NAME),L=$L(NAME),DUP=+$G(DUP)
 Q:L<3!(L>30) "-1^Quick Note name must be 3-30 characters in length."
 Q:NAME'?.(1A,1N,1"_",1" ",1"-",1"(",1")") "-1^Quick Note name contains invalid characters."
 I DUP,$$GETIEN(NAME) Q "-1^Quick Note name already exists."
 I 'DUP,'$$GETIEN(NAME) Q "-1^Quick Note name not found."
 Q ""
 ; Rename existing Quick Note
 ;  OLD  - Existing Instance name (aka Quick Note name)
 ;  NEW  - New Quick Name name
RENLST(DATA,OLD,NEW) ;
 S DATA=$$VALIDATE(NEW,1)
 D:'DATA REP^XPAR(ENT,$$PARAM,$$GETNAME(OLD),NEW,.DATA)
 D:'DATA CHG^XPAR(ENT,$$PARAM,NEW,NEW,.DATA)
 Q
 ; Set Quick Note
SETLST(DATA,NAME,VAL) ;
 Q:'$L(NAME)
 S:NAME=+NAME NAME=$$GETNAME(NAME)
 S VAL=NAME
 S:$D(VAL)'=11 VAL(1,0)=""
 D EN^XPAR(ENT,$$PARAM,NAME,.VAL,.DATA)
 Q
 ; Delete Quick Note
 ;   NAME - Quick Note Name
DELLST(DATA,NAME) ;
 D DEL^XPAR(ENT,$$PARAM,$$GETNAME(NAME),.DATA)
 Q
 ; Return parameter name/ien
PARAM(X) Q $S($G(X):$$FIND1^DIC(8989.51,,"X",$$PARAM),1:"CIAOQN QNOTES")
 ; Return IEN to file 8989.5
GETIEN(NAME) ;
 Q $S(NAME=+NAME:NAME,1:$O(^XTV(8989.5,"AC",$$PARAM(1),ENT1,NAME,0)))
 ; Returns instance name for 8989.5 IEN
GETNAME(IEN) ;
 Q $S(IEN=+IEN:$$GET1^DIQ(8989.5,IEN_",",.03),1:IEN)
 ;
 ; Return TIU Template Node
 ; Input: TIEN - IEN to ^TIU(8927
GETTEMPL(DATA,TIEN) ;
 S DATA=""
 S:'TIEN TIEN=$O(^TIU(8927,"B",TIEN,0))
 Q:'TIEN
 S DATA=$$NODEDATA^TIUSRVT(TIEN)
 Q
 ; Returns 1 if template selection allowed
TMPLSCRN(NODE) ;
 I $P(NODE,U,3)="G"!($P(NODE,U,3)="T") Q 1
 Q 0
 ; Return Class for given Document Title
GETDOCCL(DATA,DIEN) ;
 S DATA=""
 S:'DIEN DIEN=$O(^TIU(8925.1,"B",DIEN,0))
 Q:'DIEN
 S DATA=$$DOCCLASS^TIULC1(DIEN)
 Q
 ; Returns available New Person entries for CoSigner
GCSIGLST(DATA,FROM,DIR,TITLE,AUTHOR,DATE) ;EP
 N I,IEN,CNT
 S I=0,CNT=44,DATE=$G(DATE)
 F  Q:I'<CNT  S FROM=$O(^VA(200,"B",FROM),DIR) Q:FROM=""  D
 .S IEN="" F  S IEN=$O(^VA(200,"B",FROM,IEN),DIR) Q:'IEN  D
 ..I $$VCOSIG(IEN,TITLE,DATE) D
 ...S I=I+1,DATA(I)=IEN_U_FROM
 Q
 ; Returns flag indicating the availability of the new person to cosign note
VCOSIG(NPIEN,TITLEIEN,ACTDATE) ;EP
 N VAL
 S VAL=1
 I ACTDATE>0,$$GET^XUA4A72(NPIEN,DATE)<1 D
 .S VAL=0
 E  D
 .; A non-Provider may NOT be selected
 .I +$$PROVIDER^TIUPXAP1(NPIEN,DT)'>0 S VAL=0
 .; Others who require Cosignature may NOT be selected
 .E  I +$$REQCOSIG^TIULP(TITLEIEN,0,NPIEN) S VAL=0
 .; Author may NOT be selected
 .E  I NPIEN=AUTHOR S VAL=0
 Q VAL
 ; Return need for cosignature
REQCOS(DATA,TIUTYP,TIUSER) ; EP
 S DATA=$$REQCOSIG^TIULP(TIUTYP,0,+$G(TIUSER))
 Q
