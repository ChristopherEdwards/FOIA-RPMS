SROASS ;B'HAM ISC/MAM - SELECT ASSESSMENT ; [ 04/03/00  3:21 PM ]
 ;;3.0; Surgery ;**38,47,64,94**;24 Jun 93
 K:$D(DUZ("SAV")) SRNEW K SRTN W !! S SRSOUT=0 K DIC S DIC("A")="Select Patient: ",DIC=2,DIC(0)="QEAM" D ^DIC K DIC I Y<0 S SRSOUT=1 G END
 S DFN=+Y D DEM^VADPT S SRANM=VADM(1)_"  "_VA("PID")
START ; start display
 G:SRSOUT END W @IOF,!,?1,SRANM
 I $D(^DPT(DFN,.35)),$P(^(.35),"^") S SRDT=$P(^(.35),"^") W "         * DIED "_$E(SRDT,4,5)_"/"_$E(SRDT,6,7)_"/"_$E(SRDT,2,3)_" *"
 D ^SROASS1 I SRSOUT G END
 I $D(SRTN) G ENTER
 I $D(SRNEW) S CNT=CNT+1,SRCASE(CNT)="" W CNT,".   ----     CREATE NEW ASSESSMENT"
 I '$D(SRCASE(1)) W !!,"There are no Surgery Risk Assessments entered for "_VADM(1)_".",!! K DIR S DIR(0)="FOA",DIR("A")="  Press RETURN to continue.  " D ^DIR Q
OPT W !!!,"Select Surgical Case: " R X:DTIME I '$T!("^"[X) S SRSOUT=1 G END
 I '$D(SRCASE(X)) W !!,"Enter the number of the desired assessment." W:$D(SRNEW) "  Select '"_CNT_"' to create an",!,"assessment for another surgical case." G OPT
 I $D(SRNEW),X=CNT D ^SROANEW G END
 I '$D(SRTN) S SRTN=+SRCASE(X)
ENTER ; edit, complete, or delete
 I $D(SRPRINT)!'($D(SRNEW)) Q
 S SR("RA")=$G(^SRF(SRTN,"RA")) I $P(SR("RA"),"^")="T" D TRANS I 'SRYN K SRASS,SRTN G START
 I SRATYPE="N"&($P(SR("RA"),"^",2)="C") W !!,"You've selected a Cardiac assessment, using a Non-Cardiac Option," K DIR S DIR(0)="Y",DIR("A")="Do you wish to continue",DIR("B")="NO" D ^DIR S X=$E(X) I "Yy"'[X K SRTN S SRSOUT=1 G END
 I SRATYPE="C"&($P(SR("RA"),"^",2)="N") W !!,"You've selected a Non-Cardiac assessment, using a Cardiac Option," K DIR S DIR(0)="Y",DIR("A")="Do you wish to continue",DIR("B")="NO" D ^DIR S X=$E(X) I "Yy"'[X K SRTN S SRSOUT=1 G END
 W @IOF,!,?1,SRANM,!! S SRSDATE=$P(^SRF(SRTN,0),"^",9) S SRASS=SRTN D DISP^SROASS1
 W !!,"1. Enter Risk Assessment Information",!,"2. Delete Risk Assessment Entry",!,"3. Update Assessment Status to 'COMPLETE'"
 W !!,"Select Number:  1//  " R X:DTIME I '$T!(X["^") K SRTN,SRASS S SRSOUT=1 G END
 S:X="" X=1 I X<1!(X>3)!(X'?.N) D HELP G ENTER
 I X=2 D ^SROADEL W !!,"Press <RET> to continue  " R X:DTIME W @IOF K SRTN G END
 I X=3 D ^SROACOM K SRTN G END
 Q
END S:'$D(SRSOUT) SRSOUT=1 W:SRSOUT @IOF D ^SRSKILL
 Q
HELP ;
 W !!,"Enter <RET> or '1' to enter or edit information related to this Risk ",!,"Assessment entry.  If you want to delete the Assessment, enter '2'."
 W !,"Enter '3' to update the status of this Assessment to 'COMPLETE'."
 W !!,"Press <RET> to continue  " R X:DTIME
 Q
TRANS W @IOF,!,"This assessment has already been transmitted.  The information contained",!,"in it cannot be altered unless you first change the status to 'INCOMPLETE'."
 S SRYN=0 K DIR S DIR("A")="Do you wish to change the status of this assessment to 'INCOMPLETE'",DIR("B")="NO",DIR(0)="Y" D ^DIR I $D(DTOUT)!$D(DUOUT) S SRSOUT=1 Q
 S SRYN=Y I 'SRYN Q
 K DA,DIE,DR S DIE=130,DA=SRTN,DR="235////I;393////1" D ^DIE K DA,DIE,DR
 Q
