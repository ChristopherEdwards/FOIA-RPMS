ACRPEC ; GENERATED FROM 'ACR EQUIPMENT CERTIFICATION' PRINT TEMPLATE (#3905) ; 09/29/09 ; (FILE 9002196, MARGIN=80)
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
 S I(0)="^ACRDOC(",J(0)=9002196
 D N:$X>9 Q:'DN  W ?9 W "CERTIFICATION FOR THE ACQUISITION OF NEW OR REPLACEMENT EQUIPMENT"
 D N:$X>9 Q:'DN  W ?9 W "REQUISITION NO....:"
 S X=$G(^ACRDOC(D0,0)) W ?30,$E($P(X,U,1),1,17)
 D N:$X>9 Q:'DN  W ?9 W "PURCHASE ORDER NO.:"
 W ?30,$E($P(X,U,2),1,15)
 D N:$X>9 Q:'DN  W ?9 W "DHHS ORDER NO.....:  "
 W $$EXPDN^ACRFUTL(D0) K DIP K:DN Y
 D T Q:'DN  D N D N W ?0 W "A.  The requirement is absolutely essential."
 D T Q:'DN  D N W ?0 W "B.  The item meets existing use standards."
 D T Q:'DN  D N W ?0 W "C.  Validation in accord with DHHS Material Mgt Manual 103-25.150-3."
 D T Q:'DN  D N D N:$X>9 Q:'DN  W ?9 W "1.  Justification of Need"
 D N:$X>13 Q:'DN  W ?13 W "(see justification for each item per attached requisition)"
 D T Q:'DN  D N D N:$X>9 Q:'DN  W ?9 W "2.  Utilization Consideration"
 D N:$X>13 Q:'DN  W ?13 W "(see utilization consideration for each item per attached req.)"
 D T Q:'DN  D N D N:$X>9 Q:'DN  W ?9 W "3.  Other Consideration"
 D N:$X>13 Q:'DN  W ?13 W "(see other consideration for each item per attached requisition)"
 D PAUSE^ACRFWARN K DIP K:DN Y
 D T Q:'DN  D N W ?0 W "D.  There is no other item available within the Bureau to meet the requirement,"
 D N:$X>4 Q:'DN  W ?4 W "either from equipment pools/sharing or from required and excess sources."
 D T Q:'DN  D N W ?0 W "E.  This is the least expensive item which will satisfy the requirements."
 D N:$X>4 Q:'DN  W ?4 W "Approvals requesting other than lowest prices available must be supported"
 D N:$X>4 Q:'DN  W ?4 W "by a justification signed by Executive Officer, Indian Health Service."
 D T Q:'DN  D N W ?0 W "F.  A rehabilitated item will be accepted, if available."
 D T Q:'DN  D N W ?0 W "G.  The appropriate GSA Regional Office Surplus Program does not have"
 D N:$X>4 Q:'DN  W ?4 W "a suitable item to meet the need."
 D T Q:'DN  D N W ?0 W "H.  The requisition will also reflect the following information concerning"
 D N:$X>4 Q:'DN  W ?4 W "the item being replaced, regardless of whether it is being utilized as"
 D N:$X>4 Q:'DN  W ?4 W "a trade in."
 D T Q:'DN  D N D N:$X>4 Q:'DN  W ?4 W "(see attached requisition)"
 D PAUSE^ACRFWARN K DIP K:DN Y
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
