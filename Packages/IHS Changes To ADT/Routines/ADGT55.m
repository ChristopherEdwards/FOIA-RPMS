ADGT55 ; GENERATED FROM 'ADGICCHK' PRINT TEMPLATE (#1513) ; 05/04/99 ; (FILE 9009013, MARGIN=80)
 G BEGIN
CP G CP^DIO2
C S DQ(C)=Y
S S Q(C)=Y*Y+Q(C) S:L(C)>Y L(C)=Y S:H(C)<Y H(C)=Y
P S N(C)=N(C)+1
A S S(C)=S(C)+Y
 Q
D I Y=DITTO(C) S Y="" Q
 S DITTO(C)=Y
 Q
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
 S X=$G(^ADGIC(D0,0)) W:$X>8 ! W ?10 S Y=$P(X,U,1) S:Y]"" N(1)=N(1)+1 S Y=$S(Y="":Y,$D(^AUPNPAT(Y,0))#2:$P(^(0),U,1),1:Y) S Y=$S(Y="":Y,$D(^DPT(Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,30)
 W ?42 S X=$S($D(^AUPNPAT(D0,41,DUZ(2),0)):$P(^(0),"^",2),1:"") W $E(X,1,7) K Y(9009013,2)
 S I(1)="""D""",J(1)=9009013.01 F D1=0:0 Q:$O(^ADGIC(D0,"D",D1))'>0  X:$D(DSC(9009013.01)) DSC(9009013.01) S D1=$O(^(D1)) Q:D1'>0  D:$X>51 T Q:'DN  D A1
 G A1R
A1 ;
 S X=$G(^ADGIC(D0,"D",D1,0)) W ?51 S Y=$P(X,U,1) D DT
 Q
A1R ;
 K Y
 Q
HEAD ;
 W !,?10,"PATIENT NAME",?42,"HRCN",?51,"DISCHARGE DATE"
 W !,"--------------------------------------------------------------------------------",!!
