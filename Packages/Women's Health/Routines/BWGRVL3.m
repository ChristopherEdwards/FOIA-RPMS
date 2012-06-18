BWGRVL3 ; IHS/CMI/LAB - NO DESCRIPTION PROVIDED ;  [ 08/16/01  3:48 PM ]
 ;;2.0;WOMEN'S HEALTH;**6,8**;MAY 16, 1996
 ;
 ;
 ;IHS/CMI/LAB - modified file number
TITLE ;EP
 Q:"FTC"[BWGRCTYP
 K DIR,X,Y S DIR(0)="Y",DIR("A")="Would you like a custom title for this report",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) S BWGRQUIT=1 Q
 Q:Y=0
 S BWGRLENG=$S(BWGRTCW:BWGRTCW-8,1:60)
 I Y=1 K DIR,X,Y S DIR(0)="F^3:"_BWGRLENG,DIR("A")="Enter custom title",DIR("?")="    Enter from 3 to "_BWGRLENG_" characters" D ^DIR K DIR
 G:$D(DIRUT) TITLE
 S BWGRTITL=Y
 Q
SAVE ;EP
 Q:$D(BWGRCAND)  ;--- don't ask if already a pre-defined rpt
 Q:BWGRCTYP'="D"  ;--- must be a detailed report to be saved
 S BWGRSAVE=""
 K DIR,X,Y S DIR(0)="Y",DIR("A")="Do you wish to SAVE this "_$S('$D(BWGREP1):"SEARCH/",1:"")_"PRINT/SORT logic for future use",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q:$D(DIRUT)
 Q:'Y
 K DIR,X,Y S DIR(0)="9002086.88,.03",DIR("A")="Enter NAME for this REPORT DEFINITION" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) SAVE
 S BWGRNAME=Y
 S DIE="^BWGRTRPT(",DA=BWGRRPT,DR=".02////1;.03///"_BWGRNAME_";.06///"_BWGRPTVS_";.05///"_BWGRCTYP S:$D(BWGREP1) DR=DR_";.09///"_BWGRPACK D ^DIE K DIE,DA,DR
 Q
COUNT ;EP
 W !!
 S DIR(0)="S^T:Total Count Only;S:Sub-counts and Total Count;D:Detailed "_$S(BWGRPTVS="R":"WH Procedure",1:"Patient")_" Listing"
 S DIR("A")="     Choose Type of Report",DIR("B")="D" D ^DIR K DIR W !!
 S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) S BWGRQUIT=1 Q
 S BWGRCTYP=Y
 I BWGRCTYP="T" S $P(^BWGRTRPT(BWGRRPT,0),U,5)="T" S:BWGRPTVS="R" BWGRSORT=19,BWGRSORV="Procedure Date" S:BWGRPTVS="P" BWGRSORT=1,BWGRSORV="Patient Name" Q
 I BWGRCTYP="D" D PRINT Q:$D(BWGRQUIT)  D SORT Q
 D SORT
 Q
PRINT ;
 S BWGRCNTL="P"
 D ^BWGRVL4
 Q
SORT ;EP
 K BWGRSORT,BWGRSORV,BWGRQUIT
 I BWGRCTYP="D",'$D(^BWGRTRPT(BWGRRPT,12)) W !!,"NO PRINT FIELDS SELECTED!!",$C(7),$C(7) S BWGRQUIT=1 Q
 S BWGRSORT=""
 D SHOWR^BWGRVLS
 S BWGRCNTL="R" D ^BWGRVL4 K BWGRCNTL
 I '$D(BWGRSORV) S BWGRQUIT=1 Q
 Q:BWGRCTYP'="D"
PAGE ;
 K BWGRSPAG
 Q:BWGRCTYP'="D"
 S DIR(0)="Y",DIR("A")="Do you want a separate page for each "_BWGRSORV,DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G SORT
 S BWGRSPAG=Y,DIE="^BWGRTRPT(",DA=BWGRRPT,DR=".04///"_BWGRSPAG D ^DIE K DA,DR,DIE
 Q
FLAT ;
 S BWGRFILE="BWGR"_DUZ_"."
 S X2=$E(DT,1,3)_"0101",X1=DT D ^%DTC S BWGRJD=X+1
 S BWGRFILE=BWGRFILE_BWGRJD
 W !!,"I am going to create a file called ",BWGRFILE," which will reside in ",!,"the ",$S($P(^AUTTSITE(1,0),U,21)=1:"/usr/spool/uucppublic",1:"C:\EXPORT")," directory.",!
 W "Actually, the file will be placed in the same directory that the data export"
 W !,"globals are placed.  See your site manager for assistance in finding the file",!,"after it is created.  PLEASE jot down and remember the following file name:",!?15,"**********    ",BWGRFILE,"    **********",!
 W "It may be several hours (or overnight) before your report and flat file are ",!,"finished.",!
 W !,"As a reminder, the records that are generated and placed in file ",BWGRFILE,!
 W !,"are in a standard, pre-defined record format.  For a definition of the format",!,"please see your user manual.",!
 S DIR(0)="Y",DIR("A")="Is everything ok?  Do you want to continue?",DIR("B")="Y" K DA D ^DIR K DIR
 I $D(DIRUT)!(Y'=1) S BWGRQUIT=1 Q
 S DA=BWGRRPT,DR=".12///"_BWGRFILE,DIE="^BWGRTRPT(" D ^DIE
 K DIE,DA,DR
 Q
