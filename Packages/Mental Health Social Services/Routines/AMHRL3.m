AMHRL3 ; IHS/CMI/LAB - LISTER ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
 ;
COUNT ;EP
 W !! S DIR(0)="S^T:Total Count Only;S:Sub-counts and Total Count;D:Detailed Listing"_$S(AMHPTVS="V":";F:Flat ASCII file (pre-defined record format)",1:"")
 S DIR("A")="Choose Type of Report",DIR("B")="D" D ^DIR K DIR W !!
 S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) S AMHQUIT=1 Q
 S AMHCTYP=Y
 I AMHCTYP="T" S $P(^AMHTRPT(AMHRPT,0),U,5)=1 S:AMHPTVS="V" AMHSORT=19,AMHSORV="Encounter Date" S:AMHPTVS="P" AMHSORT=70,AMHSORV="Patient Name" S:AMHPTVS="S" AMHSORT=129,AMHSORV="Date of Suicide Act" Q
 I AMHCTYP="D" D PRINT Q:$D(AMHQUIT)  D SORT Q
 I AMHCTYP="F" D FLAT S:AMHPTVS="S" AMHSORT=129,AMHSORV="Date of Suicide Act" Q:$D(AMHQUIT)  S $P(^AMHTRPT(AMHRPT,0),U,5)=1 S:AMHPTVS="V" AMHSORT=19,AMHSORV="Encounter Date" S:AMHPTVS="P" AMHSORT=70,AMHSORV="Patient Name" Q
 D SORT
 Q
PRINT ;
 S AMHCNTL="P" D ^AMHRL4
 Q
SORT ;
 K AMHSORT,AMHSORV,AMHQUIT
 I AMHCTYP="D",'$D(^AMHTRPT(AMHRPT,12)) W !!,"NO PRINT FIELDS SELECTED!!",$C(7),$C(7) S AMHQUIT=1 Q
 S AMHSORT=""
 D SHOWR^AMHRLS
 S AMHCNTL="R" D ^AMHRL4 K AMHCNTL
 I '$D(AMHSORV) S AMHQUIT=1 Q
 Q:AMHCTYP'="D"
PAGE ;
 K AMHSPAG
 Q:AMHCTYP'="D"
 S DIR(0)="Y",DIR("A")="Do you want a separate page for each "_AMHSORV,DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G SORT
 S AMHSPAG=Y,DIE="^AMHTRPT(",DA=AMHRPT,DR=".04///"_AMHSPAG D CALLDIE^AMHLEIN
 Q
FLAT ;
 S AMHFILE="AMH"_DUZ_"."
 S X2=$E(DT,1,3)_"0101",X1=DT D ^%DTC S AMHJD=X+1
 S AMHFILE=AMHFILE_AMHJD
 W !!,"I am going to create a file called ",AMHFILE," which will reside in ",!,"the ",$S($P(^AUTTSITE(1,0),U,21)=1:"/usr/spool/uucppublic",1:"C:\EXPORT")," directory.",!
 W "Actually, the file will be placed in the same directory that the data export"
 W !,"globals are placed.  See your site manager for assistance in finding the file",!,"after it is created.  PLEASE jot down and remember the following file name:",!?15,"**********    ",AMHFILE,"    **********",!
 W "It may be several hours (or overnight) before your report and flat file are ",!,"finished.",!
 W !,"As a reminder, the records that are generated and placed in file ",AMHFILE,!
 W !,"are in a standard, pre-defined record format.  For a definition of the format",!,"please see your user manual.",!
 S DIR(0)="Y",DIR("A")="Is everything ok?  Do you want to continue?",DIR("B")="Y" K DA D ^DIR K DIR
 I $D(DIRUT)!(Y'=1) S AMHQUIT=1 Q
 S DA=AMHRPT,DR=".12///"_AMHFILE,DIE="^AMHTRPT(" D ^DIE
 K DIE,DA,DR
 Q
