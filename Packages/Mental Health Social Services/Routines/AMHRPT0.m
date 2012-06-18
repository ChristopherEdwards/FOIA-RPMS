AMHRPT0 ; IHS/CMI/LAB - MENUS FOR REPORT DRIVER ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
PMENU ;EP
 K AMHDISP,AMHSEL,AMHHIGH
 W:$D(IOF) @IOF
 S AMHLHDR="PRINT DATA ITEMS Menu" W ?((80-$L(AMHLHDR))/2),AMHLHDR,!
 W "The following data items can be printed.  You can use up to 132 characters.",!,"Choose the data items in the order you want them printed.",!
 W ?15,"Total Report width (including column margins - 2 spaces):   ",AMHTCW
 S AMHHIGH=0,X=0 F  S X=$O(^AMHSORT("C",X)) Q:X'=+X  S Y=$O(^AMHSORT("C",X,"")) I $P(^AMHSORT(Y,0),U,5)["P",$P(^(0),U,11)["V" S AMHHIGH=AMHHIGH+1,AMHSEL(AMHHIGH)=Y
 S AMHCUT=((AMHHIGH/2)+.5)\1
 S I=0,J=1 F  S I=$O(AMHSEL(I)) Q:I'=+I  I '$D(AMHDISP(I)) D
 .W !?2,I,")  ",$P(^AMHSORT(AMHSEL(I),0),U) S AMHDISP(I)="",J=I+AMHCUT I $D(AMHSEL(J)),'$D(AMHDISP(J)) W ?40,J,")  ",$P(^AMHSORT(AMHSEL(J),0),U) S AMHDISP(J)=""
 W !?7,"<Enter a list or a range.  E.g. 1-4,5,20 or 10,12,20,30>"
 W !?7,"<<PRESS ENTER to conclude selections or '^' to exit>>"
 Q
SMENU ;EP
 K AMHDISP,AMHSEL,AMHHIGH
 I $Y>(IOSL-4) W:$D(IOF) @IOF
 W !,"The records displayed can be selected based on any of the following criteria:",!
 S AMHHIGH=0,X=0 F  S X=$O(^AMHSORT(AMHXREF,X)) Q:X'=+X  S Y=$O(^AMHSORT(AMHXREF,X,"")) I $P(^AMHSORT(Y,0),U,5)["S",$P(^(0),U,11)[AMHPTVS S AMHHIGH=AMHHIGH+1,AMHSEL(AMHHIGH)=Y
 S AMHCUT=((AMHHIGH/3)+1)\1
 S I=0,J=1,K=1 F  S I=$O(AMHSEL(I)) Q:I'=+I!($D(AMHDISP(I)))  D
  .W !,I,") ",$E($P(^AMHSORT(AMHSEL(I),0),U),1,23) S AMHDISP(I)=""
 .S J=I+AMHCUT I $D(AMHSEL(J)),'$D(AMHDISP(J)) W ?27,J,") ",$E($P(^AMHSORT(AMHSEL(J),0),U),1,22) S AMHDISP(J)=""
 .S K=J+AMHCUT I $D(AMHSEL(K)),'$D(AMHDISP(K)) W ?53,K,") ",$E($P(^AMHSORT(AMHSEL(K),0),U),1,22) S AMHDISP(K)=""
 W !?9,"<Enter a list or a range.  E.g. 1-4,5,20 or 10,12,20,30>"
 W !?9,"<<PRESS ENTER to conclude selections or bypass screens>>"
 Q
RMENU ;EP - SORT MENU
 K AMHDISP,AMHSEL,AMHHIGH
 I $Y>(IOSL-4) W:$D(IOF) @IOF
 W !!,"The records displayed can be sorted by any one of the following:",!
 S AMHHIGH=0,X=0 F  S X=$O(^AMHSORT("C",X)) Q:X'=+X  S Y=$O(^AMHSORT("C",X,"")) I $P(^AMHSORT(Y,0),U,5)["R",$P(^(0),U,11)["V" S AMHHIGH=AMHHIGH+1,AMHSEL(AMHHIGH)=Y
 S AMHCUT=((AMHHIGH/2)+.5)\1
 S I=0,J=1,K=1 F  S I=$O(AMHSEL(I)) Q:I'=+I  I '$D(AMHDISP(I)) W !?5,I,")  ",$P(^AMHSORT(AMHSEL(I),0),U) S AMHDISP(I)="",J=I+AMHCUT I $D(AMHSEL(J)),'$D(AMHDISP(J)) W ?40,J,")  ",$P(^AMHSORT(AMHSEL(J),0),U) S AMHDISP(J)=""
 W !!,"<<If you don't select a sort criteria the report will be sorted by Visit date>>"
 Q
 ;
N ;EP
 K ^AMHTRPT(AMHRPT,11,AMHCRIT),^AMHTRPT(AMHRPT,11,"B",AMHCRIT)
 S DIR(0)="FO^1:7",DIR("A")="Enter a Range for "_$P(^AMHSORT(AMHCRIT,0),U)_", (e.g. 5-12)" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !!,"No number range entered.  All numbers will be included." Q
 I Y'?.N1"-".N W !!,$C(7),$C(7),"Enter an number range in the format nnn-nnn.  E.g. 0-5, 0-99, 5-20." G N
 S ^AMHTRPT(AMHRPT,11,AMHCRIT,0)=AMHCRIT,^AMHTRPT(AMHRPT,11,"B",AMHCRIT,AMHCRIT)=""
 S AMHCNT=0,^AMHTRPT(AMHRPT,11,AMHCRIT,11,AMHCNT,0)="^9002013.8110101A^1^1" F X=$P(Y,"-"):1:$P(Y,"-",2) S AMHCNT=AMHCNT+1,^AMHTRPT(AMHRPT,11,AMHCRIT,11,1,0)=X,^AMHTRPT(AMHRPT,11,AMHCRIT,11,"B",X,AMHCNT)=""
 Q
Y ;EP
 S DIR(0)="S^1:"_AMHTEXT_";0:NO "_AMHTEXT_"",DIR("A")="Choose one",DIR("B")="1" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q:$D(DIRUT)
 Q:Y=""
 S ^AMHTRPT(AMHRPT,11,AMHCRIT,0)=AMHCRIT,^AMHTRPT(AMHRPT,11,"B",AMHCRIT,AMHCRIT)=""
 S ^AMHTRPT(AMHRPT,11,AMHCRIT,11,1,0)=Y,^AMHTRPT(AMHRPT,11,AMHCRIT,11,"B",Y,1)="",^AMHTRPT(AMHRPT,11,AMHCRIT,11,0)="^9001003.8110101A^"_1_"^"_1
 Q
