BQI2POS1 ;VNGT/HC/ALA - Continuation of Version 2.0 Post Install ; 25 Jul 2008  4:02 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
REG ;EP - Process Tags
 ; First delete all tag data
 NEW DFN,TAG,DA,DIK
 S DFN=0
 F  S DFN=$O(^BQIPAT(DFN)) Q:'DFN  D
 . S TAG=0
 . F  S TAG=$O(^BQIPAT(DFN,20,TAG)) Q:'TAG  D
 .. S DA(1)=DFN,DA=TAG,DIK="^BQIPAT("_DA(1)_",20,"
 .. D ^DIK
 ;
 ; Recalculate all tags
 D DXC^BQITASK2
 ;
NX ; Process register records into tags
 NEW REGIEN,RDATA,TAG,FILE,FIELD,XREF,STFILE,STFLD,STEX,SUBREG,GLBREF,GLBNOD
 NEW DFN,RIEN,QFL,DATE,TGNM,CSTAT,PCAT,PSTAT
 S REGIEN=0
 F  S REGIEN=$O(^BQI(90507,REGIEN)) Q:'REGIEN  D
 . S RDATA=^BQI(90507,REGIEN,0)
 . ; If the register is inactive, quit
 . I $P(RDATA,U,8)=1 Q
 . ; Check if register is associated with a tag, if there isn't one, quit
 . S TAG=$O(^BQI(90506.2,"AD",REGIEN,"")) I TAG="" Q
 . S FILE=$P(RDATA,U,7),FIELD=$P(RDATA,U,5),XREF=$P(RDATA,U,6)
 . S STFILE=$P(RDATA,U,15),STFLD=$P(RDATA,U,14),STEX=$G(^BQI(90507,REGIEN,1))
 . S SUBREG=$P(RDATA,U,9)
 . S GLBREF=$$ROOT^DILFD(FILE,"")_XREF_")"
 . S GLBNOD=$$ROOT^DILFD(FILE,"",1)
 . I GLBNOD="" Q
 . ;
 . I '$D(@GLBNOD@(0)) Q
 . ;
 . S DFN=""
 . F  S DFN=$O(@GLBREF@(DFN)) Q:DFN=""  D
 .. ; If patient is deceased, quit
 .. I $P($G(^DPT(DFN,.35)),U,1)'="" Q
 .. ; If patient has no active HRNs, quit
 .. I '$$HRN^BQIUL1(DFN),'$$VTHR^BQIUL1(DFN) Q
 .. ;
 .. I $G(SUBREG)'="" S QFL=0 D  Q:'QFL
 ... Q:FILE'=9002241
 ... S RIEN=""
 ... F  S RIEN=$O(@GLBREF@(DFN,RIEN)) Q:RIEN=""  D
 .... I $P($G(@GLBNOD@(RIEN,0)),U,5)=SUBREG S QFL=1,IENS=RIEN
 .. ; Check register status
 .. I $G(SUBREG)="" S IENS=$O(@GLBREF@(DFN,""))
 .. I STEX'="" X STEX Q:'$D(IENS)
 .. S PSTAT=$$GET1^DIQ(STFILE,IENS,STFLD,"I"),CSTAT="",PCAT=""
 .. I STFILE=90451.01 S PCAT=$$GET1^DIQ(STFILE,IENS,2.3,"I")
 .. I $O(^BQIREG("C",DFN,TAG,""))'="" S CSTAT=$$ATAG^BQITDUTL(DFN,TAG)
 .. I $P(CSTAT,U,2)="A" Q
 .. S DATE=$P($G(^BQIPAT(DFN,20,TAG,0)),U,2)
 .. I $O(^BQIREG("C",DFN,TAG,""))'="" Q
 .. I PSTAT="U"!(PSTAT="")!(PSTAT="I") D  Q
 ... ; If patient is not tagged, quit
 ... I $O(^BQIPAT(DFN,20,TAG,0))="" Q
 ... I $O(^BQIREG("C",DFN,TAG,""))'="" Q
 ... I TAG=3&($E(PCAT,1)="E")!(PCAT="") Q
 ... ; else build a "proposed" record
 ... D EN^BQITDPRC(.DATA,DFN,TAG,"P",DATE,"POST INSTALL JOB",8,"Register status is "_PSTAT) Q
 .. I $O(^BQIPAT(DFN,20,TAG,0))'="" D
 ... I PCAT="H"!(PCAT="A") D EN^BQITDPRC(.DATA,DFN,TAG,"A",DATE,"POST INSTALL JOB",8,"Register status is "_PSTAT) Q
 ... D EN^BQITDPRC(.DATA,DFN,TAG,"P",DATE,"POST INSTALL JOB",8,"Register status is "_PSTAT)
 .. I $O(^BQIPAT(DFN,20,TAG,0))="" D
 ... I TAG=3&($E(PCAT,1)="E")!(PCAT="") Q
 ... D EN^BQITDPRC(.DATA,DFN,TAG,"P",DATE,"POST INSTALL JOB",8,"Register status is "_PSTAT)
 .. ; Remove any temporary BQIPAT data
 .. NEW DA,DIK
 .. S DA(1)=DFN,DA=TAG,DIK="^BQIPAT("_DA(1)_",20,"
 .. D ^DIK
 ;
TG ; Set up Proposed records in BQIREG
 S DFN=0
 F  S DFN=$O(^BQIPAT(DFN)) Q:'DFN  D
 . S TAG=0
 . F  S TAG=$O(^BQIPAT(DFN,20,TAG)) Q:'TAG  D
 .. ; If there is already a record, quit
 .. I $O(^BQIREG("C",DFN,TAG,""))'="" Q
 .. ; Get date that the tag was last identified
 .. S DATE=$P(^BQIPAT(DFN,20,TAG,0),"^",2)
 .. ; Get the tag name
 .. S TGNM=$P(^BQI(90506.2,TAG,0),"^",1)
 .. ; If the tag is CVD At Risk, then it automatically becomes 'Accepted'
 .. I TGNM="CVD At Risk" D  Q
 ... D EN^BQITDPRC(.DATA,DFN,TAG,"A",DATE,"POST INSTALL JOB",5)
 ... NEW DA,DIK
 ... S DA(1)=DFN,DA=TAG,DIK="^BQIPAT("_DA(1)_",20,"
 ... D ^DIK
 .. ; Otherwise, it is a 'Proposed' tag
 .. D EN^BQITDPRC(.DATA,DFN,TAG,"P",DATE,"POST INSTALL JOB",5)
 ;
CN ;Check HMS Candidate file
 NEW STAT,BQDA,TAG
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
 ; Check if any HIV record is 'No Longer Valid' and reset comment
 NEW RIEN
 S RIEN=""
 F  S RIEN=$O(^BQIREG("B",3,RIEN)) Q:RIEN=""  D
 . S STAT=$P(^BQIREG(RIEN,0),U,3)
 . I STAT'="V" Q
 . S BQIUPD(90509,RIEN_",",.06)=9
 D FILE^DIE("","BQIUPD","ERROR")
 ;
AS ; Set any Asthma's (IEN=1) to accepted if the severity value is 2,3, or 4
 S RIEN=""
 F  S RIEN=$O(^BQIREG("B",1,RIEN)) Q:RIEN=""  D
 . S STAT=$P(^BQIREG(RIEN,0),U,3),DFN=$P(^(0),U,2)
 . I '$$ACST^BQITDUTL(STAT) Q
 . S SEV=$$LASTSEV^APCHSAST(DFN,1)
 . I SEV<2 Q
 . K BQTX
 . S BQIUPD(90509,RIEN_",",.03)="A"
 . S BQIUPD(90509,RIEN_",",.06)=9
 . D FILE^DIE("I","BQIUPD","ERROR")
 . S BQTX(1,0)="Patient's severity was "_$$LASTSEV^APCHSAST(DFN,5)
 . D WP^DIE(90509,RIEN_",",1,"","BQTX","ERROR")
 . K BQIUPD
 ;
 ; Set up treatment prompts
 D EN^BQITASK3
 Q
