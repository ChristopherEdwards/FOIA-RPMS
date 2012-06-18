ACRCSI ; GENERATED FROM 'ACR CONTROL SEQUENCE INFO' PRINT TEMPLATE (#3846) ; 09/30/09 ; (FILE 9002190, MARGIN=80)
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
 I $D(DXS)<9 M DXS=^DIPT(3846,"DXS")
 S I(0)="^ACRAPVS(",J(0)=9002190
 D N:$X>0 Q:'DN  W ?0 W "ORDER:"
 S X=$G(^ACRAPVS(D0,0)) W ?8 S Y=$P(X,U,4) W:Y]"" $J(Y,3,0)
 D N:$X>14 Q:'DN  W ?14 W "DOCUMENT:"
 W ?25 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^ACRDOC(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,17)
 D N:$X>49 Q:'DN  W ?49 W "DATE IN:"
 S X=$G(^ACRAPVS(D0,"DT")) W ?59 S Y=$P(X,U,3) D DT
 D N:$X>14 Q:'DN  W ?14 W "CATEGORY:"
 S X=$G(^ACRAPVS(D0,0)) W ?25 S Y=$P(X,U,3) S Y=$S(Y="":Y,$D(^ACRAPVT(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,20)
 D N:$X>48 Q:'DN  W ?48 W "DATE OUT:"
 S X=$G(^ACRAPVS(D0,"DT")) W ?59 S Y=$P(X,U,4) D DT
 D N:$X>13 Q:'DN  W ?13 W "SIGNATORE:"
 W ?25 S Y=$P(X,U,2) S Y(0)=Y S Y=$$NAME2^ACRFUTL1(Y) W $E(Y,1,30)
 D N:$X>16 Q:'DN  W ?16 W "STATUS:"
 S X=$G(^ACRAPVS(D0,"DT")) W ?25 S Y=$P(X,U,1) W:Y]"" $S($D(DXS(1,Y)):DXS(1,Y),1:Y)
 D N:$X>51 Q:'DN  W ?51 W "FINAL:"
 W ?59 S Y=$P(X,U,5) W:Y]"" $S($D(DXS(2,Y)):DXS(2,Y),1:Y)
 W ?64 I $D(^ACRAPVS(D0,"CNG")) W !?14,"COMMENTS: " K DIP K:DN Y
 S X=$G(^ACRAPVS(D0,"CNG")) D N:$X>25 Q:'DN  W ?25,$E($P(X,U,1),1,40)
 D N:$X>25 Q:'DN  W ?25,$E($P(X,U,2),1,40)
 D N:$X>25 Q:'DN  W ?25,$E($P(X,U,3),1,40)
 D N:$X>25 Q:'DN  W ?25,$E($P(X,U,4),1,40)
 D N:$X>25 Q:'DN  W ?25,$E($P(X,U,5),1,40)
 S X=$G(^ACRAPVS(D0,"RSN")) D N:$X>25 Q:'DN  W ?25,$E($P(X,U,1),1,40)
 D N:$X>25 Q:'DN  W ?25,$E($P(X,U,2),1,40)
 D N:$X>25 Q:'DN  W ?25,$E($P(X,U,3),1,40)
 D N:$X>25 Q:'DN  W ?25,$E($P(X,U,4),1,40)
 D N:$X>25 Q:'DN  W ?25,$E($P(X,U,5),1,40)
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
