ACGSFLDS ;IHS/OIRM/DSD/THL,AEF - CONTROL CIS FIELDS AND EXPORT VARIABLES ; [ 03/27/2000   2:22 PM ]
 ;;2.0t1;CONTRACT INFORMATION SYSTEM;;FEB 16, 2000
 ;;CONTROL CIS FIELDS AND EXPORT VARIABLES
 ;;modified for y2k;mlp;01/01/2000
EN I $D(^ACGS(ACGRDA,"DT"))&$D(^("DT1"))&$D(^("DT2"))&$D(^("DT3")) S ACGDT=^("DT"),ACGDT1=^("DT1"),ACGDT2=^("DT2"),ACGDT3=^("DT3"),ACGIHS=^("IHS") D 1
EXIT K ACGSIGN,ACGX
 Q
1 S ACGY="",X=$P(ACGDT,U),X=$S('X:" ",$D(^ACGTPA(X,0)):$E($P(^(0),U)),1:" ")
 D Y
2 S X=$E($P(ACGDT,U,2),1,15)
 S:$L(X)<15 X=X_$J(" ",15-$L(X))
 D Y
3 S X=$E($P(ACGDT,U,3),1,12)
 S:$L(X)<12 X=X_$J(" ",12-$L(X))
 D Y
4 S X=$E($P(ACGDT,U,4),1,3)
 S:$L(X)<3 X=X_$J(" ",3-$L(X))
 D Y
5 S X=$E($P(ACGDT,U,5),1,40)
 S:$L(X)<40 X=X_$J(" ",40-$L(X))
 D Y
6 S X=$E($P(ACGDT,U,6),1,30)
 S:$L(X)<30 X=X_$J(" ",30-$L(X))
 D Y
7 S X=$E($P(ACGDT,U,7),1,23)
 S:$L(X)<23 X=X_$J(" ",23-$L(X))
 D Y
8 S X=$P(ACGDT,U,8),X=$S('X:"",$D(^DIC(5,X,0)):$E($P(^(0),U),1,19),1:"")
 S:$L(X)<19 X=X_$J(" ",19-$L(X))
 D Y
9 S X=$E($P(ACGDT,U,9),1,5)
 S:$L(X)<5 X=X_$J(" ",5-$L(X))
 D Y
10 S X=$E($P(ACGDT,U,10),1,3)
 S:X="" X="   "
 S:$L(X)<3 X=X_$J("0",3-$L(X))
 S:X="MUL"!(+X>99) X="099"
 D Y
11 S X=$E($P(ACGDT,U,11),1,12)
 S:$L(X)<12 X=X_$J(" ",12-$L(X))
 S:$E(X)=2 $E(X,11,12)="  "
 D Y
12 S X=$E($P(ACGDT,U,12)),X=$S(X]"":X,1:" ")
 D Y
13 S X=$P(ACGDT,U,13),X=$S('X:"  ",$D(^AUTTTOB(X,0)):$P(^(0),U),1:"  ")
 D Y
14 S X=$E($P(ACGDT,U,14),1,2),X=$S(X]"":X,1:"  ")
 D Y
15 S X=$P(ACGDT,U,15),X=$S('X:"  ",$D(^ACGTOC(X,0)):$P(^(0),U),1:"  ")
 D Y
16 S X=$E($P(ACGDT,U,16)),X=$S(X]"":X,1:" ")
 D Y
17 S X=$P(ACGDT,U,17),X=$S('X:"  ",$D(^ACGSP(X,0)):$P(^(0),U),1:"  ")
 D Y
18 S X=$P(ACGDT,U,18),X=$S('X:"  ",$D(^ACGFAO(X,0)):$P(^(0),U),1:"  ")
 D Y
19 S X=$P(ACGDT,U,19),X=$S('X:"  ",$D(^ACGEOC(X,0)):$P(^(0),U),1:"  ")
 D Y
20 S X=$P(ACGDT,U,20),X=$S('X:" ",$D(^ACGMOC(X,0)):$P(^(0),U),1:" ")
 D Y
21 S X=$E($P(ACGDT,U,21),1,2),X=$S($L(X)=2:X,X]"":"0"_X,1:"01")
 D Y
22 S X=$E($P(ACGDT1,U),1,97)
 S:$L(X)<97 X=X_$J(" ",97-$L(X))
 D Y
23 ;S X=$E($P(ACGDT1,U,2),2,7)
 ;S:$L(X)<6 X=X_$J(" ",6-$L(X))
 S X=$E($P(ACGDT1,U,2),1,7) ;y2k;mlp
 S:$L(X)<7 X=X_$J(" ",7-$L(X)) ;y2k;mlp
 D Y
24 ;S X=$E($P(ACGDT1,U,3),2,7)
 ;S:$L(X)<6 X=X_$J(" ",6-$L(X))
 S X=$E($P(ACGDT1,U,3),1,7) ;y2k;mlp
 S:$L(X)<7 X=X_$J(" ",7-$L(X)) ;y2k;mlp
 D Y
25 ;S X=$E($P(ACGDT1,U,4),2,7)
 ;S:$L(X)<6 X=X_$J(" ",6-$L(X))
 S X=$E($P(ACGDT1,U,4),1,7) ;y2k;mlp
 S:$L(X)<7 X=X_$J(" ",7-$L(X)) ;y2k;mlp
 D Y
26 S X=$P(ACGDT1,U,5),ACGSIGN=$S($E(X)="-":"-",1:""),ACGX=""
 S:+X=0&($E(ACGY)="D") X=1
 S:ACGSIGN="-" X=$P(X,"-",2)
 S:(10-$L(ACGSIGN)-$L(X)) $P(ACGX,"0",(10-$L(ACGSIGN)-$L(X)))="" S X=ACGSIGN_ACGX_X
 D Y
27 S X=$P(ACGDT1,U,6),X=$S('X:"    ",$D(^ACGPPC(X,0)):$P(^(0),U),1:"    ")
 D Y
28 S X=$E($P(ACGDT1,U,7),1,25)
 S:$L(X)<25 X=X_$J(" ",25-$L(X))
 D Y
29 S X=$E($P(ACGDT1,U,8)),X=$S(X]"":X,1:" ")
 D Y
30 S X=$E($P(ACGDT1,U,9)),X=$S(X=1!(X=2):X,1:2)
 D Y
31 S X=$E($P(ACGDT1,U,10)),X=$S(X]"":X,1:" ")
 D Y
32 S X=$E($P(ACGDT1,U,11)),X=$S(X]"":X,1:" ")
 D Y
33 S X=$E($P(ACGDT1,U,12),1,8),X="000000  "
 D Y
34 ;S X=$E($P(ACGDT1,U,13),2,7)
 ;S:$L(X)<6 X=X_$J(" ",6-$L(X))
 S X=$E($P(ACGDT1,U,13),1,7) ;y2k;mlp
 S:$L(X)<7 X=X_$J(" ",7-$L(X)) ;y2k;mlp
 D Y
35 S X=$E($P(ACGDT1,U,14),1,20)
 S:$L(X)<20 X=X_$J(" ",20-$L(X))
 D Y
CONT D ^ACGSFLD1
 Q
Y S ACGY=ACGY_X
 Q
