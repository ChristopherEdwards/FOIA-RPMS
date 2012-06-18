SROWL ;B'HAM ISC/MAM - ENTER PATIENT ON WAITING LIST ; 13 Feb 1989  11:32 AM
 ;;3.0; Surgery ;**58**;24 Jun 93
ENTER ; enter a patient on the waiting list
 S SRSOUT=0 W @IOF K DIC S DIC(0)="QEAMZL",(DIC,DLAYGO)=133.8,DIC("A")="  Select Surgical Specialty: " D ^DIC K DIC,DLAYGO G:Y<0 END S SRSS=+Y,SRSS1=+Y(0)
 S SRSSNM=$P(^SRO(137.45,SRSS1,0),"^")
PAT W ! S DIC=2,DIC(0)="QEAMZ",DIC("A")="  Select Patient: " D ^DIC K DIC I Y<0 W !!,"No action taken." G END
 S DFN=+Y,SRNM=$P(Y(0),"^") I $D(^DPT(DFN,.35)),$P(^(.35),"^")'="" S Y=$E($P(^(.35),"^"),1,7) D D^DIQ W !!,"The records show that "_SRNM_" died on "_Y_".",! G PAT
 I $O(^SRO(133.8,"AP",DFN,SRSS,0)) D CHK G:"Yy"'[ECYN END
OP W ! K DIR S DIR("A")="  Select Operative Procedure",DIR(0)="133.801,1" D ^DIR I $D(DTOUT)!$D(DUOUT) W !!,"No action taken." G END
 S SROPER=Y
 W ! D NOW^%DTC S SRSDT=%
 K DD,DO,DIC,DR,DA S DIC(0)="L",DIC="^SRO(133.8,SRSS,1,",DA(1)=SRSS,X=DFN D FILE^DICN I +Y S SROFN=+Y
 K DA,DIE,DR S DA=SRSS,DIE=133.8,DR="1///"_SRNM,DR(2,133.801)="1////"_SROPER_";2///"_SRSDT_";4T;W !;5T;6T;W !;3T",DR(3,133.8013)=".01T;1T;2T;3T;4T;5T" D ^DIE K DIE,DR
 D WL^SROPCE1 I SRSOUT G DEL
 W @IOF,!,SRNM_" has been entered on the waiting list",!,"for "_SRSSNM
END D PRESS,^SRSKILL W @IOF
 Q
PRESS W ! K DIR S DIR("A")="Press RETURN to continue  ",DIR(0)="FOA" D ^DIR K DIR
 Q
DEL S DA(1)=SRSS,DA=SROFN,DIK="^SRO(133.8,"_DA(1)_",1," D ^DIK
 W @IOF,!,"Classification information is incomplete.  No action taken." G END
 Q
HELP W !!,"Enter RETURN if you want to continue entering a new procedure on the waiting",!,"list for "_SRNM_".  If the procedure you are about to enter appears",!,"above, enter 'NO' to quit this option."
 W !!,"Press RETURN to continue  " R X:DTIME
 Q
CHK ; check for existing entries for a patient
 W @IOF,!,"Procedure(s) already entered for "_SRNM,!,"on the Waiting List for "_SRSSNM,!
 S SROFN=0 F  S SROFN=$O(^SRO(133.8,"AP",DFN,SRSS,SROFN)) Q:'SROFN  D LIST
 W !!,"Do you wish to continue entering a new procedure for "_SRNM_" on",!,"the waiting list for "_SRSSNM_" ?  YES// " R ECYN:DTIME I '$T!(ECYN["^") S ECYN="N" Q
 S ECYN=$E(ECYN) S:"y"[ECYN ECYN="Y"
 I "YNn"'[ECYN D HELP G CHK
 Q
LIST ; list existing procedures for specialty selected
 S SROPER=$P(^SRO(133.8,SRSS,1,SROFN,0),"^",2),SRDT=$P(^(0),"^",3),SROPDT=$P(^(0),"^",5),Y=SRDT D D^DIQ S SRDT=$E(Y,1,12) I SROPDT S Y=SROPDT D D^DIQ S SROPDT=$E(Y,1,12)
 K SROP,MM,MMM S:$L(SROPER)<36 SROP(1)=SROPER I $L(SROPER)>35 S SROPER=SROPER_"  " S SROPER=SROPER_"  " F M=1:1 D LOOP Q:MMM=""
 W !,SRNM,?40,"Date Entered on List:",?66,SRDT,!,?3,SROP(1),?40,"Tentative Operation Date: ",?66,SROPDT
 I $D(SROP(2)) W !,?3,SROP(2)
 W !
 Q
LOOP ; break procedure if greater than 36 characters
 S SROP(M)="" F LOOP=1:1 S MM=$P(SROPER," "),MMM=$P(SROPER," ",2,200) Q:MMM=""  Q:$L(SROP(M))+$L(MM)'<36  S SROP(M)=SROP(M)_MM_" ",SROPER=MMM
 Q
