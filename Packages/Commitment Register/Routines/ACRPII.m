ACRPII ; GENERATED FROM 'ACR ITEM INVENTORY' PRINT TEMPLATE (#3844) ; 09/29/09 ; (FILE 9002193, MARGIN=80)
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
 S I(0)="^ACRSS(",J(0)=9002193
 D N:$X>0 Q:'DN  W ?0 W "ITEM #...:"
 S X=$G(^ACRSS(D0,0)) W ?12 S Y=$P(X,U,1) W:Y]"" $J(Y,4,0)
 D N:$X>26 Q:'DN  W ?26 W "ORDER #..:"
 S X=$G(^ACRSS(D0,"NMS")) W ?38,$E($P(X,U,1),1,30)
 D N:$X>53 Q:'DN  W ?53 W "DOCUMNT #:"
 S X=$G(^ACRSS(D0,0)) W ?65 S Y=$P(X,U,3) S Y=$S(Y="":Y,$D(^ACRDOC(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,14)
 D N:$X>0 Q:'DN  W ?0 W "NSN......:"
 S X=$G(^ACRSS(D0,"NMS")) W ?12,$E($P(X,U,2),1,17)
 D N:$X>26 Q:'DN  W ?26 W "NDC......:"
 W ?38,$E($P(X,U,3),1,14)
 D N:$X>53 Q:'DN  W ?53 W "VON......:"
 S X=$G(^ACRSS(D0,"VND")) W ?65,$E($P(X,U,2),1,14)
 D N:$X>0 Q:'DN  W ?0 W "VENDOR...:"
 W ?12 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^AUTTVNDR(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 D N:$X>53 Q:'DN  W ?53 W "OBJ CLASS:"
 S X=$G(^ACRSS(D0,0)) W ?65 S Y=$P(X,U,4) S Y=$S(Y="":Y,$D(^AUTTOBJC(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,4)
 D N:$X>0 Q:'DN  W ?0 W "# ORDERED:"
 W ?12 S DIP(1)=$S($D(^ACRSS(D0,"DT")):^("DT"),1:"") S X=$P(DIP(1),U,1),DIP(2)=X S X=10,X=$J(DIP(2),X) K DIP K:DN Y W X
 D N:$X>26 Q:'DN  W ?26 W "UNIT COST:"
 W ?38 S DIP(1)=$S($D(^ACRSS(D0,"DT")):^("DT"),1:"") S X=$P(DIP(1),U,3),DIP(2)=X S X=10,DIP(3)=X S X=2,X=$J(DIP(2),DIP(3),X) K DIP K:DN Y W X
 D N:$X>53 Q:'DN  W ?53 W "EST TOTAL:"
 W ?65 S DIP(1)=$S($D(^ACRSS(D0,"DT")):^("DT"),1:"") S X=$P(DIP(1),U,4),DIP(2)=X S X=10,DIP(3)=X S X=2,X=$J(DIP(2),DIP(3),X) K DIP K:DN Y W X
 D N:$X>0 Q:'DN  W ?0 W "UNIT ISSU:"
 W ?12 S DIP(1)=$S($D(^ACRSS(D0,"DT")):^("DT"),1:"") S X=$S('$D(^ACRUI(+$P(DIP(1),U,2),0)):"",1:$P(^(0),U,1)),DIP(2)=X S X=10,X=$J(DIP(2),X) K DIP K:DN Y W X
 D N:$X>26 Q:'DN  W ?26 W "# ACCEPTD:"
 W ?38 S DIP(1)=$S($D(^ACRSS(D0,"DT")):^("DT"),1:"") S X=$P(DIP(1),U,6),DIP(2)=X S X=10,X=$J(DIP(2),X) K DIP K:DN Y W X
 D N:$X>53 Q:'DN  W ?53 W "TOTL PAID:"
 W ?65 S DIP(1)=$S($D(^ACRSS(D0,"DT")):^("DT"),1:"") S X=$P(DIP(1),U,21),DIP(2)=X S X=10,DIP(3)=X S X=2,X=$J(DIP(2),DIP(3),X) K DIP K:DN Y W X
 D T Q:'DN  D N D N:$X>9 Q:'DN  W ?9 W "DESCRIPTION"
 D N:$X>9 Q:'DN  W ?9 W "---------------------------------------------"
 S X=$G(^ACRSS(D0,"DESC")) D N:$X>9 Q:'DN  W ?9,$E($P(X,U,1),1,30)
 D N:$X>9 Q:'DN  W ?9,$E($P(X,U,2),1,30)
 D N:$X>9 Q:'DN  W ?9,$E($P(X,U,3),1,30)
 D N:$X>9 Q:'DN  W ?9,$E($P(X,U,4),1,30)
 D N:$X>9 Q:'DN  W ?9,$E($P(X,U,5),1,30)
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
