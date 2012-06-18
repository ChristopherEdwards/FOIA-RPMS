AMQQMGR2 ; IHS/CMI/THL - QMAN USAGE LOG ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;-----
MENU W @IOF,!,?15,"*****  QMAN USAGE LOG  *****",!!!
ASK S DIR("??")="AMQQLOG"
 S DIR("A")=$C(10)_"     Your choice"
 S DIR("?")="Enter a code from the list or type '??' for more information"
 S DIR(0)="SO^1:ACTIVATE Log;2:INACTIVATE Log;3:PURGE Log;4:VIEW Log;9:HELP;0:EXIT"
 D ^DIR
 K DIR
 I 'Y K DUOUT,DIRUT,DTOUT G EXIT
 I Y=9 W !!,"Enter a code from the list or type '??' for more information." G ASK
 D @("L"_Y)
 I '$D(AMQQQUIT) G MENU
EXIT K AMQQQUIT,X,Y,AMQQLLD,AMQQLOG1,AMQQLOGN,%,%H,%I,A,B,C,D,FR,TO,H,M,S,T,Z
 Q
 ;
CHK I $D(DTOUT)+$D(DUOUT)+(Y=-1)+(Y="") K DIRUT,DUOUT,DTOUT S AMQQQUIT="" Q
 Q
 ;
LOG ; ENTRY POINT
 I '$P($G(^AMQQ(8,DUZ(2),0)),U,7) Q
 I '$D(^AMQQ(8,DUZ(2),4,0)) S ^(0)="^9009078.04D^^0"
 N X,%,Y,DIC,DIE,DA,DR,DINUM,Z,%I,%H
 S Z="D"
 S %=$$KEYCHECK^AMQQUTIL("AMQQZCLIN")
 I % S Z="C"
 D NOW^%DTC
 S (DINUM,X)=%
 S DIC="^AMQQ(8,DA(1),4,"
 S DIC(0)="L"
 S DA(1)=DUZ(2)
 D FILE^DICN
 I Y=-1 Q
 S (DA,AMQQLOGN)=+Y
 S AMQQLOG1=%H
 S DIE=DIC
 S DR=".02////"_DUZ_";.03////"_Z
 I $G(ION)'="" S DR=DR_";.04////"_$O(^%ZIS(1,"B",ION,""))
 S %=$G(AMQQCNAM)
 S:%="LIVING PATIENTS" %="PATIENTS"
 I %'="" S %=%_": "
 S Y=0
 F Z=0:0 S Z=$O(^UTILITY("AMQQ",$J,"Q",Z)) Q:'Z  S:Y %=%_", " S %=%_$P(^(Z),U,2),Y=1
 I %'="" S %=$E(%,1,189),DR=DR_";.07////"_%
 D ^DIE
 Q
 ;
TIME ; ENTRY POINT
 I '$D(AMQQLOGN)!('$D(AMQQLOG1)) K AMQQLOGN,AMQQLOG1 Q
 N A,B,C,D,%,Z,DA,DR,DIE,DIC,%H,%I,T,S,H,M
 D NOW^%DTC
 S S=%H
 S A=+S
 S B=$P(S,",",2)
 S Z=(60*60*24)
 S C=+AMQQLOG1
 S D=$P(AMQQLOG1,",",2)
 I (B-D)<0 S B=B+Z,A=A-1
 S S=((A-C)*Z)+(B-D)
 S T=S
 S H=T\3600
 I H S T=T#3600
 S M=T\60
 I M S T=T#60
 F %="H","M","T" S @%=$S('@%:"00",@%<10:("0"_@%),1:@%)
 S T=H_":"_M_":"_T
 S DA(1)=DUZ(2)
 S DIE="^AMQQ(8,DA(1),4,"
 S DA=AMQQLOGN
 S DR=".05////"_S_";.06////"_T
 D ^DIE
 K AMQQLOGN,AMQQLOG1,%I
 Q
 ;
TEST ;
 S FLDS="[AMQQ LOG]"
 S DIC="^AMQQ(8,"
 S BY="@40,.01,@40,.05"
 S FR="2910423.13000"
 S TO="2910501,55"
 D EN1^DIP
 Q
 ;
L4 ; VIEW LOG
 W @IOF,!,?20,"*****  VIEW QUERY LOG  *****",!!
 S DIR(0)="DO^::ETS"
 S DIR("A")="Start with what date"
 D ^DIR
 K DIR
 I Y="" S Y=2100000 W "  Start with first entry"
 I 'Y K DUOUT,DTOUT,DIRUT Q
 S AMQQLD1=Y
 S DIR(0)="DO^::ETS"
 S DIR("A")="End with what date"
 D ^DIR
 K DIR
 I Y="" S Y=3900000 W "  Go to last entry"
 I 'Y K DUOUT,DTOUT,DIRUT Q
 S AMQQLD2=Y
 I AMQQLD1>AMQQLD2 W "  ????",*7 H 2 G L4
 W !!!,"When viewing the log, you may sort by one of the following attributes =>",!!
 S DIR(0)="SO^1:USER (e.g. DOE,JOHN);2:SECURITY LEVEL (DEMOGRAPHIC or CLINICAL);3:OUTPUT DEVICE;4:SESSION DURATION (SECONDS);0:NONE"
 S DIR("A")="Your choice"
 S DIR("B")="NONE"
 D ^DIR
 K DIR
 I Y=0 G LIST
 I 'Y K DUOUT,DTOUT,DIRUT Q
 S AMQQLBY=",@40,.0"_(Y+1)
LIST S BY="@40,.01"_$G(AMQQLBY)
 S FR=AMQQLD1_",?"
 S TO=AMQQLD2_",?"
 S DIC="^AMQQ(8,"
 S FLDS="[AMQQ LOG]"
 S DHD="QMAN LOG"
 W !! D EN1^DIP
 S DIR(0)="E"
 D ^DIR
 K DUOUT,DTOUT,DIRUT,DIR
 K AMQQLBY,AMQQLD1,AMQQLD2,DIJ,B
 Q
 ;
L1 S X=1
 G LACT
L2 S X=0
LACT S DIE="^AMQQ(8,"
 S DA=DUZ(2)
 S DR=".07////"_X
 D ^DIE
 K DIE,DA,DR
 W !!,"The Q-Man LOG has been ",$S(X:"activated",1:"deactivated"),!!
 H 2
 Q
 ;
L3 ; PURGE
 W !!
 S DIR(0)="DO^::ET"
 S DIR("A")="Purge all QMan LOG entries prior to what date"
 S DIR("B")="NOW"
 D ^DIR
 K DIR
 I 'Y K DUOUT,DTOUT,DIRUT Q
 S AMQQLLD=Y
 F DA=0:0 S DA=$O(^AMQQ(8,DUZ(2),4,DA)) Q:'DA  Q:DA>AMQQLLD  S DIK="^AMQQ(8,DA(1),4,",DA(1)=DUZ(2) D ^DIK W "."
 K DA,DA,DIK,AMQQLLD
 W !!,"The Q-MAN LOG has been purged as requested",!!
 H 2
 Q
 ;
