BCHRL3 ; IHS/TUCSON/LAB - LISTER ;  [ 10/28/96  2:05 PM ]
 ;;1.0;IHS RPMS CHR SYSTEM;;OCT 28, 1996
 ;
 ;
SCREEN ;EP
 D SMENU^BCHRL2
 W ! S DIR(0)="LO^1:"_BCHHIGH,DIR("A")="Select "_$S(BCHPTVS="P":"Patients",1:"visits")_" based on which of the above" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q:Y=""
 I $D(DIRUT) S BCHQUIT=1 Q
 ;process all items in Y
 D SELECT^BCHRL0
 D SHOW^BCHRLS
 W !! S DIR(0)="Y",DIR("A")="      Would you like to select additional "_$S(BCHPTVS="P":"PATIENT",1:"CHR RECORD")_" criteria",DIR("B")="NO" D ^DIR K DIR
 S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) S BCHQUIT=1 Q
 Q:Y=0
 G SCREEN
 ;
COUNT ;EP
 W !! S DIR(0)="S^T:Total Count Only;S:Sub-counts and Total Count;D:Detailed "_$S(BCHPTVS="V":"Record",1:"Patient")_" Listing",DIR("A")="Choose Type of Report",DIR("B")="D" D ^DIR K DIR W !!
 S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) S BCHQUIT=1 Q
 S BCHCTYP=Y
 I BCHCTYP="T" S $P(^BCHTRPT(BCHRPT,0),U,5)=1 S:BCHPTVS="V" BCHSORT=132,BCHSORV="Date of Encounter" S:BCHPTVS="P" BCHSORT=1,BCHSORV="Patient Name" Q
 I BCHCTYP="D" D PRINT Q:$D(BCHQUIT)  D SORT Q
 D SORT
 Q
PRINT ;
 D PMENU^BCHRL2
 S DIR(0)="LO^1:"_BCHHIGH,DIR("A")="Select print item(s)" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q:Y=""
 I $D(DIRUT) S BCHQUIT=1 Q
 W !!?15,"Total Report width (including column margins - 2 spaces):  ",BCHTCW
 D PSELECT^BCHRL0
 D SHOWP^BCHRLS
 W !! S DIR(0)="Y",DIR("A")="      Would you like to select additional PRINT criteria",DIR("B")="NO" D ^DIR K DIR
 S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) S BCHQUIT=1 Q
 Q:Y=0
 G PRINT
SORT ;
 K BCHSORT,BCHSORV,BCHQUIT
 I BCHCTYP="D",'$D(^BCHTRPT(BCHRPT,12)) W !!,"NO PRINT FIELDS SELECTED!!",$C(7),$C(7) S BCHQUIT=1 Q
 S BCHSORT=""
 D SHOWR^BCHRLS
 D RMENU^BCHRL2
 W ! S DIR(0)="NO^1:"_BCHHIGH_":0",DIR("A")=$S(BCHCTYP="S":"Sub-total ",1:"Sort ")_$S(BCHPTVS="P":"Patients",1:"visits")_" by which of the above" D ^DIR K DIR
 I $D(DUOUT) K ^BCHTRPT(BCHRPT,12) S BCHTCW=0 G PRINT
 I Y="",BCHCTYP="D" W !!,"No sort criteria selected ... will sort by "_$S(BCHPTVS="P":"Patient Name",1:"Date of Encounter")_"." S:BCHPTVS="V" BCHSORT=132,BCHSORV="Date of Encounter" S:BCHPTVS="P" BCHSORT=70,BCHSORV="Patient Name" H 2 D   Q
 .S DA=BCHRPT,DIE="^BCHTRPT(",DR=".07////"_BCHSORT D CALLDIE^BCHUTIL
 I Y="",BCHCTYP'="D" W !!,"No sub-totalling will be done.",!! H 2 S BCHCTYP="T",$P(^BCHTRPT(BCHRPT,0),U,5)=1 S:BCHPTVS="V" BCHSORT=132,BCHSORV="Date of Encounter" S:BCHPTVS="P" BCHSORT=1,BCHSORV="Patient Name" Q
 S BCHSORT=BCHSEL(+Y),BCHSORV=$P(^BCHSORT(BCHSORT,0),U),DA=BCHRPT,DIE="^BCHTRPT(",DR=".07////"_BCHSORT D CALLDIE^BCHUTIL
 Q:BCHCTYP'="D"
PAGE ;
 K BCHSPAG
 Q:BCHCTYP'="D"
 S DIR(0)="Y",DIR("A")="Do you want a separate page for each "_BCHSORV,DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G SORT
 S BCHSPAG=Y,DIE="^BCHTRPT(",DA=BCHRPT,DR=".04///"_BCHSPAG D CALLDIE^BCHUTIL
 Q
