ACMRL3 ; IHS/TUCSON/TMJ - CMS REPORT LISTER...CUSTOM REPORT ; [ 01/07/02  1:14 PM ]
 ;;2.0;ACM CASE MANAGEMENT SYSTEM;**1,4**;JAN 10, 1996
 ;IHS/CMI/LAB - patch 1 flat file
 ;
 ;
TITLE ;EP
 Q:ACMCTYP="F"  ;IHS/CMI/LAB - patch 1 flat file
 Q:ACMCTYP="T"  ;--- don't ask for title if total count only
 K DIR,X,Y S DIR(0)="Y",DIR("A")="Would you like a custom title for this report",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) S ACMQUIT=1 Q
 Q:Y=0
 S ACMLENG=$S(ACMTCW:ACMTCW-8,1:60)
 I Y=1 K DIR,X,Y S DIR(0)="F^3:"_ACMLENG,DIR("A")="Enter custom title",DIR("?")="    Enter from 3 to "_ACMLENG_" characters" D ^DIR K DIR
 G:$D(DIRUT) TITLE
 S ACMTITL=Y
 Q
SAVE ;EP
 Q:$D(ACMCAND)  ;--- don't ask if already a pre-defined rpt
 Q:ACMCTYP'="D"  ;--- must be a detailed report to be saved
 S ACMSAVE=""
 K DIR,X,Y S DIR(0)="Y",DIR("A")="Do you wish to SAVE this "_$S('$D(ACMEP1):"SEARCH/",1:"")_"PRINT/SORT logic for future use",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q:$D(DIRUT)
 Q:'Y
 K DIR,X,Y S DIR(0)="9002258.8,.03",DIR("A")="Enter NAME for this REPORT DEFINITION" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) SAVE
 S ACMNAME=Y
 S DIE="^ACM(58.8,",DA=ACMRPT,DR=".02////1;.03///"_ACMNAME_";.06////"_ACMRG_";.05///"_ACMCTYP D ^DIE K DIE,DA,DR
 Q
SCREEN ;EP
 D SMENU^ACMRL2
 W ! S DIR(0)="LO^1:"_ACMHIGH,DIR("A")="      Select Patients based on which of the above" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q:Y=""
 I $D(DIRUT) S ACMQUIT=1 Q
 ;process all items in Y
 D SELECT^ACMRL0
 D SHOW^ACMRLS
 W !! S DIR(0)="Y",DIR("A")="      Would you like to select additional PATIENT criteria",DIR("B")="NO" D ^DIR K DIR
 S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) S ACMQUIT=1 Q
 Q:Y=0
 G SCREEN
 ;
COUNT ;EP
 W !! S DIR(0)="S^T:Total Count Only;S:Sub-counts and Total Count;D:Detailed Patient Listing;F:Delimited Export File",DIR("A")="     Choose Type of Report",DIR("B")="D" D ^DIR K DIR W !! ;IHS/CMI/LAB - added delimited
 S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) S ACMQUIT=1 Q
 S ACMCTYP=Y
 I ACMCTYP="T" S $P(^ACM(58.8,ACMRPT,0),U,5)=1 S ACMSORT=2,ACMSORV="Patient Name" Q
 I ACMCTYP="F" D FLAT^ACMRLF Q:$D(ACMQUIT)  D PRINT Q:$D(ACMQUIT)  D SORT Q  ;IHS/CMI/LAB - flat file
 I ACMCTYP="D" D PRINT Q:$D(ACMQUIT)  D SORT Q
 D SORT
 Q
PRINT ;
 D PMENU^ACMRL2
 S DIR(0)="LO^1:"_ACMHIGH,DIR("A")="Select print item(s)" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q:Y=""
 I $D(DIRUT) S ACMQUIT=1 Q
 I ACMCTYP="P" W !!?15,"Total Report width (including column margins - 2 spaces):  ",ACMTCW ;IHS/CMI/LAB - flat file
 D PSELECT^ACMRL0
 D SHOWP^ACMRLS
 W !! S DIR(0)="Y",DIR("A")="      Would you like to select additional PRINT criteria",DIR("B")="NO" D ^DIR K DIR
 S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) S ACMQUIT=1 Q
 Q:Y=0
 G PRINT
SORT ;
 K ACMSORT,ACMSORV,ACMQUIT
 I ACMCTYP="D",'$D(^ACM(58.8,ACMRPT,12)) W !!,"NO PRINT FIELDS SELECTED!!",$C(7),$C(7) S ACMQUIT=1 Q
 S ACMSORT=""
 D SHOWR^ACMRLS
 D RMENU^ACMRL2
 W ! S DIR(0)="NO^1:"_ACMHIGH_":0",DIR("A")=$S(ACMCTYP="S":"Sub-total ",1:"Sort ")_"Patients by which of the above" D ^DIR K DIR
 I $D(DUOUT) K ^ACM(58.8,ACMRPT,12) S ACMTCW=0 G PRINT
 I Y="",(ACMCTYP="D"!(ACMCTYP="F")) W !!,"No sort criteria selected ... will sort by Patient Name" S ACMSORT=2,ACMSORV="Patient Name" H 4 D  Q  ;IHS/CMI/LAB
 .S DA=ACMRPT,DIE="^ACM(58.8,",DR=".07////"_ACMSORT D ^DIE K DA,DR,DIE,DIU,DIV,DIY,DIW
 I Y="",ACMCTYP'="D" W !!,"No sub-totalling will be done.",!! H 4 S ACMCTYP="T",ACMSORT=2 Q
 S ACMSORT=ACMSEL(+Y),ACMSORV=$P(^ACM(58.1,ACMSORT,0),U),DA=ACMRPT,DIE="^ACM(58.8,",DR=".07////"_ACMSORT D ^DIE K DA,DR,DIE,DIU,DIV,DIY,DIW
 Q:ACMCTYP'="D"
PAGE ;
 K ACMSPAG
 Q:ACMCTYP'="D"
 S DIR(0)="Y",DIR("A")="Do you want a separate page for each "_ACMSORV,DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G SORT
 S ACMSPAG=Y,DIE="^ACM(58.8,",DA=ACMRPT,DR=".04///"_ACMSPAG D ^DIE K DA,DR,DIE
 Q
