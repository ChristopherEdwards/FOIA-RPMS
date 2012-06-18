BQITD081 ;APTIV/HC/DB-HIV/AIDS Definition (cont) ; 04 Jun 2008  9:01 AM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ; Utilities called by BQITD08
 ;
 Q
 ;
POV(DFN,GLOB,TMREF,DXOK) ; EP - Process HIV/AIDS POV date logic
 ;
 ; At least two POVs ever at least 60 days apart
 ;
 ; Input
 ;   DFN - patient whose HIV/AIDS POVs are being examined
 ;   GLOB - Global where data is to be stored
 ;          Structure:
 ;          GLOB(DFN,"CRITERIA",criteria or taxonomy,visit ien)=date/time
 ;   TMREF - Global used to temporarily store diagnoses that may meet the
 ;           POV logic and, if so, will be stored in GLOB
 ;   DXOK - If set to '1', patient meets the POV logic for HIV/AIDS - value
 ;          may be returned (if called by PAT subroutine)
 ; Variables
 ;   NOK - If set to '1', no diagnoses remaining that will meet the date logic
 ;   LDX - Most recent diagnosis that meets the POV criteria
 ;   FDX - Other diagnosis that must be compared to LDX to determine if they
 ;         meet the date logic
 N NOK,LDX,FDX,DX
 I $G(@TMREF@(DFN))<2 K @TMREF@(DFN) Q
 S DXOK=0,NOK=0
 F  D  Q:DXOK!NOK  K @TMREF@(DFN,LDX)
 . S LDX=$O(@TMREF@(DFN,"A"),-1) I LDX="" S NOK=1 Q
 . S FDX=LDX
 . F  S FDX=$O(@TMREF@(DFN,FDX),-1) Q:FDX=""  D  Q:DXOK
 .. I $$FMDIFF^XLFDT(LDX,FDX,1)>59 S DXOK=1 D
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
 ... S @GLOB@(DFN,"CRITERIA",TAX,VTYP,VISIT,IEN)=VSDT_U_EXDT_U_IEN_U_FREF
 Q
 ;
CDVL(DFN,GLOB,TMREF,DXOK) ; EP - Process CD4/Viral Load date logic
 ;
 ; At least two CD4 or Viral Load lab tests in the past two years
 ; at least 60 days apart
 ; Note: one CD4 and one Viral Load lab test in the past two years
 ;       at least 60 days apart also meet this criteria
 ;
 ; Input
 ;   DFN - patient whose CD4 and Viral Load lab tests are being examined
 ;   GLOB - Global where data is to be stored
 ;          Structure:
 ;          GLOB(DFN,"CRITERIA",criteria or taxonomy,visit ien)=date/time
 ;   TMREF - Global used to temporarily store diagnoses that may meet the
 ;           POV logic and, if so, will be stored in GLOB
 ;   DXOK - If set to '1', patient meets the lab test logic for HIV/AIDS
 ;        - value may be returned (if called by PAT subroutine)
 ; Variables
 ;   NOK - If set to '1', no lab tests remaining that will meet the date logic
 ;   LDX - Most recent lab test that meets the POV criteria
 ;   FDX - Other lab test that must be compared to LDX to determine if they
 ;         meet the date logic
 N NOK,LDX,FDX,DX,ENDT
 I $G(@TMREF@(DFN))<2 K @TMREF@(DFN) Q
 S ENDT=$$FMADD^XLFDT(DT,-730) ; Can only be within the past 2 years
 S DXOK=0,NOK=0
 F  D  Q:DXOK!NOK  K @TMREF@(DFN,LDX)
 . S LDX=$O(@TMREF@(DFN,"A"),-1) I LDX<ENDT S NOK=1 Q
 . S FDX=LDX
 . F  S FDX=$O(@TMREF@(DFN,FDX),-1) Q:FDX<ENDT  D  Q:DXOK
 .. I $$FMDIFF^XLFDT(LDX,FDX,1)>59 S DXOK=1 D
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
 ... S @GLOB@(DFN,"CRITERIA",TAX,VTYP,VISIT,IEN)=VSDT_U_EXDT_U_IEN_U_FREF
 Q
