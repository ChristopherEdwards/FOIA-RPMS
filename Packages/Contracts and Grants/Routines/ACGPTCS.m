ACGPTCS ; GENERATED FROM 'ACG PHSCIS SUMMARY' PRINT TEMPLATE (#4000) ; 10/01/09 ; (FILE 9002330, MARGIN=80)
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
 I $D(DXS)<9 M DXS=^DIPT(4000,"DXS")
 S I(0)="^ACGS(",J(0)=9002330
 W ?0 I 1 W:$D(IOF)&$D(ACGAH) @IOF K DIP K:DN Y
 D N:$X>54 Q:'DN  W ?54 W "PAGE:"
 W ?61 S X=$S($D(DC)#2:DC,1:"") K DIP K:DN Y W X
 D N:$X>0 Q:'DN  W ?0 W "1  TYPE ACTION:"
 W ?17 S DIP(1)=$S($D(^ACGS(D0,"DT")):^("DT"),1:"") S X="("_$S('$D(^ACGTPA(+$P(DIP(1),U,1),0)):"",1:$P(^(0),U,1))_") " K DIP K:DN Y W X
 X DXS(1,9.2) S X=$P(DIP(101),U,2) S D0=I(0,0) K DIP K:DN Y W $E(X,1,16)
 D N:$X>39 Q:'DN  W ?39 W "2  CONTRACT NO:"
 S X=$G(^ACGS(D0,"DT")) W ?56,$E($P(X,U,2),1,15)
 D N:$X>0 Q:'DN  W ?0 W "3  AGENCY ORD#:"
 W ?17,$E($P(X,U,3),1,14)
 D N:$X>39 Q:'DN  W ?39 W "4  CONT OFFICE:"
 W ?56,$E($P(X,U,4),1,3)
 D N:$X>0 Q:'DN  W ?0 W "5  CONTRACTOR.:"
 W ?17,$E($P(X,U,5),1,30)
 D N:$X>0 Q:'DN  W ?0 W "6  ADDRESS....:"
 W ?17,$E($P(X,U,6),1,30)
 W " "
 W ?0,$E($P(X,U,7),1,23)
 W ", "
 S Y=$P(X,U,8) S Y=$S(Y="":Y,$D(^DIC(5,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 W "  "
 W ?0,$E($P(X,U,9),1,5)
 D N:$X>0 Q:'DN  W ?0 W "10 CONGRS DIST:"
 W ?17,$E($P(X,U,10),1,3)
 D N:$X>39 Q:'DN  W ?39 W "11 EIN........:"
 W ?56,$E($P(X,U,11),1,12)
 D N:$X>0 Q:'DN  W ?0 W "12 EXTENT CMPD:"
 W ?17 S Y=$P(X,U,12) W:Y]"" $S($D(DXS(9,Y)):DXS(9,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "13 TYPE OF BUS:"
 W ?56 X DXS(2,9.2) S X=$P(DIP(101),U,2) S D0=I(0,0) K DIP K:DN Y W $E(X,1,20)
 D N:$X>0 Q:'DN  W ?0 W "14 NEG AUTH...:"
 S X=$G(^ACGS(D0,"DT")) W ?17,$E($P(X,U,14),1,2)
 D N:$X>39 Q:'DN  W ?39 W "15 CONTR TYPE.:"
 W ?56 X DXS(3,9.2) S X=$P(DIP(101),U,2) S D0=I(0,0) K DIP K:DN Y W $E(X,1,20)
 D N:$X>0 Q:'DN  W ?0 W "16 AA SRV CONT:"
 S X=$G(^ACGS(D0,"DT")) W ?17 S Y=$P(X,U,16) W:Y]"" $S($D(DXS(10,Y)):DXS(10,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "17 SOLICITATN.:"
 W ?56 X DXS(4,9.2) S X=$P(DIP(101),U,2) S D0=I(0,0) K DIP K:DN Y W $E(X,1,20)
 D N:$X>0 Q:'DN  W ?0 W "18 AOFOC......:"
 W ?17 X DXS(5,9.2) S X=$P(DIP(101),U,2) S D0=I(0,0) K DIP K:DN Y W $E(X,1,20)
 D N:$X>39 Q:'DN  W ?39 W "19 EXTENT COMP:"
 W ?56 X DXS(6,9.2) S X=$P(DIP(101),U,2) S D0=I(0,0) K DIP K:DN Y W $E(X,1,20)
 D N:$X>0 Q:'DN  W ?0 W "20 CONT METHOD:"
 W ?17 X DXS(7,9.2) S X=$P(DIP(101),U,2) S D0=I(0,0) K DIP K:DN Y W $E(X,1,20)
 D N:$X>39 Q:'DN  W ?39 W "21 OFFERS RCVD:"
 S X=$G(^ACGS(D0,"DT")) W ?56 S Y=$P(X,U,21) W:Y]"" $J(Y,3,0)
 D N:$X>0 Q:'DN  W ?0 W "22 PROJECT TTL:"
 D N:$X>17 Q:'DN  W ?17 S DIP(1)=$S($D(^ACGS(D0,"DT1")):^("DT1"),1:"") S X=$P(DIP(1),U,1),DIP(2)=X S X=1,DIP(3)=X S X=63,X=$E(DIP(2),DIP(3),X) K DIP K:DN Y W X
 W ?28 I $D(^ACGS(D0,"DT1")),$L($P(^("DT1"),U))>63 W !?17,$E($P(^("DT1"),U),64,97) K DIP K:DN Y
 W ?39 W " " K DIP K:DN Y
 D N:$X>0 Q:'DN  W ?0 W "23 AWARD DATE.:"
 S X=$G(^ACGS(D0,"DT1")) W ?17 S Y=$P(X,U,2) D DT
 D N:$X>39 Q:'DN  W ?39 W "24 START DATE.:"
 W ?56 S Y=$P(X,U,3) D DT
 D N:$X>0 Q:'DN  W ?0 W "25 END DATE...:"
 W ?17 S Y=$P(X,U,4) D DT
 D N:$X>39 Q:'DN  W ?39 W "26 DOLLAR AMNT:"
 W ?56 S Y=$P(X,U,5) W:Y]"" $J(Y,10,0)
 D N:$X>0 Q:'DN  W ?0 W "27 PURPOSE CDE:"
 W ?17 S Y=$P(X,U,6) S Y=$S(Y="":Y,$D(^ACGPPC(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,4)
 D N:$X>39 Q:'DN  W ?39 W "28 PLACE PERF.:"
 W ?56,$E($P(X,U,7),1,20)
 D N:$X>0 Q:'DN  W ?0 W "29 COST ACCNTG:"
 W ?17 S Y=$P(X,U,8) W:Y]"" $S($D(DXS(11,Y)):DXS(11,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "30 WOMEN-OWNED:"
 W ?56 S Y=$P(X,U,9) W:Y]"" $S($D(DXS(12,Y)):DXS(12,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "31 STAT REQS..:"
 W ?17 S Y=$P(X,U,10) W:Y]"" $S($D(DXS(13,Y)):DXS(13,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "32 AFFIRM ACT.:"
 W ?56 S Y=$P(X,U,11) W:Y]"" $S($D(DXS(14,Y)):DXS(14,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "33 TRADE DATA.:"
 W ?17,$E($P(X,U,12),1,8)
 D N:$X>39 Q:'DN  W ?39 W "34 DATE OF RFC:"
 W ?56 S Y=$P(X,U,13) D DT
 W ?69 I $E(IOST,1,2)="C-" D HOLD^ACGSMENU W:$D(IOF) @IOF K DIP K:DN Y
 D N:$X>0 Q:'DN  W ?0 W "35 PROJECT OFF:"
 S X=$G(^ACGS(D0,"DT1")) W ?17,$E($P(X,U,14),1,20)
 D N:$X>39 Q:'DN  W ?39 W "36 INDIR COST.:"
 S X=$G(^ACGS(D0,"DT2")) W ?56 S Y=$P(X,U,1) W:Y]"" $J(Y,10,0)
 D N:$X>0 Q:'DN  W ?0 W "37 FIRST CAN #:"
 W ?17,$E($P(X,U,2),1,8)
 D N:$X>39 Q:'DN  W ?39 W "38 FIRST CAN $:"
 W ?56 S Y=$P(X,U,3) W:Y]"" $J(Y,10,0)
 D N:$X>0 Q:'DN  W ?0 W "39 SECOND CAN#:"
 W ?17,$E($P(X,U,4),1,8)
 D N:$X>39 Q:'DN  W ?39 W "40 SECOND CAN$:"
 W ?56 S Y=$P(X,U,5) W:Y]"" $J(Y,10,0)
 D N:$X>0 Q:'DN  W ?0 W "41 THIRD CAN #:"
 W ?17,$E($P(X,U,6),1,8)
 D N:$X>39 Q:'DN  W ?39 W "42 THIRD CAN $:"
 W ?56 S Y=$P(X,U,7) W:Y]"" $J(Y,8,0)
 D N:$X>0 Q:'DN  W ?0 W "43 CO-DIRECT..:"
 W ?17 S Y=$P(X,U,8) W:Y]"" $J(Y,10,0)
 D N:$X>39 Q:'DN  W ?39 W "44 CO-INDIR...:"
 W ?56 S Y=$P(X,U,9) W:Y]"" $J(Y,10,0)
 D N:$X>0 Q:'DN  W ?0 W "45 SYNOPSIS...:"
 W ?17 S Y=$P(X,U,10) W:Y]"" $S($D(DXS(15,Y)):DXS(15,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "46 FEE AWARDED:"
 W ?56 S Y=$P(X,U,11) W:Y]"" $J(Y,10,0)
 D N:$X>0 Q:'DN  W ?0 W "47 SUB-C $$...:"
 W ?17 S Y=$P(X,U,12) W:Y]"" $J(Y,10,0)
 D N:$X>39 Q:'DN  W ?39 W "48 S-C NOT DIS:"
 W ?56 S Y=$P(X,U,13) W:Y]"" $J(Y,10,0)
 D N:$X>0 Q:'DN  W ?0 W "49 S-C DISADV.:"
 W ?17 S Y=$P(X,U,14) W:Y]"" $J(Y,10,0)
 D N:$X>39 Q:'DN  W ?39 W "50 INCR FUNDED:"
 W ?56 S Y=$P(X,U,15) W:Y]"" $J(Y,10,0)
 D N:$X>0 Q:'DN  W ?0 W "51 FORGN/INTRN:"
 W ?17 S Y=$P(X,U,16) W:Y]"" $S($D(DXS(16,Y)):DXS(16,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "52 TAR/REGULAT:"
 W ?56 S Y=$P(X,U,17) W:Y]"" $S($D(DXS(17,Y)):DXS(17,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "53 SIC CODE...:"
 W ?17,$E($P(X,U,18),1,4)
 D N:$X>39 Q:'DN  W ?39 W "54 CP NAME....:"
 W ?56,$E($P(X,U,19),1,20)
 D N:$X>0 Q:'DN  W ?0 W "55 CP TIN.....:"
 W ?17,$E($P(X,U,20),1,9)
 D N:$X>39 Q:'DN  W ?39 W "56 SUB-C PLAN.:"
 S X=$G(^ACGS(D0,"DT3")) W ?56 S Y=$P(X,U,1) W:Y]"" $S($D(DXS(18,Y)):DXS(18,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "57 SUB-K PLAN.:"
 W ?17 S Y=$P(X,U,2) W:Y]"" $S($D(DXS(19,Y)):DXS(19,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "58 AIDS AFFLTD:"
 W ?56 S Y=$P(X,U,3) W:Y]"" $S($D(DXS(20,Y)):DXS(20,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "59 AIDS DOLLAR:"
 W ?17 S Y=$P(X,U,4) W:Y]"" $J(Y,10,0)
 D N:$X>39 Q:'DN  W ?39 W "60 MULT PLACE.:"
 W ?56 S Y=$P(X,U,5) W:Y]"" $S($D(DXS(21,Y)):DXS(21,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "61 MULTPLE PSC:"
 W ?17,$E($P(X,U,6),1,4)
 D N:$X>39 Q:'DN  W ?39 W "62 CICA APPLIC:"
 W ?56 S Y=$P(X,U,7) W:Y]"" $S($D(DXS(22,Y)):DXS(22,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "63 SB DEMO TST:"
 W ?17 S Y=$P(X,U,8) W:Y]"" $S($D(DXS(23,Y)):DXS(23,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "64 EMERGING SB:"
 W ?56 S Y=$P(X,U,9) W:Y]"" $S($D(DXS(24,Y)):DXS(24,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "65 EM SB RES..:"
 W ?17 S Y=$P(X,U,10) W:Y]"" $S($D(DXS(25,Y)):DXS(25,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "66 SIZE OF SB.:"
 W ?56 X DXS(8,9.2) S X=$P(DIP(101),U,2) S D0=I(0,0) K DIP K:DN Y W X
 D N:$X>0 Q:'DN  W ?0 W "67 HANDICAP $$:"
 G ^ACGPTCS1
