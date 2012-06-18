BQIDCAH ;PRXM/HC/ALA-Ad Hoc Search ; 16 Nov 2005  6:26 PM
 ;;2.2;ICARE MANAGEMENT SYSTEM;;Jul 28, 2011;Build 37
 ;
 Q
 ;
PARMS(DATA,FGLOB,PARMS,MPARMS,APARMS,MAPARMS) ;EP -  Execute Ad Hoc Search
 ;
 ;Description
 ;  Ad Hoc Search which can be an assortment of parameters including;
 ;  GENDER, COMMUNITY, PROVIDER, VISIT DATES, AGE
 ;Input
 ;  FGLOB = From global (only sent for filters)
 ;  PARMS = Array of parameters and their values
 ;  MPARMS = Multiple array of a parameter
 ;Expected to return DATA
 ;
 NEW JJ,KK,UID,TGLOB,SEX,COMM,PROV,FROM,THRU,AGE,CRIT1
 NEW CRIT2,NM,DXCAT,PLIDEN,NUMVIS,COMMTX,BEN,VDATA,VNDATA,VODATA
 NEW CLIN,DXOP,RANGE,RFROM,RTHRU,DEC,DECDT,BNEW,VCRIT1,VCRIT2,DECFDT,DECTDT
 NEW ALLERGY,ALLOP
 ;
 I '$D(PARMS),'$D(MPARMS),'$D(APARMS),'$D(MAPARMS) Q
 S NM=""
 F  S NM=$O(PARMS(NM)) Q:NM=""  S @NM=PARMS(NM)
 ;
 S SEX=$G(SEX,""),COMM=$G(COMM,"")
 S FROM=$G(FROM,""),THRU=$G(THRU,""),FGLOB=$G(FGLOB,"")
 S DXCAT=$G(DXCAT,""),PLIDEN=$G(PLIDEN,"")
 S BEN=$G(BEN,"") ; Beneficiary
 S DXOP=$G(DXOP,"!")
 S VISOP=$G(VISOP,"!")
 S RANGE=$G(RANGE,"")
 S DEC=$G(DEC,"N"),DECDT=$G(DECDT,"") ; Deceased
 S LIV=$G(LIV,"Y") ; Living
 S INAC=$G(INAC,"N") ; Inactive patients
 S DECFDT=$G(DECFDT,""),DECTDT=$G(DECTDT,"") ;Deceased Date Range
 S ALLERGY=$G(ALLERGY,""),ALLOP=$G(ALLOP,"!")
 ;
 ; If timeframe is selected populate start and end dates
 I RANGE'="",$G(PPIEN)'="" D RANGE(RANGE,PPIEN)
 ;
 S RFROM=$G(RFROM,""),RTHRU=$G(RTHRU,"")
 S FROM=$S($G(RFROM)'="":RFROM,1:$G(FROM))
 S THRU=$S($G(RTHRU)'="":RTHRU,1:$G(THRU))
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 F KK=0:1:10 K ^TMP("BQITO"_KK,UID)
 S VDATA=$NA(^TMP("BQIAVIS",UID)),VNDATA=$NA(^TMP("BQINOVIS",UID))
 S VODATA=$NA(^TMP("BQIOTHVIS",UID))
 K @VDATA,@VNDATA,@VODATA
 ;
 S JJ=0
 S TGLOB=$NA(^TMP("BQITO"_JJ,UID))
 ;
 ;Alternate cross-reference test
 ;I $G(FROM)'="",$G(PROV)'="" D PRVS^BQIDCAH2(TGLOB,PROV,FROM,THRU),UPD
 ;
 I $G(PLIDEN)'=""!$D(MPARMS("PLIDEN")) D PNL(FGLOB,TGLOB,PLIDEN,.MPARMS),UPD
 ;
 I $G(DXCAT)'=""!$D(MPARMS("DXCAT")) D DIAG^BQIDCAH1(FGLOB,TGLOB,DXCAT,.MPARMS),UPD
 ;
 I $G(FROM)'="" D VIS^BQIDCAH2(FGLOB,TGLOB,FROM,THRU,.MAPARMS),UPD
 I $G(FROM)="",$G(RANGE)'="" D VIS^BQIDCAH2(FGLOB,TGLOB,FROM,THRU,.MAPARMS),UPD
 ;
 ;I $G(PROV)'="" D PROV^BQIDCAH2(FGLOB,TGLOB,PROV),UPD
 ;
 I $G(COMM)'=""!$D(MPARMS("COMM")) D COMM(FGLOB,TGLOB,COMM,.MPARMS),UPD
 ;
 I $G(COMMTX)'=""!$D(MPARMS("COMMTX")) D
 . N COM,COMLST,IEN,PCOMM
 . I $G(COMMTX)'="" D COMMTX(COMMTX,.COMLST)
 . I $D(MPARMS("COMMTX")) D
 .. S COM=""
 .. F  S COM=$O(MPARMS("COMMTX",COM)) Q:COM=""  D COMMTX(COM,.COMLST)
 . I $G(FGLOB)="" D
 .. S COM=""
 .. F  S COM=$O(COMLST(COM)) Q:COM=""  D COMM(FGLOB,TGLOB,COM,.MPARMS)
 . I $G(FGLOB)'="",$D(COMLST) D
 .. S IEN=0
 .. F  S IEN=$O(@FGLOB@(IEN)) Q:'IEN  D
 ... S PCOMM=$P($G(^AUPNPAT(IEN,11)),U,18)
 ... Q:PCOMM=""
 ... I $D(COMLST(PCOMM)) S @TGLOB@(IEN)=""
 . D UPD
 ;
 I $G(BEN)'=""!$D(MPARMS("BEN")) D BEN^BQIDCAH1(FGLOB,TGLOB,BEN,.MPARMS),UPD
 ;
 I $G(ALLERGY)'=""!$D(MPARMS("ALLERGY")) D ALGY^BQIDCAH2(FGLOB,TGLOB,ALLERGY,.MPARMS),UPD
 ;
 I $G(SEX)'="" D GEN(FGLOB,TGLOB,SEX),UPD
 ;
 ; If age is a single value then that is criteria 1 and criteria 2 is blank
 I $G(AGE)'="" D
 . S CRIT1=AGE,CRIT2=""
 . D AGE(FGLOB,TGLOB,CRIT1,CRIT2),UPD
 ;
 ; If age is a multiple value then criteria 1 is the first and criteria 2 is the second MPARMS("AGE",#)
 I $D(MPARMS("AGE")) D
 . NEW N
 . S N="",N=$O(MPARMS("AGE",N)),CRIT1=N
 . S N=$O(MPARMS("AGE",N)) I N'="" S CRIT2=N
 . S CRIT1=$G(CRIT1,""),CRIT2=$G(CRIT2,"")
 . D AGE(FGLOB,TGLOB,CRIT1,CRIT2),UPD
 ;
 D STAT(FGLOB,TGLOB,LIV,DEC,INAC),UPD
 ;
 I $D(@TGLOB)>0 D
 . S DATA=$NA(^TMP("BQIAHOC",UID))
 . K @DATA
 . S IEN="" F  S IEN=$O(@TGLOB@(IEN)) Q:IEN=""  S @DATA@(IEN)=""
 ;
 I $D(@TGLOB)'>0,$G(FGLOB)'="" D
 . S DATA=$NA(^TMP("BQIAHOC",UID))
 . K @DATA
 . S IEN="" F  S IEN=$O(@FGLOB@(IEN)) Q:IEN=""  S @DATA@(IEN)=""
 F KK=0:1:JJ K ^TMP("BQITO"_KK,UID)
 K @VDATA,@VODATA
 Q
 ;
UPD ;EP
 S JJ=JJ+1,FGLOB=TGLOB,TGLOB=$NA(^TMP("BQITO"_JJ,UID))
 Q
 ;
AGE(FGLOB,TGLOB,CRIT1,CRIT2) ;EP - Age search
 I $G(TGLOB)="" Q
 I $G(CRIT1)="" Q
 ;
 NEW IEN,AGE,DOD
 S IEN=0
 I $G(FGLOB)'="" D
 . F  S IEN=$O(@FGLOB@(IEN)) Q:'IEN  D ACHK^BQIDCAH1(.IEN)
 ;
 I $G(FGLOB)="" D
 . F  S IEN=$O(^AUPNPAT(IEN)) Q:'IEN  D ACHK^BQIDCAH1(.IEN)
 Q
 ;
GEN(FGLOB,TGLOB,GEN) ;EP - Gender search
 I $G(TGLOB)="" Q
 I $G(GEN)="" Q
 ;
 NEW IEN
 S IEN=0
 I $G(FGLOB)'="" D
 . F  S IEN=$O(@FGLOB@(IEN)) Q:'IEN  D GCHK
 ;
 I $G(FGLOB)="" D
 . F  S IEN=$O(^AUPNPAT(IEN)) Q:'IEN  D GCHK
 Q
 ;
GCHK ;  Gender check
 I $P($G(^DPT(IEN,0)),U,2)'=GEN Q
 S @TGLOB@(IEN)=""
 Q
 ;
COMM(FGLOB,TGLOB,COM,MPARMS) ;EP - Community search
 I $G(TGLOB)="" Q
 I $G(COM)]"" D COMM1
 I $D(MPARMS("COMM")) S COM="" F  S COM=$O(MPARMS("COMM",COM)) Q:COM=""  D COMM1
 Q
 ;
COMM1 ;
 ; Get Community Name and use x-ref for speed improvement.
 ; If community ien is passed use it to determine if patient community matches ***
 NEW COMM,COMMNM ;***
 S (COMM,COMMNM)=COM ;***
 I COMM?1.N S COMMNM=$$GET1^DIQ(9999999.05,COM,.01,"E") ;***
 ;
 NEW IEN
 S IEN=0
 I $G(FGLOB)'="" D
 . F  S IEN=$O(@FGLOB@(IEN)) Q:'IEN  D
 .. I COMM?.N,$P($G(^AUPNPAT(IEN,11)),U,17)'=COMM Q  ;***
 .. I COMM'?.N,$P($G(^AUPNPAT(IEN,11)),U,18)'=COMMNM Q  ;***
 .. S @TGLOB@(IEN)=""
 ;
 I $G(FGLOB)="" D
 . F  S IEN=$O(^AUPNPAT("AC",COMMNM,IEN)) Q:IEN=""  D
 .. ;I $P($G(^AUPNPAT(IEN,41,DUZ(2),0)),U,3)'="" Q
 .. I COMM?.N,$P($G(^AUPNPAT(IEN,11)),U,17)'=COMM Q  ;***
 .. S @TGLOB@(IEN)=""
 Q
 ;
COMMTX(TAX,COML) ;EP
 ; Get a list of communities for the specified community taxonomy
 I $G(TAX)="" Q
 N TAXNM,COMM,IEN
 I TAX'?.N S TAXNM=TAX,TAX=$O(^ATXAX("B",TAXNM,"")) I TAX=""!($O(^ATXAX("B",TAXNM,TAX))'="") Q
 ; Currently CRS only uses community names and matches these to the patient's
 ; community without regard to state, etc.
 S COMM=""
 F  S COMM=$O(^ATXAX(TAX,21,"B",COMM)) Q:COMM=""  D
 . I '$D(^AUTTCOM("B",COMM)) Q
 . S COML(COMM)=""
 Q
 ;
VIS(FGLOB,TGLOB,FDT,TDT) ;EP - Visit search
 I $G(TGLOB)="" Q
 ;
 NEW DFN,IEN,RIEN,CLNFLG,PRVFLG,VCLIN,PRIEN,VPRV,OK,NOVST
 S IEN=0
 S CLNFLG=$S($D(MPARMS("CLIN")):1,$G(CLIN)'="":1,1:0)
 S PRVFLG=$G(PROV)'=""
 ;
 F  S FDT=$O(^AUPNVSIT("B",FDT)) Q:FDT=""!(FDT\1>TDT)  D
 . S RIEN=""
 . F  S RIEN=$O(^AUPNVSIT("B",FDT,RIEN)) Q:'RIEN  D
 .. ; If the visit is deleted, quit
 .. I $$GET1^DIQ(9000010,RIEN_",",.11,"I")=1 Q
 .. S DFN=$$GET1^DIQ(9000010,RIEN_",",.05,"I") I DFN="" Q
 .. ;
 .. I $G(FGLOB)'="",'$D(@FGLOB@(DFN)) Q
 .. S @TGLOB@(DFN)=$G(@TGLOB@(DFN))+1,@VODATA@(DFN)=""
 .. S @VDATA@(RIEN)=DFN
 .. I CLNFLG D  ;Find associated clinic
 ... S VCLIN=$$GET1^DIQ(9000010,RIEN_",",.08,"I")
 ... I VCLIN'="" S @VODATA@(DFN,"CLN",VCLIN)=$G(@VODATA@(DFN,"CLN",VCLIN))+1
 .. I PRVFLG D  ;Find associated providers
 ... S PRIEN="" F  S PRIEN=$O(^AUPNVPRV("AD",RIEN,PRIEN)) Q:PRIEN=""  D
 .... S VPRV=$$GET1^DIQ(9000010.06,PRIEN_",",.01,"I") Q:VPRV=""
 .... ;S @VODATA@(DFN,"PRV",VPRV)=""
 .... S @VODATA@(DFN,"PRV",VPRV)=$G(@VODATA@(DFN,"PRV",VPRV))+1
 ;
 ;NOVST = flag to check for patients with no visits in the range
 ;      = 2 ... only check for patients with no visits in the range
 ;      = 1 ... check for patients with number of visits as well as no visits in the range
 ;      = 0 ... do not check for patients with no visits in the range
 ;
 S NOVST=0
 ;
 S BNEW=0 ;Temporary addition to work with old and new pre-GUI
 I $G(NUMVIS)'="",NUMVIS'?1N.N S BNEW=1
 I $D(MPARMS("NUMVIS")) S BNEW=1
 ;*** New code for #visit range
 I BNEW,$D(NUMVIS),'$D(MPARMS("NUMVIS")) D
 . I NUMVIS="=0"!(NUMVIS="<0")!(NUMVIS="<1")!(NUMVIS="'>0") S NOVST=2 Q  ; only check patients with no visits
 . I $E(NUMVIS)="<" S NOVST=1 Q
 . I $E(NUMVIS,1,2)="'>" S NOVST=1
 I $D(MPARMS("NUMVIS")) D
 . S VCRIT1=$O(MPARMS("NUMVIS","")),VCRIT2=$O(MPARMS("NUMVIS",VCRIT1))
 . I $E(VCRIT1,1,2)="'<" S NOVST=1 Q
 . I $E(VCRIT1)="<" S NOVST=1
 I BNEW,NOVST<2,$G(PROV)="" D
 . S DFN=""
 . F  S DFN=$O(@TGLOB@(DFN)) Q:DFN=""  D
 .. I $G(NUMVIS)'="" D  Q
 ... I CLIN'="" D
 .... I '$D(@VODATA@(DFN,"CLN",CLIN)) K @TGLOB@(DFN),@VODATA@(DFN) Q
 ... I CLIN="" D
 .... I @(@TGLOB@(DFN)_NUMVIS) Q
 .... K @TGLOB@(DFN)
 .. ; If criteria includes a "not" it is inclusive and both must be true
 .. I $E(VCRIT1)="'",@(@TGLOB@(DFN)_VCRIT1),@(@TGLOB@(DFN)_VCRIT2) Q
 .. ; If criteria does not includes a "not" it is exclusive and one must be true
 .. I $E(VCRIT1)'="'",@(@TGLOB@(DFN)_VCRIT1_"!("_(@TGLOB@(DFN)_VCRIT2)_")") Q
 .. K @TGLOB@(DFN)
 ;
 I $G(NUMVIS)=0 S NOVST=2 ; ***Replace*** - temporary
 ;
 I 'BNEW,NUMVIS'=0 D  ;***Replace*** temporary
 . S DFN=""
 . F  S DFN=$O(@TGLOB@(DFN)) Q:DFN=""  I @TGLOB@(DFN)<NUMVIS K @TGLOB@(DFN)
 ;
 I NOVST D
 . S DFN=0
 . F  S DFN=$O(^BQIPAT(DFN)) Q:'DFN  D
 .. I $D(@VODATA@(DFN)) Q
 .. S @VNDATA@(DFN)=""
 . I NOVST=2 D
 .. K @TGLOB
 .. S DFN="" F  S DFN=$O(@VNDATA@(DFN)) Q:DFN=""  S @TGLOB@(DFN)=""
 . K @VNDATA
 ;
 I CLIN'="" D
 . S DFN=""
 . F  S DFN=$O(@TGLOB@(DFN)) Q:DFN=""  D
 .. I '$D(@VODATA@(DFN,"CLN",CLIN)) K @TGLOB@(DFN),@VODATA@(DFN)
 . Q
 I CLIN="",$D(MPARMS("CLIN")) D
 . S DFN=""
 . F  S DFN=$O(@TGLOB@(DFN)) Q:DFN=""  D
 .. S OK=0
 .. S VCLIN="" F  S VCLIN=$O(MPARMS("CLIN",VCLIN)) Q:VCLIN=""  D  Q:OK
 ... I $D(@VODATA@(DFN,"CLN",VCLIN)) S OK=1
 .. I 'OK K @TGLOB@(DFN),@VODATA@(DFN)
 . Q
 Q
 ;
RANGE(VAL,ENT) ; EP - Load relative from and through dates when RANGE
 ;                    parameter or filter has been selected.
 ; Input:
 ;   VAL - Range value - e.g. last week
 ;   ENT - Entry in file 90506
 ;   
 Q:$G(VAL)=""
 Q:$G(ENT)=""
 N RNGIEN,CHOICE
 S RNGIEN=$O(^BQI(90506,ENT,3,"B","RANGE",""))
 I RNGIEN D
 . S CHOICE=$O(^BQI(90506,ENT,3,RNGIEN,3,"B",VAL,""))
 . I CHOICE D
 .. N DA,IENS,EXEC
 .. S DA=CHOICE,DA(1)=RNGIEN,DA(2)=ENT S IENS=$$IENS^DILF(.DA)
 .. S EXEC=$$GET1^DIQ(90506.33,IENS,.02,"I")
 .. Q:EXEC=""
 .. S RFROM=$$DATE^BQIUL1($P($P(EXEC,"RFROM=",2),"~"))
 .. S RTHRU=$$DATE^BQIUL1($P($P(EXEC,"RTHRU=",2),"~"))
 Q
 ;
PNL(FGLOB,TGLOB,PLIDEN,MPARMS) ;EP - Panel search
 I $G(TGLOB)="" Q
 I PLIDEN]"" D PLD
 I $D(MPARMS("PLIDEN")) S PLIDEN="" F  S PLIDEN=$O(MPARMS("PLIDEN",PLIDEN)) Q:PLIDEN=""  D PLD
 Q
 ;
PLD ;
 NEW OWNR,PLNME,DA,IENS,PLIEN
 S OWNR=$P(PLIDEN,$C(26),1),PLNME=$P(PLIDEN,$C(26),2)
 S DA="",DA(1)=OWNR,IENS=$$IENS^DILF(.DA)
 S PLIEN=$$FIND1^DIC(90505.01,IENS,"X",PLNME,"","","ERROR")
 I PLIEN="" Q
 I $G(FGLOB)'="" D
 . S IEN=""
 . F  S IEN=$O(@FGLOB@(IEN)) Q:'IEN  D
 .. I $D(^BQICARE(OWNR,1,PLIEN,40,IEN)),$P(^BQICARE(OWNR,1,PLIEN,40,IEN,0),U,2)'="R" S @TGLOB@(IEN)=""
 ;
 NEW DFN,IEN
 I $G(FGLOB)="" D
 . S DFN=0
 . F  S DFN=$O(^BQICARE(OWNR,1,PLIEN,40,DFN)) Q:'DFN  D
 .. I $P(^BQICARE(OWNR,1,PLIEN,40,DFN,0),U,2)="R" Q
 .. S @TGLOB@(DFN)=""
 Q
 ;
DECHK(DDFN) ; Is patient eligible based on date of death
 N DOD,DFLG
 S DOD=$P($G(^DPT(DDFN,.35)),U,1)
 I DOD="" Q 0
 ;
 ;Date of Death Checks
 ;
 ;New Method - Date Range
 I $G(DECFDT)]""!($G(DECTDT)]"") S DFLG=1 D  Q DFLG
 .I $G(DECFDT)]"",DOD<DECFDT S DFLG=0 Q
 .I $G(DECTDT)]"",DOD>DECTDT S DFLG=0
 ;
 ;Old Method - Single Deceased as of Date
 I DECDT="" Q 1
 I DOD'>DECDT Q 1
 ;
 Q 0
 ;
STAT(FGLOB,TGLOB,LIV,DEC,INAC) ;EP Check patients status
 I $G(TGLOB)="" Q
 NEW IEN
 S IEN=0
 I $G(FGLOB)'="" D  Q
 . F  S IEN=$O(@FGLOB@(IEN)) Q:'IEN  D STCK
 ;
 I $G(FGLOB)="" D
 . F  S IEN=$O(^AUPNPAT(IEN)) Q:'IEN  D STCK
 Q
 ;
STCK ;EP - Check
 ; If all are checked for yes, all patients are included
 I LIV="Y",DEC="Y",INAC="Y" S @TGLOB@(IEN)="" Q
 ; If none are checked, no patients are included
 I LIV="N",DEC="N",INAC="N" Q
 ; if living and deceased are included but not inactives
 I LIV="Y",DEC="Y",INAC="N" D
 . ; Active HRN, include
 . I $$HRN^BQIUL1(IEN) S @TGLOB@(IEN)="" Q
 ; Include living but not deceased
 I LIV="Y",DEC="N",INAC="Y" D
 . ; If they are not active and not deceased, include
 . I '$$HRN^BQIUL1(IEN),'$$DECHK(IEN) S @TGLOB@(IEN)="" Q
 ; If living, not deceased and not inactive, include
 I LIV="Y",DEC="N",INAC="N" D
 . I $$HRN^BQIUL1(IEN),'$$DECHK(IEN) S @TGLOB@(IEN)="" Q
 I LIV="N",DEC="Y",INAC="Y" D
 . ; Decease but active
 . I $$DECHK(IEN),$$HRN^BQIUL1(IEN) S @TGLOB@(IEN)="" Q
 I LIV="N",DEC="N",INAC="Y" D
 . ; inactive
 . I $$HRN^BQIUL1(IEN) S @TGLOB@(IEN)="" Q
 I LIV="N",DEC="Y",INAC="N" D
 . ; Deceased but not inactive
 . I $$DECHK(IEN),$$HRN^BQIUL1(IEN) S @TGLOB@(IEN)="" Q
 Q
