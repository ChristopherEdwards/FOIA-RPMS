AGELGMED ;ITSC/SD/SDR - ELIGIBILITY MODIFIERS FILE EDIT ; 6/21/2002 
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
EN ;Select entry
 W !! K DIC
 S DINUM=$O(^AUPNELM(999999),-1)+1   ;go get last entry used
 I DINUM<1000 S DINUM=1001
 S DIC="^AUPNELM("
 S DIC(0)="AEQLMZ"
 S DIC("A")="ELIGIBILITY MODIFIERS ENTRY: "
 D ^DIC
 G:Y'>0 EXIT
 I $P($G(Y),"^",3)="" D  ;not a new entry
 .S (DA,AGDA1)=+Y
 .I DA<1000 W !,"This is a standard entry that cannot be edited!" Q
 .K DIE S DIE=DIC,DR=".01;.02"
 .D ^DIE
ENTRY ;
EXIT ;
 K DIC,DIE,AGDA1
 Q
