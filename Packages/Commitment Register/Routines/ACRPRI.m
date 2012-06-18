ACRPRI ; GENERATED FROM 'ACR SIGNATURE SUMMARY' PRINT TEMPLATE (#3903) ; 09/30/09 ; (FILE 9002190, MARGIN=80)
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
 I $D(DXS)<9 M DXS=^DIPT(3903,"DXS")
 S I(0)="^ACRAPVS(",J(0)=9002190
 D N:$X>0 Q:'DN  W ?0 W "I CERTIFY THAT ALL ITEMS LISTED ABOVE WERE RECEIVED, INSPECTED AND ACCEPTED"
 S X=$G(^ACRAPVS(D0,"DT")) D N:$X>0 Q:'DN  W ?0 S Y=$P(X,U,2) S Y(0)=Y S Y=$$NAME2^ACRFUTL1(Y) W $E(Y,1,30)
 S X=$G(^ACRAPVS(D0,"DT")) W ?32 S Y=$P(X,U,1) W:Y]"" $S($D(DXS(3,Y)):DXS(3,Y),1:Y)
 W ?45 S Y=$P(X,U,4) D DT
 D N:$X>9 Q:'DN  W ?9 X DXS(1,9) K DIP K:DN Y W X
 D N:$X>9 Q:'DN  W ?9 W "REQ. NO.:"
 S X=$G(^ACRAPVS(D0,0)) W ?20 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^ACRDOC(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,17)
 W ?39 W "PO NO.:"
 W ?48 X DXS(2,9.2) S X=$P(DIP(101),U,2) S D0=I(0,0) K DIP K:DN Y W X
 D N:$X>0 Q:'DN  W ?0 W "COMMENTS:"
 S X=$G(^ACRAPVS(D0,"CNG")) D N:$X>11 Q:'DN  W ?11,$E($P(X,U,1),1,40)
 D N:$X>11 Q:'DN  W ?11,$E($P(X,U,2),1,40)
 D N:$X>11 Q:'DN  W ?11,$E($P(X,U,3),1,40)
 D N:$X>11 Q:'DN  W ?11,$E($P(X,U,4),1,40)
 D N:$X>11 Q:'DN  W ?11,$E($P(X,U,5),1,40)
 S X=$G(^ACRAPVS(D0,"RSN")) D N:$X>11 Q:'DN  W ?11,$E($P(X,U,1),1,40)
 D N:$X>11 Q:'DN  W ?11,$E($P(X,U,2),1,40)
 D N:$X>11 Q:'DN  W ?11,$E($P(X,U,3),1,40)
 D N:$X>11 Q:'DN  W ?11,$E($P(X,U,4),1,40)
 D N:$X>11 Q:'DN  W ?11,$E($P(X,U,5),1,40)
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
