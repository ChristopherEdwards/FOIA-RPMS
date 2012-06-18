BQIPLAP ;PRXM/HC/ALA-Add Patients ; 11 Sep 2006  5:36 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
MANP(DATA,OWNR,PLIEN,FLAG,PLIST) ; EP - BQI MANUAL ADD/REMOVE PATIENTS
 ;
 ;Description
 ;  Manually add a patient or remove a patient from a panel
 ;Input
 ;  OWNR  - Owner of the panel
 ;  PLIEN - Panel internal entry number
 ;  FLAG  - "A" for add, "R" for remove
 ;  PLIST - List of patient IENs separated by $C(28)
 ;DUZ is assumed to be the user signed onto iCare.
 ;DFN is the Patient internal entry number
 ;
 NEW UID,II,X,RESULT,LIST,BN
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIMANP",UID))
 K ^TMP("BQIMANP",UID)
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIPLAP D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 ; Check if share and has write access
 I DUZ'=OWNR,'$$CKSHR^BQIPLSH(OWNR,PLIEN) S BMXSEC="You do not have write access" Q
 ;
 S PLIST=$G(PLIST,"")
 I PLIST="" D
 . S LIST="",BN=""
 . F  S BN=$O(PLIST(BN)) Q:BN=""  S LIST=LIST_PLIST(BN)
 . K PLIST
 . S PLIST=LIST
 . K LIST
 F BQI=1:1 S DFN=$P(PLIST,$C(28),BQI) Q:DFN=""  D
 . NEW DA,IENS
 . ;Check if patient is already in panel
 . I $D(^BQICARE(OWNR,1,PLIEN,40,DFN)) D
 .. I $P(^BQICARE(OWNR,1,PLIEN,40,DFN,0),U,2)="A",FLAG="A" S RESULT=0 Q
 .. I $P(^BQICARE(OWNR,1,PLIEN,40,DFN,0),U,2)="R",FLAG="R" S RESULT=0 Q
 .. I FLAG="A" D APTM(DFN)
 .. I FLAG="R" D RPTM(DFN)
 . ;
 . I '$D(^BQICARE(OWNR,1,PLIEN,40,DFN)),FLAG="A" D APTM(DFN)
 . I '$D(^BQICARE(OWNR,1,PLIEN,40,DFN)),FLAG="R" S RESULT=0
 ;
 S DIK(1)=".01",DA(2)=OWNR,DA(1)=PLIEN
 S DIK="^BQICARE("_DA(2)_",1,"_DA(1)_",40,"
 D ENALL^DIK
 ;  Get total count of patients
 D CNTP(OWNR,PLIEN)
 ;
 NEW DA,PIENS,BQIUP
 S DA(1)=OWNR,DA=PLIEN,PIENS=$$IENS^DILF(.DA)
 S BQIUP(90505.01,PIENS,.09)=$$NOW^XLFDT()
 S BQIUP(90505.01,PIENS,.08)=DUZ
 D FILE^DIE("","BQIUP","ERROR")
 ;
 S II=0,^TMP("BQIMANP",UID,II)="I00010RESULT"_$C(30)
 S II=II+1,^TMP("BQIMANP",UID,II)=RESULT_$C(30)
 S II=II+1,^TMP("BQIMANP",UID,II)=$C(31)
 Q
 ;
APTM(DFN) ;EP - Add patient record manually
 NEW DA,DATA
 S DA(2)=OWNR,DA(1)=PLIEN
 I '$D(^BQICARE(DA(2),1,DA(1),40,0)) S ^BQICARE(DA(2),1,DA(1),40,0)="^90505.04P^^"
 ;  Update the user for flags for this patient
 I '$D(^BQICARE(DA(2),1,"AB",DFN)) D UPU^BQIFLAG(DFN,OWNR)
 ;  Update the patient record in panel
 S DATA=DFN_U_"A"_U_DUZ_U_$$NOW^XLFDT()
 S $P(DATA,U,8)=$S($$FLG^BQIULPT(DUZ,PLIEN,DFN)="Y":1,1:0)
 S ^BQICARE(OWNR,1,PLIEN,40,DFN,0)=DATA
 S RESULT=1
 Q
 ;
RPTM(DFN) ;EP - Remove patient record manually
 NEW DA,DATA
 S DA(2)=OWNR,DA(1)=PLIEN
 S DA=DFN,IENS=$$IENS^DILF(.DA)
 S DATA=$G(^BQICARE(DA(2),1,DA(1),40,DFN,0))
 I DATA="" S DATA=DFN
 S $P(DATA,U,2)="R",$P(DATA,U,5)=DUZ,$P(DATA,U,6)=$$NOW^XLFDT(),$P(DATA,U,8)=0
 S ^BQICARE(DA(2),1,DA(1),40,DFN,0)=DATA
 S RESULT=1
 Q
 ;
CNTP(OWNR,PLIEN) ;EP - Count patients and file the total
 ;
 ;Input
 ;  OWNR  - Owner of the panel
 ;  PLIEN - Panel internal entry number
 ;
 NEW DA,PIENS,DFN,IENS,CNT,BQIUP,SFLG
 S DA(1)=OWNR,DA=PLIEN,PIENS=$$IENS^DILF(.DA)
 S DFN=0,CNT=0,SFLG=0
 F  S DFN=$O(^BQICARE(OWNR,1,PLIEN,40,DFN)) Q:'DFN  D
 . S DA(2)=OWNR,DA(1)=PLIEN,DA=DFN,IENS=$$IENS^DILF(.DA)
 . I $$GET1^DIQ(90505.04,IENS,.02,"I")="R" Q
 . S CNT=CNT+1
 . ;  Check for sensitive patient
 . I $$SENS^BQIULPT(DFN)="Y" S SFLG=1
 . ;  Set flags for patient
 . D UPU^BQIFLAG(DFN,OWNR)
 ;
 S BQIUP(90505.01,PIENS,.1)=CNT
 S BQIUP(90505.01,PIENS,.07)=$$NOW^XLFDT()
 S BQIUP(90505.01,PIENS,3.5)=DUZ
 S BQIUP(90505.01,PIENS,3.6)=SFLG
 D FILE^DIE("I","BQIUP")
 ;
 ; Count flags for panel
 D CNTP^BQIFLG(OWNR,PLIEN)
 Q
 ;
ERR ;
 L -^BQICARE(OWNR,1,0)
 D ^%ZTER
 N Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 Q
