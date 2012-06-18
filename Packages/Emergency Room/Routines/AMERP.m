AMERP ; GENERATED FROM 'AMER BRIEF' PRINT TEMPLATE (#3423) ; 06/24/09 ; (FILE 9009080, MARGIN=79)
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
 I $D(DXS)<9 M DXS=^DIPT(3423,"DXS")
 S I(0)="^AMERVSIT(",J(0)=9009080
 D N:$X>0 Q:'DN  W ?0 S DIP(1)=$S($D(^AMERVSIT(D0,0)):^(0),1:"") S X=$P(DIP(1),U,1) S:X X=$E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3) K DIP K:DN Y W $E(X,1,8)
 D N:$X>9 Q:'DN  W ?9 X DXS(1,9.2) S X=$E($P(X,".",2)_"0000",1,4),%=X>1159 S:X>1259 X=X-1200 S X=X\100_":"_$E(X#100+100,2,3)_" "_$E("AP",%+1)_"M" K DIP K:DN Y W $E(X,1,8)
 S X=$G(^AMERVSIT(D0,0)) D N:$X>18 Q:'DN  W ?18 S Y=$P(X,U,2) S Y=$S(Y="":Y,$D(^AUPNPAT(Y,0))#2:$P(^(0),U),1:Y) S Y=$S(Y="":Y,$D(^DPT(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,14)
 D N:$X>33 Q:'DN  W ?33,$E($P(X,U,13),1,6)
 D N:$X>40 Q:'DN  W ?40 S DIP(1)=$S($D(^AMERVSIT(D0,0)):^(0),1:"") S X=$P(DIP(1),U,12) S:X X=$E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3) K DIP K:DN Y W $E(X,1,8)
 D N:$X>49 Q:'DN  W ?49 X DXS(2,9.3) S X=X_Y K DIP K:DN Y W $E(X,1,12)
 S X=$G(^AMERVSIT(D0,5.1)) D N:$X>62 Q:'DN  W ?62,$E($P(X,U,3),1,16)
 K Y
 Q
HEAD ;
 W !,?62,"PRIMARY DX"
 W !,?0,"DATE",?9,"TIME",?18,"PATIENT",?33,"CHART",?40,"DOB",?49,"PHYSICIAN",?62,"NARRATIVE"
 W !,"-------------------------------------------------------------------------------",!!
