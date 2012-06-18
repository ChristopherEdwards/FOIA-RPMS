APCDRETR ; IHS/CMI/LAB - RETRANSMIT VISIT ; 
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;rejected by the IHS Data System;
 S APCDPAT=""
 F APCDL=0:0 D GETPAT Q:APCDPAT=""  D GETVISIT W:'APCDVSIT !,"No visit selected!!" I APCDVSIT D PROCESS
 D EOJ
 Q
 ;
EOJ ;
 K APCDPAT,APCDVSIT,APCDY,APCDVDSP,APCDVR,APCDLOOK,APCDCAT,APCDCLN,APCDDATE,APCDL,APCDLOC,APCDRETR,APCDTYPE
 K AUPNPAT,AUPNDAYS,AUPNSEX,AUPNDOD,AUPNDOB
 K DA,DR,DIE
 Q
GETPAT ; GET PATIENT
 W !
 S APCDPAT=""
 S DIC="^AUPNPAT(",DIC(0)="AEMQ" D ^DIC K DIC
 Q:Y<0
 S APCDPAT=+Y
 Q
 ;
GETVISIT ; GET VISIT
 S APCDVSIT=""
 D ^APCDVLK
 I APCDVSIT I AUPNDOB]"" S X2=AUPNDOB,X1=APCDDATE D ^%DTC S AUPNDAYS=X ; re-set days of age to visit date-dob
 I APCDVSIT K DR S APCDVDSP=APCDVSIT D ^APCDVDSP
 Q
 ;
PROCESS ;
 W !,"Are you sure this is the visit to re-transmit" S %=2 D YN^DICN S %Y=$E(%Y)
 Q:"Nn"[%Y
 S APCDVR=^AUPNVSIT(APCDVSIT,0)
 I $P(APCDVR,U,11) W $C(7),!!,"This visit has been deleted!!",! Q
 I '$P(APCDVR,U,9) W $C(7),!!,"This visit does not have any dependent entries - no data to transmit!!",! Q
 D C1 Q
 ;I $P(APCDVR,U,14)]"" D C2 Q
 Q
C1 ;W $C(7),!!,"This Visit has not been flagged as ever having been successfully sent to",!,"the IHS Data Center!",!
 W !,"I will re-set the Data Warehouse flag to re-send this visit as of today's",!,"Posting Date."
C1R ;
 S DIR(0)="Y",DIR("A")="Do you want to continue",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT)!(Y=0) W !,"BYE" Q
 S AUPNVSIT=APCDVSIT D MOD^AUPNVSIT
 K DA,DR,DIE,DIROUT,DUOUT,DTOUT,Y,X
 Q
 ;
C2 ;
 W !!,"This visit has already been transmitted to the IHS Data Center once.",!,"This will cause the visit to be re-transmitted to the Data Center.",!!
C2R W !!,"Have all corrections to the visit been made through modify or append mode",!,"so that the visit will now be accepted by the Data Center (either PCIS or the",!,"the IHS Inpatient System?",!
 S DIR(0)="Y",DIR("A")="Enter Yes or No",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) W $C(7),"Bye" Q
 I Y=0 W $C(7),!!,"Make corrections and then try again!",!! Q
 S APCDRETR="",DA=APCDVSIT,DR=".14///@",DIE="^AUPNVSIT(" D ^DIE K DA,DR,DIE
 S AUPNVSIT=APCDVSIT D MOD^AUPNVSIT
 W !!,"Visit will be re-sent as of Today's Date",! Q
 Q
