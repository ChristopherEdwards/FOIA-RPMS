ATSORT ;TUCSON/DG/INQUIRE INTO SORT TEMPLATE FILE  [ 10/25/91  1:23 PM ]
 ;;2.5;SEARCH TEMPLATE COMPARISON;;OCT 25, 1991
 ;
 S DIC="^DIBT(",DIC(0)="AEMQ",DIC("A")="Select Sort Template: " D ^DIC K DIC I Y<0 Q
 S (DA,D0)=+Y
 I $D(^DIBT(DA,1))!$D(^DIBT(DA,"O")) D SEARCH Q
 E  D SORT Q
SEARCH ;
 W:$D(IOF) @IOF W "Search Template: ",$P(^DIBT(DA,0),U)
 D DISPLAY
 I $D(^DIBT(DA,"O")) W !,"Search Specifications: " F ATSL=0:0 S ATSL=$O(^DIBT(DA,"O",ATSL)) Q:'ATSL  W:ATSL>1 ! W ?23,^DIBT(DA,"O",ATSL,0)
 I '$D(^DIBT(DA,"O")),$D(^DIBT(DA,"%D")) W !,"Search Specifications: " F ATSL=0:0 S ATSL=$O(^DIBT(DA,"%D",ATSL)) Q:'ATSL  W:ATSL>1 ! W ?23,^DIBT(DA,"%D",ATSL,0)
 K ATSL W ! S DIR("A")="Would you like to have a count of the entries in this search template",DIR(0)="YO" D ^DIR
 I Y=1 W ! S Y=DA D EN^ATSCNT
 Q
 ;
SORT ;
 W:$D(IOF) @IOF W "Sort Template: ",$P(^DIBT(DA,0),U)
 D DISPLAY
 W ! D DIBT^DIPT
 Q
 ;
DISPLAY ;
 W !,"Created By: " I +$P(^DIBT(DA,0),U,5),$D(^DIC(3,$P(^DIBT(DA,0),U,5),0)) W $P(^(0),U)
 E  W "Name Not Entered"
 W ?35,"Date: " S Y=$P(^DIBT(DA,0),U,2) X:+Y ^DD("DD") W $S(+$P(^DIBT(DA,0),U,2):Y,1:"Date Not Entered")
 I +$P(^DIBT(DA,0),U,4) W !,"File Name: ",$P(^DIC($P(^DIBT(DA,0),U,4),0),U),?35,"File Number: ",$P(^DIBT(DA,0),U,4)
 E  W !,"File Name: File Not Entered"
 Q
 ;
