AGELPHCK ; IHS/ASDS/EFG - Check if Registered Policy Holder ;   
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
 I $D(AGELP("PHPAT")),AGELP("PHPAT")]"",$D(^DPT(AGELP("PHPAT"),0)) G REG
 W !!,"Presently the POLICY HOLDER is NOT known as a REGISTERED PATIENT."
 W !
 K DIR
 S DIR(0)="Y",DIR("B")="Y"
 S DIR("A")="Want to SCAN to see if the Policy Holder is Registered"
 D ^DIR
 K DIR
 G XIT:$D(DTOUT)!(Y="^")
 G NAME:Y=0,PLK
REG I AGELP("MODE")="A" G NAME
 W !!?5,"The Policy Holder is presently linked to "
 W $P(^DPT(AGELP("PHPAT"),0),U),$S($D(^AUPNPAT(AGELP("PHPAT"),41,DUZ(2),0)):" ["_$P(^(0),U,2)_"]",1:"")
 W !?5,"in your Patient Registration data base."
 K DIR
 W !
 S DIR("A")="Want to REMOVE the linkage with this Registered Patient (Y/N)"
 S DIR(0)="Y",DIR("B")="N"
 D ^DIR
 K DIR
 G XIT:$D(DTOUT)!(Y="^")
 I Y=1 D
 .S DIE="^AUPN3PPH("
 .S DA=AGELP("PH")
 .S DR=".02///@;.08///@;.19///@"
 .D ^DIE
 .K AGELP("PHPAT")
 .G AGELPHCK
 G NAME
PLK K DIC
 S DIC(0)="QZEAM",DIC="^AUPNPAT("
 D ^DIC
 I +Y<0 G NAME
 S AGEL("YCK")=Y
 W !
 K DIR
 S DIR(0)="Y",DIR("B")="Y"
 S DIR("A")="Is "_Y(0,0)_" the Policy Holder (Y/N)"
 D ^DIR
 K DIR
 G XIT:$D(DTOUT)!(Y="^")
 I Y=0 G PLK
 S DIE="^AUPN3PPH(",DA=AGELP("PH")
 S DR=".02////"_+AGEL("YCK")
 D ^DIE
NAME W !
 S DIE="^AUPN3PPH(",DA=AGELP("PH")
 S DR=".01Name as Stated on Policy..: "
 D ^DIE
 S DR=".09;.11;.12;.13;.14"
 D ^DIE
XIT K DIR,DUOUT,DTOUT,DIROUT,DIRUT
 Q
