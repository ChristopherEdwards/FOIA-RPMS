BQICMUT1 ;GDIT/HS/ALA-Care Mgmt Utility ; 11 Jun 2014  11:19 AM
 ;;2.5;ICARE MANAGEMENT SYSTEM;;May 24, 2016;Build 27
 ;
 ;
TAX(TMFRAME,TAX,PTDFN,FREF,SAME,TREF,START,END,RESULT) ;EP
 ; Return all values for a taxonomy (TAX) or list of taxonomies (TREF)
 ; Input
 ;   TMFRAME - Timeframe to search for data
 ;   TAX     - Taxonomy (if singular taxonomy)
 ;   PTDFN   - Patient IEN
 ;   FREF    - File number reference
 ;   SAME    - If NIT is allowed for the same day or not (1 same day okay)
 ;   TREF    - Multiple same resulting taxonomies (e.g. MEDs) built
 ;             into reference (usually global)
 ;   START   - Starting Date
 ;   END     - Ending Date
 ;
 NEW GREF,ENDT,IEN,TIEN,TEMP,QFL,SRCTYP,VFL,VALUE
 K RESULT
 S TMFRAME=$G(TMFRAME,""),SAME=$G(SAME,1)
 S TREF=$G(TREF,""),TAX=$G(TAX,"")
 S START=$G(START,""),END=$G(END,"")
 I $G(TMFRAME)'="" S ENDT=$$DATE^BQIUL1(TMFRAME),BDT=""
 I $G(START)'=""!($G(END)'="") S ENDT=START,BDT=(9999999-END)-.001
 I $G(UID)="" S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 I TAX'="" D
 . S TREF=$NA(^TMP("BQITAX",UID))
 . K @TREF
 . D BLD^BQITUTL(TAX,TREF)
 S GREF=$$ROOT^DILFD(FREF,"",1)
 S TEMP=$NA(^TMP("BQITEMP",UID)) K @TEMP
 ;
 S IEN="",QFL=0,CT=0
 D
 . I $G(TMFRAME)="",$G(START)="",$G(END)="" Q
 . S VFL=$O(^BQI(90508.6,"B",FREF,""))
 . I VFL'="" S SRCTYP=$P(^BQI(90508.6,VFL,0),U,3)
 . S EDT=9999999-ENDT
 . I SRCTYP'=2 D  Q
 .. F  S BDT=$O(@GREF@("AA",PTDFN,BDT)) Q:BDT=""!(BDT>EDT)  D
 ... S IEN=""
 ... F  S IEN=$O(@GREF@("AA",PTDFN,BDT,IEN)) Q:IEN=""  D
 .... S TIEN=$$GET1^DIQ(FREF,IEN,.01,"I") I TIEN="" Q
 .... I '$D(@TREF@(TIEN)) Q
 .... S VISIT=$$GET1^DIQ(FREF,IEN,.03,"I") I VISIT="" Q
 .... I $$GET1^DIQ(9000010,VISIT,.11,"I")=1 Q
 .... S VSDTM=$$GET1^DIQ(9000010,VISIT,.01,"I")\1 Q:VSDTM=0
 .... ;I $G(TMFRAME)'="",VSDTM<ENDT Q
 .... S VALUE=$$GET1^DIQ(FREF,IEN,.04,"E")
 .... ; Set temporary
 .... S @TEMP@(VSDTM,VISIT,IEN)=VALUE
 . S TIEN=""
 . F  S TIEN=$O(@TREF@(TIEN)) Q:TIEN=""  D
 .. I $G(TMFRAME)'="" S ENDT=$$DATE^BQIUL1(TMFRAME),BDT=""
 .. I $G(START)'=""!($G(END)'="") S ENDT=START,BDT=(9999999-END)-.001
 .. F  S BDT=$O(@GREF@("AA",PTDFN,TIEN,BDT)) Q:BDT=""!(BDT>EDT)  D
 ... S IEN=""
 ... F  S IEN=$O(@GREF@("AA",PTDFN,TIEN,BDT,IEN)) Q:IEN=""  D
 .... S VISIT=$$GET1^DIQ(FREF,IEN,.03,"I") I VISIT="" Q
 .... I $$GET1^DIQ(9000010,VISIT,.11,"I")=1 Q
 .... S VSDTM=$$GET1^DIQ(9000010,VISIT,.01,"I")\1 Q:VSDTM=0
 .... S VALUE=$$GET1^DIQ(FREF,IEN,.04,"E")
 .... S @TEMP@(VSDTM,VISIT,IEN)=VALUE
 ;
 I $G(TMFRAME)="" D
 . I $G(START)'="",$G(END)'="" Q
 . F  S IEN=$O(@GREF@("AC",PTDFN,IEN),-1) Q:IEN=""  D
 .. S TIEN=$$GET1^DIQ(FREF,IEN,.01,"I") I TIEN="" Q
 .. I '$D(@TREF@(TIEN)) Q
 .. S VISIT=$$GET1^DIQ(FREF,IEN,.03,"I") I VISIT="" Q
 .. I $$GET1^DIQ(9000010,VISIT,.11,"I")=1 Q
 .. S VSDTM=$$GET1^DIQ(9000010,VISIT,.01,"I")\1 Q:VSDTM=0
 .. ;I $G(TMFRAME)'="",VSDTM<ENDT Q
 .. S VALUE=$$GET1^DIQ(FREF,IEN,.04,"E")
 .. ; Set temporary
 .. S @TEMP@(VSDTM,VISIT,IEN)=VALUE
 ;
 S VSDTM="",QFL=0
 F  S VSDTM=$O(@TEMP@(VSDTM),-1) Q:VSDTM=""!(QFL)  D
 . S VISIT=""
 . F  S VISIT=$O(@TEMP@(VSDTM,VISIT),-1) Q:VISIT=""  D  Q:QFL
 .. S IEN=""
 .. F  S IEN=$O(@TEMP@(VSDTM,VISIT,IEN),-1) Q:IEN=""  D  Q:QFL
 ... ; If result cannot be on the same day, quit
 ... I 'SAME,$P(RESULT,U,2)=VSDTM Q
 ... S VALUE=@TEMP@(VSDTM,VISIT,IEN)
 ... S CT=CT+1
 ... S RESULT(CT)=VSDTM_U_VISIT_U_IEN_U_VALUE
 S RESULT(0)=CT
 K @TREF
 Q
