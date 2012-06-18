BCHRL2 ; IHS/TUCSON/LAB -CONT OF BCHRL ;  [ 08/31/02  1:00 PM ]
 ;;1.0;IHS RPMS CHR SYSTEM;**14**;OCT 28, 1996
 ;
 ;
PMENU ;EP
 K BCHDISP,BCHSEL,BCHHIGH
 W:$D(IOF) @IOF
 S BCHLHDR="PRINT DATA ITEMS Menu" W ?((80-$L(BCHLHDR))/2),BCHLHDR,!
 W "The following data items can be printed.  You can use up to 132 characters.",!,"Choose the data items in the order you want them printed.",!
 W ?15,"Total Report width (including column margins - 2 spaces):   ",BCHTCW
 S BCHHIGH=0,X=0 F  S X=$O(^BCHSORT(BCHXREF,X)) Q:X'=+X  S Y=$O(^BCHSORT(BCHXREF,X,"")) I $P(^BCHSORT(Y,0),U,5)["P" S BCHHIGH=BCHHIGH+1,BCHSEL(BCHHIGH)=Y
 S BCHCUT=((BCHHIGH/3)+1)\1
 S I=0,J=1,K=1 F  S I=$O(BCHSEL(I)) Q:I'=+I!($D(BCHDISP(I)))  D
 .W !,I,") ",$S($P(^BCHSORT(BCHSEL(I),0),U,14)="":$E($P(^(0),U),1,20),1:$P(^(0),U,14)) S BCHDISP(I)=""
 .S J=I+BCHCUT I $D(BCHSEL(J)),'$D(BCHDISP(J)) W ?27,J,") ",$S($P(^BCHSORT(BCHSEL(J),0),U,14)="":$E($P(^BCHSORT(BCHSEL(J),0),U),1,20),1:$P(^(0),U,14)) S BCHDISP(J)=""
 .S K=J+BCHCUT I $D(BCHSEL(K)),'$D(BCHDISP(K)) W ?55,K,") ",$S($P(^BCHSORT(BCHSEL(K),0),U,14)="":$E($P(^BCHSORT(BCHSEL(K),0),U),1,20),1:$P(^(0),U,14)) S BCHDISP(K)=""
 W !?7,"<Enter a list or a range.  E.g. 1-4,5,20 or 10,12,20,30>"
 W !?7,"<<PRESS Enter to conclude selections or '^' to exit>>"
 Q
SMENU ;EP
 K BCHDISP,BCHSEL,BCHHIGH
 I $Y>(IOSL-4) W:$D(IOF) @IOF
 W !!,"The ",$S(BCHPTVS="P":"Patients",1:"records")," displayed can be selected based on any of the following criteria:",!
 S BCHHIGH=0,X=0 F  S X=$O(^BCHSORT(BCHXREF,X)) Q:X'=+X  S Y=$O(^BCHSORT(BCHXREF,X,"")) I $P(^BCHSORT(Y,0),U,5)["S" S BCHHIGH=BCHHIGH+1,BCHSEL(BCHHIGH)=Y
 S BCHCUT=((BCHHIGH/3)+1)\1
 S I=0,J=1,K=1 F  S I=$O(BCHSEL(I)) Q:I'=+I!($D(BCHDISP(I)))  D
  .W !,I,") ",$E($P(^BCHSORT(BCHSEL(I),0),U),1,23) S BCHDISP(I)=""
 .S J=I+BCHCUT I $D(BCHSEL(J)),'$D(BCHDISP(J)) W ?27,J,") ",$E($P(^BCHSORT(BCHSEL(J),0),U),1,20) S BCHDISP(J)=""
 .S K=J+BCHCUT I $D(BCHSEL(K)),'$D(BCHDISP(K)) W ?53,K,") ",$E($P(^BCHSORT(BCHSEL(K),0),U),1,20) S BCHDISP(K)=""
 W !!?9,"<Enter a list or a range.  E.g. 1-4,5,20 or 10,12,20,30>"
 W !?9,"<<PRESS Enter to conclude selections or bypass screens>>"
 Q
RMENU ;EP - SORT MENU
 K BCHDISP,BCHSEL,BCHHIGH
 I $Y>(IOSL-4) W:$D(IOF) @IOF
 W !!,"The ",$S(BCHPTVS="P":"Patients",1:"records")," displayed can be SORTED by any one of the following:",!
 S BCHHIGH=0,X=0 F  S X=$O(^BCHSORT(X)) Q:X'=+X  I $P(^BCHSORT(X,0),U,5)["R" S BCHHIGH=BCHHIGH+1,BCHSEL(BCHHIGH)=X
 S BCHCUT=((BCHHIGH/2)+1)\1
 S I=0,J=1,K=1 F  S I=$O(BCHSEL(I)) Q:I'=+I!($D(BCHDISP(I)))  W !?5,I,") ",$P(^BCHSORT(BCHSEL(I),0),U) S BCHDISP(I)="",J=I+BCHCUT I $D(BCHSEL(J)),'$D(BCHDISP(J)) W ?40,J,") ",$P(^BCHSORT(BCHSEL(J),0),U) S BCHDISP(J)=""
 W !!,"<<If you don't select a sort criteria the report will be sorted by ",$S(BCHPTVS="V":"Date",1:"Patient"),".>>"
 Q
