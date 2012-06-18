APCLVL3 ; IHS/CMI/LAB - NO DESCRIPTION PROVIDED ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;LAB added help text to dir call
 ;
 ;
TITLE ;EP
 Q:"FTCP"[APCLCTYP
 K DIR,X,Y S DIR(0)="Y",DIR("A")="Would you like a custom title for this report",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) S APCLQUIT=1 Q
 Q:Y=0
 S APCLLENG=$S(APCLTCW:APCLTCW-8,1:60)
 I Y=1 K DIR,X,Y S DIR(0)="F^3:"_APCLLENG,DIR("A")="Enter custom title",DIR("?")="    Enter from 3 to "_APCLLENG_" characters" D ^DIR K DIR
 G:$D(DIRUT) TITLE
 S APCLTITL=Y
 S $P(^APCLVRPT(APCLRPT,13),U,3)=APCLTITL
 Q
SAVE ;EP
 Q:$D(APCLCAND)  ;--- don't ask if already a pre-defined rpt
 Q:APCLCTYP'="D"  ;--- must be a detailed report to be saved
 S APCLSAVE=""
 K DIR,X,Y S DIR(0)="Y",DIR("A")="Do you wish to SAVE this "_$S('$D(APCLEP1):"SEARCH/",1:"")_"PRINT/SORT logic for future use",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q:$D(DIRUT)
 Q:'Y
 K DIR,X,Y S DIR(0)="9001003.8,.03",DIR("A")="Enter NAME for this REPORT DEFINITION" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) SAVE
 S APCLNAME=Y
 S DIE="^APCLVRPT(",DA=APCLRPT,DR=".02////1;.03///"_APCLNAME_";.06///"_APCLPTVS_";.05///"_APCLCTYP S:$D(APCLEP1) DR=DR_";.09///"_APCLPACK D ^DIE K DIE,DA,DR
 Q
COUNT ;EP
 W !!
 S DIR(0)="S^T:Total Count Only;S:Sub-counts and Total Count;C:Cohort/Template Save;D:Detailed "_$S(APCLPTVS="V":"Visit",1:"Patient")_" Listing"_$S(APCLPTVS="V":";F:Flat file of Area Database formatted records",1:"")
 S DIR(0)=DIR(0)_$S(APCLPTVS="V":";P:Unduplicated Patient Cohort/Template",1:"")
 S DIR(0)=DIR(0)_";L:Delimited Output File for use in Excel"
 S DIR("A")="     Choose Type of Report",DIR("B")="D" D ^DIR K DIR W !!
 S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) S APCLQUIT=1 Q
 S APCLCTYP=Y
 I APCLCTYP="F" D FLAT Q:$D(APCLQUIT)  S $P(^APCLVRPT(APCLRPT,0),U,5)="F" S:APCLPTVS="V" APCLSORT=19,APCLSORV="Visit Date" Q
 I APCLCTYP="T" S $P(^APCLVRPT(APCLRPT,0),U,5)="T" S:APCLPTVS="V" APCLSORT=19,APCLSORV="Visit Date" S:APCLPTVS="P" APCLSORT=1,APCLSORV="Patient Name" Q
 I APCLCTYP="D" D PRINT Q:$D(APCLQUIT)  D SORT Q
 I APCLCTYP="C"&(APCLPTVS="P") D ^APCLSTMP G:$D(APCLQUIT) COUNT D  Q
 .S $P(^APCLVRPT(APCLRPT,0),U,5)="C"
 .S:APCLPTVS="P" APCLSORT=1,APCLSORV="Patient Name"
 I APCLCTYP="C"&(APCLPTVS="V") D ^APCLSTMV G:$D(APCLQUIT) COUNT D  Q
 .S $P(^APCLVRPT(APCLRPT,0),U,5)="C"
 .S:APCLPTVS="V" APCLSORT=19,APCLSORV="Visit Date"
 I APCLCTYP="P" D ^APCLSTMP G:$D(APCLQUIT) COUNT D  Q
 .S $P(^APCLVRPT(APCLRPT,0),U,5)="P"
 .S APCLSORT=1,APCLSORV="Patient Name"
 .Q
 I APCLCTYP="L" D  Q
 .W !!,"You have selected to create a delimited output file, you will be"
 .W !,"asked to select the print items, the sort item and then to name the"
 .W !,"output file.",!!
 .K DIR S DIR(0)="Y",DIR("A")="Do you wish to continue",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) S APCLQUIT=1 Q
 .I 'Y S APCLQUIT=1 Q
 .D PRINT Q:$D(APCLQUIT)  S $P(^APCLVRPT(APCLRPT,0),U,5)="F" D  Q:$D(APCLQUIT)
 .D SORT
 .D DELIMIT
 .I APCLDELT="" S APCLQUIT=1
 Q:$G(APCLQUIT)
 D SORT
 Q
PRINT ;
 S APCLCNTL="P"
 D ^APCLVL4
 Q
SORT ;EP
 K APCLSORT,APCLSORV,APCLQUIT
 I APCLCTYP="D"!(APCLCTYP="L"),'$D(^APCLVRPT(APCLRPT,12)) W !!,"NO PRINT FIELDS SELECTED!!",$C(7),$C(7) S APCLQUIT=1 Q
 S APCLSORT=""
 D SHOWR^APCLVLS
 S APCLCNTL="R" D ^APCLVL4 K APCLCNTL
 I '$D(APCLSORV) S APCLQUIT=1 Q
 Q:APCLCTYP'="D"
PAGE ;
 K APCLSPAG
 Q:APCLCTYP'="D"
 S DIR(0)="Y",DIR("A")="Do you want a separate page for each "_APCLSORV,DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G SORT
 S APCLSPAG=Y,DIE="^APCLVRPT(",DA=APCLRPT,DR=".04///"_APCLSPAG D ^DIE K DA,DR,DIE
 Q
FLAT ;
 S APCLOUTF="APCL"_DUZ_"."
 S X2=$E(DT,1,3)_"0101",X1=DT D ^%DTC S APCLJD=X+1
 S APCLOUTF=APCLOUTF_APCLJD
 W !!,"I am going to create a file called ",APCLOUTF," which will reside in ",!,"the ",$S($P(^AUTTSITE(1,0),U,21)=1:"/usr/spool/uucppublic",1:"C:\EXPORT")," directory.",!
 W "Actually, the file will be placed in the same directory that the data export"
 W !,"globals are placed.  See your site manager for assistance in finding the file",!,"after it is created.  PLEASE jot down and remember the following file name:",!?15,"**********    ",APCLOUTF,"    **********",!
 W "It may be several hours (or overnight) before your report and flat file are ",!,"finished.",!
 W !,"As a reminder, the records that are generated and placed in file ",APCLOUTF,!
 W !,"are in a standard, pre-defined record format.  For a definition of the format",!,"please see your user manual.",!
 S DIR(0)="Y",DIR("A")="Is everything ok?  Do you want to continue?",DIR("B")="Y" K DA D ^DIR K DIR
 I $D(DIRUT)!(Y'=1) S APCLQUIT=1 Q
 S DA=APCLRPT,DR=".12///"_APCLOUTF,DIE="^APCLVRPT(" D ^DIE
 K DIE,DA,DR
 Q
DELIMIT ;get filename for delimited output
 K APCLQUIT
 S APCLDELF="",APCLDELT=""
 W !!,"You have selected to create a '^' delimited output file.  You can have this",!,"output file created as a text file in the pub directory, ",!,"OR you can have the delimited output display on your screen so that"
 W !,"you can do a file capture.  Keep in mind that if you choose to",!,"do a screen capture you CANNOT Queue your report to run in the background!!",!!
 S DIR(0)="S^S:SCREEN - delimited output will display on screen for capture;F:FILE - delimited output will be written to a file in pub",DIR("A")="Select output type",DIR("B")="S" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) S APCLDELT="" Q
 S APCLDELT=Y
 Q:APCLDELT="S"
 S DIR(0)="F^1:40" W !,"Enter a filename for the delimited output (no more than 40 characters)"
 S DIR("A")="Filename" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G DELIMIT
 S APCLDELF=Y
 S APCLHDIR=$S($P($G(^AUTTSITE(1,1)),U,2)]"":$P(^AUTTSITE(1,1),U,2),1:$G(^XTV(8989.3,1,"DEV")))
 I $G(APCLHDIR)="" S APCLHDIR="/usr/spool/uucppublic/"
 W !!,"When the report is finished your delimited output will be found in the",!,APCLHDIR," directory.  The filename will be ",APCLDELF,".txt",!
 Q
