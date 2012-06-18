DPTDZFCH ; IHS/TUCSON/JCM - CHANGE CHART NUMBERS FOR MERGED PATIENTS ; [ 02/02/94  4:52 PM ]
 ;;1.0;PATIENT MERGE;;FEB 02, 1994
 ;
START ;
 W:$D(IOF) @IOF W !,"This program will switch chart numbers for patients who have been merged ",!,"together and who have had the wrong chart number kept for the patient.",!!
 D GETFROM
 G:DPTDZFCH("FROM")="" END
 D GETSITE
 G:DPTDZFCH("CHART SITE")="" END
 D DISPLAY
 D GETOK
 I DPTDZFCH("OK")="" W !,"Okay, Bye!!" G END
 D CHGCHART
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
 S DIC("A")="Enter the facility of the chart number to be switched: ",DIC="^AUTTLOC(",DIC(0)="AEMQ" D ^DIC K DIC
 Q:Y=-1
 I '$D(^AUPNPAT(DPTDZFCH("FROM"),41,+Y)) W !!,$C(7),$C(7),"The 'From' patient, ",$P(^DPT(DPTDZFCH("FROM"),0),U)," does not have a chart at that facility." K Y G GETSITE
 I '$D(^AUPNPAT(DPTDZFCH("TO"),41,+Y)) W !!,$C(7),$C(7),"The 'To' patient, ",$P(^DPT(DPTDZFCH("TO"),0),U)," does not have a chart at that facility." K Y G GETSITE
 S DPTDZFCH("CHART SITE")=+Y
 S DPTDZFCH("FROM CHART")=$P(^AUPNPAT(DPTDZFCH("FROM"),41,DPTDZFCH("CHART SITE"),0),U,2)
 S DPTDZFCH("TO CHART")=$P(^AUPNPAT(DPTDZFCH("TO"),41,DPTDZFCH("CHART SITE"),0),U,2)
 Q
DISPLAY ;DISPLAY CURRENT CHART NUMBERS
 W:$D(IOF) @IOF
 W !!?28,"Current Chart Number Data"
 W !!,"From DFN:  ",DPTDZFCH("FROM"),?22,"Name:  ",$P(^DPT(DPTDZFCH("FROM"),0),U),?59,"Chart No.:  ",DPTDZFCH("FROM CHART")
 W !,"  To DFN:  ",DPTDZFCH("TO"),?22,"Name:  ",$P(^DPT(DPTDZFCH("TO"),0),U),?59,"Chart No.:  ",DPTDZFCH("TO CHART")
 Q
GETOK ;
 S DPTDZFCH("OK")=""
 W !!,"I will switch the chart numbers listed above.",!
 S DIR(0)="Y",DIR("A")="Do you want to continue",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q:$D(DIRUT)
 I Y=0 W !!,"Okay, I won't" Q
 S DPTDZFCH("OK")=1
 Q
CHGCHART ;change chart number
 ;change from chart number to to's chart number
 S DIE="^AUPNPAT("_DPTDZFCH("FROM")_",41,",DA(1)=DPTDZFCH("FROM"),DA=DPTDZFCH("CHART SITE"),DR=".02///"_DPTDZFCH("TO CHART") D ^DIE
 I $D(Y) W !!,"OOPS.. Changing the From patient chart number failed in DIE!" K Y,DIE Q
 S DIE="^AUPNPAT("_DPTDZFCH("TO")_",41,",DA(1)=DPTDZFCH("TO"),DA=DPTDZFCH("CHART SITE"),DR=".02///"_DPTDZFCH("FROM CHART") D ^DIE
 I $D(Y) W !!,"OOPS.. Changing the To patient chart number failed in DIE!" K Y,DIE Q
 Q
DISPLAY2 ; print new chart info, face sheet and health summary
 W !!?30,"NEW Chart Number Data"
 W !!,"From DFN:  ",DPTDZFCH("FROM"),?22,"Name:  ",$P(^DPT(DPTDZFCH("FROM"),0),U),?59,"Chart No.:  ",$P(^AUPNPAT(DPTDZFCH("FROM"),41,DPTDZFCH("CHART SITE"),0),U,2)
 W !,"  To DFN:  ",DPTDZFCH("TO"),?22,"Name:  ",$P(^DPT(DPTDZFCH("TO"),0),U),?59,"Chart No.:  ",$P(^AUPNPAT(DPTDZFCH("TO"),41,DPTDZFCH("CHART SITE"),0),U,2)
 S DPTDZFCH("QFLG")=0
 D ASK G:DPTDZFCH("QFLG") END
 S DPTDZFCH("PAT")=DPTDZFCH("TO")
 D DEVICE G:DPTDZFCH("QFLG") END
 D:$D(DPTDZFCH("PCC")) HEALTH
 D FACE K AGOPT
 Q
 ;
ASK ;
 K DIR
 W !!
 S DIR(0)="YO",DIR("B")="Y",DIR("A")="Do you wish to re-print a face sheet"
 I $P(^AUTTSITE(1,0),U,8)="Y" S DIR("A")=DIR("A")_" and health summary for the 'TO' patient" S DPTDZFCH("PCC")=""
 D ^DIR K DIR
 I $D(DUOUT)!($D(DTOUT)) S DPTDZFCH("QFLG")=1 G ASKX
 I 'Y S DPTDZFCH("QFLG")=1 G ASKX
 I $D(DPTDZFCH("PCC")) K DIC,Y S DIC=9001015,DIC("A")="Select health summary type: ",DIC(0)="AEQ" D
 .S X=$S($D(^APCHSCTL("B","PATIENT MERGE (COMPLETE)")):"PATIENT MERGE (COMPLETE)",1:"ADULT REGULAR"),DIC("B")=X D ^DIC S:Y>0 DPTDZFCH("TYPE")=+Y S:Y'>0 DPTDZFCH("QFLG")=1 K DIC
ASKX K Y
 Q
 ;
DEVICE ;
 S:$D(DPTDZFCH("DEVICE")) IOP=DPTDZFCH("DEVICE")
 S %ZIS(0)="MP" D ^%ZIS
 I POP S DPTDZFCH("QFLG")=1 G DEVICEX
 S DPTDZFCH("DEVICE")=$P(IO,";")_";"_IOST_";"_IOM_";"_IOSL
DEVICEX K %ZIS,POP
 Q
 ;
HEALTH ;
 I $D(^%ZOSF("XY"))#2 S (DX,DY)=0 X ^("XY") K DX,DY
 K APCHSPAT,APCHSTYP
 S APCHSPAT=DPTDZFCH("PAT"),APCHSTYP=DPTDZFCH("TYPE")
 D EN^APCHS
 Q
 ;
FACE ;
 I $D(^%ZOSF("XY"))#2 S (DX,DY)=0 X ^("XY") K DX,DY
 S DFN=DPTDZFCH("PAT")
 D START^AGFACE K AGOPT
 Q
