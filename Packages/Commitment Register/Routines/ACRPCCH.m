ACRPCCH ; GENERATED FROM 'ACR CREDIT CARD HEAD' PRINT TEMPLATE (#3953) ; 09/29/09 ; (FILE 9002193, MARGIN=132)
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
 S I(0)="^ACRSS(",J(0)=9002193
 D N:$X>0 Q:'DN  W ?0 W "DATE/"
 D N:$X>57 Q:'DN  W ?57 W "OBJ"
 D N:$X>63 Q:'DN  W ?63 W "QUAN"
 D N:$X>72 Q:'DN  W ?72 W "UNIT"
 D N:$X>0 Q:'DN  W ?0 W "DOCUMENT"
 D N:$X>16 Q:'DN  W ?16 W "DESCRIPTION"
 D N:$X>48 Q:'DN  W ?48 W "CAN"
 D N:$X>57 Q:'DN  W ?57 W "CODE"
 D N:$X>63 Q:'DN  W ?63 W "TITY"
 D N:$X>71 Q:'DN  W ?71 W "ISSUE"
 W "  UNIT PRICE  TOTAL PRICE  RECEIVED  BILLED"
 D N:$X>0 Q:'DN  W ?0 W "--------------"
 D N:$X>16 Q:'DN  W ?16 W "------------------------------"
 D N:$X>48 Q:'DN  W ?48 W "-------"
 D N:$X>57 Q:'DN  W ?57 W "----"
 D N:$X>63 Q:'DN  W ?63 W "------"
 D N:$X>71 Q:'DN  W ?71 W "-----"
 W "  ----------  -----------  --------  -----------"
 K Y
 Q
HEAD ;
 W !,"------------------------------------------------------------------------------------------------------------------------------------",!!
