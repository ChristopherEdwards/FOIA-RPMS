ACMLTR2 ; IHS/TUCSON/TMJ - RECALL LETTER..FORMAT EDIT & DISPLAY ;
 ;;2.0;ACM CASE MANAGEMENT SYSTEM;;JAN 10, 1996
 ;;DISPLAY OF RECALL LETTER SAMPLE AND/OR EDIT OF LETTER FORMAT
 ;
 ;EP;ENTRY POINT
START ;
 D HEAD^ACMMENU
 W !!!!
 ;
 W ?12,"****************************************************",!
 W ?15,"A sample of the Recall Letter will be displayed.",!,?15,"You will also be asked if you want to modify the",!,?15,"letter format and/or the additional text field."
 W !,?12,"*****************************************************",!
 W !,"Enter a DEVICE Number or Hit Return to display to Screen",!
 D SAMPLE
 ;
 ;
HEAD ;
 W !!!
 W ?15,"***********************************************",!
 W !,?15,"You may also EDIT the Standard Letter format -",!
 W ?15,"OR the additional Word Processing Text Paragraph?",!
 W ?15,"************************************************",!
 ;
ASK ;
 S DIR(0)="Y",DIR("A")="Do you wish to EDIT the letter format",DIR("?")="Enter 'Y' for Yes or 'N' for NO",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G PRNTLTR
 I Y=0 G PRNTLTR
 S ACMRG=ACMRG
 S DIE="^ACM(41.1,",DR="[ACM LETTER SETUP]"
 S DA=ACMRG
 D DIE K DIC,DIE,DA
 ;
ASK2 ;
 W !!
 S DIR(0)="Y",DIR("A")="Do you wish to display the Sample Letter again",DIR("?")="Enter 'Y' for Yes or 'N' for NO",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G PRNTLTR
 I Y=1 W !! D SAMPLE
 ;
 ;
PRNTLTR ;
 D HEAD^ACMMENU
 S ACMLTREX=0
 W !!!
 S DIR(0)="Y",DIR("A")="Do you want to print the final letter now",DIR("?")="Enter 'Y' for Yes or 'N' for NO",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) S ACMLTREX=1 G EXIT
 I Y=0 S ACMLTREX=1 G EXIT
 Q
SAMPLE ;
 ;
 S DIC="^ACM(41.1,",FLDS="[ACM RECALL LETTER SAMPLE]",BY="@NUMBER",FR=ACMRG,TO=ACMRG,DHD="@" D DIP
 Q
 ;
DIP ;
 D EN1^DIP Q
DIE ;
 D ^DIE K DIC,DIE,DA Q
 ;
EXIT ;
 Q
