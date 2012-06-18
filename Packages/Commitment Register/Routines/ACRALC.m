ACRALC ; GENERATED FROM 'ACR SUB-ALLOWANCE INFO' PRINT TEMPLATE (#3842) ; 09/29/09 ; (FILE 9002187, MARGIN=80)
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
 I $D(DXS)<9 M DXS=^DIPT(3842,"DXS")
 S I(0)="^ACRALC(",J(0)=9002187
 D N:$X>20 Q:'DN  W ?20 W "AMOUNT...........:"
 S X=$G(^ACRALC(D0,0)) W ?40 S Y=$P(X,U,1) W:Y]"" $J(Y,11,2)
 D N:$X>20 Q:'DN  W ?20 W "ORIGINAL/AMENDMNT:"
 W ?40 X DXS(1,9.2) S DIP(3)=X S X=11,X=$J(DIP(3),X) K DIP K:DN Y W X
 D N:$X>20 Q:'DN  W ?20 W "FISCAL YEAR......:"
 W ?40 S DIP(1)=$S($D(^ACRALC(D0,"DT")):^("DT"),1:"") S X=$P(DIP(1),U,1),DIP(2)=X S X=11,X=$J(DIP(2),X) K DIP K:DN Y W X
 D N:$X>20 Q:'DN  W ?20 W "RECURRING/NON-REC:"
 W ?40 X DXS(2,9.2) S DIP(3)=X S X=11,X=$J(DIP(3),X) K DIP K:DN Y W X
 D N:$X>20 Q:'DN  W ?20 W "APPROPRIATION NO.:"
 W ?40 S DIP(1)=$S($D(^ACRALC(D0,"DT")):^("DT"),1:"") S X=$S('$D(^AUTTPRO(+$P(DIP(1),U,4),0)):"",1:$P(^(0),U,1)),DIP(2)=X S X=11,X=$J(DIP(2),X) K DIP K:DN Y W X
 D N:$X>20 Q:'DN  W ?20 W "ACCOUNTING POINT.:"
 W ?40 S DIP(1)=$S($D(^ACRALC(D0,"DT")):^("DT"),1:"") S X=$S('$D(^AUTTACPT(+$P(DIP(1),U,13),0)):"",1:$P(^(0),U,1)),DIP(2)=X S X=11,X=$J(DIP(2),X) K DIP K:DN Y W X
 D N:$X>20 Q:'DN  W ?20 W "ALLOWANCE........:"
 W ?40 S DIP(1)=$S($D(^ACRALC(D0,"DT")):^("DT"),1:"") S X=$S('$D(^AUTTALLW(+$P(DIP(1),U,5),0)):"",1:$P(^(0),U,1)),DIP(2)=X S X=11,X=$J(DIP(2),X) K DIP K:DN Y W X
 D N:$X>20 Q:'DN  W ?20 W "SUB-SUB-ACTIVITY.:"
 W ?40 X DXS(3,9.2) S X=$P(DIP(101),U,3),DIP(102)=X S X=11,X=$J(DIP(102),X) S D0=I(0,0) K DIP K:DN Y W X
 D N:$X>20 Q:'DN  W ?20 W "LOCATION CODE....:"
 S X=$G(^ACRALC(D0,"DT")) W ?40 S Y=$P(X,U,11) S Y=$S(Y="":Y,$D(^AUTTLCOD(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 X DXS(4,9.2) S X=$P(DIP(101),U,2) S D0=I(0,0) K DIP K:DN Y W X
 W " "
 X DXS(5,9.2) S X=$P(DIP(101),U,2) S D0=I(0,0) K DIP K:DN Y W X
 D N:$X>20 Q:'DN  W ?20 W "COST CENTER......:"
 S X=$G(^ACRALC(D0,"DT")) W ?40 S Y=$P(X,U,10) S Y=$S(Y="":Y,$D(^AUTTCCT(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,2)
 D N:$X>20 Q:'DN  W ?20 W "CREATE NEXT FY...:"
 S X=$G(^ACRALC(D0,0)) W ?40 S Y=$P(X,U,16) W:Y]"" $S($D(DXS(6,Y)):DXS(6,Y),1:Y)
 D N:$X>20 Q:'DN  W ?20 W "PURPOSE..........:"
 S X=$G(^ACRALC(D0,"PURP")) D N:$X>25 Q:'DN  W ?25,$E($P(X,U,1),1,45)
 D N:$X>25 Q:'DN  W ?25,$E($P(X,U,2),1,45)
 D N:$X>25 Q:'DN  W ?25,$E($P(X,U,3),1,45)
 D N:$X>25 Q:'DN  W ?25,$E($P(X,U,4),1,45)
 D N:$X>25 Q:'DN  W ?25,$E($P(X,U,5),1,45)
 D N:$X>20 Q:'DN  W ?20 W "COMMENT..........:"
 S X=$G(^ACRALC(D0,"CMT")) D N:$X>25 Q:'DN  W ?25,$E($P(X,U,1),1,45)
 D N:$X>25 Q:'DN  W ?25,$E($P(X,U,2),1,45)
 D N:$X>25 Q:'DN  W ?25,$E($P(X,U,3),1,45)
 D N:$X>25 Q:'DN  W ?25,$E($P(X,U,4),1,45)
 D N:$X>25 Q:'DN  W ?25,$E($P(X,U,5),1,45)
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
