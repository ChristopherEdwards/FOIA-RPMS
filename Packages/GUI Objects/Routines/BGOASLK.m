BGOASLK ; IHS/MSC/MGH - FHL - PROGRAM TO GET LIST OF DIAGNOSES ;03-Feb-2010 11:28;PLS
 ;;1.1;BGO COMPONENTS;**6**;Mar 20, 2007
 ;---------------------------------------------------------------
CHECK(CODE) ;EP see if the icd code entered is an asthma code
 N X,TAX,LOW,HIGH,ICD,NODE
 S X=0
 I DUZ("AG")'="I" Q X
 S CODE=$$ICDDX^ICDCODE(CODE)
 S CODE=$P(CODE,U,2)
 S TAX="" S TAX=$O(^ATXAX("B","BGP ASTHMA DXS",TAX))
 Q:TAX=""
 S ICD=0 F  S ICD=$O(^ATXAX(TAX,21,ICD)) Q:ICD=""!(ICD?1.2A)  D
 .S NODE=$G(^ATXAX(TAX,21,ICD,0))
 .S LOW=$P(NODE,U,1),HIGH=$P(NODE,U,2)
 .I (CODE'<LOW)&(CODE'>HIGH) S X=1
 Q X
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
 ;INP=DX [1] ^ Classification [2]
DICLASS(RET,INP) ;EP Get the classifications for an asthma DX
 N CNT,VAL,TYPE,CLASS,CTYPE,ICD,ASTHMA
 S ICD=$P(INP,U,1)
 S ASTHMA=$$CHECK^BGOASLK(ICD)
 K RET
 I ASTHMA=0 S RET="" Q
 S CNT=0
 S TYPE=$O(^APCDPLCL("B",$P(INP,U,2),"")) Q:TYPE=""  D
 .S CLASS=0 F  S CLASS=$O(^APCDPLCL(TYPE,11,CLASS)) Q:CLASS=""!(CLASS="B")  D
 ..S CTYPE=$G(^APCDPLCL(TYPE,11,CLASS,0))
 ..I CTYPE'="" S VAL=$P(CTYPE,U,1)_"^"_$P(CTYPE,U,2)
 ..S CNT=CNT+1,RET(CNT)=VAL
 Q
ACONTROL(DFN) ;Find last entry of patient's asthma control
 N LEVEL,DT,IEN
 S LEVEL=""
 I DUZ("AG")'="I" Q LEVEL
 S DT="" S DT=$O(^AUPNVAST("AAC",DFN,DT))
 I DT="" Q LEVEL
 S IEN="" S IEN=$O(^AUPNVAST("AAC",DFN,DT,IEN),-1)  ;Reverse $O if there is more than one on a given date  - p6
 I IEN="" Q LEVEL
 S LEVEL=$G(^AUPNVAST("AAC",DFN,DT,IEN))
 S LEVEL=$S(LEVEL="W":"WELL CONTROLLED",LEVEL="N":"NOT WELL CONTROLLED",LEVEL="V":"VERY POORLY CONTROLLED",1:"")
 Q LEVEL
TMPGBL(X) ;EP
 K ^TMP("BGO"_$G(X),$J) Q $NA(^($J))
FNUM() Q 9000011
