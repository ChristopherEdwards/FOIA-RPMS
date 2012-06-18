ACGSDCIS ;IHS/OIRM/DSD/THL,AEF - CONTROL CIS FIELDS AND EXPORT VARIABLES ; [ 03/27/2000   2:22 PM ]
 ;;2.0t1;CONTRACT INFORMATION SYSTEM;;FEB 16, 2000
 ;;CONTROL CIS FIELDS AND EXPORT VARIABLES
 ;;modified for y2k;mlp;01/31/2000
EN I $D(^ACGS(ACGRDA,"DT"))&$D(^("DT1"))&$D(^("DT2"))&$D(^("DT3")) S ACGDT=^("DT"),ACGDT1=^("DT1"),ACGDT2=^("DT2"),ACGDT3=^("DT3"),ACGIHS=^("IHS") D 1
EXIT K ACGSIGN,ACGX
 Q
1 S ACGY="",X="7520"
 D Y
2 S X=$E($P(ACGDT,U,2),1,9)_"   "
 S:$L(X)<15 X=X_$J(" ",15-$L(X))
 D Y
3 S X=$E($P(ACGDT,U,2),10,12)
 S:$L(X)<4 X=X_$J("0",4-$L(X))
 D Y
4 S X=$E($P(ACGDT,U,3),1,12)
 S:$L(X)<15 X=X_$J(" ",15-$L(X))
 D Y
5 S X="00"_$E($P(ACGDT,U,4),1,3)
 S:$L(X)<5 X=X_$J(" ",5-$L(X))
 D Y
6 S X=$E($P(ACGDT1,U,3),2,5)
 S:X'?4N X="    "
 D Y
7 S X="A"
 D Y
8 S X="961"
 D Y
9 S X=$P(ACGDT,U),X=$S('X:" ",$D(^ACGTPA(X,0)):$E($P(^(0),U)),1:" ")
 D 9^ACGSDCI2,Y
10 S X=$P(ACGDT1,U,5),ACGSIGN=$S($E(X)="-":"-",1:""),ACGX=""
 S:ACGSIGN="-" X=$P(X,"-",2)
 Q:X<500
 D DOLLAR
 S:(9-$L(X)) $P(ACGX,"0",(9-$L(X)))=""
 S X=ACGX_X
 D Y
11 S X=$S(ACGSIGN'="-":"A",1:"B")
 D Y
12 S X=$P(ACGDT1,U,6),X=$S('X:"    ",$D(^ACGPPC(X,0)):$P(^(0),U),1:"    ")
 D Y
13 S X=$E($P(ACGDT2,U,18),1,4),X=$S(X]"":X,1:"    ")
 D Y
14 S X=$E($P(ACGDT,U,16)),X=$S(X=1:"Y",X=2:"N",1:" ")
 D Y
15 S X=$E($P(ACGDT,U,5),1,30)
 S:$L(X)<30 X=X_$J(" ",30-$L(X))
 D Y
16 S X="         "
 D Y
17 S X=$E($P(ACGDT1,U,7),1,7)
 S:$L(X)'=7 X="       "
 S X=X_"  "
 D Y
18 S X=$E($P(ACGDT2,U,16)),X=$S(X=1:"Y",1:"N")
 D Y
19 S X=$E($P(ACGDT2,U,17)),X=$S("ABC"[$P(ACGDT3,U,7):" ",X]"":X,1:" ")
 D Y
20 S X="0"
 D Y
21 S X="00"
 D Y
22 S X="US"
 D Y
23 S X=$E($P(ACGDT2,U,10)),X=$S(X=1:"A",X=2:"B",1:"C")
 D Y
24 S X=$P(ACGDT,U,15),X=$S('X:" ",$D(^ACGTOC(X,0)):$P(^(0),U),1:" ")
 D 24^ACGSDCI2
 D Y
25 S X=$E($P(ACGDT3,U,7)),X=$S(X]"":X,1:" ")
 D Y
26 S X=$P(ACGDT,U,17),X=$S('X:" ",$D(^ACGSP(X,0)):$P(^(0),U),1:" "),X=$E(X,2),X=$S(X="K":"L",X="J":"K",X="I":"J",1:X)
 D Y
27 S X=$P(ACGDT,U,18),X=$S('X:" ",$D(^ACGFAO(X,0)):$P(^(0),U),1:" ")
 D 27^ACGSDCI2
 D Y
28 S X=$E($P(ACGDT,U,21),1,2),X=$S(X<2:"A",1:"B")
 D Y
29 S X=$E($P(ACGDT,U,12)),X=$S(X]"":X,1:" ")
 D Y
30 S X=$P(ACGDT,U,13),X=$S('X:" ",$D(^AUTTTOB(X,0)):$P(^(0),U),1:" ")
 D 30^ACGSDCI2
 D Y
31 S X=$E($P(ACGDT1,U,9)),X=$S(X=1:"Y",1:"N")
 D Y
32 S X=$P(ACGDT,U,19),X=$S('X:" ",$D(^ACGEOC(X,0)):$P(^(0),U),1:" ")
 D 32^ACGSDCI2
 D Y
33 S X=$E($P(ACGDT3,U,1)),X=$S(X=1:"A",1:"B")
 D Y
34 S X=$E($P(ACGDT1,U,10)),X=$S(X]"":X,1:" ")
 D Y
35 S X=$E($P(ACGDT1,U,4),2,5)
 S:X="" X="    "
 D Y
36 S X=$E($P(ACGDT,U,11),2,10)
 S:$L(X)<9 X=X_$J(" ",9-$L(X))
 D Y
37 S X=$E($P(ACGDT2,U,19),1,30)
 S:$L(X)<30 X=X_$J(" ",30-$L(X))
 D Y
38 S X=$E($P(ACGDT2,U,20),2,10)
 S:$L(X)<9 X=X_$J(" ",9-$L(X))
 D Y
39 S X=" "
 D Y
40 S X=" "
 D Y
41 S X="        "
 D Y
42 S X=$E($P(ACGDT3,U,8)),X=$S(X'=1:"N",$E(ACGY,129)="D"&(X=1):"N",1:"N")
 D Y
43 S X=$E($P(ACGDT3,U,9)),X=$S($E(ACGY,200)="N":" ",X=1:"Y",1:"N")
 D Y
44 S X=$E($P(ACGDT3,U,10)),X=$S($E(ACGY,200)="N":" ",X=1:"Y",1:"N")
 D Y
45 S X=$P(ACGDT3,U,11),X=$S('X:" ",$D(^AUTTSOB(X,0)):$P(^(0),U),1:" ")
 D Y
46 S X="          "
 D Y
50 S X=$E($P(ACGDT,U,6),1,35)
 S:$L(X)<35 X=X_$J(" ",35-$L(X))
 D Y
51 S X=$E($P(ACGDT,U,7),1,18)
 S:$L(X)<18 X=X_$J(" ",18-$L(X))
 D Y
52 S X=$P(ACGDT,U,8),X=$S('X:"",$D(^DIC(5,X,0)):$P(^(0),U,2),1:"")
 D Y
53 S X=$E($P(ACGDT,U,9),1,5)
 S:$L(X)<5 X=X_$J(" ",5-$L(X))
 D Y
54 S X=$E($P(ACGDT1,U),1,150)
 S:$L(X)<150 X=X_$J(" ",150-$L(X))
 D Y
55 ;S X=$E($P(ACGDT1,U,13),2,7)
 ;S:X'?6N X="      "
 ;S:$L(X)<6 X=X_$J(" ",6-$L(X))
 S X=$E($P(ACGDT1,U,13),1,7) ;y2k;mlp
 S:X'?7N X="       " ;y2k;mlp
 S:$L(X)<7 X=X_$J(" ",7-$L(X)) ;y2k;mlp
 D Y
56 ;S X=$E($P(ACGDT1,U,3),2,7)
 ;S:X'?6N X="      "
 S X=$E($P(ACGDT1,U,3),1,7) ;y2k;mlp
 S:X'?7N X="       " ;y2k;mlp
 D Y
57 S X=$P(ACGDT2,U,12),ACGSIGN=$S($E(X)="-":"-",1:""),ACGX=""
 S:ACGSIGN="-" X=$P(X,"-",2)
 D DOLLAR
 S:(9-$L(X)) $P(ACGX,"0",(9-$L(X)))=""
 S X=ACGX_X
 D Y
58 S X=$P(ACGDT2,U,13),ACGSIGN=$S($E(X)="-":"-",1:""),ACGX=""
 S:ACGSIGN="-" X=$P(X,"-",2)
 D DOLLAR
 S:(9-$L(X)) $P(ACGX,"0",(9-$L(X)))=""
 S X=ACGX_X
 D Y
59 S X=$P(ACGDT2,U,14),ACGSIGN=$S($E(X)="-":"-",1:""),ACGX=""
 S:ACGSIGN="-" X=$P(X,"-",2)
 D DOLLAR
 S:(9-$L(X)) $P(ACGX,"0",(9-$L(X)))=""
 S X=ACGX_X
 D Y
60 S X=$E($P(ACGDT1,U,8)),X=$S(X=1:"Y",1:"N")
 D Y
61 S X=$E($P(ACGDT3,U,12),1,10),ACGSIGN=$S($E(X)="-":"-",1:""),ACGX=""
 S:ACGSIGN="-" X=$P(X,"-",2)
 D DOLLAR
 S:(9-$L(X)) $P(ACGX,"0",(9-$L(X)))=""
 S X=ACGX_X
 D Y
 K ACGX
62 S X=$E($P(ACGDT3,U,13),1,10),ACGSIGN=$S($E(X)="-":"-",1:""),ACGX=""
 S:ACGSIGN="-" X=$P(X,"-",2)
 D DOLLAR
 S:(9-$L(X)) $P(ACGX,"0",(9-$L(X)))=""
 S X=ACGX_X
 D Y
63 S X="                              "
 D Y
64 S X="          "
 D Y
65 S X="DHRI"
 D Y
66 S X="                                                                                "
 D Y
 Q
Y S ACGY=ACGY_X
 Q
DOLLAR ;FORMAT DOLLARS FOR DCIS
 S X=$FN(X,"P,",2),X=$P(X,"."),Z=$L(X,","),Y=$P(X,",",Z),X=$P(X,",",1,Z-1)
 S X=$TR(X," ",""),X=$TR(X,",","")
 S:Y>500 X=X+1
 Q
