ACRPPRG ; GENERATED FROM 'ACR PROGRAM INFO' PRINT TEMPLATE (#3874) ; 09/30/09 ; (FILE 9999999.62, MARGIN=80)
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
 I $D(DXS)<9 M DXS=^DIPT(3874,"DXS")
 S I(0)="^AUTTPRG(",J(0)=9999999.62
 W ?0 W:$D(IOF) @IOF K DIP K:DN Y
 W ?11 W !?13,"DEPARTMENT INFORMATION" K DIP K:DN Y
 D T Q:'DN  D N W ?0 W "NAME......:"
 S X=$G(^AUTTPRG(D0,0)) W ?13,$E($P(X,U,1),1,30)
 D N:$X>49 Q:'DN  W ?49 W "CODE.:"
 W ?57,$E($P(X,U,2),1,3)
 D N:$X>0 Q:'DN  W ?0 W "ORG LEVEL.:"
 W ?13 S Y=$P(X,U,3) W:Y]"" $S($D(DXS(2,Y)):DXS(2,Y),1:Y)
 D T Q:'DN  D N W ?0 W "COST CENTER PREFIX....:"
 W ?25 S Y=$P(X,U,6) W:Y]"" $S($D(DXS(3,Y)):DXS(3,Y),1:Y)
 W ?39 W "("
 S DIP(1)=$S($D(^AUTTPRG(D0,0)):^(0),1:"") S X=$P(DIP(1),U,6),X=X K DIP K:DN Y W X
 W ")"
 D N:$X>0 Q:'DN  W ?0 W "PROCUREMENT OFFICE....:"
 S X=$G(^AUTTPRG(D0,0)) W ?25 S Y=$P(X,U,5) S Y=$S(Y="":Y,$D(^ACRPO(Y,0))#2:$P(^(0),U),1:Y) S Y=$S(Y="":Y,$D(^AUTTLOC(Y,0))#2:$P(^(0),U),1:Y) S Y=$S(Y="":Y,$D(^DIC(4,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,20)
 W ?47 W "AGENT:"
 I $D(^ACRDEPT(D0,0)),$P(^(0),U,3) W $E($$NAME2^ACRFUTL1($P(^ACRDEPT(D0,0),U,3)),1,20) K DIP K:DN Y
 D N:$X>0 Q:'DN  W ?0 W "FEDSTRIP LOCATION CODE:"
 W "  "
 W ?25 X DXS(1,9) K DIP K:DN Y
 D T Q:'DN  D N W ?0 W "ADDRESS...:"
 S X=$G(^AUTTPRG(D0,"DT")) W ?13,$E($P(X,U,1),1,30)
 D N:$X>13 Q:'DN  W ?13,$E($P(X,U,2),1,30)
 D N:$X>13 Q:'DN  W ?13,$E($P(X,U,3),1,20)
 W ", "
 S Y=$P(X,U,4) S Y=$S(Y="":Y,$D(^DIC(5,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 W "  "
 W ?0,$E($P(X,U,5),1,10)
 D N:$X>0 Q:'DN  W ?0 W "PHONE.....:"
 W ?13,$E($P(X,U,6),1,12)
 D N:$X>0 Q:'DN  W ?0 W "FAX NUMBER:"
 W ?13,$E($P(X,U,8),1,12)
 D N:$X>0 Q:'DN  W ?0 W "PRINTER 1.:"
 W ?13 S Y=$P(X,U,10) S Y=$S(Y="":Y,$D(^%ZIS(1,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 D N:$X>39 Q:'DN  W ?39 W "PRINTER 2.:"
 D T Q:'DN  D N W ?0 W "SAMS USER CODE....:"
 D N:$X>0 Q:'DN  W ?0 W "SAMS ACCOUNT CODE.:"
 D N:$X>0 Q:'DN  W ?0 W "SAMS SUB-ACCT CODE:"
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
