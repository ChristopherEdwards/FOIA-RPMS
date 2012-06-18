BQITD031 ;PRXM/HC/ALA-CVD Known Definition ; 19 Jun 2006  5:01 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ; Utilities called by BQITD03
 ;
 Q
 ;
AMI(DFN,GLOB,TMREF,DXOK) ; EP - Process AMI date logic
 ;
 ; Within any two year period, at least two diagnoses of [whatever] and
 ; at least 90 days between first and last diagnosis (Revised logic definition)
 ;
 ; Input
 ;   DFN - patient whose AMI diagnoses are being examined
 ;   GLOB - Global where data is to be stored
 ;          Structure:
 ;          GLOB(DFN,"CRITERIA",criteria or taxonomy,visit or problem ien)=date/time
 ;   TMREF - Global used to temporarily store diagnoses that may meet the
 ;           AMI logic and, if so, will be stored in GLOB
 ;   DXOK - If set to '1', patient meets the AMI logic for CVD Known - value
 ;          may be returned (if called by PAT subroutine)
 ; Variables
 ;   NOK - If set to '1', no diagnoses remaining that will meet the date logic
 ;   LDX - Most recent diagnosis that meets the AMI criteria
 ;   FDX - Other diagnosis that must be compared to LDX to determine if they
 ;         meet the date logic
 ;   STOP - Set to '1' if the date range exceeds the two year maximum so new
 ;          value for LDX must be found
 ;   VTYP - Visit type - either 'V' for visit or 'P' for problem
 N NOK,STOP,LDX,FDX,DX
 I $G(@TMREF@(DFN))<2 K @TMREF@(DFN) Q
 S DXOK=0,NOK=0
 F  D  Q:DXOK!NOK  K @TMREF@(DFN,LDX)
 . S LDX=$O(@TMREF@(DFN,"A"),-1) I LDX="" S NOK=1 Q
 . S STOP=0,FDX=LDX
 . F  S FDX=$O(@TMREF@(DFN,FDX),-1) Q:FDX=""  D  Q:DXOK!STOP
 .. I $$TYP(DFN,LDX,TMREF)="P",$$TYP(DFN,FDX,TMREF)="P" Q
 .. I $$FMDIFF^XLFDT(LDX,FDX,1)'<731 S STOP=1 Q  ; More than 2 years apart
 .. I $$FMDIFF^XLFDT(LDX,FDX,1)>89 S DXOK=1 D
 ... ; Delete remaining entries from temporary file
 ... S DX=""
 ... F  S DX=$O(@TMREF@(DFN,DX)) Q:DX=""  I DX'=LDX,DX'=FDX K @TMREF@(DFN,DX)
 ; Update global with criteria
 I DXOK D
 . M @GLOB@(DFN)=@TMREF@(DFN)
 . NEW IEN,FREF,EXDT
 . S VSDT="",EXDT=""
 . F  S VSDT=$O(@TMREF@(DFN,VSDT)) Q:VSDT=""  D
 .. S TIEN="" F  S TIEN=$O(@TMREF@(DFN,VSDT,TIEN)) Q:TIEN=""  D
 ... S VISIT=$P(@TMREF@(DFN,VSDT,TIEN),U,2),VTYP=$P(@TMREF@(DFN,VSDT,TIEN),U,1)
 ... S IEN=$P(@TMREF@(DFN,VSDT,TIEN),U,4),FREF=$P(@TMREF@(DFN,VSDT,TIEN),U,5)
 ... I VTYP="V" S @GLOB@(DFN,"CRITERIA",TAX,VTYP,VISIT,IEN)=VSDT_U_EXDT_U_IEN_U_FREF
 ... I VTYP="P" S @GLOB@(DFN,"CRITERIA",TAX,VTYP,VISIT)=VSDT_U_EXDT
 Q
 ;
IHD(DFN,GLOB,TMREF,DXOK) ; EP - Process IHD/Multiple Known CVD date logic
 ;
 ; Within any five year period, at least three diagnoses of [whatever] and
 ; at least 90 days between first and last diagnosis (Revised logic definition)
 ; Input
 ;   DFN - patient whose IHD diagnoses are being examined
 ;   GLOB - Global where data is to be stored
 ;          Structure:
 ;          GLOB(DFN,"CRITERIA",criteria or taxonomy,visit or problem ien)=date/time
 ;   TMREF - Global used to temporarily store diagnoses that may meet the
 ;           IHD logic and, if so, will be stored in GLOB
 ;   DXOK - If set to '1', patient meets the IHD logic for CVD Known - value
 ;          may be returned (if called by PAT subroutine)
 ; Variables
 ;   NOK - If set to '1', no diagnoses remaining that will meet the date logic
 ;   LDX - Most recent diagnosis that meets the IHD criteria
 ;   LDX1 - Next recent diagnosis that meets the IHD criteria
 ;   FDX - Third diagnosis that must be compared to LDX to determine if they
 ;         meet the date logic
 ;   STOP - Set to '1' if the date range exceeds the two year maximum so new
 ;          value for LDX must be found
 ;   VTYP - Visit type - either 'V' for visit or 'P' for problem
 N NOK,STOP,LDX,LDX1,FDX,DX
 I $G(@TMREF@(DFN))<3 K @TMREF@(DFN) Q
 S DXOK=0,NOK=0
 F  D  Q:DXOK!NOK  K @TMREF@(DFN,LDX)
 . S LDX=$O(@TMREF@(DFN,"A"),-1) I LDX="" S NOK=1 Q
 . S LDX1=$O(@TMREF@(DFN,LDX),-1) I LDX1="" S NOK=1 Q
 . ; Only one problem can be included
 . I $$TYP(DFN,LDX,TMREF)="P",$$TYP(DFN,LDX1,TMREF)="P" D  I LDX1="" S NOK=1 Q
 .. F  S LDX1=$O(@TMREF@(DFN,LDX1),-1) Q:LDX1=""  I $$TYP(DFN,LDX1,TMREF)="V" Q
 . S STOP=0,FDX=LDX1
 . F  S FDX=$O(@TMREF@(DFN,FDX),-1) Q:FDX=""  D  Q:DXOK!STOP
 .. I $$TYP(DFN,LDX,TMREF)="P"!($$TYP(DFN,LDX1,TMREF)="P"),$$TYP(DFN,FDX,TMREF)="P" Q
 .. I $$FMDIFF^XLFDT(LDX,FDX,1)'<1826 S STOP=1 Q  ; More than 5 years apart
 .. I $$FMDIFF^XLFDT(LDX,FDX,1)>89 S DXOK=1 D
 ... ; Delete remaining entries from temporary file
 ... S DX=""
 ... F  S DX=$O(@TMREF@(DFN,DX)) Q:DX=""  I DX'=LDX,DX'=LDX1,DX'=FDX K @TMREF@(DFN,DX)
 I DXOK D
 . M @GLOB@(DFN)=@TMREF@(DFN)
 . NEW IEN,FREF,EXDT
 . S VSDT="",EXDT=""
 . F  S VSDT=$O(@TMREF@(DFN,VSDT)) Q:VSDT=""  D
 .. S TIEN="" F  S TIEN=$O(@TMREF@(DFN,VSDT,TIEN)) Q:TIEN=""  D
 ... S VISIT=$P(@TMREF@(DFN,VSDT,TIEN),U,2),VTYP=$P(@TMREF@(DFN,VSDT,TIEN),U,1)
 ... S IEN=$P(@TMREF@(DFN,VSDT,TIEN),U,4),FREF=$P(@TMREF@(DFN,VSDT,TIEN),U,5)
 ... S TAX=$P(@TMREF@(DFN,VSDT,TIEN),U,6)
 ... I VTYP="V" S @GLOB@(DFN,"CRITERIA",TAX,VTYP,VISIT,IEN)=VSDT_U_EXDT_U_IEN_U_FREF
 ... I VTYP="P" S @GLOB@(DFN,"CRITERIA",TAX,VTYP,VISIT)=VSDT_U_EXDT
 Q
 ;
IHDSM(DFN,GLOB,TMREF,DXOK) ; EP - Process IHD same day date logic
 ;
 ; 3 different instances of IHD on same day
 ; Input
 ;   DFN - patient whose IHD diagnoses are being examined
 ;   GLOB - Global where data is to be stored
 ;          Structure:
 ;          GLOB(DFN,"CRITERIA",criteria or taxonomy,visit or problem ien)=date/time
 ;   TMREF - Global used to temporarily store diagnoses that may meet the
 ;           IHD logic and, if so, will be stored in GLOB
 ;   DXOK - If set to '1', patient meets the IHD logic for CVD Known - value
 ;          may be returned (if called by PAT subroutine)
 ; Variables
 ;   VSDT - Visit date
 ;   TIEN - Diagnosis internal entry number
 ;   CT - Count of diagnoses for a date
 ;   VCT - Count of diagnoses associated with a visit
 ;   STOP - Set to '1' if the date range exceeds the two year maximum so new
 ;          value for LDX must be found
 ;   VTYP - Visit type - either 'V' for visit or 'P' for problem
 ;   VST - Array of visits to be included in the criteria
 ;   PVST - If there are only 2 visit dxs, set to the problem to be included
 ;
 N VSDT,TIEN,CT,VCT,VISIT,VTYP,VST,PVST,PRM,VPRM
 I $G(@TMREF@(DFN))<3 K @TMREF@(DFN) Q
 S DXOK=0,VSDT="",VPRM=""
 F  S VSDT=$O(@TMREF@(DFN,VSDT),-1) Q:VSDT=""  D  Q:DXOK
 . S STOP=0,TIEN="",CT=0,VCT=0,PVST="" K VST
 . F  S TIEN=$O(@TMREF@(DFN,VSDT,TIEN)) Q:TIEN=""  D  Q:VPRM
 .. I $P(@TMREF@(DFN,VSDT,TIEN),U,7) S VPRM=1,VST(TIEN)="",CT=1,VCT=1
 . Q:'VPRM  S TIEN=""
 . F  S TIEN=$O(@TMREF@(DFN,VSDT,TIEN)) Q:TIEN=""  I '$D(VST(TIEN)) D
 .. S CT=CT+1
 .. ; There must be three different diagnoses
 .. ; and of these three only one can be a problem
 .. ; One diagnosis must be a primary (PRM)
 .. S VTYP=$P(@TMREF@(DFN,VSDT,TIEN),U),PRM=$P(@TMREF@(DFN,VSDT,TIEN),U,7)
 .. I VTYP="V" S VCT=VCT+1 I CT'>3 S VST(TIEN)=""
 .. I VTYP="P",PVST="" S PVST=TIEN
 .. I CT'<3,VCT'<2 S DXOK=1
 . I DXOK D DEL(VSDT,CT,VCT,PVST,.VST)
 ; Update global with criteria
 ; VSDT is the date for which there are 3 different diagnoses
 ;
 I DXOK D
 . M @GLOB@(DFN,VSDT)=@TMREF@(DFN,VSDT)
 . NEW IEN,FREF,EXDT
 . S TIEN="",EXDT=""
 . F  S TIEN=$O(@TMREF@(DFN,VSDT,TIEN)) Q:TIEN=""  D
 .. S VISIT=$P(@TMREF@(DFN,VSDT,TIEN),U,2),VTYP=$P(@TMREF@(DFN,VSDT,TIEN),U,1)
 .. S IEN=$P(@TMREF@(DFN,VSDT,TIEN),U,4),FREF=$P(@TMREF@(DFN,VSDT,TIEN),U,5)
 .. I VTYP="V" S @GLOB@(DFN,"CRITERIA","Ischemic Heart Disease (3 diff)",VTYP,VISIT,IEN)=VSDT_U_EXDT_U_IEN_U_FREF
 .. I VTYP="P" S @GLOB@(DFN,"CRITERIA","Ischemic Heart Disease (3 diff)",VTYP,VISIT)=VSDT_U_EXDT
 Q
 ;
TYP(DFN,DX,TMREF) ; EP - Return 'V' or 'P' to identify type of visit
 ; Input
 ;   DFN - Patient
 ;   DX - Diagnosis internal entry number
 ;   TMREF - Temporary array of diagnoses
 ; Variables
 ;   LTYP - Either 'V' for visit or 'P' for problem
 N LIEN,LTYP
 S LTYP="P"
 S LIEN=""
 F  S LIEN=$O(@TMREF@(DFN,DX,LIEN)) Q:LIEN=""  D  Q:LTYP="V"
 . S LTYP=$P(@TMREF@(DFN,DX,LIEN),U)
 Q LTYP
 ;
DEL(VSDT,CT,VCT,PVST,VST) ; EP - Delete diagnoses from temporary file
 ; If more than three diagnoses on same day, remove extras
 ; preferentially keeping visit diagnoses over problem diagnoses
 ; and retaining a maximum of one problem diagnosis
 ;
 ; Input
 ;   VSDT - Visit date
 ;   CT - Count of diagnoses for a date
 ;   VCT - Count of diagnoses associated with a visit
 ;   PVST - If there are problem dxs, set to the first problem ien
 ;   VST - array of visit iens; if there are more than three only the
 ;         first three are included
 ;
 I CT=3 Q  ; If only 3 diagnoses we're done
 I VCT'<3 D  Q  ; keep three visit diagnoses and remove the rest
 . S TIEN=""
 . F  S TIEN=$O(@TMREF@(DFN,VSDT,TIEN)) Q:TIEN=""  D
 .. I '$D(VST(TIEN)) K @TMREF@(DFN,VSDT,TIEN)
 ; keep the problem and two visit diagnoses and remove the rest
 S TIEN=""
 F  S TIEN=$O(@TMREF@(DFN,VSDT,TIEN)) Q:TIEN=""  D
 . I '$D(VST(TIEN)),TIEN'=PVST K @TMREF@(DFN,VSDT,TIEN)
 Q
PRB ;  EP - Check Problem File for instance of taxonomy
 ; Called by BQITD03
 ;
 ;     PVIEN - Taxonomy entry
 ;     TPGLOB - Problem file temporary global reference
 ;
 NEW IEN,PGREF,PFREF,DFN,VSDTM
 ;  Go through the problem file, starting with the most recent entry
 S IEN="",PGREF="^AUPNPROB",PFREF=9000011,PROB=0
 F  S IEN=$O(@PGREF@("B",PVIEN,IEN),-1) Q:IEN=""  D
 . ;  get the patient record
 . S DFN=$$GET1^DIQ(PFREF,IEN,.02,"I") I DFN="" Q
 . ;  get the date of the problem, since not all dates exist, the
 . ;
 . ;  Check class - if Family ignore
 . I $$GET1^DIQ(PFREF,IEN,.04,"I")="F" Q
 . ;  hierarchy is 'DATE ENTERED', and then 'DATE LAST MODIFIED'.
 . S VSDTM=$$PROB^BQIUL1(IEN)\1 Q:VSDTM=0
 . ;  if there is a specified timeframe for the instance and the
 . ;  problem date doesn't fall within that timeframe, quit
 . I $G(TMFRAME)'="",VSDTM<ENDT Q
 . ;  if the problem is not an 'active' one, quit
 . I $$GET1^DIQ(PFREF,IEN,.12,"I")'="A" Q
 . ;  set the qualifying criteria for this patient and diagnostic category
 . S @TPGLOB@(DFN,VSDTM,PVIEN)="P"_U_IEN
 . S $P(@TPGLOB@(DFN,VSDTM,PVIEN),U,6)=TAX
 . S @TPGLOB@(DFN)=$G(@TPGLOB@(DFN))+1
 Q
 ;
PPRB ;EP - Check Problem File for instance of a patient
 ; Called by BQITD03
 ; Input Parameters
 ;   DFN - Patient record
 ;   TPGLOB - Temporary global
 NEW PGREF,PFREF,PVIEN,VSDTM
 S PGREF="^AUPNPROB",PFREF=9000011,PROB=0
 S PVIEN=""
 F  S PVIEN=$O(@PGREF@("AC",DFN,PVIEN),-1) Q:PVIEN=""  D
 . S TIEN=$$GET1^DIQ(PFREF,PVIEN,.01,"I") I TIEN="" Q
 . I '$D(@TREF@(TIEN)) Q
 . ;  Check class - if Family ignore
 . I $$GET1^DIQ(PFREF,PVIEN,.04,"I")="F" Q
 . I $$GET1^DIQ(PFREF,PVIEN,.12,"I")'="A" Q
 . S VSDTM=$$PROB^BQIUL1(PVIEN)\1 Q:VSDTM=0
 . I $G(TMFRAME)'="",VSDTM<ENDT Q
 . S @TPGLOB@(DFN,VSDTM,TIEN)="P"_U_PVIEN
 . S $P(@TPGLOB@(DFN,VSDTM,TIEN),U,6)=TAX
 . S @TPGLOB@(DFN)=$G(@TPGLOB@(DFN))+1
 Q
