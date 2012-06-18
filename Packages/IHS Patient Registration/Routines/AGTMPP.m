AGTMPP ; GENERATED FROM 'AG TM PI ELIGIBLE' PRINT TEMPLATE (#671) ; 02/14/06 ; (FILE 9000006, MARGIN=132)
 G BEGIN
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
 S I(0)="^AUPNPRVT(",J(0)=9000006
 S I(1)=11,J(1)=9000006.11 F D1=0:0 Q:$O(^AUPNPRVT(D0,11,D1))'>0  X:$D(DSC(9000006.11)) DSC(9000006.11) S D1=$O(^(D1)) Q:D1'>0  D:$X>0 T Q:'DN  D A1
 G A1R
A1 ;
 S X=$G(^AUPNPRVT(D0,11,D1,0)) W ?0 S Y=$P(X,U,1),C=1 D D S Y=$S(Y="":Y,$D(^AUTNINS(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,25)
 D N:$X>4 Q:'DN  W ?4 S Y=$P(X,U,8),C=2 D D S Y=$S(Y="":Y,$D(^AUPN3PPH(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,25)
 W ?31 S Y=$P(X,U,2),C=3 D D W $E(Y,1,12)
 Q
A1R ;
 S X=$G(^AUPNPRVT(D0,0)) W ?45 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^AUPNPAT(Y,0))#2:$P(^(0),U),1:Y) S Y=$S(Y="":Y,$D(^DPT(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,25)
 S I(1)=11,J(1)=9000006.11 F D1=0:0 Q:$O(^AUPNPRVT(D0,11,D1))'>0  X:$D(DSC(9000006.11)) DSC(9000006.11) S D1=$O(^(D1)) Q:D1'>0  D:$X>72 T Q:'DN  D B1
 G B1R
B1 ;
 S X=$G(^AUPNPRVT(D0,11,D1,0)) W ?72 S Y=$P(X,U,5) S Y=$S(Y="":Y,$D(^AUTTRLSH(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,12)
 W ?86 S Y=$P(X,U,6) D DT
 W ?99 S Y=$P(X,U,7) D DT
 Q
B1R ;
 K Y
 Q
HEAD ;
 W !,?31,"*POLICY",?72,"RELATIONSHIP",?86,"EFFECTIVE"
 W !,?4,"POLICY HOLDER",?31,"NUMBER",?45,"POLICY MEMBERS",?72,"TO HOLDER",?86,"DATE",?99,"EXPIRE DATE"
 W !,"------------------------------------------------------------------------------------------------------------------------------------",!!
