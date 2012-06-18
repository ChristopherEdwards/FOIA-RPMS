BKMOFF ;VNGT/HS/ALA - Turn off HIV Management System ; 04 Jun 2008  3:44 PM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
EN ;EP - Entry point
 NEW BKMIEN,OPT,IEN
 ; Set flag
 S BKMIEN=$O(^BKM(90450,"B","HMS REGISTER","")) I BKMIEN="" Q
 S BKMUPD(90450,BKMIEN_",",30)=1
 D FILE^DIE("","BKMUPD","ERROR")
 K BKMUPD
 ;
 S OPT="BKM"
 F  S OPT=$O(^DIC(19,"B",OPT)) Q:OPT=""!($E(OPT,1,3)'="BKM")  D
 . S IEN=""
 . F  S IEN=$O(^DIC(19,"B",OPT,IEN)) Q:IEN=""  D
 .. S BKMUPD(19,IEN_",",2)="CANNOT ACCESS HMS VIA RPMS - USE ICARE"
 D FILE^DIE("","BKMUPD","ERROR")
 K BKMUPD
 ;
 ;Check HMS Candidate file
 NEW STAT,BQDA,BQDFN,TAG
 S BQDA=0,TAG=3
 F  S BQDA=$O(^BKM(90451.2,BQDA)) Q:'BQDA  D
 . S BQDFN=$P(^BKM(90451.2,BQDA,0),U,1),STAT=$P(^(0),U,3)
 . ; if the status is not NOT:NOT ACCEPTED or REM:REMOVED, quit
 . I STAT'="NOT"&(STAT'="REM") D  Q
 .. I $O(^BQIREG("C",BQDFN,TAG,""))'="" Q
 .. D EN^BQITDPRC(.DATA,BQDFN,TAG,"P",DATE,"POST INSTALL JOB",1,"Patient originally on HMS Candidate List")
 . S DATE=$S($P(^BKM(90451.2,BQDA,0),U,5)'="":$P(^(0),U,5),1:"")
 . S USER=$S($P(^BKM(90451.2,BQDA,0),U,6)'="":$P(^VA(200,$P(^(0),U,6),0),U,1),1:"POST INSTALL JOB")
 . ; If the recalculate of tags created a record, delete it
 . I $O(^BQIREG("C",BQDFN,TAG,""))'="" D
 .. NEW DIK,DA
 .. S DIK="^BQIREG(",DA=$O(^BQIREG("C",BQDFN,TAG,"")) D ^DIK
 .. S DA(1)=BQDFN,DA=TAG,DIK="^BQIPAT("_DA(1)_",20," D ^DIK
 . D EN^BQITDPRC(.DATA,BQDFN,TAG,"N",DATE,USER,1,"Patient on HMS Register has status Not Accepted or Removed.")
 ;
 Q
 ;
HIV ;EP - Check to turn off HIV
 NEW BKMHIV,UID
 S BKMHIV=$$HIVIEN^BKMIXX3()
 I $$GET1^DIQ(90450,BKMHIV_",",30,"I")="" D
 . I $$GET1^DIQ(90450,BKMHIV_",",.08,"I")\1'>DT D EN
 Q
 ;
STCS ; Status comments set
 NEW TEXT,IENS
 S TEXT(1,0)=X
 S IENS=$$IENS^DILF(.DA)
 D WP^DIE(90451.01,IENS,20,"","TEXT","ERROR")
 Q
 ;
STCK ; Status comments kill
 Q
 ;
DXCS ; Diagnosis comments set
 NEW TEXT,IENS
 S TEXT(1,0)=X
 S IENS=$$IENS^DILF(.DA)
 D WP^DIE(90451.01,IENS,21,"","TEXT","ERROR")
 Q
 ;
DXCK ; Diagnosis comments kill
 Q
 ;
ETCS ; Etiology comments set
 NEW TEXT,IENS
 S TEXT(1,0)=X
 S IENS=$$IENS^DILF(.DA)
 D WP^DIE(90451.01,IENS,22,"","TEXT","ERROR")
 Q
 ;
ETCK ; Etiology comments kill
 Q
