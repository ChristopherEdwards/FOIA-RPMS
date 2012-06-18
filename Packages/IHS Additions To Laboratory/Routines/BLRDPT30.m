BLRDPT30 ; IHS/DIR/FJE - Current Inpatient Variables ;
 ;;5.2;BLR;;NOV 01, 1997
 ;
 ;;MAS VERSION 5.0;
 ;
VAR ; -- inpatient demographics variables
 ;  input: DFN, VATD  = inverse date ; VACN  =
 ;              VAPRC =              ; VAPRT =
 ;
 ; output: VAWD = ward ; VATS = tr. spec. ; VARM = room/bed
 ;         VAPP = doc  ; VADX = diagnosis ; VAMV = mv entry
 ;
 S (VAWDA,VAWD,VATS,VAMV,VARM,VAPP,VADX)="",VAID=VATD
 ; -- get mv
 D MV G VARQ:VAMV0']""
 ; quit if not an adm or xfr
 I "^1^2^"'[("^"_$P(VAMV0,"^",2)_"^") G VARQ
 I 'VAPRC,"^2^3^13^25^26^43^44^45^"[("^"_VAMT_"^") G VARQ
 I VAPRC,"^13^43^44^45^"[("^"_VAMT_"^") G VARQ
 S:VAPRC VABO=$S(VAMT<4:VAMT,1:4) D GET
 ;I 'VACN,'VATS S VATS=TSD ;what is this
VARQ K VAMV0,VAMT,VAID
 Q
 ;
GET ; -- get variables and quit when all set(Y=1)
 S VACA=+$P(VAMV0,"^",14)
 D TS,SET G GETQ:Y
 F VAID=VATD:0 S VAID=$O(^DGPM("APMV",DFN,VACA,VAID)) Q:'VAID  F VAIFN=0:0 S VAIFN=$O(^DGPM("APMV",DFN,VACA,VAID,VAIFN)) Q:'VAIFN  I $D(^DGPM(VAIFN,0)) S VAMV0=^(0) D SET G GETQ:Y
GETQ K VACA,VAIFN,VAID Q
 ;
KVAR K VAMV,VAWDA,VAWD,VARM,VAPP,VATS,VATD,VAPRC,VAPRT,VACN,VADX,VABO Q
 ;
SET ; -- set variables if null
 S Y=0
 I 'VAWD,$D(^DIC(42,+$P(VAMV0,"^",6),0)) S VAWDA=$S($D(VAIFN):VAIFN,1:VAMV),VAWD=$P(VAMV0,"^",6)_"^"_$P(^(0),"^") S VARM="" I $D(^DG(405.4,+$P(VAMV0,"^",7),0)) S VARM=$P(VAMV0,"^",7)_"^"_$P(^(0),"^")
 I 'VACN,VAWD S Y=1
 I VACN,'VAPRT,$D(DGPMDDF),@$P("^^^^^VAWD^VARM^VAPP^VATS^VADX^","^",+DGPMDDF),VAMV S Y=1
 I VACN,VAPRT,VAWD,VAMV,VADX]"" S Y=1
 Q
 ;
TS ; set VADX, VATS and VAPP via VACA x-refs
 N VAMV0
 S:$D(^DGPM(VACA,0)) VADX=$P(^(0),"^",10)
 F VAID=VATD:0 S VAID=$O(^DGPM("ATS",DFN,VACA,VAID)) Q:'VAID  F VAT=0:0 S VAT=$O(^DGPM("ATS",DFN,VACA,VAID,VAT)) Q:'VAT  F VAIFN=0:0 S VAIFN=$O(^DGPM("ATS",DFN,VACA,VAID,VAT,VAIFN)) Q:'VAIFN  D TS1 G TSQ:VAPP&VATS
TSQ K VAIFN,VAT Q
 ;
TS1 ; set VATS and VAPP
 Q:'$D(^DGPM(VAIFN,0))  S VAMV0=^(0)
 ;I 'VAPP,$D(^DIC(16,+$P(VAMV0,"^",8),0)) S Y=$P(VAMV0,"^",8)_"^"_$P(^(0),"^") D PROV:$D(VA200) S VAPP=Y ;IHS/ANMC/LJF 5/9/96 not needed
 I 'VAPP,$D(^VA(200,+$P(VAMV0,U,8),0)) S Y=$P(VAMV0,U,8),VAPP=Y_U_$P(^VA(200,Y,0),U) ;IHS/ANMC/LJF 5/9/96 ADT v5 converted to file 200
 I 'VATS,$D(^DIC(45.7,+$P(VAMV0,"^",9),0)) S VATS=$P(VAMV0,"^",9)_"^"_$P(^(0),"^")
 Q
 ;
MV ; -- get latest mv for pt before VAID and not ASIH mv
 S (VAMV,VAMV0)=""
 F VAID=VAID:0 S VAID=$O(^DGPM("APID",DFN,VAID)) G MVQ:'VAID S VAMV=$O(^DGPM("APID",DFN,VAID,0)) I $D(^DGPM(+VAMV,0)) S VAMT=$P(^(0),"^",18) G MVQ:'VAMT Q:"^13^41^42^47^"'[("^"_VAMT_"^")
 S VAMV0=^DGPM(VAMV,0)
MVQ Q
 ;
A ;return current admission or last admission for patient
 S Y=$S($D(^DPT(DFN,.105)):+^(.105),1:0) G AQ:$D(^DGPM(Y,0))
 N VAID,VAMV,VAMV0
 F VAID=0:0 S VAID=$O(^DGPM("ATID1",DFN,VAID)) Q:'VAID  F VAMV=0:0 S VAMV=$O(^DGPM("ATID1",DFN,VAID,VAMV)) Q:'VAMV  I $D(^DGPM(VAMV,0)) S VAMV0=^(0) D DIS G AQ:Y
 S Y=0
AQ Q
 ;
DIS ; check for ASIH discharges
 S Y=$S('$D(^DGPM(+$P(VAMV0,"^",17),0)):VAMV,"^41^46"[(U_$P(^(0),"^",18)_U):0,1:VAMV)
 Q
 ;
PROV ; -- get provider info
 S X=+Y,Y="^"
 I $D(^DIC(16,X,"A3")) S X=+^("A3") I $D(^VA(200,X,0)) S Y=X_"^"_$P(^(0),"^")
 ;I $D(^DIC(3,X,0)) S X=+$P(^(0),"^",16) I $D(^DIC(16,X,0)) S Y=X_"^"_$P(^(0),"^")
 K X Q
