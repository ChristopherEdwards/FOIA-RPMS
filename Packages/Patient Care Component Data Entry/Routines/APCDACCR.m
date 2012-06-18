APCDACCR ; IHS/CMI/LAB - remove accept command from a record ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;
 D INFORM
 D GETPAT
 I APCDPAT="" W !!,"No PATIENT selected!" D EOJ Q
 D GETVISIT
 I APCDVSIT="" W !!,"No VISIT selected!" D EOJ Q
 D DSPLY
 D GETTYPE
 I APCDPROC="" W !!,"No Record Type selected!",! D EOJ Q
 D @APCDPROC
 D EOJ
 Q
 ;
INFORM ;inform user what is going on
 W !!,"This option will allow you to remove the ACCEPT command in a Purpose of Visit",!,"record.  The Accept command is used to override an edit in the",!,"IHS Direct Inpatient System.",!!
 W !!,"PLEASE NOTE:  The IHS Direct Inpatient System no longer requires"
 W !,"the use of the ACCEPT command so this option is no longer necessary and"
 W !,"will be eliminated.",!!
 Q
 ;
EOJ ;end of job clean up
 K APCDLOOK,APCDSWD,APCDSWCR,APCDSWV,APCDPAT,AUPNDAYS,AUPNPAT,AUPNSEX,AUPNDOD,AUPNDOB,X,Y,%,DR,DIE,DIC,DA,APCDVSIT,APCDCLN,APCDCAT,APCDDATE,APCDLOC,APCDTYPE,%DT,APCDPROC
 Q
GETTYPE ;get type of record to update
 S APCDPROC=""
 S DIR(0)="SO^1:Purpose of Visit (V POV);2:Procedure/Operation (V PROCEDURE);3:Inpatient Record (V HOSPITALIZATION)",DIR("A")="Remove ACCEPT Command from which of the above" D ^DIR K DIR
 I $D(DIRUT) Q
 S APCDPROC=Y
 Q
 ;
GETPAT ;get patient
 W !
 K AUPNPAT,AUPNSEX,AUPNDAYS,AUPNDOD,AUPNDOB
 S APCDPAT=""
 S DIC="^AUPNPAT(",DIC(0)="AEMQ" D ^DIC K DIC
 Q:Y<0
 I $D(APCDPARM),$P(APCDPARM,U,3)="Y" W !?25,"Ok" S %=1 D YN^DICN Q:%'=1
 S APCDPAT=+Y
 Q
 ;
GETVISIT ;get visit to edit
 S APCDLOOK="",APCDVSIT=""
 K APCDVLK
 D ^APCDVLK
 K APCDLOOK
 Q
 ;
DSPLY ;display selected visit, calls APCDVDSP
 S APCDVDSP=APCDVSIT D ^APCDVDSP
 Q
 ;
1 ;
 I '$D(^AUPNVPOV("AD",APCDVSIT)) W !!,"No POV's for that Visit",! Q
 W !!,"You must select which POV should have the ACCEPT command removed.",!
 S APCDSWD=9000010.07,APCDSWCR="AD",APCDSWV=APCDVSIT
 D ^APCDSW
 I APCDLOOK="" W !!,"No POV selected!",! Q
 S DA=APCDLOOK,DIE="^AUPNVPOV(",DR=".14///@" D ^DIE K DA,DIE,DR
 I $D(Y) W !!,"ACCEPT COMMAND FAILED!!  NOTIFY A PROGRAMMER!" Q
 ;W !,"Accept command has been removed for POV ",$P(^ICD9($P(^AUPNVPOV(APCDLOOK,0),U),0),U),!
 W !,"Accept command has been removed for POV ",$P($$ICDDX^ICDCODE($P(^AUPNVPOV(APCDLOOK,0),U)),U,2),!
 D MOD
 I $D(Y) W !!,"DIE FAILED... NOTIFY PROGRAMMER!"
 Q
2 ;
 ;
 I '$D(^AUPNVPRC("AD",APCDVSIT)) W !!,"No PROCEDURE's for that Visit",! Q
 W !!,"You must select which PROCEDURE/OPERATION should have the ACCEPT command removed.",!!
 S APCDSWD=9000010.08,APCDSWCR="AD",APCDSWV=APCDVSIT
 D ^APCDSW
 I APCDLOOK="" W !!,"No PROCEDURE/OPERATION selected!",! Q
 S DA=APCDLOOK,DIE="^AUPNVPRC(",DR=".09///@" D ^DIE K DA,DIE,DR
 I $D(Y) W !!,"ACCEPT COMMAND FAILED!!  NOTIFY A PROGRAMMER!" Q
 ;W !,"Accept command has been removed from PROCEDURE ",$P(^ICD0($P(^AUPNVPRC(APCDLOOK,0),U),0),U),!
 W !,"Accept command has been removed from PROCEDURE ",$P($$ICDOP^ICDCODE($P(^AUPNVPRC(APCDLOOK,0),U)),U,2),!
 D MOD
 I $D(Y) W !!,"DIE FAILED... NOTIFY PROGRAMMER",!,$C(7),$C(7)
 Q
3 ;
 I '$D(^AUPNVINP("AD",APCDVSIT)) W !!,"No V HOSPITALIZATION record exists for this Visit",! Q
 S APCDSWD=9000010.02,APCDSWCR="AD",APCDSWV=APCDVSIT
 D ^APCDSW
 I APCDLOOK="" W !!,"No V HOSPITALIZATION selected!",! Q
 S DA=APCDLOOK,DIE="^AUPNVINP(",DR=".14///@" D ^DIE K DA,DIE,DR
 I $D(Y) W !!,"ACCEPT COMMAND FAILED!!  NOTIFY A PROGRAMMER!" Q
 W !,"Accept command has been removed from V HOSPITALIZATION.",!
 D MOD
 I $D(Y) W !!,"DIE FAILED... NOTIFY PROGRAMMER",!,$C(7),$C(7)
 Q
 ;
MOD ;
 S AUPNVSIT=APCDVSIT D MOD^AUPNVSIT
 Q
