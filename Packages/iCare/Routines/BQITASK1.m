BQITASK1 ;PRXM/HC/ALA-Reminders Update Task ; 24 May 2007  1:10 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
EN ;EP - Entry point
 ;NEW UID
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIRMDR D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
REM ;EP - Redo reminders
 NEW DA
 S DA=$O(^BQI(90508,0)) I 'DA Q
 S BQIUPD(90508,DA_",",4.07)=$$NOW^XLFDT()
 S BQIUPD(90508,DA_",",4.09)=1
 D FILE^DIE("","BQIUPD","ERROR")
 K BQIUPD
 ;
 ; Re-evaluate Reminders
 D CHK^BQIRMDR("Weekly")
 ;
 D DZ
 ;
 S BQDFN=0
 F  S BQDFN=$O(^AUPNPAT(BQDFN)) Q:'BQDFN  D
 . NEW BQIDATA
 . S BQIDATA=$NA(^BQIPAT)
 . K @BQIDATA@(BQDFN,40)
 . ; If deceased, don't include
 . I $P($G(^DPT(BQDFN,.35)),U,1)'="" Q
 . ; If no active HRN, don't include
 . I '$$HRN^BQIUL1(BQDFN) Q
 . ; If no visit in last 3 years, quit
 . I '$$VTHR^BQIUL1(BQDFN) Q
 . D PAT^BQIRMDR(BQDFN)
 ;
 NEW DA
 S DA=$O(^BQI(90508,0)) I 'DA Q
 S BQIUPD(90508,DA_",",4.08)=$$NOW^XLFDT()
 S BQIUPD(90508,DA_",",4.09)="@"
 D FILE^DIE("","BQIUPD","ERROR")
 K BQIUPD
 Q
 ;
ORM ; EP - Update all patients for one reminder
 ; Create a reminder record for every patient with new reminder
 S BQDFN=0
 F  S BQDFN=$O(^BQIPAT(BQDFN)) Q:'BQDFN  D
 . ; If deceased, don't include
 . I $P($G(^DPT(BQDFN,.35)),U,1)'="" Q
 . ; If no active HRN, don't include
 . I '$$HRN^BQIUL1(BQDFN) Q
 . ; If no visit in last 3 years, quit
 . I '$$VTHR^BQIUL1(BQDFN) Q
 . S IEN=0
 . F  S IEN=$O(^XTMP("BQIRMOM",IEN)) Q:IEN=""  D
 .. S RCAT=$P(^XTMP("BQIRMOM",IEN),U,1)
 .. S HIEN=$P(^XTMP("BQIRMOM",IEN),U,2)
 .. S CODE=$P(^XTMP("BQIRMOM",IEN),U,3)
 .. I RCAT'="Care Management" D RMR^BQIRMDR(BQDFN,HIEN) Q
 .. I RCAT="Care Management" D REG^BQIRMDR1(BQDFN,CODE)
 K HIEN,RCAT,BQDFN,CODE,IEN
 Q
 ;
DZ ;EP - Check for DUZ(2), it is usually missing for Postmaster
 K ^XTMP("BQIRMDR")
 S ^XTMP("BQIRMDR",0)=$$FMADD^XLFDT(DT,1)_U_$$DT^XLFDT()
 M ^XTMP("BQIRMDR","DUZ")=DUZ
 I $G(^XTMP("BQIRMDR","DUZ",2))=0 D
 . NEW FAC,BQIHM
 . D GETFCRS^BMXRPC3(.FAC,$G(^XTMP("BQIRMDR","DUZ")))
 . I $P(FAC,U,4)'=0 S ^XTMP("BQIRMDR","DUZ",2)=$P(FAC,U,4) Q
 . S BQIHM=$O(^BQI(90508,0)) I BQIHM'="" S FAC=$P($G(^BQI(90508,BQIHM,0)),U,1)
 . S ^XTMP("BQIRMDR","DUZ",2)=$G(FAC)
 ;
 NEW KEY,BUSER,QFL
 S KEY="XUMGR",BUSER="",QFL=0
 F  S BUSER=$O(^XUSEC(KEY,BUSER),-1) Q:BUSER=""!(QFL)  I $$ACTIVE^XUSER(BUSER) S QFL=1
 I ^XTMP("BQIRMDR","DUZ")=.5,BUSER'="" S ^XTMP("BQIRMDR","DUZ")=BUSER
 Q
