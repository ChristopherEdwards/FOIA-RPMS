AQAQCHK1 ; GENERATED FROM 'AQAQCHKLST' PRINT TEMPLATE (#410) ; 03/01/90 ; (continued)
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
 D N:$X>31 Q:'DN  W ?31 X DXS(14,9.3) S X=$P($P(DIP(103),$C(59)_X_":",2),$C(59),1) S D0=I(0,0) S D1=I(1,0) K DIP,Y W X
 D N:$X>2 Q:'DN  W ?2 W "CME SUMMARY UPDATED:"
 S I(1)=4,J(1)=9002155.016 F D1=0:0 Q:$N(^AQAQ(D0,4,D1))'>0  X:$D(DSC(9002155.016)) DSC(9002155.016) S D1=$N(^(D1)) Q:D1'>0  D:$X>24 T Q:'DN  D C1
 G C1R
C1 ;
 S X=$S($D(^AQAQ(D0,4,D1,0)):^(0),1:"") D N:$X>31 Q:'DN  W ?31 S Y=$P(X,U,1) D DT
 Q
C1R ;
 D N:$X>2 Q:'DN  W ?2 W "PRIVILEGES REQUESTED:"
 S I(1)=10,J(1)=9002155.022 F D1=0:0 Q:$N(^AQAQ(D0,10,D1))'>0  X:$D(DSC(9002155.022)) DSC(9002155.022) S D1=$N(^(D1)) Q:D1'>0  D:$X>25 T Q:'DN  D D1
 G D1R
D1 ;
 S X=$S($D(^AQAQ(D0,10,D1,0)):^(0),1:"") D N:$X>31 Q:'DN  W ?31 S Y=$P(X,U,1) D DT
 Q
D1R ;
 D N:$X>2 Q:'DN  W ?2 W "PRIVILEGES GRANTED"
 S I(1)=10,J(1)=9002155.022 F D1=0:0 Q:$N(^AQAQ(D0,10,D1))'>0  X:$D(DSC(9002155.022)) DSC(9002155.022) S D1=$N(^(D1)) Q:D1'>0  D:$X>22 T Q:'DN  D E1
 G E1R
E1 ;
 S X=$S($D(^AQAQ(D0,10,D1,0)):^(0),1:"") D N:$X>31 Q:'DN  W ?31 S Y=$P(X,U,2) D DT
 Q
E1R ;
 D N:$X>2 Q:'DN  W ?2 W "CREDENTIALS APPROVED:"
 S I(1)=9,J(1)=9002155.01 F D1=0:0 Q:$N(^AQAQ(D0,9,D1))'>0  X:$D(DSC(9002155.01)) DSC(9002155.01) S D1=$N(^(D1)) Q:D1'>0  D:$X>25 T Q:'DN  D F1
 G F1R
F1 ;
 S X=$S($D(^AQAQ(D0,9,D1,0)):^(0),1:"") D N:$X>31 Q:'DN  W ?31 S Y=$P(X,U,1) D DT
 Q
F1R ;
 D N:$X>3 Q:'DN  W ?3 W ""
 D N:$X>2 Q:'DN  W ?2 W "RECREDENTIALING DUE DATE:"
 S X=$S($D(^AQAQ(D0,8)):^(8),1:"") D N:$X>31 Q:'DN  W ?31 S Y=$P(X,U,2) D DT
 D T Q:'DN  D N D N D N D N D N D N:$X>2 Q:'DN  W ?2 W "COMPUTER FILE LAST EDITED:"
 S X=$S($D(^AQAQ(D0,7)):^(7),1:"") D N:$X>31 Q:'DN  W ?31 S Y=$P(X,U,1) D DT
 D N:$X>25 Q:'DN  W ?25 W "BY:"
 D N:$X>31 Q:'DN  W ?31 X DXS(15,9.2) S X=$P(DIP(101),U,2) S D0=I(0,0) K DIP,Y W X
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
