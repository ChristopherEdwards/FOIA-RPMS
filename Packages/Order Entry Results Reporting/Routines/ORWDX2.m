ORWDX2 ; SLC/JM/AGP - Order dialog utilities ;20-Jun-2014 09:43;DU
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**246,243,1013**;Dec 17, 1997;Build 242
 ;Per VHA Directive 2004-038, this routine should not be modified.
 ;IHS/MSC/MGH Modified XROOT for ICD codes for ICD-10 Patch 1013
 ;
 Q
 ;
NXT() ; -- Gets index in array
 S ILST=ILST+1
 Q ILST
 ;
EXTVAL(IVAL,DLG) ; External value given a dlg ptr
 N ORDIALOG
 S ORDIALOG(DLG,0)=$P($G(^ORD(101.41,DLG,1)),U,1,2)
 S ORDIALOG(DLG,1)=IVAL
 I $E(ORDIALOG(DLG,0))="R",(+IVAL'=IVAL) Q IVAL  ; free text date/time
 Q $$EXT^ORCD(DLG,1)  ; all others
 ;
XROOT ; Part of LOADRSP^ORWDX - moved here because of routine size
 N CHKDOSE,DOSE,INSTR,SAVCLIN,SAVSNO
 S SAVCLIN="",SAVSNO=""
 S (ILST,I)=0,CHKDOSE=$$CHKDOSES
 S CNT=0
 F  S I=$O(@ROOT@(I)) Q:I'>0  D
 . S DLG=$P(@ROOT@(I,0),U,2),INST=$P(^(0),U,3)
 . Q:'DLG
 . S ID=$P($G(^ORD(101.41,DLG,1)),U,3)
 . I '$L(ID) S ID="ID"_DLG
 . S VAL=$G(@ROOT@(I,1))
 . S CNT=CNT+1
 . I $P($G(^ORD(101.41,DLG,0)),U)="OR GTX ADDITIVE" S ID="ADDITIVE"
 . I $E(RSPID)="C",(ID="START"),VAL Q  ; skip literal start time on copy
 . I $P($G(^ORD(101.41,DLG,0)),U)="OR GTX CLININD2" S SAVCLIN="~"_DLG_U_INST_U_ID Q   ;IHS/MSC/MGH Patch 1013
 . S LST($$NXT)="~"_DLG_U_INST_U_ID
 . I $L(VAL) D
 .. S LST($$NXT)="i"_VAL,LST($$NXT)="e"_$$EXTVAL(VAL,DLG)
 .. I CHKDOSE D DOSEINFO
 . I $P($G(^ORD(101.41,DLG,0)),U)="OR GTX SNMDCNPTID" S SAVSNO=VAL  ;IHS/MSC/MGH Patch 1013
 . I $D(@ROOT@(I,2))>1 D
 .. I $E(RSPID)?1U,'$G(TRANS),ID="COMMENT",'$$DRAFT(RSPID) D FORMID^ORWDX(.X,+$E(RSPID,2,99)) Q:X=140
 .. S J=0 F  S J=$O(@ROOT@(I,2,J)) Q:J'>0  D
 ... S LST($$NXT)="t"_$G(@ROOT@(I,2,J,0))
 ;IHS/MSC/MGH Patch 1013 changes
 I SAVSNO'="" D
 .S ^TMP("MGH","SNO")=SAVSNO
 .S VAL=$P($$CONC^BSTSAPI(SAVSNO_"^^^1"),U,5)
 .I SAVCLIN="" D
 ..S DLG=$O(^ORD(101.41,"B","OR GTX CLININD2",""))
 ..S ID=$P($G(^ORD(101.41,DLG,1)),U,3)
 ..S INST=1
 ..S LST($$NXT)="~"_DLG_U_INST_U_ID
 .E  S LST($$NXT)=SAVCLIN
 .S LST($$NXT)="i"_VAL,LST($$NXT)="e"_VAL
 ;END MOD
 I CHKDOSE D FIXDOSES
 I $E(ROOT,1,4)="^TMP" K ^TMP("ORWDXMQ",$J)
 Q
 ;
DRAFT(ID) ; -- Return 1 or 0 if editing an unsigned/unreleased or pending order
 N IEN,STS,ES
 I $E(ID)?1U,$E(ID)'="X" Q 0
 S IEN=$S(ID:+ID,1:+$E(ID,2,99))
 S STS=$P($G(^OR(100,IEN,3)),U,3),ES=$P($G(^(8,1,0)),U,4)
 I STS=5 Q 1
 I STS=11 Q 1
 I STS=10,ES=2 Q 1
 Q 0
 ;
CHKDOSES() ; Returns true if doses may need to be modified
 Q $$PATCH^XPDUTL("PSS*1.0*78")&($T(DOSE^PSSORUTE)'="")
 ;
DOSEINFO ; Collect pointers to dose information
 I ID="INSTR" S INSTR(INST)=ILST-1
 I ID="DOSE",+VAL>0 S DOSE(INST)=ILST-1 ; +VAL filters out local dosages
 Q
 ;
FIXDOSES ; Update doses for those saved before PSS*1*78 was installed
 N CODE,OLDDOSE,IDX,NEWDOSE,IIDX
 S IIDX=0
 F  S IIDX=$O(INSTR(IIDX)) Q:'+IIDX  D
 . I +$G(INSTR(IIDX))>0,+$G(DOSE(IIDX))>0 D
 .. S OLDDOSE=$E(LST(INSTR(IIDX)),2,999)
 .. S NEWDOSE=$$DOSE^PSSORUTE(OLDDOSE)
 .. I OLDDOSE'=NEWDOSE D
 ... F IDX=0:1:1 D
 .... S CODE=$E(LST(INSTR(IIDX)+IDX),1)
 .... S LST(INSTR(IIDX)+IDX)=CODE_NEWDOSE
 .. S OLDDOSE=$P(LST(DOSE(IIDX)),"&",5)
 .. S NEWDOSE=$$DOSE^PSSORUTE(OLDDOSE)
 .. I OLDDOSE'=NEWDOSE D
 ... F IDX=0:1:1 D
 .... S $P(LST(DOSE(IIDX)+IDX),"&",5)=NEWDOSE
 Q
 ;
DCREASON(LST) ; Return a list of DC reasons
 N ARRAY,CNT,ERROR,IEN,ILST,NAME,SEQARR,X
 S ILST=1,LST(ILST)="~DCReason"
 S IEN=0 F  S IEN=$O(^ORD(100.03,IEN)) Q:'IEN  S X=^(IEN,0) D
 . I $P(X,U,4) Q                              ; inactive
 . I $P(X,U,5)'=+$O(^DIC(9.4,"C","OR",0)) Q   ; not OR pkg
 . I $P(X,U,7)=+$O(^ORD(100.02,"C","A",0)) Q  ; nature=auto
 . S ARRAY($P(X,U))="i"_IEN_U_$P(X,U)
 D GETLST^XPAR(.SEQARR,"SYS","OR DC REASON LIST","Q",.ERROR)
 ;S CNT=0 F  S CNT=$O(SEQARR(CNT)) Q:CNT'>0  D
 F CNT=1:1:SEQARR D
 . S IEN=$P(SEQARR(CNT),U,2),NAME=$P(^ORD(100.03,IEN,0),U)
 . S ILST=ILST+1,LST(ILST)="i"_IEN_U_NAME
 . I $D(ARRAY(NAME))>0 K ARRAY(NAME)
 I $D(ARRAY)'>0 Q
 S NAME="" F  S NAME=$O(ARRAY(NAME)) Q:NAME=""  D
 .S ILST=ILST+1,LST(ILST)=ARRAY(NAME)
 Q
