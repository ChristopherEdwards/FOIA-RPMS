AGTMPE ; GENERATED FROM 'AG TM EMPLOYER' PRINT TEMPLATE (#668) ; 02/14/06 ; (FILE 9999999.75, MARGIN=80)
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
 I $D(DXS)<9 M DXS=^DIPT(668,"DXS")
 S I(0)="^AUTNEMPL(",J(0)=9999999.75
 S X=$G(^AUTNEMPL(D0,0)) D T Q:'DN  D N W ?0,$E($P(X,U,1),1,25)
 D N:$X>39 Q:'DN  W ?39,$E($P(X,U,6),1,13)
 I $P(X,U,2)]"" W !,"" K DIP K:DN Y
 S X=$G(^AUTNEMPL(D0,0)) D N:$X>2 Q:'DN  W ?2,$E($P(X,U,2),1,40)
 Q:$P(X,U,3)=""  W !,"" K DIP K:DN Y
 S X=$G(^AUTNEMPL(D0,0)) D N:$X>2 Q:'DN  W ?2,$E($P(X,U,3),1,12)
 I $P(X,U,3)]"" W ", " K DIP K:DN Y
 X DXS(1,9.2) S X=$P(DIP(101),U,2) S D0=I(0,0) K DIP K:DN Y W X
 W "  " K DIP K:DN Y
 S X=$G(^AUTNEMPL(D0,0)) W ?0,$E($P(X,U,5),1,10)
 K Y
 Q
HEAD ;
 W !,?0,"EMPLOYER",?39,"PHONE"
 W !,"--------------------------------------------------------------------------------",!!
