INXHR02 ; GENERATED FROM 'INH ERROR DISPLAY' PRINT TEMPLATE (#2831) ; 10/25/01 ; (FILE 4003, MARGIN=80)
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
 I $D(DXS)<9 F X=0:0 S X=$O(^DIPT(2831,"DXS",X)) Q:'X  S Y=$O(^(X,"")) F X=X:0 Q:Y=""  S DXS(X,Y)=^(Y),Y=$O(^(Y))
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W "Date/Time of Error    Message ID    Resolution  Destination"
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W "--------------------  ------------  ----------  -------------------------------"
 S X=$G(^INTHER(D0,0)) D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 S Y=$P(X,U,1) D DT
 D N:$X>22 Q:'DN  W ?22 X DXS(1,9) K DIP K:DN Y W $E(X,1,12)
 S X=$G(^INTHER(D0,0)) D N:$X>36 Q:'DN  W ?36 S Y=$P(X,U,10) W:Y]"" $S($D(DXS(3,Y)):DXS(3,Y),1:Y)
 D N:$X>48 Q:'DN  W ?48 S Y=$P(X,U,9) S Y=$S(Y="":Y,$D(^INRHD(Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,32)
 D T Q:'DN  D N D N:$X>1 Q:'DN  W ?1 W "User:"
 D N:$X>7 Q:'DN  W ?7 S Y=$P(X,U,8) S Y=$S(Y="":Y,$D(^DIC(3,Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,30)
 D N:$X>40 Q:'DN  W ?40 W "Division:"
 D N:$X>50 Q:'DN  W ?50 X DXS(2,9) K DIP K:DN Y W $E(X,1,20)
 D T Q:'DN  D N D N:$X>1 Q:'DN  W ?1 W "Error Message:"
 S:'$D(DIWF) DIWF="" S:DIWF'["N" DIWF=DIWF_"N" S X="" S I(1)=2,J(1)=4003.02 F D1=0:0 Q:$O(^INTHER(D0,2,D1))'>0  S D1=$O(^(D1)) D:$X>1 T Q:'DN  D A1
 G A1R
A1 ;
 S X=$G(^INTHER(D0,2,D1,0)) S DIWL=3,DIWR=78 D ^DIWP
 Q
A1R ;
 D A^DIWW
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W ""
 I '$G(INBRIEF) D MESS^INHU1($P(^INTHER(D0,0),"^",4)) K DIP K:DN Y
 K Y K DIWF
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
