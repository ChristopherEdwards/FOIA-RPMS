ABPABAT ; GENERATED FROM 'ABPABAT' PRINT TEMPLATE (#735) ; 08/29/91 ; (FILE 9002270.04, MARGIN=80)
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
 I $D(DXS)<9 F X=0:0 S X=$O(^DIPT(735,"DXS",X)) Q:'X  S Y=$O(^(X,"")) F X=X:0 Q:Y=""  S DXS(X,Y)=^(Y),Y=$O(^(Y))
 D N:$X>0 Q:'DN  W ?0 X DXS(1,9.2) S X=X_Y,X=$J("",$S($D(DIWR)+$D(DIWL)=2:DIWR-DIWL+1,$D(IOM):IOM,1:80)-$L(X)\2-$X)_X K DIP K:DN Y W X
 D T Q:'DN  D N D N:$X>25 Q:'DN  W ?25 W "CHECK LOG TOTAL:"
 S X=$S($D(^ABPAPBAT(D0,0)):^(0),1:"") D N:$X>43 Q:'DN  W ?43 S Y=$P(X,U,10) W:Y]"" $J(Y,10,2)
 D N:$X>20 Q:'DN  W ?20 W "INTER-FUND ADDITIONS:"
 D N:$X>43 Q:'DN  W ?43 S Y=$P(X,U,13) W:Y]"" $J(Y,10,2)
 D N:$X>29 Q:'DN  W ?29 W "ADJUSTMENTS:"
 D N:$X>42 Q:'DN  W ?42 W "<"
 D N:$X>43 Q:'DN  W ?43 S Y=$P(X,U,12) W:Y]"" $J(Y,10,2)
 D N:$X>53 Q:'DN  W ?53 W ">"
 D N:$X>19 Q:'DN  W ?19 W "COLLECTIONS PROCESSED:"
 D N:$X>42 Q:'DN  W ?42 W "<"
 D N:$X>43 Q:'DN  W ?43 S Y=$P(X,U,2) W:Y]"" $J(Y,10,2)
 D N:$X>53 Q:'DN  W ?53 W ">"
 D N:$X>42 Q:'DN  W ?42 W "------------"
 D N:$X>17 Q:'DN  W ?17 W "BALANCE TO BE PROCESSED:"
 D N:$X>43 Q:'DN  W ?43 X DXS(2,9.2) S X=$J(DIP(2),DIP(3),X) K DIP K:DN Y W $J(X,10)
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
