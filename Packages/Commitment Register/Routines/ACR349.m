ACR349 ; GENERATED FROM 'ACR CONTRACT DISPLAY' PRINT TEMPLATE (#3973) ; 09/30/09 ; (FILE 9002196, MARGIN=80)
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
 I $D(DXS)<9 M DXS=^DIPT(3973,"DXS")
 S I(0)="^ACRDOC(",J(0)=9002196
 D N:$X>0 Q:'DN  W ?0 W "[1 ]*ORDER DATE:"
 S X=$G(^ACRDOC(D0,"PO")) W ?18 S Y=$P(X,U,1) D DT
 D N:$X>40 Q:'DN  W ?40 W "[10] GBL NO....:"
 W ?58,$E($P(X,U,10),1,10)
 D N:$X>0 Q:'DN  W ?0 W "[2 ] CONTRACT #:"
 W ?18,$E($P(X,U,2),1,15)
 D N:$X>40 Q:'DN  W ?40 W "[11]*ON/BEFORE.:"
 W ?58 S Y=$P(X,U,12) D DT
 D N:$X>0 Q:'DN  W ?0 W "[3 ]*ISSUE OFF.:"
 S X=$G(^ACRDOC(D0,"POIO")) W ?18 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^AUTTPRG(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,20)
 D N:$X>40 Q:'DN  W ?40 W "[12] DISCOUNT..:"
 S X=$G(^ACRDOC(D0,"PO")) W ?58,$E($P(X,U,13),1,20)
 D N:$X>0 Q:'DN  W ?0 W "[4 ]*SHIP TO...:"
 S X=$G(^ACRDOC(D0,"POST")) W ?18 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^AUTTPRG(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,20)
 D N:$X>40 Q:'DN  W ?40 W "[13] SHIP POINT:"
 S X=$G(^ACRDOC(D0,"PO")) W ?58,$E($P(X,U,14),1,20)
 D N:$X>0 Q:'DN  W ?0 W "[5 ]*CONTRACTOR:"
 W ?18 S Y=$P(X,U,5) S Y=$S(Y="":Y,$D(^AUTTVNDR(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,20)
 D N:$X>40 Q:'DN  W ?40 W "[14] GRS WEIGHT:"
 W ?58,$E($P(X,U,15),1,10)
 D N:$X>0 Q:'DN  W ?0 W "     BUS. CLASS:"
 W ?18 X DXS(1,9.3) S X=$P(DIP(201),U,2) S D0=I(0,0) K DIP K:DN Y W $E(X,1,20)
 D N:$X>40 Q:'DN  W ?40 W "[15] SHIP VIA..:"
 S X=$G(^ACRDOC(D0,"PO")) W ?58,$E($P(X,U,18),1,20)
 D N:$X>0 Q:'DN  W ?0 W "[6 ]*REQ OFFICE:"
 W ?18 S Y=$P(X,U,7) S Y=$S(Y="":Y,$D(^AUTTPRG(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,20)
 D N:$X>40 Q:'DN  W ?40 W "[16]*INVOICE TO:"
 S X=$G(^ACRDOC(D0,"POMI")) W ?58 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^AUTTPRG(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,20)
 D N:$X>0 Q:'DN  W ?0 W "[7 ]*TYPE ORDER:"
 S X=$G(^ACRDOC(D0,"PO")) W ?18 S Y=$P(X,U,6) W:Y]"" $S($D(DXS(2,Y)):DXS(2,Y),1:Y)
 D N:$X>40 Q:'DN  W ?40 W "[17] DRAFT PYMT:"
 S X=$G(^ACRDOC(D0,0)) W ?58 S Y=$P(X,U,12) W:Y]"" $S($D(DXS(3,Y)):DXS(3,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "[8 ] FOB. POINT:"
 S X=$G(^ACRDOC(D0,"PO")) W ?18 S Y=$P(X,U,9) W:Y]"" $S($D(DXS(4,Y)):DXS(4,Y),1:Y)
 D N:$X>40 Q:'DN  W ?40 W "[18]*AUTHRZD BY:"
 S X=$G(^ACRDOC(D0,"AU")) W ?58 S Y=$P(X,U,1) S Y(0)=Y S Y=$$NAME2^ACRFUTL1(Y) W $E(Y,1,20)
 D N:$X>0 Q:'DN  W ?0 W "[9 ] INSPT/ACCP:"
 S X=$G(^ACRDOC(D0,"PO")) W ?18 S Y=$P(X,U,11) S Y=$S(Y="":Y,$D(^AUTTPRG(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,20)
 D N:$X>40 Q:'DN  W ?40 W "[19] BPA TOTAL.:"
 S X=$G(^ACRDOC(D0,0)) W ?58 S Y=$P(X,U,18) W:Y]"" $J(Y,12,2)
 D N:$X>40 Q:'DN  W ?40 W "[20]*AUTHORITY.:"
 S X=$G(^ACRDOC(D0,"PO")) W ?58 S Y=$P(X,U,22) W:Y]"" $S($D(DXS(5,Y)):DXS(5,Y),1:Y)
 D N:$X>40 Q:'DN  W ?40 W "[21] CUST ACCT#:"
 W ?58,$E($P(X,U,23),1,20)
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
