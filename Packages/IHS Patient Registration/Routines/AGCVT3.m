AGCVT3 ; IHS/ASDS/EFG - COMPUTE BIC ELIGIBILITY, OR SET TO "C"-NOT REVIEWED ;   
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
 ; A rough calculation indicates that it would take approximately
 ; a week of continual execution for this routine to work its way
 ; thru a database of 50,000 patients.
 Q
START ;
 I '$D(DTIME) S DTIME=300
 I '$D(DT) S %DT="",X="T" D ^%DT S DT=Y
 W $$S^AGVDF("IOF"),!!
 W ?31,"***   AGCVT3   ***",!!
 W "This routine reads thru the PATIENT file, and,",!
 W "if the BIC ELIGIBILITY STATUS does not exist, computes it."
 W !!,"It will take about ",$J(+$P(^AUPNPAT(0),U,4)*(285/1077)/60,5,1)," minutes",!
 W "to run this utility thru your ",$P(^AUPNPAT(0),U,4)," entries.",!!
 K DIR,DTOUT,DUOUT,DFOUT,DQOUT,DIRUT,DIROUT,DLOUT
 S DIR(0)="Y"
 S DIR("A")="Do you want to continue? (Y/N) "
 S DIR("B")="NO"
 D ^DIR
 Q:Y=0
USER I '($D(DUZ)#2) W !! S DIC="^VA(200,",DIC("A")="Who are you?",DIC(0)="AEFMNQ" D ^DIC G:+Y<0 END S DUZ=+Y
FACILITY I '$D(DUZ(2)) S DUZ(2)=0 D SET^XBSITE K DIC I '$D(DUZ(2)) G END
 I '$D(DUZ(0)) S DUZ(0)="@"
QUE ;
 K DIR,DTOUT,DUOUT,DFOUT,DQOUT,DIRUT,DIROUT,DLOUT
 S DIR(0)="Y"
 S DIR("A")="Do you want to q this process? (Y/N) "
 S DIR("B")="YES"
 D ^DIR
 G END:$D(DTOUT)!(Y["^")
 G ENTRY:Y=0
DEV X ^%ZOSF("UCI") S ZTRTN="ENTRY^AGCVT3",ZTUCI=Y,ZTIO="",ZTDESC="Calc BIC Eligibility, for "_$P(^AUTTLOC(DUZ(2),0),U,2)_"." S ZTSAVE=""
 D ^%ZTLOAD G:'$D(ZTSK) QUE W !!,"Task Number = ",ZTSK,!!,"Press RETURN..." R Y:DTIME K AG,AGIO,AGQIO,G,ZTDESC,ZTIO,ZTRTN,ZTSAVE,ZTSK,ZTUCI D ^%ZISC Q
ENTRY ;EP - TaskMan.
 S AGHIDA=+$P(^AUPNPAT(0),U,3)
 I '$D(ZTQUEUED) S IOP=ION D ^%ZIS,WAIT^DICD S DX=$X,DY=$Y+1
 F DA=1:1:AGHIDA I $D(^AUPNPAT(DA)),$D(^(DA,11)),$P(^(11),U,24)="" S DFN=DA D ^AGBIC2C I $P(^AUPNPAT(DA,11),U,24)="" S DIE="^AUPNPAT(",DR="1124///C" D ^DIE
 I '$D(ZTQUEUED) W !!?25,"AGCVT3 SUCCCESSFULLY COMPLETED",!!
END K DA,DIC,DR,DX,DY,AGHIDA
 Q
READ K DFOUT,DTOUT,DUOUT,DQOUT,DLOUT
 S DIR(0)="Y"
 D ^DIR
 S:Y="/.," (DFOUT,Y)=""
 S:Y="" DLOUT=""
 S:Y="^" (DUOUT,Y)=""
 S:Y?1"?".E!(Y["^") (DQOUT,Y)=""
 Q
TEST ;For testing, enter here to set all BIC ELIGIBILITY STATUS and
 ;DATE ELIGIBILITY DETERMINED fields to blank.
 ;
 S IOP=ION D ^%ZIS,WAIT^DICD S DX=$X,DY=$Y+1
 S AGHIDA=+$P(^AUPNPAT(0),U,3) F DA=1:1:AGHIDA X XY W DA I $D(^AUPNPAT(DA)),$D(^(DA,11)) I ($P(^(11),U,23)]"")!($P(^(11),U,24)]"") S $P(^(11),U,23,24)=""
