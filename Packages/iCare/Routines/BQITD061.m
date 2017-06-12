BQITD061 ;GDHD/HS/ALA-ASCVD At Risk ; 04 May 2016  6:46 AM
 ;;2.5;ICARE MANAGEMENT SYSTEM;**1**;May 24, 2016;Build 17
 ;
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
 NEW TDFN,AGE,MX
 ;
 S TDFN=0
 F  S TDFN=$O(^AUPNPAT(TDFN)) Q:'TDFN  D
 . S AGE=$$AGE^BQIAGE(TDFN)
 . I AGE<21 Q
 . S MX=$$MEAS^BQIDCUTL(TDFN,"ACC")
 . I $P(MX,"^",3)>7.49 D
 .. S @TGLOB@(TDFN)="",VISIT=$P(MX,"^",4),IEN=$P(MX,"^",5)
 .. S @TGLOB@(TDFN,"CRITERIA","ACC 10 Year ASCVD Risk & Age","V",VISIT,IEN)=$P($G(^AUPNVSIT(VISIT,0)),U,1)_U_U_IEN_U_9000010.01
 . F TXDXCT="ASCVD Known" I $$ATAG^BQITDUTL(TDFN,TXDXCT) K @TGLOB@(TDFN)
 Q
 ;
PAT(DEF,TGLOB,BDFN) ; EP -- By Patient
 ;Description
 ;  Checks if a patient meets the criteria for ASCVD At Risk
 ;Input
 ;  TGLOB - Temporary global
 ;  BDFN   - patient internal entry number
 ;
 S FLAG=0
 S QFL=0 F TXDXCT="ASCVD Known" D  Q:QFL
 . I $$ATAG^BQITDUTL(BDFN,TXDXCT) S QFL=1 Q
 I QFL Q FLAG
 ;
 S AGE=$$AGE^BQIAGE(BDFN)
 S FLAG=0
 D
 . I AGE<21 Q
 . S MX=$$MEAS^BQIDCUTL(BDFN,"ACC")
 . I $P(MX,"^",3)>7.49 D
 .. S VISIT=$P(MX,"^",4),IEN=$P(MX,"^",5),FLAG=1
 .. S @TGLOB@(BDFN,"CRITERIA","ACC 10 Year ASCVD Risk & Age","V",VISIT,IEN)=$P($G(^AUPNVSIT(VISIT,0)),U,1)_U_U_IEN_U_9000010.01
 Q FLAG
