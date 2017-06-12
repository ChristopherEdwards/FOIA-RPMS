BQIDCASN ;VNGT/HS/ALA-'Patients Assigned To' ; 15 Sep 2006  5:18 PM
 ;;2.4;ICARE MANAGEMENT SYSTEM;**2**;Apr 01, 2015;Build 10
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
 NEW UID,PSTMFRAM,PSVISITS,PTMFRAME,PVISITS,TYPE,VDATA,RFROM
 NEW TEAM,CAT,TYP,PROV,NOTA,SPEC,QFL,VISIT,VSDTM,PPIEN,RTHRU
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S FDATA=$NA(^TMP(UID,"BQIDCASN")),VDATA=$NA(^TMP(UID,"BQIFND"))
 K @FDATA,@VDATA
 ;
 ;  Set the parameters into variables
 I '$D(PARMS) Q
 ;
 S NM="" F  S NM=$O(PARMS(NM)) Q:NM=""  S @NM=PARMS(NM)
 S PROV=$G(PROV,""),TYPE=$G(TYPE,""),NOTA=$G(NOTA,"")
 S PPIEN=$$PP^BQIDCDF("PATIENTS ASSIGNED TO")
 ;
 ; If panel is patient not assigned to a DPCP
 I $G(NOTA)'="" D  Q
 . NEW BQDFN
 . S BQDFN=0
 . F  S BQDFN=$O(^AUPNPAT(BQDFN)) Q:'BQDFN  D
 .. I $P($G(^AUPNPAT(BQDFN,0)),"^",1)="" Q
 .. I $P(^AUPNPAT(BQDFN,0),U,14)'="" Q
 .. ; If patient has no active HRNs, quit
 .. I '$$HRN^BQIUL1(BQDFN) Q
 .. S @FDATA@(BQDFN)=""
 ;
 ; If team
 I $G(TEAM)'="" D  Q
 . S CAT=$$CT("DESIGNATED PRIMARY PROVIDER")
 . S PROV=""
 . F  S PROV=$O(^BSDPCT(TEAM,1,"B",PROV)) Q:PROV=""  D DP
 . D SAV
 ;
 I '$D(MPARMS("TYPE")) D
 . I TYPE="CMGR"!(TYPE="DPCP") S DATA=$NA(^TMP("BQIBDP",UID))
 . I TYPE="PRIM"!(TYPE="PRSC") S DATA=$NA(^TMP("BQIPRV",UID))
 . K @DATA
 . I TYPE="PRIM" D PROV("P"),SAV Q
 . I TYPE="PRSC" D PROV(""),SAV Q
 . I TYPE="" Q
 . D @TYPE,SAV
 I $D(MPARMS("TYPE")) D
 . ; types = CMGR,DPCP,PRIM,PRSC
 . S TYP=""
 . F  S TYP=$O(MPARMS("TYPE",TYP)) Q:TYP=""  D
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
 K @FDATA
 S DFN=""
 F  S DFN=$O(@DATA@(DFN)) Q:DFN=""  S @FDATA@(DFN)=""
 K @DATA
 Q
 ;
CMGR ; Case Manager
 I $$VERSION^XPDUTL("BDP")="" Q
 ;  
 NEW DFN,CAT,IEN,NM,IEN,Y,X,CSMGR
 S CAT=$$CT("CASE MANAGER")
 I 'CAT Q
 ;
 ;  Go through the BDP DESG SPECIALTY PROVIDER File to find any patient
 ;  with the specified case manager
 ;
 I $D(MPARMS("PROV")) D
 . S CSMGR=""
 . F  S CSMGR=$O(MPARMS("PROV",CSMGR)) Q:CSMGR=""  S IEN="" D CM
 I '$D(MPARMS("PROV")) S CSMGR=PROV,IEN="" D CM
 Q
 ;
CM ;
 F  S IEN=$O(^BDPRECN("AC",CSMGR,IEN)) Q:IEN=""  D
 . ;I $$GET1^DIQ(90360.1,IEN_",",.01,"I")'=CAT Q
 . I $P($G(^BDPRECN(IEN,0)),"^",1)'=CAT Q
 . ;S DFN=$$GET1^DIQ(90360.1,IEN_",",.02,"I") I DFN="" Q
 . S DFN=$P($G(^BDPRECN(IEN,0)),"^",2) I DFN="" Q
 . S @DATA@(DFN)=""
 Q
 ;
DPCP ;
 ;  If the DSPM package is installed
 I $$VERSION^XPDUTL("BDP")'="" D DSPM
 ;
 ;  If the DSPM package is NOT installed, use the alternate
 ;  primary provider definition
 I $$VERSION^XPDUTL("BDP")="" D
 . I $D(MPARMS("PROV")) D
 .. S PROV=""
 .. F  S PROV=$O(MPARMS("PROV",PROV)) Q:PROV=""  S IEN="" D DP
 . I '$D(MPARMS("PROV")) S IEN="" D DP
 . Q
 . NEW IEN
 . S IEN=""
 . F  S IEN=$O(^AUPNPAT("AK",PROV,IEN)) Q:IEN=""  D
 .. S @DATA@(IEN)=""
 Q
 ;
DSPM ;  Find the internal entry number
 NEW DFN,DIC,IEN,Y,X
 S CAT=$$CT("DESIGNATED PRIMARY PROVIDER")
 I 'CAT Q
 ;
 I $D(MPARMS("PROV")) D
 . S PROV=""
 . F  S PROV=$O(MPARMS("PROV",PROV)) Q:PROV=""  S IEN="" D DP
 I '$D(MPARMS("PROV")) S IEN="" D DP
 Q
 ;
DP ;
 S IEN=""
 F  S IEN=$O(^BDPRECN("AC",PROV,IEN)) Q:IEN=""  D
 . ;I $$GET1^DIQ(90360.1,IEN_",",.01,"I")'=CAT Q
 . I $P($G(^BDPRECN(IEN,0)),"^",1)'=CAT Q
 . ;S DFN=$$GET1^DIQ(90360.1,IEN_",",.02,"I") I DFN="" Q
 . S DFN=$P($G(^BDPRECN(IEN,0)),"^",2) I DFN="" Q
 . S @DATA@(DFN)=""
 ;
 ; Also check patient file
 NEW IEN
 S IEN=""
 F  S IEN=$O(^AUPNPAT("AK",PROV,IEN)) Q:IEN=""  D
 . S @DATA@(IEN)=""
 Q
 ;
PROV(FLAG) ;EP - Primary or Primary/Secondary Providers
 ; Input
 ;   FLAG - "P" for Primary Only
 ; 
 NEW TMFRAME,VISITS,FDT,TDT,IEN
 I $G(DT)="" D DT^DICRW
 S FDT="",TDT=""
 I FLAG="P" D
 . I $G(PTMFRAME)'="" D
 .. D RANGE^BQIDCAH1(PTMFRAME,PPIEN,"PTMFRAME")
 .. S FDT=$G(RFROM,""),TDT=$G(RTHRU,"")
 . S VISITS=$G(PVISITS,"")
 I FLAG'="P" D
 . I $G(PSTMFRAM)'="" D
 .. D RANGE^BQIDCAH1(PSTMFRAM,PPIEN,"PSTMFRAM")
 .. S FDT=$G(RFROM,""),TDT=$G(RTHRU,"")
 . S VISITS=$G(PSVISITS,"")
 S TDT=DT
 I $G(PROV)'="" D PV
 I $D(MPARMS("PROV")) D
 . S PROV=""
 . F  S PROV=$O(MPARMS("PROV",PROV)) Q:PROV=""  D PV
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
 ;  Go through the V PROVIDER File for the designated provider and
 ;  find out if they are a primary or secondary provider AND if the
 ;  visit falls within the time frame
PV ;
 S IEN="",FLAG=$G(FLAG,"")
 F  S IEN=$O(^AUPNVPRV("B",PROV,IEN),-1) Q:IEN=""  D
 . ;I FLAG="P",$$GET1^DIQ(9000010.06,IEN_",",.04,"I")'="P" Q
 . I FLAG="P",$P($G(^AUPNVPRV(IEN,0)),"^",4)'="P" Q
 . ;S VISIT=$$GET1^DIQ(9000010.06,IEN_",",.03,"I") I VISIT="" Q
 . S VISIT=$P($G(^AUPNVPRV(IEN,0)),"^",3) I VISIT="" Q
 . ;S VSDTM=$$GET1^DIQ(9000010,VISIT_",",.01,"I")\1 I VSDTM=0 Q
 . S VSDTM=$P($G(^AUPNVSIT(VISIT,0)),"^",1)\1 I VSDTM=0 Q
 . ;S DFN=$$GET1^DIQ(9000010.06,IEN_",",.02,"I") I DFN="" Q
 . S DFN=$P($G(^AUPNVPRV(IEN,0)),"^",2) I DFN="" Q
 . I $D(@FDATA)>0,'$D(@FDATA@(DFN)) Q
 . ;
 . I FDT'="" S QFL=0 D  Q:QFL
 .. I VSDTM'<FDT,VSDTM'>TDT Q
 .. S QFL=1
 . ;  Count number of visits for a patient
 . S @VDATA@(DFN)=$G(@VDATA@(DFN))+1
 ; 
 Q
 ;
SPEC ; Find the entries for a specialty provider
 NEW IEN,SPC,IEN
 ; If single specialty
 I '$D(MPARMS("SPEC")) D
 . ; Multiple providers
 . I $D(MPARMS("PROV")) D
 .. S PROV=""
 .. F  S PROV=$O(MPARMS("PROV",PROV)) Q:PROV=""  S IEN="" D SPC(SPEC,PROV)
 . ; Single Provider
 . I '$D(MPARMS("PROV")) S IEN="" D SPC(SPEC,PROV) Q
 ;
 ; If multiple specialties
 I $D(MPARMS("SPEC")) D
 . S SPC=""
 . F  S SPC=$O(MPARMS("SPEC",SPC),-1) Q:SPC=""  D
 .. ; Multiple providers
 .. I $D(MPARMS("PROV")) D
 ... S PROV=""
 ... F  S PROV=$O(MPARMS("PROV",PROV)) Q:PROV=""  S IEN="" D SPC(SPC,PROV)
 .. ; Single Provider
 .. I '$D(MPARMS("PROV")) S IEN="" D SPC(SPC,PROV) Q
 Q
 ;
SPC(SPC,PRV) ;
 S IEN=""
 F  S IEN=$O(^BDPRECN("B",SPC,IEN)) Q:IEN=""  D
 . I $P(^BDPRECN(IEN,0),U,3)'=PRV Q
 . S DFN=$P(^BDPRECN(IEN,0),U,2)
 . S @DATA@(DFN)=""
 Q
 ;
CT(TEXT) ; Find value
 Q $$FIND1^DIC(90360.3,,"X",TEXT)
