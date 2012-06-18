BQITASK5 ;VNGT/HS/ALA-MU Clinical Measures ; 08 Apr 2011  9:30 AM
 ;;2.2;ICARE MANAGEMENT SYSTEM;**1**;Jul 28, 2011;Build 25
 ;
 ;
CQM ;EP -- BQI UPDATE MU CQM 1 YEAR
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQI1POJB D UNWIND^%ZTER"
 ;
 ;   Set the DATE/TIME MU STARTED field
 NEW DA
 S DA=$O(^BQI(90508,0)) I 'DA Q
 S BQIUPD(90508,DA_",",8.07)=$$NOW^XLFDT()
 S BQIUPD(90508,DA_",",8.09)=1
 D FILE^DIE("","BQIUPD","ERROR")
 K BQIUPD
 ;
 NEW DESC,BJOB,BCJOB,BQPROH
 S BQPROH=+$P(^BQI(90508,1,12),U,7)
 S BQIMUDTM=$$NOW^XLFDT(),BQIMUDT=$P(BQIMUDTM,".",1),BQIMUTIM=$P(BQIMUDTM,".",2)
 S CDOW=$$DOW^XLFDT(BQIMUDT,1)
 I CDOW'=6,CDOW'=0,BQPROH,$E(BQIMUTIM,1,2)>6,$E(BQIMUTIM,1,2)<18 D  Q
 . S DESC="BQI UPDATE MU CQM 1 YEAR",ZTDTH=BQIMUDT_".183"
 . D RESCH^XUTMOPT(DESC,ZTDTH,"","1M","L",.ERROR)
 . S $P(^BQI(90508,1,12),U,6)=ZTSK
 . K ZTSK,ZTDTH
 ;
 ; Check scheduled and continuation jobs
 D REQ(12)
 ;
 S BGPPROV=$P(^BQI(90508,1,12),U,4),BCJOB=$P(^BQI(90508,1,12),U,6)
 I BGPPROV=0 S BCJOB="",$P(^BQI(90508,1,12),U,6)=BCJOB
 ;
 F  S BGPPROV=$O(^BQIPROV(BGPPROV)) Q:'BGPPROV  D
 . I '$D(^BQI(90508,1,14,"B",BGPPROV)) D
 .. K ^BQIPROV(BGPPROV,11),^BQIPROV(BGPPROV,21)
 .. F BJ=1:1:8 S $P(^BQIPROV(BGPPROV,1),U,BJ)=""
 ;
 S BGPPROV=$P(^BQI(90508,1,12),U,4),STOP=0
 F  S BGPPROV=$O(^BQI(90508,1,14,"B",BGPPROV)) Q:BGPPROV=""  D  Q:STOP
 . K ^BQIPROV(BGPPROV,11)
 . F BJ=1:1:4 S $P(^BQIPROV(BGPPROV,1),U,BJ)=""
 . D PROV^BQIMUPRS(BGPPROV)
 . ; If not prohibited, keep running
 . I 'BQPROH Q
 . ; If prohibited, check the date and time to see if the job needs to stop
 . S BQIMUDTM=$$NOW^XLFDT(),BQIMUDT=$P(BQIMUDTM,".",1),BQIMUTIM=$P(BQIMUDTM,".",2)
 . S CDOW=$$DOW^XLFDT(BQIMUDT,1)
 . ; If day of week is Saturday, keeping running even if prohibited
 . I CDOW=6 Q
 . ; If day of week is Sunday, keeping running even if prohibited
 . I CDOW=0 Q
 . ;If the time plus 3 hours is less than 6 am or greater than 6 pm keep going
 . I $E(BQIMUTIM,1,2)+3<6 Q
 . I $E(BQIMUTIM,1,2)+3>18 Q
 . S STOP=1
 . S ZTDTH=BQIMUDT_".183"
 . S ZTDESC="MU CQM Continue Compile",ZTRTN="CQM^BQITASK5",ZTIO=""
 . D ^%ZTLOAD
 . S BQIUPD(90508,"1,",12.06)=ZTSK
 . D FILE^DIE("","BQIUPD","ERROR")
 . K ZTDESC,ZTRTN,ZTIO,ZTDTH,ZTSK
 ;
 ; Hospital CQ
 I $P(^BQI(90508,1,0),U,6)=1 D
 . K BGPIND
 . S BGPINDT=""
 . S BGPMUYF="90595.11"
 . S BGPRTYPE=4,BGP0RPTH="A"
 . S BGPMUT="H" ; BGPMU Hospital Measures
 . S BGPRTYPE=4,BGP0RPTH="A"
 . S BGPBEN=3
 . S X=0 F  S X=$O(^BGPMUIND(BGPMUYF,"AMS","H",X)) Q:X'=+X  S BGPIND(X)=""
 . S BQIGREF=$NA(^TMP("BQICQMH1",$J)) K @BQIGREF
 . ; 1 year timeframe
 . ; Current
 . S BGPBD=$$DATE^BQIUL1("T-365"),BGPED=DT
 . ; Previous
 . S BGPPBD=$$DATE^BQIUL1("T-731"),BGPPED=$$DATE^BQIUL1("T-366")
 . ; Baseline
 . S BGPBBD=BGPPBD,BGPBED=BGPPED
 . D BQI^BGPMUEHD(.BQIGREF)
 . K CDEN,CNUM,CEXC,PDEN,PNUM,PEXC,CSORT,PSORT,MTOT
 . S BN=""
 . F  S BN=$O(@BQIGREF@(BN)) Q:BN=""  D
 .. S I=""
 .. F  S I=$O(@BQIGREF@(BN,"C",I)) Q:I=""  D
 ... I $P($G(^BGPMUIND(90596.11,I,0)),U,4)[".ED." D  Q
 .... S MTOT=$P(@BQIGREF@(BN,"C",I),U,2)/60
 .... S CSORT(I,MTOT,BN)="",CSORT(I)=$G(CSORT(I))+1
 ... S CDEN(I)=$G(CDEN(I))+$P($G(@BQIGREF@(BN,"C",I)),U,1)
 ... S CNUM(I)=$G(CNUM(I))+$P($G(@BQIGREF@(BN,"C",I)),U,2)
 ... S CEXC(I)=$G(CEXC(I))+$P($G(@BQIGREF@(BN,"C",I)),U,3)
 .. S I=""
 .. F  S I=$O(@BQIGREF@(BN,"P",I)) Q:I=""  D
 ... I $P($G(^BGPMUIND(90596.11,I,0)),U,4)[".ED." D  Q
 .... S MTOT=$P(@BQIGREF@(BN,"P",I),U,2)/60
 .... S PSORT(I,MTOT,BN)="",PSORT(I)=$G(PSORT(I))+1
 ... S PDEN(I)=$G(PDEN(I))+$P($G(@BQIGREF@(BN,"P",I)),U,1)
 ... S PNUM(I)=$G(PNUM(I))+$P($G(@BQIGREF@(BN,"P",I)),U,2)
 ... S PEXC(I)=$G(PEXC(I))+$P($G(@BQIGREF@(BN,"P",I)),U,3)
 ... ; For DFN set up and store individual
 ... ;S PADH=$P($G(@BQIGREF@(DFN,"P",I)),U,4)
 . D STORH(11)
 . K @BQIGREF,CSORT,PSORT
 ;
 ;  Set the DATE/TIME MU STOPPED field
 NEW DA
 S DA=$O(^BQI(90508,0)) I 'DA Q
 S BQIUPD(90508,DA_",",8.08)=$$NOW^XLFDT()
 S BQIUPD(90508,DA_",",8.09)="@"
 S BQIUPD(90508,DA_",",12.04)=+BGPPROV
 D FILE^DIE("","BQIUPD","ERROR")
 K BQIUPD
 Q
 ;
NIN ;EP -- BQI UPDATE MU CQM 90 DAYS
 ;   Set the DATE/TIME MU STARTED field
 NEW DA,BQIMUTIM,BQIMUDT,CDOW,BQIMUDTM,STOP
 S DA=$O(^BQI(90508,0)) I 'DA Q
 S BQIUPD(90508,DA_",",4.19)=$$NOW^XLFDT()
 S BQIUPD(90508,DA_",",4.21)=1
 D FILE^DIE("","BQIUPD","ERROR")
 K BQIUPD
 ;
 NEW DESC,BJOB,BCJOB,BQPROH
 S BQPROH=+$P(^BQI(90508,1,12),U,7)
 S BQIMUDTM=$$NOW^XLFDT(),BQIMUDT=$P(BQIMUDTM,".",1),BQIMUTIM=$P(BQIMUDTM,".",2)
 S CDOW=$$DOW^XLFDT(BQIMUDT,1)
 I CDOW'=6,CDOW'=0,BQPROH,$E(BQIMUTIM,1,2)+3>6,$E(BQIMUTIM,1,2)+3<18 D  Q
 . S DESC="BQI UPDATE MU CQM 90 DAYS",ZTDTH=BQIMUDT_".183"
 . D RESCH^XUTMOPT(DESC,ZTDTH,"","7D","L",.ERROR)
 . S $P(^BQI(90508,1,12),U,5)=ZTSK
 . K ZTSK,ZTDTH
 ;
 ; Check scheduled and continuation jobs
 D REQ(90)
 ;
 S BGPPROV=$P(^BQI(90508,1,12),U,3),BCJOB=$P(^BQI(90508,1,12),U,5)
 I BGPPROV=0 S BCJOB="",$P(^BQI(90508,1,12),U,5)=BCJOB
 ;
 F  S BGPPROV=$O(^BQIPROV(BGPPROV)) Q:'BGPPROV  D
 . I '$D(^BQI(90508,1,14,"B",BGPPROV)) D
 .. K ^BQIPROV(BGPPROV,11),^BQIPROV(BGPPROV,21)
 .. F BJ=1:1:8 S $P(^BQIPROV(BGPPROV,1),U,BJ)=""
 ;
 S BGPPROV=$P(^BQI(90508,1,12),U,3),STOP=0,BQPROH=+$P(^BQI(90508,1,12),U,7)
 F  S BGPPROV=$O(^BQI(90508,1,14,"B",BGPPROV)) Q:BGPPROV=""  D  Q:STOP
 . K ^BQIPROV(BGPPROV,21)
 . F BJ=5:1:8 S $P(^BQIPROV(BGPPROV,1),U,BJ)=""
 . D NIN^BQIMUPRS(BGPPROV)
 . ; If not prohibited, keep running
 . I 'BQPROH Q
 . ; If prohibited, check the date and time to see if the job needs to stop
 . S BQIMUDTM=$$NOW^XLFDT(),BQIMUDT=$P(BQIMUDTM,".",1),BQIMUTIM=$P(BQIMUDTM,".",2)
 . S CDOW=$$DOW^XLFDT(BQIMUDT,1)
 . ; If day of week is Saturday, keeping running even if prohibited
 . I CDOW=6 Q
 . ; If day of week is Sunday, keeping running even if prohibited
 . I CDOW=0 Q
 . ;If the time plus 3 hours is less than 6 am or greater than 6 pm keep going
 . I $E(BQIMUTIM,1,2)+3<6 Q
 . I $E(BQIMUTIM,1,2)+3>18 Q
 . S STOP=1
 . S ZTDTH=BQIMUDT_".183"
 . S ZTDESC="MU CQ Continue Compile",ZTRTN="NIN^BQITASK5",ZTIO=""
 . D ^%ZTLOAD
 . S BQIUPD(90508,"1,",12.05)=ZTSK
 . D FILE^DIE("","BQIUPD","ERROR")
 . K ZTDESC,ZTRTN,ZTIO,ZTDTH,ZTSK
 ;
HOS ; Hospital CQ
 I $P(^BQI(90508,1,0),U,6)=1 D
 . K BGPIND
 . S BGPINDT=""
 . S BGPMUYF="90595.11"
 . S BGPRTYPE=4,BGP0RPTH="A"
 . S BGPMUT="H" ; BGPMU Hospital Measures
 . S BGPRTYPE=4,BGP0RPTH="A"
 . S BGPBEN=3
 . S X=0 F  S X=$O(^BGPMUIND(BGPMUYF,"AMS","H",X)) Q:X'=+X  S BGPIND(X)=""
 . S BQIGREF=$NA(^TMP("BQICQMH9",$J)) K @BQIGREF
 . ; 90 days
 . ; Current
 . S BGPBD=$$DATE^BQIUL1("T-90"),BGPED=DT
 . ; Previous
 . S BGPPBD=$$DATE^BQIUL1("T-181"),BGPPED=$$DATE^BQIUL1("T-91")
 . ; Baseline
 . S BGPBBD=BGPPBD,BGPBED=BGPPED
 . D BQI^BGPMUEHD(.BQIGREF)
 . K CDEN,CNUM,CEXC,PDEN,PNUM,PEXC,CSORT,PSORT,MTOT
 . S BN=""
 . F  S BN=$O(@BQIGREF@(BN)) Q:BN=""  D
 .. S I=""
 .. F  S I=$O(@BQIGREF@(BN,"C",I)) Q:I=""  D
 ... I $P($G(^BGPMUIND(90596.11,I,0)),U,4)[".ED." D  Q
 .... S MTOT=$P(@BQIGREF@(BN,"C",I),U,2)/60
 .... S CSORT(I,MTOT,BN)="",CSORT(I)=$G(CSORT(I))+1
 ... S CDEN(I)=$G(CDEN(I))+$P($G(@BQIGREF@(BN,"C",I)),U,1)
 ... S CNUM(I)=$G(CNUM(I))+$P($G(@BQIGREF@(BN,"C",I)),U,2)
 ... S CEXC(I)=$G(CEXC(I))+$P($G(@BQIGREF@(BN,"C",I)),U,3)
 .. S I=""
 .. F  S I=$O(@BQIGREF@(BN,"P",I)) Q:I=""  D
 ... I $P($G(^BGPMUIND(90596.11,I,0)),U,4)[".ED." D  Q
 .... S MTOT=$P(@BQIGREF@(BN,"P",I),U,2)/60
 .... S PSORT(I,MTOT,BN)="",PSORT(I)=$G(PSORT(I))+1
 .... S PDEN(I)=$G(PDEN(I))+$P($G(@BQIGREF@(BN,"P",I)),U,1)
 .... S PNUM(I)=$G(PNUM(I))+$P($G(@BQIGREF@(BN,"P",I)),U,2)
 .... S PEXC(I)=$G(PEXC(I))+$P($G(@BQIGREF@(BN,"P",I)),U,3)
 .. ; For DFN set up and store individual
 .. ;S PADH=$P($G(@BQIGREF@(DFN,"P",I)),U,4)
 . D STORH(21)
 . K @BQIGREF,CSORT,PSORT
 ;
 ;  Set the DATE/TIME MU STOPPED field
 NEW DA
 S DA=$O(^BQI(90508,0)) I 'DA Q
 S BQIUPD(90508,DA_",",4.2)=$$NOW^XLFDT()
 S BQIUPD(90508,DA_",",4.21)="@"
 S BQIUPD(90508,DA_",",12.03)=+BGPPROV
 D FILE^DIE("","BQIUPD","ERROR")
 K BQIUPD
 Q
 ;
STORH(NODE) ;
 NEW CVALUE,PVALUE,CT,I,MSN,FAC
 I '$D(@BQIGREF) Q
 S FAC=$$HME^BQIGPUTL()
 K ^BQIFAC(FAC,NODE),^BQIFAC(FAC,NODE,"B")
 I NODE=11 S $P(^BQIFAC(FAC,1),U,1,4)=BGPBD_U_BGPED_U_BGPPBD_U_BGPPED
 I NODE=21 S $P(^BQIFAC(FAC,1),U,5,8)=BGPBD_U_BGPED_U_BGPPBD_U_BGPPED
 S CT=0
 S I=0 F  S I=$O(^BGPMUIND(90596.11,I)) Q:'I  D
 . S MSN=$P(^BGPMUIND(90596.11,I,0),U,1)
 . I $G(^BGPMUIND(90595.11,MSN,0))="" Q
 . I $P(^BGPMUIND(90595.11,MSN,0),U,4)'="H" Q
 . I $P($G(^BGPMUIND(90596.11,I,0)),U,4)[".ED." D
 .. S CVALUE=$$MED(I,.CSORT),PVALUE=$$MED(I,.PSORT)
 .. S CT=CT+1,^BQIFAC(FAC,NODE,CT,0)=$P(^BGPMUIND(90596.11,I,0),"^",4)_U_$P(CVALUE,U,1)_U_$P(CVALUE,U,2)_U_$G(CEXC(I))_U_$P(PVALUE,U,1)_U_$P(PVALUE,U,2)_U_$G(PEXC(I))
 . I $P($G(^BGPMUIND(90596.11,I,0)),U,4)'[".ED." D
 .. S CT=CT+1,^BQIFAC(FAC,NODE,CT,0)=$P(^BGPMUIND(90596.11,I,0),"^",4)_U_$G(CDEN(I))_U_$G(CNUM(I))_U_$G(CEXC(I))_U_$G(PDEN(I))_U_$G(PNUM(I))_U_$G(PEXC(I))
 . S ^BQIFAC(FAC,NODE,"B",$P(^BGPMUIND(90596.11,I,0),"^",4),CT)=""
 Q
 ;
MED(ITM,LIST) ;EP - Find Median for LIST
 ; Input
 ;    ITM  - Which measure to check list for
 ;    LIST - By ITM, the list of sorted values
 NEW CNT,MID,CT,PVAL,VAL,TOT,DFN,MED
 S CNT=$G(LIST(ITM))
 I CNT=1 Q $O(LIST(ITM,""))_U_1
 I CNT=2 D  Q (TOT/CNT)_U_CNT
 . S TOT=0,VAL=""
 . F  S VAL=$O(LIST(ITM,VAL)) Q:VAL=""  D
 .. S DFN="" F  S DFN=$O(LIST(ITM,VAL,DFN)) Q:DFN=""  S TOT=TOT+VAL
 ;
 ;S MID=(CNT+1)\2
 S MID=CNT\2
 S CT=0,VAL="",QFL=0,MED="",TOT=0
 F  S VAL=$O(LIST(ITM,VAL)) Q:VAL=""  D  Q:QFL
 . S DFN=""
 . F  S DFN=$O(LIST(ITM,VAL,DFN)) Q:DFN=""  D
 .. S CT=CT+1,NVAL=$O(LIST(ITM,VAL))
 .. I CT=MID S TOT=TOT+VAL+NVAL,MED=(TOT/2),QFL=1 Q
 .. S PVAL=VAL
 Q MED_U_CNT
 ;
CKJ(DESC) ;EP - Check job
 ; Input
 ;   DESC - Job description
 ; Output
 ;   Task Number
 ;
 NEW OPTN,CIEN
 S OPTN=$$FIND^BQISCHED(DESC) I OPTN'>0 Q ""
 I $O(^DIC(19.2,"B",OPTN,""))="" Q ""
 I $O(^DIC(19.2,"B",OPTN,""))'="" S CIEN=$O(^DIC(19.2,"B",OPTN,""))
 Q $P($G(^DIC(19.2,CIEN,1)),U,1)
 ;
REQ(WHO) ;EP - Check to see if need to requeue job
 ; Input
 ;   WHO = which job 12=1 year, 90=90 days
 ;
 NEW ZTSK,DESC,BJOB,BCJOB,BQSJB,BQCJB
 I WHO=12 D
 . S DESC="BQI UPDATE MU CQM 1 YEAR",BJOB=$$CKJ(DESC)
 . S BCJOB=$P(^BQI(90508,1,12),U,6)
 I WHO=90 D
 . S DESC="BQI UPDATE MU CQM 90 DAYS",BJOB=$$CKJ(DESC)
 . S BCJOB=$P(^BQI(90508,1,12),U,5)
 ;
 S ZTSK=BJOB
 D ISQED^%ZTLOAD
 ; If the scheduled job is running, quit
 I $G(ZTSK(0))=0 Q
 ;
 ; if the scheduled job is pending
 I $G(ZTSK(0))=1 S BQSJB=$G(ZTSK("D"))
 S BCJOB=$P(^BQI(90508,1,12),U,5)
 S ZTSK=BCJOB
 D ISQED^%ZTLOAD
 ;
 ; If the continuation job is pending, quit
 I $G(ZTSK(0))=1 Q
 ;
 S BQCJB=$G(ZTSK("D"))
 ;
 ; If the difference between the continuation job and the scheduled job is less than
 ; 2 days, requeue the scheduled job one day
 I $$HDIFF^XLFDT(BQSJB,BQCJB,1)<2 D
 . S ZTSK=BJOB,ZTDTH=$$FMADD^XLFDT($$HTFM^XLFDT(BQSJB),1)
 . D RESCH^XUTMOPT(DESC,ZTDTH,"","7D","L",.ERROR)
 . K ZTSK,ZTDTH
 Q
