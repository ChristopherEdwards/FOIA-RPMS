BQIFLG ;PRXM/HC/ALA-Get flags for all patients in panels ; 13 Dec 2005  9:28 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
FND ;EP - Find all flags for a patient
 ;
 ;Description
 ;  This program should be run nightly to determine all the flags that any patient
 ;  found in the BQICARE file has
 ;Parameters
 ;  PPIEN = Definition internal entry number
 ;  EXEC  = Executable code
 ;  PORD  = Flag order
 ;
 ;  Purge flags older than 7 months
 NEW DFN,FLG,DTM,PRGDT,REC
 S DFN=0,PRGDT=$$DATE^BQIUL1("T-7M")
 F  S DFN=$O(^BQIPAT(DFN)) Q:'DFN  D
 . S FLG=0
 . F  S FLG=$O(^BQIPAT(DFN,10,FLG)) Q:'FLG  D
 .. S DTM=""
 .. F  S DTM=$O(^BQIPAT(DFN,10,FLG,5,"AC",DTM)) Q:DTM=""  D
 ... S REC=""
 ... F  S REC=$O(^BQIPAT(DFN,10,FLG,5,"AC",DTM,REC)) Q:REC=""  D
 .... NEW DA,DIK
 .... S DA(2)=DFN,DA(1)=FLG,DA=REC
 .... S DIK="^BQIPAT("_DA(2)_",10,"_DA(1)_",5," D ^DIK
 ;
 S PORD=""
 F  S PORD=$O(^BQI(90506,"AC",PORD)) Q:PORD=""  D
 . S PPIEN=0
 . F  S PPIEN=$O(^BQI(90506,"AC",PORD,PPIEN)) Q:'PPIEN  D
 .. ; if the definition is inactive, quit
 .. Q:$$GET1^DIQ(90506,PPIEN_",",.02,"I")=1
 .. ; if the definition is not a flag definition, quit
 .. Q:$$GET1^DIQ(90506,PPIEN_",",.04,"I")'="A"
 .. S EXEC=$$GET1^DIQ(90506,PPIEN_",",2,"E")
 .. Q:EXEC=""
 .. ; define time frame for the largest valid range
 .. S PARMS("TMFRAME")="T-6M"
 .. X EXEC
 .. Q:'$D(@GLREF)
 .. NEW DFN,VIEN
 .. S DFN=""
 .. F  S DFN=$O(@GLREF@(DFN)) Q:DFN=""  D
 ... ; Exclude deceased patients
 ... I $P($G(^DPT(DFN,.35)),U,1)'="" Q
 ... ; If patient has no active HRNs, quit
 ... I '$$HRN^BQIUL1(DFN) Q
 ... ; If patient has no visit in 3 years, quit
 ... I '$$VTHR^BQIUL1(DFN) Q
 ... ;  if the patient is not in the ICARE PATIENT INDEX file, add them
 ... I $G(^BQIPAT(DFN,0))="" D
 .... NEW DIC,X,DINUM,DLAYGO
 .... S (X,DINUM)=DFN,DLAYGO=90507.5,DIC="^BQIPAT(",DIC(0)="L",DIC("P")=DLAYGO
 .... K DO,DD D FILE^DICN
 ... ;  add the flag definition for the patient
 ... NEW DIC,X,DINUM,DLAYGO,DA
 ... S (X,DINUM)=PPIEN,DLAYGO=90507.51,DA(1)=DFN
 ... I '$D(^BQIPAT(DA(1),10,0)) S ^BQIPAT(DA(1),10,0)="^90507.51P^^"
 ... S DIC="^BQIPAT("_DA(1)_",10,",DIC(0)="L"
 ... K DO,DD D FILE^DICN
 ... ;  for each record, if it isn't already in the file, add it as a flag record
 ... S RCIEN=""
 ... F  S RCIEN=$O(@GLREF@(DFN,RCIEN)) Q:RCIEN=""  D
 .... NEW DIC,DA,IENS,NFLG
 .... S DA(2)=DFN,DA(1)=PPIEN,X=RCIEN,NFLG=0
 .... I '$D(^BQIPAT(DA(2),10,DA(1),5,0)) S ^BQIPAT(DA(2),10,DA(1),5,0)="^90507.515^^"
 .... S DIC="^BQIPAT("_DA(2)_",10,"_DA(1)_",5,",DIC(0)="LXZ"
 .... D ^DIC
 .... S (DA,RIEN)=+Y S:$P(Y,U,3)=1 NFLG=1
 .... S IENS=$$IENS^DILF(.DA)
 .... ; set the date of the visit
 .... S BQIUPD(90507.515,IENS,.02)=$P(@GLREF@(DFN,RCIEN),U,2)
 .... S BQIUPD(90507.515,IENS,.04)=$P(@GLREF@(DFN,RCIEN),U,1)
 .... I NFLG S BQIUPD(90507.515,IENS,.03)=$$NOW^XLFDT()
 .... D FILE^DIE("","BQIUPD","ERROR")
 .... K BQIUPD
 .... ;
 .... NEW DIC,DA,DLAYGO,X,DINUM
 .... S DA(3)=DFN,DA(2)=PPIEN,DA(1)=RIEN
 .... I '$D(^BQIPAT(DA(3),10,DA(2),5,DA(1),1,0)) S ^BQIPAT(DA(3),10,DA(2),5,DA(1),1,0)="^90507.5151P^^"
 .... ;  for each user that has this patient in a panel, add a user record so
 .... ;  that each user's action/status for this patient and flag can be recorded
 .... S USR=""
 .... F  S USR=$O(^BQICARE("AB",DFN,USR)) Q:USR=""  D
 ..... S (X,DINUM)=USR,DIC="^BQIPAT("_DA(3)_",10,"_DA(2)_",5,"_DA(1)_",1,"
 ..... S DIC(0)="L",DLAYGO=90507.5151,DIC("P")=DLAYGO
 ..... K DO,DD D FILE^DICN
 ..... S UIEN=+Y Q:UIEN<1
 ..... D FND^BQIFLFLG(USR,DFN)
 ..... ;
 ..... ;  Make sure that Shared users can see the flags as well
 ..... S SHRU=""
 ..... F  S SHRU=$O(^BQICARE("C",SHRU)) Q:SHRU=""  D
 ...... I '$D(^BQICARE("C",SHRU,USR)) Q
 ...... S PLIEN=""
 ...... F  S PLIEN=$O(^BQICARE("C",SHRU,USR,PLIEN)) Q:PLIEN=""  D
 ....... I '$D(^BQICARE(USR,1,PLIEN,40,"B",DFN)) Q
 ....... I $P(^BQICARE(USR,1,PLIEN,40,DFN,0),U,2)="R" Q
 ....... D UPU^BQIFLAG(DFN,SHRU)
 .. K @GLREF
 ;
 S USR=0
 F  S USR=$O(^BQICARE(USR)) Q:'USR  D
 . S PLIEN=0
 . F  S PLIEN=$O(^BQICARE(USR,1,PLIEN)) Q:'PLIEN  D CNTP(USR,PLIEN)
 ;
 K Y,X,USR,UIEN,TMFRAME,SSN,SEX,RIEN,PPIEN,PARMS,DOB,DA,AUPNSEX,AUPNPAT
 K AUPNDOD,AUPNDOB,AUPNDAYS,AGE,ABNFL,OWNR,PLIEN,RCIEN,EXEC,GLREF,PORD
 K SHRU
 Q
 ;
CNTP(OWNR,PLIEN) ;EP - Count patients' flags and file the result for panel
 ;
 ;Input
 ;  OWNR  - Owner of the panel
 ;  PLIEN - Panel internal entry number
 ;
 NEW DA,PIENS,DFN,DFN,IENS,CNT,BQIUP
 S DA(1)=OWNR,DA=PLIEN,PIENS=$$IENS^DILF(.DA)
 S DFN=0,CNT=0
 F  S DFN=$O(^BQICARE(OWNR,1,PLIEN,40,DFN)) Q:'DFN  D  Q:CNT
 . S DA(2)=OWNR,DA(1)=PLIEN,DA=DFN,IENS=$$IENS^DILF(.DA)
 . I $$GET1^DIQ(90505.04,IENS,.02,"I")="R" Q
 . S CNT=CNT+$$GET1^DIQ(90505.04,IENS,.08,"I")
 ;
 I CNT>0 S BQIUP(90505.01,PIENS,.12)="Y"
 I CNT=0 S BQIUP(90505.01,PIENS,.12)="N"
 D FILE^DIE("I","BQIUP")
 Q
