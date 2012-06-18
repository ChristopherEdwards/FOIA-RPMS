ACRRRH ; GENERATED FROM 'ACR RECEIVING REPORT HEAD' PRINT TEMPLATE (#3899) ; 09/29/09 ; (FILE 9002196, MARGIN=80)
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
 I $D(DXS)<9 M DXS=^DIPT(3899,"DXS")
 S I(0)="^ACRDOC(",J(0)=9002196
 W ?0 W @IOF K DIP K:DN Y
 W ?11 I 1 S:'$D(ACRPAGE) ACRPAGE=1 K DIP K:DN Y
 D N:$X>9 Q:'DN  W ?9 W "INDIAN HEALTH SERVICE"
 D N:$X>9 Q:'DN  W ?9 W "RECEIVING AND INSPECTION REPORT"
 D N:$X>64 Q:'DN  W ?64 W "PAGE: "
 W ACRPAGE K DIP K:DN Y
 D T Q:'DN  D N D N:$X>9 Q:'DN  W ?9 X DXS(1,9.2) S DIP(101)=$S($D(^ACROBL(D0,"APV")):^("APV"),1:"") S X=$P($P(DIP(102),$C(59)_$P(DIP(101),U,6)_":",2),$C(59)) S D0=I(0,0) K DIP K:DN Y W X
 D T Q:'DN  D N W ?0 W "PURCHASE ORDER NO.:"
 S X=$G(^ACRDOC(D0,0)) W ?21,$E($P(X,U,2),1,15)
 D N:$X>39 Q:'DN  W ?39 W "ORDER DATE:"
 S X=$G(^ACRDOC(D0,"PO")) W ?52 S Y=$P(X,U,1) D DT
 D N:$X>4 Q:'DN  W ?4 W "DHHS ORDER NO.:  "
 W $$EXPDN^ACRFUTL(D0) K DIP K:DN Y
 D N:$X>0 Q:'DN  W ?0 W "--------------------------------------------------------------------------------"
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
