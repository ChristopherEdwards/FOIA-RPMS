ACR148 ; GENERATED FROM 'ACR TRAINING REQUEST DISPLAY' PRINT TEMPLATE (#3852) ; 09/30/09 ; (FILE 9002196, MARGIN=80)
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
 I $D(DXS)<9 M DXS=^DIPT(3852,"DXS")
 S I(0)="^ACRDOC(",J(0)=9002196
 W ?0 K ACRX K DIP K:DN Y
 W ?11 X DXS(1,9) K DIP K:DN Y
 W ?22 X DXS(2,9) K DIP K:DN Y
 W ?33 X DXS(3,9) K DIP K:DN Y
 W ?44 X DXS(4,9) K DIP K:DN Y
 D N:$X>0 Q:'DN  W ?0 W "[1 ]*ATTENDEE..:"
 S X=$G(^ACRDOC(D0,"TRNG")) W ?18 S Y=$P(X,U,2) S Y=$S(Y="":Y,$D(^ACRAU(Y,0))#2:$P(^(0),U),1:Y) S Y(0)=Y S Y=$$NAME2^ACRFUTL1(Y) W $E(Y,1,20)
 D N:$X>40 Q:'DN  W ?40 W "[16] PURPOSE...:"
 S X=$G(^ACRDOC(D0,"TRNG3")) W ?58 S Y=$P(X,U,6) S Y=$S(Y="":Y,$D(^ACRTP(Y,0))#2:$P(^(0),U),1:Y) W:Y]"" $J(Y,2,0)
 D N:$X>0 Q:'DN  W ?0 W "[2 ]*ORGANIZATN:"
 S X=$G(^ACRDOC(D0,"TRNG")) W ?18 S Y=$P(X,U,3) S Y=$S(Y="":Y,$D(^AUTTPRG(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,20)
 D N:$X>40 Q:'DN  W ?40 W "[17] TYPE......:"
 S X=$G(^ACRDOC(D0,"TRNG3")) W ?58 S Y=$P(X,U,7) S Y=$S(Y="":Y,$D(^ACRTT(Y,0))#2:$P(^(0),U),1:Y) W:Y]"" $J(Y,2,0)
 D N:$X>0 Q:'DN  W ?0 W "     SOC SEC...:"
 W ?18 W $$PSSN^ACRFUTL($P($G(^ACRDOC(D0,"TRNG")),U,2),$G(DUZ),$G(IOST),$G(ACRSSNOK)) K DIP K:DN Y
 D N:$X>40 Q:'DN  W ?40 W "[18] SOURCE....:"
 S X=$G(^ACRDOC(D0,"TRNG3")) W ?58 S Y=$P(X,U,8) S Y=$S(Y="":Y,$D(^ACRTS(Y,0))#2:$P(^(0),U),1:Y) W:Y]"" $J(Y,2,0)
 D N:$X>0 Q:'DN  W ?0 W "     PAY PLAN..:"
 W ?18 X DXS(5,9.2) S DIP(101)=X S X=$P(DIP(102),U,3),X=X S X=X S D0=I(0,0) K DIP K:DN Y W X
 W "-"
 W ?29 X DXS(6,9.2) S X=$P(DIP(101),U,4) S D0=I(0,0) K DIP K:DN Y W X
 D N:$X>40 Q:'DN  W ?40 W "[19] SPEC INTR.:"
 S X=$G(^ACRDOC(D0,"TRNG3")) W ?58 S Y=$P(X,U,9) S Y=$S(Y="":Y,$D(^ACRTSI(Y,0))#2:$P(^(0),U),1:Y) W:Y]"" $J(Y,2,0)
 D N:$X>0 Q:'DN  W ?0 W "     TYPE APPT.:"
 W ?18 X DXS(7,9.3) S X=$P($P(DIP(102),$C(59)_$P(DIP(101),U,7)_":",2),$C(59),1) S D0=I(0,0) K DIP K:DN Y W X
 D N:$X>40 Q:'DN  W ?40 W "[20] SELF SPONS:"
 S X=$G(^ACRDOC(D0,"TRNG")) W ?58 S Y=$P(X,U,21) W:Y]"" $S($D(DXS(8,Y)):DXS(8,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "     POS. TITLE:"
 W ?18,$E($P(X,U,6),1,30)
 D N:$X>40 Q:'DN  W ?40 W "[21] SKILL CODE:"
 W ?58 S Y=$P(X,U,22) S Y=$S(Y="":Y,$D(^ACRTSC(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,4)
 D N:$X>0 Q:'DN  W ?0 W "[3 ] SERV YEARS:"
 W ?18 S Y=$P(X,U,7) W:Y]"" $J(Y,3,0)
 D N:$X>40 Q:'DN  W ?40 W "[22] SIBAC.....:"
 W ?58,$E($P(X,U,24),1,10)
 D N:$X>0 Q:'DN  W ?0 W "[4 ] SERV MNTHS:"
 W ?18 S Y=$P(X,U,8) W:Y]"" $J(Y,3,0)
 D N:$X>40 Q:'DN  W ?40 W "[23]*SUPERVISOR:"
 W ?58 I $D(ACRX(26,1)),ACRX(26,1)'="" W "#" K DIP K:DN Y
 S X=$G(^ACRDOC(D0,"TRNG")) S Y=$P(X,U,26) S Y(0)=Y S Y=$$NAME2^ACRFUTL1(Y) W $E(Y,1,20)
 D N:$X>0 Q:'DN  W ?0 W "[5 ] HOURS DUTY:"
 S X=$G(^ACRDOC(D0,"TRNG")) W ?18 S Y=$P(X,U,9) W:Y]"" $J(Y,5,0)
 D N:$X>40 Q:'DN  W ?40 W "[24]*CONCUR - 1:"
 W ?58 I $D(ACRX(3,1)),ACRX(3,1)'="" W "#" K DIP K:DN Y
 S X=$G(^ACRDOC(D0,"TRNG4")) S Y=$P(X,U,1) S Y(0)=Y S Y=$$NAME2^ACRFUTL1(Y) W $E(Y,1,20)
 D N:$X>0 Q:'DN  W ?0 W "[6 ] NON-DUTY..:"
 S X=$G(^ACRDOC(D0,"TRNG")) W ?18 S Y=$P(X,U,10) W:Y]"" $J(Y,5,0)
 D N:$X>40 Q:'DN  W ?40 W "[25]*CONCUR - 2:"
 W ?58 I $D(ACRX(4,1)),ACRX(4,1)'="" W "#" K DIP K:DN Y
 S X=$G(^ACRDOC(D0,"TRNG4")) S Y=$P(X,U,2) S Y(0)=Y S Y=$$NAME2^ACRFUTL1(Y) W $E(Y,1,20)
 D N:$X>0 Q:'DN  W ?0 W "[7 ]*TRNG FROM.:"
 S X=$G(^ACRDOC(D0,"TRNG")) W ?18 S Y=$P(X,U,11) D DT
 D N:$X>40 Q:'DN  W ?40 W "[26]*APPROVING.:"
 W ?58 I $D(ACRX(5,1)),ACRX(5,1)'="" W "#" K DIP K:DN Y
 S X=$G(^ACRDOC(D0,"TRNG4")) S Y=$P(X,U,3) S Y(0)=Y S Y=$$NAME2^ACRFUTL1(Y) W $E(Y,1,20)
 D N:$X>0 Q:'DN  W ?0 W "[8 ]*TRNG TO...:"
 S X=$G(^ACRDOC(D0,"TRNG")) W ?18 S Y=$P(X,U,12) D DT
 D N:$X>40 Q:'DN  W ?40 W "[27]*RVW SPCLST:"
 W ?58 I $D(ACRX(6,1)),ACRX(6,1)'="" W "#" K DIP K:DN Y
 S X=$G(^ACRDOC(D0,"TRNG4")) S Y=$P(X,U,4) S Y(0)=Y S Y=$$NAME2^ACRFUTL1(Y) W $E(Y,1,20)
 D N:$X>0 Q:'DN  W ?0 W "[9 ]*TRNG TITLE:"
 S X=$G(^ACRDOC(D0,"TRNG")) W ?18,$E($P(X,U,18),1,20)
 D N:$X>40 Q:'DN  W ?40 W "[28]*AUTHORIZNG:"
 W ?58 I $D(ACRX(2,1)),ACRX(2,1)'="" W "#" K DIP K:DN Y
 S X=$G(^ACRDOC(D0,"TRNG4")) S Y=$P(X,U,5) S Y(0)=Y S Y=$$NAME2^ACRFUTL1(Y) W $E(Y,1,20)
 D N:$X>0 Q:'DN  W ?0 W "[10] PAYMENT TO:"
 S X=$G(^ACRDOC(D0,"TRNG3")) W ?18 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^AUTTVNDR(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,20)
 D N:$X>40 Q:'DN  W ?40 W "[29]*FUNDS AVAL:"
 W ?58 I $D(ACRX(1,1)),ACRX(1,1)'="" W "#" K DIP K:DN Y
 S X=$G(^ACRDOC(D0,"TRNG")) S Y=$P(X,U,25) S Y(0)=Y S Y=$$NAME2^ACRFUTL1(Y) W $E(Y,1,20)
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
