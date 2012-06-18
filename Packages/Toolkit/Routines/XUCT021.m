XUCT021 ; GENERATED FROM 'XU-ZISPL-USER' PRINT TEMPLATE (#19) ; 10/05/92 ; (continued)
 G BEGIN
CP G CP^DIO2
C S DQ(C)=Y
S S Q(C)=Y*Y+Q(C) S:L(C)>Y L(C)=Y S:H(C)<Y H(C)=Y
P S N(C)=N(C)+1
A S S(C)=S(C)+Y
 Q
D I Y=DITTO(C) S Y="" Q
 S DITTO(C)=Y
 Q
N W !
T W:$X ! I '$D(DIOT(2)),DN,$D(IOSL),$S('$D(DIWF):1,$P(DIWF,"B",2):$P(DIWF,"B",2),1:1)+$Y'<IOSL,$D(^UTILITY($J,1))#2,^(1)?1U1P1E.E X ^(1)
 Q
DT I Y W $P("JAN^FEB^MAR^APR^MAY^JUN^JUL^AUG^SEP^OCT^NOV^DEC",U,$E(Y,4,5))_" " W:Y#100 $J(Y#100\1,2)_"," W Y\10000+1700 W:Y#1 "  "_$E(Y_0,9,10)_":"_$E(Y_"000",11,12) Q
 W Y Q
M D @DIXX
 Q
BEGIN ;
 S:'$D(DN) DN=1
 S I(1)=2,J(1)=3.5121 F D1=0:0 Q:$N(^XMB(3.51,D0,2,D1))'>0  X:$D(DSC(3.5121)) DSC(3.5121) S D1=$N(^(D1)) Q:D1'>0  D:$X>70 T Q:'DN  D A1
 G A1R
A1 ;
 D N:$X>9 Q:'DN  W ?9 S DIP(1)=$S($D(^XMB(3.51,D0,2,D1,0)):^(0),1:"") S X=$P(DIP(1),U,6),DIP(2)=X S X="CNT",X1=DIP(2) S:X]""&(X?.ANP) DIPA($E(X,1,30))=X1 S X="" K DIP K:DN Y W X
 W ?9 S X="CNT",X=$S(X=""!(X'?.ANP):"",$D(DIPA($E(X,1,30))):DIPA($E(X,1,30)),1:"") K DIP K:DN Y W X
 W $S(DIPA("CNT")>1:" copies",1:" copy")_" printed on " K DIP K:DN Y
 S X=$S($D(^XMB(3.51,D0,2,D1,0)):^(0),1:"") W ?0,$E($P(X,U,1),1,30)
 W " at "
 S Y=$P(X,U,5) D DT
 Q
A1R ;
 K Y
