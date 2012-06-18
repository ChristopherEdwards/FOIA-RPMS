ACMRL2 ; IHS/TUCSON/TMJ - CONT OF ACMRL ; [ 06/01/1999  1:37 PM ]
 ;;2.0;ACM CASE MANAGEMENT SYSTEM;**1**;JAN 10, 1996
 ;IHS/CMI/LAB - patch 1 - flat file, tmp to xtmp
 ;
 ;
PMENU ;EP
 K ACMDISP,ACMSEL,ACMHIGH
 W:$D(IOF) @IOF
 W !,"REGISTER:  ",$P(^ACM(41.1,ACMRG,0),U),"     USER:  ",$E($P(^VA(200,DUZ,0),U),1,15),!
 S ACMLHDR="PRINT Data Items Menu" W ?((80-$L(ACMLHDR))/2),ACMLHDR,!
 I ACMCTYP="P" W "The following data items can be printed.  You can use up to 132 characters.",!,"Choose the data items in the order you want them printed.",! ;IHS/CMI/LAB
 I ACMCTYP="F" W "The following data items can be selected to be output to a '^' delimited file.",!,"Choose the data items in the order you want them to be output.",! ;IHS/CMI/LAB
 I ACMCTYP="P" W ?15,"Total Report width (including column margins - 2 spaces):   ",ACMTCW
 S ACMHIGH=0,X=0 F  S X=$O(^ACM(58.1,"C",X)) Q:X'=+X  S Y=$O(^ACM(58.1,"C",X,"")) D
 .I $P(^ACM(58.1,Y,0),U,5)'["P" Q
 .I $P(^ACM(58.1,Y,0),U,11)]"",ACMCTRLP'[$P(^(0),U,11) Q
 .I $P(^ACM(58.1,Y,0),U,8),ACMCTYP="F" Q  ;IHS/CMI/LAB - no mult valued items for now
 .S ACMHIGH=ACMHIGH+1,ACMSEL(ACMHIGH)=Y
 .Q
 S ACMCUT=((ACMHIGH/3)+1)\1
 S I=0,J=1,K=1 F  S I=$O(ACMSEL(I)) Q:I'=+I!($D(ACMDISP(I)))  D
 .W !,I,")  ",$S($P(^ACM(58.1,ACMSEL(I),0),U,12)="":$E($P(^(0),U),1,20),1:$P(^(0),U,12)) S ACMDISP(I)=""
 .S J=I+ACMCUT I $D(ACMSEL(J)),'$D(ACMDISP(J)) W ?26,J,")  ",$S($P(^ACM(58.1,ACMSEL(J),0),U,12)="":$E($P(^ACM(58.1,ACMSEL(J),0),U),1,20),1:$P(^(0),U,12)) S ACMDISP(J)=""
 .S K=J+ACMCUT I $D(ACMSEL(K)),'$D(ACMDISP(K)) W ?53,K,")  ",$S($P(^ACM(58.1,ACMSEL(K),0),U,12)="":$E($P(^ACM(58.1,ACMSEL(K),0),U),1,20),1:$P(^(0),U,12)) S ACMDISP(K)=""
 W !?7,"<Enter a list or a range.  E.g. 1-4,5,18 or 10,12,18,30>"
 W !?7,"<<HIT RETURN to conclude selections or '^' to exit>>"
 Q
SMENU ;EP
 K ACMDISP,ACMSEL,ACMHIGH
 I $Y>(IOSL-4) W:$D(IOF) @IOF
 W:$D(IOF) @IOF
 W !,"REGISTER:  ",$P(^ACM(41.1,ACMRG,0),U),"     USER:  ",$E($P(^VA(200,DUZ,0),U),1,15)
 W !!,"The Patients displayed can be SEARCHED based on any of the following criteria:",!
 S ACMHIGH=0,X=0 F  S X=$O(^ACM(58.1,"C",X)) Q:X'=+X  S Y=$O(^ACM(58.1,"C",X,"")) D
 .I $P(^ACM(58.1,Y,0),U,5)'["S" Q
 .I $P(^ACM(58.1,Y,0),U,11)]"",ACMCTRLP'[$P(^(0),U,11) Q
 .S ACMHIGH=ACMHIGH+1,ACMSEL(ACMHIGH)=Y
 .Q
 S ACMCUT=((ACMHIGH/3)+1)\1
 S I=0,J=1,K=1 F  S I=$O(ACMSEL(I)) Q:I'=+I!($D(ACMDISP(I)))  D
 .W !,I,")  ",$S($P(^ACM(58.1,ACMSEL(I),0),U,12)="":$E($P(^(0),U),1,20),1:$P(^(0),U,12)) S ACMDISP(I)=""
 .S J=I+ACMCUT I $D(ACMSEL(J)),'$D(ACMDISP(J)) W ?28,J,")  ",$S($P(^ACM(58.1,ACMSEL(J),0),U,12)="":$E($P(^ACM(58.1,ACMSEL(J),0),U),1,20),1:$P(^(0),U,12)) S ACMDISP(J)=""
 .S K=J+ACMCUT I $D(ACMSEL(K)),'$D(ACMDISP(K)) W ?55,K,")  ",$S($P(^ACM(58.1,ACMSEL(K),0),U,12)="":$E($P(^ACM(58.1,ACMSEL(K),0),U),1,20),1:$P(^(0),U,12)) S ACMDISP(K)=""
 W !!?9,"<Enter a list or a range.  E.g. 1-4,5,20 or 10,12,20,30>"
 W !?9,"<<HIT RETURN to conclude selections or bypass screens>>"
 Q
RMENU ;EP - SORT MENU
 K ACMDISP,ACMSEL,ACMHIGH
 W:$D(IOF) @IOF
 W !,"REGISTER:  ",$P(^ACM(41.1,ACMRG,0),U),"     USER:  ",$E($P(^VA(200,DUZ,0),U),1,15)
 W !!,"The Patients displayed can be SORTED by any one of the following:",!
 S ACMHIGH=0,X=0 F  S X=$O(^ACM(58.1,X)) Q:X'=+X  I $P(^ACM(58.1,X,0),U,5)["R" S ACMHIGH=ACMHIGH+1,ACMSEL(ACMHIGH)=X
 S ACMCUT=((ACMHIGH/2)+1)\1
 S I=0,J=1,K=1 F  S I=$O(ACMSEL(I)) Q:I'=+I!($D(ACMDISP(I)))  W !?5,I,")  ",$P(^ACM(58.1,ACMSEL(I),0),U) S ACMDISP(I)="",J=I+ACMCUT I $D(ACMSEL(J)),'$D(ACMDISP(J)) W ?40,J,")  ",$P(^ACM(58.1,ACMSEL(J),0),U) S ACMDISP(J)=""
 W !!,"<<If you don't select a sort criteria the report will be sorted by Patient Name.>>"
 Q
