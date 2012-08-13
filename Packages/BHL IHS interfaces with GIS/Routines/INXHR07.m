INXHR07 ; GENERATED FROM 'INHSG FIELD' PRINT TEMPLATE (#2827) ; 10/25/01 ; (FILE 4012, MARGIN=80)
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
 I $D(DXS)<9 F X=0:0 S X=$O(^DIPT(2827,"DXS",X)) Q:'X  S Y=$O(^(X,"")) F X=X:0 Q:Y=""  S DXS(X,Y)=^(Y),Y=$O(^(Y))
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W "FIELD:"
 S X=$G(^INTHL7F(D0,0)) D N:$X>7 Q:'DN  W ?7,$E($P(X,U,1),1,30)
 D T Q:'DN  D N D N:$X>2 Q:'DN  W ?2 W "DATA LOCATION:"
 S X=$G(^INTHL7F(D0,"C")) D T Q:'DN  D N D N:$X>3 Q:'DN  W ?3,$E($E(X,1,245),1,70)
 D T Q:'DN  D N D N:$X>11 Q:'DN  W ?11 W "DATA TYPE:"
 S X=$G(^INTHL7F(D0,0)) D N:$X>22 Q:'DN  W ?22 S Y=$P(X,U,2) S Y=$S(Y="":Y,$D(^INTHL7FT(Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,30)
 D T Q:'DN  D N D N:$X>8 Q:'DN  W ?8 W "MAP FUNCTION:"
 S X=$G(^INTHL7F(D0,50)) D N:$X>22 Q:'DN  W ?22 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^INVD(4090.2,Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,30)
 D T Q:'DN  D N D N:$X>2 Q:'DN  W ?2 W "DESCRIPTION:"
 S:'$D(DIWF) DIWF="" S:DIWF'["N" DIWF=DIWF_"N" S X="" S I(1)=1,J(1)=4012.01 F D1=0:0 Q:$O(^INTHL7F(D0,1,D1))'>0  S D1=$O(^(D1)) D:$X>2 T Q:'DN  D A1
 G A1R
A1 ;
 S X=$G(^INTHL7F(D0,1,D1,0)) S DIWL=16,DIWR=78 D ^DIWP
 Q
A1R ;
 D A^DIWW
 D T Q:'DN  D N D N:$X>4 Q:'DN  W ?4 W "INPUT VALIDATION:"
 S X=$G(^INTHL7F(D0,"I")) D N:$X>22 Q:'DN  W ?22,$E($E(X,1,245),1,245)
 D T Q:'DN  D N D N:$X>2 Q:'DN  W ?2 W "OUTGOING TRANSFORM:"
 S X=$G(^INTHL7F(D0,5)) D N:$X>22 Q:'DN  W ?22,$E($E(X,1,245),1,245)
 D T Q:'DN  D N D N:$X>2 Q:'DN  W ?2 W "INCOMING TRANSFORM:"
 S X=$G(^INTHL7F(D0,4)) D N:$X>22 Q:'DN  W ?22,$E($E(X,1,245),1,245)
 D T Q:'DN  D N D N:$X>2 Q:'DN  W ?2 W "TIME PRECISION:"
 S X=$G(^INTHL7F(D0,2)) D N:$X>18 Q:'DN  W ?18 S Y=$P(X,U,1) W:Y]"" $S($D(DXS(1,Y)):DXS(1,Y),1:Y)
 D N:$X>38 Q:'DN  W ?38 W "TIME CONVERT:"
 D N:$X>52 Q:'DN  W ?52 S Y=$P(X,U,2) W:Y]"" $S($D(DXS(2,Y)):DXS(2,Y),1:Y)
 D T Q:'DN  D N D N:$X>2 Q:'DN  W ?2 W "MIDNIGHT OFFSET:"
 D N:$X>19 Q:'DN  W ?19 S Y=$P(X,U,3) W:Y]"" $S($D(DXS(3,Y)):DXS(3,Y),1:Y)
 D N:$X>32 Q:'DN  W ?32 W "CONVERT DELIMETERS:"
 D N:$X>52 Q:'DN  W ?52 S Y=$P(X,U,4) W:Y]"" $S($D(DXS(4,Y)):DXS(4,Y),1:Y)
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W "OVERRIDE INPUT XFORM:"
 S X=$G(^INTHL7F(D0,0)) D N:$X>22 Q:'DN  W ?22 S Y=$P(X,U,5) W:Y]"" $S($D(DXS(5,Y)):DXS(5,Y),1:Y)
 D N:$X>28 Q:'DN  W ?28 W "DELETE ON NULL:"
 D N:$X>44 Q:'DN  W ?44 S Y=$P(X,U,6) W:Y]"" $S($D(DXS(6,Y)):DXS(6,Y),1:Y)
 D N:$X>49 Q:'DN  W ?49 W "WP:"
 D N:$X>53 Q:'DN  W ?53 S Y=$P(X,U,4) W:Y]"" $S($D(DXS(7,Y)):DXS(7,Y),1:Y)
 D N:$X>64 Q:'DN  W ?64 W "MAX LENGTH:"
 D N:$X>76 Q:'DN  W ?76,$E($P(X,U,3),1,3)
 D T Q:'DN  D N D N:$X>1 Q:'DN  W ?1 W "SUB-FIELDS:"
 S I(1)=10,J(1)=4012.02 F D1=0:0 Q:$O(^INTHL7F(D0,10,D1))'>0  X:$D(DSC(4012.02)) DSC(4012.02) S D1=$O(^(D1)) Q:D1'>0  D:$X>1 T Q:'DN  D B1
 G B1R
B1 ;
 S X=$G(^INTHL7F(D0,10,D1,0)) D N:$X>2 Q:'DN  W ?2 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^INTHL7F(Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,30)
 D N:$X>37 Q:'DN  W ?37 W "SEQUENCE:"
 D N:$X>47 Q:'DN  W ?47,$E($P(X,U,2),1,6)
 Q
B1R ;
 K Y K DIWF
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
