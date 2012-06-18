ACGSSPFD ;IHS/OIRM/DSD/THL - CONTROL CIS/SP EXPORT; [ 03/27/2000   2:22 PM ]
 ;;2.0t1;CONTRACT INFORMATION SYSTEM;;FEB 16, 2000
 ;;CONTROL CIS FIELDS AND EXPORT VARIABLES FOR SMALL PURCHASES
 ;;modifed for y2k;mlp;01/01/2000
EN I $D(^ACGS(ACGRDA,"DT"))&$D(^("DT1")) S ACGDT=^("DT"),ACGDT1=^("DT1"),ACGSP=$G(^("SP")) D 1
EXIT K ACGSIGN,ACGX
 Q
1 S ACGY="",X=$P(ACGDT,U),X=$S('X:" ",$D(^ACGTPA(X,0)):$E($P(^(0),U)),1:" ")
 D Y
2 S X=$E($P(ACGDT,U,2),1,17)
 S:$L(X)<17 X=X_$J(" ",17-$L(X))
 D Y
3 S X=$E($P(ACGDT,U,4),1,3)
 S:$L(X)<3 X=X_$J(" ",3-$L(X))
 D Y
4 S X=$E($P(ACGDT,U,5),1,40)
 S:$L(X)<40 X=X_$J(" ",40-$L(X))
 D Y
5 S X=$E($P(ACGDT,U,6),1,30)
 S:$L(X)<30 X=X_$J(" ",30-$L(X))
 D Y
6 S X=$E($P(ACGDT,U,7),1,23)
 S:$L(X)<23 X=X_$J(" ",23-$L(X))
 D Y
7 S X=$P(ACGDT,U,8),X=$S('X:"",$D(^DIC(5,X,0)):$E($P(^(0),U),1,19),1:"")
 S:$L(X)<19 X=X_$J(" ",19-$L(X))
 D Y
8 S X=$E($P(ACGDT,U,9),1,9),X=$TR(X,"-","")
 S:$L(X)<9 X=X_$J(" ",9-$L(X))
 D Y
9 S X="                   "
 D Y
1023 ;S X=$E($P(ACGDT1,U,2),2,7)
 ;S:$L(X)<6 X=X_$J(" ",6-$L(X))
 S X=$E($P(ACGDT1,U,2),1,7) ;y2k;mlp
 S:$L(X)<7 X=X_$J(" ",7-$L(X)) ;y2k;mlp
 D Y
1124 ;S X=$E($P(ACGDT1,U,3),2,7)
 ;S:$L(X)<6 X=X_$J(" ",6-$L(X))
 S X=$E($P(ACGDT1,U,3),1,7) ;y2k;mlp
 S:$L(X)<7 X=X_$J(" ",7-$L(X)) ;y2k;mlp
 D Y
1225 ;S X=$E($P(ACGDT1,U,4),2,7)
 ;S:$L(X)<6 X=X_$J(" ",6-$L(X))
 S X=$E($P(ACGDT1,U,4),1,7) ;y2k;mlp
 S:$L(X)<7 X=X_$J(" ",7-$L(X)) ;y2k;mlp
 D Y
1326 S X=$P($P(ACGDT1,U,5),"."),ACGSIGN=$S($E(X)="-":"-",1:""),ACGX=""
 S:ACGSIGN="-" X=$P(X,"-",2)
 S:(10-$L(ACGSIGN)-$L(X)) $P(ACGX,"0",(10-$L(ACGSIGN)-$L(X)))=""
 S X=ACGSIGN_ACGX_X
 D Y
14 S X=$P(ACGSP,U,2),X=$S('X:"    ",$D(^AUTTOBJC(X,0)):$P(^(0),U),1:"    ")
 D Y
1511 S X=$E($P(ACGDT,U,11),1,12)
 S:$L(X)<12 X=X_$J(" ",12-$L(X)) S:$E(X)=2 $E(X,11,12)="  "
 D Y
16 S X=$E($P(ACGSP,U,7)),X=$S(X]"":X,1:" ")
 D Y
17 S X=$E($P(ACGSP,U,3)),X=$S(X]"":X,1:" ")
 D Y
18 S X=$E($P(ACGSP,U,4),1,2),X=$S(X]"":X,1:"  ")
 D Y
19 S X=$E($P(ACGSP,U,5)),X=$S(X]"":X,1:" ")
 D Y
20 S X=$E($P(ACGSP,U,6)),X=$S(X]"":X,1:" ")
 D Y
2116 S X=$E($P(ACGDT,U,16)),X=$S(X]"":X,1:" ")
 D Y
2227 S X=$P(ACGDT1,U,6),X=$S('X:"    ",$D(^ACGPPC(X,0)):$P(^(0),U),1:"    ")
 D Y
23 S X=""
 S X=X_$J(" ",85-$L(X))
 D Y
 Q
Y S ACGY=ACGY_X
 Q
