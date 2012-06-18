BQITD03 ;PRXM/HC/ALA-CVD Known Definition ; 19 Jun 2006  5:01 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
POP(BQARY,TGLOB) ; EP
 ;
 ;Description
 ;  Finds all patients who meet the criteria for CVD known
 ;Input
 ;  BQARY - Array of taxonomies and other information
 ;  TGLOB - Global where data is to be stored
 ;          Structure:
 ;          TGLOB(DFN,"CRITERIA",criteria or taxonomy,visit or problem ien)=date/time
 ;Variables
 ;  TAX - Taxonomy name
 ;  NIT - Number of iterations
 ;  TMFRAME - Timeframe
 ;  PLFLG - Problem check flag (if 1 check problem file)
 ;  VTYP - The type of event; 'V'isit or 'P'roblem
 ;  DXOK - Diag category okay flag (if 1 then it meet the criteria)
 ;  FREF - File number to search
 ;  GREF - Global reference of FREF
 ;  TREF - Taxonomy temporary global
 ;  TMREF - Temporary global reference; global stores the individual
 ;          record from the visit or problem file.
 ;
 NEW DTDIF,ENDT,EXDT,PLFLG,PROB,TMFRAME,VTYP,DXOK,DXNN,TDFN,RGIEN
 NEW PRIM,SERV,VSERV,OPRM
 ;
 S DXOK=0
 ; BQARY contains a list of taxonomies that can be checked by the generic
 ; program, BQITDGN
 I $D(@BQARY) D
 . D POP^BQITDGN(.BQARY,.TGLOB)
 ;
 ;  AMI Diagnosis check
 S TREF=$NA(^TMP("BQITAX",UID)),TMREF=$NA(^TMP("BQITMPD",UID))
 S TAX="BGP AMI DXS (HEDIS)",FREF=9000010.07,GREF=$$ROOT^DILFD(FREF,"",1)
 S PRIM=1,SERV="A;H"
 S TMFRAME="",EXDT="",DTDIF="",ENDT=""
 K @TREF,@TMREF
 ; Build the taxonomy global
 D BLD^BQITUTL(TAX,TREF)
 S TIEN="" F  S TIEN=$O(@TREF@(TIEN)) Q:TIEN=""  D
 . ;  Check for active problems
 . D PRB(TIEN,TMREF)
 ; For each entry in the taxonomy, find patients that match
 S TIEN="" F  S TIEN=$O(@TREF@(TIEN)) Q:TIEN=""  D
 . S IEN=""
 . F  S IEN=$O(@GREF@("B",TIEN,IEN),-1) Q:IEN=""  D
 .. S TDFN=$$GET1^DIQ(FREF,IEN,.02,"I") I TDFN="" Q
 .. ;
 .. ; if the patient has already matched one of the general taxonomies, don't
 .. ; continue
 .. I $D(@TGLOB@(TDFN)) Q
 .. ;
 .. ; Get the visit pointer and check if it has been deleted
 .. S VISIT=$$GET1^DIQ(FREF,IEN,.03,"I") I VISIT="" Q
 .. I $$GET1^DIQ(9000010,VISIT,.11,"I")=1 Q
 .. I FREF=9000010.07,PRIM,$P(@GREF@(IEN,0),U,12)'="P" S OPRM=0 D  Q:'OPRM
 ... I $O(@GREF@("AD",VISIT,""))=IEN S OPRM=1
 .. ;
 .. ; Get the visit date/time and if a timeframe, check for validity
 .. S VSDTM=$$GET1^DIQ(9000010,VISIT,.01,"I")\1 I VSDTM=0 Q
 .. I $G(TMFRAME)'="",VSDTM<ENDT Q
 .. ; if service categories, check the visit for the service category
 .. S VSERV=$$GET1^DIQ(9000010,VISIT,.07,"I")
 .. I $G(SERV)'="",SERV'[VSERV Q
 .. ; Check if there is one value on the same day
 .. D ONE(TDFN,VSDTM)
 .. I $D(@TMREF@(TDFN,VSDTM)) Q
 .. ;
 .. ; If passed all checks, save for further checking
 .. S @TMREF@(TDFN)=$G(@TMREF@(TDFN))+1
 .. ;S @TMREF@(TDFN,VSDTM)=VISIT
 .. S @TMREF@(TDFN,VSDTM,TIEN)="V"_U_VISIT_U_EXDT_U_IEN_U_FREF_U_TAX
 ;
 ; if at least 90 days apart but no more than 2 years between
 ; first and last diagnosis
 S TDFN=""
 F  S TDFN=$O(@TMREF@(TDFN)) Q:TDFN=""  D AMI^BQITD031(TDFN,TGLOB,TMREF)
 ; 
 ;  Ischemic Heart Disease
 S TREF=$NA(^TMP("BQITAX",UID)),TMREF=$NA(^TMP("BQITMPD",UID))
 S TAX="BQI IHD DXS",FREF=9000010.07,GREF=$$ROOT^DILFD(FREF,"",1)
 S SERV="A;H",OPRM=0
 S TMFRAME="",EXDT="",DTDIF="",ENDT=""
 K @TREF,@TMREF
 ; Build the taxonomy global
 D BLD^BQITUTL(TAX,TREF)
 S TIEN="" F  S TIEN=$O(@TREF@(TIEN)) Q:TIEN=""  D
 . ;  Check for active problems
 . D PRB(TIEN,TMREF)
 ;
 ; For each entry in the taxonomy, find patients that match
 S TIEN="" F  S TIEN=$O(@TREF@(TIEN)) Q:TIEN=""  D
 . S IEN=""
 . F  S IEN=$O(@GREF@("B",TIEN,IEN),-1) Q:IEN=""  D
 .. S TDFN=$$GET1^DIQ(FREF,IEN,.02,"I") I TDFN="" Q
 .. ;
 .. ; if the patient has already matched one of the general taxonomies, don't
 .. ; continue
 .. I $D(@TGLOB@(TDFN)) Q
 .. ;
 .. ; Get the visit pointer and check if it has been deleted
 .. S VISIT=$$GET1^DIQ(FREF,IEN,.03,"I") I VISIT="" Q
 .. I $$GET1^DIQ(9000010,VISIT,.11,"I")=1 Q
 .. ; Identify clinical ranking (primary or 1st for visit)
 .. S OPRM=0
 .. I FREF=9000010.07 D
 ... I $P(@GREF@(IEN,0),U,12)="P" S OPRM=1 Q
 ... I $O(@GREF@("AD",VISIT,""))=IEN S OPRM=1
 .. ; Get the visit date/time and if a timeframe, check for validity
 .. S VSDTM=$$GET1^DIQ(9000010,VISIT,.01,"I")\1 I VSDTM=0 Q
 .. I $G(TMFRAME)'="",VSDTM<ENDT Q
 .. ;  if service categories, check the visit for the service category
 .. S VSERV=$$GET1^DIQ(9000010,VISIT,.07,"I")
 .. I $G(SERV)'="",SERV'[VSERV Q
 .. ; If passed all checks, save for further checking
 .. S @TMREF@(TDFN)=$G(@TMREF@(TDFN))+1
 .. S @TMREF@(TDFN,VSDTM,TIEN)="V"_U_VISIT_U_EXDT_U_IEN_U_FREF_U_TAX_U_OPRM
 ;
 ;  Check from temporary global if 3 different diagnoses on same day
 S TDFN=""
 F  S TDFN=$O(@TMREF@(TDFN)) Q:TDFN=""  D IHDSM^BQITD031(TDFN,TGLOB,TMREF)
 ; 
 ; 3 instances of any Ischemic Heart Disease
 S TREF=$NA(^TMP("BQITAX",UID)),TMREF=$NA(^TMP("BQITMPD",UID))
 S TAX="BQI IHD DXS",FREF=9000010.07,GREF=$$ROOT^DILFD(FREF,"",1)
 S SERV="A;H",OPRM=0
 S TMFRAME="",EXDT="",DTDIF="",ENDT=""
 K @TREF,@TMREF
 D BLD^BQITUTL(TAX,TREF)
 S TIEN="" F  S TIEN=$O(@TREF@(TIEN)) Q:TIEN=""  D
 . D PRB(TIEN,TMREF)
 S TIEN="" F  S TIEN=$O(@TREF@(TIEN)) Q:TIEN=""  D
 . S IEN=""
 . F  S IEN=$O(@GREF@("B",TIEN,IEN),-1) Q:IEN=""  D
 .. S TDFN=$$GET1^DIQ(FREF,IEN,.02,"I") I TDFN="" Q
 .. ;
 .. I $D(@TGLOB@(TDFN)) Q
 .. ;
 .. S VISIT=$$GET1^DIQ(FREF,IEN,.03,"I") I VISIT="" Q
 .. I $$GET1^DIQ(9000010,VISIT,.11,"I")=1 Q
 .. S VSDTM=$$GET1^DIQ(9000010,VISIT,.01,"I")\1 I VSDTM=0 Q
 .. I $G(TMFRAME)'="",VSDTM<ENDT Q
 .. ;  if service categories, check the visit for the service category
 .. S VSERV=$$GET1^DIQ(9000010,VISIT,.07,"I")
 .. I $G(SERV)'="",SERV'[VSERV Q
 .. I $P(@GREF@(IEN,0),U,12)'="P" S OPRM=0 D  Q:'OPRM
 ... I $O(@GREF@("AD",VISIT,""))=IEN S OPRM=1
 .. ;
 .. D ONE(TDFN,VSDTM)
 .. I $D(@TMREF@(TDFN,VSDTM)) Q
 .. ; If passed all checks, save for further checking
 .. S @TMREF@(TDFN)=$G(@TMREF@(TDFN))+1
 .. S @TMREF@(TDFN,VSDTM,TIEN)="V"_U_VISIT_U_EXDT_U_IEN_U_FREF_U_TAX
 ;
 S TDFN=""
 F  S TDFN=$O(@TMREF@(TDFN)) Q:TDFN=""  D IHD^BQITD031(TDFN,TGLOB,TMREF)
 ;
 ;  Multiple Instances of Known CVD
 S TREF=$NA(^TMP("BQITAX",UID)),TMREF=$NA(^TMP("BQITMPD",UID))
 K BQITRY,@TMREF
 S BQITRY(1)="BQI KNOWN CVD-MULT CPTS^9000010.18"
 S BQITRY(2)="BQI KNOWN CVD-MULT DXS^9000010.07^^^^1"
 S BQITRY(3)="BQI KNOWN CVD-MULT PROCEDURES^9000010.08"
 S SERV="A;H",OPRM=0
 S N=0 F  S N=$O(BQITRY(N)) Q:'N  D
 . K @TREF
 . S TAX=$P(BQITRY(N),U,1),FREF=$P(BQITRY(N),U,2),GREF=$$ROOT^DILFD(FREF,"",1)
 . S PLFLG=+$P(BQITRY(N),U,6),TMFRAME=$P(BQITRY(N),U,4),ENDT=""
 . D BLD^BQITUTL(TAX,TREF)
 . S TIEN="" F  S TIEN=$O(@TREF@(TIEN)) Q:TIEN=""  D
 .. I PLFLG D PRB(TIEN,TMREF)
 . S TIEN="" F  S TIEN=$O(@TREF@(TIEN)) Q:TIEN=""  D
 .. S IEN=""
 .. F  S IEN=$O(@GREF@("B",TIEN,IEN),-1) Q:IEN=""  D
 ... S TDFN=$$GET1^DIQ(FREF,IEN,.02,"I") I TDFN="" Q
 ... I $D(@TGLOB@(TDFN)) Q
 ... S VISIT=$$GET1^DIQ(FREF,IEN,.03,"I") I VISIT="" Q
 ... I $$GET1^DIQ(9000010,VISIT,.11,"I")=1 Q
 ... S VSDTM=$$GET1^DIQ(9000010,VISIT,.01,"I")\1 I VSDTM=0 Q
 ... I $G(TMFRAME)'="",VSDTM<ENDT Q
 ... I $P(@GREF@(IEN,0),U,12)'="P" S OPRM=0 D  Q:'OPRM
 .... I $O(@GREF@("AD",VISIT,""))=IEN S OPRM=1
 ... ;  if service categories, check the visit for the service category
 ... S VSERV=$$GET1^DIQ(9000010,VISIT,.07,"I")
 ... I $G(SERV)'="",SERV'[VSERV Q
 ... ;
 ... D ONE(TDFN,VSDTM)
 ... I $D(@TMREF@(TDFN,VSDTM)) Q
 ... S @TMREF@(TDFN)=$G(@TMREF@(TDFN))+1
 ... S @TMREF@(TDFN,VSDTM,TIEN)="V"_U_VISIT_U_EXDT_U_IEN_U_FREF_U_TAX
 ;
 ; at least 90 days apart but no more than 5 years
 ; between first and last
 S TDFN=""
 F  S TDFN=$O(@TMREF@(TDFN)) Q:TDFN=""  D IHD^BQITD031(TDFN,TGLOB,TMREF)
 ;
 K @TMREF,@TREF,BQITRY,TAX,NIT,FREF,FDX,LDX,VISIT,VSDTM,IEN,DFN
 K BQITRY,TIEN,TDFN,TREF,TMREF,VSDT,GREF,CT,N
 Q
 ;
PAT(DEF,BTGLOB,BDFN) ; EP -- By patient
 ;Description
 ;  Checks if a patient meets the criteria for CVD known
 ;Input
 ;  BDFN   - patient internal entry number
 ;  BTGLOB - Global to store results
 ;  DEF    - Diagnosis category definition
 ;Output
 ;  DXOK   - Diag category okay flag (if 1 then patient met the criteria)
 NEW DXOK,BQDXN,BQREF,DTDIF,ENDT,EXDT,PLFLG,PROB,TMFRAME,VTYP
 NEW PRIM,SERV,VSERV,OPRM
 S DXOK=0
 S BQDXN=$$GDXN^BQITUTL(DEF)
 S BQREF="BQIRY"
 D GDF^BQITUTL(BQDXN,BQREF)
 I $$PAT^BQITDGN(BQREF,BTGLOB,BDFN) Q 1
 ;
 ;  AMI Diagnosis check
 S TREF=$NA(^TMP("BQITAX",UID)),TMREF=$NA(^TMP("BQITMPD",UID))
 S TAX="BGP AMI DXS (HEDIS)",FREF=9000010.07,GREF=$$ROOT^DILFD(FREF,"",1)
 S PRIM=1,SERV="A;H"
 S TMFRAME="",ENDT=""
 K @TREF,@TMREF
 D BLD^BQITUTL(TAX,TREF)
 D PPRB(BDFN,TMREF)
 S IEN=""
 F  S IEN=$O(@GREF@("AC",BDFN,IEN),-1) Q:IEN=""  D
 . S TIEN=$$GET1^DIQ(FREF,IEN,.01,"I") I TIEN="" Q
 . Q:'$D(@TREF@(TIEN))
 . S VISIT=$$GET1^DIQ(FREF,IEN,.03,"I") I VISIT="" Q
 . I $$GET1^DIQ(9000010,VISIT,.11,"I")=1 Q
 . I FREF=9000010.07,PRIM,$P(@GREF@(IEN,0),U,12)'="P" S OPRM=0 D  Q:'OPRM
 .. I $O(@GREF@("AD",VISIT,""))=IEN S OPRM=1
 . S VSDTM=$$GET1^DIQ(9000010,VISIT,.01,"I")\1 I VSDTM=0 Q
 . I $G(TMFRAME)'="",VSDTM<ENDT Q
 . ;  if service categories, check the visit for the service category
 . S VSERV=$$GET1^DIQ(9000010,VISIT,.07,"I")
 . I $G(SERV)'="",SERV'[VSERV Q
 . D ONE(BDFN,VSDTM)
 . I $D(@TMREF@(BDFN,VSDTM)) Q
 . ;
 . S @TMREF@(BDFN)=$G(@TMREF@(BDFN))+1
 . S @TMREF@(BDFN,VSDTM,TIEN)="V"_U_VISIT_U_EXDT_U_IEN_U_FREF_U_TAX
 ;
 I $D(@TMREF@(BDFN)) D AMI^BQITD031(BDFN,BTGLOB,TMREF,.DXOK)
 K @TMREF,@TREF
 I DXOK Q DXOK
 ;
 ;  Ischemic Heart Disease
 S TREF=$NA(^TMP("BQITAX",UID)),TMREF=$NA(^TMP("BQITMPD",UID))
 S TAX="BQI IHD DXS",FREF=9000010.07,GREF=$$ROOT^DILFD(FREF,"",1)
 S TMFRAME="",ENDT="",SERV="A;H"
 K @TREF,@TMREF
 D BLD^BQITUTL(TAX,TREF)
 D PPRB(BDFN,TMREF)
 S IEN=""
 F  S IEN=$O(@GREF@("AC",BDFN,IEN),-1) Q:IEN=""  D
 . S TIEN=$$GET1^DIQ(FREF,IEN,.01,"I") I TIEN="" Q
 . ;
 . Q:'$D(@TREF@(TIEN))
 . ;
 . S VISIT=$$GET1^DIQ(FREF,IEN,.03,"I") I VISIT="" Q
 . I $$GET1^DIQ(9000010,VISIT,.11,"I")=1 Q
 . S OPRM=0
 . I FREF=9000010.07 D
 .. I $P(@GREF@(IEN,0),U,12)="P" S OPRM=1 Q
 .. I $O(@GREF@("AD",VISIT,""))=IEN S OPRM=1
 . S VSDTM=$$GET1^DIQ(9000010,VISIT,.01,"I")\1 I VSDTM=0 Q
 . I $G(TMFRAME)'="",VSDTM<ENDT Q
 . ;  if service categories, check visit for the service category
 . S VSERV=$$GET1^DIQ(9000010,VISIT,.07,"I")
 . I $G(SERV)'="",SERV'[VSERV Q
 . ;
 . S @TMREF@(BDFN,VSDTM,TIEN)="V"_U_VISIT_U_EXDT_U_IEN_U_FREF_U_TAX_U_OPRM
 . S @TMREF@(BDFN)=$G(@TMREF@(BDFN))+1
 ;
 ;  If 3 different diagnoses on the same date with at least one a primary
 I $D(@TMREF@(BDFN)) D IHDSM^BQITD031(BDFN,BTGLOB,TMREF,.DXOK)
 K @TMREF,@TREF
 I DXOK Q DXOK
 ;
 ; 3 instances of any Ischemic Heart Disease
 S TREF=$NA(^TMP("BQITAX",UID)),TMREF=$NA(^TMP("BQITMPD",UID))
 S TAX="BQI IHD DXS",FREF=9000010.07,GREF=$$ROOT^DILFD(FREF,"",1)
 S TMFRAME="",EXDT="",DTDIF="",ENDT=""
 K @TREF,@TMREF
 D BLD^BQITUTL(TAX,TREF)
 D PPRB(BDFN,TMREF)
 S IEN=""
 F  S IEN=$O(@GREF@("AC",BDFN,IEN),-1) Q:IEN=""  D
 . S TIEN=$$GET1^DIQ(FREF,IEN,.01,"I") I TIEN="" Q
 . Q:'$D(@TREF@(TIEN))
 . ;
 . S VISIT=$$GET1^DIQ(FREF,IEN,.03,"I") I VISIT="" Q
 . I $$GET1^DIQ(9000010,VISIT,.11,"I")=1 Q
 . I FREF=9000010.07 S OPRM=0 D  Q:'OPRM
 .. I $P(@GREF@(IEN,0),U,12)="P" S OPRM=1 Q
 .. I $O(@GREF@("AD",VISIT,""))=IEN S OPRM=1
 . S VSDTM=$$GET1^DIQ(9000010,VISIT,.01,"I")\1 I VSDTM=0 Q
 . I $G(TMFRAME)'="",VSDTM<ENDT Q
 . ;  if service categories, check visit for service category
 . S VSERV=$$GET1^DIQ(9000010,VISIT,.07,"I")
 . I $G(SERV)'="",SERV'[VSERV Q
 . D ONE(BDFN,VSDTM)
 . I $D(@TMREF@(BDFN,VSDTM)) Q
 . S @TMREF@(BDFN)=$G(@TMREF@(BDFN))+1
 . S @TMREF@(BDFN,VSDTM,TIEN)="V"_U_VISIT_U_EXDT_U_IEN_U_FREF_U_TAX
 ;
 I $D(@TMREF@(BDFN)) D IHD^BQITD031(BDFN,BTGLOB,TMREF,.DXOK)
 K @TMREF,@TREF
 I DXOK Q DXOK
 ;
 ;  Multiple Instances of Known CVD
 S TREF=$NA(^TMP("BQITAX",UID)),TMREF=$NA(^TMP("BQITMPD",UID))
 K @TMREF,BQITRY
 S BQITRY(1)="BQI KNOWN CVD-MULT CPTS^9000010.18"
 S BQITRY(2)="BQI KNOWN CVD-MULT DXS^9000010.07^^^^1"
 S BQITRY(3)="BQI KNOWN CVD-MULT PROCEDURES^9000010.08"
 S N=0 F  S N=$O(BQITRY(N)) Q:'N  D
 . K @TREF
 . S TAX=$P(BQITRY(N),U,1),FREF=$P(BQITRY(N),U,2)
 . S GREF=$$ROOT^DILFD(FREF,"",1),PLFLG=+$P(BQITRY(N),U,6)
 . S TMFRAME=$P(BQITRY(N),U,4),ENDT=""
 . D BLD^BQITUTL(TAX,TREF)
 . I PLFLG D PPRB(BDFN,TMREF)
 . S IEN=""
 . F  S IEN=$O(@GREF@("AC",BDFN,IEN),-1) Q:IEN=""  D
 .. S TIEN=$$GET1^DIQ(FREF,IEN,.01,"I") I TIEN="" Q
 .. I '$D(@TREF@(TIEN)) Q
 .. S VISIT=$$GET1^DIQ(FREF,IEN,.03,"I") I VISIT="" Q
 .. I $$GET1^DIQ(9000010,VISIT,.11,"I")=1 Q
 .. I FREF=9000010.07 S OPRM=0 D  Q:'OPRM
 ... I $P(@GREF@(IEN,0),U,12)="P" S OPRM=1 Q
 ... I $O(@GREF@("AD",VISIT,""))=IEN S OPRM=1
 .. S VSDTM=$$GET1^DIQ(9000010,VISIT,.01,"I")\1 I VSDTM=0 Q
 .. I $G(TMFRAME)'="",VSDTM<ENDT Q
 .. ;  if service categories, check the visit for the service category
 .. S VSERV=$$GET1^DIQ(9000010,VISIT,.07,"I")
 .. I $G(SERV)'="",SERV'[VSERV Q
 .. D ONE(BDFN,VSDTM)
 .. I $D(@TMREF@(BDFN,VSDTM)) Q
 .. ;
 .. S @TMREF@(BDFN)=$G(@TMREF@(BDFN))+1
 .. S @TMREF@(BDFN,VSDTM,TIEN)="V"_U_VISIT_U_EXDT_U_IEN_U_FREF_U_TAX
 ;
 ; at least 90 days apart but no more than 5 years
 ; between first and last
 I $D(@TMREF@(BDFN)) D IHD^BQITD031(BDFN,BTGLOB,TMREF,.DXOK)
 K @TREF,@TMREF
 Q DXOK
 ;
PRB(PVIEN,TPGLOB) ;  EP - Check Problem File for instance of taxonomy
 ;  Input
 ;     PVIEN - Taxonomy entry
 ;     TPGLOB - Problem file temporary global reference
 ;     Call BQITD031 due to routine size considerations
 D PRB^BQITD031
 Q
 ;
PPRB(DFN,TPGLOB) ;EP - Check Problem File for instance of a patient
 ; Input Parameters
 ;   DFN - Patient record
 ;   TPGLOB - Temporary global
 ;     Call BQITD031 due to routine size considerations
 D PPRB^BQITD031
 Q
 ;
ONE(DFN,VSDTM) ; If there was a visit and a problem on the same day, count the visit
 I $D(@TMREF@(DFN,VSDTM)),$$TYP^BQITD031(DFN,VSDTM,TMREF)="P" D  Q
 . K @TMREF@(DFN,VSDTM)
 . S @TMREF@(DFN)=$G(@TMREF@(DFN))-1
 Q
