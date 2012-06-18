SRSCHD ;B'HAM ISC/MAM - SCHEDULING UNREQUESTED CASES ; [ 01/08/98   9:54 AM ]
 ;;3.0; Surgery ;**77**;24 Jun 93
BEG W @IOF S SRSOUT=0
 K SRSDATE W ! S (SRNOREQ,SRSCHD,SRSC1)=1,ST="SCHEDULING"
 K %DT S %DT="AEFX",%DT("A")="Schedule a Procedure for which Date ?  " D ^%DT I Y<0 W !!,"The schedule cannot be updated without a date.",!! G END
 S SRSDATE=+Y I SRSDATE<DT W !!,"Reservations cannot be made for dates in the past.  Please select another date.",!!,"Press RETURN to continue  " R X:DTIME G BEG
 S X=SRSDATE D H^%DTC S SRDAY=%Y+1 S SRDL=$P($G(^SRO(133,SRSITE,2)),"^",SRDAY) S:SRDL="" SRDL=1
 I 'SRDL W !!,"Scheduling not allowed for "_$S(SRDAY=1:"SUNDAY",SRDAY=2:"MONDAY",SRDAY=3:"TUESDAY",SRDAY=4:"WEDNESDAY",SRDAY=5:"THURSDAY",SRDAY=6:"FRIDAY",1:"SATURDAY")_" !!",!!!,"Press RETURN to continue  " R X:DTIME G BEG
 I $D(^HOLIDAY(SRSDATE,0)),'$D(^SRO(133,SRSITE,3,SRSDATE,0)) W !!,"Scheduling not allowed for "_$P(^HOLIDAY(SRSDATE,0),"^",2)_" !!",!!!,"Press RETURN to continue  " R X:DTIME G BEG
 S Y=SRSDATE D D^DIQ S SREQDT=Y
 W ! S DIC=2,DIC("A")="Select Patient: ",DIC(0)="QEAMZ" D ^DIC K DIC G:Y<0 END S (DFN,SRSDPT)=+Y D DEM^VADPT S SRNM=VADM(1),SRSSN=VA("PID")
 I $D(^DPT(SRSDPT,.35)),$P(^(.35),"^")'="" S Y=$E($P(^(.35),"^"),1,7) D D^DIQ W !!,"The records show that "_SRNM_" died on "_Y_".",! G END
OR D ^SRSCHOR I SRSOUT W !!,"No surgical case has been scheduled.",! S SRSOUT=0 G END
 D ^SRSCHUN I SRSOUT S SRSOUT=0 G END
 D ^SRSCHUN1
END ;
 I 'SRSOUT K DIR S DIR(0)="FOA",DIR("A")=" Press RETURN to continue. " D ^DIR
 D ^SRSKILL K SRTN W @IOF
 Q
