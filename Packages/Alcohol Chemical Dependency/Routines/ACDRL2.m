ACDRL2 ;IHS/ADC/EDE/KML - CONT OF ACDRL;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;
 ;
PMENU ;EP
 K ACDDISP,ACDSEL,ACDHIGH
 W:$D(IOF) @IOF
 S ACDLHDR="PRINT DATA ITEMS Menu" W ?((80-$L(ACDLHDR))/2),ACDLHDR,!
 W "The following data items can be printed.  You can use up to 132 characters.",!,"Choose the data items in the order you want them printed.",!
 W ?15,"Total Report width (including column margins - 2 spaces):   ",ACDTCW
 S ACDHIGH=0,X=0 F  S X=$O(^ACDTITEM(ACDXREF,X)) Q:X'=+X  S Y=$O(^ACDTITEM(ACDXREF,X,"")) I $P(^ACDTITEM(Y,0),U,5)["P",$P(^(0),U,11)[ACDPTVS S ACDHIGH=ACDHIGH+1,ACDSEL(ACDHIGH)=Y
 ;S ACDCUT=((ACDHIGH/3)+1)\1
 S ACDCUT=ACDHIGH/3 S:ACDCUT'=(ACDCUT\1) ACDCUT=(ACDCUT\1)+1
 S I=0,J=1,K=1 F  S I=$O(ACDSEL(I)) Q:I'=+I!($D(ACDDISP(I)))  D
 .W !,I,") ",$S($P(^ACDTITEM(ACDSEL(I),0),U,14)="":$E($P(^(0),U),1,20),1:$P(^(0),U,14)) S ACDDISP(I)=""
 .S J=I+ACDCUT I $D(ACDSEL(J)),'$D(ACDDISP(J)) W ?27,J,") ",$S($P(^ACDTITEM(ACDSEL(J),0),U,14)="":$E($P(^ACDTITEM(ACDSEL(J),0),U),1,20),1:$P(^(0),U,14)) S ACDDISP(J)=""
 .S K=J+ACDCUT I $D(ACDSEL(K)),'$D(ACDDISP(K)) W ?55,K,") ",$S($P(^ACDTITEM(ACDSEL(K),0),U,14)="":$E($P(^ACDTITEM(ACDSEL(K),0),U),1,20),1:$P(^(0),U,14)) S ACDDISP(K)=""
 W !?7,"<Enter a list or a range.  E.g. 1-4,5,20 or 10,12,20,30>"
 W !?7,"<<HIT RETURN to conclude selections or '^' to exit>>"
 Q
SMENU ;EP
 K ACDDISP,ACDSEL,ACDHIGH
 I $Y>(IOSL-4) W:$D(IOF) @IOF
 W !!,"The ",$S(ACDPTVS="P":"Patients",1:"records")," displayed can be selected based on any of the following criteria:",!
 S ACDHIGH=0,X=0 F  S X=$O(^ACDTITEM(ACDXREF,X)) Q:X'=+X  S Y=$O(^ACDTITEM(ACDXREF,X,"")) I $P(^ACDTITEM(Y,0),U,5)["S",$P(^(0),U,11)[ACDPTVS S ACDHIGH=ACDHIGH+1,ACDSEL(ACDHIGH)=Y
 ;S ACDCUT=((ACDHIGH/3)+1)\1
 S ACDCUT=ACDHIGH/3 S:ACDCUT'=(ACDCUT\1) ACDCUT=(ACDCUT\1)+1
 S I=0,J=1,K=1 F  S I=$O(ACDSEL(I)) Q:I'=+I!($D(ACDDISP(I)))  D
 .W !,I,") ",$E($P(^ACDTITEM(ACDSEL(I),0),U),1,23) S ACDDISP(I)=""
 .S J=I+ACDCUT I $D(ACDSEL(J)),'$D(ACDDISP(J)) W ?27,J,") ",$E($P(^ACDTITEM(ACDSEL(J),0),U),1,20) S ACDDISP(J)=""
 .S K=J+ACDCUT I $D(ACDSEL(K)),'$D(ACDDISP(K)) W ?53,K,") ",$E($P(^ACDTITEM(ACDSEL(K),0),U),1,20) S ACDDISP(K)=""
 W !!?9,"<Enter a list or a range.  E.g. 1-4,5,20 or 10,12,20,30>"
 W !?9,"<<HIT RETURN to conclude selections or bypass screens>>"
 Q
RMENU ;EP - SORT MENU
 K ACDDISP,ACDSEL,ACDHIGH
 I $Y>(IOSL-4) W:$D(IOF) @IOF
 W !!,"The ",$S(ACDPTVS="P":"Patients",1:"records")," displayed can be SORTED by any one of the following:",!
 S ACDHIGH=0,X=0 F  S X=$O(^ACDTITEM(X)) Q:X'=+X  I $P(^ACDTITEM(X,0),U,5)["R",$P(^(0),U,11)[ACDPTVS S ACDHIGH=ACDHIGH+1,ACDSEL(ACDHIGH)=X
 ;S ACDCUT=((ACDHIGH/3)+1)\1
 S ACDCUT=ACDHIGH/3 S:ACDCUT'=(ACDCUT\1) ACDCUT=(ACDCUT\1)+1
 S I=0,J=1,K=1 F  S I=$O(ACDSEL(I)) Q:I'=+I!($D(ACDDISP(I)))  D
 .W !,I,") ",$E($P(^ACDTITEM(ACDSEL(I),0),U),1,23) S ACDDISP(I)=""
 .S J=I+ACDCUT I $D(ACDSEL(J)),'$D(ACDDISP(J)) W ?27,J,") ",$E($P(^ACDTITEM(ACDSEL(J),0),U),1,20) S ACDDISP(J)=""
 .S K=J+ACDCUT I $D(ACDSEL(K)),'$D(ACDDISP(K)) W ?53,K,") ",$E($P(^ACDTITEM(ACDSEL(K),0),U),1,20) S ACDDISP(K)=""
 W !!,"<<If you don't select a sort criteria the report will be sorted by ",$S(ACDPTVS="V":"Visit date",1:"Patient"),".>>"
 Q
