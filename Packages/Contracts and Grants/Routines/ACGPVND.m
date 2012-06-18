ACGPVND ; GENERATED FROM 'ACG VENDOR DATA-VENDOR-2' PRINT TEMPLATE (#1079) ; 10/01/09 ; (FILE 9999999.11, MARGIN=80)
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
 I $D(DXS)<9 M DXS=^DIPT(1079,"DXS")
 S I(0)="^AUTTVNDR(",J(0)=9999999.11
 D N:$X>0 Q:'DN  W ?0 W "VENDOR:"
 S X=$G(^AUTTVNDR(D0,0)) W ?9,$E($P(X,U,1),1,30)
 D N:$X>40 Q:'DN  W ?40 W "EIN NO:"
 S X=$G(^AUTTVNDR(D0,11)) W ?49,$E($P(X,U,13),1,12)
 D N:$X>0 Q:'DN  W ?0 W "PARENT:"
 W ?9 S Y=$P(X,U,24) S Y=$S(Y="":Y,$D(^AUTTVNDR(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 D N:$X>40 Q:'DN  W ?40 W "C-DIST:"
 W ?49,$E($P(X,U,16),1,3)
 D N:$X>0 Q:'DN  W ?0 W "CITY #:"
 W ?9,$E($P(X,U,23),1,5)
 D N:$X>40 Q:'DN  W ?40 W "TYPE..:"
 W ?49 S DIP(1)=$S($D(^AUTTVNDR(D0,11)):^(11),1:"") S X="("_$S('$D(^AUTTTOB(+$P(DIP(1),U,26),0)):"",1:$P(^(0),U,1))_") " K DIP K:DN Y W X
 X DXS(1,9.2) S X=$P(DIP(101),U,2) S D0=I(0,0) K DIP K:DN Y W $E(X,1,22)
 D N:$X>0 Q:'DN  W ?0 W "W-OWND:"
 S X=$G(^AUTTVNDR(D0,11)) W ?9 S Y=$P(X,U,15) W:Y]"" $S($D(DXS(3,Y)):DXS(3,Y),1:Y)
 D N:$X>40 Q:'DN  W ?40 W "LSA...:"
 W ?49 S Y=$P(X,U,17) W:Y]"" $S($D(DXS(4,Y)):DXS(4,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "SBS...:"
 W ?9 S Y=$P(X,U,22) W:Y]"" $S($D(DXS(5,Y)):DXS(5,Y),1:Y)
 D N:$X>40 Q:'DN  W ?40 W "SIZE..:"
 W ?49 X DXS(2,9.2) S X=$P(DIP(101),U,2) S D0=I(0,0) K DIP K:DN Y W X
 D N:$X>0 Q:'DN  W ?0 W "V-CODE:"
 S X=$G(^AUTTVNDR(D0,11)) W ?9 S Y=$P(X,U,19) W:Y]"" $S($D(DXS(6,Y)):DXS(6,Y),1:Y)
 D N:$X>40 Q:'DN  W ?40 W "PROFIT:"
 W ?49 S Y=$P(X,U,20) W:Y]"" $S($D(DXS(7,Y)):DXS(7,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "N-PROF:"
 W ?9 S Y=$P(X,U,21) W:Y]"" $S($D(DXS(8,Y)):DXS(8,Y),1:Y)
 D N:$X>40 Q:'DN  W ?40 W "GEOLOC:"
 W ?49 S Y=$P(X,U,25) S Y=$S(Y="":Y,$D(^AUTTGL(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,20)
 D T Q:'DN  D N D N:$X>9 Q:'DN  W ?9 W "MAILING ADDRESS"
 D N:$X>49 Q:'DN  W ?49 W "REMIT TO ADDRESS"
 D N:$X>9 Q:'DN  W ?9 W "-----------------------------"
 D N:$X>49 Q:'DN  W ?49 W "-----------------------------"
 D N:$X>0 Q:'DN  W ?0 W "STREET:"
 S X=$G(^AUTTVNDR(D0,13)) W ?9,$E($P(X,U,1),1,30)
 D N:$X>40 Q:'DN  W ?40 W "STREET:"
 W ?49,$E($P(X,U,6),1,30)
 D N:$X>0 Q:'DN  W ?0 W "ST - 2:"
 W ?9,$E($P(X,U,10),1,30)
 D N:$X>40 Q:'DN  W ?40 W "ST - 2:"
 W ?49,$E($P(X,U,11),1,30)
 D N:$X>0 Q:'DN  W ?0 W "CITY..:"
 W ?9,$E($P(X,U,2),1,20)
 D N:$X>40 Q:'DN  W ?40 W "CITY..:"
 W ?49,$E($P(X,U,7),1,20)
 D N:$X>0 Q:'DN  W ?0 W "STATE.:"
 W ?9 S Y=$P(X,U,3) S Y=$S(Y="":Y,$D(^DIC(5,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 D N:$X>40 Q:'DN  W ?40 W "STATE.:"
 W ?49 S Y=$P(X,U,8) S Y=$S(Y="":Y,$D(^DIC(5,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 D N:$X>0 Q:'DN  W ?0 W "ZIP...:"
 W ?9,$E($P(X,U,4),1,10)
 D N:$X>40 Q:'DN  W ?40 W "ZIP...:"
 W ?49,$E($P(X,U,9),1,10)
 D N:$X>0 Q:'DN  W ?0 W "ATTN..:"
 W ?9,$E($P(X,U,5),1,20)
 D N:$X>0 Q:'DN  W ?0 W "PHONE.:"
 S X=$G(^AUTTVNDR(D0,11)) W ?9,$E($P(X,U,9),1,15)
 D N:$X>40 Q:'DN  W ?40 W "FAX...:"
 W ?49,$E($P(X,U,14),1,12)
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
