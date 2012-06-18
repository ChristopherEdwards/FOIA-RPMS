BEHOENP1 ;MSC/IND/DKM - Retrieve PCC data for a visit ;02-Feb-2010 15:19;MGH
 ;;1.1;BEH COMPONENTS;**005002,005004**;Sep 18, 2007
 ;=================================================================
 ; RPC: Return PCC data for an associated visit
LOAD(DATA,DFN,VIEN) ;EP
 N VSTR,LOC,VTYP,ICNT,ICOM,X0
 Q:VIEN'>0
 S VSTR=$$VIS2VSTR^BEHOENCX(DFN,VIEN)
 Q:'$L(VSTR)
 S VTYP=$P(VSTR,";",3),(ICNT,ICOM)=0
 Q:VTYP="H"
 ; Visit data
 D ADD("HDR"_U_("ID"[VTYP)_U_U_VSTR)
 S X0=^AUPNVSIT(VIEN,0),LOC=+$P(X0,U,22)
 D ADD("VST^DT^"_$P(X0,U))
 D ADD("VST^PT^"_$P(X0,U,5))
 D ADD("VST^HL^"_LOC_"^^"_$P($G(^SC(LOC,0)),U))
 D ADD("VST^PS^0")  ;outpt
 D GET(9000010.06,"PRV")
 D GET(9000010.07,"POV")
 D GET(9000010.18,"CPT")
 D GET(9000010.11,"IMM")
 D GET(9000010.12,"SK")
 D GET(9000010.16,"PED")
 D GET(9000010.23,"HF")
 D GET(9000010.13,"XAM")
 D GET(9000010.15,"TRT")
 D GET(9000010.01,"MSR")
 D GET(120.5,"VIT")
 Q
 ; Fetch V File data
GET(VF,TAG) ;
 N LP,PC
 S PC=$S(VF=120.5:3,1:1)
 S VF=$$ROOT^DILFD(VF,,1)
 Q:'$L(VF)
 S LP=0
 F  S LP=$O(@VF@("AD",VIEN,LP)) Q:'LP  D
 .N X,CODE,CMNT,PRV,CAT
 .M X=@VF@(LP)
 .Q:$P(X(0),U,2)'=DFN
 .S CODE=$P(X(0),U,PC),CMNT=$G(X(811)),PRV=$P($G(X(12)),U,4),CAT=$P($G(X(802)),U)
 .S CAT=$S(CAT:$P(^AUTNPOV(CAT,0),U),1:"")
 .D @TAG
 Q
 ; V PROVIDER
 ; PRV^ien^^^name^primary/secondary flag
PRV N NARR,PRIM
 S NARR=$P($G(^VA(200,CODE,0)),U)
 S PRIM=($P(X(0),U,4)="P")
 D ADD(TAG_U_CODE_"^^^"_NARR_U_PRIM)
 Q
 ; V POV
 ; POV^ien^CAT^narrative^com^prv^primary
POV N NARR,PRIM
 S:CODE CODE=$P(^ICD9(CODE,0),U)
 S NARR=$P(X(0),U,4)
 S:NARR NARR=$P(^AUTNPOV(NARR,0),U)
 S PRIM=$P(X(0),U,12)="P"
 D ADD(TAG_U_CODE_U_CAT_U_NARR_U_U_PRV_U_PRIM,CMNT)
 Q
 ; V CPT
 ; CPT^ien^cat^nar^com^prv^qty^mods
CPT N NARR,QTY,MCNT,MIDX,MODS
 S CODE=$O(^ICPT("B",CODE,0))
 S:CODE CODE=$P(^ICPT(CODE,0),U)
 S NARR=$P(X(0),U,4)
 S:NARR NARR=$P(^AUTNPOV(NARR,0),U)
 S QTY=$P(X(0),U,16)
 S MCNT=0,MIDX=0,MODS=""
 F  S MIDX=$O(X(1,MIDX)) Q:'MIDX  D
 .S MIEN=X(1,MIDX,0)
 .S:MIEN MCNT=MCNT+1,MODS=MODS_";/"_MIEN
 S:MCNT MODS=MCNT_MODS
 D ADD(TAG_U_CODE_U_CAT_U_NARR_U_U_PRV_U_QTY_U_MODS,CMNT)
 Q
 ; V IMMUNIZATION
 ; IMM^ien^cat^nar^com^prv^Series^Reaction^Contraindicated^Refused^LotNum^Site^Volume^VISDate
IMM N NARR,QTY,REF
 S:CODE NARR=$P(^AUTTIMM(CODE,0),U)
 S QTY=$P(X(0),U,4)
 S REF=$$REFUSAL(9999999.14,CODE,LP)
 D ADD(TAG_U_CODE_U_CAT_U_NARR_U_U_PRV_U_QTY_U_$P(X(0),U,6)_U_$P(X(0),U,7)_U_REF_U_$P(X(0),U,5)_U_$P(X(0),U,9)_U_$P(X(0),U,11)_U_$P(X(0),U,12),CMNT)
 Q
 ; V SKIN TEST
 ; SK^ien^cat^nar^com^prv^Result^Reading^D/T read^D/T given^Read by^Refused
SK N NARR,QTY,REF
 S:CODE NARR=$P(^AUTTSK(CODE,0),U)
 S QTY=$P(X(0),U,4)
 S REF=$$REFUSAL(9999999.28,CODE,LP)
 ;IHS/MSC/MGH added $G for missing entry date/time
 D ADD(TAG_U_CODE_U_CAT_U_NARR_U_U_PRV_U_QTY_U_$P(X(0),U,5)_U_$P(X(0),U,6)_U_$P($G(X(12)),U)_U_$P(X(0),U,8)_U_REF,CMNT)
 Q
 ; V PATIENT ED
 ; PED^ien^cat^nar^com^prv^Level of understanding^Refused^Elapsed^Setting^Goals^Outcome
PED N NARR,QTY,REF
 S:CODE NARR=$P(^AUTTEDT(CODE,0),U)
 S QTY=$P(X(0),U,6)
 S REF=$$REFUSAL(9999999.09,CODE,LP)
 D ADD(TAG_U_CODE_U_CAT_U_NARR_U_U_PRV_U_QTY_U_REF_U_$P(X(0),U,8)_U_$P(X(0),U,7)_U_$P(X(0),U,13)_U_$P(X(0),U,14),CMNT)
 Q
 ; V HEALTH FACTOR
 ; HF^ien^cat^nar^com^prv^Level/severity
HF N NARR,QTY
 S:CODE NARR=$P(^AUTTHF(CODE,0),U)
 S QTY=$P(X(0),U,4)
 D ADD(TAG_U_CODE_U_CAT_U_NARR_U_U_PRV_U_QTY,CMNT)
 Q
 ; V EXAM
 ; XAM^ien^cat^nar^com^prv^Result^Refused
XAM N NARR,QTY,REF
 S:CODE NARR=$P(^AUTTEXAM(CODE,0),U)
 S QTY=$P(X(0),U,4)
 S REF=$$REFUSAL(9999999.15,CODE,LP)
 D ADD(TAG_U_CODE_U_CAT_U_NARR_U_U_PRV_U_QTY_U_REF,CMNT)
 Q
 ; V TREATMENT
 ; TRT^ien^cat^nar^com^prv^qty
TRT N QTY,NARR
 S QTY=$P(X(0),U,4)
 S NARR=$P(X(0),U,6)
 S:NARR NARR=$P(^AUTNPOV(NARR,0),U)
 D ADD(TAG_U_CODE_U_CAT_U_NARR_U_U_PRV_U_QTY,CMNT)
 Q
 ; V MEASUREMENT
MSR N NARR,VAL
 S:CODE NARR=$P(^AUTTMSR(CODE,0),U)
 S VAL=$P(X(0),U,4)
 D ADD(TAG_U_CODE_U_CAT_U_$G(NARR)_U_U_PRV_U_VAL)
 Q
 ; GMRV VITAL MEASUREMENT
VIT N NARR,VAL
 S:CODE NARR=$P(^GMRD(120.51,CODE,0),U,7)
 S VAL=$P(X(0),U,8)
 D ADD("MSR^"_CODE_U_CAT_U_$G(NARR)_U_U_PRV_U_VAL)
 Q
 ; Add to return array
ADD(X,C) S:$L($G(C)) ICOM=ICOM+1,$P(X,U,5)=ICOM
 S ICNT=ICNT+1,@DATA@(ICNT)=X
 D:$L($G(C)) ADD("COM"_U_ICOM_U_C)
 Q
 ; Look for a refusal of specified type
 ;  FNUM = File # of PCC type file
 ;  CODE = IEN in PCC type file
 ;  VISIT= IEN in visit file
 ; .IEN  = Returned IEN of entry in refusal file (or 0 if none)
 ;  Returns internal value of refusal reason or null
REFUSAL(FNUM,CODE,VISIT,IEN) ;EP
 N DAT,DFN,X
 S X=$G(^AUPNVSIT(VISIT,0)),DAT=X\1,DFN=$P(X,U,5),IEN=0
 I FNUM,CODE,DAT,DFN D
 .S IEN=$O(^AUPNPREF("AA",DFN,FNUM,CODE,9999999-DAT,0))
 Q:$Q $S(IEN:$P($G(^AUPNPREF(IEN,0)),U,7),1:"")
 Q
 ; RPC: Return the default values for an immunization
 ;  IMM = IEN in IMMUNIZATION file
 ;  Returns:
 ;    VIS Date^Volume^Lot #
IMMDFLTS(DATA,IMM) ;EP
 N X,VOL
 S X=$G(^AUTTIMM(+$G(IMM),0))
 S $P(DATA,U)=$P(X,U,13)
 ;S $P(DATA,U,2)=$P(X,U,18)
 ;IHS/MSC/MGH modified to add leading zeros
 S VOL=$P(X,U,18) I $E(VOL,1,1)="." S VOL="0"_VOL
 S $P(DATA,U,2)=VOL
 S $P(DATA,U,3)=$$GET1^DIQ(9999999.41,+$P(X,U,4),.01)
 Q
 ; Lot # screen
IMMLOTSC(LOT,IMM) ;EP
 N X,I
 S X=$G(^AUTTIML(+LOT,0))
 Q:'$L(X)!$P(X,U,3) 0
 F I=4:1:8 I $P(X,U,I)=IMM S I=-1 Q
 Q $S(I=-1:1,1:0)
