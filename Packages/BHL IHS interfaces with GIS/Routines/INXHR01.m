INXHR01 ; GENERATED FROM 'INH TASK DISPLAY' PRINT TEMPLATE (#2834) ; 10/25/01 ; (FILE 4001, MARGIN=80)
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
 I $D(DXS)<9 F X=0:0 S X=$O(^DIPT(2834,"DXS",X)) Q:'X  S Y=$O(^(X,"")) F X=X:0 Q:Y=""  S DXS(X,Y)=^(Y),Y=$O(^(Y))
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W "QUEUED FOR:"
 D N:$X>12 Q:'DN  W ?12 W ""
 W $$DATEFMT^UTDT(DIPA(D0),"MM/DD@HH:II") K DIP K:DN Y
 D T Q:'DN  D N D N:$X>12 Q:'DN  W ?12 W "MSG ID:"
 S X=$G(^INTHU(D0,0)) D N:$X>20 Q:'DN  W ?20,$E($P(X,U,5),1,30)
 D T Q:'DN  D N D N:$X>12 Q:'DN  W ?12 W "STATUS:"
 D N:$X>20 Q:'DN  W ?20 S Y=$P(X,U,3) W:Y]"" $S($D(DXS(2,Y)):DXS(2,Y),1:Y)
 D N:$X>32 Q:'DN  W ?32 W "# ATTEMPTS:"
 D N:$X>44 Q:'DN  W ?44,$E($P(X,U,12),1,5)
 D T Q:'DN  D N D N:$X>12 Q:'DN  W ?12 W "SOURCE:"
 D N:$X>20 Q:'DN  W ?20 N DIP X DXS(1,9.2) S X=$S(DIP(2):DIP(3),DIP(4):X) K DIP K:DN Y W $E(X,1,45)
 D T Q:'DN  D N D N:$X>7 Q:'DN  W ?7 W "DESTINATION:"
 S X=$G(^INTHU(D0,0)) D N:$X>20 Q:'DN  W ?20 S Y=$P(X,U,2) S Y=$S(Y="":Y,$D(^INRHD(Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,50)
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
