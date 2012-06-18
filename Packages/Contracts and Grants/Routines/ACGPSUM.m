ACGPSUM ; GENERATED FROM 'ACG REPORT' PRINT TEMPLATE (#4022) ; 10/01/09 ; (FILE 9002330, MARGIN=80)
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
 I $D(DXS)<9 M DXS=^DIPT(4022,"DXS")
 S I(0)="^ACGS(",J(0)=9002330
 S X=$G(^ACGS(D0,"DT")) D T Q:'DN  D N W ?0,$E($P(X,U,2),1,12)
 D N:$X>13 Q:'DN  W ?13,$E($P(X,U,5),1,30)
 D N:$X>45 Q:'DN  W ?45 W "EIN...:"
 W ?54,$E($P(X,U,11),1,12)
 D N:$X>13 Q:'DN  W ?13,$E($P(X,U,6),1,30)
 W ", "
 W ?0,$E($P(X,U,7),1,23)
 W ", "
 X DXS(1,9.2) S X=$P(DIP(101),U,2) S D0=I(0,0) K DIP K:DN Y W X
 W "  "
 S X=$G(^ACGS(D0,"DT")) W ?0,$E($P(X,U,9),1,5)
 D N:$X>13 Q:'DN  W ?13 W "DESCRIPTN: "
 S DIP(1)=$S($D(^ACGS(D0,"DT1")):^("DT1"),1:"") S X=$P(DIP(1),U,1),DIP(2)=X S X=1,DIP(3)=X S X=56,X=$E(DIP(2),DIP(3),X) K DIP K:DN Y W X
 W ?26 I $D(^ACGS(D0,"DT1")) S ACGX=$E($P(^("DT1"),U),57,97) W:ACGX'="" !?24,ACGX K DIP K:DN Y
 W ?37 W " " K DIP K:DN Y
 D N:$X>13 Q:'DN  W ?13 W "STAT CODE: "
 S DIP(1)=$S($D(^ACGS(D0,"IHS")):^("IHS"),1:"") S X=$P(DIP(1),U,22),X=X K DIP K:DN Y W X
 D N:$X>28 Q:'DN  W ?28 W "PURP CODE: "
 S X=$G(^ACGS(D0,"DT1")) S Y=$P(X,U,6) S Y=$S(Y="":Y,$D(^ACGPPC(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,4)
 D N:$X>45 Q:'DN  W ?45 W "START.: "
 S DIP(1)=$S($D(^ACGS(D0,"DT1")):^("DT1"),1:"") S X=$P(DIP(1),U,3) S:X X=$E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3) K DIP K:DN Y W X
 D N:$X>13 Q:'DN  W ?13 W "NEG. AUTH: "
 S X=$G(^ACGS(D0,"DT")) W ?0,$E($P(X,U,14),1,2)
 D N:$X>28 Q:'DN  W ?28 W "TYPE CONT: "
 S Y=$P(X,U,15) S Y=$S(Y="":Y,$D(^ACGTOC(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,2)
 D N:$X>45 Q:'DN  W ?45 W "END...: "
 S DIP(1)=$S($D(^ACGS(D0,"DT1")):^("DT1"),1:"") S X=$P(DIP(1),U,4) S:X X=$E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3) K DIP K:DN Y W X
 D N:$X>13 Q:'DN  W ?13 W "SOL. PROC: "
 S X=$G(^ACGS(D0,"DT")) S Y=$P(X,U,17) S Y=$S(Y="":Y,$D(^ACGSP(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,2)
 D N:$X>28 Q:'DN  W ?28 W "CNTR TYPE: "
 S Y=$P(X,U,13) S Y=$S(Y="":Y,$D(^AUTTTOB(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,2)
 D N:$X>45 Q:'DN  W ?45 W "AMOUNT: "
 S X=$G(^ACGS(D0,"DT1")) S Y=$P(X,U,5) W:Y]"" $J(Y,10,0)
 D N:$X>64 Q:'DN  W ?64 W "IND:"
 S X=$G(^ACGS(D0,"DT2")) S Y=$P(X,U,1) W:Y]"" $J(Y,10,0)
 W ?70 D ^ACGSPSUM K DIP K:DN Y
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
