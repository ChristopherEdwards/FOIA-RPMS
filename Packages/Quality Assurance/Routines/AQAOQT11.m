AQAOQT11 ; IHS/ORDC/LJF - BRAINSTORMING SUBRTNS ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contians entry points to handle the code for the actual
 ;brainstorming function.
 ;
IDEAS ;ENTRY POINT >> SUBRTN to loop through entering ideas <<
 ;called by ^AQAOQT1
 W !! K DIR S DIR(0)="FO^3:50",DIR("A")="Enter IDEA" D ^DIR Q:$D(DIRUT)
 K DD,DO,DIC,DIE S DIC="^AQAO1(7,",DIC(0)="AEMZLQ",X=Y
 S DIC("DR")=".02////"_AQAOMTG D FILE^DICN W "  Entered.." G IDEAS
 ; >> END OF IDEAS SUBRTN <<
 ;
 ;
LIST ;ENTRY POINT >> SUBRTN to list ideas entered for this meeting <<
 ;called by ^AQAOQT1
 W !!,"IDEAS ENTERED FOR ",$P(^AQAO1(8,AQAOMTG,0),U,3),":",!
 S AQAOX=0,AQAOJ=1
MORE F AQAOI=AQAOJ:1:AQAOJ+12 S AQAOX=$O(^AQAO1(7,"AC",AQAOMTG,AQAOX)) Q:AQAOX=""  D
 .W !?5,AQAOI_". "_$P(^AQAO1(7,AQAOX,0),U),?40,$P(^(0),U,3)
 S AQAOJ=AQAOI+1 Q:AQAOX=""  ;end of list
 K DIR S DIR("A")="Press RETURN to continue or ""^"" to exit"
 S DIR(0)="E" D ^DIR G MORE:Y=1
 Q
 ; >> END OF LIST SUBRTN <<
 ;
 ;
CATEGORY ;ENTRY POINT >> SUBRTN to categorize ideas entered <<
 ;called by ^AQAOQT1
 I '$O(^AQAO1(7,"AC",AQAOMTG,0)) D  G BRAIN^AQAOQT1
 .W !!,"NO IDEAS ENTERED!",!!
 W !!?20,"*** CATEGORIZE IDEAS ***",!!
 ; >> loop and display 20 ideas at a time and select range to group
 S AQAOX=0 K DIR S AQAOJ=1,AQAOK=AQAOJ+12
LOOP F AQAOI=AQAOJ:1:AQAOK S AQAOX=$O(^AQAO1(7,"AC",AQAOMTG,AQAOX)) Q:AQAOX=""  D
 .S AQAOARR(AQAOI)=AQAOX,X="     "
 .S DIR("A",AQAOI)=AQAOI_". "_$P(^AQAO1(7,AQAOX,0),U)_X_$P(^(0),U,3)
 S AQAOJ=AQAOI+1,AQAOK=AQAOJ+12
 I AQAOX=""!'$O(^AQAO1(7,"AC",AQAOMTG,AQAOX)) D
 .S DIR("A")="Select IDEAS to group together"
 .S DIR(0)="LO^1:"_(AQAOI-1)_"^K:X#1 X"
 E  D
 .S DIR(0)="LO^1:"_AQAOI_"^K:X#1 X"
 .S DIR("A")="Select IDEAS to group together OR hit RETURN to list more ideas"
 S DIR("?",1)="You may select a RANGE such as 1,3,7 or 2-5."
 S DIR("?",2)="OR hit RETURN to see list again,"
 S DIR("?",3)="OR enter ""^"" to exit.",DIR("?")=" "
 D ^DIR I X="",AQAOX'="" W !! K DIR G LOOP
 Q:$D(DIRUT)  Q:Y=-1  S AQAORNG=Y
 ;
 ; >> ask for category and flag each idea with that category
 W !! K DIR S DIR(0)="F^3:50",DIR("A")="CATEGORY" D ^DIR
 G CATEGORY:X=U,CATEGORY:Y=-1 Q:$D(DIRUT)  S AQAOCAT=Y
 K DIE S DIE="^AQAO1(7,",DR=".03////"_AQAOCAT
 F AQAOK=1:1 S DA=$P(AQAORNG,",",AQAOK) Q:DA=""  D
 .S DA=AQAOARR(DA) D ^DIE W ".."
 G CATEGORY
 ; >> END OF CATEGORY SUBRTN <<
 ;
 ;
EDIT ;ENTRY POINT >> SUBRTN to edit or delete ideas <<
 ;called by AQAOQT1
 K DIE,DIC S (DIE,DIC)=9002169.7,DIC(0)="AEMZQ"
 S DIC("S")="I $P(^(0),U,2)=AQAOMTG" D ^DIC
 Q:Y=-1  S DA=+Y,DR=".01",DIDEL=9002169.7 D ^DIE G EDIT
 ; >> END OF EDIT SUBRTN <<
