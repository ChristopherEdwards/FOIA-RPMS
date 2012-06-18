AQAOT69 ; GENERATED FROM 'AQAO VISIT DATA' PRINT TEMPLATE (#1312) ; 05/13/96 ; (FILE 9000010, MARGIN=80)
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
 I $D(DXS)<9 F X=0:0 S X=$O(^DIPT(1312,"DXS",X)) Q:'X  S Y=$O(^(X,"")) F X=X:0 Q:Y=""  S DXS(X,Y)=^(Y),Y=$O(^(Y))
 D N:$X>0 Q:'DN  W ?0 W "Patient Name:  "
 S X=$G(^AUPNVSIT(D0,0)) S Y=$P(X,U,5) S Y=$S(Y="":Y,$D(^AUPNPAT(Y,0))#2:$P(^(0),U,1),1:Y) S Y=$S(Y="":Y,$D(^DPT(Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,30)
 D N:$X>39 Q:'DN  W ?39 W "Chart #:  "
 S APCDLOOK=DUZ(2) K DIP K:DN Y
 X DXS(1,9.3) S DIP(202)=$S($D(^AUPNPAT(D0,41,D1,0)):^(0),1:"") S X=$P(DIP(202),U,2) S D0=I(0,0) S D1=I(101,0) K DIP K:DN Y W X
 W ?51 K APCDLOOK K DIP K:DN Y
 D N:$X>2 Q:'DN  W ?2 W "Visit Date:  "
 S X=$G(^AUPNVSIT(D0,0)) S Y=$P(X,U,1) D DT
 D N:$X>39 Q:'DN  W ?39 S Y=$P(X,U,7) W:Y]"" $S($D(DXS(2,Y)):DXS(2,Y),1:Y)
 W ?61 S Y=$P(X,U,8) S Y=$S(Y="":Y,$D(^DIC(40.7,Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,15)
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
