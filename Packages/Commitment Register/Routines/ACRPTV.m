ACRPTV ; GENERATED FROM 'ACR TRAVEL VOUCHER' PRINT TEMPLATE (#3865) ; 09/30/09 ; (FILE 9002196, MARGIN=80)
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
 I $D(DXS)<9 M DXS=^DIPT(3865,"DXS")
 S I(0)="^ACRDOC(",J(0)=9002196
 I $E($G(IOST),1,2)="C-" W "ARMS REF: ",$P(^ACRDOC(D0,0),U,6),"/",D0 K DIP K:DN Y
 S ACRDOCDA=D0 K DIP K:DN Y
 D N:$X>9 Q:'DN  W ?9 W "DHHS/INDIAN HEALTH SERVICE - TRAVEL VOUCHER"
 D N:$X>9 Q:'DN  W ?9 W "TRAVEL ORDER #: "
 S X=$G(^ACRDOC(D0,0)) W ?27,$E($P(X,U,1),1,17)
 D N:$X>44 Q:'DN  W ?44 W "VOUCHER NO.:"
 W ?58,$E($P(X,U,2),1,15)
 D N:$X>9 Q:'DN  W ?9 W "DHHS #: "
 W $$EXPDN^ACRFUTL(D0) K DIP K:DN Y
 D N:$X>0 Q:'DN  W ?0 W "--------------------------------------------------------------------------------"
 D N:$X>0 Q:'DN  W ?0 W "TRAVELER........:"
 S X=$G(^ACRDOC(D0,"TO")) D N:$X>19 Q:'DN  W ?19 S Y=$P(X,U,9) S Y(0)=Y S Y=$$NAME2^ACRFUTL1(Y) W $E(Y,1,30)
 D N:$X>51 Q:'DN  W ?51 W "DEPART:"
 S X=$G(^ACRDOC(D0,"TO")) W ?60 S Y=$P(X,U,14) D DT
 D N:$X>0 Q:'DN  W ?0 W "SOC SECURITY NO.:  "
 W $$PSSN^ACRFUTL($P($G(^ACRDOC(D0,"TO")),U,9),$G(DUZ),$G(IOST),$G(ACRSSNOK)) K DIP K:DN Y
 D N:$X>51 Q:'DN  W ?51 W "RETURN:"
 S X=$G(^ACRDOC(D0,"TO")) W ?60 S Y=$P(X,U,15) D DT
 D N:$X>0 Q:'DN  W ?0 W "MAILING ADDRESS.:"
 D N:$X>19 Q:'DN  W ?19 X DXS(1,9.2) S X=$P(DIP(101),U,1) S D0=I(0,0) K DIP K:DN Y W X
 D N:$X>51 Q:'DN  W ?51 W "PHONE.:"
 W:$E(IOST,1,2)="C-" "  ***-***-****" K DIP K:DN Y
 X DXS(2,9) K DIP K:DN Y
 D N:$X>19 Q:'DN  W ?19 X DXS(3,9.2) S X=$P(DIP(101),U,2) S D0=I(0,0) K DIP K:DN Y W X
 D N:$X>19 Q:'DN  W ?19 X DXS(4,9.2) S X=$P(DIP(101),U,4) S D0=I(0,0) K DIP K:DN Y W X
 W ", "
 X DXS(5,9.2) S X=$P($G(^DIC(5,+$P(DIP(101),U,5),0)),U) S D0=I(0,0) K DIP K:DN Y W X
 W "  "
 X DXS(6,9.2) S X=$P(DIP(101),U,6) S D0=I(0,0) K DIP K:DN Y W X
 D N:$X>0 Q:'DN  W ?0 W "PRESENT STATION.:"
 S X=$G(^ACRDOC(D0,"TO")) D N:$X>19 Q:'DN  W ?19 S Y=$P(X,U,13) S Y=$S(Y="":Y,$D(^AUTTLOC(Y,0))#2:$P(^(0),U),1:Y) S Y=$S(Y="":Y,$D(^DIC(4,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 D N:$X>0 Q:'DN  W ?0 W "----------  TRAVEL ADVANCE  -----------"
 D N:$X>39 Q:'DN  W ?39 W "---------  CASH PAYMENT RECEIPT  --------"
 D N:$X>0 Q:'DN  W ?0 W "OUTSTANDING..........:"
 W ?24 S Y=$P(X,U,25) W:Y]"" $J(Y,8,2)
 D N:$X>39 Q:'DN  W ?39 W "| DATE RECEIVED:"
 D N:$X>59 Q:'DN  W ?59 W "| AMOUNT RECEIVED:"
 D N:$X>0 Q:'DN  W ?0 W "AMOUNT TO BE APPLIED.:"
 W ?24 S Y=$P(X,U,25) W:Y]"" $J(Y,8,2)
 D N:$X>39 Q:'DN  W ?39 W "|___________________|___________________"
 D N:$X>0 Q:'DN  W ?0 W "AMOUNT DUE GOVERNMENT:"
 D EN11^ACRFCLM K DIP K:DN Y
 I $G(ACRADV)>$G(ACRX) W $J($FN(ACRADV-ACRX,"P",2),11) K DIP K:DN Y
 D N:$X>39 Q:'DN  W ?39 W "| PAYEE'S SIGNATURE:"
 D PAUSE^ACRFWARN K DIP K:DN Y
 S ACRY="PURPOSE OF TRAVEL" D JUST^ACRFSSD1 K DIP K:DN Y
 K DXS S D0=ACRDOCDA D ^ACRPTVI K DIP K:DN Y
 D ^ACRFCLM K DIP K:DN Y
 D N:$X>0 Q:'DN  W ?0 W "NOTE: Falsification of an item in an expense account works a forfeiture of claim"
 D N:$X>0 Q:'DN  W ?0 W "(28 U.S.C. 2514 and may result in a fine of not more than $10,000 or imprison-"
 D N:$X>0 Q:'DN  W ?0 W "ment for not more than five (5) years or both (18 U.S.C. 287 i.d. 1001)."
 D ^ACRFPAPV K DIP K:DN Y
 D ^ACRFPSS K DIP K:DN Y
 D N:$X>0 Q:'DN  W ?0 W "|------------------------------------------------------------------------------|"
 D N:$X>3 Q:'DN  W ?3 W "IHS 531 (6/94) Computerized Modification of Standard Form 1012 (Rev.10/77)"
 S ACRPRT="" K DIP K:DN Y
 D ^ACRFSS4 K DIP K:DN Y
 D EXIT^ACRFCLM K DIP K:DN Y
 D T Q:'DN  W ?2 D PTR^ACRFTO K DIP K:DN Y
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
