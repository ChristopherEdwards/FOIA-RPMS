BQITASK3 ;PRXM/HC/ALA-Treatment Prompts Update Task ; 03 Aug 2007  1:45 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
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
 D FILE^DIE("","BQIUPD")
 K BQIUPD
 ;
 NEW SRIEN,SRC,RIEN,STAT,DFN,SRCIEN
 S DFN=0
 F  S DFN=$O(^BQIPAT(DFN)) Q:'DFN  D
 . F SOURCE="Asthma" D
 .. D SRC(SOURCE) I SRIEN="" Q
 .. S SRCIEN=$O(^BQIPAT(DFN,60,"B",SRIEN,""))
 .. I SRCIEN'="" D
 ... NEW DA,DIK
 ... S DA(1)=DFN,DA=SRCIEN
 ... S DIK="^BQIPAT("_DA(1)_",60,"
 ... D ^DIK
 .. ; If patient is deceased, don't calculate
 .. I $P($G(^DPT(DFN,.35)),U,1)'="" Q
 .. ; If patient has no active HRNs, quit
 .. I '$$HRN^BQIUL1(DFN) Q
 .. ; If patient has no visit in past 3 years
 .. I '$$VTHR^BQIUL1(DFN) Q
 .. D PAT^BQIRGASP(DFN,SRC)
 ;
 ; Set the date/time stopped
 NEW DA
 S DA=$O(^BQI(90508,0)) I 'DA Q
 S BQIUPD(90508,DA_",",4.14)=$$NOW^XLFDT()
 S BQIUPD(90508,DA_",",4.15)="@"
 D FILE^DIE("","BQIUPD")
 K BQIUPD
 Q
 ;
SRC(SOURCE) ; EP
 S SRIEN=$O(^BQI(90506.5,"B",SOURCE,"")) I SRIEN="" Q
 S SRC=$P(^BQI(90506.5,SRIEN,0),U,2)
 Q
