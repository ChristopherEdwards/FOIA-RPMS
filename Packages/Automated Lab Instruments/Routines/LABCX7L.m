LABCX7L ; IHS/DIR/FJE - ; [ 05/30/2003  4:00 PM ]
 ;;5.2;LA;**1016**;MAY 27, 2003
DOC ;Displays the CX7 download list for the CX7.
INIT S A=0,CT=0 F I=1:1 S A=$O(^LAZ(A)) Q:A=""!(A["ZZZ")  S CT=CT+1
 I CT=0 W !!,"There are NO entries in the CX7 download list." G EXIT
 I CT=1 W !!,"There is 1 entry in the CX7 download list." D ONE S ID=A D DELETE G EXIT
 W !!,"There are ",CT," entries in the CX7 download list."
 R !!,"Do you want a list?  Y// ",ANS:DTIME G:'$T EXIT W !
 I ANS["N"!(ANS["n") D LOOKUP G EXIT
LIST ;List all entries of ^LAZ(A)
 S (A,LC)=0 K IOP D ^%ZIS Q:POP  U IO I IO'=IO(0) W @IOF S Y=DT X ^DD("DD") W !!,?21,"CX7 DOWNLOAD LIST, PRINTED: ",Y,!!
A S A=$O(^LAZ(A)) I A=""!(A["ZZZ") D ^%ZISC G LOOKUP
 I IO=IO(0) S LC=LC+1 I LC>21 S LC=0 R !!,"Press any key to continue ",*AN:DTIME I AN=94 S A=0 D LOOKUP G EXIT
 S DATA=^LAZ(A,0)
 W !,?7,$S($P(DATA,",",7)="ST":"STAT",1:""),?14,A,"  ",$E($P(DATA,",",16),4,12),"  ",$P(DATA,",",13,14) ;***JPC ADDED STAT TO LIST
 G A
LOOKUP ;Look up one particular Sample Id
 R !!,"Enter the 11 digit Sample Id: ",ID:DTIME I '$T!(ID="") G EXIT
 ;I ID["?" W ! G INIT
 I ID["?" W !,"Enter Sample ID (eg. CX704230162) or LOOP",! G INIT  ;IHS/ANMC/CLS 07/12/96
 I ID="LOOP" S A=0 F I=1:1 S A=$O(^LAZ(A)) G:A=""!(A["ZZZ")!(ANS="^") INIT W !!,A," will be deleted" S ID=A D KILL
 ;I $L(ID)<11 S ID=$E(ID_"           ",1,11) ;***JPC - NO TRAILING SPACES IN KEY
 I '$D(^LAZ(ID)) W !,?14,ID," is NOT in the download list." G LOOKUP
 S DATA=^LAZ(ID,0)
 W !,?7,$S($P(DATA,",",7)="ST":"STAT",1:""),?14,ID,"  ",$E($P(DATA,",",16),4,12),"  ",$P(DATA,",",13,14) ;***JPC ADDED STAT TO LIST
 D DELETE G LOOKUP
DELETE ;Allow the user to delete the ^LAZ(ID) entry
 R !,?14,"Do you want to delete this entry?  N// ",ANS:DTIME Q:'$T
 I ANS["Y"!(ANS["y") D KILL Q
 E  W "    NO CHANGE."
 Q
KILL ;Kills ^LAZ(ID)
 W *7,!,?14,"ARE YOU SURE?  N// " R ANS:DTIME Q:'$T
 I ANS["Y"!(ANS["y") K ^LAZ(ID) W "   ",ID," HAS BEEN DELETED!!!"
 E  W "    NO CHANGE."
 Q
ONE ;automatically list the 1 entry
 S A=0,A=$O(^LAZ(A)) S DATA=$G(^(A)) W !!,?7,$S($P(DATA,",",7)="ST":"STAT",1:""),?14,A,"  ",$E($P(DATA,",",16),4,12),"  ",$P(DATA,",",13,14) ;***JPC - PRINT ENTRY AS THE OTHERS DO.
 ;JPC NOTE - START A AT BEGINNING TO INSURE GETTING CORRECT KEY. WITHOUT "S A=0", IF THERE WAS "ZZZ" ERROR ENTRY, $O WOULD PRODUCE THE "ZZZERROR" KEY AND DELETE ALL OF THE STANDARD ERROR MESSAGES
 Q
EXIT K A,AN,ANS,CT,DATA,I,ID,LC,Y Q  ;Kills variables and final exit point.
