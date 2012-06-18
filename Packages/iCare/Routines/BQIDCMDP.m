BQIDCMDP ;PRXM/HC/ALA-"MY PATIENTS-DPCP" ; 19 Oct 2005  5:49 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
FND(DATA,PARMS,MPARMS) ;EP - Find all patients
 ;
 ;Description
 ;  Executable to find all patients who has the designated primary provider
 ;Input
 ;  PARMS = Array of parameters and their values
 ;  MPARMS = Multiple array of a parameter (not currently used for this definition)
 ;Expected to return DATA
 ;
 NEW UID
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIDCMDP",UID))
 K @DATA
 ;
 NEW NM
 I '$D(PARMS) Q
 ;
 S NM=""
 F  S NM=$O(PARMS(NM)) Q:NM=""  S @NM=PARMS(NM)
 ;
 ;  If the DSPM package is installed
 I $$VERSION^XPDUTL("BDP")'="" D DSPM Q
 ;
 ;  If the DSPM package is NOT installed, use the alternate
 ;  primary provider definition
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
 . ; If patient is deceased, quit
 . I $P($G(^DPT(DFN,.35)),U,1)'="" Q
 . ; If patient has no active HRNs, quit
 . I '$$HRN^BQIUL1(DFN) Q
 . ; If patient has no visit in last 3 years, quit
 . ;I '$$VTHR^BQIUL1(DFN) Q
 . S @DATA@(DFN)=""
 . ;
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
