ACRPDHR ; GENERATED FROM 'ACR SYSTEMS DHR SETUP' PRINT TEMPLATE (#3967) ; 09/29/09 ; (FILE 9002199.2, MARGIN=80)
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
 I $D(DXS)<9 M DXS=^DIPT(3967,"DXS")
 S I(0)="^ACRSYS(",J(0)=9002199.2
 D N:$X>0 Q:'DN  W ?0 W "DHR INTERFACE ACTIVATED..:"
 S X=$G(^ACRSYS(D0,"DT")) W ?28 S Y=$P(X,U,25) W:Y]"" $S($D(DXS(1,Y)):DXS(1,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "CREATE DHR FOR BPA CALL..:"
 W ?28 S Y=$P(X,U,36) W:Y]"" $S($D(DXS(2,Y)):DXS(2,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "CREATE DHR FOR FEDSTRIP..:"
 W ?28 S Y=$P(X,U,38) W:Y]"" $S($D(DXS(3,Y)):DXS(3,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "CREATE CREDIT CARD DHR...:"
 S X=$G(^ACRSYS(D0,"DT1")) W ?28 S Y=$P(X,U,8) W:Y]"" $S($D(DXS(4,Y)):DXS(4,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "CREATE ALLOWANCE DHR.....:"
 W ?28 S Y=$P(X,U,6) W:Y]"" $S($D(DXS(5,Y)):DXS(5,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "CREATE ACCRUAL DHR.......:"
 W ?28 S Y=$P(X,U,5) W:Y]"" $S($D(DXS(6,Y)):DXS(6,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "CREATE ONLY TRAVEL DHR...:"
 S X=$G(^ACRSYS(D0,"DT")) W ?28 S Y=$P(X,U,32) W:Y]"" $S($D(DXS(7,Y)):DXS(7,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "TRAVEL PAID BY 1166......:"
 W ?28 S Y=$P(X,U,37) W:Y]"" $S($D(DXS(8,Y)):DXS(8,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "AIRFARE ON OBLIGATION DHR:"
 W ?28 S Y=$P(X,U,33) W:Y]"" $S($D(DXS(9,Y)):DXS(9,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "AIRFARE ON PAYMENT DHR...:"
 W ?28 S Y=$P(X,U,34) W:Y]"" $S($D(DXS(10,Y)):DXS(10,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "REF. CODE FOR AIRFARE DHR:"
 W ?28 S Y=$P(X,U,35) S Y=$S(Y="":Y,$D(^AUTTDOCR(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,3)
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
