ACRPTTS ; GENERATED FROM 'ACR DOCUMENT STATUS SUMMARY' PRINT TEMPLATE (#3858) ; 09/29/09 ; (FILE 9002190, MARGIN=80)
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
 I $D(DXS)<9 M DXS=^DIPT(3858,"DXS")
 S I(0)="^ACRAPVS(",J(0)=9002190
 D N:$X>0 Q:'DN  W ?0 W "DOCUMENT:"
 S X=$G(^ACRAPVS(D0,0)) W ?11 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^ACRDOC(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,17)
 D N:$X>40 Q:'DN  W ?40 W "IDENTIFIER:"
 W ?53 X DXS(1,9.2) S X=$P(DIP(101),U,14) S D0=I(0,0) K DIP K:DN Y W X
 D N:$X>2 Q:'DN  W ?2 W "STATUS:  WAITING FOR "
 X DXS(2,9.2) S X=$P(DIP(2),DIP(3),X),DIP(4)=X S X=" ",X=$P(DIP(4),X) K DIP K:DN Y W X
 W " "
 S DIP(1)=$S($D(^ACRAPVS(D0,"DT")):^("DT"),1:"") S X=$S('$D(^VA(200,+$P(DIP(1),U,2),0)):"",1:$P(^(0),U,1)),DIP(2)=X S X=",",X=$P(DIP(2),X) K DIP K:DN Y W X
 W " TO SIGN"
 D N:$X>6 Q:'DN  W ?6 W "AS:"
 S X=$G(^ACRAPVS(D0,0)) W ?11 S Y=$P(X,U,3) S Y=$S(Y="":Y,$D(^ACRAPVT(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
