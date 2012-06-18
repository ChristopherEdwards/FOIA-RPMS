ACR1481 ; GENERATED FROM 'ACR TRAINING REQUEST DISPLAY' PRINT TEMPLATE (#3852) ; 09/29/09 ; (continued)
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
 D N:$X>0 Q:'DN  W ?0 W "[9 ]*TRNG TITLE:"
 S X=$G(^ACRDOC(D0,"TRNG")) W ?18,$E($P(X,U,18),1,20)
 D N:$X>40 Q:'DN  W ?40 W "[28]*AUTHORIZNG:"
 W ?58 I $D(ACRX(2,1)),ACRX(2,1)'="" W "#" K DIP K:DN Y
 S X=$G(^ACRDOC(D0,"TRNG4")) S Y=$P(X,U,5) S Y=$S(Y="":Y,$D(^VA(200,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,20)
 D N:$X>0 Q:'DN  W ?0 W "[10] PAYMENT TO:"
 S X=$G(^ACRDOC(D0,"TRNG3")) W ?18 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^AUTTVNDR(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,20)
 D N:$X>40 Q:'DN  W ?40 W "[29]*FUNDS AVAL:"
 W ?58 I $D(ACRX(1,1)),ACRX(1,1)'="" W "#" K DIP K:DN Y
 S X=$G(^ACRDOC(D0,"TRNG")) S Y=$P(X,U,25) S Y=$S(Y="":Y,$D(^VA(200,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,20)
 D N:$X>0 Q:'DN  W ?0 W "[11] LOC OF TNG:"
 S X=$G(^ACRDOC(D0,"TRNG4")) W ?18,$E($P(X,U,6),1,20)
 D N:$X>40 Q:'DN  W ?40 W "[30]*TRAV ORDER:"
 S X=$G(^ACRDOC(D0,"TRNGTO")) W ?58 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^ACRDOC(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,17)
 D N:$X>0 Q:'DN  W ?0 W "[12] LOC ADDRSS:"
 S X=$G(^ACRDOC(D0,"TRNG4")) W ?18,$E($P(X,U,7),1,20)
 D N:$X>40 Q:'DN  W ?40 W "[31] PRIOR NON-"
 D N:$X>0 Q:'DN  W ?0 W "[13] LOC CITY..:"
 W ?18,$E($P(X,U,8),1,20)
 D N:$X>40 Q:'DN  W ?40 W "     GOV'T TRNG:"
 S X=$G(^ACRDOC(D0,"TRNG3")) W ?58 S Y=$P(X,U,10) W:Y]"" $J(Y,5,0)
 D N:$X>0 Q:'DN  W ?0 W "[14] LOC STATE.:"
 S X=$G(^ACRDOC(D0,"TRNG4")) W ?18 S Y=$P(X,U,9) S Y=$S(Y="":Y,$D(^DIC(5,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,20)
 D N:$X>40 Q:'DN  W ?40 W "[32]*IDENTIFIER:"
 S X=$G(^ACRDOC(D0,0)) W ?58,$E($P(X,U,14),1,16)
 D N:$X>0 Q:'DN  W ?0 W "[15] LOC ZIP...:"
 S X=$G(^ACRDOC(D0,"TRNG4")) W ?18,$E($P(X,U,10),1,10)
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
