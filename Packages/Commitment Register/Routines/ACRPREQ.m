ACRPREQ ; GENERATED FROM 'ACR REQUISITION HEAD' PRINT TEMPLATE (#3855) ; 09/30/09 ; (FILE 9002196, MARGIN=80)
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
 I $D(DXS)<9 M DXS=^DIPT(3855,"DXS")
 S I(0)="^ACRDOC(",J(0)=9002196
 S X=$G(^ACRDOC(D0,"REQ")) D N:$X>3 Q:'DN  W ?3 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^AUTTPRG(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 W ?35 X DXS(1,9) K DIP K:DN Y
 S X=$G(^ACRDOC(D0,"REQ")) D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 S Y=$P(X,U,3) S Y=$S(Y="":Y,$D(^AUTTPRG(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 D N:$X>39 Q:'DN  W ?39 S Y=$P(X,U,4) S Y=$S(Y="":Y,$D(^AUTTLCOD(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 D N:$X>60 Q:'DN  W ?60 S DIP(1)=$S($D(^ACRDOC(D0,"REQ")):^("REQ"),1:"") S X=$P(DIP(1),U,5) S:X X=$E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3) K DIP K:DN Y W X
 D N:$X>69 Q:'DN  W ?69 X DXS(2,9.2) S X=$S('$D(^AUTTOBJC(+$P(DIP(101),U,3),0)):"",1:$P(^(0),U,1)) S D0=I(0,0) K DIP K:DN Y W X
 S X=$G(^ACRDOC(D0,"REQ")) D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 S Y=$P(X,U,7) S Y(0)=Y S Y=$$NAME2^ACRFUTL1(Y) W $E(Y,1,30)
 S X=$G(^ACRDOC(D0,"REQ")) D N:$X>37 Q:'DN  W ?37,$E($P(X,U,8),1,12)
 D N:$X>59 Q:'DN  W ?59 X DXS(3,9.3) S X=$S('$D(^AUTTPRO(+$P(DIP(201),U,4),0)):"",1:$P(^(0),U,1)) S D0=I(0,0) K DIP K:DN Y W X
 S X=$G(^ACRDOC(D0,"REQ1")) D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^AUTTPRG(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 S X=$G(^ACRDOC(D0,"REQ")) D N:$X>59 Q:'DN  W ?59 S Y=$P(X,U,10) S Y=$S(Y="":Y,$D(^ACRCAN(Y,0))#2:$P(^(0),U),1:Y) S Y=$S(Y="":Y,$D(^AUTTCAN(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,7)
 S X=$G(^ACRDOC(D0,"REQ1")) D N:$X>0 Q:'DN  W ?0,$E($P(X,U,2),1,40)
 D N:$X>0 Q:'DN  W ?0,$E($P(X,U,4),1,15)
 W ?17 S Y=$P(X,U,5) S Y=$S(Y="":Y,$D(^DIC(5,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,20)
 W ?39,$E($P(X,U,8),1,10)
 S X=$G(^ACRDOC(D0,"REQ")) D N:$X>59 Q:'DN  W ?59 S Y=$P(X,U,11) D DT
 D T Q:'DN  W ?2 W !!!?10 K DIP K:DN Y
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
