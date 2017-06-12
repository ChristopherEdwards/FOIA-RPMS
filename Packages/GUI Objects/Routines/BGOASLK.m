BGOASLK ; IHS/MSC/MGH - ASTHMA FILE ;12-Apr-2016 04:34;MGH
 ;;1.1;BGO COMPONENTS;**6,10,12,13,19,20**;Mar 20, 2007;Build 2
 ;---------------------------------------------------------------
CHKASM(RET,CODE,SNOMED) ;RPC to see if its a SNOMED code
 N X
 S CODE=$G(CODE),SNOMED=$G(SNOMED)
 S X=$$CHECK(CODE,SNOMED)
 S RET=X
 Q
CHECK(CODE,SNOMED) ;EP see if the icd code entered is an asthma code
 N X,X1,TAX,LOW,HIGH,ICD,NODE,IN,OUT
 S CODE=$G(CODE),SNOMED=$G(SNOMED)
 S X=0,X1=0
 I DUZ("AG")'="I" Q X
 I SNOMED'="" D
 .S OUT="ARR"
 .S IN=SNOMED_"^EHR IPL ASTHMA DXS^^1"
 .S X=$$VALSBTRM^BSTSAPI(.OUT,.IN)
 .I +X S X1=$G(@OUT) ; ISC/DKA
 I +X1=0 D
 .;IHS/MSC/MGH Patch 12
 .S X=0
 .Q:CODE=""
 .;Patch 20 changed lookup to use standard for taxonomies
 .S TAX="" S TAX=$O(^ATXAX("B","BGP ASTHMA DXS",TAX))
 .Q:TAX=""
 .S CODE=$P($$ICDDX^ICDEX(CODE,$$NOW^XLFDT,"","E"),U,1)
 .S X1=$$ICD^ATXAPI(CODE,TAX,9)
 .;S ICD=0 F  S ICD=$O(^ATXAX(TAX,21,ICD)) Q:ICD=""!(ICD?1.2A)  D
 .;.S NODE=$G(^ATXAX(TAX,21,ICD,0))
 .;.S LOW=$P(NODE,U,1),HIGH=$P(NODE,U,2)
 .;.;EHR patch 18 changed to accomodate non-numeric codes
 .;.I +CODE=0 D
 .;..I (CODE=LOW)!(CODE=HIGH) S X1=1
 .;.E  I (CODE'<LOW)&(CODE'>HIGH) S X1=1
 Q X1
 ;Set the classification for an asthma diagnosis
 ;INP=  IEN of problem [1] ^ Classification[2]
CLASS(RET,INP) ;EP to set the classification of an asthma dx
 N PIEN,CLASS,FNUM,IENS,FDA
 S PIEN=$P(INP,U,1)
 Q:PIEN=""
 S CLASS=$P(INP,U,2)
 S FNUM=$$FNUM,RET=""
 S IENS=PIEN_","
 S FDA=$NA(FDA(FNUM,IENS))
 S @FDA@(.15)=CLASS
 S RET=$$UPDATE^BGOUTL(.FDA,,.IEN)
 Q:RET
 S:'RET RET=PIEN
 Q
 ;Get the classification for an asthma diagnosis
 ;INP=DX [1] ^ SNOMED [2] ^Classification [2]
DICLASS(RET,INP) ;EP Get the classifications for an asthma DX
 N CNT,VAL,TYPE,CLASS,CTYPE,ICD,ASTHMA,SNO
 S ICD=$P(INP,U,1)
 S SNO=$P(INP,U,2)
 S ASTHMA=$$CHECK^BGOASLK(ICD,SNO)
 K RET
 I ASTHMA=0 S RET="" Q
 S CNT=0
 S TYPE=$O(^APCDPLCL("B",$P(INP,U,3),"")) Q:TYPE=""  D
 .S CLASS=0 F  S CLASS=$O(^APCDPLCL(TYPE,11,CLASS)) Q:CLASS=""!(CLASS="B")  D
 ..S CTYPE=$G(^APCDPLCL(TYPE,11,CLASS,0))
 ..I CTYPE'="" S VAL=$P(CTYPE,U,1)_"^"_$P(CTYPE,U,2)
 ..S CNT=CNT+1,RET(CNT)=VAL
 Q
ACONTROL(DFN,VST) ;Find last entry of patient's asthma control
 ;IHS/MSC/MGH Patch 10 modified to loop through IENs on visit
 N LEVEL,DT,IEN
 S LEVEL=""
 I DUZ("AG")'="I" Q LEVEL
 S IEN="" F  S IEN=$O(^AUPNVAST("AD",VST,IEN),-1) Q:IEN=""!(LEVEL'="")  D
 .S LEVEL=$P($G(^AUPNVAST(IEN,0)),U,14)
 .I LEVEL'="" D
 ..S LEVEL=$S(LEVEL="W":"WELL CONTROLLED",LEVEL="N":"NOT WELL CONTROLLED",LEVEL="V":"VERY POORLY CONTROLLED",1:"")
 ..S LEVEL=LEVEL_U_IEN
 Q LEVEL
TMPGBL(X) ;EP
 K ^TMP("BGO"_$G(X),$J) Q $NA(^($J))
FNUM() Q 9000011
