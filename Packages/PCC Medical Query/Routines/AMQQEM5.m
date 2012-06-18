AMQQEM5 ; IHS/CMI/THL - EMAN OPTIONS ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;-----
EN ; ENTRY POINT FOR EXPORT OF DATA FROM ^AMQQ(3.1,
 S DIC="^AMQQ(3.1,"
 S DIC(0)="AEQM"
 S DIC("A")="File name: "
 D ^DIC
 K DIC
 I Y=-1 G ENX
 I '$D(^AMQQ(3.1,+Y,2,1,0)) G DATA
 W !!,"Get ready to receive the reference file (approx 1K)....."
 R !!,"Press the <return> key to initiate data transfer",X:DTIME E  G ENX
 I X?1."^" G ENX
 W !!
 F %=0:0 S %=$O(^AMQQ(3.1,+Y,2,%)) Q:'%  W ^(%,0),!
DATA W @IOF,!!,"Get ready to receive the data file......."
 R !!,"Press the <return> key to initiate data transfer",X:DTIME E  G ENX
 I X?1."^" G ENX
 F %=0:0 S %=$O(^AMQQ(3.1,+Y,1,%)) Q:'%  W ^(%,0),!
ENX W @IOF
 K DUOUT,DTOUT,X,Y
 Q
 ;
EN1 ;EP FOR PURGING EXPORT DATA FILE
 N AMQQEMPG
 W:$D(IOF) @IOF W !,?15,"*****  PURGE MUMPS EXPORT DATA FILE  *****",!!!
EN11 S DIR(0)="PO^9009073.1:EQM"
 S DIR("A")="Select MUMPS data file to purge"
 D ^DIR
 K DIR
 I $D(DIRUT)!($D(DIROUT)) K DIRUT,DIROUT,DUOUT,DTOUT Q
 S AMQQEMPG=+Y
 W !!,"MUMPS data file: ",$P(Y,U,2),!,"Created by: "
 S %=$P(^AMQQ(3.1,+Y,0),U,2)
 S %=$P($G(@AMQQ200(3)@(+$G(%),0)),U)
 S:%="" %="??"
 W %
 W !,"Entered on: "
 S Y=$P(^AMQQ(3.1,+Y,0),U,3)
 X ^DD("DD")
 W Y,!!
 I $P(^AMQQ(3.1,AMQQEMPG,0),U,2)'=DUZ W !!,"You are not allowed to purge anyone else's MUMPS data file.",*7,!! G EN11
 S DIR(0)="YO"
 S DIR("A")="Are you sure"
 D ^DIR
 K DIR
 I $D(DIRUT)!($D(DIROUT)) K DIROUT,DIRUT,DUOUT,DTOUT Q
 I 'Y G EN11
 S DA=AMQQEMPG
 S DIK="^AMQQ(3.1,"
 D ^DIK
 K DIK,DIC,DA
 I $D(AMQQ(3.1,"B")) S DIR(0)="YO",DIR("A")="Want to purge another" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y G EN11
 K DIRUT,DIROUT,DUOUT,DTOUT
 Q
 ;
