BQITD06 ;PRXM/HC/ALA-CVD At Risk ; 10 Apr 2006  6:50 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 Q
 ;
POP(BQARY,TGLOB) ; EP -- By population
 ;
 ;Description
 ;  Finds all patients who meet the criteria for CVD at Risk
 ;Input
 ;  BQARY - Array of taxonomies and other information
 ;  TGLOB - Global where data is to be stored and passed back
 ;          to calling routine
 ;          Structure:
 ;          TGLOB(DFN,"CRITERIA",criteria or taxonomy,visit or problem ien)=date/time
 ;Variables
 ;  TAX - Taxonomy name
 ;  NIT - Number of iterations
 ;  TMFRAME - Time frame of check
 ;  FREF - File Number reference
 ;  PLFLG - Problem File flag
 ;  GREF - Global reference
 ;  TREF - Taxonomy temp reference
 ;
 ;  Clean up all current entries
 NEW DXNN,TDFN,DA,DIK,AGE,DFN,FLAG,SEX,TXDXCN,TXDXCT,VSDTM,RGIEN,QFL
 S TDFN=0
 F  S TDFN=$O(^AUPNPAT(TDFN)) Q:'TDFN  D
 . S SEX=$$GET1^DIQ(2,TDFN,.02,"I")
 . S AGE=$$AGE^BQIAGE(TDFN)
 . ; Factor for CVD At Risk is AGE - as per IHS
 . I SEX="M",AGE'<45 S @TGLOB@(TDFN)="",@TGLOB@(TDFN,"CRITERIA","Age: "_AGE)=""
 . I SEX="F",AGE'<55 S @TGLOB@(TDFN)="",@TGLOB@(TDFN,"CRITERIA","Age: "_AGE)=""
 . ;
 . S QFL=0 F TXDXCT="CVD Known","CVD Highest Risk","CVD Significant Risk" D  Q:QFL
 .. I $$ATAG^BQITDUTL(TDFN,TXDXCT) K @TGLOB@(TDFN) S QFL=1
 Q
 ;
PAT(DEF,TGLOB,BDFN) ; EP -- By Patient
 ;Description
 ;  Checks if a patient meets the criteria for CVD At Risk
 ;Input
 ;  TGLOB - Temporary global
 ;  BDFN   - patient internal entry number
 ;
 S FLAG=0
 S QFL=0 F TXDXCT="CVD Known","CVD Highest Risk","CVD Significant Risk" D  Q:QFL
 . I $$ATAG^BQITDUTL(BDFN,TXDXCT) S QFL=1 Q
 I QFL Q FLAG
 ;
 S SEX=$$GET1^DIQ(2,BDFN,.02,"I")
 S AGE=$$AGE^BQIAGE(BDFN)
 S FLAG=0
 I SEX="M",AGE'<45 D
 . S FLAG=1
 . ; Factor for CVD At Risk is AGE - as per IHS
 . S @TGLOB@(BDFN,"CRITERIA","Age: "_AGE)=""
 ;
 I SEX="F",AGE'<55 D
 . S FLAG=1
 . ; Factor for CVD At Risk is AGE - as per IHS
 . S @TGLOB@(BDFN,"CRITERIA","Age: "_AGE)=""
 Q FLAG
