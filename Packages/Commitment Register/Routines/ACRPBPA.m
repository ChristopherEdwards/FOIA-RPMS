ACRPBPA ; GENERATED FROM 'ACR BPA' PRINT TEMPLATE (#3906) ; 09/29/09 ; (FILE 9002196, MARGIN=80)
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
 D N:$X>19 Q:'DN  W ?19 W "BLANKET PURCHASE AGREEMENT CERTIFICATION"
 D N:$X>19 Q:'DN  W ?19 W "REQUISITION NUMBER:"
 S X=$G(^ACRDOC(D0,0)) W ?40,$E($P(X,U,1),1,17)
 D N:$X>19 Q:'DN  W ?19 W "PURCHASE ORDER NO.:"
 W ?40,$E($P(X,U,2),1,15)
 D N:$X>20 Q:'DN  W ?20 W "DHHS DOCUMENT NO.:  "
 W $$EXPDN^ACRFUTL(D0) K DIP K:DN Y
 D T Q:'DN  D N D N W ?0 W "Open Market Purchases are not authorized under this BPA that are"
 D N:$X>0 Q:'DN  W ?0 W "available from mandatory sources of supply such as:  PAO Warehouse,"
 D N:$X>0 Q:'DN  W ?0 W "Federal Supply Schedule, and Veteran's Administration."
 D T Q:'DN  D N W ?0 W "1.   Blanket Purchase Arrangement to provide supplies/services as described"
 D N:$X>5 Q:'DN  W ?5 W "in the attached Purchase Order."
 D T Q:'DN  D N W ?0 W "The following conditions apply to this Blanket Purchase Arrangement"
 D T Q:'DN  D N W ?0 W "2.   The government is obligated to this Blanket Purchase Arrangement:"
 D N:$X>5 Q:'DN  W ?5 W "purchases actually made under this arrangement."
 D T Q:'DN  D N W ?0 W "3.   Contractor's established price list and discounts shall apply to"
 D N:$X>5 Q:'DN  W ?5 W "all orders issued against this arrangement in addition to any"
 D N:$X>5 Q:'DN  W ?5 W "discounts for prompt payment."
 D T Q:'DN  D N W ?0 W "4.   Individual calls placed against this BPA are not to exceed"
 S X=$G(^ACRDOC(D0,3)) D N:$X>5 Q:'DN  W ?5 S Y=$P(X,U,10) W:Y]"" $J(Y,9,2)
 W ?16 W "without telephone confirmation."
 D T Q:'DN  D N W ?0 W "5.   The only authorized personnel to place an order against this"
 D N:$X>5 Q:'DN  W ?5 W "arrangement are:"
 D N:$X>5 Q:'DN  W ?5 W "                "
 S I(1)=6,J(1)=9002196.06 F D1=0:0 Q:$O(^ACRDOC(D0,6,D1))'>0  X:$D(DSC(9002196.06)) DSC(9002196.06) S D1=$O(^(D1)) Q:D1'>0  D:$X>23 T Q:'DN  D A1
 G A1R
A1 ;
 S X=$G(^ACRDOC(D0,6,D1,0)) D N:$X>5 Q:'DN  W ?5 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^ACRAU(Y,0))#2:$P(^(0),U),1:Y) S Y=$S(Y="":Y,$D(^VA(200,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,35)
 Q
A1R ;
 D T Q:'DN  D N W ?0 W "6.   Delivery Tickets shall contain the following minimum information:"
 D T Q:'DN  D N D N:$X>5 Q:'DN  W ?5 W "a.  Name of Supplier"
 D N:$X>5 Q:'DN  W ?5 W "b.  Blanket Purchase Arrangement Number"
 D N:$X>5 Q:'DN  W ?5 W "c.  Date of call order"
 D N:$X>5 Q:'DN  W ?5 W "d.  Identification of the individual placing the call"
 D N:$X>5 Q:'DN  W ?5 W "e.  Itemized list of supplies furnished"
 D N:$X>5 Q:'DN  W ?5 W "f.  Quantity, unit price and extension"
 D N:$X>5 Q:'DN  W ?5 W "g.  Date of Delivery"
 D T Q:'DN  D N W ?0 W "7.   A Summary Invoice shall be submitted monthly or upon expiration of the"
 D N:$X>5 Q:'DN  W ?5 W "Blanket Purchase Arrangement, whichever occurs first for all deliveries"
 D N:$X>5 Q:'DN  W ?5 W "made during the billing period, covered therein, stating their total"
 D N:$X>5 Q:'DN  W ?5 W "dollar value, and supported by receipted copies of the delivery"
 D N:$X>5 Q:'DN  W ?5 W "tickets or sales slips."
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
