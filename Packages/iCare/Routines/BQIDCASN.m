BQIDCASN ;PRXM/HC/ALA-'Patients Assigned To' ; 15 Sep 2006  5:18 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
FND(FDATA,PARMS,MPARMS) ;EP - Find records
 ;
 ;Description
 ;  Executable that finds all patients who are assigned to designated people
 ;Input
 ;  PARMS = Array of parameters and their values
 ;  MPARMS = Multiple array of a parameter
 ;Expected to return FDATA
 ;
 NEW UID,PSTMFRAM,PSVISITS,PTMFRAME,PVISITS,TYP,VDATA,SPEC
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S FDATA=$NA(^TMP("BQIDCASN",UID)),VDATA=$NA(^TMP("BQIFND",UID))
 K @FDATA,@VDATA
 ;
 ;  Set the parameters into variables
 I '$D(PARMS) Q
 ;
 S NM="" F  S NM=$O(PARMS(NM)) Q:NM=""  S @NM=PARMS(NM)
 S PROV=$G(PROV,""),TYPE=$G(TYPE,"")
 ;
 I '$D(MPARMS("TYPE")) D
 . I TYPE="CMGR"!(TYPE="DPCP") S DATA=$NA(^TMP("BQIBDP",UID))
 . I TYPE="PRIM"!(TYPE="PRSC") S DATA=$NA(^TMP("BQIPRV",UID))
 . K @DATA
 . I TYPE="PRIM" D PROV("P"),SAV Q
 . I TYPE="PRSC" D PROV(""),SAV Q
 . D @TYPE,SAV
 I $D(MPARMS("TYPE")) D
 . ; types = CMGR,DPCP,PRIM,PRSC
 . S TYP=""
 . F  S TYP=$O(MPARMS("TYPE",TYP),-1) Q:TYP=""  D
 .. I TYP="CMGR"!(TYP="DPCP") S DATA=$NA(^TMP("BQIBDP",UID))
 .. I TYP="PRIM"!(TYP="PRSC") S DATA=$NA(^TMP("BQIPRV",UID))
 .. K @DATA
 .. I TYP="PRIM" D PROV("P"),SAV Q
 .. I TYP="PRSC" D PROV(""),SAV Q
 .. D @TYP,SAV
 ;
 Q
 ;
SAV ;  Save the data
 S DFN=""
 F  S DFN=$O(@DATA@(DFN)) Q:DFN=""  S @FDATA@(DFN)=""
 K @DATA
 Q
 ;
CMGR ; Case Manager
 I $$VERSION^XPDUTL("BDP")="" Q
 ;  
 NEW DFN,CAT,DIC,IEN,NM,IEN,Y,X,CSMGR
 S DIC="^BDPTCAT("
 S DIC(0)="Z",X="CASE MANAGER" D ^DIC
 S CAT=+Y I CAT=-1 Q
 ;
 ;  Go through the BDP DESG SPECIALTY PROVIDER File to find any patient
 ;  with the specified case manager
 ;
 S IEN="",CSMGR=PROV
 F  S IEN=$O(^BDPRECN("AC",CSMGR,IEN)) Q:IEN=""  D
 . I $$GET1^DIQ(90360.1,IEN_",",.01,"I")'=CAT Q
 . S DFN=$$GET1^DIQ(90360.1,IEN_",",.02,"I") I DFN="" Q
 . ; User may now select Living, Deceased or both as a filter so
 . ; if no filters defined assume living patients otherwise let filter decide
 . ;I $O(^BQICARE(OWNR,1,PLIEN,15,0))="",$P($G(^DPT(DFN,.35)),U,1)'="" Q
 . I '$$HRN^BQIUL1(DFN) Q
 . ; If patient has no visit in last 3 years, quit
 . ;I '$$VTHR^BQIUL1(DFN) Q
 . S @DATA@(DFN)=""
 Q
 ;
DPCP ;
 ;  If the DSPM package is installed
 I $$VERSION^XPDUTL("BDP")'="" D DSPM Q
 ;
 ;  If the DSPM package is NOT installed, use the alternate
 ;  primary provider definition
 NEW IEN
 S IEN=""
 F  S IEN=$O(^AUPNPAT("AK",PROV,IEN)) Q:IEN=""  D
 . I $P($G(^DPT(IEN,.35)),U,1)'="" Q
 . I '$$HRN^BQIUL1(IEN) Q
 . ; If patient has no visit in last 3 years, quit
 . ;I '$$VTHR^BQIUL1(IEN) Q
 . S @DATA@(IEN)=""
 Q
 ;
DSPM ;  Find the internal entry number
 NEW DFN,CAT,DIC,IEN,Y,X
 S DIC="^BDPTCAT("
 S DIC(0)="Z",X="DESIGNATED PRIMARY PROVIDER" D ^DIC
 S CAT=+Y I CAT=-1 Q
 ;
 S IEN=""
 F  S IEN=$O(^BDPRECN("AC",PROV,IEN)) Q:IEN=""  D
 . I $$GET1^DIQ(90360.1,IEN_",",.01,"I")'=CAT Q
 . S DFN=$$GET1^DIQ(90360.1,IEN_",",.02,"I") I DFN="" Q
 . I $P($G(^DPT(DFN,.35)),U,1)'="" Q
 . I '$$HRN^BQIUL1(DFN) Q
 . ; If patient has no visit in last 3 years, quit
 . ;I '$$VTHR^BQIUL1(DFN) Q
 . S @DATA@(DFN)=""
 ;
 ; Also check patient file
 NEW IEN
 S IEN=""
 F  S IEN=$O(^AUPNPAT("AK",PROV,IEN)) Q:IEN=""  D
 . ; If patient is deceased, quit
 . I $P($G(^DPT(IEN,.35)),U,1)'="" Q
 . ; If patient has no active HRNs, quit
 . I '$$HRN^BQIUL1(IEN) Q
 . ; If patient has no visit in last 3 years, quit
 . ;I '$$VTHR^BQIUL1(IEN) Q
 . S @DATA@(IEN)=""
 Q
 ;
PROV(FLAG) ;EP - Primary or Primary/Secondary Providers
 ; Input
 ;   FLAG - "P" for Primary Only
 ; 
 NEW TMFRAME,VISITS,FDT,TDT,IEN
 I $G(DT)="" D DT^DICRW
 I FLAG="P" S FDT=$G(PTMFRAME,""),VISITS=$G(PVISITS,"")
 I FLAG'="P" S FDT=$G(PSTMFRAM,""),VISITS=$G(PSVISITS,"")
 S TDT=DT
 ;
 ;  Go through the V PROVIDER File for the designated provider and
 ;  find out if they are a primary or secondary provider AND if the
 ;  visit falls within the time frame
 S IEN="",FLAG=$G(FLAG,"")
 F  S IEN=$O(^AUPNVPRV("B",PROV,IEN),-1) Q:IEN=""  D
 . I FLAG="P",$$GET1^DIQ(9000010.06,IEN_",",.04,"I")'="P" Q
 . S VISIT=$$GET1^DIQ(9000010.06,IEN_",",.03,"I") I VISIT="" Q
 . S VSDTM=$$GET1^DIQ(9000010,VISIT_",",.01,"I")\1 I VSDTM=0 Q
 . S DFN=$$GET1^DIQ(9000010.06,IEN_",",.02,"I") I DFN="" Q
 . I $P($G(^DPT(DFN,.35)),U,1)'="" Q
 . I '$$HRN^BQIUL1(DFN) Q
 . ; If patient has no visit in last 3 years, quit
 . ;I '$$VTHR^BQIUL1(DFN) Q
 . ;
 . I FDT'="" S QFL=0 D  Q:QFL
 .. I VSDTM'<FDT,VSDTM'>TDT Q
 .. S QFL=1
 . ;  Count number of visits for a patient
 . S @VDATA@(DFN)=$G(@VDATA@(DFN))+1
 ;
 S DFN=""
 F  S DFN=$O(@VDATA@(DFN)) Q:DFN=""  D
 . ;  if the number of visits for patient doesn't match the criteria, quit
 . I @VDATA@(DFN)<VISITS Q  ;Changed from '= to <
 . S @DATA@(DFN)=""
 ;
 K @VDATA
 Q
 ;
SPEC ; Find the entries for a specialty provider
 NEW IEN,SPC
 I '$D(MPARMS("SPEC")) D SPC(SPEC,PROV) Q
 I $D(MPARMS("SPEC")) D
 . S SPC=""
 . F  S SPC=$O(MPARMS("SPEC",SPC),-1) Q:SPC=""  D SPC(SPC,PROV)
 Q
 ;
SPC(SPC,PRV) ;
 S IEN=""
 F  S IEN=$O(^BDPRECN("B",SPC,IEN)) Q:IEN=""  D
 . I $P(^BDPRECN(IEN,0),U,3)'=PRV Q
 . S DFN=$P(^BDPRECN(IEN,0),U,2)
 . I $P($G(^DPT(DFN,.35)),U,1)'="" Q
 . I '$$HRN^BQIUL1(DFN) Q
 . ; If patient has no visit in last 3 years, quit
 . ;I '$$VTHR^BQIUL1(DFN) Q
 . S @DATA@(DFN)=""
 Q
