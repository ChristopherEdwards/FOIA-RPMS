APCDRPOV ; IHS/CMI/LAB - DISPLAY VISIT ;
 ;;2.0;IHS PCC SUITE;**2**;MAY 14, 2009
 ;
 W !!,"This option is used to resequence the purpose of visit (diagnoses)"
 W !,"on a visit.  This allows you to determine which will be the first diagnosis"
 W !,"listed which will become the primary diagnosis.",!!
 W !,"It is recommended that you query the provider before resequencing POVs.",!!
 D GETPAT
 I APCDPAT="" W !!,"No PATIENT selected!" D EOJ Q
 D GETVISIT
 I APCDVSIT="" W !!,"No VISIT selected!" D EOJ Q
 D DSPLY
 D EOJ
 Q
 ;
GETPAT ;EP GET-  PATIENT
 W !
 S AUPNLK("INAC")=""
 S APCDPAT=""
 S DIC="^AUPNPAT(",DIC(0)="AEMQ" D ^DIC K DIC
 Q:Y<0
 S APCDPAT=+Y
 Q
 ;
GETVISIT ;EP - this entry point called by the BVP package (View patient record)
 S APCDLOOK="",APCDVSIT=""
 K APCDVLK
 D ^APCDVLK
 K APCDLOOK
 Q
EN(APCDVSIT) ;EP -pass in visit
 ;
DSPLY ;
 W !!,"Visit Information",!
 S APCDVR0=^AUPNVSIT(APCDVSIT,0)
 S DFN=$P(APCDVR0,U,5)
 S Y=DFN D ^AUPNPAT
 ;W !,"Patient Name: ",$$VAL^XBDIQ1(2,DFN,.01),?50,"HRN: ",$$HRN^AUPNPAT(DFN,DUZ(2))
 S DA=APCDVSIT,DIC="^AUPNVSIT(" D EN^DIQ
 D POVDISP
 Q
 ;
EOJ ; EP - EOJ HOUSE KEEPING - this ep called by the BVP package (View patient record)
 K AUPNLK("INAC")
 K %,%DT,%X,%Y,C,DIYS,X,Y
 K APCDCLN,APCDCAT,APCDDATE,APCDLOC,APCDPAT,APCDVSIT,APCDLOOK,APCDTYPE
 D KILL^AUPNPAT
 Q
POVDISP ;
 ;display current V POV information
 W !?3,"Current Sequence of POV's",!
 S APCDX=0,APCDC=0 K APCDPOV F  S APCDX=$O(^AUPNVPOV("AD",APCDVSIT,APCDX)) Q:APCDX'=+APCDX  D
 .S APCDC=APCDC+1,APCDPOV(APCDC)=APCDX
 .W !?5,APCDC,")",?10,$$VAL^XBDIQ1(9000010.07,APCDX,.01),?18,$$VAL^XBDIQ1(9000010.07,APCDX,.04)
 .Q
 W ! K DIR S DIR(0)="Y",DIR("A")="Do you want to resequence these POV's",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D EOJ Q
 I 'Y D EOJ Q
 ;store all V POV info
 W !!,"Please jot down the order using the numbers above that you wish the POV's"
 W !,"to be in.  For example, if there are 3 POV's and you want #3 first, #1 second"
 W !,"and #2 third, you would enter 3,1,2.",!
 K APCDORD
 K DIR S DIR(0)="L^1:"_APCDC,DIR("A")="In what order do you want the POV's resequenced" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G DSPLY
 I X="" G DSPLY
 S APCDJ=Y
 I APCDC'=($L(APCDJ,",")-1) W !!,"You did not select all ",APCDC," POV's.  Please sequence all of them.",! D PAUSE^APCDALV1 G POVDISP
 K APCDNEWO
 S APCDC=0
 W !!,"The POV's will be resequenced to the following order:"
 F X=1:1 S J=$P(APCDJ,",",X) Q:J=""  W !?5,X,")" S APCDX=APCDPOV(J) W ?10,$$VAL^XBDIQ1(9000010.07,APCDX,.01),?18,$$VAL^XBDIQ1(9000010.07,APCDX,.04) S APCDC=APCDC+1,APCDNEWO(APCDC)=APCDX
 W ! K DIR S DIR(0)="Y",DIR("A")="Do you want to continue to resequence these POV's",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G DSPLY
 I 'Y G DSPLY
 ;now take povs and re-enter them, then delete the old ones
 S APCDC=0 F  S APCDC=$O(APCDNEWO(APCDC)) Q:APCDC'=+APCDC  S APCDX=APCDNEWO(APCDC) D
 .;create new entry with FILE^DICN
 .K DD,D0,DO
 .S X=$P(^AUPNVPOV(APCDX,0),U),DIC="^AUPNVPOV(",DIADD=1,DLAYGO=9000010.07,DIC(0)="L"
 .D FILE^DICN
 .I Y=-1 W !!,"ERROR in creating new POV for ",APCDC Q
 .S APCDNEW=+Y
 .K DIC,DIADD,DLAYGO
 .M ^AUPNVPOV(APCDNEW)=^AUPNVPOV(APCDX)
 .S DA=APCDNEW,DIK="^AUPNVPOV(" D IX1^DIK K DA,DIK
 .S DA=APCDNEW,DR=".12///"_$S(APCDC=1:"P",1:"S"),DIE="^AUPNVPOV(" D ^DIE K DA,DR,DIE
 .;now delete old one
 .S DA=APCDX,DIK="^AUPNVPOV(" D ^DIK K DA,DIK
 S AUPNVSIT=APCDVSIT D MOD^AUPNVSIT
 G DSPLY
