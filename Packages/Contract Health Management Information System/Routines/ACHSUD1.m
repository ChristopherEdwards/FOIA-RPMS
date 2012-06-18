ACHSUD1 ; IHS/ITSC/PMF - SELECT HOSPITAL ORDER NUMBER ;   [ 10/16/2001   8:16 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 ;
 K ACHSDIEN,DIC
A1 ;
 W !!,"Hospital Order Number: "
 W:ACHSHONN]"" ACHSHONN_"// "
 D READ^ACHSFU
 I Y?1"?".E D ORD G A1
 Q:$D(DUOUT)!(Y="")
 I Y=" ",$D(^DISV(DUZ,"ACHSUD1")) S Y=$G(^DISV(DUZ,"ACHSUD1")),Y=$E(Y,2)_"-"_$E(Y,3,99) W Y
 I ACHSHONN]"",Y="@" W "   Deleted" S (ACHSHON,ACHSHONN)="" G A1
 G END:Y=""
 F %=1:1:$L(Y) I $E(Y,%)?1P,$E(Y,%)'="-" S Y=$E(Y,1,%-1)_"-"_$E(Y,%+1,999)
 F  S F=$F(Y,"--") Q:'F  S Y=$P(Y,"--")_"-"_$P(Y,"--",2,999)
 S (N,F,C)="",P=$L(Y,"-")
 I P>3 W *7,"  ??" G A1
 S N=$P(Y,"-",P)
 I P=3 S F=$P(Y,"-",2),C=+Y G A2
 I P=2 S C=$P(Y,"-") S:$L(C)>1 F=C,C=""
A2 ;
 S:C="" C=$E(ACHSACFY,4)
 S:F="" F=ACHSFC
 I $L(F)<3 S F=$E("000",1,3-$L(F))_F
 I $L(N)<6 S N=$E("00000",1,5-$L(N))_N
 S X="1"_C_N
 K C,F,N,P
 S DIC="^ACHSF("_DUZ(2)_",""D"",",DIC(0)="QZE",DIC("W")="W ""  "",$P(^(0),U,14),""-"",ACHSFC,""-"",$P(^(0),U)"
 D ^DIC
 K DIC
 G A1:Y<1
 S ACHSHON=+Y,^DISV(DUZ,"ACHSUD1")=$P(Y,U,2)
END ;
 Q
 ;
ORD ;
 W !!,"  If The Patient Is Currently Being Hospitialized Under Contract",!,"  Enter The Order Number.  Enter An '@' To Delete The Current Number.",!
 Q:'$G(DFN)
ORDC ; Check Inpatient Hospital Order Number.
 K O
 S (A,E)=0
 F  S A=$O(^ACHSF(DUZ(2),"PB",DFN,A)) Q:'A  I $D(^ACHSF(DUZ(2),"D",A,0)),$P(^(0),U,4)=1 S E=E+1,O(E)=+A_U_^(0)
 G:'$D(O) ENDO
 W !?8,"Doc #",?25,"Tran Date",!
 F E=1:1 S A=$O(O(A)) Q:A<1  D
 . W !,E,".",?5,$P(O(A),U,15),"-",ACHSFC,"-",$P(O(A),U,2),?25,$$FMTE^XLFDT($P(O(A),U,3))
 . S $P(O(A),U,2)=$P(O(A),U,15)_"-"_ACHSFC_"-"_$P(O(A),U,2)
 .Q
 S Y=$$DIR^XBDIR("NO^1:"_(E-1),"Hospital Order Number","","","","",2)
 G ENDO:$D(DUOUT)!$D(DTOUT)
 I Y="" S (ACHSHON,ACHSHONN)="" G ENDO
 S:$D(O(Y)) ACHSHON=+O(Y)
 W " ",$P(O(Y),U,2)
 S ACHSHONN=$P(O(Y),U,2)
ENDO ;
 K A,E,O
 Q
 ;
