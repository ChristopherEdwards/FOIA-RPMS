LABCX7E ; IHS/DIR/FJE - ; [ 05/30/2003  4:00 PM ]
 ;;5.2;LA;**1016**;MAY 27, 2003
DOC ;Displays the error list for the CX7.
INIT S A="",CT=0 F I=1:1 S A=$O(^LAZ("ZZZ",A)) Q:A=""  S CT=CT+1
 I CT=0 W !!,"There are NO entries in the CX7 error list." G EXIT
 I CT=1 W !!,"There is 1 entry in the CX7 error list." D ONE S ID=A D DELETE G EXIT
 W !!,"There are ",CT," entries in the CX7 error list."
 R !!,"Do you want a list?  Y// ",ANS:DTIME G:'$T EXIT W !
 I ANS["N"!(ANS["n") D LOOKUP G EXIT
LIST ;List all entries of ^LAZ("ZZZ")
 S LC=0 K IOP D ^%ZIS Q:POP  U IO I IO'=IO(0) W @IOF S Y=DT X ^DD("DD") W !!,?23,"CX7 ERROR LIST, PRINTED: ",Y,!!
A S A=$O(^LAZ("ZZZ",A)) I A="" D ^%ZISC G LOOKUP
 I IO=IO(0) S LC=LC+1 I LC>21 S LC=0 R !!,"Press any key to continue",*AN
 W !,?4,A," ... ",^LAZ("ZZZ",A)
 G A
LOOKUP ;Look up one particular Sample Id
 R !!,"Enter the 11 digit Sample Id: ",ID:DTIME I '$T!(ID="") G EXIT
 ;I ID["?" W !,"Enter Sample ID (eg. CHM04230162) or LOOP or ALL",! G INIT
 I ID["?" W !,"Enter Sample ID (eg. CX704230162) or LOOP or ALL",! G INIT  ;IHS/ANMC/CLS 07/12/96
 I ID="LOOP" S A="" F I=1:1 S A=$O(^LAZ("ZZZ",A)) G:A=""!(ANS="^") INIT W !!,A," will be deleted" S ID=A D KILL
 I ID="ALL" W !!,"All entries in the Error List will be deleted.",!,"Are you sure? N//" R ANS:DTIME G:'$T EXIT I ANS["y"!(ANS["Y") K ^LAZ("ZZZ") W !,"All entries in Error List have been deleted!" G EXIT
 I $L(ID)<11 S ID=$E(ID_"           ",1,11)
 I '$D(^LAZ("ZZZ",ID)) W !,?14,ID," is NOT in the error list." G LOOKUP
 D DELETE G LOOKUP
DELETE ;Allow the user to delete the ^LAZ("ZZZ",ID) entry
 W !,?4,ID," ... ",^LAZ("ZZZ",ID)
 R !,?14,"Do you want to delete this entry?  N// ",ANS:DTIME Q:'$T
 I ANS["Y"!(ANS["y") D KILL Q
 E  W "    NO CHANGE."
 Q
KILL ;Kills ^LAZ("ZZZ",ID)
 W *7,!,?14,"ARE YOU SURE?  N// " R ANS:DTIME Q:'$T
 I ANS["Y"!(ANS["y") K ^LAZ("ZZZ",ID) W "   ",ID," HAS BEEN DELETED!!!"
 E  W "   NO CHANGE."
 Q
ONE ;automatically list the 1 entry
 S A=$O(^LAZ("ZZZ",A)) ; W !!,?14,A," ... ",^LAZ("ZZZ",A)
 Q
EXIT K A,AN,ANS,CT,I,ID,LC,Y Q  ;Kills variables and final exit point.
