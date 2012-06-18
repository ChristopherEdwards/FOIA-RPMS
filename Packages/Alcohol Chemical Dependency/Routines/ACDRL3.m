ACDRL3 ;IHS/ADC/EDE/KML - LISTER;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;
 ;
COUNT ;EP
 W !! S DIR(0)="S^T:Total Count Only;S:Sub-counts and Total Count;D:Detailed Listing"_$S(ACDPTVS="V":";F:Flat ASCII file (pre-defined record format)",1:"")
 S DIR("A")="Choose Type of Report",DIR("B")="D" D ^DIR K DIR W !!
 S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) S ACDQUIT=1 Q
 S ACDCTYP=Y
 I ACDCTYP="T" S $P(^ACDRPTD(ACDRPT,0),U,5)=1 S:ACDPTVS="V" ACDSORT=19,ACDSORV="Visit Date" S:ACDPTVS="P" ACDSORT=119,ACDSORV="Patient Name" Q
 I ACDCTYP="D" D PRINT Q:$D(ACDQUIT)  D SORT Q
 I ACDCTYP="F" D FLAT Q:$D(ACDQUIT)  S $P(^ACDRPTD(ACDRPT,0),U,5)=1 S:ACDPTVS="V" ACDSORT=19,ACDSORV="Visit Date" S:ACDPTVS="P" ACDSORT=119,ACDSORV="Patient Name" Q
 D SORT
 Q
PRINT ;
 S ACDCNTL="P" D ^ACDRL4 K ACDCNTL
 Q
SORT ;
 K ACDSORT,ACDSORV,ACDQUIT
 I ACDCTYP="D",'$D(^ACDRPTD(ACDRPT,12)) W !!,"NO PRINT FIELDS SELECTED!!",$C(7),$C(7) S ACDQUIT=1 Q
 S ACDSORT=""
 D SHOWR^ACDRLS
 S ACDCNTL="R" D ^ACDRL4 K ACDCNTL
 Q:ACDCTYP'="D"
PAGE ;
 K ACDSPAG
 Q:ACDCTYP'="D"
 S DIR(0)="Y",DIR("A")="Do you want a separate page for each "_ACDSORV,DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G SORT
 S ACDSPAG=Y,DIE="^ACDRPTD(",DA=ACDRPT,DR=".04///"_ACDSPAG D CALLDIE^ACDRLU1
 Q
FLAT ;
 S ACDFILE="ACD"_DUZ_"."
 S X2=$E(DT,1,3)_"0101",X1=DT D ^%DTC S ACDJD=X+1
 S ACDFILE=ACDFILE_ACDJD
 W !!,"I am going to create a file called ",ACDFILE," which will reside in ",!,"the ",$S($P(^AUTTSITE(1,0),U,21)=1:"/usr/spool/uucppublic",1:"C:\EXPORT")," directory.",!
 W "Actually, the file will be placed in the same directory that the data export"
 W !,"globals are placed.  See your site manager for assistance in finding the file",!,"after it is created.  PLEASE jot down and remember the following file name:",!?15,"**********    ",ACDFILE,"    **********",!
 W "It may be several hours (or overnight) before your report and flat file are ",!,"finished.",!
 W !,"As a reminder, the records that are generated and placed in file ",ACDFILE,!
 W !,"are in a standard, pre-defined record format.  For a definition of the format",!,"please see your user manual.",!
 S DIR(0)="Y",DIR("A")="Is everything ok?  Do you want to continue?",DIR("B")="Y" K DA D ^DIR K DIR
 I $D(DIRUT)!(Y'=1) S ACDQUIT=1 Q
 S DA=ACDRPT,DR=".12///"_ACDFILE,DIE="^ACDRPTD(" D ^DIE
 K DIE,DA,DR
 Q
