ACGPSP ; GENERATED FROM 'ACG SMALL PURCHASE DISPLAY' PRINT TEMPLATE (#4015) ; 10/01/09 ; (FILE 9002330, MARGIN=80)
 G BEGIN
N W !
T W:$X ! I '$D(DIOT(2)),DN,$D(IOSL),$S('$D(DIWF):1,$P(DIWF,"B",2):$P(DIWF,"B",2),1:1)+$Y'<IOSL,$D(^UTILITY($J,1))#2,^(1)?1U1P1E.E X ^(1)
 S DISTP=DISTP+1,DILCT=DILCT+1 D:'(DISTP#100) CSTP^DIO2
 Q
DT I $G(DUZ("LANG"))>1,Y W $$OUT^DIALOGU(Y,"DD") Q
 I Y W $P("JAN^FEB^MAR^APR^MAY^JUN^JUL^AUG^SEP^OCT^NOV^DEC",U,$E(Y,4,5))_" " W:Y#100 $J(Y#100\1,2)_"," W Y\10000+1700 W:Y#1 "  "_$E(Y_0,9,10)_":"_$E(Y_"000",11,12) Q
 W Y Q
M D @DIXX
 Q
BEGIN ;
 S:'$D(DN) DN=1 S DISTP=$G(DISTP),DILCT=$G(DILCT)
 I $D(DXS)<9 M DXS=^DIPT(4015,"DXS")
 S I(0)="^ACGS(",J(0)=9002330
 D N:$X>0 Q:'DN  W ?0 W "1  TYPE ACTION:"
 W ?17 X DXS(1,9.2) S X=$P(DIP(101),U,2) S D0=I(0,0) K DIP K:DN Y W $E(X,1,20)
 D N:$X>40 Q:'DN  W ?40 W "15 EIN........:"
 W ?57 X DXS(2,9.2) S X=$P(DIP(101),U,13) S D0=I(0,0) K DIP K:DN Y W X
 D N:$X>0 Q:'DN  W ?0 W "2  PO NUMBER..:"
 S X=$G(^ACGS(D0,"SP")) W ?17,$E($P(X,U,1),1,17)
 D N:$X>40 Q:'DN  W ?40 W "16 EXTENT CMPD:"
 W ?57 S Y=$P(X,U,7) W:Y]"" $S($D(DXS(4,Y)):DXS(4,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "3  CONT OFFICE:"
 S X=$G(^ACGS(D0,"DT")) W ?17,$E($P(X,U,4),1,3)
 D N:$X>40 Q:'DN  W ?40 W "17 PRF PROFRAM:"
 S X=$G(^ACGS(D0,"SP")) W ?57 S Y=$P(X,U,3) W:Y]"" $S($D(DXS(5,Y)):DXS(5,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "4  VENDOR.....:"
 S X=$G(^ACGS(D0,"DT")) W ?17,$E($P(X,U,5),1,30)
 D N:$X>0 Q:'DN  W ?0 W "5  ADDRESS....:"
 W ?17,$E($P(X,U,6),1,30)
 W ", "
 W ?0,$E($P(X,U,7),1,23)
 W ", "
 X DXS(3,9.2) S X=$P(DIP(101),U,2) S D0=I(0,0) K DIP K:DN Y W X
 W "  "
 S X=$G(^ACGS(D0,"DT")) W ?0,$E($P(X,U,9),1,5)
 D N:$X>0 Q:'DN  W ?0 W "10 AWARD DATE.:"
 S X=$G(^ACGS(D0,"DT1")) W ?17 S Y=$P(X,U,2) D DT
 D N:$X>40 Q:'DN  W ?40 W "18 TYPE OF BUS:"
 S X=$G(^ACGS(D0,"SP")) W ?57 S Y=$P(X,U,4) W:Y]"" $S($D(DXS(6,Y)):DXS(6,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "11 START DATE.:"
 S X=$G(^ACGS(D0,"DT1")) W ?17 S Y=$P(X,U,3) D DT
 D N:$X>40 Q:'DN  W ?40 W "19 TYPE VENDOR:"
 S X=$G(^ACGS(D0,"SP")) W ?57 S Y=$P(X,U,5) W:Y]"" $S($D(DXS(7,Y)):DXS(7,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "12 END DATE...:"
 S X=$G(^ACGS(D0,"DT1")) W ?17 S Y=$P(X,U,4) D DT
 D N:$X>40 Q:'DN  W ?40 W "20 PROC METH..:"
 S X=$G(^ACGS(D0,"SP")) W ?57 S Y=$P(X,U,6) W:Y]"" $S($D(DXS(8,Y)):DXS(8,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "13 DOLLAR AMNT:"
 S X=$G(^ACGS(D0,"DT1")) W ?17 S Y=$P(X,U,5) W:Y]"" $J(Y,10,0)
 D N:$X>40 Q:'DN  W ?40 W "21 A&A SERV...:"
 S X=$G(^ACGS(D0,"DT")) W ?57 S Y=$P(X,U,16) W:Y]"" $S($D(DXS(9,Y)):DXS(9,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "14 OBJECT CODE:"
 S X=$G(^ACGS(D0,"SP")) W ?17 S Y=$P(X,U,2) S Y=$S(Y="":Y,$D(^AUTTOBJC(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,4)
 D N:$X>40 Q:'DN  W ?40 W "22 PURPOSE CDE:"
 S X=$G(^ACGS(D0,"DT1")) W ?57 S Y=$P(X,U,6) S Y=$S(Y="":Y,$D(^ACGPPC(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,20)
 D N:$X>40 Q:'DN  W ?40 W "23 BUYER INIT.:"
 S X=$G(^ACGS(D0,"IHS")) W ?57,$E($P(X,U,16),1,3)
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
