BQITASK2 ;PRXM/HC/ALA-Separate tasks for post-installs ; 31 Jul 2007  11:24 AM
 ;;2.5;ICARE MANAGEMENT SYSTEM;;May 24, 2016;Build 27
 ;
DXC ;EP - Entry point to identify the diagnostic tags
 ; Variables
 ;   BQDEF  - Diag Cat Definition Name
 ;   BQEXEC - Diag Cat special executable program
 ;   BQPRG  - Diag Cat standard executable program
 ;   BQREF  - Taxonomy array reference
 ;   BQGLB  - Temporary global reference
 ;   BQORD  - Order that the category must be determined
 ;           (Some categories depend upon a patient not being
 ;            in another category)
 ;   BQTN   - Diag Cat internal entry number
 ;
 NEW UID
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 D DXC^BQITASK
 Q
 ;
GPR ;EP - Entry point to get GPRA values for all users
 ;
 NEW UID
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 D GPR^BQITASK
 Q
 ;
CMG(SOURCE) ;EP - Update a Care Management group
 NEW SRIEN,SRC,RIEN,STAT,DFN,SRCIEN
 I SOURCE="DM Audit" D
 . S BDMDMRG=$P($G(^BQI(90508,1,"DM")),"^",2)
 . S BQIUPD(90508,"1,",4.16)=$$NOW^XLFDT(),BQIUPD(90508,"1,",4.18)=1
 . D FILE^DIE("","BQIUPD","ERROR")
 S DFN=0
 F  S DFN=$O(^BQIPAT(DFN)) Q:'DFN  D
 . D SRC(SOURCE) I SRIEN="" Q
 . S SRCIEN=$O(^BQIPAT(DFN,60,"B",SRIEN,""))
 . I SRCIEN'="" D
 .. NEW DA,DIK
 .. S DA(1)=DFN,DA=SRCIEN
 .. S DIK="^BQIPAT("_DA(1)_",60,"
 .. D ^DIK
 . ; If patient is deceased, don't calculate
 . I $P($G(^DPT(DFN,.35)),U,1)'="" Q
 . ; If patient has no active HRNs, quit
 . I '$$HRN^BQIUL1(DFN) Q
 . ; If patient has no visit in past 3 years
 . I '$$VTHR^BQIUL1(DFN) Q
 . D PAT^BQIRGASP(DFN,SRC)
 K BDMDMRG,BDMJOB,BDMBTH,CYR,CIEN,PGTHR,PGRF,BDMRBD,BDMADAT,BDMTYPE,BDMRED,BMDBDAT,BDMPD
 S BQIUPD(90508,"1,",4.17)=$$NOW^XLFDT(),BQIUPD(90508,"1,",4.18)="@"
 D FILE^DIE("","BQIUPD","ERROR")
 Q
 ;
SRC(SOURCE) ; EP
 S SRIEN=$O(^BQI(90506.5,"B",SOURCE,"")) I SRIEN="" Q
 S SRC=$P(^BQI(90506.5,SRIEN,0),U,2)
 Q
 ;
JBDM ; EP Job off a DM Audit update
 I $$GET1^DIQ(90508,"1,",4.18,"I")=1 Q
 NEW ZTDTH,ZTDESC,ZTRTN,ZTIO,ZTSAVE,BQIUPD,NOW
 S NOW=$$NOW^XLFDT(),ZTDTH=DT_".19"
 I $$FMDIFF^XLFDT(ZTDTH,NOW,2)<60 S ZTDTH=$$FMADD^XLFDT($$NOW^XLFDT(),,,15)
 S ZTDESC="Update DM Audit",ZTIO=""
 S ZTRTN="CMG^BQITASK2(""DM Audit"")"
 D ^%ZTLOAD
 Q
