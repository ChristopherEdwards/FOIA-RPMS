BQITRMT ;PRXM/HC/ALA - Find Treatment Prompts ; 24 Apr 2007  12:29 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 Q
 ;
EN ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 D POP
 Q
 ;
POP ; Find all Treatment Prompts for CVD tagged patients
 ; Parameters
 ;   BQTDN  - Tag IEN
 ;   PRI    - Treatment priority for the tag
 ;   BQTIEN - Treatment IEN
 ;   BQIDFN - Patient IEN
 ;
 NEW BQTDN,BQRIEN
 S BQTDN=""
 F  S BQTDN=$O(^BQI(90508.5,"AD",BQTDN)) Q:BQTDN=""  D
 . ;
 . ; For every patient with this tag
 . S BQRIEN=""
 . F  S BQRIEN=$O(^BQIREG("B",BQTDN,BQRIEN)) Q:BQRIEN=""  D
 .. S BQIDFN=$P(^BQIREG(BQRIEN,0),U,2),STAT=$P(^(0),U,3)
 .. ; Remove treatment prompt
 .. D DEL(BQIDFN)
 .. ; If the tag status is not an active status, quit
 .. I '$$ACST^BQITDUTL(STAT) Q
 .. ; If no active HRNS, quit
 .. I '$$HRN^BQIUL1(BQIDFN) Q
 .. ; If no visit in last 3 years, quit
 .. I '$$VTHR^BQIUL1(BQIDFN) Q
 .. ; Set the date/time last updated
 .. I $G(^BQIPAT(BQIDFN,0))'="" S $P(^BQIPAT(BQIDFN,0),U,7)=$$NOW^XLFDT()
 .. ;
 .. S PRI=""
 .. F  S PRI=$O(^BQI(90508.5,"AD",BQTDN,PRI)) Q:PRI=""  D
 ... S BQTIEN=""
 ... F  S BQTIEN=$O(^BQI(90508.5,"AD",BQTDN,PRI,BQTIEN)) Q:BQTIEN=""  D
 .... I $P(^BQI(90508.5,BQTIEN,0),U,4)=1 Q
 .... ; Set the treatment remarks into array
 .... K BQIRMK
 .... S BK=0
 .... F  S BK=$O(^BQI(90508.5,BQTIEN,1,BK)) Q:'BK  S BQIRMK(BK)=^BQI(90508.5,BQTIEN,1,BK,0)
 .... ;
 .... ; Determine if this patient meets this treatment prompt definition,
 .... ; if they do, store the remarks into the iCare Patient file
 .... I $$FND^BQITRPPT(BQTIEN,"BQITEST",BQIDFN,.BQIRMK) D FILE
 .... Q
 ... Q
 .. Q
 . Q
 Q
 ;
PAT(BQIDFN) ;EP - Find treatment prompts for one patient
 ; Remove treatment prompt for this patient
 I $G(UID)="" S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 ;
 D DEL(BQIDFN)
 ; If no active HRNS, quit
 I '$$HRN^BQIUL1(BQIDFN) Q
 ; If no visit in last 3 years, quit
 I '$$VTHR^BQIUL1(BQIDFN) Q
 ; Set the date/time last updated
 I $G(^BQIPAT(BQIDFN,0))'="" S $P(^BQIPAT(BQIDFN,0),U,7)=$$NOW^XLFDT()
 ;
 S BQTDN=0
 F  S BQTDN=$O(^BQIREG("C",BQIDFN,BQTDN)) Q:BQTDN=""  D
 . ; If tag has no associated treatment prompts, quit
 . I $O(^BQI(90508.5,"AD",BQTDN,""))="" Q
 . S RCIEN=$O(^BQIREG("C",BQIDFN,BQTDN,"")) I RCIEN="" Q
 . S STAT=$P(^BQIREG(RCIEN,0),U,3)
 . ; If the tag status is not accepted or proposed, quit
 . I '$$ACST^BQITDUTL(STAT) Q
 . S PRI=""
 . F  S PRI=$O(^BQI(90508.5,"AD",BQTDN,PRI)) Q:PRI=""  D
 .. S BQTIEN=""
 .. F  S BQTIEN=$O(^BQI(90508.5,"AD",BQTDN,PRI,BQTIEN)) Q:BQTIEN=""  D
 ... I $P(^BQI(90508.5,BQTIEN,0),U,4)=1 Q
 ... ;
 ... ; Set up the treatment remarks into array
 ... K BQIRMK
 ... S BK=0
 ... F  S BK=$O(^BQI(90508.5,BQTIEN,1,BK)) Q:'BK  S BQIRMK(BK)=^BQI(90508.5,BQTIEN,1,BK,0)
 ... ;
 ... ; Determine if this patient meets this treatment prompt definition,
 ... ; if they do, store the remarks into the iCare Patient file
 ... I $$FND^BQITRPPT(BQTIEN,"BQITEST",BQIDFN,.BQIRMK) D FILE
 ... Q
 .. Q
 . Q
 Q
 ;
FILE ;EP - File a record
 NEW DA,DIC
 S DA(1)=BQIDFN,(DINUM,X)=BQTIEN,DIC="^BQIPAT("_DA(1)_",50,",DIC(0)="L"
 S DLAYGO=90507.55,DIC("P")=DLAYGO
 I $G(^BQIPAT(BQIDFN,50,0))="" S ^BQIPAT(BQIDFN,50,0)="^90507.55P^^"
 K DO,DD D FILE^DICN
 S DA=+Y
 S IENS=$$IENS^DILF(.DA)
 S BQIUPD(90507.55,IENS,.02)=DT
 D FILE^DIE("","BQIUPD","ERROR")
 ;
 D WP^DIE(90507.55,IENS,1,"","BQIRMK","ERROR")
 K BQIRMK
 Q
 ;
DEL(BQDFN) ;EP - Delete treatment prompts
 NEW BQIUPD
 S BQIUPD(90507.5,BQDFN_",",.07)="@"
 D FILE^DIE("","BQIUPD","ERROR")
 NEW DIK,DA
 S DA(1)=BQDFN,DIK="^BQIPAT("_DA(1)_",50,"
 S DA=0 F  S DA=$O(^BQIPAT(DA(1),50,DA)) Q:'DA  D ^DIK
 Q
