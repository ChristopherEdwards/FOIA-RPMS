AMQQMGR5 ; IHS/CMI/THL - SECURE DEVICES ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;-----
 I $P($G(^AMQQ(8,DUZ(2),0)),U,10)'="" D OLD G EXIT
 D M2
EXIT K X,DIRUT,DIRDT,DUOUT,DTOUT,DISYS,C,DG,%,%Y
 Q
 ;
M2 W @IOF,!!,?15,"*****  IDENTIFY SECURE DEVICES FOR Q-MAN  *****",!!
 W !!,"You may want to define a group of ""secure devices"" for Q-Man.  If you choose"
 W !,"this option, Q-Man reports can only be displayed or printed on the devices you"
 W !,"specify.  First tell me if the set is ""inclusionary"" (all devices on your list"
 W !,"are secure) or ""exclusionary"" (all devices are secure unless they appear on"
 W !,"your list).  You may assign ""secure status"" to all devices or just the printers."
 W !,"Finally, I will ask you to enter the devices one at a time.",!
 S DIR(0)="SO^1:INCLUSIONARY (secure devices in list);2:EXCLUSIONARY (non-secure devices in list);0:EXIT (no device security requested)"
 S DIR("A")=$C(10)_"     Your choice"
 D ^DIR
 K DIR
 I Y=0 Q
 I Y=U Q
 D CHK
 I $D(AMQQQUIT) K AMQQQUIT Q
 I Y=2 G M2EX
 S DIR(0)="SO^1:ALL devices outside of your set are not secure;2:ONLY printers outside of your set are not secure;0:EXIT"
 S DIR("A")=$C(10)_"     Your choice"
 D ^DIR
 K DIR
 I Y=0!(Y=U) G M2
 D CHK
 I $D(AMQQQUIT) K AMQQQUIT G M2
 S AMQQMGRS=$S(Y=1:1,1:2)
 W !!
 G SECURE
M2EX S DIR(0)="SO^1:ALL devices outside of your set are secure;2:ONLY printers outside of your set are secure;0:EXIT"
 S DIR("A")=$C(10)_"     Your choice"
 D ^DIR
 K DIR
 I Y=0!(Y=U) G M2
 D CHK
 I $D(AMQQQUIT) K AMQQQUIT G M2
 S AMQQMGRS=$S(Y=1:3,1:4)
 W !!
SECURE S DR=".1////"_$S(AMQQMGRS<3:"I",1:"E")_";.09////"_$S(AMQQMGRS#2:"A",1:"P")
 S DA=DUZ(2)
 S DIE="^AMQQ(8,"
 D ^DIE
 K DIE,DA,DR,DIC
 D ED
 Q
 ;
OLD ;
 W @IOF,!!,?20,"*****  DEVICE MANAGEMENT  *****",!!!,"Current status =>",!!
 S %=^AMQQ(8,DUZ(2),0)
 I $P(%,U,10)="I" W !,"INCLUSIONARY PROTOCOL (All devices on the list are secure)",!
 E  W !,"EXCLUSIONARY PROTOCOL (All devices on the list are NOT secure)",!
 I $P(%,U,9)="A" W !,"ALL DEVICES (terminals and printers) NEED SECURITY CLEARANCE",!
 E  W !,"ONLY PRINTERS NEED SECURITY CLEARANCE",!
 W !,"CURRENT LIST OF ",$S($P(%,U,10)="I":"",1:"NON-"),"SECURE DEVICES: ",!
 S N=0
 F X=0:0 S X=$O(^AMQQ(8,DUZ(2),1,X)) Q:'X  D STOP S (Y,%)=^(X,0),%=$P(^%ZIS(1,%,0),U) W ?3,%,?20,$P(^%ZIS(2,^%ZIS(1,Y,"SUBTYPE"),0),U),?48,$P($G(^%ZIS(1,Y,1)),U)
 S DIR(0)="SO^1:CLEAR the device list and start over;2:EDIT the device list;0:EXIT"
 S DIR("A")="What do you want to do now"
 S DIR("B")="EXIT"
 D ^DIR
 K DIR
 I $D(DIRUT)+$D(DUOUT)+$D(DTOUT)+'Y K DIRUT,DTOUT,DUOUT G EXIT
 I Y=1 D CLEAR Q
 I Y=2 D EDIT
 Q
 ;
CLEAR D WAIT^DICD
 S DA(1)=DUZ(2)
 S DIK="^AMQQ(8,"_DA(1)_",1,"
 F DA=0:0 S DA=$O(^AMQQ(8,DA(1),1,DA)) Q:'DA  D ^DIK W "."
 S DR=".1///@;.09///@"
 S DIE="^AMQQ(8,"
 S DA=DUZ(2)
 D ^DIE
 K DIK,DA,DR,DIC,D,D0,DI,DIE,DQ
 Q
 ;
EDIT I '$O(^AMQQ(8,DUZ(2),1,0)) W !!,"Sorry, there are no devices in the file to edit.",!!,*7 Q
ED S DA(1)=DUZ(2)
 S DIC("P")=$P(^DD(9009078,1,0),U,2)
 S DIC="^AMQQ(8,"_DA(1)_",1,"
 S DIC(0)="AEQLM"
 D ^DIC
 K DIC,DA
 I (Y=-1)+$D(DTOUT)+$D(DUOUT)+($E(X)=U) K DUOUT,DTOUT Q
 I $P(Y,U,3) D SCREEN G ED
 W !,?3,"This device is already in the file.  Want to remove it"
 S %=2
 D YN^DICN
 I $D(DTOUT)+$D(DUOUT) K DTOUT,DUOUT Q
 I "Nn"[$E(%Y) G ED
 S DA=+Y
 S DA(1)=DUZ(2)
 S DIK="^AMQQ(8,"_DA(1)_",1,"
 D ^DIK
 W !!,"DEVICE REMOVED FROM LIST"
 K %Y,Y,X,DIK,DA,DIC,D0,DI,DISYS
 G ED
 ;
CHK I $D(DTOUT)+$D(DUOUT)+(Y=-1)+(Y="") K DIRUT,DUOUT,DTOUT S AMQQQUIT="" Q
 Q
 ;
STOP N X
 S N=N+1
 W !
 I N=15 S N=0 R "<>",X:DTIME W $C(13),?79,$C(13)
 Q
 ;
SCREEN I $P(^AMQQ(8,DUZ(2),0),U,9)'="P" Q
 I $P(^%ZIS(2,^%ZIS(1,$P(Y,U,2),"SUBTYPE"),0),U)["P-" Q
 W !!,"SORRY...This device must be a printer!",!!,*7
 S DA(1)=DUZ(2)
 S DA=+Y
 S DIK="^AMQQ(8,"_DA(1)_",1,"
 D ^DIK
 K DIK,DA,DIC,D0,DI,DQ
 S Y=-1
 Q
 ;
