BQIIPCCP ;VNGT/HS/ALA-Continuity of Care Provider ; 05 May 2011  12:06 PM
 ;;2.3;ICARE MANAGEMENT SYSTEM;;Apr 18, 2012;Build 59
 ;
 ;
EN(BQDATE) ;EP
 NEW BQDTE,BQMON,EDAY,ENDT,CYR,PYR,ID,FAC,BQITOTV,BQITOTR,BD,VISIT
 NEW DFN,VD,X,Y,BQA,DPCP,CLN,QFL,BEGDT,BQITOTP,FC,PRV,CRST,CRIPC,CRN
 S QFL=0
 S CRST=$P($G(^BQI(90508,1,11)),U,2) S:CRST="" CRST=1
 S CRST="0"_CRST
 S CRIPC=$P($G(^BQI(90508,1,11)),U,1)
 S CRN=$O(^BQI(90508,1,22,"B",CRIPC,"")) I CRN="" Q
 ;
 I $G(BQDATE)'="" D
 . S BEGDT=$E(BQDATE,1,5)_"01",CYR=$E(BQDATE,1,3),BQMON=$E(BQDATE,4,5)
 . I $L(BQMON)=1 S BQMON="0"_BQMON
 . S EDAY="31^"_($$LEAP^XLFDT2(CYR)+28)_"^31^30^31^30^31^31^30^31^30^31"
 . S ENDT=$E(BQDATE,1,5)_$P(EDAY,U,+BQMON)
 ;
 I $G(BQDATE)="" D  Q:QFL
 . I $E(DT,6,7)'=CRST S QFL=1 Q
 . S BQMON=$E(DT,4,5)-1,CYR=$E(DT,1,3),PYR=CYR-1
 . S BQDTE=$P($T(BQM+BQMON),";;",2)
 . I $L(BQMON)=1 S BQMON="0"_BQMON
 . S BEGDT=@($P(BQDTE,U,2))_$P(BQDTE,U,1)_"01"
 . S EDAY="31^"_($$LEAP^XLFDT2(CYR)+28)_"^31^30^31^30^31^31^30^31^30^31"
 . S ENDT=@($P(BQDTE,U,2))_$P(BQDTE,U,1)_$P(EDAY,U,+$P(BQDTE,U,1))
 . S BQDATE=$S(BQMON="01":PYR,1:CYR)_BQMON_"00"
 ;
 S ID="IPC_CCPR"
 S FAC=$$HME^BQIGPUTL()
 ;
 ; BQITOTP(primary provider ien,clinic or "UNKNOWN"))=# of visits^# of visits to this provider
 S BQITOTV=0,BQITOTR=0
 S PRV=""
 F  S PRV=$O(^AUPNPAT("AK",PRV)) Q:PRV=""  S BQITOTP(PRV)="0^0"
 ;
 S BD=BEGDT_".9999"
 F  S BD=$O(^AUPNVSIT("B",BD)) Q:BD=""!(BD\1>ENDT)  D
 . S VISIT=""
 . F  S VISIT=$O(^AUPNVSIT("B",BD,VISIT)) Q:VISIT=""  D
 .. I $G(^AUPNVSIT(VISIT,0))="" Q
 .. I $P(^AUPNVSIT(VISIT,0),U,11) Q
 .. ; skip E:EVENT (HISTORICAL);D:DAILY HOSP DATA;X:ANCILLARY PACKAGE DAILY visits
 .. Q:"EDX"[$P(^AUPNVSIT(VISIT,0),U,7)
 .. ; location of visit not facility
 .. S FC=$P(^AUPNVSIT(VISIT,0),U,6) Q:'FC
 .. Q:FC'=FAC
 .. ; if no diagnoses
 .. Q:'$D(^AUPNVPOV("AD",VISIT))
 .. S DFN=$P(^AUPNVSIT(VISIT,0),U,5) I DFN="" Q
 .. I $G(^AUPNPAT(DFN,0))="" Q
 .. I $G(^DPT(DFN,0))="" Q
 .. ; If no HRN for this facility
 .. I $G(^AUPNPAT(DFN,41,FAC,0))="" Q
 .. S VD=$P(^AUPNVSIT(VISIT,0),U,1)\1
 .. ; HRN is inactive
 .. S X=$S($P($G(^AUPNPAT(DFN,41,FAC,0)),U,3)="":1,$P($G(^AUPNPAT(DFN,41,FAC,0)),U,3)>VD:1,1:0)
 .. I 'X Q
 .. ; patient is deceased
 .. I $P($G(^DPT(DFN,.35)),U,1)'="" Q
 .. ; No primary provider
 .. S BQA=$$PRIMPROV^APCLV(VISIT,"I") I BQA="" Q
 .. ; If no DPCP
 .. S DPCP=$P(^AUPNPAT(DFN,0),U,14) I DPCP="" Q
 .. S CLN=$P(^AUPNVSIT(VISIT,0),U,8) I CLN="" Q
 .. ; check against primary care clinic list
 .. I '$D(^BQI(90508,1,23,"B",CLN)) Q
 .. S $P(BQITOTP(DPCP),U,1)=$P($G(BQITOTP(DPCP)),U,1)+1
 .. S $P(BQITOTP(DPCP,CLN),U,1)=$P($G(BQITOTP(DPCP,CLN)),U,1)+1
 .. S BQITOTV=BQITOTV+1 ; Denominator
 .. I BQA,BQA=DPCP D
 ... S $P(BQITOTP(DPCP,CLN),U,2)=$P($G(BQITOTP(DPCP,CLN)),U,2)+1
 ... S $P(BQITOTP(DPCP),U,2)=$P($G(BQITOTP(DPCP)),U,2)+1
 ... S BQITOTR=BQITOTR+1 ; Numerator
 ;
 S DPCP=""
 F  S DPCP=$O(BQITOTP(DPCP)) Q:DPCP=""  D
 . D STORP^BQIIPUTL(DPCP,ID,BQDATE,$P(BQITOTP(DPCP),U,1),$P(BQITOTP(DPCP),U,2))
 D STORF^BQIIPUTL(FAC,ID,BQDATE,BQITOTV,BQITOTR)
 Q
 ;
BQM ;
 ;;12^PYR
 ;;01^CYR
 ;;02^CYR
 ;;03^CYR
 ;;04^CYR
 ;;05^CYR
 ;;06^CYR
 ;;07^CYR
 ;;08^CYR
 ;;09^CYR
 ;;10^CYR
 ;;11^CYR
