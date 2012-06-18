ORWDRA32 ; SLC/KCM/REV/JDL - Radiology calls to support windows [6/28/02]
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**10,116,141**;Dec 17, 1997
 ;
DEF(LST,PATID,EVTDIV,IMGTYP) ; Get dialog data for radiology
 N ILST,I,X S ILST=0
 S LST($$NXT)="~ShortList"  D SHORT
 S IMGTYP=$$IMTYPE(IMGTYP)
 S LST($$NXT)="~Common Procedures" D COMMPRO
 S LST($$NXT)="~Modifiers" D MODIFYR
 S LST($$NXT)="~Urgencies" D URGENCY
 S LST($$NXT)="~Transport" D TRNSPRT
 S LST($$NXT)="~Category" D CATEGRY
 S LST($$NXT)="~Submit to" D SUBMIT
 S LST($$NXT)="~Last 7 Days" D LAST7
 Q
MODIFYR ; Get the modifiers (should be by imaging type)
 S I=$O(^RA(79.2,"C",IMGTYP,0)) Q:'I
 S X=0 F  S X=$O(^RAMIS(71.2,"AB",I,X)) Q:'X  S LST($$NXT)="i"_X_U_$P(^RAMIS(71.2,X,0),U)
 Q
SHORT ; from DEF, get short list of imaging quick orders
 N I,TMP
 D GETQLST^ORWDXQ(.TMP,IMGTYP,"Q")
 S I=0 F  S I=$O(TMP(I)) Q:'I  D
 . S LST($$NXT)="i"_TMP(I)
 Q
COMMPRO ; Get the common procedures
 S X=""
 F  S X=$O(^ORD(101.43,"COMMON",IMGTYP,X)) Q:X=""  D
 . S I=$O(^ORD(101.43,"COMMON",IMGTYP,X,0))
 . I $$REQDET,$P($G(^ORD(101.43,I,"RA")),U,2)="B" Q
 . S LST($$NXT)="i"_I_U_X_U_U_$$REQAPPR(I)
 Q
URGENCY ; Get the allowable urgencies and default
 S X="",I=0
 F  S X=$O(^ORD(101.42,"S.RA",X)) Q:X=""  D
 . S I=$O(^ORD(101.42,"S.RA",X,0))
 . S LST($$NXT)="i"_I_U_X
 S I=$O(^ORD(101.42,"B","ROUTINE",0))
 S LST($$NXT)="d"_I_U_"ROUTINE"
 Q
TRNSPRT ; Get the modes of transport
 F X="A^AMBULATORY","P^PORTABLE","S^STRETCHER","W^WHEELCHAIR" D
 . S LST($$NXT)="i"_X
 ; figure default on windows side
 Q
CATEGRY ; Get the categories of exam  
 F X="I^INPATIENT","O^OUTPATIENT","E^EMPLOYEE","C^CONTRACT","S^SHARING","R^RESEARCH" D
 . S LST($$NXT)="i"_X
 ; figure default on windows side
 Q
SUBMIT ; Get the locations to which the request may be submitted
 N TMPLST,ASK,X
 D EN4^RAO7PC1(IMGTYP,"TMPLST")
 S I=0 F  S I=$O(TMPLST(I)) Q:'I  S LST($$NXT)="i"_TMPLST(I)
 I $D(TMPLST) S I=$O(TMPLST(0)),X=$P(TMPLST(I),U,1,2),LST($$NXT)="d"_X
 S LST($$NXT)="~Ask Submit"
 I $G(EVTDIV) S X=$$GET^XPAR(+$G(EVTDIV)_";DIC(4,^SYS^PKG","RA SUBMIT PROMPT",1,"Q")
 E  S X=$$GET^XPAR("ALL","RA SUBMIT PROMPT",1,"Q")
 ;S DUZ(2)=TMPDIV
 S ASK=$S($L(X):X,1:1)
 S LST($$NXT)="d"_ASK_U_$S(ASK=1:"YES",ASK=0:"NO",1:"YES")
 Q
LAST7 ; Get exams for the last 7 days
 K ^TMP($J,"RAE7") D EN2^RAO7PC1(PATID)
 S I=0 F  S I=$O(^TMP($J,"RAE7",PATID,I)) Q:'I  D 
 . S LST($$NXT)="i"_I_U_^TMP($J,"RAE7",PATID,I)
 K ^TMP($J,"RAE7")
 Q
PROCMSG(Y,IEN) ; return order message for a procedure
 N I
 S I=0 F  S I=$O(^ORD(101.43,IEN,8,I)) Q:I'>0  S Y(I)=^(I,0)
 Q
NXT() ; Increment index of LST
 S ILST=ILST+1
 Q ILST
RAORDITM(Y,FROM,DIR,IMGTYP) ; Return a subset of orderable items
 ; .Return Array, Starting Text, Direction, Cross Reference (S.xxx)
 N I,IEN,CNT,X,DTXT,REQDET,REQAPPR,XREF S I=0,CNT=44
 S XREF="S."_$$IMTYPE(IMGTYP)
 F  Q:I'<CNT  S FROM=$O(^ORD(101.43,XREF,FROM),DIR) Q:FROM=""  D
 . S IEN=0 F  S IEN=$O(^ORD(101.43,XREF,FROM,IEN)) Q:'IEN  D
 . . I $$REQDET,$P($G(^ORD(101.43,IEN,"RA")),U,2)="B" Q
 . . S X=^ORD(101.43,XREF,FROM,IEN)
 . . I +$P(X,U,3),$P(X,U,3)<DT Q
 . . S I=I+1
 . . I 'X S Y(I)=IEN_U_$P(X,U,2)_U_$P(X,U,2)_U_$$REQAPPR(IEN)
 . . E  S Y(I)=IEN_U_$P(X,U,2)_" <"_$P(X,U,4)_">"_U_$P(X,U,4)_U_$$REQAPPR(IEN)
 Q
REQDET() ; Are "broad" procedures allowed for this division?
 N TMPDIV,RESULT
 S TMPDIV=DUZ(2)
 I $D(EVTDIV),$G(EVTDIV) S DUZ(2)=EVTDIV
 S RESULT=$$GET^XPAR("ALL","RA REQUIRE DETAILED",1,"Q")
 S DUZ(2)=TMPDIV
 Q RESULT
 ;
REQAPPR(IEN) ;  does procedure require radiologist approval?
 N RAIEN
 S RAIEN=$P($P($G(^ORD(101.43,IEN,0)),U,2),";",1)
 I +RAIEN=0 Q ""
 Q $P($G(^RAMIS(71,RAIEN,0)),U,11)
 ;
ISOLATN(Y,DFN) ;Is patient on isolation procedures?
 N ORVP
 S ORVP=DFN_";DPT("
 S Y=$$IP^ORMBLD
 Q
APPROVAL(Y,DUMMY) ; RETURNS LIST OF RADIOLOGISTS WHO MAY APPROVE A
 ;                       PROCEDURE WHEN REQUIRED
 N X,I
 S I="" F  S I=$O(^VA(200,"ARC","S",I)) Q:I=""  D
 . S X=$P($G(^VA(200,I,0)),U)
 . S Y(I)=I_U_X
 Q
IMTYPE(DGRP) ; return the mnemonic for the imaging type
 Q $P(^ORD(100.98,DGRP,0),U,3)
IMTYPSEL(Y,DUMMY) ;return list of active imaging types
 N X,I,IEN,DGRP,MNEM,NAME
 S X=""
 F I=1:1  S X=$O(^RA(79.2,"C",X)) Q:X=""  D
 . I '$D(^ORD(101.43,"S."_X)) Q
 . S IEN=$O(^RA(79.2,"C",X,0))
 . S NAME=$P(^RA(79.2,IEN,0),U,1)
 . S MNEM=$P(^RA(79.2,IEN,0),U,3)
 . S DGRP=$O(^ORD(100.98,"B",MNEM,0))
 . S Y(I)=IEN_U_NAME_U_MNEM_U_DGRP
 Q
RADSRC(Y,SRCTYPE) ; return list of available contract/sharing/research sources
 S X=0
 F I=1:1 S X=$O(^DIC(34,X)) Q:+X=0  D
 . Q:($P(^DIC(34,X,0),U,2)'=SRCTYPE)
 . I $D(^DIC(34,X,"I")),(^DIC(34,X,"I")<$$NOW^XLFDT) Q
 . S Y(I)=I_U_$P(^DIC(34,X,0),U,1)
 Q
LOCTYPE(Y,ORLOC) ; Returns type of location (C,W)
 S Y=-1
 Q:$G(ORLOC)=""
 S Y=$P($G(^SC(+$G(ORLOC),0)),U,3)
 Q
