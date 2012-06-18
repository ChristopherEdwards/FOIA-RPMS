BEXRPAT ; GENERATED FROM 'BEX TRANSACTIONS BY PATIENT' PRINT TEMPLATE (#3799) ; 08/21/10 ; (FILE 90350.1, MARGIN=80)
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
 I $D(DXS)<9 M DXS=^DIPT(3799,"DXS")
 S I(0)="^VEXHRX0(19080.1,",J(0)=90350.1
 X DXS(1,9.2) S X1=DIP(2) S:X]""&(X?.ANP)&(X1'[U)&(X1'["$C(94)") DIPA($E(X,1,30))=X1 S X="" K DIP K:DN Y W X
 X DXS(2,9.3) S X1=DIP(5) S:X]""&(X?.ANP)&(X1'[U)&(X1'["$C(94)") DIPA($E(X,1,30))=X1 S X="" K DIP K:DN Y W X
 X DXS(3,9.4) S X1=DIP(6) S:X]""&(X?.ANP)&(X1'[U)&(X1'["$C(94)") DIPA($E(X,1,30))=X1 S X="" K DIP K:DN Y W X
 X DXS(4,9.4) S X1=DIP(6) S:X]""&(X?.ANP)&(X1'[U)&(X1'["$C(94)") DIPA($E(X,1,30))=X1 S X="" K DIP K:DN Y W X
 X DXS(5,9.4) S X1=DIP(7) S:X]""&(X?.ANP)&(X1'[U)&(X1'["$C(94)") DIPA($E(X,1,30))=X1 S X="" K DIP K:DN Y W X
 X DXS(6,9.3) S X1=DIP(5) S:X]""&(X?.ANP)&(X1'[U)&(X1'["$C(94)") DIPA($E(X,1,30))=X1 S X="" K DIP K:DN Y W X
 S X=$S($D(DC)#2:DC,1:"") S X=X,DIP(1)=$G(X) S X="BEXPG",X1=DIP(1) S:X]""&(X?.ANP)&(X1'[U)&(X1'["$C(94)") DIPA($E(X,1,30))=X1 S X="" K DIP K:DN Y W X
 D N:$X>0 Q:'DN  W ?0 S X="BEXPAT",X=$S(X=""!(X'?.ANP):"",$D(DIPA($E(X,1,30))):DIPA($E(X,1,30)),1:"") K DIP K:DN Y W $E(X,1,17)
 W ?19 S X="BEXSSN",X=$S(X=""!(X'?.ANP):"",$D(DIPA($E(X,1,30))):DIPA($E(X,1,30)),1:"") K DIP K:DN Y W X
 W ?30 X DXS(7,9.2) S X=+$E(X,6,7) S Y=X,X=DIP(2),X=X S X=X_Y K DIP K:DN Y W $E(X,1,5)
 S X=$G(^VEXHRX0(19080.1,D0,0)) W ?37,$E($P(X,U,3),1,8)
 W ?47 S DIP(1)=$S($D(^VEXHRX0(19080.1,D0,0)):^(0),1:"") S X=$P(DIP(1),U,4),X=X K DIP K:DN Y W $E(X,1,1)
 S X=$G(^VEXHRX0(19080.1,D0,0)) W ?50 S Y=$P(X,U,11) S Y=$S(Y="":Y,$D(^PSDRUG(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,17)
 W ?69,$E($P(X,U,5),1,10)
 X DXS(8,9.2) S X1=DIP(1) S:X]""&(X?.ANP)&(X1'[U)&(X1'["$C(94)") DIPA($E(X,1,30))=X1 S X="" K DIP K:DN Y W X
 K Y
 Q
HEAD ;
 W !,?47,"T"
 W !,?47,"Y"
 W !,?47,"P"
 W !,?0,"PATIENT",?19,"HRCN",?30,"DATE",?37,"Rx #",?47,"E",?50,"Medication",?69,"RESULT"
 W !,"--------------------------------------------------------------------------------",!!
