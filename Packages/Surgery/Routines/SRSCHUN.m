SRSCHUN ;BIR/ADM - MAKE UNREQUESTED OPERATION; [ 06/14/01  10:17 AM ]
 ;;3.0; Surgery ;**3,67,68,88,103**;24 Jun 93
MUST S SRLINE="" F I=1:1:80 S SRLINE=SRLINE_"="
 W @IOF W:$D(SRCC) !,?29,$S(SRSCON=1:"FIRST",1:"SECOND")_" CONCURRENT CASE" W !,?14,"SCHEDULE UNREQUESTED OPERATION: REQUIRED INFORMATION",!!,SRNM_" ("_$G(SRSSN)_")",?65,SREQDT,!,SRLINE,!
SURG ; surgeon
 K DIR S DIR(0)="130,.14",DIR("A")="Surgeon" D ^DIR K DIR I $D(DTOUT)!(X="^") S SRSOUT=1 G END
 I Y=""!(X["^") W !!,"To create a surgical case, a surgeon MUST be selected.  Enter '^' to exit.",! G SURG
 S SRSDOC=+Y
SPEC ; surgical specialty
 K DIR S DIR(0)="130,.04",DIR("A")="Surgical Specialty" D ^DIR K DIR I $D(DTOUT)!(X="^") S SRSOUT=1 G END
 I Y=""!(X["^") W !!,"To create a surgical case, a surgical specialty MUST be selected.  Enter '^'",!,"to exit.",! G SPEC
 S SRSS=+Y
OP ; principal operative procedure
 K DIR S DIR(0)="130,26",DIR("A")="Principal Operative Procedure" D ^DIR K DIR I $D(DTOUT)!(X="^") S SRSOUT=1 G END
 I X["^" W !!,"Principal procedure must not contain an up-arrow (^).",! G OP
 S SRSOP=Y
CASE ; create case in SURGERY file
 K DA,DIC,DD,DO,DINUM,SRTN S X=SRSDPT,DIC="^SRF(",DIC(0)="L",DLAYGO=130 D FILE^DICN K DD,DO,DIC,DLAYGO S SRTN=+Y
 D NOW^%DTC S SREQDAY=+$E(%,1,12),SRNOCON=1 K DR,DIE
 S DA=SRTN,DIE=130,DR="26////"_SRSOP_";68////"_SRSOP_";36////0;Q;.09////"_SRSDATE_";.14////"_SRSDOC_";1.098////"_+SREQDAY_";1.099////"_DUZ_";Q;.02////"_SRSOR_";10////"_SRSDT1_";11////"_SRSDT2_";Q;.04////"_SRSS D ^DIE
 K DR,DA S DR="[SRO-NOCOMP]",DA=SRTN,DIE=130 D ^DIE K DR
 S ^SRF(SRTN,8)=SRSITE("DIV") D ^SROXRET K SRNOCON
OTHER ; other required fields
 S SRFLD=0 F  S SRFLD=$O(^SRO(133,SRSITE,4,SRFLD)) Q:'SRFLD!(SRSOUT)  D OTHDIR Q:SRSOUT
 I SRSOUT S DA=SRTN,DIK="^SRF(" D ^DIK G END
IND K DR S DIE=130,DA=SRTN,DR="55T" D ^DIE I $D(DTOUT) S SRDUOUT=1
 I $D(SRDUOUT),'$O(^SRF(SRTN,40,0)) S SRSOUT=1
 I '$D(SRDUOUT),'$O(^SRF(SRTN,40,0)) W !!,"A brief description of the indications for this operation MUST be entered",!,"before proceeding with this option.",! D ASK G:'SRSOUT IND
 I SRSOUT S DA=SRTN,DIK="^SRF(" D ^DIK G END
 I $D(SRCC),SRSCON=2 S DIE=130,DR="35////"_SRSCON(1),DA=SRTN D ^DIE K DR S DR="35////"_SRTN,DA=SRSCON(1),DIE=130 D ^DIE K DR,DA S SROERR=SRSCON(1) D ^SROERR0
 S SROERR=SRTN D ^SROERR I $D(SRDUOUT) S SRSOUT=1
 Q
CON ; request concurrent case
 D MUST Q:SRSOUT  S SRSCON(SRSCON,"DOC")=$P(^VA(200,SRSDOC,0),"^"),SRSCON(SRSCON,"SS")=$P(^SRO(137.45,SRSS,0),"^"),SRSCON(SRSCON,"OP")=$P(^SRF(SRTN,"OP"),"^"),SRSCON(SRSCON)=SRTN K DA
 Q
OTHDIR ; call to reader for site specific required fields
 K DIR,SREQ,SRY S FLD=$P(^SRO(133,SRSITE,4,SRFLD,0),"^") D FIELD^DID(130,FLD,"","TITLE","SRY") S DIR(0)="130,"_FLD,DIR("A")=SRY("TITLE") D ^DIR I $D(DTOUT)!(X="^") S SRSOUT=1 Q
 I Y=""!(X["^") W !!,"It is mandatory that you provide this information before proceeding with this",!,"option.",! D ASK Q:SRSOUT  G OTHDIR
 S SREQ(130,SRTN_",",FLD)=$P(Y,"^") D FILE^DIE("","SREQ","^TMP(""SR"",$J)")
 Q
ASK K DIR S DIR(0)="Y",DIR("A")="Do you want to continue with this option ",DIR("B")="YES"
 S DIR("?")="Enter RETURN to continue with this option, or 'NO' to discontinue this option." D ^DIR S:'Y SRSOUT=1
 Q
END I '$D(SRCC),SRSOUT W !!,"No surgical case has been scheduled.",! S SRTN("OR")=SRSOR,SRTN("START")=SRSDT1,SRTN("END")=SRSDT2,SRSEDT=$E(SRSDT2,1,7) D ^SRSCG
 Q
