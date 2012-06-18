BQIDCMPR ;PRXM/HC/ALA-"MY PATIENTS-PRIMARY or PRIMARY/SECONDARY" ; 20 Oct 2005  9:52 AM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
FND(DATA,PARMS,MPARMS,FLAG) ;EP - Find patients
 ;
 ;Description
 ;  Executable to find the patients for a specific provider where the patient
 ;  had NVIS number of visits for the specified time frame
 ;Input
 ;  PARMS  = Array of parameters and their values
 ;  MPARMS = Multiple array of a parameter (not currently used for this definition)
 ;  FLAG   = "P" is primary only, blank is both primary and secondary
 ;Expected to return DATA
 ;
 NEW IEN,DFN,FDT,TDT,VISIT,VSDTM,Y,X,UID,NM,TMFRAME,PROV
 NEW VISITS,QFL,%DT,VDATA
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIDCMPR",UID))
 S VDATA=$NA(^TMP("BQIFND",UID))
 K @DATA,@VDATA
 ;
 I '$D(PARMS) Q
 ;
 S NM=""
 F  S NM=$O(PARMS(NM)) Q:NM=""  S @NM=PARMS(NM)
 ;
 I $G(DT)="" D DT^DICRW
 S FDT=$G(TMFRAME,"")
 I TMFRAME["T-" D
 . S %DT="",X=TMFRAME
 . D ^%DT
 . S FDT=Y
 S TDT=DT
 ;
 ;  Go through the V PROVIDER File for the designated provider and
 ;  find out if they are a primary or secondary provider AND if the
 ;  visit falls within the time frame
 S IEN="",FLAG=$G(FLAG,"")
 F  S IEN=$O(^AUPNVPRV("B",PROV,IEN),-1) Q:IEN=""  D
 . I FLAG="P",$$GET1^DIQ(9000010.06,IEN_",",.04,"I")'="P" Q
 . S VISIT=$$GET1^DIQ(9000010.06,IEN_",",.03,"I") I VISIT="" Q
 . I $$GET1^DIQ(9000010,VISIT_",",.11,"I")=1 Q
 . S VSDTM=$$GET1^DIQ(9000010,VISIT_",",.01,"I")\1 I VSDTM=0 Q
 . S DFN=$$GET1^DIQ(9000010.06,IEN_",",.02,"I") I DFN="" Q
 . ; If patient is deceased, quit
 . I $P($G(^DPT(DFN,.35)),U,1)'="" Q
 . ; If patient has no active HRNs, quit
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
