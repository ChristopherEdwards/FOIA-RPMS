ABPAPDA ; GENERATED FROM 'ABPAPDA' PRINT TEMPLATE (#734) ; 08/29/91 ; (FILE 9002270.02, MARGIN=80)
 G BEGIN
N W !
T W:$X ! I '$D(DIOT(2)),DN,$D(IOSL),$S('$D(DIWF):1,$P(DIWF,"B",2):$P(DIWF,"B",2),1:1)+$Y'<IOSL,$D(^UTILITY($J,1))#2,^(1)?1U1P1E.E X ^(1)
 Q
DT I Y W $P("JAN^FEB^MAR^APR^MAY^JUN^JUL^AUG^SEP^OCT^NOV^DEC",U,$E(Y,4,5))_" " W:Y#100 $J(Y#100\1,2)_"," W Y\10000+1700 W:Y#1 "  "_$E(Y_0,9,10)_":"_$E(Y_"000",11,12) Q
 W Y Q
M D @DIXX
 Q
BEGIN ;
 S:'$D(DN) DN=1
 W ?0 S X=DT S X=X S:X X=$E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3) K DIP K:DN Y W X
 S X="AO PRIVATE INSURANCE SYSTEM",X=$J("",$S($D(DIWR)+$D(DIWL)=2:DIWR-DIWL+1,$D(IOM):IOM,1:80)-$L(X)\2-$X)_X K DIP K:DN Y W X
 D N:$X>72 Q:'DN  W ?72 W "Page:"
 D N:$X>78 Q:'DN  W ?78 S X=$S($D(DC)#2:DC,1:"") K DIP K:DN Y W $E(X,1,2)
 D N:$X>0 Q:'DN  W ?0 S X="*** BILL/PAYMENTS SCREEN ***",X=$J("",$S($D(DIWR)+$D(DIWL)=2:DIWR-DIWL+1,$D(IOM):IOM,1:80)-$L(X)\2-$X)_X K DIP K:DN Y W X
 D N:$X>0 Q:'DN  W ?0 W "================================================================================"
 D N:$X>0 Q:'DN  W ?0 W "Patient:"
 D N:$X>9 Q:'DN  W ?9 S DIP(1)=$S($D(^ABPVAO(D0,0)):^(0),1:"") S X=$P(DIP(1),U,1)_"  ("_$P(DIP(1),U,3)_")" K DIP K:DN Y W X
 D N:$X>51 Q:'DN  W ?51 W "Facility:"
 S X=$S($D(^ABPVAO(D0,0)):^(0),1:"") D N:$X>61 Q:'DN  W ?61 S Y=$P(X,U,2) S Y=$S(Y="":Y,$D(^AUTTLOC(Y,0))#2:$P(^(0),U,1),1:Y) S Y=$S(Y="":Y,$D(^DIC(4,Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,19)
 D N:$X>0 Q:'DN  W ?0 W "--------------------------------------------------------------------------------"
 D N:$X>0 Q:'DN  W ?0 S X="Bill Information",X=$J("",$S($D(DIWR)+$D(DIWL)=2:DIWR-DIWL+1,$D(IOM):IOM,1:80)-$L(X)\2-$X)_X K DIP K:DN Y W X
 D T Q:'DN  D N W ?0 W "   Bill #    DOS     Billed  Penalty Non-Cov. Deduct.  Payment Writeoff  Balance"
 D N:$X>0 Q:'DN  W ?0 W "  ------- -------- -------- -------- -------- ------- -------- -------- --------"
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
