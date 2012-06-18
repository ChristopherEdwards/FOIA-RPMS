AQAQMLE ;IHS/ANMC/LJF - EDIT MED LICENSE ENTRIES; [ 05/27/92  11:12 AM ]
 ;;2.2;STAFF CREDENTIALS;;01 OCT 1992
 ;
 ;must have DA set
 ;
DISPLAY ;EP;***> display any entries already in med licensure file
 W !!
 S (AQAX,AQACNT)=0,AQAQDA=DA
 F  S AQAX=$O(^AQAQML("C",DA,AQAX)) Q:AQAX'=+AQAX  D
 .S AQACNT=AQACNT+1,AQA(AQACNT)=AQAX
 .S Y=$P(^AQAQML(AQAX,0),U),C=$P(^DD(9002161.2,.01,0),U,2) D Y^DIQ
 .W !,AQACNT,")  ",Y    ;med license state
 .S AQAQLAST=$P($G(^AQAQML(AQAX,1,0)),U,3)  ;expiration date
 .I AQAQLAST>0 S Y=$P(^AQAQML(AQAX,1,AQAQLAST,0),U),C=$P(^DD(9002161.21,.01,0),U,2) D Y^DIQ W ?35,"Expires:  ",Y
 .Q
 G ADD:AQACNT=0  ;go directly to add if first entry
 S AQACNT=AQACNT+1 W !,AQACNT,")  ADD NEW ENTRY"
 ;
CHOOSE W ! K DIR S DIR(0)="NO^1:"_AQACNT
 S DIR("A")="Choose ONE from list OR hit <return> to continue"
 D ^DIR G END:X="",END:$D(DIRUT),CHOOSE:Y=-1
 I +Y=AQACNT G ADD
 E  S DA=AQA(+Y) G EDIT
 ;
ADD K DIC S DIC=5,DIC(0)="AQEMZ" D ^DIC
 G END:X="",END:X="^",ADD:Y=-1
 K DIC,DD S DIC="^AQAQML(",X=+Y,DIC("DR")=".02///^S X=""`""_AQAQDA"
 S DLAYGO=9002161.2,DIC(0)="L" D FILE^DICN
 S DA=+Y
 ;
EDIT K DIC,DIE S DIDEL=9002161.2,DIE=9002161.2,DR="[AQAQMLEDIT]" D ^DIE
 ;
 K DIR S DIR(0)="Y",DIR("B")="NO"
 S DIR("A")="Do you wish to ADD or EDIT another Medical License"
 D ^DIR I Y=1 S DA=AQAQDA G DISPLAY
 ;
END S DA=AQAQDA K AQAX,AQACNT,AQA,DIR,DIE,DIC Q
