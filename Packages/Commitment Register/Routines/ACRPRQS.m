ACRPRQS ; GENERATED FROM 'ACR REQUISITION-TX SUMMARY' PRINT TEMPLATE (#3961) ; 09/29/09 ; (FILE 9002196, MARGIN=80)
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
 I $D(DXS)<9 M DXS=^DIPT(3961,"DXS")
 S I(0)="^ACRDOC(",J(0)=9002196
 I $E($G(IOST),1,2)="C-" W "ARMS REF: ",$P(^ACRDOC(D0,0),U,6),"/",D0 K DIP K:DN Y
 W ?0 I '$D(ACRCSI) S ACRX=$P(^ACRTXTYP($P(^ACRDOC(D0,0),U,4),0),U) W !?23,ACRX,?60,"HHS-393" K DIP K:DN Y
 W ?11 X DXS(1,9) K DIP K:DN Y
 D T Q:'DN  D N W ?0 W "REQUISITION NO.....:"
 S X=$G(^ACRDOC(D0,0)) W ?22,$E($P(X,U,1),1,17)
 W "  (",$E("000000",1,6-$L(D0)),D0,")" K DIP K:DN Y
 D N:$X>56 Q:'DN  W ?56 W "DATE.....:"
 S X=$G(^ACRDOC(D0,"REQ")) W ?68 S Y=$P(X,U,5) D DT
 D N:$X>0 Q:'DN  W ?0 W "REQUESTED BY.......:"
 W ?22 S Y=$P(X,U,12) S Y=$S(Y="":Y,$D(^VA(200,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,35)
 D N:$X>56 Q:'DN  W ?56 W "PHONE NO.:"
 W ?68,$E($P(X,U,8),1,12)
 D N:$X>0 Q:'DN  W ?0 W "FOR REFERENCE CALL.:"
 W ?22 S Y=$P(X,U,7) S Y=$S(Y="":Y,$D(^VA(200,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,35)
 D N:$X>56 Q:'DN  W ?56 W "DATE"
 D N:$X>0 Q:'DN  W ?0 W "DELIVER TO.........:"
 S X=$G(^ACRDOC(D0,"REQ1")) W ?22 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^AUTTPRG(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 D N:$X>56 Q:'DN  W ?56 W "REQUESTED:"
 S X=$G(^ACRDOC(D0,"REQ")) W ?68 S Y=$P(X,U,11) D DT
 D N:$X>56 Q:'DN  W ?56 W "PRIORITY.:"
 S X=$G(^ACRDOC(D0,"DT")) W ?68 S Y=$P(X,U,4) W:Y]"" $S($D(DXS(2,Y)):DXS(2,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "REQUESTING OFFICE..:"
 S X=$G(^ACRDOC(D0,"PO")) W ?22 S Y=$P(X,U,7) S Y=$S(Y="":Y,$D(^AUTTPRG(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 S X=$G(^ACRDOC(D0,"DT")) D N:$X>9 Q:'DN  W ?9,$E($P(X,U,5),1,40)
 D N:$X>9 Q:'DN  W ?9,$E($P(X,U,6),1,40)
 D N:$X>9 Q:'DN  W ?9,$E($P(X,U,7),1,40)
 D N:$X>9 Q:'DN  W ?9,$E($P(X,U,8),1,40)
 D N:$X>9 Q:'DN  W ?9,$E($P(X,U,9),1,40)
 W ?51 S ACRDOCDA=D0,ACRDOC=$P(^ACRDOC(D0,0),U) D DISPLAY^ACRFSS12 K DIP K:DN Y
 W ?62 D ^ACRFPSS K DIP K:DN Y
 D T Q:'DN  W ?2 D:$D(ACRREV)&'$D(ACRPRT) ASUM^ACRFEA42 K DIP K:DN Y
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
