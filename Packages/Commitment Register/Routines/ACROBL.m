ACROBL ; GENERATED FROM 'ACR REQUEST INFO' PRINT TEMPLATE (#3845) ; 09/29/09 ; (FILE 9002189, MARGIN=80)
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
 S I(0)="^ACROBL(",J(0)=9002189
 D N:$X>20 Q:'DN  W ?20 W "DOCUMENT NO......:"
 W ?40 S DIP(1)=$S($D(^ACROBL(D0,"DT")):^("DT"),1:"") S X=$S('$D(^ACRDOC(+$P(DIP(1),U,1),0)):"",1:$P(^(0),U,1)),DIP(2)=X S X=11,X=$J(DIP(2),X) K DIP K:DN Y W X
 D N:$X>20 Q:'DN  W ?20 W "ESTIMATED AMOUNT.:"
 W ?40 S DIP(1)=$S($D(^ACROBL(D0,0)):^(0),1:"") S X=$P(DIP(1),U,1),DIP(2)=X S X=11,X=$J(DIP(2),X) K DIP K:DN Y W X
 D N:$X>20 Q:'DN  W ?20 W "BRIEF NARRATIVE..:"
 S X=$G(^ACROBL(D0,"NOTES")) D N:$X>25 Q:'DN  W ?25,$E($P(X,U,1),1,48)
 D N:$X>25 Q:'DN  W ?25,$E($P(X,U,2),1,48)
 D N:$X>25 Q:'DN  W ?25,$E($P(X,U,3),1,48)
 D N:$X>25 Q:'DN  W ?25,$E($P(X,U,4),1,48)
 D N:$X>25 Q:'DN  W ?25,$E($P(X,U,5),1,48)
 S X=$G(^ACROBL(D0,"NOTES2")) D N:$X>25 Q:'DN  W ?25,$E($P(X,U,1),1,45)
 D N:$X>25 Q:'DN  W ?25,$E($P(X,U,2),1,45)
 D N:$X>25 Q:'DN  W ?25,$E($P(X,U,3),1,45)
 D N:$X>25 Q:'DN  W ?25,$E($P(X,U,4),1,45)
 D N:$X>25 Q:'DN  W ?25,$E($P(X,U,5),1,45)
 D N:$X>20 Q:'DN  W ?20 W "JUSTIFICATION....:"
 S X=$G(^ACROBL(D0,"JST")) D N:$X>25 Q:'DN  W ?25,$E($P(X,U,1),1,48)
 D N:$X>25 Q:'DN  W ?25,$E($P(X,U,2),1,48)
 D N:$X>25 Q:'DN  W ?25,$E($P(X,U,3),1,48)
 D N:$X>25 Q:'DN  W ?25,$E($P(X,U,4),1,48)
 D N:$X>25 Q:'DN  W ?25,$E($P(X,U,5),1,48)
 S X=$G(^ACROBL(D0,"JST2")) D N:$X>25 Q:'DN  W ?25,$E($P(X,U,1),1,48)
 D N:$X>25 Q:'DN  W ?25,$E($P(X,U,2),1,48)
 D N:$X>25 Q:'DN  W ?25,$E($P(X,U,3),1,48)
 D N:$X>25 Q:'DN  W ?25,$E($P(X,U,4),1,48)
 D N:$X>25 Q:'DN  W ?25,$E($P(X,U,5),1,48)
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
