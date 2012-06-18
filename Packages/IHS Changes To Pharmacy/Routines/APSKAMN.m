APSKAMN ;IHS/ANMC/SFB MRS - MENU ENTRY & EXIT ACTIONS ; [ 09/28/94  11:00 AM ]
 ;;1.0;Aminoglycoside Kinetics;;OCT 31,1994
 K DIR
 S DIR(0)="E"
 D ^DIR
 G END:$D(DIRUT) K DIR
 ;
NOINFO ;EP - NO PATIENT INFORMATION
 W @IOF
 K DIR
 S DIR("A")="Please press return key."
 S DIR("A",1)="You must run New Patient option first in order to Procede!"
 S DIR(0)="E" D ^DIR
 G END:$D(DIRUT) K DIR
END Q
