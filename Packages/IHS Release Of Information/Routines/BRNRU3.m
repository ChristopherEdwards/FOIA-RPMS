BRNRU3 ; IHS/OIT/LJF - MISC REPORT LOGIC
 ;;2.0;RELEASE OF INFO SYSTEM;*1*;APR 10, 2003
 ;IHS/OIT/LJF 10/25/2007 PATCH 1 Added routine
 ;
 ;
TITLE ;EP; Custom Title for report
 NEW Y,LENGTH,TITLE,DIE,DA,DR
 Q:"FTCP"[BRNCTYP
 S Y=$$READ^BRNU("Y","Would you like a custom title for this report","NO") Q:Y=0
 I Y=U S BRNQUIT=1 Q
 S LENGTH=$S(BRNTCW:BRNTCW-8,1:60)
 S TITLE=$$READ^BRNU("F^3:"_LENGTH,"Enter custom title",,"    Enter from 3 to "_LENGTH_" characters")
 I (Y=U)!(Y="") D TITLE Q
 S DIE=90264.8,DA=BRNRPT,DR="1303///"_TITLE D ^DIE
 Q
 ;
SAVE ;EP; Ask user to save report logic
 Q:$D(BRNCAND)    ;--- don't ask if already a pre-defined rpt
 Q:BRNCTYP'="D"   ;--- must be a detailed report to be saved
 Q:'$$READ^BRNU("Y","Do you wish to SAVE this SEARCH/PRINT/SORT logic for future use","NO")
 ;
 NEW NAME,DIE,DR,DA
 S NAME=$$READ^BRNU("90264.8,.03","Enter NAME for this REPORT DEFINITION") Q:$L(NAME)<3
 S DIE="^BRNRPT(",DA=BRNRPT,DR=".02////1;.03///"_NAME_";.05///"_BRNCTYP D ^DIE
 Q
 ;
COUNT ;EP; Counts and Subcount logic
 W !!
 S DIR(0)="S^T:Total Count Only;S:Sub-counts and Total Count;D:Detailed Listing;L:Delimited Output File for use in Excel"
 S DIR("A")="     Choose Type of Report",DIR("B")="D" D ^DIR K DIR W !!
 S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) S BRNQUIT=1 Q
 S BRNCTYP=Y
 I BRNCTYP="T" S $P(^BRNRPT(BRNRPT,0),U,5)="T" S BRNSORT=1,BRNSORV="Patient Name" Q
 I BRNCTYP="D" D PRINT Q:$D(BRNQUIT)  D SORT Q
 I BRNCTYP="L" D  Q
 .W !!,"You have selected to create a delimited output file, you will be"
 .W !,"asked to select the print items, the sort item and then to name the"
 .W !,"output file.",!!
 .K DIR S DIR(0)="Y",DIR("A")="Do you wish to continue",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) S BRNQUIT=1 Q
 .I 'Y S BRNQUIT=1 Q
 .D PRINT Q:$D(BRNQUIT)  S $P(^BRNRPT(BRNRPT,0),U,5)="F" D  Q:$D(BRNQUIT)
 .D SORT
 .D DELIMIT
 .I BRNDELT="" S BRNQUIT=1
 Q:$G(BRNQUIT)
 D SORT
 Q
 ;
PRINT ;
 S BRNCNTL="P"
 D ^BRNRU2
 Q
 ;
SORT ;EP
 K BRNSORT,BRNSORV,BRNQUIT
 I BRNCTYP="D"!(BRNCTYP="L"),'$D(^BRNRPT(BRNRPT,12)) W !!,"NO PRINT FIELDS SELECTED!!",$C(7),$C(7) S BRNQUIT=1 Q
 S BRNSORT=""
 D SHOWR^BRNRUS
 S BRNCNTL="R" D ^BRNRU2 K BRNCNTL
 I '$D(BRNSORV) S BRNQUIT=1 Q
 Q:BRNCTYP'="D"
PAGE ;
 K BRNSPAG
 Q:BRNCTYP'="D"
 S DIR(0)="Y",DIR("A")="Do you want a separate page for each "_BRNSORV,DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G SORT
 S BRNSPAG=Y,DIE="^BRNRPT(",DA=BRNRPT,DR=".04///"_BRNSPAG D ^DIE K DA,DR,DIE
 Q
 ;
DELIMIT ;get filename for delimited output
 K BRNQUIT
 S BRNDELF="",BRNDELT=""
 W !!,"You have selected to create a '^' delimited output file.  You can have this"
 W !,"output file created as a text file in the pub directory, "
 W !,"OR you can have the delimited output display on your screen so that"
 W !,"you can do a file capture.  Keep in mind that if you choose to"
 W !,"do a screen capture you CANNOT Queue your report to run in the background!!",!!
 S DIR(0)="S^S:SCREEN - delimited output will display on screen for capture;F:FILE - delimited output will be written to a file in pub"
 S DIR("A")="Select output type",DIR("B")="S" KILL DA
 D ^DIR KILL DIR
 I $D(DIRUT) S BRNDELT="" Q
 S BRNDELT=Y
 Q:BRNDELT="S"
 S DIR(0)="F^1:40" W !,"Enter a filename for the delimited output (no more than 40 characters)"
 S DIR("A")="Filename" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G DELIMIT
 S BRNDELF=Y
 S BRNHDIR=$S($P($G(^AUTTSITE(1,1)),U,2)]"":$P(^AUTTSITE(1,1),U,2),1:$G(^XTV(8989.3,1,"DEV")))
 I $G(BRNHDIR)="" S BRNHDIR="/usr/spool/uucppublic/"
 W !!,"When the report is finished your delimited output will be found in the",!,BRNHDIR," directory.  The filename will be ",BRNDELF,".txt",!
 Q
