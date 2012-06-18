BGOUTL2 ; IHS/BAO/TMD - Utilities (continued)  ;03-Dec-2009 10:35;MGH
 ;;1.1;BGO COMPONENTS;**1,3,5,6**;Mar 20, 2007
 ; Add refusals to output stream
 ;  R ^ Refusal IEN [2] ^ Type IEN [3] ^ Type Name [4] ^ Item IEN [5] ^ Item Name [6] ^ Provider IEN [7] ^
 ;  Provider Name [8] ^ Date [9] ^ Locked [10] ^ Reason [11] ^ Comment [12]
REFGET(RET,DFN,FNUM,CNT) ;EP
 N TYPE,VDT,RIEN,REC,TYPNM,DATE,REASON,COMMENT,PRV,PRVNM
 S TYPE=0,CNT=+$G(CNT)
 S:$G(RET)="" RET=$$TMPGBL^BGOUTL
 F  S TYPE=$O(^AUPNPREF("AA",DFN,FNUM,TYPE)) Q:'TYPE  D
 .S VDT=0
 .F  S VDT=$O(^AUPNPREF("AA",DFN,FNUM,TYPE,VDT)) Q:'VDT  D
 ..S RIEN=0
 ..F  S RIEN=$O(^AUPNPREF("AA",DFN,FNUM,TYPE,VDT,RIEN)) Q:'RIEN  D
 ...S CNT=CNT+1,@RET@(CNT)=$$REFGET1(RIEN)
 Q
 ; Return data for a specified refusal
 ;  R ^ Refusal IEN [2] ^ Type IEN [3] ^ Type Name [4] ^ Item IEN [5] ^ Item Name [6] ^ Provider IEN [7] ^
 ;  Provider Name [8] ^ Date [9] ^ Locked [10] ^ Reason [11] ^ Comment [12]
REFGET1(RIEN) ;EP
 N REC,PRV,COMMENT,TYPE,TYPENM,REASON,DATE,PRVNM,FNUM,ITEM,ITEMNM
 S REC=$G(^AUPNPREF(RIEN,0)),PRV=$P($G(^(12)),U,4),COMMENT=$P($G(^(11)),U)
 Q:REC=""
 S TYPE=+REC
 S TYPENM=$P($G(^AUTTREFT(TYPE,0)),U)
 S DATE=$$FMTDATE^BGOUTL($P(REC,U,3))
 S ITEMNM=$P(REC,U,4)
 S FNUM=$P(REC,U,5)
 S ITEM=$P(REC,U,6)
 S:ITEMNM="" ITEMNM=$$GET1^DIQ(FNUM,ITEM,.01)
 S REASON=$$EXTERNAL^DILFD(9000022,.07,,$P(REC,U,7))
 S PRVNM=$S(PRV:$$GET1^DIQ(200,PRV,.01),1:"")
 Q "R"_U_RIEN_U_TYPE_U_TYPENM_U_ITEM_U_ITEMNM_U_PRV_U_PRVNM_U_DATE_U_$$REFLCK(RIEN)_U_REASON_U_COMMENT
 ; Store a patient refusal (using visit IEN)
REFSET(VIEN,ITEM,TYPE,RSN,CMNT,PRV) ;EP
 N X
 S X=$G(^AUPNVSIT(VIEN,0))
 Q $$REFSET2($P(X,U,5),X\1,ITEM,TYPE,RSN,.CMNT,.PRV)
 ; Store a patient refusal (alternate)
REFSET2(DFN,DAT,ITEM,TYPE,RSN,CMNT,PRV,IEN) ;EP
 N FDA,ERR,FNUM,RET,IENX,OPR,ZN
 S TYPE=$$FIND1^DIC(9999999.73,,"X",TYPE)
 Q:'TYPE $$ERR^BGOUTL(1067)
 S FNUM=$P(^AUTTREFT(TYPE,0),U,2),OPR=1
 S:'$G(IEN) IEN=$O(^AUPNPREF("AA",DFN,FNUM,ITEM,9999999-DAT,0))
 I "@"[RSN Q:'IEN  S TYPE="@",OPR=2
 S:'IEN IEN="+1",OPR=0
 S:OPR=2 ZN=$G(^AUPNPREF(IEN,0))
 S FDA=$NA(FDA(9000022,IEN_","))
 S @FDA@(.01)="`"_TYPE
 S:'OPR @FDA@(.02)="`"_DFN
 S @FDA@(.03)=DAT
 S @FDA@(.04)=$E($$GET1^DIQ(FNUM,ITEM,.01),1,80)
 S @FDA@(.05)=FNUM
 S @FDA@(.06)=ITEM
 S @FDA@(.07)=RSN
 S:$D(CMNT) @FDA@(1101)=CMNT
 S:'$G(PRV) PRV=DUZ
 S @FDA@(1204)="`"_PRV
 S RET=$$UPDATE^BGOUTL(.FDA,"E@",.IENX)
 S:$E(IEN)="+" IEN=$G(IENX(1))
 D:'RET REFEVT(IEN,OPR,.ZN)
 Q RET
 ; Delete a refusal
REFDEL(IEN) ;EP
 N RET,X
 S X=$G(^AUPNPREF(IEN,0))
 Q:'$L(X) ""
 S RET=$$DELETE^BGOUTL("^AUPNPREF(",IEN)
 D:'RET REFEVT(IEN,2,X)
 Q RET
 ; Delete a refusal (alternate)
REFDEL2(VIEN,ITEM,TYPE) ;EP
 N X,FNUM
 S TYPE=$$FIND1^DIC(9999999.73,,"X",TYPE)
 Q:'TYPE $$ERR^BGOUTL(1067)
 S FNUM=$P(^AUTTREFT(TYPE,0),U,2)
 S X=$G(^AUPNVSIT(VIEN,0))
 Q $$REFDEL(+$O(^AUPNPREF("AA",+$P(X,U,5),FNUM,ITEM,9999999-(X\1),0)))
 ; Broadcast a refusal event
REFEVT(IEN,OPR,X) ;EP
 N DFN,TYPE
 S:'$D(X) X=$G(^AUPNPREF(IEN,0))
 S DFN=$P(X,U,2)
 Q:'DFN
 S TYPE=$P($G(^AUTTREFT(+X,0)),U)
 D BRDCAST^CIANBEVT("REFUSAL."_DFN_"."_TYPE,IEN_U_$G(CIA("UID"))_U_OPR)
 Q
 ; Returns true if a refusal is locked against editing
REFLCK(IEN) ;EP
 N DAT,DAYS
 S DAT=+$P($G(^AUPNPREF(IEN,0)),U,3)
 S DAYS=$$GET^XPAR("ALL","BEHOENCX VISIT LOCKED")
 Q $S('DAT:-1,1:$$FMDIFF^XLFDT(DT,DAT)>$S(DAYS<1:1,1:DAYS))
 ; Check for duplicate V File type in a visit
VFCHK(RET,FNUM,TYPE,ENTITY,VIEN) ;EP
 D VFFND(.RET,FNUM,TYPE,VIEN)
 S:RET RET=$$ERR^BGOUTL(1068,ENTITY)_U_RET
 Q
 ; Locate a V File entry
VFFND(RET,FNUM,TYPE,VIEN) ;EP
 N X,GBL
 S GBL=$$ROOT^DILFD(FNUM,,1)
 I '$L(GBL) S RET=$$ERR^BGOUTL(1069) Q
 S X=0,RET=""
 F  S X=$O(@GBL@("AD",VIEN,X)) Q:'X  D  Q:RET
 .S:$P($G(@GBL@(X,0)),U)=TYPE RET=X
 Q
 ; Create root V File entry
 ;  FNUM = File number
 ;  TYPE = Entry type (.01 of V File)
 ;  VIEN = Visit IEN
 ;  NAME = Name of entity (if checking for dups)
 ;  FLDS = Additional field values (optional)
 ; .RET  = IEN of new entry or -1^error text
VFNEW(RET,FNUM,TYPE,VIEN,NAME,FLDS) ;EP
 N FDA,IEN,V0,CAT,APCDVSIT,PXCEVIEN
 S V0=$G(^AUPNVSIT(VIEN,0)),CAT=$P(V0,U,7)
 I $L($G(NAME)),CAT'="H" D VFCHK(.RET,FNUM,TYPE,NAME,VIEN) Q:RET
 I $G(DUZ("AG"))="I" S APCDVSIT=VIEN
 E  S PXCEVIEN=VIEN
 S FDA=$NA(FDA(FNUM,"+1,"))
 S @FDA@(.01)=TYPE
 S @FDA@(.02)=$P(V0,U,5)
 S @FDA@(.03)=VIEN
 S:$D(^DD(FNUM,1201,0)) @FDA@(1201)=$S(CAT="H":$$NOW^XLFDT,1:+V0)
 M @FDA=FLDS
 S RET=$$UPDATE^BGOUTL(.FDA,,.IEN)
 S:'RET RET=IEN(1)
 Q
 ; Delete V File entry
VFDEL(RET,FNUM,VFIEN) ;EP
 N VIEN,GBL,X
 S GBL=$$ROOT^DILFD(FNUM,,1),RET=""
 Q:'VFIEN
 I '$L(GBL) S RET=$$ERR^BGOUTL(1069) Q
 S X=$G(@GBL@(VFIEN,0))
 S VIEN=$P(X,U,3)
 Q:'VIEN
 S RET=$$CHKVISIT^BGOUTL(VIEN)
 S:'RET RET=$$DELETE^BGOUTL(FNUM,VFIEN)
 D:'RET VFEVT(FNUM,VFIEN,2,X)
 Q
 ; Fetch V File entries
 ;  INP = Patient IEN (for entries associated with a patient) [1] ^
 ;        V File IEN (for single entry) [2] ^
 ;        Visit IEN (for entries associated with a visit) [3]
 ;  FNUM= V File #
 ;  FLDS= Fields to retrieve
VFGET(RET,INP,FNUM,FLDS) ;EP
 N VFIEN,VIEN,DFN,GBL,CNT,XREF,X
 S RET=$$TMPGBL^BGOUTL
 S GBL=$$ROOT^DILFD(FNUM,,1)
 I '$L(GBL) S @RET@(1)=$$ERR^BGOUTL(1069) Q
 S CNT=0
 S DFN=+INP
 S VFIEN=$P(INP,U,2)
 S VIEN=$P(INP,U,3)
 I VFIEN D
 .I '$D(@GBL@(VFIEN,0)) S @RET@(1)=$$ERR^BGOUTL(1070)
 .E  D GV1
 E  I VIEN D
 .S VFIEN=0
 .F  S VFIEN=$O(@GBL@("AD",VIEN,VFIEN)) Q:'VFIEN  D GV1
 E  I DFN D
 .S VFIEN="",XREF=$$VFPTXREF   ;P6
 .F  S VFIEN=$O(@GBL@(XREF,DFN,VFIEN),-1) Q:'VFIEN  D GV1
 E  S @RET@(1)=$$ERR^BGOUTL(1008)
 Q
GV1 S X=$$GETREC^BGOUTL(FNUM,VFIEN,FLDS)
 S CNT=CNT+1,@RET@(CNT)=$P(X,U)_U_$$ISLOCKED^BEHOENCX(+$P($G(@GBL@(VFIEN,0)),U,3))_U_$P(X,U,2,9999)
 Q
 ; Fire V file update events
 ;  FNUM  = V File #
 ;  VFIEN = V File IEN
 ;  OPR   = Operation (0 = add, 1 = edit, 2 = delete)
VFEVT(FNUM,VFIEN,OPR,X) ;EP
 N ID,GBL,DFN,VIEN,DATA
 S GBL=$$ROOT^DILFD(FNUM,,1)
 Q:'$L(GBL)
 Q:'$G(VFIEN)  ;P6
 S ID=$P(GBL,"AUPNV",2)
 S:'$D(X) X=$G(@GBL@(VFIEN,0))
 S DFN=$P(X,U,2),VIEN=$P(X,U,3),DATA=VFIEN_U_$G(CIA("UID"))_U_OPR_U_$P(X,U)_U_VIEN
 D:DFN BRDCAST^CIANBEVT("PCC."_DFN_"."_ID,DATA)
 D:VIEN BRDCAST^CIANBEVT("VISIT."_VIEN_"."_ID,DATA)
 D:VIEN VFMOD(VIEN)
 Q
 ; Update the visit modification date
VFMOD(AUPNVSIT) ;EP
 Q:$G(DUZ("AG"))'="I"  ;P6
 N DIE,DA,DR,DIU,DIV
 D MOD^AUPNVSIT
 Q
 ; Returns patient xref for V files
VFPTXREF() ;
 Q $S($G(DUZ("AG"))="I":"AC",1:"C")
 ; Find/create narrative text in narrative file, returning IEN
FNDNARR(NARR,CREATE) ;EP
 N IEN,FDA,TRC,RET
 Q:'$L(NARR) ""
 S IEN=0,TRC=$E(NARR,1,30),NARR=$E(NARR,1,160),CREATE=$G(CREATE,1)
 F  S IEN=$O(^AUTNPOV("B",TRC,IEN)) Q:'IEN  Q:$P($G(^AUTNPOV(IEN,0)),U)=NARR
 Q:IEN!'CREATE IEN
 S FDA(9999999.27,"+1,",.01)=NARR
 S RET=$$UPDATE^BGOUTL(.FDA,"E",.IEN)
 Q $S(RET:RET,1:IEN(1))
 ; Returns true if CSV is active
CSVACT(RTN) ;EP
 Q $S(DUZ("AG")'="I":1,$$VERSION^XPDUTL("BCSV")="":0,'$L($G(RTN)):1,1:$T(+0^@RTN)'="")
