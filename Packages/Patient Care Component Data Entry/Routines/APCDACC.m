APCDACC ; IHS/CMI/LAB - stuff accept command on pov record ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 D INFORM
 D GETPAT
 I APCDPAT="" W !!,"No PATIENT selected!" D EOJ Q
 D GETVISIT
 I APCDVSIT="" W !!,"No VISIT selected!" D EOJ Q
 D DSPLY
MORE D GETTYPE
 I APCDPROC="" W !!,"No Record Type selected!",! D EOJ Q
 D @APCDPROC
 D PROCESS
 D MORE
 D EOJ
 Q
 ;
INFORM ; inform user what is going on
 W:$D(IOF) @IOF
 F APCDJ=1:1:5 S APCDX=$P($T(HDR+APCDJ),";;",2) W !?80-$L(APCDX)\2,APCDX
 K APCDX,APCDJ
 F APCDJ=1:1:5 W !,$P($T(TEXT+APCDJ),";;",2)
 Q
 ;
EOJ ; eoj clean up
 K ^UTILITY("DIQ1",$J)
 K APCDLOOK,APCDN,APCDCR,APCDVSIT,APCDPAT,APCDVSIT,APCDCLN,APCDCAT,APCDDATE,APCDLOC,APCDTYPE,APCDACCT,APCDPROC,APCDJ,APCDFN,APCDG,APCDT,APCDVIGR,APCDY
 K X,Y,%,DR,DIE,DIC,DA,%DT,D,DX,POP,S,DA,D0,DQ,DI,A
 K AUPNPAT,AUPNSEX,AUPNDOB,AUPNDOD,AUPNDAYS
 Q
GETTYPE ;get type of record to edit
 S APCDPROC=""
 S DIR(0)="SO^1:Purpose of Visit (V POV);2:Procedure/Operation (V PROCEDURE);3:Inpatient Record (V HOSPITALIZATION)",DIR("A")="Enter ACCEPT Command for which of the above" D ^DIR K DIR
 Q:$D(DIRUT)
 S APCDPROC=Y
 Q
 ;
GETPAT ;get patient
 K AUPNPAT,AUPNSEX,AUPNDAYS,AUPNDOD,AUPNDOB
 S APCDPAT="",DIC="^AUPNPAT(",DIC(0)="AEMQ" D ^DIC K DIC
 Q:Y<0
 I $D(APCDPARM),$P(APCDPARM,U,3)="Y" W !?25,"Ok" S %=1 D YN^DICN Q:%'=1
 S APCDPAT=+Y
 Q
 ;
GETVISIT ;get visit to edit
 S (APCDLOOK,APCDVSIT)=""
 K APCDVLK
 D ^APCDVLK
 K APCDLOOK
 Q
 ;
DSPLY ; DISPLAY VISIT TO BE EDITED
 S APCDVDSP=APCDVSIT D ^APCDVDSP
 Q
SET ;the following sub-routines set up variables with file
 ;specific information for each item in the GETTYPE DIR call
1 ;
 S APCDG="^AUPNVPOV(",APCDT="Purpose of Visit (V POV)",APCDN=9000010.07,APCDFN=".14"
 Q
 ;
2 ;
 S APCDG="^AUPNVPRC(",APCDT="Procedure/Operation (V Procedure)",APCDN=9000010.08,APCDFN=".09"
 Q
 ;
3 ;
 S APCDG="^AUPNVINP(",APCDT="Inpatient Record (V HOSPITALIZATION)",APCDN=9000010.02,APCDFN=".14"
 Q
PROCESS ;process the ACCEPT command
 S APCDVIGR=APCDG_"""AD"",APCDVSIT)"
 I '$D(@APCDVIGR) W !!!,$C(7),"No ",APCDT,"'s for that Visit.",! Q
 W !!,"You must select which ",APCDT," should be given",!,"the ACCEPT command."
 S APCDSWCR="AD",APCDSWV=APCDVSIT,APCDSWD=APCDN
 D ^APCDSW
 I '$D(APCDLOOK) W !!,"No ",APCDT," selected!",! Q
 I APCDLOOK="" W !!,"No ",APCDT," selected!",! Q
 S DA=APCDLOOK,DIE=APCDG,DR=APCDFN_"////^S X=DUZ" D ^DIE K DA,DIE,DR,DIU,DIV
 I $D(Y) W !!,"ACCEPT COMMAND FAILED!!  NOTIFY A PROGRAMMER!",$C(7),$C(7) Q
 K ^UTILITY("DIQ1",$J) S DIC=APCDG,DR=".01",DA=APCDLOOK D EN^DIQ1
 W !,"Accept command has been set for ",APCDT," ",^UTILITY("DIQ1",$J,APCDN,APCDLOOK,".01"),".",!
 S AUPNVSIT=APCDVSIT D MOD^AUPNVSIT
 I $D(Y) W !!,"DIE FAILED... NOTIFY PROGRAMMER",!,$C(7),$C(7)
 Q
HDR ;
 ;;PCC Data Entry Module
 ;;
 ;;****************************
 ;;*   ACCEPT Command Entry   *
 ;;****************************
 ;;
 ;
TEXT ;informing paragraph
 ;;
 ;;PLEASE NOTE:  THE ACCEPT COMMAND IS NO LONGER NECESSARY TO BE ENTERED
 ;;TO OVERRIDE AN EDIT.  THIS OPTION WILL BE ELIMINATED IN A FUTURE PATCH.
 ;;VISITS WILL EXPORT TO THE DATA WAREHOUSE AND WILL NOT BE REJECTED IF
 ;;THE ACCEPT COMMAND IS NOT PRESENT.
 ;;
 ;;This option will allow you to set the ACCEPT command in a Purpose of Visit,
 ;;Procedure or Hospitalization record.  This ACCEPT command is used to 
 ;;override an edit in the IHS Direct Inpatient and/or PCIS Systems.
 ;;
