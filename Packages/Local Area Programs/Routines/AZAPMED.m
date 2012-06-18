AZAPMED ; IHS/PHXAO/TMJ - GENERATED FROM 'AZAM MEDICAID ELIGIBILITY TAPE' PRINT TEMPLATE (#1967) 02/17/99 (FILE 1180001, MARGIN=132) ;
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
 I $D(DXS)<9 F X=0:0 S X=$O(^DIPT(1967,"DXS",X)) Q:'X  S Y=$O(^(X,"")) F X=X:0 Q:Y=""  S DXS(X,Y)=^(Y),Y=$O(^(Y))
 S X=$G(^AZAMED(D0,0)) W ?0,$E($P(X,U,2),1,25)
 W ?27 S Y=$P(X,U,3) W:Y]"" $S($D(DXS(1,Y)):DXS(1,Y),1:Y)
 W ?32 S Y=$P(X,U,4) D DT
 W ?45,$E($P(X,U,5),1,18)
 W ?65,$E($P(X,U,6),1,10)
 D N:$X>76 Q:'DN  W ?76,$E($P(X,U,7),1,2)
 D N:$X>80 Q:'DN  W ?80 S Y=$P(X,U,8) W:Y]"" $J(Y,3,0)
 W ?85 S Y=$P(X,U,1) D DT
 W ?98 S Y=$P(X,U,9) D DT
 W ?111,$E($P(X,U,11),1,1)
 W ?116,$E($P(X,U,10),1,9)
 K Y
 Q
HEAD ;
 W !,?0,"NAME",?27,"SEX",?32,"BIRTHDATE",?45,"RESIDENCE",?65,"CASE NO.",?76,"RC",?80,"ELG",?85,"EBD",?98,"EED",?111,"RES",?116,"SSN"
 W !,"------------------------------------------------------------------------------------------------------------------------------------",!!
