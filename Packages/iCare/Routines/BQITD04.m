BQITD04 ;PRXM/HC/ALA-CVD Highest Risk ; 10 Apr 2006  4:29 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
POP(BQARY,TGLOB) ; EP
 ;
 ;Description
 ;  Finds all patients who meet the criteria for CVD Highest Risk
 ;Input
 ;  BQARY - Array of taxonomies and other information
 ;  TGLOB - Global where data is to be stored
 ;          Structure:
 ;          TGLOB(DFN,"CRITERIA",criteria or taxonomy,visit or problem ien)=date/time
 ;Variables
 ;  TAX - Taxonomy name
 ;  NIT - Number of iterations
 ;  TMFRAME - Timeframe
 ;  FREF - File number to search
 ;  GREF - Global reference of FREF
 ;  TREF - Taxonomy temporary global
 ;
 NEW TDFN,TDXNCN,TPPGLOB,DXNN,TDFN,RGIEN
 S TPPGLOB=$NA(^TMP("TEMPD",UID))
 K @TPPGLOB
 ;
 ;  Using same logic as Diabetes, find if valid for Highest Risk
 S TDFN="",TDXNCN=$$GDXN^BQITUTL("Diabetes")
 S BQDREF="BQIREF" K @BQDREF
 D ARY^BQITUTL(TDXNCN,BQDREF)
 I $D(@BQDREF) D
 . D POP^BQITDGN(.BQDREF,.TPPGLOB)
 K @BQDREF,BQDREF
 ;
 ;  Check for ESRD
 I $D(@BQARY) D
 . D POP^BQITDGN(.BQARY,.TGLOB,1)
 ;
 S DFN=0
 F  S DFN=$O(@TPPGLOB@(DFN)) Q:'DFN  M @TGLOB@(DFN)=@TPPGLOB@(DFN)
 I $D(@TPPGLOB) K @TPPGLOB
 ;
 ; If already CVD Known, then cannot be at highest risk
 NEW TDFN,TDXNCN
 S TDFN="",TDXNCN=$$GDXN^BQITUTL("CVD Known")
 F  S TDFN=$O(@TGLOB@(TDFN)) Q:'TDFN  D
 . ; If the patient has been tagged as CVD Known
 . I $$ATAG^BQITDUTL(TDFN,"CVD Known") K @TGLOB@(TDFN)
 ;
 Q
 ;
PAT(DEF,BTGLOB,BDFN) ; EP -- By patient
 NEW DXOK,BQDXN,TGLOB,BQREF,TDXNCN,TDXNCN1,DXNN
 S DXOK=0
 ;
 ; If patient already active for 'CVD Known', quit
 I $$ATAG^BQITDUTL(BDFN,"CVD Known") Q DXOK
 ; See if patient meets diabetes criteria
 S BQDXN=$$GDXN^BQITUTL("Diabetes")
 S BQDREF="BQIREF" K @BQDREF
 D GDF^BQITUTL(BQDXN,BQDREF)
 S DXOK=$$PAT^BQITDGN(.BQDREF,BTGLOB,BDFN)
 I DXOK Q DXOK
 ;
 ;  Check for ESRD
 S BQDXN=$$GDXN^BQITUTL(DEF)
 S BQREF="BQIRY"
 D GDF^BQITUTL(BQDXN,BQREF)
 S DXOK=$$PAT^BQITDGN(BQREF,BTGLOB,BDFN,1)
 Q DXOK
