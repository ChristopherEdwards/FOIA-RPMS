BQICAUTL ;VNGT/HS/ALA-Utility for CA ; 29 Mar 2011  4:49 PM
 ;;2.3;ICARE MANAGEMENT SYSTEM;;Apr 18, 2012;Build 59
 ;
TAX(TMFRAME,TAX,NIT,PTDFN,FREF,PRB,SAME,TREF) ;EP
 ; Find value for a taxonomy (TAX) or list of taxonomies (TREF)
 ; Input
 ;   TMFRAME - Timeframe to search for data
 ;   TAX     - Taxonomy
 ;   NIT     - Number of iterations
 ;   PTDFN   - Patient IEN
 ;   FREF    - File number reference
 ;   PRB     - If Active Problem okay
 ;   SAME    - If NIT is allowed for the same 30 days or not (1 same 30 days okay)
 ;   TREF    - Multiple same resulting taxonomies (e.g. MEDs) built
 ;             into reference (usually global)
 ;
 NEW RESULT,GREF,ENDT,IEN,TIEN,TEMP,QFL
 S TMFRAME=$G(TMFRAME,""),NIT=$G(NIT,1),PRB=$G(PRB,0),SAME=$G(SAME,1)
 S ENDT=$$DATE^BQIUL1(TMFRAME),RESULT=0,TREF=$G(TREF,""),TAX=$G(TAX,"")
 I TAX'="" D
 . S TREF=$NA(^TMP("BQITAX",UID))
 . K @TREF
 . D BLD^BQITUTL(TAX,TREF)
 S GREF=$$ROOT^DILFD(FREF,"",1)
 S TEMP=$NA(^TMP("BQITEMP",UID)) K @TEMP
 ;
 I PRB D
 . S IEN="",QFL=0,RESULT=0
 . F  S IEN=$O(^AUPNPROB("AC",PTDFN,IEN),-1) Q:IEN=""  D  Q:QFL
 .. S TIEN=$$GET1^DIQ(9000011,IEN,.01,"I") I TIEN="" Q
 .. I '$D(@TREF@(TIEN)) Q
 .. ;  Check class - if Family ignore
 .. I $$GET1^DIQ(9000011,IEN,.04,"I")="F" Q
 .. I $$GET1^DIQ(9000011,IEN,.12,"I")'="A" Q
 .. S VSDTM=$$PROB^BQIUL1(IEN)\1 Q:VSDTM=0
 .. I $G(TMFRAME)'="",VSDTM<ENDT Q
 .. S RESULT=1_U_VSDTM,$P(RESULT,U,4)=IEN,QFL=1
 ;
 I 'RESULT D
 . S IEN="",QFL=0,RESULT=0,CT=0
 . I $G(TMFRAME)'="" D
 .. S EDT=9999999-ENDT,BDT=""
 .. F  S BDT=$O(@GREF@("AA",PTDFN,BDT)) Q:BDT=""!(BDT>EDT)  D
 ... S IEN=""
 ... F  S IEN=$O(@GREF@("AA",PTDFN,BDT,IEN)) Q:IEN=""  D
 .... S TIEN=$$GET1^DIQ(FREF,IEN,.01,"I") I TIEN="" Q
 .... I '$D(@TREF@(TIEN)) Q
 .... S VISIT=$$GET1^DIQ(FREF,IEN,.03,"I") I VISIT="" Q
 .... I $$GET1^DIQ(9000010,VISIT,.11,"I")=1 Q
 .... S VSDTM=$$GET1^DIQ(9000010,VISIT,.01,"I")\1 Q:VSDTM=0
 .... ;I $G(TMFRAME)'="",VSDTM<ENDT Q
 .... ; Set temporary
 .... S @TEMP@(VSDTM,VISIT,IEN)=""
 . ;
 . I $G(TMFRAME)="" D
 .. F  S IEN=$O(@GREF@("AC",PTDFN,IEN),-1) Q:IEN=""  D
 ... S TIEN=$$GET1^DIQ(FREF,IEN,.01,"I") I TIEN="" Q
 ... I '$D(@TREF@(TIEN)) Q
 ... S VISIT=$$GET1^DIQ(FREF,IEN,.03,"I") I VISIT="" Q
 ... I $$GET1^DIQ(9000010,VISIT,.11,"I")=1 Q
 ... S VSDTM=$$GET1^DIQ(9000010,VISIT,.01,"I")\1 Q:VSDTM=0
 ... ;I $G(TMFRAME)'="",VSDTM<ENDT Q
 ... ; Set temporary
 ... S @TEMP@(VSDTM,VISIT,IEN)=""
 ;
 S VSDTM="",QFL=0
 F  S VSDTM=$O(@TEMP@(VSDTM),-1) Q:VSDTM=""!(QFL)  D
 . S VISIT=""
 . F  S VISIT=$O(@TEMP@(VSDTM,VISIT),-1) Q:VISIT=""  D  Q:QFL
 .. S IEN=""
 .. F  S IEN=$O(@TEMP@(VSDTM,VISIT,IEN),-1) Q:IEN=""  D  Q:QFL
 ... ; If result cannot be within 30 days, quit
 ... I 'SAME,$P(RESULT,U,2)=VSDTM Q
 ... S CT=CT+1
 ... I $P(RESULT,U,2)'="",(CT'>NIT) D
 .... I VSDTM'<STDT,'SAME S CT=CT-1 Q
 .... S $P(RESULT,U,2)=$P(RESULT,U,2)_";"_VSDTM
 .... S $P(RESULT,U,4)=$P(RESULT,U,4)_";"_VISIT
 .... S $P(RESULT,U,5)=$P(RESULT,U,5)_";"_IEN
 ... I $P(RESULT,U,2)="" S $P(RESULT,U,2)=VSDTM,$P(RESULT,U,4)=VISIT_U_IEN
 ... ;S $P(RESULT,U,4)=VISIT_U_IEN,CT=CT+1
 ... ;S RESULT=U_VSDTM_U_U_VISIT_U_IEN,CT=CT+1
 ... I CT=NIT S QFL=1,$P(RESULT,U,1)=1
 K @TREF
 Q RESULT
 ;
MEAS(BQDFN,MEAS,VISIT,RESVAL,OPER) ;EP - Get measurement
 I MEAS'?.N S MEAS=$$FIND1^DIC(9999999.07,,"MX",MEAS)
 S VALUE=0
 S VDATE=$P(^AUPNVSIT(VISIT,0),U,1)\1
 S RVDT=9999999-VDATE
 S IEN=""
 F  S IEN=$O(^AUPNVMSR("AA",BQDFN,MEAS,RVDT,IEN)) Q:IEN=""  D
 . S RESULT=$P($G(^AUPNVMSR(IEN,0)),"^",4) I RESULT="" Q
 . I @(RESULT_OPER_RESVAL) S VALUE="1^"_VDATE_U_RESULT_U_VISIT_U_IEN_U_"9000010.01"
 Q VALUE
 ;
MIC(BQDFN,TIEN,EDT,BDT,MICRO) ;EP - Look through Microbiology file
 F  S BDT=$O(^AUPNVMIC("AA",BQDFN,TIEN,BDT)) Q:BDT=""!(BDT>EDT)  D
 . S LIEN=""
 . F  S LIEN=$O(^AUPNVMIC("AA",BQDFN,TIEN,BDT,LIEN)) Q:LIEN=""  D
 .. S VALUE=$P(^AUPNVMIC(LIEN,0),U,7) I VALUE="" Q
 .. S VIEN=$P(^AUPNVMIC(LIEN,0),U,3) I VIEN="" Q
 .. S VSDTM=$$GET1^DIQ(9000010,VIEN_",",.01,"I")\1 I VSDTM=0 Q
 .. ; quit if deleted flag
 .. I $P($G(^AUPNVSIT(VIEN,0)),U,11)=1 Q
 .. I $P($G(^AUPNVMIC(LIEN,11)),U,9)="D" Q
 .. S MICRO(VSDTM,VIEN,LIEN)=VALUE
 Q
