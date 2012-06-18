BQITD10 ;PRXM/HC/ALA-Obese Definition ; 04 Apr 2006  1:36 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
POP(BQARY,TGLOB) ; EP -- By population
 ;
 ;Description
 ;  Finds all patients who meet the criteria for Obese
 ;Input
 ;  BQIRY - Array of taxonomies and other information
 ;  TGLOB - Global where data is to be stored
 ;          Structure:
 ;          TGLOB(DFN,"CRITERIA",criteria or taxonomy,visit or problem ien)=date/time
 ;
 ;  Clean out any previous data
 NEW DXNN,TDFN,DA,DIK,DFN,TMPG,TX,AGE,BMI,TMFRAME,EXDT,DTDIF,ENDT,STDT
 ;
 I $D(@BQARY) D
 . D POP^BQITDGN(.BQARY,.TGLOB)
 ;
 S TMPG=$NA(^TMP("BQIBMI",UID))
 K @TMPG
 S TMFRAME="T-60M",EXDT="",DTDIF=""
 S ENDT=$$DATE^BQIUL1(TMFRAME),STDT=$$DT^XLFDT()
 S DTDIF=$$FMDIFF^XLFDT(STDT,ENDT,1)
 D ABMI^BQITBMI(TMFRAME,.TMPG)
 S TDFN=0
 F  S TDFN=$O(@TMPG@(TDFN)) Q:'TDFN  D
 . S AGE=$P(@TMPG@(TDFN),"^",2)
 . S BMI=$P(@TMPG@(TDFN),"^",1)
 . I $$OB^BQITBMI(TDFN,BMI,AGE) D
 .. F TX="BMI-Height","BMI-Weight" D
 ... S VISIT=$O(@TMPG@(TDFN,"CRITERIA",TX,"V",""))
 ... S IEN=""
 ... F  S IEN=$O(@TMPG@(TDFN,"CRITERIA",TX,"V",VISIT,IEN)) Q:IEN=""  D
 .... S VSDTM=@TMPG@(TDFN,"CRITERIA",TX,"V",VISIT,IEN)
 .... I DTDIF'="" S EXDT=$$FMADD^XLFDT(VSDTM,DTDIF)
 .... S @TGLOB@(TDFN,"CRITERIA","BMI","V",VISIT,IEN)=VSDTM_U_U_IEN_U_"9000010.01"
 .... I EXDT'="" S $P(@TGLOB@(TDFN,"CRITERIA","BMI","V",VISIT,IEN),U,2)=EXDT
 K @TMPG
 Q
 ;
PAT(DEF,TGLOB,BDFN) ; EP -- By patient
 ;Description
 ;  Checks if a patient meets the criteria for Obese
 ;    if adult and BMI is =>30
 ;Input
 ;  BDFN   - patient internal entry number
 ;
 NEW AGE,BMI,BMID,VIENS,VST,VSDTM,TMFRAME,EXDT,DTDIF,ENDT,STDT
 S TMFRAME="T-60M",EXDT="",DTDIF=""
 S ENDT=$$DATE^BQIUL1(TMFRAME),STDT=$$DT^XLFDT()
 S DTDIF=$$FMDIFF^XLFDT(STDT,ENDT,1)
 S BMID=$$OBMI^BQITBMI(BDFN,TMFRAME)
 S BMI=$P(BMID,"^",1),AGE=$P(BMID,"^",2),VIENS=$P(BMID,"^",3),MIENS=$P(BMID,"^",4)
 I BMI'="",$$OB^BQITBMI(BDFN,BMI,AGE) D  Q 1
 . F I=1:1 S VST=$P(VIENS,",",I) Q:VST=""  D
 .. S VSDTM=$P($G(^AUPNVSIT(VST,0)),U,1)
 .. S IEN=$P(MIENS,",",I)
 .. I DTDIF'="" S EXDT=$$FMADD^XLFDT(VSDTM,DTDIF)
 .. S @TGLOB@(BDFN,"CRITERIA","BMI","V",VST,IEN)=VSDTM_U_U_IEN_U_"9000010.01"
 .. I EXDT'="" S $P(@TGLOB@(BDFN,"CRITERIA","BMI","V",VST,IEN),U,2)=EXDT
 Q 0
