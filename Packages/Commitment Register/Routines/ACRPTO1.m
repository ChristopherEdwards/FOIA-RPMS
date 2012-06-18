ACRPTO1 ; GENERATED FROM 'ACR TRAVEL ORDER' PRINT TEMPLATE (#3864) ; 09/30/09 ; (continued)
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
 D ^ACRFPAPV K DIP K:DN Y
 D N:$X>3 Q:'DN  W ?3 W "IHS 530 (6/94) Computerized Modification of Travel Order HHS-1 (Rev. 8/86)"
 D DISPLAY^ACRFSS42 K DIP K:DN Y
 K DXS K DIP K:DN Y
 S D0=ACRDOCDA K DIP K:DN Y
 D:'$D(ACRITINY)#2&'$D(ACRREV)#2 ^ACRPTI K DIP K:DN Y
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
