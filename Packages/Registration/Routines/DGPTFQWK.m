DGPTFQWK ;ALB/AS - QUICK/LOAD PTF DATA ; JAN 7 88@3
 ;;5.3;Registration;;Aug 13, 1993
 ;
 S (DGPTF,DA)=PTF,DIE="^DGPT(",DR="[DGQWK"_$S('DGPTFE:"]",1:"F]") W !,"* editing 101 & 701 transactions" D ^DIE S DR="[DG701]" D ^DIE W !,"* editing 501 transactions"
 F DGM=0:0 D S501 Q:Y'>0  K DA S (DGPTF,DA)=PTF S DGMOV=+Y,DGJUMP=$S('DGPTFE:"",1:"1-2"),DR=$S('DGPTFE:"[DG501]",1:"[DG501F]"),DIE="^DGPT(" D ^DIE,CHK501^DGPTSCAN K DGMOV
 K DIC,DA,DR,DIE
 W !,"* editing 401 transactions"
 F DGM=0:0 D S401 Q:Y'>0  K DA S DGSUR=+Y,DGJUMP="1-2",DR="[DG401]",DIE="^DGPT(",(DA,DGPTF)=PTF D ^DIE,CHK401^DGPTSCAN K DGSUR
 W !,"* editing 601 transactions" S DR="60",DR(2,45.05)=".01;2;S:'X Y=4;3;4:8",DIE="^DGPT(",DA=PTF D ^DIE
 I '$P(^DGPT(PTF,0),"^",4)&('DGST) W !,"  Updating TRANSFER DRGs" S DGADM=$P(^DGPT(PTF,0),U,2) D SUDO1^DGPTSUDO
 K DGM,DA,DGMOVENO,DIC,DIE,DR,Y,DGPTF,DGJUMP Q
S501 ;-- set up 501 
 S DA(1)=PTF,DIC("A")="Select 501 MOVEMENT NUMBER: ",DIC(0)="AEQ",DIC="^DGPT("_PTF_",""M""," S:'$D(^DGPT(PTF,"M",0)) ^(0)="^45.02AI^^" D ^DIC
 K DA,DIC
 Q
 ;
S401 ;-- set up 401
 S DA(1)=PTF,DIC("A")="Select 401 SURGERY DATE: ",DIC(0)="AEQL",DIC="^DGPT("_PTF_",""S""," S:'$D(^DGPT(PTF,"S",0)) ^(0)="^45.01DA^^" D ^DIC
 K DA,DIC
 Q
 ;
