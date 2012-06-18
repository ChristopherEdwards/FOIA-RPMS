BQITDGN ;PRXM/HC/ALA-General Taxonomy Diagnosis Category ; 10 Apr 2006  6:53 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 Q
 ;
POP(BQARY,TGLOB,KEEP) ; EP -- By population
 ;
 ;Description
 ;  Finds all patients who meet the criteria passed in array BQARY
 ;Input
 ;  BQARY - Array of taxonomies and other information
 ;          Format: BQARY(#)=TAX^TYPE^NIT^TMFRAME^FREF^PLFLG^SAME
 ;  TGLOB - Global where data is to be stored and passed back
 ;          to calling routine
 ;          Structure:
 ;          TGLOB(DFN,"CRITERIA",criteria or taxonomy,visit or problem ien)=date/time
 ;Variables
 ;  TAX - Taxonomy name
 ;  NIT - Number of iterations
 ;  TMFRAME - Time frame of check, this is a relative date (T-12M)
 ;  FREF - File Number reference
 ;  PLFLG - Active Problem flag
 ;  SAME - Check flag for instance on same date
 ;  GREF - Global reference
 ;  TREF - Taxonomy temp reference
 ;  TPGLOB - Temporary global reference for Problem File instances
 ;  KEEP - Keep the temporary global when passed from another logic definition
 ;  EXDT - Expiration date
 ;  DTDIF - difference between the start and end dates of the timeframe
 ;  STDT - Start date of the timeframe
 ;  ENDT - End date of the timeframe
 ;  PRIM - Clinical ranking e.g. primary diagnosis only or primary/secondary.
 ;  SERV - Visit service categories
 ;
 NEW N,TAX,NIT,TMFRAME,FREF,GREF,TREF,STDT,GLOBAL,IEN,TIEN,VISIT,VSDTM,ENDT
 NEW TPGLOB,SAME,EXDT,DTDIF,TPRGL,PRIM,SERV,VSERV
 S KEEP=$G(KEEP,0)
 S TPGLOB=$NA(^TMP("TEMP",UID))
 ; if KEEP is zero (do not keep any previous data passed), clean out the temporary
 ; global
 I 'KEEP K @TPGLOB
 ;  For each defined taxonomy set up into an array from File 90506.2
 I $D(@BQARY) D
 . S N=0 F  S N=$O(@BQARY@(N)) Q:'N  D
 .. D PROC
 .. S DFN=0
 .. F  S DFN=$O(@TPGLOB@(DFN)) Q:'DFN  D
 ... I '$D(@TGLOB@(DFN)) M @TGLOB@(DFN)=@TPGLOB@(DFN)
 .. ;
 .. I 'KEEP K @TPGLOB
 .. Q
 I $D(@TPGLOB) K @TPGLOB
 I $D(@TREF) K @TREF
 I $D(@TPRGL) K @TPRGL
 K DFN,PLFLG,GLBL,PC,STDT
 Q
 ;
PROC ;Process each entry
 S TAX=$P(@BQARY@(N),U,1),NIT=$P(@BQARY@(N),U,3)
 S TMFRAME=$P(@BQARY@(N),U,4),FREF=$P(@BQARY@(N),U,5)
 S PLFLG=+$P(@BQARY@(N),U,6),SAME=+$P(@BQARY@(N),U,7)
 S PRIM=+$P(@BQARY@(N),U,8),SERV=$P(@BQARY@(N),U,9)
 S EXDT="",DTDIF=""
 I TMFRAME'="" D
 . S ENDT=$$DATE^BQIUL1(TMFRAME),STDT=$$DT^XLFDT()
 . S DTDIF=$$FMDIFF^XLFDT(STDT,ENDT,1)
 S GREF=$$ROOT^DILFD(FREF,"",1)
 S TPRGL=$NA(^TMP("TPRBLM",UID)) K @TPRGL
 ;  Build the taxonomy reference
 S TREF=$NA(^TMP("BQITAX",UID))
 K @TREF
 D BLD^BQITUTL(TAX,TREF)
 ;  For each entry in the taxonomy reference
 S TIEN="" F  S TIEN=$O(@TREF@(TIEN)) Q:TIEN=""  D
 . ;  If problem flag, check the problem file for any instances of
 . ;  the taxonomy entry
 . I PLFLG D PRB(TIEN,TPRGL) Q
 ; For each entry in the appropriate file (GREF), starting with most recent
 ; look for patients with instances for each taxonomy entry
 S DFN=""
 F  S DFN=$O(@TPRGL@(DFN)) Q:DFN=""  M @TGLOB@(DFN)=@TPRGL@(DFN)
 S TIEN=""
 F  S TIEN=$O(@TREF@(TIEN)) Q:TIEN=""  D
 . S IEN=""
 . F  S IEN=$O(@GREF@("B",TIEN,IEN),-1) Q:IEN=""  D
 .. ;  if a bad record (no zero node), quit
 .. I $G(@GREF@(IEN,0))="" Q
 .. ;  get patient record
 .. S DFN=$$GET1^DIQ(FREF,IEN,.02,"I") Q:DFN=""
 .. ;  if the patient already has a problem instance, quit
 .. ;I $D(@TPRGL@(DFN))>0,$D(@TGLOB@(DFN)) M @TGLOB@(DFN)=@TPRGL@(DFN) Q
 .. I $D(@TGLOB@(DFN)) Q
 .. ;  get the visit information
 .. S VISIT=$$GET1^DIQ(FREF,IEN,.03,"I") Q:VISIT=""
 .. ;  if the visit is deleted, quit
 .. I $$GET1^DIQ(9000010,VISIT,.11,"I")=1 Q
 .. ;  check clinical ranking if diagnosis (9000010.07)
 .. I FREF=9000010.07,PRIM I $P(@GREF@(IEN,0),U,12)'="P" S MFL=0 D  Q:'MFL
 ... I $O(@GREF@("AD",VISIT,""))=IEN S MFL=1
 .. ;  check clinical ranking if procedure (9000010.18 or 9000010.08)
 .. I (FREF=9000010.18)!(FREF=9000010.08)&(PRIM) I $P(@GREF@(IEN,0),U,7)'="P" S MFL=0 D  Q:'MFL
 ... I $O(@GREF@("AD",VISIT,""))=IEN S MFL=1
 .. S VSDTM=$$GET1^DIQ(9000010,VISIT,.01,"I")\1 Q:VSDTM=0
 .. ;  if there is a specified timeframe for the visit and the
 .. ;  visit date doesn't fall within that timeframe, quit
 .. I $G(TMFRAME)'="",VSDTM<ENDT Q
 .. ;  if service categories, check the visit for the service category
 .. S VSERV=$$GET1^DIQ(9000010,VISIT,.07,"I")
 .. I $G(SERV)'="",SERV'[VSERV Q
 .. ; if the SAME day flag is zero then the value cannot be on the same day
 .. ; if there is already a value for this date, quit
 .. I 'SAME,$D(@TPGLOB@(DFN,"VISIT",VSDTM)) Q
 .. ;  if the patient has already met the number of interations, quit
 .. I $G(@TPGLOB@(DFN))'<NIT Q
 .. ;  set the qualifying criteria for this patient and diagnostic category
 .. I DTDIF'="" S EXDT=$$FMADD^XLFDT(VSDTM,DTDIF)
 .. S @TPGLOB@(DFN,"CRITERIA",TAX,"V",VISIT,IEN)=VSDTM
 .. S $P(@TPGLOB@(DFN,"CRITERIA",TAX,"V",VISIT,IEN),U,3)=IEN_U_FREF
 .. I EXDT'="" S $P(@TPGLOB@(DFN,"CRITERIA",TAX,"V",VISIT,IEN),U,2)=EXDT
 .. S @TPGLOB@(DFN,"VISIT",VSDTM)=""
 .. S @TPGLOB@(DFN)=$G(@TPGLOB@(DFN))+1
 S DFN=""
 F  S DFN=$O(@TPGLOB@(DFN)) Q:DFN=""  D
 . K @TPGLOB@(DFN,"VISIT")
 . I @TPGLOB@(DFN)<NIT K @TPGLOB@(DFN)
 Q
 ;
PAT(BQARY,TGLOB,PTDFN,KEEP) ; EP -- By patient
 ;Description
 ;  Checks if a patient meets the criteria
 ;Input
 ;  BQARY - Array of taxonomies and other information
 ;  DFN   - patient internal entry number
 ;
 S KEEP=$G(KEEP,0)
 NEW TPGLOB
 S TPGLOB=$NA(^TMP("TEMP",UID))
 I 'KEEP K @TPGLOB
 NEW N,TAX,NIT,TMFRAME,FREF,GREF,TREF,STDT,GLOBAL,IEN
 NEW TIEN,VISIT,VSDTM,SAME,PROB,TPRGL,PRIM,SERV,VSERV
 S N=0 F  S N=$O(@BQARY@(N)) Q:'N  D
 . D PROCP
 . I '$D(@TGLOB@(PTDFN)) M @TGLOB@(PTDFN)=@TPGLOB@(PTDFN)
 . I 'KEEP K @TPGLOB
 . Q
 K @TPGLOB@(PTDFN,"VISIT")
 I '$D(@TGLOB@(PTDFN)),$G(@TPGLOB@(PTDFN))<NIT K @TPGLOB Q 0
 D FIL Q 1
 ;
FIL ;
 M @TGLOB@(PTDFN,"CRITERIA")=@TPGLOB@(PTDFN,"CRITERIA")
 S @TGLOB@(PTDFN)=$G(@TGLOB@(PTDFN))+$G(@TPGLOB@(PTDFN))
 Q
 ;
PROCP ; Process one patient
 S TAX=$P(@BQARY@(N),U,1),NIT=$P(@BQARY@(N),U,3)
 S TMFRAME=$P(@BQARY@(N),U,4),FREF=$P(@BQARY@(N),U,5)
 S PLFLG=+$P(@BQARY@(N),U,6),SAME=+$P(@BQARY@(N),U,7)
 S PRIM=+$P(@BQARY@(N),U,8),SERV=$P(@BQARY@(N),U,9)
 S EXDT="",DTDIF=""
 I TMFRAME'="" D
 . S ENDT=$$DATE^BQIUL1(TMFRAME),STDT=$$DT^XLFDT()
 . S DTDIF=$$FMDIFF^XLFDT(STDT,ENDT,1)
 S GREF=$$ROOT^DILFD(FREF,"",1),TREF=$NA(^TMP("BQITAX",UID))
 K @TREF
 S TPRGL=$NA(^TMP("TPRBLM",UID)) K @TPRGL
 D BLD^BQITUTL(TAX,TREF)
 I PLFLG D PPRB(PTDFN,TPRGL) I $D(@TPRGL@(PTDFN))>0,'$D(@TGLOB@(PTDFN)) M @TGLOB@(PTDFN)=@TPRGL@(PTDFN) Q
 S IEN=""
 F  S IEN=$O(@GREF@("AC",PTDFN,IEN),-1) Q:'IEN  D
 . S TIEN=$$GET1^DIQ(FREF,IEN,.01,"I") I TIEN="" Q
 . I '$D(@TREF@(TIEN)) Q
 . S VISIT=$$GET1^DIQ(FREF,IEN,.03,"I") I VISIT="" Q
 . I $$GET1^DIQ(9000010,VISIT,.11,"I")=1 Q
 . ;  check clinical ranking if diagnosis (9000010.07)
 . I FREF=9000010.07,PRIM I $P(@GREF@(IEN,0),U,12)'="P" S MFL=0 D  Q:'MFL
 .. I $O(@GREF@("AD",VISIT,""))=IEN S MFL=1
 . I (FREF=9000010.18)!(FREF=9000010.08)&(PRIM) I $P(@GREF@(IEN,0),U,7)'="P" S MFL=0 D  Q:'MFL
 .. I $O(@GREF@("AD",VISIT,""))=IEN S MFL=1
 . S VSDTM=$$GET1^DIQ(9000010,VISIT,.01,"I")\1 I VSDTM=0 Q
 . I $G(TMFRAME)'="",VSDTM<ENDT Q
 . ;  if service categories, check the visit for the service category
 . S VSERV=$$GET1^DIQ(9000010,VISIT,.07,"I")
 . I $G(SERV)'="",SERV'[VSERV Q
 . ; if the SAME day flag is zero then the value cannot be on the same day
 . ; if there is already a value for this date, quit
 . I 'SAME,$D(@TPGLOB@(PTDFN,"VISIT",VSDTM)) Q
 . I $G(@TPGLOB@(PTDFN))'<NIT Q
 . I DTDIF'="" S EXDT=$$FMADD^XLFDT(VSDTM,DTDIF)
 . S @TPGLOB@(PTDFN,"CRITERIA",TAX,"V",VISIT,IEN)=VSDTM
 . S $P(@TPGLOB@(PTDFN,"CRITERIA",TAX,"V",VISIT,IEN),U,3)=IEN_U_FREF
 . I EXDT'="" S $P(@TPGLOB@(PTDFN,"CRITERIA",TAX,"V",VISIT,IEN),U,2)=EXDT
 . S @TPGLOB@(PTDFN,"VISIT",VSDTM)=""
 . S @TPGLOB@(PTDFN)=$G(@TPGLOB@(PTDFN))+1
 K @TPGLOB@(PTDFN,"VISIT")
 I $G(@TPGLOB@(PTDFN))<NIT K @TPGLOB@(PTDFN)
 Q
 ;
PRB(PVIEN,BQTGLB) ;EP - Check Problem File for instance of taxonomy
 ;  Input
 ;     PVIEN - Taxonomy entry
 ;     TPGLOB - Problem file temporary global reference
 NEW IEN,PGREF,PFREF
 ;  Go through the problem file, starting with the most recent entry
 S IEN="",PGREF="^AUPNPROB",PFREF=9000011
 F  S IEN=$O(@PGREF@("B",PVIEN,IEN),-1) Q:IEN=""  D
 . ;  get the patient record
 . S DFN=$$GET1^DIQ(PFREF,IEN,.02,"I") I DFN="" Q
 . ;  if there is already a problem instance for this patient, quit
 . I $G(@BQTGLB@(DFN))=1 Q
 . ;  get the date of the problem, since not all dates exist, the
 . ;  hierachy is 'DATE OF ONSET', 'DATE ENTERED', and then 'DATE LAST MODIFIED'.
 . ;
 . ;  Check class - if Family ignore
 . I $$GET1^DIQ(PFREF,IEN,.04,"I")="F" Q
 . S VSDTM=$$PROB^BQIUL1(IEN)\1 Q:VSDTM=0
 . ;  if there is a specified timeframe for the instance and the
 . ;  problem date doesn't fall within that timeframe, quit
 . I $G(TMFRAME)'="",VSDTM<ENDT Q
 . ;  if the problem is not an 'active' one, quit
 . I $$GET1^DIQ(PFREF,IEN,.12,"I")'="A" Q
 . ;  set the qualifying criteria for this patient and diagnostic category
 . I DTDIF'="" S EXDT=$$FMADD^XLFDT(VSDTM,DTDIF)
 . S @BQTGLB@(DFN,"CRITERIA",TAX,"P",IEN)=VSDTM
 . I EXDT'="" S $P(@BQTGLB@(DFN,"CRITERIA",TAX,"P",IEN),U,2)=EXDT
 . S @BQTGLB@(DFN)=$G(@BQTGLB@(DFN))+1
 Q
 ;
PPRB(DFN,BQTGLB) ;EP - Check Problem File for instance of a patient
 NEW PGREF,PFREF,PVIEN,VSDTM
 S PGREF="^AUPNPROB",PFREF=9000011,PROB=0
 S PVIEN=""
 F  S PVIEN=$O(@PGREF@("AC",DFN,PVIEN),-1) Q:PVIEN=""  D  Q:PROB
 . S TIEN=$$GET1^DIQ(PFREF,PVIEN,.01,"I") I TIEN="" Q
 . I '$D(@TREF@(TIEN)) Q
 . ;  Check class - if Family ignore
 . I $$GET1^DIQ(PFREF,PVIEN,.04,"I")="F" Q
 . I $$GET1^DIQ(PFREF,PVIEN,.12,"I")'="A" Q
 . S VSDTM=$$PROB^BQIUL1(PVIEN)\1 Q:VSDTM=0
 . I $G(TMFRAME)'="",VSDTM<ENDT Q
 . I '$D(@BQTGLB@(DFN,PVIEN,VSDTM)) D
 .. S @BQTGLB@(DFN,PVIEN,VSDTM)=$G(@BQTGLB@(DFN,PVIEN,VSDTM))+1
 .. I DTDIF'="" S EXDT=$$FMADD^XLFDT(VSDTM,DTDIF)
 .. S @BQTGLB@(DFN,"CRITERIA",TAX,"P",PVIEN)=VSDTM
 .. I EXDT'="" S $P(@BQTGLB@(DFN,"CRITERIA",TAX,"P",PVIEN),U,2)=EXDT
 .. S @BQTGLB@(DFN)=$G(@BQTGLB@(DFN))+1
 .. S PROB=1
 Q
