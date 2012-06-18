BMCRL3 ; IHS/PHXAO/TMJ - MORE LISTER ;   
 ;;4.0;REFERRED CARE INFO SYSTEM;;JAN 09, 2006
 ;LAB added help text to dir call
 ;IHS/ITSC/FCJ ADDED DTTST SUB FOR CANNED REPORTS ;ADDED ABILITY
 ;   TO SAVE TOT/SUBTOT RPTS ;ADDED ABILITY TO SAVE CUSTOM TITLE
 ;   Save type of referral: Prim, Sec or both
 ;
TITLE ;EP
 Q:BMCCTYP="T"  ;--- don't ask for title if total count only
 K DIR,X,Y S DIR(0)="Y",DIR("A")="Would you like a custom title for this report",DIR("B")="N"
 I $D(BMCCAND),$D(^BMCRTMP(BMCRPT,1)) D
 .S BMCTITL=$P(^BMCRTMP(BMCRPT,1),U)
 .W !,"Previous Custom Report Title: ",BMCTITL
 .S DIR("A")="Would you like to change custom title for this report"
 D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) S BMCQUIT=1 Q
 Q:Y=0
 S BMCLENG=$S(BMCTCW:BMCTCW-8,1:60)
 I Y=1 K DIR,X,Y S DIR(0)="F^3:"_BMCLENG,DIR("A")="Enter custom title",DIR("?")="    Enter from 3 to "_BMCLENG_" characters" D ^DIR K DIR
 G:$D(DIRUT) TITLE
 S BMCTITL=Y
 I $D(BMCCAND) S $P(^BMCRTMP(BMCRPT,1),U)=BMCTITL
 Q
SAVE ;EP
 Q:$D(BMCCAND)  ;--- don't ask if already a pre-defined rpt
 I BMCCTYP="N",BMCCTYP="R" Q
 S BMCSAVE=""
 K DIR,X,Y S DIR(0)="Y",DIR("A")="Do you wish to SAVE this "_$S('$D(BMCEP1):"SEARCH/",1:"")_"PRINT/SORT logic for future use",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q:$D(DIRUT)
 Q:'Y
 K DIR,X,Y S DIR(0)="90001.82,.03",DIR("A")="Enter NAME for this REPORT DEFINITION" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) SAVE
 S BMCNAME=Y
 S DIE="^BMCRTMP(",DA=BMCRPT,DR=".02////1;.03///"_BMCNAME_";.06///"_BMCPTVS_";.05///"_BMCCTYP
 S:$D(BMCEP1) DR=DR_";.09///"_BMCPACK
 ;4.0 IHS/ITSC/FCJ ADDED REF TYPE: PRIM SEC BOTH
 S DR=DR_";.14///"_BMCTYPR
 S:$D(BMCTITL) DR=DR_";1///"_BMCTITL D ^DIE K DIE,DA,DR
 Q
COUNT ;EP
 W !! S DIR(0)="S^T:Total Count Only;S:Sub-counts and Total Count;D:Detailed Referral Listing;N:Numeric Item Basic Statistics;R:Referral Record Display",DIR("A")="     Choose Type of Report",DIR("B")="D" D ^DIR K DIR W !!
 S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) S BMCQUIT=1 Q
 S BMCCTYP=Y
 I BMCCTYP="T" S $P(^BMCRTMP(BMCRPT,0),U,5)=1 S:BMCPTVS="R" BMCSORT=6,BMCSORV="Referral Date" S:BMCPTVS="P" BMCSORT=1,BMCSORV="Patient Name" Q
 I BMCCTYP="R" S $P(^BMCRTMP(BMCRPT,0),U,5)=1 S:BMCPTVS="R" BMCSORT=6,BMCSORV="Referral Date" S:BMCPTVS="P" BMCSORT=1,BMCSORV="Patient Name" Q
 I BMCCTYP="D" D PRINT Q:$D(BMCQUIT)  D SORT Q
 I BMCCTYP="N" D NUMERIC Q
 D SORT
 Q
PRINT ;
 S BMCCNTL="P" D ^BMCRL4 K BMCCNTL
 Q
SORT ;
 K BMCSORT,BMCSORV,BMCQUIT
 I BMCCTYP="D",'$D(^BMCRTMP(BMCRPT,12)) W !!,"NO PRINT FIELDS SELECTED!!",$C(7),$C(7) S BMCQUIT=1 Q
 S BMCSORT=""
 D SHOWR^BMCRLS
 S BMCCNTL="R" D ^BMCRL4 K BMCCNTL
 I '$D(BMCSORV) S BMCQUIT=1 Q
 Q:BMCCTYP'="D"
PAGE ;
 K BMCSPAG
 Q:BMCCTYP'="D"
 S DIR(0)="Y",DIR("A")="Do you want a separate page for each "_BMCSORV,DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G SORT
 S BMCSPAG=Y,DIE="^BMCRTMP(",DA=BMCRPT,DR=".04///"_BMCSPAG D ^DIE K DA,DR,DIE
 Q
NUMERIC ;
 D ^XBCLS
 W !!,?20,"***NUMERIC ITEM BASIC STATISTICS**",!!
 W !!,"This print option will provide basic statistics (sum, count, mean, max, min)",!,"on any one of the 'Numeric Items' listed below.",!!,"Upon selection of a 'Numeric Item' a list of 'Sort' Choices will also be",!,"displayed.  "
 W "This 'Sort' Choice is provided for the purpose of Totaling and/or",!,"Sub-totaling all records selected.",!!,"For example, choosing 'Actual Cost' as the Numeric Item and, then, choosing"
 W !,"Primary Vendor as the 'Sort' Choice would produce a report of Actual Cost",!,"statistics (Sub-totaled by Vendor).",!!
 W "If you choose NOT to select a 'Sort' Item, the report would produce only",!,"one Grand Total (sum, count, mean, max, and min, etc.) for all",!,"'Actual Cost' statistics.",!!
 K BMCDISP,BMCSEL,BMCHIGH
 S BMCLHDR="NUMERIC ITEM Selection Menu" W ?((80-$L(BMCLHDR))/2),BMCLHDR,!
 S BMCHIGH=0,X=0 F  S X=$O(^BMCTSORT("C",X)) Q:X'=+X  S Y=$O(^BMCTSORT("C",X,"")) I $P(^BMCTSORT(Y,0),U,5)["S",$P(^BMCTSORT(Y,0),U,2)="N" S BMCHIGH=BMCHIGH+1,BMCSEL(BMCHIGH)=Y
 S BMCCUT=((BMCHIGH/2)+1)\1
 S I=0,J=1,K=1 F  S I=$O(BMCSEL(I)) Q:I'=+I!($D(BMCDISP(I)))  W !?5,I,")  ",$P(^BMCTSORT(BMCSEL(I),0),U) S BMCDISP(I)="",J=I+BMCCUT I $D(BMCSEL(J)),'$D(BMCDISP(J)) W ?40,J,")  ",$P(^BMCTSORT(BMCSEL(J),0),U) S BMCDISP(J)=""
 W ! S DIR(0)="NO^1:"_BMCHIGH_":0",DIR("A")="Produce statistics for which of the above" D ^DIR K DIR
 I $D(DIRUT) G COUNT
 S BMCNSRT=BMCSEL(+Y)
 D SORT
 Q
DTTST ;CANNED REPORTS
 ;TEST DATE RANGE FIELDS FOR CANNED REPORTS
 S BMCQT=""
 S I=0  F  S I=$O(^BMCRTMP(BMCRPT,11,I)) Q:I'?1N.N  D
 .I $P($G(^BMCTSORT(I,0)),U,2)="D" S BMCR("CR",I)=""
 I $D(BMCR("CR")) D
 .W !,"There are date range(s) in this report..."
 .S I="" F  S I=$O(BMCR("CR",I)) Q:I'?1.N  D  Q:$D(DIRUT)
 ..S BMCTEXT=$P(^BMCTSORT(I,0),U)
 ..S Y=$P(^BMCRTMP(BMCRPT,11,I,11,1,0),U) D DD^%DT S BMCBD=Y
 ..S Y=$P(^BMCRTMP(BMCRPT,11,I,11,1,0),U,2) D DD^%DT S BMCED=Y
 ..W !,BMCTEXT," Previous Date Range: ",BMCBD," TO ",BMCED
 ..S DIR(0)="Y",DIR("A")="Would you like to update these dates"
 ..D ^DIR
 ..Q:(Y="^")!(Y=0)
 ..D D^BMCRL0 Q:$D(DIRUT)
 ..S ^BMCRTMP(BMCRPT,11,I,11,1,0)=BMCBD_U_BMCED
 ..K ^BMCRTMP(BMCRPT,11,I,11,"B")
 ..S ^BMCRTMP(BMCRPT,11,I,11,"B",BMCBD,1)=""
 S BMCTYPR=$P(^BMCRTMP(BMCRPT,0),U,14) S:BMCTYPR="" BMCTYPR="P"
 W !,"The Report contains ",$S(BMCTYPR="P":"Only PRIMARY",BMCTYPR="S":"Only SECONDARY",1:"Primary and Secondary")," Referrals"
 S DIR(0)="Y",DIR("A")="Would you like to update the Referral type",DIR("B")="N"
 D ^DIR Q:(Y="^")!(Y=0)
 D RTYP^BMCRL Q:$D(DIRUT)
 S $P(^BMCRTMP(BMCRPT,0),U,14)=BMCTYPR
 Q
