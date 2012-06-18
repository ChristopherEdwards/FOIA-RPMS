DGVPTIB2 ;alb/mjk - IBECEA3 for export with PIMS v5.3; 4/21/93
 ;;5.3;Registration;;Aug 13, 1993
 ;
IBECEA3 ;ALB/RLW - Add/Update/Cancel Charges Part 3 ; 12-JUN-92
 ;;Version 1.5 ; INTEGRATED BILLING ;**4,14**; 29-JUL-92
 ;
LAST ;find last entry
 S IBLAST=""
 S IBPARNT=$P(^IB(+IBIEN,0),"^",9) I 'IBPARNT S IBPARNT=IBIEN
 S IBLDT=$O(^IB("APDT",IBPARNT,"")) I +IBLDT F IBL=0:0 S IBL=$O(^IB("APDT",IBPARNT,IBLDT,IBL)) Q:'IBL  S IBLAST=IBL
 I IBLAST="" S IBLAST=IBPARNT
 Q
BEVT ; get associated billable event
 K DIRUT
 D EN^IBECEA4
 S I=0,I=$O(SDULY(I))
 I I="" S DIR(0)="Y",DIR("A")="You must select an admission.  Do you wish to continue" D ^DIR K DIR I +Y=1 G BEVT
 I I="" S Y="-1^IB037" G BEVTQ
 I $D(^TMP("IBACMID1",$J,I)) S IBEVDATA=^IB($P(^(I),"^",4),0),IBEVENT=$P(IBEVDATA,"^",16),IBEVDATE=$P(IBEVDATA,"^",17)
 S IBDT=$S(IBEVDATE="":IBCHGFR,1:IBEVDATE)
 I (IBDT="") S Y="-1^IB037" G BEVTQ
 I '$D(IBCHGFR) D GETDAT
 S Y=1
BEVTQ K IBEVDATA,I Q
FEE ; charges for fee basis
 N X K Y S IBDESC=""
 I $D(^IBE(350.1,IBATYP,20)) X ^(20)
 S DIR(0)="N^0:9999999:2",DIR("A")="Amount" D ^DIR I $D(DIRUT) S Y="-1^IB038" G FEEQ
 S IBCHG=+Y
FEEQ K DIR
 Q
GETDAT ;
 K IBCHGFR,IBCHGTO
 S DIR(0)="DA^2901001:NOW:EX",DIR("A")="Charge for services from: " D ^DIR K DIR Q:$D(DIRUT)  S IBCHGFR=+Y I (IBXA="2")!(IBXA="4") S IBCHGTO=IBCHGFR Q
 S Y=+Y D DD^%DT
 S DIR(0)="DA^"_IBCHGFR_":NOW:EX",DIR("A")="                      to:",DIR("B")=Y D ^DIR K DIR S IBCHGTO=+Y K Y I IBCHGTO=IBCHGFR S IBCHGTO=(IBCHGTO+1)
 Q
APPT ; see if there's already an appointment billed for the day or a C&P
 ; (if there's a charge, is status complete,billed,on hold,updated?)
 ; if $D(IBSIEN) called from ^IBACKIN; ignore that charge to account for filer delay in cancelling old charge.
 S IBCHRGD=0,IBCNP="" I $D(IBIEN) S IBSIEN=IBIEN
 I $D(^IB("AFDT",IBADFN,-IBDT)) S IBCHRGD=0,IBIEN="",I="" D
 .F  S IBIEN=$O(^IB("AFDT",IBADFN,-IBDT,IBIEN)) Q:IBIEN=""  D
 ..I $D(IBSIEN),IBIEN=IBSIEN Q
 ..I $P(^IB(IBIEN,0),"^",3)=51 N X S X=$P(^(0),"^",5),IBCHRGD=$S(X=2:(IBCHRGD+1),X=3:(IBCHRGD+1),X=8:(IBCHRGD+1),1:IBCHRGD)
 G:IBCHRGD>0 APPTQ
 D CHKCNP G:IBCNP=1 APPTQ
 D CHKAE
APPTQ K I,IBSIEN Q
CHKCNP ; skip op copay charges (if any) if a C&P appointment is found 
 S I=IBDT
 F  S I=$O(^DPT(IBADFN,"S",I)) Q:I=""!(I>(IBDT+.9999))  S IBSDATA=$G(^(I,0)) D
 .Q:$P(IBSDATA,"^",16)'=1  ; appt not for C&P exam
 .I +$$STATUS^SDAM1(IBADFN,I,+IBSDATA,IBSDATA)<3 S IBCNP=1
 I $D(IBWHER),IBWHER="IBECEA",IBCNP=1 D
 .S DIR(0)="Y",DIR("A")="Patient had a C&P exam on this date.  Are you sure you want to add a charge" D ^DIR K DIR I +Y=1 S IBCNP=0
 K IBSDATA,I Q
CHKAE ; check ADD/EDIT STOP CODES for C&Ps
 S I=$G(^SDV("ADT",IBADFN,IBDT)) G:I="" CHKAEQ S IBDTTM=I,I="",J=""
 F  S I=$O(^SDV(IBDTTM,"CS","B",I)) G:I="" CHKAEQ S J="",J=$O(^(I,J)) G:J="" CHKAEQ S:+$P(^SDV(IBDTTM,"CS",J,0),"^",5)=1 IBCNP=1 Q
CHKAEQ K I,J,IBDTTM Q
CANCP ; if check-in is for a C&P, cancel OP Copayments for day (if any).
 Q:'$D(^IB("AFDT",IBADFN,-IBDT))
 S IBIEN=""
 F  S IBIEN=$O(^IB("AFDT",IBADFN,-IBDT,IBIEN)) Q:(IBIEN="")  Q:($P(^IB(IBIEN,0),"^",8)'["OPT COPAY")  I $P(^(0),"^",5)'=10 S IBCRES=19 D CANCHG^IBECEA2
 K IBIEN Q
 ;
CLOCK1 ; update category c billing clock NUMBER INPATIENT DAYS
 S IBUNIT=-IBUNIT
CLOCK2 S IBCLDA="",IBCLDA=$O(^IBE(351,"ACT",DFN,IBCLDA)) L +^IBE(351,IBCLDA):10 I $T=0 W !!,"Can't update clock, record is locked" D PAUSE^IBECEA1 K IBCLDA Q
 S IBCLDAYS=$P(^IBE(351,IBCLDA,0),"^",9),IBCLDAYS=(IBCLDAYS+IBUNIT) W !,"Adjust CATEGORY C BILLING CLOCK NUMBER INPATIENT DAYS by "_$S(IBUNIT<0:"("_IBUNIT_")",1:IBUNIT) S %=1 D YN^DICN
 I %=1 S DIE="^IBE(351,",DA=IBCLDA,DR=".09////"_IBCLDAYS D ^DIE K DIE,DA,DR
 L -^IBE(351,IBCLDA) K IBCLDA
 Q
CLOCK3 ; update category c billing clock 90 DAY INPATIENT AMOUNT
 S IBCHG=-IBCHRG
CLOCK4 S IBCLDA="",IBCLDA=$O(^IBE(351,"ACT",DFN,IBCLDA)) L +^IBE(351,IBCLDA):10 I $T=0 W !!,"Can't update clock, record is locked" D PAUSE^IBECEA1 K IBCLDA Q
 S IBCLDAY=$P(^IBE(351,IBCLDA,0),"^",9),DIE="^IBE(351,",DA=IBCLDA,X=$S(IBCLDAY<91:5,IBCLDAY<181:6,IBCLDAY<271:7,1:8),IBCHGTOT=$P(^IBE(351,IBCLDA,0),"^",X)+IBCHG,DR=".0"_X_"////"_IBCHGTOT_";13////"_IBDUZ_";14////"_DT
 W !,"Adjust CATEGORY C BILLING CLOCK "_$S(X=5:"1ST",X=6:"2ND",X=7:"3RD",1:"4TH")_" 90-DAY INPATIENT AMOUNT by $"_$S(IBCHG<0:"("_IBCHG_")",1:IBCHG) D
 S %=1 D YN^DICN D:%=1 ^DIE
 K DIE,DA,DR,X
 L -^IBE(351,IBCLDA) K IBCLDA
 Q
DELETE ; clean up stub record if no charge created
 Q:'$D(^IB(IBN))
 W !,"NEW CHARGE NOT ADDED..."
 S DIK="^IB(",DA=IBN D ^DIK K DIK,DA
 Q
