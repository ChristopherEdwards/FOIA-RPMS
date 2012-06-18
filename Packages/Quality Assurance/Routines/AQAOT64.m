AQAOT64 ; GENERATED FROM 'AQAO HEADING' PRINT TEMPLATE (#1282) ; 05/13/96 ; (FILE 9002168.5, MARGIN=80)
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
 D N:$X>7 Q:'DN  W ?7 W "***** Confidential Patient/Provider Data Covered by Privacy Act *****"
 D N:$X>0 Q:'DN  W ?0 S X=$S('$D(DUZ(2)):"",DUZ(2)=0:"",1:$P(^DIC(4,DUZ(2),0),U)) W $E(X,1,30) K Y(9002168.5,99)
 D N:$X>59 Q:'DN  W ?59 S %=$P($H,",",2),X=DT_(%\60#60/100+(%\3600)+(%#60/10000)/100) S Y=X K DIP K:DN Y S Y=X D DT
 D N:$X>25 Q:'DN  W ?25 W ">>> ACTION PLAN SUMMARY <<<"
 D N:$X>0 Q:'DN  W ?0 W "=============================================================================="
 W ?0 W "  "
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
