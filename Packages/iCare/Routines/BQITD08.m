BQITD08 ;PRXM/HC/ALA-HIV/AIDS ; 02 Mar 2006  1:17 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 Q
 ;
POP(BQARY,TGLOB) ; EP -- By population
 ;
 ;Description
 ;  Finds all patients who meet the criteria for HIV/AIDS
 ;Input
 ;  BQARY - Array of taxonomies and other information
 ;  TGLOB - Global where data is to be stored and passed back
 ;          to calling routine
 ;          Structure:
 ;          TGLOB(DFN,"CRITERIA",criteria or taxonomy,visit or problem ien)=date/time
 ;Variables
 ;  TAX - Taxonomy name
 ;  NIT - Number of iterations
 ;  TMFRAME - Time frame of check
 ;  FREF - File Number reference
 ;  PLFLG - Problem File flag
 ;  GREF - Global reference
 ;  TREF - Taxonomy temp reference
 ;
 ;  Clean up all current entries
 NEW DXNN,TDFN,DA,DIK,RGIEN
 NEW PRIM,SERV,VSERV,OPRM
 ;
 N TAX,FREF,GREF,TMFRAME,EXDT,DTDIF,ENDT,TIEN,IEN,TDFN,VISIT
 ;One diagnosis on Active Problem List (for POP)
 S TMFRAME="",EXDT="",DTDIF="",ENDT=""
 S FREF=9000010.07,GREF=$$ROOT^DILFD(FREF,"",1)
 S TREF=$NA(^TMP("BQITAX",UID)),TMREF=$NA(^TMP("BQITMPD",UID))
 K @TREF,@TMREF
 S TAX="BGP HIV/AIDS DXS"
 S PRIM=1,SERV="A;H"
 D BLD^BQITUTL(TAX,TREF)
 ;  For each entry in the taxonomy reference check problem file
 S TIEN=0
 F  S TIEN=$O(@TREF@(TIEN)) Q:'TIEN  D PRB^BQITDGN(TIEN,.TGLOB)
 ;
 ; At least 2 POVs ever at least 60 days apart (for POP)
 ;    Note: BGP HIV/AIDS DX taxonomy data already loaded in TREF
 D GETVST ; Get related visit data and set up criteria in temporary file
 S TDFN=""
 F  S TDFN=$O(@TMREF@(TDFN)) Q:TDFN=""  D
 . Q:$D(@TGLOB@(TDFN))  ; Patient already identified
 . D POV^BQITD081(TDFN,TGLOB,TMREF)
 ;
 ; At least 2 CD4/Viral Load lab tests in the past two years
 ; at least 60 days apart (for POP)
 N N
 K BQITRY,@TMREF
 S BQITRY(1)="BGP CD4 TAX^9000010.09^^T-24M"
 S BQITRY(2)="BGP CD4 CPTS^9000010.18^^T-24M"
 S BQITRY(3)="BGP CD4 LOINC CODES^9000010.09^^T-24M"
 S BQITRY(4)="BGP HIV VIRAL LOAD TAX^9000010.09^^T-24M"
 S BQITRY(5)="BGP HIV VIRAL LOAD CPTS^9000010.18^^T-24M"
 S BQITRY(6)="BGP VIRAL LOAD LOINC CODES^9000010.09^^T-24M"
 S N=0
 F  S N=$O(BQITRY(N)) Q:'N  D
 . K @TREF
 . S TAX=$P(BQITRY(N),U,1),FREF=$P(BQITRY(N),U,2),GREF=$$ROOT^DILFD(FREF,"",1)
 . S TMFRAME=$P(BQITRY(N),U,4),ENDT=""
 . D BLD^BQITUTL(TAX,TREF)
 . D GETVST ; Get related visit data and set up criteria in temporary file
 S TDFN=""
 F  S TDFN=$O(@TMREF@(TDFN)) Q:TDFN=""  D
 . Q:$D(@TGLOB@(TDFN))  ; Patient already identified
 . D CDVL^BQITD081(TDFN,TGLOB,TMREF)
 K @TMREF
 ;
 ; Positive HIV Screening (for POP)
 S FREF=9000010.09,GREF=$$ROOT^DILFD(FREF,"",1),TREF=$NA(^TMP("BQITAX",UID))
 K @TREF
 S TAX="BGP HIV TEST TAX" D BLD^BQITUTL(TAX,TREF)
 S TIEN=0
 F  S TIEN=$O(@TREF@(TIEN)) Q:'TIEN  D
 . S IEN=""
 . F  S IEN=$O(@GREF@("B",TIEN,IEN),-1) Q:IEN=""  D
 .. I $G(@GREF@(IEN,0))="" Q
 .. S DFN=$$GET1^DIQ(FREF,IEN,.02,"I") Q:DFN=""
 .. I $D(@TGLOB@(DFN)) Q  ; Patient already identified
 .. S VISIT=$$GET1^DIQ(FREF,IEN,.03,"I") Q:VISIT=""
 .. I $$GET1^DIQ(9000010,VISIT,.11,"I")=1 Q
 .. I FREF=9000010.07,PRIM,$P(@GREF@(IEN,0),U,12)'="P" S OPRM=0 D  Q:'OPRM
 ... I $O(@GREF@("AD",VISIT,""))=IEN S OPRM=1
 .. S VSDTM=$$GET1^DIQ(9000010,VISIT,.01,"I")\1 I VSDTM=0 Q
 .. I $G(TMFRAME)'="",VSDTM<ENDT Q
 .. ; If service categories, check the visit for the service category
 .. S VSERV=$$GET1^DIQ(9000010,VISIT,.07,"I")
 .. I $G(SERV)'="",SERV'[VSERV Q
 .. S VSDTM=$$GET1^DIQ(9000010,VISIT,.01,"I")\1 Q:'VSDTM
 .. I $G(TMFRAME)'="",VSDTM<ENDT Q
 .. S RESULT=$$GET1^DIQ(FREF,IEN,.04,"E")
 .. I $$POSITIVE^BKMVF32(RESULT) D STOR(DFN,"Positive HIV Screening",VISIT,IEN,TGLOB) Q
 K @TREF
 Q
 ;
 ;
PAT(DEF,BTGLOB,BDFN) ;EP -- By patient
 NEW DXOK ;,BQDXN,BQREF
 NEW PRIM,SERV,VSERV,OPRM
 S DXOK=0
 ;
 N TAX,FREF,GREF,TMFRAME,EXDT,DTDIF,ENDT,TRIEN,IEN,TDFN,VISIT
 ;One diagnosis on Active Problem List (for PAT)
 S TMFRAME="",EXDT="",DTDIF="",ENDT=""
 S FREF=9000010.07,GREF=$$ROOT^DILFD(FREF,"",1),TREF=$NA(^TMP("BQITAX",UID))
 K @TREF
 S TAX="BGP HIV/AIDS DXS"
 S PRIM=1,SERV="A;H"
 S TPRGL=$NA(^TMP("TPRBLM",UID)) K @TPRGL
 NEW TPGLOB
 S TPGLOB=BTGLOB
 D BLD^BQITUTL(TAX,TREF)
 D PPRB^BQITDGN(BDFN,TPRGL)
 I $D(@TPRGL@(BDFN))>0,'$D(@BTGLOB@(BDFN)) M @BTGLOB@(BDFN)=@TPRGL@(BDFN) Q 1
 ;  For each entry in the taxonomy reference
 ;S TRIEN=0
 ;F  S TRIEN=$O(@TREF@(TRIEN)) Q:'TRIEN  D  I $D(@BTGLOB@(BDFN)) Q
 ;. D PPRB^BQITDGN(BDFN,.BTGLOB)
 ;I $D(@BTGLOB@(BDFN)) Q 1  ; Patient already identified
 ;
 ; At least 2 POVs ever at least 60 days apart (for PAT)
 S TMREF=$NA(^TMP("BQITMPD",UID))
 K @TMREF
 N TIEN
 S IEN=""
 F  S IEN=$O(@GREF@("AC",BDFN,IEN),-1) Q:IEN=""  D
 . S TIEN=$$GET1^DIQ(FREF,IEN,.01,"I") I TIEN="" Q
 . I '$D(@TREF@(TIEN)) Q
 . S VISIT=$$GET1^DIQ(FREF,IEN,.03,"I") I VISIT="" Q
 . I $$GET1^DIQ(9000010,VISIT,.11,"I")=1 Q
 . I FREF=9000010.07,PRIM,$P(@GREF@(IEN,0),U,12)'="P" S OPRM=0 D  Q:'OPRM
 .. I $O(@GREF@("AD",VISIT,""))=IEN S OPRM=1
 . S VSDTM=$$GET1^DIQ(9000010,VISIT,.01,"I")\1 I VSDTM=0 Q
 . I $G(TMFRAME)'="",VSDTM<ENDT Q
 . ; If service categories, check the visit for the service category
 . S VSERV=$$GET1^DIQ(9000010,VISIT,.07,"I")
 . I $G(SERV)'="",SERV'[VSERV Q
 . I $D(@TMREF@(BDFN,VSDTM)) Q
 . ;
 . S @TMREF@(BDFN)=$G(@TMREF@(BDFN))+1
 . S @TMREF@(BDFN,VSDTM,TIEN)="V"_U_VISIT_U_EXDT_U_IEN_U_FREF_U_TAX
 ;
 I $D(@TMREF@(BDFN)) D POV^BQITD081(BDFN,BTGLOB,TMREF,.DXOK)
 K @TREF,@TMREF
 I DXOK Q DXOK
 ;
 ; At least 2 CD4/Viral Load lab tests in the past two years
 ; at least 60 days apart (for PAT)
 N N
 S TMREF=$NA(^TMP("BQITMPD",UID))
 K @TMREF,BQITRY
 S BQITRY(1)="BGP CD4 TAX^9000010.09^^T-24M"
 S BQITRY(2)="BGP CD4 CPTS^9000010.18^^T-24M"
 S BQITRY(3)="BGP CD4 LOINC CODES^9000010.09^^T-24M"
 S BQITRY(4)="BGP HIV VIRAL LOAD TAX^9000010.09^^T-24M"
 S BQITRY(5)="BGP HIV VIRAL LOAD CPTS^9000010.18^^T-24M"
 S BQITRY(6)="BGP VIRAL LOAD LOINC CODES^9000010.09^^T-24M"
 S N=0
 F  S N=$O(BQITRY(N)) Q:'N  D
 . K @TREF
 . S TAX=$P(BQITRY(N),U,1),FREF=$P(BQITRY(N),U,2)
 . S GREF=$$ROOT^DILFD(FREF,"",1),PLFLG=+$P(BQITRY(N),U,6)
 . S TMFRAME=$P(BQITRY(N),U,4),ENDT=""
 . D BLD^BQITUTL(TAX,TREF)
 . S IEN=""
 . F  S IEN=$O(@GREF@("AC",BDFN,IEN),-1) Q:IEN=""  D
 .. S TIEN=$$GET1^DIQ(FREF,IEN,.01,"I") I TIEN="" Q
 .. I '$D(@TREF@(TIEN)) Q
 .. S VISIT=$$GET1^DIQ(FREF,IEN,.03,"I") I VISIT="" Q
 .. I $$GET1^DIQ(9000010,VISIT,.11,"I")=1 Q
 .. I FREF=9000010.07,PRIM,$P(@GREF@(IEN,0),U,12)'="P" S OPRM=0 D  Q:'OPRM
 ... I $O(@GREF@("AD",VISIT,""))=IEN S OPRM=1
 .. S VSDTM=$$GET1^DIQ(9000010,VISIT,.01,"I")\1 I VSDTM=0 Q
 .. I $G(TMFRAME)'="",VSDTM<ENDT Q
 .. ; If service categories, check the visit for the service category
 .. S VSERV=$$GET1^DIQ(9000010,VISIT,.07,"I")
 .. I $G(SERV)'="",SERV'[VSERV Q
 .. I $D(@TMREF@(BDFN,VSDTM)) Q
 .. ;
 .. S @TMREF@(BDFN)=$G(@TMREF@(BDFN))+1
 .. S @TMREF@(BDFN,VSDTM,TIEN)="V"_U_VISIT_U_EXDT_U_IEN_U_FREF_U_TAX
 ;
 I $D(@TMREF@(BDFN)) D CDVL^BQITD081(BDFN,BTGLOB,TMREF,.DXOK)
 K @TREF,@TMREF
 I DXOK Q DXOK
 ;
 ;Positive HIV Screening (for PAT)
 S FREF=9000010.09,GREF=$$ROOT^DILFD(FREF,"",1),TREF=$NA(^TMP("BQITAX",UID))
 S TAX="BGP HIV TEST TAX" D
 . K @TREF
 . D BLD^BQITUTL(TAX,TREF)
 . S IEN=""
 . F  S IEN=$O(@GREF@("AC",BDFN,IEN),-1) Q:IEN=""  D  Q:DXOK
 .. S TIEN=$$GET1^DIQ(FREF,IEN,.01,"I") Q:TIEN=""
 .. I '$D(@TREF@(TIEN)) Q
 .. S VISIT=$$GET1^DIQ(FREF,IEN,.03,"I") Q:VISIT=""
 .. I $$GET1^DIQ(9000010,VISIT,.11,"I")=1 Q
 .. I FREF=9000010.07,PRIM,$P(@GREF@(IEN,0),U,12)'="P" S OPRM=0 D  Q:'OPRM
 ... I $O(@GREF@("AD",VISIT,""))=IEN S OPRM=1
 .. S VSDTM=$$GET1^DIQ(9000010,VISIT,.01,"I")\1 Q:'VSDTM
 .. I $G(TMFRAME)'="",VSDTM<ENDT Q
 .. ; If service categories, check the visit for the service category
 .. S VSERV=$$GET1^DIQ(9000010,VISIT,.07,"I")
 .. I $G(SERV)'="",SERV'[VSERV Q
 .. S RESULT=$$GET1^DIQ(FREF,IEN,.04,"E")
 .. I $$POSITIVE^BKMVF32(RESULT) D
 ... D STOR(BDFN,"Positive HIV Screening",VISIT,IEN,BTGLOB)
 ... S DXOK=1
 Q DXOK
 ;
STOR(SDFN,CRIT,VIENS,IENS,GLOB) ;  Store the patient's met criteria
 NEW VST,I,VSDTM,IIEN
 I $G(@GLOB@(SDFN))>3 Q
 I $D(@GLOB@(SDFN,"CRITERIA",CRIT))>0 Q
 S @GLOB@(SDFN)=$G(@GLOB@(SDFN))+1
 S @GLOB@(SDFN,"CRITERIA",CRIT)=""
 I $G(VIENS)["," D  Q
 . F I=1:1 S VST=$P(VIENS,",",I) Q:VST=""  D
 .. S IIEN=$P(IENS,",",I)
 .. S VSDTM=$$GET1^DIQ(9000010,VST_",",.01,"I") Q:'VSDTM
 .. I DTDIF'="" S EXDT=$$FMADD^XLFDT(VSDTM,DTDIF)
 .. S @GLOB@(SDFN,"CRITERIA",CRIT,"V",VST,IIEN)=VSDTM_U_U_IIEN_U_FREF
 .. I EXDT'="" S $P(@GLOB@(SDFN,"CRITERIA",CRIT,"V",VST,IIEN),U,2)=EXDT
 I $G(VIENS)'="" D
 . S VSDTM=$$GET1^DIQ(9000010,VIENS_",",.01,"I") Q:'VSDTM
 . I DTDIF'="" S EXDT=$$FMADD^XLFDT(VSDTM,DTDIF)
 . S @GLOB@(SDFN,"CRITERIA",CRIT,"V",VIENS,IENS)=VSDTM_U_U_IENS_U_FREF
 . I EXDT'="" S $P(@GLOB@(SDFN,"CRITERIA",CRIT,"V",VIENS,IENS),U,2)=EXDT
 Q
 ;
GETVST ; EP - Get visit related data
 S TIEN="",PRIM=1
 F  S TIEN=$O(@TREF@(TIEN)) Q:TIEN=""  D
 . S IEN=""
 . F  S IEN=$O(@GREF@("B",TIEN,IEN),-1) Q:IEN=""  D
 .. S TDFN=$$GET1^DIQ(FREF,IEN,.02,"I") I TDFN="" Q
 .. I $D(@TGLOB@(TDFN)) Q
 .. S VISIT=$$GET1^DIQ(FREF,IEN,.03,"I") I VISIT="" Q
 .. I $$GET1^DIQ(9000010,VISIT,.11,"I")=1 Q
 .. I FREF=9000010.07,PRIM,$P(@GREF@(IEN,0),U,12)'="P" S OPRM=0 D  Q:'OPRM
 ... I $O(@GREF@("AD",VISIT,""))=IEN S OPRM=1
 .. S VSDTM=$$GET1^DIQ(9000010,VISIT,.01,"I")\1 I VSDTM=0 Q
 .. I $G(TMFRAME)'="",VSDTM<ENDT Q
 .. ; If service categories, check the visit for the service category
 .. S VSERV=$$GET1^DIQ(9000010,VISIT,.07,"I")
 .. I $G(SERV)'="",SERV'[VSERV Q
 .. ;
 .. I $D(@TMREF@(TDFN,VSDTM)) Q
 .. S @TMREF@(TDFN)=$G(@TMREF@(TDFN))+1
 .. S @TMREF@(TDFN,VSDTM,TIEN)="V"_U_VISIT_U_EXDT_U_IEN_U_FREF_U_TAX
 Q
