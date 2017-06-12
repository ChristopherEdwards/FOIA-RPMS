BQIRGUT1 ;GDHD/HS/ALA-Register Utility ; 27 Apr 2016  7:40 AM
 ;;2.5;ICARE MANAGEMENT SYSTEM;**1**;May 24, 2016;Build 17
 ;
 ;
ITM(TMFRAME,BQDFN,FREF,RREF,TIEN,TAX,TREF) ;EP - Find the value
 ; Find visits for a request item
 ; Input
 ;   TMFRAME - Time frame to search data for
 ;   BQDFN   - Patient internal entry number
 ;   FREF    - File to search in
 ;   RREF    - Search file table file
 ;   TIEN    - Item to search on
 ;   TAX     - Taxonomy
 ;   TREF    - Reference array
 ;
 NEW GREF,ENDT,IEN,QFL,RESULT,VISIT,VSDTM,RES,DTM,ITIEN,EDT,BDT,VFL
 NEW SRCTYP,BQRES
 S TMFRAME=$G(TMFRAME,"")
 ;I $G(TREF)'="" B
 I $G(TAX)'="" D
 . S TREF=$NA(^TMP($J,"BQITAX")) K @TREF
 . D BLD^BQITUTL(TAX,TREF)
 I $G(TAX)="" D
 . I $G(TIEN)="" Q
 . S TREF="BQITAX" K @TREF
 . S @TREF@(TIEN)=""
 S GREF=$$ROOT^DILFD(FREF,"",1)
 S VFL=$O(^BQI(90508.6,"B",FREF,""))
 I VFL'="" S SRCTYP=$P(^BQI(90508.6,VFL,0),U,3)
 S ENDT=$$DATE^BQIUL1(TMFRAME)
 S IEN="",QFL=0,RESULT=0
 I $G(TMFRAME)'="" D
 . S EDT=9999999-ENDT,BDT=""
 . I SRCTYP'=2 D  Q
 .. F  S BDT=$O(@GREF@("AA",BQDFN,BDT)) Q:BDT=""!(BDT>EDT)  D  Q:QFL
 ... S IEN=""
 ... F  S IEN=$O(@GREF@("AA",BQDFN,BDT,IEN)) Q:IEN=""  D  Q:QFL
 .... S ITIEN=$$GET1^DIQ(FREF,IEN,.01,"I") I ITIEN="" Q
 .... S RES=$$GET1^DIQ(FREF,IEN,.04,"I")
 .... I $G(TIEN)'="",ITIEN'=TIEN Q
 .... I $G(TIEN)="",'$D(@TREF@(ITIEN)) Q
 .... S VISIT=$$GET1^DIQ(FREF,IEN,.03,"I") I VISIT="" Q
 .... I $P($G(^AUPNVSIT(VISIT,0)),"^",11)=1 Q
 .... S VSDTM=$P($G(^AUPNVSIT(VISIT,0)),"^",1)\1 I VSDTM=0 Q
 .... S BQRES(VSDTM,VISIT,IEN)=RES
 . ;
 . F  S BDT=$O(@GREF@("AA",PTDFN,TIEN,BDT)) Q:BDT=""!(BDT>EDT)  D
 .. S IEN=""
 .. F  S IEN=$O(@GREF@("AA",PTDFN,TIEN,BDT,IEN)) Q:IEN=""  D
 ... S ITIEN=$$GET1^DIQ(FREF,IEN,.01,"I") I ITIEN="" Q
 ... S RES=$$GET1^DIQ(FREF,IEN,.04,"I")
 ... I $G(TIEN)'="",ITIEN'=TIEN Q
 ... I $G(TIEN)="",'$D(@TREF@(ITIEN)) Q
 ... S VISIT=$$GET1^DIQ(FREF,IEN,.03,"I") I VISIT="" Q
 ... I $P($G(^AUPNVSIT(VISIT,0)),"^",11)=1 Q
 ... S VSDTM=$P($G(^AUPNVSIT(VISIT,0)),"^",1)\1 I VSDTM=0 Q
 ... S BQRES(VSDTM,VISIT,IEN)=RES
 . ; check for refusal
 . I $O(^AUPNPREF("AA",BQDFN,RREF,""))'="" D
 .. I $D(TREF) S TIEN="" F  S TIEN=$O(@TREF@(TIEN)) Q:TIEN=""  D
 ... S EDT=9999999-ENDT,BDT=""
 ... F  S BDT=$O(^AUPNPREF("AA",BQDFN,RREF,TIEN,BDT)) Q:BDT=""!(BDT>EDT)  D
 .... S IEN="" F  S IEN=$O(^AUPNPREF("AA",BQDFN,RREF,TIEN,BDT,IEN)) Q:IEN=""  D
 ..... S DTM=$P(^AUPNPREF(IEN,0),U,3)
 ..... I $P(RESULT,U,2)'="",DTM<$P(RESULT,U,2) Q
 ..... S BQRES(DTM,"~","~")="refusal"
 ;
 I $G(TMFRAME)="" D
 . S IEN=""
 . F  S IEN=$O(@GREF@("AC",BQDFN,IEN),-1) Q:IEN=""  D  Q:QFL
 .. S ITIEN=$$GET1^DIQ(FREF,IEN,.01,"I") I ITIEN="" Q
 .. I $G(TIEN)'="",ITIEN'=TIEN Q
 .. I $G(TIEN)="",'$D(@TREF@(ITIEN)) Q
 .. S RES=$$GET1^DIQ(FREF,IEN,.04,"I")
 .. S VISIT=$$GET1^DIQ(FREF,IEN,.03,"I") I VISIT="" Q
 .. I $P($G(^AUPNVSIT(VISIT,0)),"^",11)=1 Q
 .. S VSDTM=$P($G(^AUPNVSIT(VISIT,0)),"^",1)\1 I VSDTM=0 Q
 .. S BQRES(VSDTM,VISIT,IEN)=RES
 . ; check for refusal
 . I $O(^AUPNPREF("AA",BQDFN,RREF,""))'="" D
 .. I $D(TREF) S TIEN="" F  S TIEN=$O(@TREF@(TIEN)) Q:TIEN=""  D
 ... ;S EDT=(9999999-DT)+.001,BDT=""
 ... S BDT="",STOP=0
 ... F  S BDT=$O(^AUPNPREF("AA",BQDFN,RREF,TIEN,BDT)) Q:BDT=""  D  Q:STOP
 .... S IEN="" F  S IEN=$O(^AUPNPREF("AA",BQDFN,RREF,TIEN,BDT,IEN)) Q:IEN=""  D  Q:STOP
 ..... S DTM=$P(^AUPNPREF(IEN,0),U,3)
 ..... I $P(RESULT,U,2)'="",DTM<$P(RESULT,U,2) Q
 ..... S BQRES(DTM,"~","~")="refusal"
 ;
 I '$D(BQRES) S RESULT=0
 I $D(BQRES) D
 . S DTM=$O(BQRES(""),-1),VISIT=$O(BQRES(DTM,""),-1),IEN=$O(BQRES(DTM,VISIT,""),-1)
 . S RES=BQRES(DTM,VISIT,IEN)
 . S RESULT=1_U_DTM_U_U_VISIT_U_IEN_U_RES
 Q RESULT
