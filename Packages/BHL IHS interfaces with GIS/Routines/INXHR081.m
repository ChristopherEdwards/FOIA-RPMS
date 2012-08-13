INXHR081 ; GENERATED FROM 'INHSG MESSAGE' PRINT TEMPLATE (#2828) ; 10/25/01 ; (continued)
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
 D N:$X>51 Q:'DN  W ?51 N DIP X DXS(1,9.2) S D1=I(1,0) K DIP K:DN Y W $E(X,1,6)
 S X=$G(^INTHL7M(D0,1,D1,0)) D N:$X>58 Q:'DN  W ?58,$E($P(X,U,2),1,6)
 D N:$X>66 Q:'DN  W ?66 S Y=$P(X,U,9) W:Y]"" $S($D(DXS(24,Y)):DXS(24,Y),1:Y)
 D N:$X>71 Q:'DN  W ?71 S Y=$P(X,U,3) W:Y]"" $S($D(DXS(25,Y)):DXS(25,Y),1:Y)
 D N:$X>76 Q:'DN  W ?76 S Y=$P(X,U,4) W:Y]"" $S($D(DXS(26,Y)):DXS(26,Y),1:Y)
 D T Q:'DN  D N D N:$X>8 Q:'DN  W ?8 W "Parent Segment:"
 D N:$X>24 Q:'DN  W ?24 S Y=$P(X,U,11) S Y=$S(Y="":Y,$D(^INTHL7S(Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,45)
 D T Q:'DN  D N D N:$X>18 Q:'DN  W ?18 W "File:"
 D N:$X>24 Q:'DN  W ?24 S Y=$P(X,U,5) S Y=$S(Y="":Y,$D(^DIC(Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,45)
 D T Q:'DN  D N D N:$X>8 Q:'DN  W ?8 W "Multiple Field:"
 D N:$X>24 Q:'DN  W ?24,$E($P(X,U,8),1,30)
 D T Q:'DN  D N D N:$X>4 Q:'DN  W ?4 W "User-Defined Index:"
 D N:$X>24 Q:'DN  W ?24,$E($P(X,U,12),1,6)
 D T Q:'DN  D N D N:$X>6 Q:'DN  W ?6 W "Lookup Parameter:"
 D N:$X>24 Q:'DN  W ?24 S Y=$P(X,U,7) W:Y]"" $S($D(DXS(27,Y)):DXS(27,Y),1:Y)
 D T Q:'DN  D N D N:$X>12 Q:'DN  W ?12 W "Make Links:"
 D N:$X>24 Q:'DN  W ?24 S Y=$P(X,U,10) W:Y]"" $S($D(DXS(28,Y)):DXS(28,Y),1:Y)
 D T Q:'DN  D N D N:$X>14 Q:'DN  W ?14 W "Template:"
 D N:$X>24 Q:'DN  W ?24,$E($P(X,U,6),1,30)
 D T Q:'DN  D N D N:$X>14 Q:'DN  W ?14 W "ID Field:"
 D N:$X>24 Q:'DN  W ?24,$E($P(X,U,18),1,3)
 D T Q:'DN  D N D N:$X>14 Q:'DN  W ?14 W "ID Value:"
 D N:$X>24 Q:'DN  W ?24,$E($P(X,U,19),1,15)
 D T Q:'DN  D N D N:$X>15 Q:'DN  W ?15 W "Routine:"
 S X=$G(^INTHL7M(D0,1,D1,3)) D N:$X>24 Q:'DN  S DIWL=25,DIWR=80 S Y=$E(X,1,100) S X=Y D ^DIWP
 D A^DIWW
 D T Q:'DN  D N D N:$X>6 Q:'DN  W ?6 W "MUMPS Code before Lookup:"
 S:'$D(DIWF) DIWF="" S:DIWF'["N" DIWF=DIWF_"N" S X="" S I(2)=1,J(2)=4011.04 F D2=0:0 Q:$O(^INTHL7M(D0,1,D1,1,D2))'>0  S D2=$O(^(D2)) D:$X>6 T Q:'DN  D A2
 G A2R
A2 ;
 S X=$G(^INTHL7M(D0,1,D1,1,D2,0)) S DIWL=10,DIWR=80 D ^DIWP
 Q
A2R ;
 D A^DIWW
 D T Q:'DN  D N D N:$X>6 Q:'DN  W ?6 W "Script code before Lookup:"
 S:'$D(DIWF) DIWF="" S:DIWF'["N" DIWF=DIWF_"N" S X="" S I(2)=2,J(2)=4011.05 F D2=0:0 Q:$O(^INTHL7M(D0,1,D1,2,D2))'>0  S D2=$O(^(D2)) D:$X>6 T Q:'DN  D B2
 G B2R
B2 ;
 S X=$G(^INTHL7M(D0,1,D1,2,D2,0)) S DIWL=10,DIWR=80 D ^DIWP
 Q
B2R ;
 D A^DIWW
 D T Q:'DN  D N D N:$X>6 Q:'DN  W ?6 W "Screening Logic:"
 S X=$G(^INTHL7M(D0,1,D1,4)) D T Q:'DN  D N D N:$X>9 Q:'DN  S DIWL=10,DIWR=80 S Y=$E(X,1,250) S X=Y D ^DIWP
 D A^DIWW
 D T Q:'DN  D N D N:$X>6 Q:'DN  W ?6 W "Outgoing MUMPS Code:"
 S:'$D(DIWF) DIWF="" S:DIWF'["N" DIWF=DIWF_"N" S X="" S I(2)=5,J(2)=4011.07 F D2=0:0 Q:$O(^INTHL7M(D0,1,D1,5,D2))'>0  S D2=$O(^(D2)) D:$X>6 T Q:'DN  D C2
 G C2R
C2 ;
 S X=$G(^INTHL7M(D0,1,D1,5,D2,0)) S DIWL=10,DIWR=80 D ^DIWP
 Q
C2R ;
 D A^DIWW
 D T Q:'DN  D N D N:$X>15 Q:'DN  W ?15 W "R R L X"
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W "SeqNo Len  DT  q p k f    Field Name                         Data Location"
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W "--------------------------------------------------------------------------------"
 S DICMX="D L^DIWP" D T Q:'DN  D N D N:$X>0 Q:'DN  S DIWL=1,DIWR=6 N DIP X DXS(2,9.4) S D1=I(1,0) K DIP K:DN Y
 D 0^DIWW K DIP K:DN Y
 S DICMX="D L^DIWP" D N:$X>6 Q:'DN  S DIWL=7,DIWR=10 N DIP X DXS(3,9.5) S D1=I(1,0) K DIP K:DN Y
 D 0^DIWW K DIP K:DN Y
 S DICMX="D L^DIWP" D N:$X>11 Q:'DN  S DIWL=12,DIWR=14 N DIP X DXS(4,9.5) S D1=I(1,0) K DIP K:DN Y
 D 0^DIWW K DIP K:DN Y
 S DICMX="D L^DIWP" D N:$X>15 Q:'DN  S DIWL=16,DIWR=16 N DIP X DXS(5,9.4) S D1=I(1,0) K DIP K:DN Y
 D 0^DIWW K DIP K:DN Y
 S DICMX="D L^DIWP" D N:$X>17 Q:'DN  S DIWL=18,DIWR=18 N DIP X DXS(6,9.4) S D1=I(1,0) K DIP K:DN Y
 D 0^DIWW K DIP K:DN Y
 S DICMX="D L^DIWP" D N:$X>19 Q:'DN  S DIWL=20,DIWR=20 N DIP X DXS(7,9.4) S D1=I(1,0) K DIP K:DN Y
 D 0^DIWW K DIP K:DN Y
 G ^INXHR082
