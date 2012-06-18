ACGPCS ; GENERATED FROM 'ACG CONTRACT SUMMARY' PRINT TEMPLATE (#4002) ; 10/01/09 ; (FILE 9002330, MARGIN=80)
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
 S I(0)="^ACGS(",J(0)=9002330
 D N:$X>0 Q:'DN  W ?0 W "CONTRACTOR......:"
 S X=$G(^ACGS(D0,"DT")) W ?19,$E($P(X,U,5),1,30)
 D N:$X>54 Q:'DN  W ?54 W "EIN:"
 W ?60,$E($P(X,U,11),1,12)
 D N:$X>0 Q:'DN  W ?0 W "ADDRESS.........:"
 W ?19,$E($P(X,U,6),1,30)
 W " "
 W ?0,$E($P(X,U,7),1,23)
 W ", "
 S Y=$P(X,U,8) S Y=$S(Y="":Y,$D(^DIC(5,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 W "  "
 W ?51,$E($P(X,U,9),1,5)
 D N:$X>0 Q:'DN  W ?0 W "CONTRACT NO.....:"
 W ?19,$E($P(X,U,2),1,15)
 D N:$X>39 Q:'DN  W ?39 W "CONTRACT AMOUNT.:"
 S X=$G(^ACGS(D0,"DT1")) W ?58 S Y=$P(X,U,5) W:Y]"" $J(Y,10,0)
 D N:$X>0 Q:'DN  W ?0 W "TITLE...........:"
 D N:$X>19 Q:'DN  S DIWL=20,DIWR=79 S Y=$P(X,U,1) S X=Y D ^DIWP
 D 0^DIWW
 D ^DIWW
 D N:$X>0 Q:'DN  W ?0 W "PURPOSE CODE....:"
 S X=$G(^ACGS(D0,"DT1")) W ?19 S Y=$P(X,U,6) S Y=$S(Y="":Y,$D(^ACGPPC(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,4)
 D N:$X>39 Q:'DN  W ?39 W "NEG AUTHORITY...:"
 S X=$G(^ACGS(D0,"DT")) W ?58,$E($P(X,U,14),1,2)
 D N:$X>0 Q:'DN  W ?0 W "TYPE OF CONTRACT:"
 W ?19 S Y=$P(X,U,15) S Y=$S(Y="":Y,$D(^ACGTOC(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,2)
 D N:$X>39 Q:'DN  W ?39 W "SOLICITATION PDR:"
 W ?58 S Y=$P(X,U,17) S Y=$S(Y="":Y,$D(^ACGSP(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,2)
 D N:$X>0 Q:'DN  W ?0 W "TYPE OF BUSINESS:"
 W ?19 S Y=$P(X,U,13) S Y=$S(Y="":Y,$D(^AUTTTOB(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,2)
 D N:$X>0 Q:'DN  W ?0 W "EFFECTIVE DATE..:"
 S X=$G(^ACGS(D0,"DT1")) W ?19 S Y=$P(X,U,3) D DT
 D N:$X>39 Q:'DN  W ?39 W "TERMINATION DATE:"
 W ?58 S Y=$P(X,U,4) D DT
 K Y K DIWF
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
