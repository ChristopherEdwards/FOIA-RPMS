BRNFMTS ; IHS/PHXAO/TMJ - driver for primary care provider report ; 
 ;;2.0;RELEASE OF INFO SYSTEM;;APR 10, 2003
 ;
 W:$D(IOF) @IOF
 W !,"This report will generate a list of patients for a specific Primary Care"
 W !,"Provider or a list of patients for all Primary Care Providers at this facility."
 I '$G(DUZ(2)) W !!!,$C(7),$C(7),"SITE NOT SET IN YOUR USER PROFILE!  Please notify your Site Manager!" Q
ASK ;
 ;
 S DIC="^DPT(",DIC("A")="Enter PATIENT NAME: ",DIC(0)="AEMQ" D ^DIC K DIC
 I Y=-1 G ASK
 S APCLPROV=+Y
 S PATNAME=$P(^DPT(APCLPROV,0),U)
DIP ;
 S DIC="^AUPNPAT("
 S FLDS="[TMJ JUMP PRINT]",BY="[TMJ JUMP SORT]"
 ;S FR=PATNAME,TO=PATNAME
 K DHIT,DIOEND,DIOBEG
 D EN1^DIP
DONE ;
 S DIR(0)="EO",DIR("A")="End of report.  Hit return" D ^DIR K DIR S:$D(DUOUT) DIRUT=1 I $D(IOF) W @IOF
EOJ ;clean up
 K DIRUT,DUOUT,X,Y,DIR,FLDS,DIP,BY,TO,FR,DIC,DHD
 K APCLPROV
 Q
