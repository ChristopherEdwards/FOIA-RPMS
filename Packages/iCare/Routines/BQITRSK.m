BQITRSK ;PRXM/HC/ALA-CVD Risk Factors ; 11 Apr 2006  4:25 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 Q
 ;
EN(TGLOB) ;EP -- Entry point
 ;  Input
 ;    TGLOB - Global that final results will reside in
 ; 
 ;Current Smoker
 ;  at least 2 smoking POVs ever (not on the same date) or on the 
 ;  Active Problem List or most recent tobacco Health Factor
 ;
 ; Set up array from File 90506.2
 S BQREF="BQIRY" K @BQREF
 S TAX="Current Smoker"
 D ARY^BQITUTL(TAX,BQREF)
 NEW BQGLB1
 S BQGLB1=$NA(^TMP("BQITMPR",UID))
 K @BQGLB1
 ;  Call generic program and return data in BQGLB1
 D POP^BQITDGN(BQREF,BQGLB1)
 ;  If data found, set the criteria
 S TDFN="" F  S TDFN=$O(@BQGLB1@(TDFN)) Q:TDFN=""  D
 . NEW TX
 . S TX=$O(@BQGLB1@(TDFN,"CRITERIA",""))
 . D STOR(TDFN,TX,BQGLB1)
 K @BQGLB1,@BQREF
 ;S TDFN="" F  S TDFN=$O(@TGLOB@(TDFN)) Q:TDFN=""  S @TGLOB@(TDFN)=1
 ;
 ; Set up array from File 90506.2
 S BQREF="BQIRY" K @BQREF
 S TAX="PreDM Metabolic Syndrome"
 D ARY^BQITUTL(TAX,BQREF)
 ; Set to primary and secondary instead of primary only
 I $G(BQIRY(1))'="",$P(BQIRY(1),U,1)["DX" S $P(BQIRY(1),U,8)=0
 NEW BQGLB1
 S BQGLB1=$NA(^TMP("BQITMPS",UID))
 K @BQGLB1
 ;  Call generic program and return data in BQGLB1
 D POP^BQITDGN(BQREF,BQGLB1)
 ;  If data found, set the criteria
 S TDFN="" F  S TDFN=$O(@BQGLB1@(TDFN)) Q:TDFN=""  D
 . NEW TX
 . S TX=$O(@BQGLB1@(TDFN,"CRITERIA",""))
 . D STOR(TDFN,TX,BQGLB1)
 K @BQGLB1,@BQREF,BQIRY
 ;
 ;Hypertension
 ;  If documented as POV at least 3 times separated by 90 days,
 ;  or on the Active problem list.
 ;
 NEW MFL,TAX,NIT,FREF,GREF,TREF,EXDT,SERV,PRIM,TX,TIEN,DTDIF,IEN,VSERV
 S TAX="BGP HYPERTENSION DXS",NIT=3,FREF=9000010.07,PLFLG=1
 S GREF=$$ROOT^DILFD(FREF,"",1),TREF=$NA(^TMP("BQITAX",UID)),EXDT=""
 S SERV="A;H",PRIM=0
 S BQGLB1=$NA(^TMP("BQITMPY",UID))
 S TX="Hypertension"
 K @TREF,@BQGLB1
 ;  Build taxonomy reference
 D BLD^BQITUTL(TAX,TREF)
 S TIEN=0 F  S TIEN=$O(@TREF@(TIEN)) Q:'TIEN  D
 . S DTDIF=""
 . D PRB^BQITD03(TIEN,BQGLB1)
 S TIEN=0 F  S TIEN=$O(@TREF@(TIEN)) Q:'TIEN  D
 . S IEN="" F  S IEN=$O(@GREF@("B",TIEN,IEN),-1) Q:IEN=""  D
 .. I $G(@GREF@(IEN,0))="" Q
 .. S DFN=$$GET1^DIQ(FREF,IEN,.02,"I") Q:DFN=""
 .. ; If there are already 2 or more risk factors, then quit
 .. I $G(@TGLOB@(DFN))'<2 Q
 .. ; if there are more than 3 hypertension diagnoses, then quit
 .. ;I $G(@BQGLB1@(DFN))>3 Q
 .. S VISIT=$$GET1^DIQ(FREF,IEN,.03,"I") Q:VISIT=""
 .. S VSDTM=$$GET1^DIQ(9000010,VISIT,.01,"I")\1 Q:VSDTM=0
 .. I $$GET1^DIQ(9000010,VISIT,.11,"I")=1 Q
 .. ;  check clinical ranking if diagnosis (9000010.07)
 .. I FREF=9000010.07,PRIM I $P(@GREF@(IEN,0),U,12)'="P" S MFL=0 D  Q:'MFL
 ... I $O(@GREF@("AD",VISIT,""))=IEN S MFL=1
 .. ;  if service categories, check the visit for the service category
 .. S VSERV=$$GET1^DIQ(9000010,VISIT,.07,"I")
 .. I $G(SERV)'="",SERV'[VSERV Q
 .. S @BQGLB1@(DFN,VSDTM,TIEN)="V"_U_VISIT_U_EXDT_U_IEN_U_FREF
 .. S @BQGLB1@(DFN)=$G(@BQGLB1@(DFN))+1
 ;
 S DFN=""
 F  S DFN=$O(@BQGLB1@(DFN)) Q:DFN=""  D
 . D HYP(DFN,TGLOB,BQGLB1)
 K @BQGLB1,@TREF
 ;
 ;Obese
 NEW DXNN,TMFRAME,EXDT,DTDIF,ENDT,STDT,BMID,BMI,AGE,TX,VST,IEN,VSDTM
 NEW DTDIF
 S DXNN=$$GDXN^BQITUTL("Obese")
 S TMPG=$NA(^TMP("BQIBMI",UID))
 K @TMPG
 S TMFRAME="T-60M",EXDT="",DTDIF=""
 S ENDT=$$DATE^BQIUL1(TMFRAME),STDT=$$DT^XLFDT()
 S DTDIF=$$FMDIFF^XLFDT(STDT,ENDT,1)
 S TX="Obese"
 D ABMI^BQITBMI(TMFRAME,.TMPG)
 S BQGLB1=$NA(^TMP("BQITMPO",UID))
 K @BQGLB1
 S TDFN=0
 F  S TDFN=$O(@TMPG@(TDFN)) Q:'TDFN  D
 . S BMID=@TMPG@(TDFN)
 . S BMI=$P(BMID,"^",1),AGE=$P(BMID,"^",2)
 . I $$OB^BQITBMI(TDFN,BMI,AGE) D
 .. F TX="BMI-Height","BMI-Weight" S VST="" D
 ... F  S VST=$O(@TMPG@(TDFN,"CRITERIA",TX,"V",VST)) Q:VST=""  D
 .... S IEN="",FREF=9000010.01,EXDT=""
 .... F  S IEN=$O(@TMPG@(TDFN,"CRITERIA",TX,"V",VST,IEN)) Q:IEN=""  D
 ..... S VSDTM=$P(@TMPG@(TDFN,"CRITERIA",TX,"V",VST,IEN),U,1)
 ..... I DTDIF'="" S EXDT=$$FMADD^XLFDT(VSDTM,DTDIF)
 ..... S $P(@BQGLB1@(TDFN,"CRITERIA","Obese","V",VST,IEN),U,1)=VSDTM_U_EXDT_U_IEN_U_FREF
 .. D STOR(TDFN,"Obese",BQGLB1)
 ;
 ;High Blood Pressure
 NEW BQGLB1
 S BQGLB1=$NA(^TMP("BQITMPP",UID))
 K @BQGLB1
 NEW QFL
 S BCLN=$$FIND1^DIC(40.7,"","Q","EMERGENCY","B","")
 S BTYP=$$FIND1^DIC(9999999.07,,"X","BP")
 S BDFN=0
 F  S BDFN=$O(^AUPNVMSR("AA",BDFN)) Q:BDFN=""  D
 . S RDT="",QFL=0
 . F  S RDT=$O(^AUPNVMSR("AA",BDFN,BTYP,RDT)) Q:RDT=""  D  Q:QFL
 .. S CT=0,N=""
 .. F  S N=$O(^AUPNVMSR("AA",BDFN,BTYP,RDT,N)) Q:N=""  D  Q:QFL
 ... S VISIT=$P($G(^AUPNVMSR(N,0)),U,5) Q:VISIT=""
 ... ; if the new ENTERED IN ERROR field exists, exclude the record if it is marked as an error
 ... I $$VFIELD^DILFD(9000010.01,2) Q:$$GET1^DIQ(9000010.01,N_",",2,"I")=1
 ... I $P($G(^AUPNVSIT(VISIT,0)),U,8)=BCLN Q
 ... I $P($G(^AUPNVSIT(VISIT,0)),U,11)=1 Q
 ... S CT=CT+1 I CT>3 S QFL=1 Q
 ... S BP=$P($G(^AUPNVMSR(N,0)),U,4),SYS=$P(BP,"/",1),DIA=$P(BP,"/",2)
 ... I SYS=""!(DIA="") Q
 ... I SYS<140!(DIA<90) Q
 ... I $G(@BQGLB1@(BDFN))'<3 Q
 ... S @BQGLB1@(BDFN)=$G(@BQGLB1@(BDFN))+1,FREF=9000010.01
 ... S @BQGLB1@(BDFN,"CRITERIA","High BP","V",VISIT,N)=$P($G(^AUPNVSIT(VISIT,0)),U,1)_U_EXDT_U_N_U_FREF
 ;
 S TX="High BP"
 S BDFN="" F  S BDFN=$O(@BQGLB1@(BDFN)) Q:BDFN=""  D
 . I $G(@TGLOB@(BDFN))'<2 Q
 . I @BQGLB1@(BDFN)>1,'$D(@TGLOB@(BDFN,"CRITERIA","Hypertension")) D STOR(BDFN,"High BP",BQGLB1)
 K @BQGLB1
 ;
 ;Most recent HDL Lab test
 NEW HDATA
 S HDATA=$NA(^TMP("BQIHDL",UID))
 K @HDATA
 S BQGLB1=$NA(^TMP("BQITMPL",UID))
 K @BQGLB1
 S FREF=9000010.09,GREF=$$ROOT^DILFD(FREF,"",1),TREF=$NA(^TMP("BQITAX",UID))
 K @TREF
 S TAX="DM AUDIT HDL TAX" D BLD^BQITUTL(TAX,TREF)
 S TMFRAME="",ENDT=""
 S TIEN=0 F  S TIEN=$O(@TREF@(TIEN)) Q:'TIEN  D
 . S IEN=""
 . F  S IEN=$O(@GREF@("B",TIEN,IEN),-1) Q:IEN=""  D
 .. I $G(@GREF@(IEN,0))="" Q
 .. S DFN=$$GET1^DIQ(FREF,IEN,.02,"I") Q:DFN=""
 .. S SEX=$$GET1^DIQ(2,DFN,.02,"I")
 .. S VISIT=$$GET1^DIQ(FREF,IEN,.03,"I") Q:VISIT=""
 .. S RESULT=$$GET1^DIQ(FREF,IEN,.04,"E") Q:RESULT=""
 .. S VSDTM=$$GET1^DIQ(9000010,VISIT,.01,"I")\1 Q:'VSDTM
 .. I $$GET1^DIQ(9000010,VISIT,.11,"I")=1 Q
 .. I $G(TMFRAME)'="",VSDTM<ENDT Q
 .. S @HDATA@(DFN,VSDTM)=RESULT_"^"_SEX_"^"_VISIT_"^"_IEN_"^"_FREF
 ;
 NEW TREF1
 S TREF1=$NA(^TMP("BQITAX1",UID)) K @TREF1
 S TAX="BGP HDL LOINC CODES" D BLD^BQITUTL(TAX,TREF1)
 S TIEN=0
 F  S TIEN=$O(@TREF1@(TIEN)) Q:TIEN=""  I $D(@TREF@(TIEN)) K @TREF1@(TIEN)
 S TIEN=0 F  S TIEN=$O(@TREF1@(TIEN)) Q:'TIEN  D
 . S IEN=""
 . F  S IEN=$O(@GREF@("B",TIEN,IEN),-1) Q:IEN=""  D
 .. I $G(@GREF@(IEN,0))="" Q
 .. S DFN=$$GET1^DIQ(FREF,IEN,.02,"I") Q:DFN=""
 .. S SEX=$$GET1^DIQ(2,DFN,.02,"I")
 .. S VISIT=$$GET1^DIQ(FREF,IEN,.03,"I") Q:VISIT=""
 .. S RESULT=$$GET1^DIQ(FREF,IEN,.04,"E") Q:RESULT=""
 .. S VSDTM=$$GET1^DIQ(9000010,VISIT,.01,"I")\1 Q:'VSDTM
 .. I $$GET1^DIQ(9000010,VISIT,.11,"I")=1 Q
 .. I $G(TMFRAME)'="",VSDTM<ENDT Q
 .. I '$D(@HDATA@(DFN,VSDTM)) S @HDATA@(DFN,VSDTM)=RESULT_"^"_SEX_"^"_VISIT_"^"_IEN_"^"_FREF
 ;
 S DFN=""
 F  S DFN=$O(@HDATA@(DFN)) Q:DFN=""  D
 . S DATE="",DATE=$O(@HDATA@(DFN,DATE),-1)
 . S RESULT=$P(@HDATA@(DFN,DATE),U,1)
 . S SEX=$P(@HDATA@(DFN,DATE),U,2)
 . S VISIT=$P(@HDATA@(DFN,DATE),U,3)
 . S IEN=$P(@HDATA@(DFN,DATE),U,4)
 . S FREF=$P(@HDATA@(DFN,DATE),U,5)
 . I SEX="M",RESULT<40 D  Q
 .. S @BQGLB1@(DFN,"CRITERIA","Risk Factor-HDL Lab Test","V",VISIT,IEN)=DATE_U_EXDT_U_IEN_U_FREF
 .. D STOR(DFN,"Risk Factor-HDL Lab Test",BQGLB1)
 . I SEX="F",RESULT<45 D
 .. S @BQGLB1@(DFN,"CRITERIA","Risk Factor-HDL Lab Test","V",VISIT,IEN)=DATE_U_EXDT_U_IEN_U_FREF
 .. D STOR(DFN,"Risk Factor-HDL Lab Test",BQGLB1)
 K @HDATA,@BQGLB1
 ;
 ;Evidence of High Cholesterol
 D DEF^BQITHCH(.TGLOB)
 ;
 ;Evidence of Nephropathy
 D DEF^BQITNPH(.TGLOB)
 ;
 K DATE,RESULT,SEX,DFN,TMFRAME,FREF,GREF,TREF,ENDT,VSDTM,TDFN
 K @HDATA,@BQGLB1,SDFN,BCLN,BP,BTYP,CT,PLFLG,RDT,BMI
 K AGE,SEX,RESULT,BDFN,BQREF,DATE2,DIA,N,NIT,SYS,TAX,TIEN,VISIT
 K TMPG
 Q
 ;
PRB(PVIEN,TPGLOB) ;EP - Check Problem File for all active instances by date
 NEW IEN,PGREF,PFREF
 S IEN=0,PGREF="^AUPNPROB",PFREF=9000011
 F  S IEN=$O(@PGREF@("B",PVIEN,IEN)) Q:'IEN  D
 . S DFN=$$GET1^DIQ(PFREF,IEN,.02,"I") I DFN="" Q
 . I $G(@TPGLOB@(DFN))=1 Q
 . I $$GET1^DIQ(PFREF,PVIEN,.12,"I")'="A" Q
 . ;  Check class - if Family ignore
 . I $$GET1^DIQ(PFREF,PVIEN,.04,"I")="F" Q
 . S VSDTM=$$PROB^BQIUL1(IEN)\1 Q:VSDTM=0
 . I $G(TMFRAME)'="",VSDTM<ENDT Q
 . I '$D(@BQGLB1@(DFN,VSDTM,PVIEN)) D
 .. S @BQGLB1@(DFN,VSDTM,PVIEN)=$G(@TGLOB@(DFN,VSDTM,PVIEN))+1
 .. S @BQGLB1@(DFN)=$G(@BQGLB1@(DFN))+1
 .. S @BQGLB1@(DFN,"CRITERIA",""_TAX,"P",IEN)=VSDTM
 Q
 ;
PPRB(DFN,BQGLB) ;EP - Check Problem File for instance of a specific patient
 NEW PGREF,PFREF,PVIEN,VSDTM
 S PGREF="^AUPNPROB",PFREF=9000011
 S PVIEN=""
 F  S PVIEN=$O(@PGREF@("AC",DFN,PVIEN),-1) Q:'PVIEN  D
 . S TIEN=$$GET1^DIQ(PFREF,PVIEN,.01,"I") I TIEN="" Q
 . I '$D(@TREF@(TIEN)) Q
 . I $$GET1^DIQ(PFREF,PVIEN,.12,"I")'="A" Q
 . ;  Check class - if Family ignore
 . I $$GET1^DIQ(PFREF,PVIEN,.04,"I")="F" Q
 . S VSDTM=$$PROB^BQIUL1(PVIEN)\1
 . I $G(TMFRAME)'="",VSDTM<ENDT Q
 . ;
 . I '$D(@BQGLB@(DFN,VSDTM,PVIEN)) D
 .. S @BQGLB@(DFN,VSDTM,PVIEN)=$G(@BQGLB@(DFN,VSDTM,PVIEN))+1
 .. S @BQGLB@(DFN,"CRITERIA",""_TAX,"P",PVIEN)=VSDTM
 .. S @BQGLB@(DFN)=$G(@BQGLB@(DFN))+1
 Q
 ;
STOR(SDFN,CRIT,BQGLB) ;  Store the patient's met criteria
 I $G(@TGLOB@(SDFN))'<2 Q
 I $D(@TGLOB@(SDFN,"CRITERIA",CRIT))>0 Q
 S @TGLOB@(SDFN)=$G(@TGLOB@(SDFN))+1
 ;S @TGLOB@(SDFN,"CRITERIA",CRIT)=""
 I $D(@BQGLB@(SDFN,"CRITERIA",CRIT)) M @TGLOB@(SDFN,"CRITERIA",CRIT)=@BQGLB@(SDFN,"CRITERIA",CRIT)
 Q
 ;
HYP(DFN,GLOB,TMREF) ; EP - Process Hypertension Risk Factor
 ;
 ; At least three hypertension diagnoses with at least 90 days
 ; between first and last diagnosis
 ; Input
 ;   DFN - patient whose hypertension diagnoses are being examined
 ;   GLOB - Global where data is to be stored
 ;          Structure:
 ;          GLOB(DFN,"CRITERIA",criteria or taxonomy,visit or problem ien)=date/time
 ;   TMREF - Global used to temporarily store diagnoses that may meet the
 ;           IHD logic and, if so, will be stored in GLOB
 ;
 ; Variables
 ;   NOK - If set to '1', no diagnoses remaining that will meet the date logic
 ;   LDX - Most recent diagnosis that meets the IHD criteria
 ;   LDX1 - Next recent diagnosis that meets the IHD criteria
 ;   FDX - Third diagnosis that must be compared to LDX to determine if they
 ;         meet the date logic
 ;   VTYP - Visit type - either 'V' for visit or 'P' for problem
 N DXOK,NOK,LDX,LDX1,FDX,DX
 I $G(@TMREF@(DFN))<3 K @TMREF@(DFN) Q
 S DXOK=0,NOK=0
 F  D  Q:DXOK!NOK  K @TMREF@(DFN,LDX)
 . S LDX=$O(@TMREF@(DFN,"A"),-1) I LDX="" S NOK=1 Q
 . S LDX1=$O(@TMREF@(DFN,LDX),-1) I LDX1="" S NOK=1 Q
 . ; Only one problem can be included
 . I $$TYP^BQITD031(DFN,LDX,TMREF)="P",$$TYP^BQITD031(DFN,LDX1,TMREF)="P" D  I LDX1="" S NOK=1 Q
 .. F  S LDX1=$O(@TMREF@(DFN,LDX1),-1) Q:LDX1=""  I $$TYP^BQITD031(DFN,LDX1,TMREF)="V" Q
 . S FDX=LDX1
 . F  S FDX=$O(@TMREF@(DFN,FDX),-1) Q:FDX=""  D  Q:DXOK
 .. I $$TYP^BQITD031(DFN,LDX,TMREF)="P"!($$TYP^BQITD031(DFN,LDX1,TMREF)="P"),$$TYP^BQITD031(DFN,FDX,TMREF)="P" Q
 .. I $$FMDIFF^XLFDT(LDX,FDX,1)>89 S DXOK=1 D  Q
 ... ; Delete remaining entries from temporary file
 ... S DX=""
 ... F  S DX=$O(@TMREF@(DFN,DX)) Q:DX=""  I DX'=LDX,DX'=LDX1,DX'=FDX K @TMREF@(DFN,DX)
 I DXOK D
 .S @GLOB@(DFN)=$G(@GLOB@(DFN))+1
 .;S @GLOB@(DFN,"CRITERIA","Hypertension")=""
 . NEW IEN,FREF,EXDT,VSDT,TIEN,VISIT,VTYP,FREF
 . S VSDT="",EXDT=""
 . F  S VSDT=$O(@TMREF@(DFN,VSDT)) Q:VSDT=""  D
 .. S TIEN="" F  S TIEN=$O(@TMREF@(DFN,VSDT,TIEN)) Q:TIEN=""  D
 ... S VISIT=$P(@TMREF@(DFN,VSDT,TIEN),U,2),VTYP=$P(@TMREF@(DFN,VSDT,TIEN),U,1)
 ... S IEN=$P(@TMREF@(DFN,VSDT,TIEN),U,4),FREF=$P(@TMREF@(DFN,VSDT,TIEN),U,5)
 ... I VTYP="V" S @GLOB@(DFN,"CRITERIA",TAX,VTYP,VISIT,IEN)=VSDT_U_EXDT_U_IEN_U_FREF
 ... I VTYP="P" S @GLOB@(DFN,"CRITERIA",TAX,VTYP,VISIT)=VSDT_U_EXDT
 Q
