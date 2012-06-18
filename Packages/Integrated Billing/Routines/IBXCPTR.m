IBXCPTR ; GENERATED FROM 'IB CPT RG DISPLAY' PRINT TEMPLATE (#3654) ; 11/29/04 ; (FILE 409.71, MARGIN=80)
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
 I $D(DXS)<9 M DXS=^DIPT(3654,"DXS")
 S I(0)="^SD(409.71,",J(0)=409.71
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W "CPT/HCFA Code"
 D N:$X>62 Q:'DN  W ?62 W "Current OPC Status"
 D N:$X>0 Q:'DN  W ?0 W "--------------"
 D N:$X>62 Q:'DN  W ?62 W "------------------"
 S X=$G(^SD(409.71,D0,0)) D N:$X>0 Q:'DN  W ?0,$E(0,1,30)
 D N:$X>6 Q:'DN  W ?6 X $P(^DD(409.71,.015,0),U,5,99) S DIP(1)=X S X="- "_DIP(1) K DIP K:DN Y W X
 S X=$G(^SD(409.71,D0,0)) D N:$X>49 Q:'DN  W ?49,$J(0,31)
 S DICMX="D L^DIWP" D T Q:'DN  D N D N:$X>4 Q:'DN  S DIWL=5,DIWR=78 X DXS(1,9) K DIP K:DN Y
 D 0^DIWW
 D ^DIWW
 D T Q:'DN  D N D N:$X>1 Q:'DN  W ?1 W "Effective Date"
 D N:$X>17 Q:'DN  W ?17 W "Billing Status"
 D N:$X>33 Q:'DN  W ?33 W "Billing Group"
 D N:$X>55 Q:'DN  W ?55 W "Division"
 D N:$X>73 Q:'DN  W ?73 W "Charge"
 D N:$X>1 Q:'DN  W ?1 W "--------------"
 D N:$X>17 Q:'DN  W ?17 W "--------------"
 D N:$X>33 Q:'DN  W ?33 W "--------------"
 D N:$X>55 Q:'DN  W ?55 W "--------"
 D N:$X>73 Q:'DN  W ?73 W "------"
 S DIXX(1)="A1",I(0,0)=D0 S I(0,0)=$S($D(D0):D0,1:"") X DXS(2,9.2) S X="" S D0=I(0,0)
 G A1R
A1 ;
 I $D(DSC(350.4)) X DSC(350.4) E  Q
 W:$X>81 ! S I(100)="^IBE(350.4,",J(100)=350.4
 S X=$G(^IBE(350.4,D0,0)) D N:$X>1 Q:'DN  W ?1 S Y=$P(X,U,1) D DT
 D N:$X>17 Q:'DN  W ?17 S Y=$P(X,U,4) W:Y]"" $S($D(DXS(6,Y)):DXS(6,Y),1:Y)
 D N:$X>33 Q:'DN  W ?33 X DXS(3,9.2) S X=$P(DIP(102),DIP(103),DIP(104),X) K DIP K:DN Y W $E(X,1,19)
 D N:$X>55 Q:'DN  W ?55 X DXS(4,9) K DIP K:DN Y
 D N:$X>71 Q:'DN  W ?71 X DXS(5,9) K DIP K:DN Y
 Q
A1R ;
 K J(100),I(100) S:$D(I(0,0)) D0=I(0,0)
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 S X="-",DIP(1)=X,DIP(2)=X,X=$S($D(IOM):IOM,1:80) S X=X,X1=DIP(1) S %=X,X="" Q:X1=""  S $P(X,X1,%\$L(X1)+1)=X1,X=$E(X,1,%) K DIP K:DN Y W X
 K Y K DIWF
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
