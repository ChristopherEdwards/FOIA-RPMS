ACR116 ; GENERATED FROM 'ACR REQUISITION DISPLAY-2' PRINT TEMPLATE (#3887) ; 09/30/09 ; (FILE 9002196, MARGIN=80)
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
 I $D(DXS)<9 M DXS=^DIPT(3887,"DXS")
 S I(0)="^ACRDOC(",J(0)=9002196
 W ?0 D ^ACRFDAP K DIP K:DN Y
 D N:$X>19 Q:'DN  W ?19 W "REQUESTED BY.......:"
 W ?41 W:$D(ACRX(12,1)) "#" K DIP K:DN Y
 S X=$G(^ACRDOC(D0,"REQ")) S Y=$P(X,U,12) S Y(0)=Y S Y=$$NAME2^ACRFUTL1(Y) W $E(Y,1,30)
 D N:$X>19 Q:'DN  W ?19 W "FUNDS CERTIFICATION:"
 W ?41 W:$D(ACRX("FA",1)) "#" K DIP K:DN Y
 S X=$G(^ACRDOC(D0,"FA")) S Y=$P(X,U,1) S Y(0)=Y S Y=$$NAME2^ACRFUTL1(Y) W $E(Y,1,30)
 D N:$X>19 Q:'DN  W ?19 W "RECOMMENDED BY.....:"
 W ?41 W:$D(ACRX(13,1)) "#" K DIP K:DN Y
 S X=$G(^ACRDOC(D0,"REQ")) S Y=$P(X,U,13) S Y(0)=Y S Y=$$NAME2^ACRFUTL1(Y) W $E(Y,1,30)
 D N:$X>19 Q:'DN  W ?19 W "APPROVED BY........:"
 W ?41 W:$D(ACRX(14,1)) "#" K DIP K:DN Y
 S X=$G(^ACRDOC(D0,"REQ")) S Y=$P(X,U,14) S Y(0)=Y S Y=$$NAME2^ACRFUTL1(Y) W $E(Y,1,30)
 D N:$X>19 Q:'DN  W ?19 W "FINANCE............:"
 S X=$G(^ACRDOC(D0,"REQ1")) W ?41 S Y=$P(X,U,14) S Y(0)=Y S Y=$$NAME2^ACRFUTL1(Y) W $E(Y,1,30)
 D N:$X>19 Q:'DN  W ?19 W "PROPERTY MANAGEMENT:"
 S X=$G(^ACRDOC(D0,"REQ")) W ?41 S Y=$P(X,U,15) S Y(0)=Y S Y=$$NAME2^ACRFUTL1(Y) W $E(Y,1,30)
 D N:$X>19 Q:'DN  W ?19 W "RECEIVING OFFICIAL.:"
 S X=$G(^ACRDOC(D0,"REQ1")) W ?41 S Y=$P(X,U,6) S Y(0)=Y S Y=$$NAME2^ACRFUTL1(Y) W $E(Y,1,30)
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W "[1 ]*TO.........:"
 S X=$G(^ACRDOC(D0,"REQ")) W ?19 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^AUTTPRG(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,20)
 D N:$X>40 Q:'DN  W ?40 W "[8 ]*REFERENCE..:"
 W ?59 S Y=$P(X,U,7) S Y(0)=Y S Y=$$NAME2^ACRFUTL1(Y) W $E(Y,1,20)
 D N:$X>0 Q:'DN  W ?0 W "[2 ]*REQUEST FOR:"
 S X=$G(^ACRDOC(D0,"REQ")) W ?19 S Y=$P(X,U,2) W:Y]"" $S($D(DXS(4,Y)):DXS(4,Y),1:Y)
 D N:$X>40 Q:'DN  W ?40 W "[9 ]*TELEPHONE #:"
 W ?59,$E($P(X,U,8),1,12)
 D N:$X>0 Q:'DN  W ?0 W "[3 ]*REQSTNG ORG:"
 W ?19 S Y=$P(X,U,3) S Y=$S(Y="":Y,$D(^AUTTPRG(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,20)
 D N:$X>40 Q:'DN  W ?40 W "[10] DELIVER TO.:"
 S X=$G(^ACRDOC(D0,"REQ1")) W ?59 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^AUTTPRG(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,20)
 D N:$X>0 Q:'DN  W ?0 W "[4 ]*CUST AREA..:"
 S X=$G(^ACRDOC(D0,"REQ")) W ?19 S Y=$P(X,U,4) S Y=$S(Y="":Y,$D(^AUTTLCOD(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 X DXS(1,9.2) S X=$P(DIP(101),U,2) S D0=I(0,0) K DIP K:DN Y W X
 W " "
 X DXS(2,9.2) S X=$P(DIP(101),U,2) S D0=I(0,0) K DIP K:DN Y W $E(X,1,9)
 D N:$X>40 Q:'DN  W ?40 W "[11]*IDENTIFIER.:"
 S X=$G(^ACRDOC(D0,0)) W ?59,$E($P(X,U,14),1,20)
 D N:$X>0 Q:'DN  W ?0 W "[5 ]*DATE OF REQ:"
 S X=$G(^ACRDOC(D0,"REQ")) W ?19 S Y=$P(X,U,5) D DT
 D N:$X>40 Q:'DN  W ?40 W "[12] DEPT PRIOR.:"
 S X=$G(^ACRDOC(D0,"REQ2")) W ?59 S Y=$P(X,U,6) W:Y]"" $J(Y,2,0)
 D N:$X>0 Q:'DN  W ?0 W "[6 ]*DATE REQRED:"
 S X=$G(^ACRDOC(D0,"REQ")) W ?19 S Y=$P(X,U,11) D DT
 D N:$X>40 Q:'DN  W ?40 W "[13]*INITIATOR..:"
 S X=$G(^ACRDOC(D0,"REQ2")) W ?59 S Y=$P(X,U,8) S Y(0)=Y S Y=$$NAME2^ACRFUTL1(Y) W $E(Y,1,20)
 D N:$X>0 Q:'DN  W ?0 W "[7 ] PRIORITY...:"
 S X=$G(^ACRDOC(D0,"DT")) W ?19 S Y=$P(X,U,4) W:Y]"" $S($D(DXS(5,Y)):DXS(5,Y),1:Y)
 D N:$X>40 Q:'DN  W ?40 W "[14]*REQST TYPE.:"
 W ?59 S DIP(1)=$S($D(^ACRDOC(D0,0)):^(0),1:"") S X=$S('$D(^ACRTXTYP(+$P(DIP(1),U,4),0)):"",1:$P(^(0),U,1)),DIP(2)=X S X=9,DIP(3)=X S X=29,X=$E(DIP(2),DIP(3),X) K DIP K:DN Y W X
 D N:$X>40 Q:'DN  W ?40 W "[15]*REQSTED BY.:"
 S X=$G(^ACRDOC(D0,"REQ")) W ?59 S Y=$P(X,U,12) S Y(0)=Y S Y=$$NAME2^ACRFUTL1(Y) W $E(Y,1,20)
 D T Q:'DN  W ?2 X DXS(3,9) K DIP K:DN Y
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
