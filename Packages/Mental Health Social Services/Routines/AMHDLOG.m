AMHDLOG ; IHS/CMI/LAB - driver for primary care provider report ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
 W:$D(IOF) @IOF
 W !,"This report will display a list of who edited a BH record.",!!
 I '$G(DUZ(2)) W !!!,$C(7),$C(7),"SITE NOT SET IN YOUR USER PROFILE!  Please notify your Site Manager!" Q
 ;
 D GETDATE
 I AMHDATE="" W !!,"No Date entered!" D EOJ Q
 D GETLOC
 D GETPAT
 D RECLKUP
 I '$G(AMHR) D EOJ Q
 D DSPLY
 D EOJ
 Q
GETDATE ; GET DATE OF ENCOUNTER
 W !
 S AMHDATE=""
 S DIR(0)="DO^:"_DT_":EPT",DIR("A")="Enter ENCOUNTER DATE" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q:$D(DIRUT)
 S %DT="ET" D ^%DT G:Y<0 GETDATE
 I Y>DT W "  <Future dates not allowed>",$C(7),$C(7) K X G GETDATE
 K AMHODAT
 S AMHDATE=Y
 ;
 Q
GETPAT ; GET PATIENT
 S AMHPAT=""
 S DIC("A")="Enter PATIENT: ",DIC="^AUPNPAT(",DIC(0)="AEMQ" D ^DIC K DIC
 I Y<0 W !!,"no patient selected." Q
 S AMHPAT=+Y
 I $G(AUPNDOD)]"" W !!?10,"***** PATIENT'S DATE OF DEATH IS ",$$FMTE^XLFDT(AUPNDOD),!! H 2
 Q
 ;
GETLOC ;get location of encounter
 S AMHLOC=""
 S DIC("A")="Enter LOCATION OF ENCOUNTER (if known, otherwise press ENTER): ",DIC="^AUTTLOC(",DIC(0)="AEMQ" D ^DIC K DIC,DA
 Q:Y<0
 S AMHLOC=+Y
 Q
DSPLY ;
DIP ;
 S FLDS="[AMH DISPLAY LOG]",BY="@NUMBER",DIC="^AMHREC(",L=0
 S FR=AMHR,TO=AMHR
 K DHIT,DIOEND,DIOBEG
 D EN1^DIP
DONE ;
 S DIR(0)="EO",DIR("A")="End of report.  Press enter" D ^DIR K DIR S:$D(DUOUT) DIRUT=1 I $D(IOF) W @IOF
EOJ ;clean up
 K DIRUT,DUOUT,X,Y,DIR,FLDS,DIP,BY,TO,FR,DIC,DHD
 K AMHDATE,AMHLOC,AMHR,AMHRIEN,AMHPAT
 D KILL^AUPNPAT
 Q
 ;
RECLKUP ;
 D ^AMHRLKUP
 Q
