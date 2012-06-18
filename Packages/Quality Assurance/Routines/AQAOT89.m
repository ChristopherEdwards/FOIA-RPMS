AQAOT89 ; GENERATED FROM 'AQAO STAGE LIST' PRINT TEMPLATE (#1302) ; 05/13/96 ; (FILE 9002168.7, MARGIN=80)
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
 S X=$G(^AQAO(7,D0,0)) D N:$X>0 Q:'DN  W ?0 S Y=$P(X,U,2) W:Y]"" $J(Y,2,0)
 D N:$X>4 Q:'DN  W ?4,$E($P(X,U,1),1,25)
 S I(1)=1,J(1)=9002168.71 F D1=0:0 Q:$O(^AQAO(7,D0,1,D1))'>0  S D1=$O(^(D1)) D:$X>31 T Q:'DN  D A1
 G A1R
A1 ;
 S X=$G(^AQAO(7,D0,1,D1,0)) S DIWL=35,DIWR=78 D ^DIWP
 Q
A1R ;
 D A^DIWW
 D T Q:'DN  D N W ?0 W "  "
 K Y K DIWF
 Q
HEAD ;
 W !,?1,"#",?4,"NAME",?34,"DESCRIPTION"
 W !,"--------------------------------------------------------------------------------",!!
