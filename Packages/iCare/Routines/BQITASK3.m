BQITASK3 ;GDIT/HS/ALA-Weekly Update Tasks ; 03 Aug 2007  1:45 PM
 ;;2.5;ICARE MANAGEMENT SYSTEM;;May 24, 2016;Build 27
 ;
EN ;EP - Entry point
 NEW UID,TTASK
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQITASK3 D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
TRT ;EP - Find best practices prompts
 ; Set the date/time started
 NEW DA
 S DA=$O(^BQI(90508,0)) I 'DA Q
 S BQIUPD(90508,DA_",",4.1)=$$NOW^XLFDT()
 S BQIUPD(90508,DA_",",4.12)=1
 S BQIUPD(90508,DA_",",24.02)=$G(ZTSK)
 D FILE^DIE("","BQIUPD")
 K BQIUPD
 ;
 D POP^BQITRMT
 ;
 ; Set the date/time stopped
 NEW DA
 S DA=$O(^BQI(90508,0)) I 'DA Q
 S BQIUPD(90508,DA_",",4.11)=$$NOW^XLFDT()
 S BQIUPD(90508,DA_",",4.12)="@"
 S BQIUPD(90508,DA_",",24.02)="@"
 D FILE^DIE("","BQIUPD")
 K BQIUPD
 Q
 ;
ERR ;
 ;
 NEW DA
 S DA=$O(^BQI(90508,0))
 I DA="" S DA=1
 S BQIUPD(90508,DA_",",3.15)="@"
 S BQIUPD(90508,DA_",",4.12)="@"
 D FILE^DIE("","BQIUPD")
 K BQIUPD
 ;
 D ^%ZTER
 Q
 ;
CMGT ; EP - BQI UPDATE CARE MGMT
 NEW UID,TTASK
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQITASK3 D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 NEW DA
 S DA=$O(^BQI(90508,0)) I 'DA Q
 S BQIUPD(90508,DA_",",4.13)=$$NOW^XLFDT()
 S BQIUPD(90508,DA_",",4.15)=1
 S BQIUPD(90508,DA_",",24.03)=$G(ZTSK)
 D FILE^DIE("","BQIUPD")
 K BQIUPD
 ;
 NEW SRIEN,SRC,RIEN,STAT,DFN,SRCIEN
 S DFN=0
 F  S DFN=$O(^BQIPAT(DFN)) Q:'DFN  D
 . K ^BQIPAT(DFN,60)
 . ; If flag is set for nightly/weekly
 . S SRIEN=""
 . F  S SRIEN=$O(^BQI(90506.5,"AD",1,SRIEN)) Q:SRIEN=""  D
 .. I $P($G(^BQI(90506.5,SRIEN,0)),"^",10)=1 Q
 .. ;I $P($G(^BQI(90506.5,SRIEN,0)),"^",16)'=1 Q
 .. S SOURCE=$P($G(^BQI(90506.5,SRIEN,0)),"^",1)
 .. S SRC=$P($G(^BQI(90506.5,SRIEN,0)),U,2)
 .. ; If patient is deceased, don't calculate
 .. I $P($G(^DPT(DFN,.35)),U,1)'="" Q
 .. ; If patient has no active HRNs, quit
 .. I '$$HRN^BQIUL1(DFN) Q
 .. ; If patient has no visit in past 3 years
 .. I '$$VTHR^BQIUL1(DFN) Q
 .. D PAT^BQIRGASP(DFN,SRC)
 K BDMDMRG,BDMJOB,BDMBTH,CYR,CIEN,PGTHR,PGRF,BDMRBD,BDMADAT,BDMTYPE,BDMRED,BMDBDAT,BDMPD
 ;
 ; Set the date/time stopped
 NEW DA
 S DA=$O(^BQI(90508,0)) I 'DA Q
 S BQIUPD(90508,DA_",",4.14)=$$NOW^XLFDT()
 S BQIUPD(90508,DA_",",4.15)="@"
 S BQIUPD(90508,DA_",",24.03)="@"
 D FILE^DIE("","BQIUPD")
 K BQIUPD
 Q
 ;
SRC(SOURCE) ; EP
 S SRIEN=$O(^BQI(90506.5,"B",SOURCE,"")) I SRIEN="" Q
 I $P(^BQI(90506.5,SRIEN,0),"^",10)=1 Q
 S SRC=$P(^BQI(90506.5,SRIEN,0),U,2)
 Q
