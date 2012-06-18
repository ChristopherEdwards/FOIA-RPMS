AQAOT93 ; GENERATED FROM 'AQAO AUTO WRKSHT HEADING' PRINT TEMPLATE (#1315) ; 05/13/96 ; (FILE 9002167, MARGIN=80)
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
 D N:$X>9 Q:'DN  W ?9 W "***** Confidential Patient Data Covered by Privacy Act *****"
 S X=$G(^AQAOC(D0,0)) D N:$X>0 Q:'DN  W ?0 S Y=$P(X,U,9) S Y=$S(Y="":Y,$D(^AUTTLOC(Y,0))#2:$P(^(0),U,1),1:Y) S Y=$S(Y="":Y,$D(^DIC(4,Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,30)
 D N:$X>59 Q:'DN  W ?59 S %=$P($H,",",2),X=DT_(%\60#60/100+(%\3600)+(%#60/10000)/100) S Y=X K DIP K:DN Y S Y=X D DT
 D N:$X>20 Q:'DN  W ?20 W ">>> INDIVIDUAL OCCURRENCE WORKSHEET <<<"
 D N:$X>0 Q:'DN  W ?0 W "==============================================================================="
 D N:$X>0 Q:'DN  W ?0 W "  "
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
