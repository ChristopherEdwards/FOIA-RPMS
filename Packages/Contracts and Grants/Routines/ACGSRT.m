ACGSRT ;IHS/OIRM/DSD/THL,AEF - SORT CONTROLLER FOR REPORTS; [ 03/27/2000   2:22 PM ]
 ;;2.0t1;CONTRACT INFORMATION SYSTEM;;FEB 16, 2000
 ;;SORT CONTROLLER FOR REPORTS
EN K ACGQUIT,ACGXZ
 D ^ACGSRT2
 Q:$D(ACGQUIT)
EN1 D HEAD,CHOICE,EXIT Q
HEAD D HEAD^ACGSMENU S ACGX="REPORT SORTING UTILITY"
 W !!?80-$L(ACGX)\2,ACGX,!!?10,"The ",@ACGON,ACGRPT,@ACGOF," report can be sorted by one or more",!?10,"of the following attributes.  '<==' indicates a mandatory selection.",! K ACGX,ACGFORC
 Q
SORT W !!?10,"Sorting by: " S ACGXZZ=$O(ACGXZ(0)) Q:'ACGXZZ  W ACGXZ(ACGXZZ) F  S ACGXZZ=$O(ACGXZ(ACGXZZ)) Q:'ACGXZZ  W !?16,"then: ",ACGXZ(ACGXZZ)
 Q
CHOICE D M2 I $D(ACGXZ) D SORT
 S DIR(0)="NOA^1:"_ACGJ,DIR("A")="          Your choice (1"_$S((ACGJ)>1:"-"_(ACGJ),1:"")_"): ",DIR("?")="Type "_$S((ACGJ)>1:"a number from 1",1:"number 1: ")_$S((ACGJ)>1:"-"_(ACGJ)_":",1:"")
 W !
 D DIR^ACGSDIC
 Q:$D(ACGQUIT)!(Y<1)
 S ACGZZ=+Y
 I '$D(ACGUB(ACGZZ)) W !!?10,ACGZZ," has already been processed.",!! G CHOICE
 G:'ACGZZ CHOICE
OK S:'$D(ACGXZ) ACGXZ=0 S ACGYZ=ACGU(ACGZZ),(X,ACGSNO)=+ACGYZ,ACGSNA=$P(ACGYZ,U,2),ACGCSTG=ACGCSTG_ACGZZ_U S ACGXZ(ACGXZ+1)=ACGSNA,ACGXZ=ACGXZ+1
 ;ACGXZ_$S(ACGXZ'="":", then ",1:"")_
 K ACGYZ W "   ",ACGSNA
OK1 I BY'="" S BY=BY_","
 S ACGNAV=^ACGSRT(X,0)
 K ACGJ
 S ACGBY=^ACGSRT(X,3)
 D @("S"_$P(ACGNAV,U,2)_"^ACGSRT1")
 K ACGNAV
 I $D(ACGQUIT) Q
 I $D(ACGFORC) K ACGFORC D PRINT Q
 I ACGYI<2 S BY=BY_ACGBY D PRINT Q
 G:'$D(ACGBY) EN1
 S ACGUB(ACGZZ)=1
 I ACGBY="" K ACGXZ(ACGXZ) G EN1
 S BY=BY_ACGBY
 I BY[26 D PRINT Q
 W !!,"Within ",ACGSNA,", want to sort by another attribute"
 S %=2 D YN^DICN
 I %Y=U S ACGQUIT="" Q
 I "Nn"[$E(%Y) D CHECK G:$D(ACGFORC) OK D PRINT Q
 G EN1
EXIT D EXIT^ACGSRT1 Q
M2 K ACGU S ACGZ=0
 S ACGJJ=(ACGYI\2)+(ACGYI#2)
 F ACGJ=1:1:ACGJJ D
 .I $D(ACGUB(ACGJ)) S (ACGU(ACGJ),ACGSRT)=ACGUB(ACGJ),X=$P(ACGSRT,U,2),Y=$P(ACGSRT,U),ACGYZ=$P(ACGSRT,U,3) W !?8,$J(ACGJ,3),") " W:ACGUB(ACGJ)'=1 X I ACGYZ W " <==" S ACGMAND=ACGJ,ACGMANN=X,ACGMAN=Y_U_X
 .I $D(ACGUB(ACGJ+ACGJJ)) S (ACGU(ACGJ+ACGJJ),ACGSRT)=ACGUB(ACGJ+ACGJJ),X=$P(ACGSRT,U,2),Y=$P(ACGSRT,U),ACGYZ=$P(ACGSRT,U,3) W ?45 W $J(ACGJ+ACGJJ,3),") " W:ACGUB(ACGJ+ACGJJ)'=1 X I ACGYZ W " <==" S ACGMAND=ACGJ+ACGJJ,ACGMANN=X,ACGMAN=Y_U_X
 S ACGJ=ACGYI
 K ACGSRT,ACGZ,ACGYZ
 Q
PRINT S DIC=ACGDIC
 K ACGJ
 I BY[26 D  Q:$D(ACGQUIT)  G FY
 .S DIR(0)="SO^1:Number and Dollar Amount Only;2:List of All Actions",DIR("A")="Which Report",DIR("B")=1,DIR("?",1)="Enter '1' to get the number of awards and total dollar amount only,"
 .S DIR("?")="Enter '2' to get list of all contract actions within the dollar range specified."
 .W !
 .D DIR^ACGSDIC
 .Q:$D(ACGQUIT)
 .S FLDS="[ACG DOLLAR AMOUNT"_$S(Y=1:" COUNT",1:"")_"]"
 S DIR(0)="SO^1:CONTRACT SUMMARY;2:BRIEF CONTRACT SUMMARY;3:COMPLETE DATA SET;4:SMALL PURCHASE SUMMARY;5:PURCHASE ORDER LISTING",DIR("B")="CONTRACT SUMMARY"
 W !
 D ^DIR K DIR
 Q:$D(ACGQUIT)
 S:Y=2 FLDS="[ACG CONTRACT DATA]",ACGAH=""
 S:Y=3 FLDS="[ACG PHSCIS SUMMARY]",ACGAH=""
 S:Y=4 FLDS="[ACG SP SUMMARY]",ACGAH=""
 S:Y=5 FLDS="[ACG 281 SOURCE DOCUMENTS]",ACGAH=""
FY S DIR(0)="YO",DIR("A")="Print Report for one Fiscal Year only",DIR("B")="NO",DIR("?")="Enter 'Y' if you wish to print this report for only one Fiscal Year."
 W !
 D DIR^ACGSDIC
 Q:$D(ACGQUIT)
 I Y=1 D FY^ACGSEXP D
 .I ACGFY?2N S DIS(0)="I $D(^ACGS(D0,""DT"")) Q:+^(""DT"")=14  I $E($P(^(""DT""),U,2),4,5)="_ACGFY
 .E  S ACGFY=""
 I FLDS="[ACG CONTRACT DATA]" W !!,"Select Fiscal Year for calculation of Fiscal Year TOTAL" D FY^ACGSEXP
 Q:$D(ACGQUIT)
PRT1 S ZTDESC="CIS ADHOC REPORT",ZTRTN="DIP^ACGSRT"
 D ^ACGSZIS
 I $D(ACGQUIT) K ACGQUIT,ACGAH Q
 S DIOEND=$S(BY'[26:"D TAIL^ACGSPSUM ",1:"")_"W:IOST[""C-"" !!,""End of report."" D:IOST[""C-"" HOLD^ACGSMENU W:$D(IOF) @IOF"
 W ! D WAIT^DICD W !
DIP I BY'[26 S:+BY'=1&(BY'["#1,")&(BY'[",1,") BY=BY_",@'.01",FR=FR_"0,",TO=TO_"0,"
 I +BY'=1&(BY'["#1,")&(BY'[",1,")&($E(FR)'="P")&(FR'[",P,"),+BY'=2&(BY'[",2,")&(BY'[",@2,") S BY=BY_",@2"
 I +BY'=1&(BY'["#1,")&(BY'[",1,")&($E(FR)'="P")&(FR'[",P,") S DIS(0)=$S($G(DIS(0))]"":DIS(0)_" ",1:"")_"I +$G(^ACGS(D0,""DT""))'=15,+$G(^(""DT""))'=17"
DIS S IOP=ACGION
 S (ACGTD,ACGTI,ACGTOTD,ACGTOTI,ACGTOTDT,ACGTOTIT,ACGTOTDI)=0,DC=""
 I BY[26 D SUB26
 S:ACG4'=236 DIS(0)="I $P($G(^ACGS(D0,""DT"")),U,4)=ACG4 "_$S($D(DIS(0)):DIS(0),1:"")
 D EN1^DIP,^%ZISC
 K IOP,ACGAH,ACGDF,ACGDT
 Q
CHECK I ACGCSTG[(U_ACGMAND_U) Q
 S ACGZZZ=ACGMAND,ACGFORC="",ACGN=ACGN+1
 W !!,*7,"You must also sort by"
 Q
DOLLAR ;EP;
 K ACGQUIT
 S DIR(0)="YO",DIR("A")="Print Report for a specified Dollar Threshold",DIR("B")="NO"
 W !
 D DIR^ACGSDIC
 Q:Y'=1!$D(ACGQUIT)
 S DIR(0)="NO^0:99999999",DIR("A")="Dollar Threshold",DIR("?")="Enter the dollar threshold you wish to use for this report.",DIR("?",1)="Enter the dollar amount without commas or cents, e.g., '100000'."
 W !
 D DIR^ACGSDIC
 Q:+Y<1!$D(ACGQUIT)
 S ACGDOLLR=+Y,DIS(0)=$S($D(DIS(0)):DIS(0)_" ",1:"")_"I $D(^ACGS(D0,""IHS"")),$P(^(""IHS""),U,7)>(ACGDOLLR-1)"
 Q
SUB26 ;
 N ACGI,X
 F ACGI=1:1:$L(BY,",") S X=$P(BY,",",ACGI) Q:X[26!(X[23)!(X[24)!(X[25)  S:X'["+" X="+"_X,$P(BY,",",ACGI)=X
 Q
