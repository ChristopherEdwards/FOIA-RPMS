BCHRPT0 ; IHS/TUCSON/LAB - MENUS FOR REPORT DRIVER ;  [ 10/28/96  2:05 PM ]
 ;;1.0;IHS RPMS CHR SYSTEM;;OCT 28, 1996
 ;
PMENU ;EP
 K BCHDISP,BCHSEL,BCHHIGH
 W:$D(IOF) @IOF
 S BCHLHDR="PRINT DATA ITEMS Menu" W ?((80-$L(BCHLHDR))/2),BCHLHDR,!
 W "The following data items can be printed.  You can use up to 132 characters.",!,"Choose the data items in the order you want them printed.",!
 W ?15,"Total Report width (including column margins - 2 spaces):   ",BCHTCW
 S BCHHIGH=0,X=0 F  S X=$O(^BCHSORT("C",X)) Q:X'=+X  S Y=$O(^BCHSORT("C",X,"")) I $P(^BCHSORT(Y,0),U,5)["P",$P(^(0),U,11)["V" S BCHHIGH=BCHHIGH+1,BCHSEL(BCHHIGH)=Y
 S BCHCUT=((BCHHIGH/2)+.5)\1
 S I=0,J=1 F  S I=$O(BCHSEL(I)) Q:I'=+I  I '$D(BCHDISP(I)) D
 .W !?2,I,")  ",$P(^BCHSORT(BCHSEL(I),0),U) S BCHDISP(I)="",J=I+BCHCUT I $D(BCHSEL(J)),'$D(BCHDISP(J)) W ?40,J,")  ",$P(^BCHSORT(BCHSEL(J),0),U) S BCHDISP(J)=""
 W !?7,"<Enter a list or a range.  E.g. 1-4,5,20 or 10,12,20,30>"
 W !?7,"<<HIT RETURN to conclude selections or '^' to exit>>"
 Q
SMENU ;EP
 K BCHDISP,BCHSEL,BCHHIGH
 I $Y>(IOSL-4) W:$D(IOF) @IOF
 W !,"The records displayed can be selected based on any of the following criteria:",!
 S BCHHIGH=0,X=0 F  S X=$O(^BCHSORT(BCHXREF,X)) Q:X'=+X  S Y=$O(^BCHSORT(BCHXREF,X,"")) I $P(^BCHSORT(Y,0),U,5)["S" S BCHHIGH=BCHHIGH+1,BCHSEL(BCHHIGH)=Y
 S BCHCUT=((BCHHIGH/3)+1)\1
 S I=0,J=1,K=1 F  S I=$O(BCHSEL(I)) Q:I'=+I!($D(BCHDISP(I)))  D
  .W !,I,") ",$E($P(^BCHSORT(BCHSEL(I),0),U),1,23) S BCHDISP(I)=""
 .S J=I+BCHCUT I $D(BCHSEL(J)),'$D(BCHDISP(J)) W ?27,J,") ",$E($P(^BCHSORT(BCHSEL(J),0),U),1,22) S BCHDISP(J)=""
 .S K=J+BCHCUT I $D(BCHSEL(K)),'$D(BCHDISP(K)) W ?53,K,") ",$E($P(^BCHSORT(BCHSEL(K),0),U),1,22) S BCHDISP(K)=""
 W !?9,"<Enter a list or a range.  E.g. 1-4,5,20 or 10,12,20,30>"
 W !?9,"<<HIT RETURN to conclude selections or bypass screens>>"
 Q
RMENU ;EP - SORT MENU
 K BCHDISP,BCHSEL,BCHHIGH
 I $Y>(IOSL-4) W:$D(IOF) @IOF
 W !!,"The records displayed can be sorted by any one of the following:",!
 S BCHHIGH=0,X=0 F  S X=$O(^BCHSORT("C",X)) Q:X'=+X  S Y=$O(^BCHSORT("C",X,"")) I $P(^BCHSORT(Y,0),U,5)["R" S BCHHIGH=BCHHIGH+1,BCHSEL(BCHHIGH)=Y
 S BCHCUT=((BCHHIGH/3)+1)\1
 S I=0,J=1,K=1 F  S I=$O(BCHSEL(I)) Q:I'=+I!($D(BCHDISP(I)))  D
 .W !,I,") ",$E($P(^BCHSORT(BCHSEL(I),0),U),1,23) S BCHDISP(I)=""
 .S J=I+BCHCUT I $D(BCHSEL(J)),'$D(BCHDISP(J)) W ?27,J,") ",$E($P(^BCHSORT(BCHSEL(J),0),U),1,22) S BCHDISP(J)=""
 .S K=J+BCHCUT I $D(BCHSEL(K)),'$D(BCHDISP(K)) W ?53,K,") ",$E($P(^BCHSORT(BCHSEL(K),0),U),1,22) S BCHDISP(K)=""
 W !!,"<<If you don't select a sort criteria the report will be sorted by Record date>>"
 Q
Y ;EP
 S DIR(0)="S^1:"_BCHTEXT_";0:NO "_BCHTEXT_"",DIR("A")="Choose one",DIR("B")="1" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q:$D(DIRUT)
 Q:Y=""
 S ^BCHTRPT(BCHRPT,11,BCHCRIT,0)=BCHCRIT,^BCHTRPT(BCHRPT,11,"B",BCHCRIT,BCHCRIT)=""
 S ^BCHTRPT(BCHRPT,11,BCHCRIT,11,1,0)=Y,^BCHTRPT(BCHRPT,11,BCHCRIT,11,"B",Y,1)="",^BCHTRPT(BCHRPT,11,BCHCRIT,11,0)="^90002.42110101A^"_1_"^"_1
 Q
