BNIGVL3 ; IHS/CMI/LAB - general retrieval cont ;
 ;;1.0;BNI CPHD ACTIVITY DATASYSTEM;;DEC 20, 2006
 ;
 ;
TITLE ;EP
 Q:"FTC"[BNIGCTYP
 K DIR,X,Y S DIR(0)="Y",DIR("A")="Would you like a custom title for this report",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) S BNIGQUIT=1 Q
 Q:Y=0
 S BNIGLENG=$S(BNIGCTYP="L":60,BNIGTCW:BNIGTCW-8,1:60)
 I Y=1 K DIR,X,Y S DIR(0)="F^3:"_BNIGLENG,DIR("A")="Enter custom title",DIR("?")="    Enter from 3 to "_BNIGLENG_" characters" D ^DIR K DIR
 G:$D(DIRUT) TITLE
 S BNIGTITL=Y
 Q
SAVE ;EP
 Q:$D(BNIGCAND)  ;--- don't ask if already a pre-defined rpt
 Q:BNIGCTYP'="D"  ;--- must be a detailed report to be saved
 S BNIGSAVE=""
 K DIR,X,Y S DIR(0)="Y",DIR("A")="Do you wish to SAVE this "_$S('$D(BNIGEP1):"SEARCH/",1:"")_"PRINT/SORT logic for future use",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q:$D(DIRUT)
 Q:'Y
 K DIR,X,Y S DIR(0)="90512.88,.03",DIR("A")="Enter NAME for this REPORT DEFINITION" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) SAVE
 S BNIGNAME=Y
 S DIE="^BNIRTMP(",DA=BNIGRPT,DR=".02////1;.03///"_BNIGNAME_";.06///"_BNIGPTVS_";.05///"_BNIGCTYP S:$D(BNIGEP1) DR=DR_";.09///"_BNIGPACK D ^DIE K DIE,DA,DR
 Q
COUNT ;EP
 W !!
 S DIR(0)="S^T:Total Count Only;S:Sub-counts and Total Count;D:Detailed Activity Record Listing"
 S DIR(0)=DIR(0)_";L:Delimited Output File for use in Excel"
 S DIR("A")="     Choose Type of Report",DIR("B")="D" D ^DIR K DIR W !!
 S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) S BNIGQUIT=1 Q
 S BNIGCTYP=Y
 S DA=BNIGRPT,DR=".05///"_BNIGCTYP,DIE="^BNIRTMP(" D ^DIE
 K DIE,DA,DR
 I BNIGCTYP="T" S $P(^BNIRTMP(BNIGRPT,0),U,5)="T" S BNIGSORT=1,BNIGSORV="Activity Date" Q
 I BNIGCTYP="D" D PRINT Q:$D(BNIGQUIT)  D SORT Q
 I BNIGCTYP="L" D  Q
 .W !!,"You have selected to create a delimited output file, you will be"
 .W !,"asked to select the print items, the sort item and then to name the"
 .W !,"output file.",!!
 .K DIR S DIR(0)="Y",DIR("A")="Do you wish to continue",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) S BNIGQUIT=1 Q
 .I 'Y S BNIGQUIT=1 Q
 .D PRINT Q:$D(BNIGQUIT)  S $P(^BNIGRTMP(BNIGRPT,0),U,5)="F" D  Q:$D(BNIGQUIT)
 .D SORT
 .D DELIMIT
 .I BNIGDELT="" S BNIGQUIT=1
 D SORT
 Q
PRINT ;
 S BNIGCNTL="P"
 D ^BNIGVL4
 Q
SORT ;EP
 K BNIGSORT,BNIGSORV,BNIGQUIT
 I BNIGCTYP="D"!(BNIGCTYP="L"),'$D(^BNIRTMP(BNIGRPT,12)) W !!,"NO PRINT FIELDS SELECTED!!",$C(7),$C(7) S BNIGQUIT=1 Q
 S BNIGSORT=""
 D SHOWR^BNIGVLS
 S BNIGCNTL="R" D ^BNIGVL4 K BNIGCNTL
 I '$D(BNIGSORV) S BNIGQUIT=1 Q
 Q:BNIGCTYP'="D"
PAGE ;
 K BNIGSPAG
 Q:BNIGCTYP'="D"
 S DIR(0)="Y",DIR("A")="Do you want a separate page for each "_BNIGSORV,DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G SORT
 S BNIGSPAG=Y,DIE="^BNIRTMP(",DA=BNIGRPT,DR=".04///"_BNIGSPAG D ^DIE K DA,DR,DIE
 Q
FLAT ;
 S BNIGFILE="BNIG"_DUZ_"."
 S X2=$E(DT,1,3)_"0101",X1=DT D ^%DTC S BNIGJD=X+1
 S BNIGFILE=BNIGFILE_BNIGJD
 W !!,"I am going to create a file called ",BNIGFILE," which will reside in ",!,"the ",$S($P(^AUTTSITE(1,0),U,21)=1:"/usr/spool/uucppublic",1:$P($G(^AUTTSITE(1,2)),U))," directory.",!
 W "Actually, the file will be placed in the same directory that the data export"
 W !,"globals are placed.  See your site manager for assistance in finding the file",!,"after it is created.  PLEASE jot down and remember the following file name:",!?15,"**********    ",BNIGFILE,"    **********",!
 W "It may be several hours (or overnight) before your report and flat file are ",!,"finished.",!
 W !,"As a reminder, the records that are generated and placed in file ",BNIGFILE,!
 W !,"are in a standard, pre-defined record format.  For a definition of the format",!,"please see your user manual.",!
 S DIR(0)="Y",DIR("A")="Is everything ok?  Do you want to continue?",DIR("B")="Y" K DA D ^DIR K DIR
 I $D(DIRUT)!(Y'=1) S BNIGQUIT=1 Q
 S DA=BNIGRPT,DR=".12///"_BNIGFILE,DIE="^BNIRTMP(" D ^DIE
 K DIE,DA,DR
 Q
DELIMIT ;get filename for delimited output
 K BNIGQUIT
 S BNIGDELF="",BNIGDELT=""
 W !!,"You have selected to create a '^' delimited output file.  You can have this",!,"output file created as a text file in the pub directory, ",!,"OR you can have the delimited output display on your screen so that"
 W !,"you can do a file capture.  Keep in mind that if you choose to",!,"do a screen capture you CANNOT Queue your report to run in the background!!",!!
 S DIR(0)="S^S:SCREEN - delimited output will display on screen for capture;F:FILE - delimited output will be written to a file in pub",DIR("A")="Select output type",DIR("B")="S" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G DELIMIT
 S BNIGDELT=Y
 Q:BNIGDELT="S"
 S DIR(0)="F^1:40" W !,"Enter a filename for the delimited output (no more than 40 characters)"
 S DIR("A")="Filename" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G DELIMIT
 S BNIGDELF=Y
 S BNIGHDIR=$S($P($G(^AUTTSITE(1,1)),U,2)]"":$P(^AUTTSITE(1,1),U,2),1:$G(^XTV(8989.3,1,"DEV")))
 I $G(BNIGHDIR)="" S BNIGHDIR="/usr/spool/uucppublic/"
 W !!,"When the report is finished your delimited output will be found in the",!,BNIGHDIR," directory.  The filename will be ",BNIGDELF,".txt",!
 S DA=BNIGRPT,DR=".12///"_BNIGDELF,DIE="^BNIRTMP(" D ^DIE
 K DIE,DA,DR
 Q
