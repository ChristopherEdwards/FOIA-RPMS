ABMURSL1 ; IHS/ASDST/DMJ - Selective Report Parameters-PART 2 ; 
 ;;2.6;IHS Third Party Billing;**1,4**;NOV 12, 2009
 ;
 ; IHS/SD/SDR - abm*2.6*1 - NO HEAT - fix so only RECONCILED
 ; or TRANSMITTED shows (not both); also removed OPEN and REOPENED from
 ; selection.  See ABMURSEL for reason.
 ;
DT ;EP
 K DIR,ABMY("DT")
 W !!," ============ Entry of CASHIERING SESSION DATE Range =============",!
 S DIR("A")="Enter STARTING for the Report"
 S DIR(0)="DO^::EP"
 D ^DIR
 ;G DT:$D(DIRUT)  ;abm*2.6*4 NOHEAT
 Q:$D(DIRUT)!$D(DTOUT)!$D(DUOUT)!$D(DUROUT)  ;abm*2.6*4
 S ABMY("DT",1)=Y
 W !
 S DIR("A")="Enter ENDING DATE for the Report"
 D ^DIR
 K DIR
 G DT:$D(DIRUT)
 S ABMY("DT",2)=Y
 I ABMY("DT",1)>ABMY("DT",2) W !!,*7,"INPUT ERROR: Start Date is Greater than than the End Date, TRY AGAIN!",!! G DT
 Q
 ;
USER ;EP
 K ABMY("USER")
USER1 W !
 S DIC="^VA(200,"
 S DIC(0)="QEAM"
 I '$D(ABMY("USER")) S DIC("A")="Select User: "
 I $D(ABMY("USER")) S DIC("A")="Select Another User: "
 D ^DIC
 I +Y>0 S ABMY("USER",+Y)="" G USER1
 I '$D(ABMY("USER"))
 Q
 ;
POS ;EP
 K DIR
 S DIR(0)="Y"
 S DIR("A")="Include POS CLAIMS sessions for this range"
 S DIR("B")="Y"
 D ^DIR
 K DIR
 S ABMY("POS")=Y
 Q
 ;
STAT ;EP
 K ABMY("SSTAT")
STAT1 K DIR
TRIBAL S ABMADIEN=$O(^AUTTLOC(DUZ(2),11,9999999),-1)  ;abm*2.6*1 NO HEAT
 ;S DIR(0)="S"_$S($D(ABMY("SSTAT")):"AO",1:"O")_"^O:OPEN;C:CLOSED;R:RECONCILED;T:TRANSMITTED;S:REOPENED;A:ALL"  ;abm*2.6*1 NO HEAT
 ;start new code abm*2.6*1 NO HEAT
 S DIR(0)="S"_$S($D(ABMY("SSTAT")):"AO",1:"O")_"^C:CLOSED;"
 S DIR(0)=DIR(0)_$S($P($G(^AUTTLOC(DUZ(2),11,ABMADIEN,0)),U,3)'="1":"R:RECONCILED",1:"T:TRANSMITTED")
 S DIR(0)=DIR(0)_";A:ALL"
 ;end new code abm*2.6*1 NO HEAT
 S:$D(ABMY("SSTAT")) DIR("A")="Select Another Status: "
 S:'$D(ABMY("SSTAT")) DIR("A")="Select Session Status",DIR("B")="A"
 D ^DIR
 K DIR
 Q:Y=""!$D(DIROUT)!$D(DTOUT)!$D(DIRUT)!$D(DUOUT)
 S ABMY("SSTAT",Y)=""
 Q:Y="A"
 G STAT1
