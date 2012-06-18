ACRDHR ; GENERATED FROM 'ACR DHR' PRINT TEMPLATE (#3949) ; 09/29/09 ; (FILE 9002189.1, MARGIN=80)
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
 S I(0)="^ACRDHR(",J(0)=9002189.1
 D N:$X>0 Q:'DN  W ?0 W "DHR RECORD TYPE.....:"
 S X=$G(^ACRDHR(D0,1)) W ?23 S Y=$P(X,U,1) W:Y]"" $J(Y,2,0)
 D N:$X>0 Q:'DN  W ?0 W "EFFECTIVE DATE......:"
 W ?23 S Y=$P(X,U,2) D DT
 D N:$X>0 Q:'DN  W ?0 W "TRANSACTION CODE....:"
 W ?23,$E($P(X,U,3),1,3)
 D N:$X>0 Q:'DN  W ?0 W "REVERSE CODE........:"
 W ?23 S Y=$P(X,U,4) W:Y]"" $J(Y,2,0)
 D N:$X>0 Q:'DN  W ?0 W "MODIFIER CODE.......:"
 W ?23 S Y=$P(X,U,5) W:Y]"" $J(Y,2,0)
 D N:$X>0 Q:'DN  W ?0 W "DOCUMENT REF. CODE..:"
 W ?23,$E($P(X,U,6),1,3)
 D N:$X>0 Q:'DN  W ?0 W "DOCUMENT NUMBER.....:"
 W ?23,$E($P(X,U,7),1,10)
 D N:$X>0 Q:'DN  W ?0 W "SECONDARY DOC. REF..:"
 W ?23,$E($P(X,U,8),1,3)
 D N:$X>0 Q:'DN  W ?0 W "SECONDARY DOC NUMBER:"
 W ?23,$E($P(X,U,9),1,10)
 D N:$X>0 Q:'DN  W ?0 W "GEOGRAPHIC CODE.....:"
 W ?23 S Y=$P(X,U,10) W:Y]"" $J(Y,2,0)
 D N:$X>0 Q:'DN  W ?0 W "FISCAL YEAR.........:"
 W ?23 S Y=$P(X,U,11) W:Y]"" $J(Y,2,0)
 D N:$X>0 Q:'DN  W ?0 W "COMMON ACCOUNTING NO:"
 W ?23,$E($P(X,U,12),1,7)
 D N:$X>0 Q:'DN  W ?0 W "OBJECT CLASS CODE...:"
 W ?23,$E($P(X,U,13),1,4)
 D N:$X>0 Q:'DN  W ?0 W "DOLLAR AMOUNT.......:"
 W ?23 S Y=$P(X,U,14) W:Y]"" $J(Y,13,0)
 D N:$X>0 Q:'DN  W ?0 W "FED/NON-FED.........:"
 W ?23 S Y=$P(X,U,15) W:Y]"" $J(Y,2,0)
 D N:$X>0 Q:'DN  W ?0 W "VENDOR CODE-PRIMARY.:"
 W ?23,$E($P(X,U,16),1,15)
 D N:$X>0 Q:'DN  W ?0 W "VENDOR CODE-SECONDRY:"
 W ?23,$E($P(X,U,17),1,15)
 D N:$X>0 Q:'DN  W ?0 W "PAY/COLLECT DOC. NUM:"
 W ?23,$E($P(X,U,18),1,10)
 D N:$X>0 Q:'DN  W ?0 W "TRAVEL BEGIN DATE...:"
 W ?23,$E($P(X,U,26),1,4)
 D N:$X>0 Q:'DN  W ?0 W "TRAVEL END DATE.....:"
 W ?23,$E($P(X,U,27),1,4)
 D N:$X>0 Q:'DN  W ?0 W "2 DIGIT FISCAL YEAR.:"
 W ?23,$E($P(X,U,28),1,2)
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
