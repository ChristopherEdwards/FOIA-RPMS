ACRPTRG2 ; GENERATED FROM 'ACR TRAINING 350' PRINT TEMPLATE (#3867) ; 09/29/09 ; (continued)
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
 X DXS(17,9.3) S X=$P(DIP(201),U,2) S D0=I(0,0) K DIP K:DN Y W X
 W "  "
 X DXS(18,9.2) S X=$P(DIP(101),U,5) S D0=I(0,0) K DIP K:DN Y W X
 D N:$X>39 Q:'DN  W ?39 X DXS(19,9.2) S X=$P(DIP(101),U,3) S D0=I(0,0) K DIP K:DN Y W X
 W ", "
 X DXS(20,9.3) S X=$P(DIP(201),U,2) S D0=I(0,0) K DIP K:DN Y W X
 W "  "
 X DXS(21,9.2) S X=$P(DIP(101),U,5) S D0=I(0,0) K DIP K:DN Y W X
 D N:$X>0 Q:'DN  W ?0 W "PHONE:"
 W ?8 X DXS(22,9.2) S X=$P(DIP(101),U,6) S D0=I(0,0) K DIP K:DN Y W X
 D N:$X>39 Q:'DN  W ?39 W "PHONE:"
 W ?47 X DXS(23,9.2) S X=$P(DIP(101),U,6) S D0=I(0,0) K DIP K:DN Y W X
 D N:$X>0 Q:'DN  W ?0 W "--------------------------------------------------------------------------------"
 D N:$X>0 Q:'DN  W ?0 W "IHS 844 (11/95) Computerized Mod TRAINING NOMINATION & AUTHORIZATION (HHS 350)"
 D T Q:'DN  W ?2 D PAUSE^ACRFWARN,EXIT^ACRFCLM K DIP K:DN Y
 I $D(^ACRTPAR("C",ACRDOCDA)) S ACRTPAR="" D LIST^ACRFTPAR K DIP K:DN Y
 I $D(ACRTVAL) W @IOF K DXS D ^ACRPTE K ACRTVAL K DIP K:DN Y
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
