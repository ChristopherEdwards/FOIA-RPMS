BQITRUTL ;PRXM/HC/ALA-Treatment Prompts Utilities ; 18 May 2007  12:40 PM
 ;;2.5;ICARE MANAGEMENT SYSTEM;**1**;May 24, 2016;Build 17
 ;
BP(TMFRAME,BQDFN,SYS,DIA,OPER) ;EP 
 ;NonER blood pressures
 ;
 ; Input
 ;   TMFRAME - Time frame to search data for
 ;   BQDFN   - Patient internal entry number
 ;   SYS     - The systolic value to compare against
 ;   DIA     - The diastolic value to compare against
 ;   OPER    - The operand to check the systolic and diastolic with
 ;
 NEW BDATE,EDATE,TBP,N,CT,OK,BCLN,VIS,VALUE,VSYS,VDIA,RESULT
 S TMFRAME=$G(TMFRAME,"T-60M"),RESULT=0
 S BDATE=$$DATE^BQIUL1(TMFRAME),BDATE=$$FMTE^XLFDT(BDATE),EDATE=$$FMTE^XLFDT(DT)
 S %=BQDFN_"^ALL MEAS BP;DURING "_BDATE_"-"_EDATE
 K TBP
 S E=$$START1^APCLDF(%,"TBP(")
 I $G(OPER)="" D  Q RESULT
 . I '$D(TBP) Q
 . S RESULT=1
 S OPER=$G(OPER,">")
 S (RESULT,N)="",(CT,OK)=0,BCLN=$$FIND1^DIC(40.7,"","Q","30","C","","ERROR")
 F  S N=$O(TBP(N),-1) Q:N=""  D  Q:CT=3
 . S VIS=$P(TBP(N),U,5) Q:VIS=""
 . I $P($G(^AUPNVSIT(VIS,0)),U,8)=BCLN Q
 . S VALUE=$P(TBP(N),U,2)
 . S DATE=$P(TBP(N),U,1),IEN=$P($P(TBP(N),U,4),";",1)
 . S VSYS=$P(VALUE,"/",1),VDIA=$P(VALUE,"/",2)
 . I VSYS=""!(VDIA="") Q
 . S CT=CT+1 I CT>3 Q
 . I @(VSYS_OPER_SYS) S OK=OK+1 D FBP Q
 . I @(VDIA_OPER_DIA) S OK=OK+1 D FBP Q
 . D FBP
 . ;I @(VSYS_OPER_SYS)!(@(VDIA_OPER_DIA)) S OK=OK+1
 . ;I VSYS>SYS!(VDIA>DIA) S OK=OK+1
 I OK>1 Q 1_U_RESULT
 Q 0_U_$S(RESULT'="":RESULT,1:"No BPs in timeframe")
 ;
FBP ; Set BP variables
 S $P(RESULT,U,1)=$P(RESULT,U,1)_DATE_";"
 S $P(RESULT,U,2)=$P(RESULT,U,2)_IEN_";"
 S $P(RESULT,U,3)=$P(RESULT,U,3)_VIS_";"
 S $P(RESULT,U,4)=$P(RESULT,U,4)_VALUE_";"
 Q
 ;
LAB(TMFRAME,RECENT,BQDFN,TAX,RESULT,OPER,RES2,OPER2,TREF) ;EP
 ; Check for a lab test result
 ;
 ; Input
 ;   TMFRAME - Time frame to search data for
 ;   RECENT  - 1=Only check most recent lab,0=Check all within timeframe
 ;   BQDFN   - Patient internal entry number
 ;   TAX     - Lab taxonomy to search
 ;   RESULT  - Lab result to check for
 ;   OPER    - Operand to use for result check
 ;   RES2    - If range, the other result value
 ;   OPER2   - If range, the other result operand
 ;   TREF    - Multiple same resulting taxonomies built
 ;             into reference (usually global)
 ;
 NEW TEMP,EDATE,BDATE,LIEN,QFL,RES,CT,VALUE,VIEN,VSDTM,MICRO,OVALUE,NCT
 S BDATE=$$DATE^BQIUL1(TMFRAME),EDATE=DT
 S TEMP=$NA(^TMP(UID,"BQITEMP")) K @TEMP
 S TAX=$G(TAX,"")
 I TAX'="" D
 . S TREF=$NA(^TMP(UID,"BQITAX")),RES2=$G(RES2,""),OPER2=$G(OPER2,""),RECENT=$G(RECENT,0)
 . K @TREF
 . D BLD^BQITUTL(TAX,TREF)
 ;
 S LIEN="",QFL=0,RES=0_U_"No Test",CT=0
 I $G(TMFRAME)'="" D
 . S TIEN=""
 . F  S TIEN=$O(@TREF@(TIEN)) Q:TIEN=""  D
 .. S EDT=9999999-BDATE,BDT=(9999999-EDATE)-.001
 .. I $P($G(^LAB(60,TIEN,0)),U,4)="MI" D MIC^BQICAUTL(BQDFN,TIEN,EDT,BDT,.MICRO) Q
 .. F  S BDT=$O(^AUPNVLAB("AA",BQDFN,TIEN,BDT)) Q:BDT=""!(BDT>EDT)  D
 ... S LIEN=""
 ... F  S LIEN=$O(^AUPNVLAB("AA",BQDFN,TIEN,BDT,LIEN)) Q:LIEN=""  D
 .... S VALUE=$P(^AUPNVLAB(LIEN,0),U,4) I VALUE="" Q
 .... S VIEN=$P(^AUPNVLAB(LIEN,0),U,3) I VIEN="" Q
 .... S FLAG=$P($G(^AUPNVLAB(LIEN,11)),U,9) I FLAG="" Q
 .... I FLAG'="R"&(FLAG'="M") Q
 .... ;S VSDTM=$$GET1^DIQ(9000010,VIEN_",",.01,"I")\1 I VSDTM=0 Q
 .... S VSDTM=$P($G(^AUPNVSIT(VIEN,0)),"^",1)\1 I VSDTM=0 Q
 .... ;I $G(TMFRAME)'="",VSDTM<BDATE Q
 .... ; quit if deleted flag
 .... I $P($G(^AUPNVSIT(VIEN,0)),U,11)=1 Q
 .... I $P($G(^AUPNVLAB(LIEN,11)),U,9)="D" Q
 .... S @TEMP@(VSDTM,VIEN,LIEN)=VALUE_U_TIEN
 ;
 I $G(TMFRAME)="" D
 . S LIEN=""
 . F  S LIEN=$O(^AUPNVLAB("AC",BQDFN,LIEN),-1) Q:LIEN=""  D
 .. S TIEN=$P($G(^AUPNVLAB(LIEN,0)),U,1) I TIEN="" Q
 .. I '$D(@TREF@(TIEN)) Q
 .. S VALUE=$P(^AUPNVLAB(LIEN,0),U,4) I VALUE="" Q
 .. S VIEN=$P(^AUPNVLAB(LIEN,0),U,3) I VIEN="" Q
 .. ;S VSDTM=$$GET1^DIQ(9000010,VIEN_",",.01,"I")\1 I VSDTM=0 Q
 .. S VSDTM=$P($G(^AUPNVSIT(VIEN,0)),"^",1)\1 I VSDTM=0 Q
 .. ;I $G(TMFRAME)'="",VSDTM<BDATE Q
 .. ; quit if deleted flag
 .. I $P($G(^AUPNVSIT(VIEN,0)),U,11)=1 Q
 .. I $P($G(^AUPNVLAB(LIEN,11)),U,9)="D" Q
 .. S @TEMP@(VSDTM,VIEN,LIEN)=VALUE_U_TIEN
 . F  S LIEN=$O(^AUPNVMIC("AC",BQDFN,LIEN),-1) Q:LIEN=""  D
 .. S TIEN=$P($G(^AUPNVMIC(LIEN,0)),U,1) I TIEN="" Q
 .. I '$D(@TREF@(TIEN)) Q
 .. S VALUE=$P(^AUPNVMIC(LIEN,0),U,7) I VALUE="" Q
 .. S VIEN=$P(^AUPNVMIC(LIEN,0),U,3) I VIEN="" Q
 .. ;S VSDTM=$$GET1^DIQ(9000010,VIEN_",",.01,"I")\1 I VSDTM=0 Q
 .. S VSDTM=$P($G(^AUPNVSIT(VIEN,0)),"^",1)\1 I VSDTM=0 Q
 .. ; quit if deleted flag
 .. I $P($G(^AUPNVSIT(VIEN,0)),U,11)=1 Q
 .. I $P($G(^AUPNVMIC(LIEN,11)),U,9)="D" Q
 .. S @TEMP@(VSDTM,VIEN,LIEN)=VALUE_U_TIEN
 ;
 S VSDTM="",CT=0,NCT=0
 F  S VSDTM=$O(@TEMP@(VSDTM),-1) Q:VSDTM=""  S CT=CT+1
 F  S VSDTM=$O(@TEMP@(VSDTM),-1) Q:VSDTM=""  D  Q:QFL
 . S VIEN=$O(@TEMP@(VSDTM,""),-1)
 . S LIEN=$O(@TEMP@(VSDTM,VIEN,""),-1)
 . S VALUE=$P(@TEMP@(VSDTM,VIEN,LIEN),U,1),OVALUE=VALUE
 . S TIEN=$P(@TEMP@(VSDTM,VIEN,LIEN),U,2)
 . K ROPER
 . S NCT=NCT+1
 . I OPER="'=",RESULT=0,VALUE'="" S RES=1_U_$$FMTE^BQIUL1(VSDTM)_U_VALUE_U_VIEN_U_LIEN_U_TIEN,QFL=1 Q
 . I RECENT,NCT=1 D  Q
 .. D RCHK I 'RES Q
 .. S QFL=1,RES=1_U_$$FMTE^BQIUL1(VSDTM)_U_VALUE_U_VIEN_U_LIEN_U_TIEN Q
 . D RCHK
 K @TEMP
 Q RES
 ;
EDTP(GREF,SRCH) ;EP - Search for education topics and put into a passed reference
 ;Input
 ;   GREF - Reference
 ;   SRCH - Search text
 ;
 NEW BQNM,IEN
 S BQNM=""
 F  S BQNM=$O(^AUTTEDT("C",BQNM)) Q:BQNM=""  D
 . I $E(SRCH,1,1)="-" D  Q
 .. I BQNM'[SRCH Q
 .. D EFIL
 . I $E(BQNM,1,$L(SRCH))'=SRCH Q
 . D EFIL
 Q
 ;
EFIL ; File data into reference
 S IEN=""
 F  S IEN=$O(^AUTTEDT("C",BQNM,IEN)) Q:IEN=""  D
 . I $P($G(^AUTTEDT(IEN,0)),U,3)=1 Q
 . I $G(^AUTTEDT(IEN,0))="" Q
 . S @GREF@(IEN)=$P(^AUTTEDT(IEN,0),U,1)
 Q
 ;
MED(GREF,SRCH) ;EP 
 ;Search for Medications
 ;Input
 ; GREF - Reference where results are to be stored
 ; SRCH - Value that is being searched on
 NEW BQNM,IEN
 S BQNM=""
 F  S BQNM=$O(^PSDRUG("B",BQNM)) Q:BQNM=""  D
 . I BQNM'[SRCH Q
 . S IEN=""
 . F  S IEN=$O(^PSDRUG("B",BQNM,IEN)) Q:IEN=""  D
 .. I $G(^PSDRUG(IEN,0))="" Q
 .. I $P($G(^PSDRUG(IEN,"I")),U,1)'="",$P($G(^PSDRUG(IEN,"I")),U,1)<DT Q
 .. S @GREF@(IEN)=$P(^PSDRUG(IEN,0),U,1)
 Q
 ;
POSITIVE(RESULT) ; EP
 ; If the result is positive return a 1 else return a 0.
 I $E(RESULT,1)="+" Q 1
 I $E(RESULT,1)=">" Q 1
 S RESULT=$$UP^XLFSTR(RESULT)
 I RESULT="P" Q 1 ; Positive
 I RESULT="R" Q 1 ; Reactive
 I RESULT="WR" Q 1 ; Weakly Reactive
 I RESULT="REACTIVE" Q 1 ; Reactive
 I RESULT="WEAKLY REACTIVE" Q 1 ; Weakly Reactive
 I RESULT["POS" Q 1 ; Positive
 I RESULT["NOT DETECTED" Q 0
 I RESULT["DETECTED" Q 1 ; Detected
 I RESULT="D" Q 1 ; Detected
 Q 0
 ;
NEGATIVE(RESULT) ; EP
 ; If the result is negative return a 1 else return a 0.
 I $E(RESULT,1)="-" Q 1
 ; **NOTE: Documentation does not specify if "<" is considered negative.
 S RESULT=$$UP^XLFSTR(RESULT)
 I RESULT="N" Q 1 ; Negative (or Non-Reactive)
 I RESULT="NR" Q 1 ; Non-Reactive
 I RESULT="NON-REACTIVE" Q 1 ; Non-Reactive
 I RESULT="NON REACTIVE" Q 1 ; Non-Reactive
 I RESULT="NONREACTIVE" Q 1 ; Non-Reactive
 I RESULT["NON REAC" Q 1 ;non-reactive
 I RESULT["NEG" Q 1 ; Negative
 I RESULT["NOT DETECTED" Q 1
 I RESULT["NOT DET" Q 1
 Q 0
 ;
TAX(TMFRAME,TAX,NIT,PTDFN,FREF,PRB,SAME,TREF,START,END) ;EP
 ; Find value for a taxonomy (TAX) or list of taxonomies (TREF)
 ; Input
 ;   TMFRAME - Timeframe to search for data
 ;   TAX     - Taxonomy
 ;   NIT     - Number of iterations
 ;   PTDFN   - Patient IEN
 ;   FREF    - File number reference
 ;   PRB     - If Active Problem okay
 ;   SAME    - If NIT is allowed for the same day or not (1 same day okay)
 ;   TREF    - Multiple same resulting taxonomies (e.g. MEDs) built
 ;             into reference (usually global)
 ;   START   - Starting Date
 ;   END     - Ending Date
 ;
 NEW RESULT,GREF,ENDT,IEN,TIEN,TEMP,QFL,SRCTYP,VFL,VALUE
 S TMFRAME=$G(TMFRAME,""),NIT=$G(NIT,1),PRB=$G(PRB,0),SAME=$G(SAME,1)
 S RESULT=0,TREF=$G(TREF,""),TAX=$G(TAX,"")
 S START=$G(START,""),END=$G(END,"")
 I $G(TMFRAME)'="" S ENDT=$$DATE^BQIUL1(TMFRAME),BDT=""
 I $G(START)'=""!($G(END)'="") S ENDT=START,BDT=(9999999-END)-.001
 I $G(UID)="" S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 I TAX'="" D
 . S TREF=$NA(^TMP(UID,"BQITAX"))
 . K @TREF
 . D BLD^BQITUTL(TAX,TREF)
 S GREF=$$ROOT^DILFD(FREF,"",1)
 S TEMP=$NA(^TMP(UID,"BQITEMP")) K @TEMP
 ;
 I PRB D
 . S IEN="",QFL=0,RESULT=0
 . F  S IEN=$O(^AUPNPROB("AC",PTDFN,IEN),-1) Q:IEN=""  D  Q:QFL
 .. ;S TIEN=$$GET1^DIQ(9000011,IEN,.01,"I") I TIEN="" Q
 .. S TIEN=$P($G(^AUPNPROB(IEN,0)),"^",1) I TIEN="" Q
 .. I '$D(@TREF@(TIEN)) Q
 .. ;  Check class - if Family ignore
 .. ;I $$GET1^DIQ(9000011,IEN,.04,"I")="F" Q
 .. I $P($G(^AUPNPROB(IEN,0)),"^",4)="F" Q
 .. I $P($G(^AUPNPROB(IEN,0)),"^",12)'="A" Q
 .. ;I $$GET1^DIQ(9000011,IEN,.12,"I")'="A" Q
 .. S VSDTM=$$PROB^BQIUL1(IEN)\1 Q:VSDTM=0
 .. I $G(TMFRAME)'="",VSDTM<ENDT Q
 .. S RESULT=1_U_VSDTM,$P(RESULT,U,4)=IEN,QFL=1
 ;
 I 'RESULT D
 . S IEN="",QFL=0,RESULT=0,CT=0
 . D
 .. I $G(TMFRAME)="",$G(START)="",$G(END)="" Q
 .. S VFL=$O(^BQI(90508.6,"B",FREF,""))
 .. I VFL'="" S SRCTYP=$P(^BQI(90508.6,VFL,0),U,3)
 .. S EDT=9999999-ENDT
 .. I SRCTYP'=2 D  Q
 ... F  S BDT=$O(@GREF@("AA",PTDFN,BDT)) Q:BDT=""!(BDT>EDT)  D
 .... S IEN=""
 .... F  S IEN=$O(@GREF@("AA",PTDFN,BDT,IEN)) Q:IEN=""  D
 ..... S TIEN=$$GET1^DIQ(FREF,IEN,.01,"I") I TIEN="" Q
 ..... I '$D(@TREF@(TIEN)) Q
 ..... S VISIT=$$GET1^DIQ(FREF,IEN,.03,"I") I VISIT="" Q
 ..... I $$GET1^DIQ(9000010,VISIT,.11,"I")=1 Q
 ..... ;S VSDTM=$$GET1^DIQ(9000010,VISIT,.01,"I")\1 Q:VSDTM=0
 ..... S VSDTM=$P($G(^AUPNVSIT(VISIT,0)),"^",1)\1 I VSDTM=0 Q
 ..... ;I $G(TMFRAME)'="",VSDTM<ENDT Q
 ..... S VALUE=$$GET1^DIQ(FREF,IEN,.04,"E")
 ..... ; Set temporary
 ..... S @TEMP@(VSDTM,VISIT,IEN)=VALUE
 .. S TIEN=""
 .. F  S TIEN=$O(@TREF@(TIEN)) Q:TIEN=""  D
 ... I $G(TMFRAME)'="" S ENDT=$$DATE^BQIUL1(TMFRAME),BDT=""
 ... I $G(START)'=""!($G(END)'="") S ENDT=START,BDT=(9999999-END)-.001
 ... F  S BDT=$O(@GREF@("AA",PTDFN,TIEN,BDT)) Q:BDT=""!(BDT>EDT)  D
 .... S IEN=""
 .... F  S IEN=$O(@GREF@("AA",PTDFN,TIEN,BDT,IEN)) Q:IEN=""  D
 ..... S VISIT=$$GET1^DIQ(FREF,IEN,.03,"I") I VISIT="" Q
 ..... I $$GET1^DIQ(9000010,VISIT,.11,"I")=1 Q
 ..... ;S VSDTM=$$GET1^DIQ(9000010,VISIT,.01,"I")\1 Q:VSDTM=0
 ..... S VSDTM=$P($G(^AUPNVSIT(VISIT,0)),"^",1)\1 I VSDTM=0 Q
 ..... S VALUE=$$GET1^DIQ(FREF,IEN,.04,"E")
 ..... S @TEMP@(VSDTM,VISIT,IEN)=VALUE
 . ;
 . I $G(TMFRAME)="" D
 .. I $G(START)'="",$G(END)'="" Q
 .. F  S IEN=$O(@GREF@("AC",PTDFN,IEN),-1) Q:IEN=""  D
 ... S TIEN=$$GET1^DIQ(FREF,IEN,.01,"I") I TIEN="" Q
 ... I '$D(@TREF@(TIEN)) Q
 ... S VISIT=$$GET1^DIQ(FREF,IEN,.03,"I") I VISIT="" Q
 ... ;I $$GET1^DIQ(9000010,VISIT,.11,"I")=1 Q
 ... I $P($G(^AUPNVSIT(VISIT,0)),"^",11)=1 Q
 ... ;S VSDTM=$$GET1^DIQ(9000010,VISIT,.01,"I")\1 Q:VSDTM=0
 ... S VSDTM=$P($G(^AUPNVSIT(VISIT,0)),"^",1)\1 I VSDTM=0 Q
 ... ;I $G(TMFRAME)'="",VSDTM<ENDT Q
 ... S VALUE=$$GET1^DIQ(FREF,IEN,.04,"E")
 ... ; Set temporary
 ... S @TEMP@(VSDTM,VISIT,IEN)=VALUE
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
 ... I $P(RESULT,U,2)'="",(CT'>NIT) D
 .... S $P(RESULT,U,2)=$P(RESULT,U,2)_";"_VSDTM
 .... S $P(RESULT,U,4)=$P(RESULT,U,4)_";"_VISIT
 .... S $P(RESULT,U,5)=$P(RESULT,U,5)_";"_IEN
 .... S $P(RESULT,U,6)=$P(RESULT,U,6)_";"_VALUE
 ... I $P(RESULT,U,2)="" S $P(RESULT,U,2)=VSDTM,$P(RESULT,U,4)=VISIT_U_IEN,$P(RESULT,U,6)=VALUE
 ... ;S $P(RESULT,U,4)=VISIT_U_IEN,CT=CT+1
 ... ;S RESULT=U_VSDTM_U_U_VISIT_U_IEN,CT=CT+1
 ... I CT=NIT S QFL=1,$P(RESULT,U,1)=1
 K @TREF
 Q RESULT
 ;
FED(TMFRAME,BQDFN,TOP) ;EP
 ; Find visits for a topic
 ; Input
 ;   TMFRAME - Time frame to search data for
 ;   BQDFN   - Patient internal entry number
 ;   TOP     - Education Topic
 NEW BQITOP,ARRAY,FREF,GREF,ENDT,IEN,QFL,RESULT,EDT,BDT,TIEN,VISIT,VSDTM
 S TMFRAME=$G(TMFRAME,"")
 S ARRAY="BQITOP",FREF=9000010.16,GREF=$$ROOT^DILFD(FREF,"",1)
 D EDTP(.ARRAY,TOP)
 S ENDT=$$DATE^BQIUL1(TMFRAME)
 S IEN="",QFL=0,RESULT=0
 I $G(TMFRAME)'="" D
 . S EDT=9999999-ENDT,BDT=""
 . F  S BDT=$O(@GREF@("AA",BQDFN,BDT)) Q:BDT=""!(BDT>EDT)  D
 .. S IEN=""
 .. F  S IEN=$O(@GREF@("AA",BQDFN,BDT,IEN)) Q:IEN=""  D
 ... S TIEN=$$GET1^DIQ(FREF,IEN,.01,"I") I TIEN="" Q
 ... I '$D(BQITOP(TIEN)) Q
 ... S VISIT=$$GET1^DIQ(FREF,IEN,.03,"I") I VISIT="" Q
 ... ;I $$GET1^DIQ(9000010,VISIT,.11,"I")=1 Q
 ... I $P($G(^AUPNVSIT(VISIT,0)),"^",11)=1 Q
 ... ;S VSDTM=$$GET1^DIQ(9000010,VISIT,.01,"I")\1 Q:VSDTM=0
 ... S VSDTM=$P($G(^AUPNVSIT(VISIT,0)),"^",1)\1 I VSDTM=0 Q
 ... S RESULT=1_U_VSDTM_U_U_VISIT_U_IEN,QFL=1
 ;
 I $G(TMFRAME)="" D
 . F  S IEN=$O(@GREF@("AC",BQDFN,IEN),-1) Q:'IEN  D  Q:QFL
 .. S TIEN=$$GET1^DIQ(FREF,IEN,.01,"I") I TIEN="" Q
 .. I '$D(BQITOP(TIEN)) Q
 .. S VISIT=$$GET1^DIQ(FREF,IEN,.03,"I") I VISIT="" Q
 .. ;I $$GET1^DIQ(9000010,VISIT,.11,"I")=1 Q
 .. I $P($G(^AUPNVSIT(VISIT,0)),"^",11)=1 Q
 .. ;S VSDTM=$$GET1^DIQ(9000010,VISIT,.01,"I")\1 Q:VSDTM=0
 .. S VSDTM=$P($G(^AUPNVSIT(VISIT,0)),"^",1)\1 I VSDTM=0 Q
 .. ;I $G(TMFRAME)'="",VSDTM<ENDT Q
 .. S RESULT=1_U_VSDTM_U_U_VISIT_U_IEN,QFL=1
 Q RESULT
 ;
RCHK ;EP - Result check
 I RESULT'?.N,VALUE?.N Q
 ;
 I RESULT="POS",$E(VALUE,1)'?.N,'$$POSITIVE(VALUE) Q
 I RESULT="POS",$E(VALUE,1)'?.N,$$POSITIVE(VALUE) D  Q
 . S RES=1_U_$$FMTE^BQIUL1(VSDTM)_U_VALUE_U_VIEN_U_LIEN_U_TIEN,QFL=1
 I RESULT="NEG",$E(VALUE,1)'?.N,'$$NEGATIVE(VALUE) Q
 I RESULT="NEG",$E(VALUE,1)'?.N,$$NEGATIVE(VALUE) D
 . S RES=1_U_$$FMTE^BQIUL1(VSDTM)_U_VALUE_U_VIEN_U_LIEN_U_TIEN,QFL=1
 I VALUE'?.PN,VALUE'?.N Q
 ;I $E(VALUE,$L(VALUE))?.P S VALUE=VALUE_"0"
 I $E(VALUE,$L(VALUE),$L(VALUE))?.P S VALUE=$E(VALUE,1,$L(VALUE)-1)
 ; if value starts with a punctuation e.g. < or >
 I $E(VALUE,1,1)?.P S ROPER=$E(VALUE,1,1),VALUE=$E(VALUE,2,$L(VALUE))
 I RES2="" D
 . I $G(ROPER)="",@("VALUE"_OPER_"RESULT") D  Q
 .. S RES=1_U_$$FMTE^BQIUL1(VSDTM)_U_OVALUE_U_VIEN_U_LIEN_U_TIEN,QFL=1
 . I $G(ROPER)'="",OPER=ROPER,@("VALUE"_OPER_"RESULT") D  Q
 .. S RES=1_U_$$FMTE^BQIUL1(VSDTM)_U_OVALUE_U_VIEN_U_LIEN_U_TIEN,QFL=1
 . I $G(ROPER)'="",OPER'=ROPER Q
 I RES2'="" D
 . I @("VALUE"_OPER_"RESULT"),@("VALUE"_OPER2_"RES2") D
 .. S RES=1_U_$$FMTE^BQIUL1(VSDTM)_U_OVALUE_U_VIEN_U_LIEN_U_TIEN,QFL=1
 Q
