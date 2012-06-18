DPTDZDCH ; IHS/TUCSON/JCM - DELETE CHARTS FROM MERGED FROM PATIENT ;
 ;;1.0;PATIENT MERGE;;FEB 02, 1994
 ;
 ;
START ;
 W:$D(IOF) @IOF W !,"This program will delete chart numbers from patients who have been merged ",!,"away.",!
 D GETFROM
 G:DPTDZFCH("FROM")="" END
 D GETSITE
 G:DPTDZFCH("CHART SITE")="" END
 D DISPLAY
 D GETOK
 I DPTDZFCH("OK")="" W !,"Okay, Bye!!" G END
 D DELCHART
 D DISPLAY2
END ;END OF JOB
 K DPTDZFCH,AUPNDAYS,AUPNSEX,AUPNPAT,AUPNDOB,AUPNDOD,APCHSPAT,APCHSTYP,AGQI,AGQT,AGTP
 K DA,DIE,DIC,DIK,DR,DO,D0,D,DI,DIW,DIWT,I,X,Y,XY,C,E,DQ,DN,DFN
 Q
 ;
GETFROM ;get the from patient (DFN)
 S DPTDZFCH("FROM")=""
 W !
 S DIR(0)="NO^1::0",DIR("A")="Enter the DFN of the From Patient",DIR("?")="Enter the internal entry number of the From (merged away) patient.  You can find this number on the mail message." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q:$D(DIRUT)
 I '$D(^DPT(Y,0)) W !!,$C(7),$C(7),"That patient does not exist!!" K DIRUT,Y G GETFROM
 I $P(^DPT(Y,0),U,19)="" W !!,$C(7),$C(7),"That patient has NOT been merged away!!" K DIRUT,Y G GETFROM
 S DPTDZFCH("FROM")=Y,DPTDZFCH("TO")=$P(^DPT(DPTDZFCH("FROM"),0),U,19)
 Q
GETSITE ; GET the site for the chart number to be switched
 S DPTDZFCH("CHART SITE")=""
 S DIC("A")="Enter the facility of the chart number to be deleted: ",DIC="^AUTTLOC(",DIC(0)="AEMQ" D ^DIC K DIC
 Q:Y=-1
 I '$D(^AUPNPAT(DPTDZFCH("FROM"),41,+Y)) W !!,$C(7),$C(7),"The 'From' patient, ",$P(^DPT(DPTDZFCH("FROM"),0),U)," does not have a chart at that facility." K Y G GETSITE
 S DPTDZFCH("CHART SITE")=+Y
 S DPTDZFCH("FROM CHART")=$P(^AUPNPAT(DPTDZFCH("FROM"),41,DPTDZFCH("CHART SITE"),0),U,2)
 S DPTDZFCH("TO CHART")=$P(^AUPNPAT(DPTDZFCH("TO"),41,DPTDZFCH("CHART SITE"),0),U,2)
 Q
DISPLAY ;DISPLAY CURRENT CHART NUMBERS
 W:$D(IOF) @IOF
 W !!?28,"Current Chart Number Data"
 W !!,"From DFN:  ",DPTDZFCH("FROM"),?22,"Name:  ",$P(^DPT(DPTDZFCH("FROM"),0),U),?59,"Chart No.:  ",DPTDZFCH("FROM CHART")
 Q
GETOK ;
 S DPTDZFCH("OK")=""
 W !!,"I will delete the chart numbers listed above.",!
 S DIR(0)="Y",DIR("A")="Do you want to continue",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q:$D(DIRUT)
 I Y=0 W !!,"Okay, I won't" Q
 S DPTDZFCH("OK")=1
 Q
DELCHART ;change chart number
 ;change from chart number to to's chart number
 S DITC="",DIE="^AUPNPAT("_DPTDZFCH("FROM")_",41,",DA(1)=DPTDZFCH("FROM"),DA=DPTDZFCH("CHART SITE"),DR=".01///@" D ^DIE
 I $D(Y) W !!,"OOPS.. Deleting the From patient chart number failed in DIE!" K Y,DIE Q
 Q
DISPLAY2 ; print new chart info, face sheet and health summary
 W !!?30,"Remaining Chart Numbers for this patient"
 W !!,"From DFN:  ",DPTDZFCH("FROM"),?22,"Name:  ",$P(^DPT(DPTDZFCH("FROM"),0),U) D
 S X=0 F  S X=$O(^AUPNPAT(DPTDZFCH("FROM"),41,X)) Q:X'=+X  W !?20,$P(^DIC(4,$P(^AUPNPAT(DPTDZFCH("FROM"),41,X,0),U),0),U),"  ",$P(^AUPNPAT(DPTDZFCH("FROM"),41,X,0),U,2)
 Q
 ;
