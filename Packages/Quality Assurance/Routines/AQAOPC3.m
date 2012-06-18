AQAOPC3 ; IHS/ORDC/LJF - OCC BY VISIT & PATIENT ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contains 2 entry points for printing occurrence lists
 ;1 - by patient and 2 - by visit.  These reports are included among 
 ;the trending reports.
 ;
BYVISIT ;ENTRY POINT for option to print occ by visit   
 D BYVISIT^AQAOHOP2 ;intro text
VPAT ; >>> ask user for patient name or chart #
 W !! K DIC S DIC="^DPT(",DIC(0)="AEMQZ" D ^DIC G EXIT:Y=-1
 S AQAOPAT=+Y
 ;
 W !!,"Select VISIT DATE linked to an occurrence you are evaluating."
VVISIT ; >>> ask user for patient visit
 W !! K DIR S DIR(0)="DO^::EX",DIR("?")="^D VHELP^AQAOHOCC"
 S DIR("A")="Enter VISIT DATE" D ^DIR
 G VPAT:Y=U,VPAT:Y="" I Y<0 W *7," ??" G VVISIT
 S APCDVLDT=Y ;visit date variable
 S APCDPAT=AQAOPAT,(APCDOVRR,APCDLOOK,APCDVSIT)=""
 D ^APCDVLK ;visit lookup requiring only date
 K APCDOVRR,APCDLOOK,APCDCAT,APCDCLN,APCDDATE,APCDLOC,APCDPAT,APCDTYPE
 G VPAT:X=U
 I APCDVSIT="" W *7,"  NO VISIT FOR THAT DATE.  TRY AGAIN." G VVISIT
 ;
CHECK ; >>> check if visit is linked to occ available to user
 I '$D(^AQAOC("AE",AQAOPAT,APCDVSIT)) D  G VVISIT
 .W *7,"  NO OCCURRENCES FOR VISIT!",!
 S Y=0
 F  S Y=$O(^AQAOC("AE",AQAOPAT,APCDVSIT,Y)) Q:Y=""  D OCCCHK^AQAOSEC Q:$D(AQAOCHK("OK"))
 I '$D(AQAOCHK("OK")) D  G VVISIT
 .W *7,"  YOU DO NOT HAVE ACCESS TO ANY OCCURRENCES FOR THIS VISIT DATE",!
 ;
VPRINT ; >>> set variables and call dip     
 W !! S L=0,DIC="^AQAOC(",FLDS="[AQAO OCC LISTING]",BY="VISIT"
 ;screen for deleted occ and for selected patient
 S DIS(0)="I $P(^AQAOC(D0,1),U)'=2,$P(^(0),U,2)=AQAOPAT",AQAOINAC=""
 S (TO,FR)=$P(^AUPNVSIT(APCDVSIT,0),U) D EN1^DIP K APCDVSIT
 ;
 ;
EXIT ; >>> eoj
 D PRTOPT^AQAOVAR D KILL^AQAOUTIL Q
 ;
 ;
BYPAT ;ENTRY POINT for option to print occ by pat for visit range
 D BYPAT^AQAOHOP2 ;intro text
PPAT ; >>> ask user for patient name or chart #
 W !! K DIC S DIC="^DPT(",DIC(0)="AEMQZ" D ^DIC G EXIT:Y=-1
 S AQAOPAT=+Y
 ;
DATES ; >> ask user to choose date range
 S AQAOBD=$$BDATE^AQAOLKP G EXIT:AQAOBD=U,PPAT:AQAOBD=""
 S AQAOED=$$EDATE^AQAOLKP G EXIT:AQAOED=U,DATES:AQAOED=""
 ;
 ;
PPRINT ; >>> set variables and call dip     
 W !! S L=0,DIC="^AQAOC(",FLDS="[AQAO OCC LISTING]"
 S BY="@OCCURRENCE DATE",AQAOINAC=""
 ;screen for deleted occ and for selected patient
 S DIS(0)="I $P(^AQAOC(D0,1),U)'=2,$P(^(0),U,2)=AQAOPAT"
 S FR=AQAOBD,TO=AQAOED_".2400"
 D EN1^DIP
 G EXIT
