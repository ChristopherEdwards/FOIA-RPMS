ACRPQH ; GENERATED FROM 'ACR REQUEST FOR QUOTATION-H' PRINT TEMPLATE (#3972) ; 09/29/09 ; (FILE 9002196, MARGIN=80)
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
 D N:$X>0 Q:'DN  W ?0 W "--------------------------------------------------------------------------------"
 D N:$X>28 Q:'DN  W ?28 W "REQUEST FOR QUOTATION"
 I 1 S ACRDC=$S($D(ACRDC)#2:ACRDC+1,1:1) K DIP K:DN Y
 D N:$X>66 Q:'DN  W ?66 W "|PAGE NO."
 D N:$X>27 Q:'DN  W ?27 W "SCHEDULE - CONTINUATION"
 D N:$X>66 Q:'DN  W ?66 W "|"
 D N:$X>0 Q:'DN  W ?0 W "------------------------------------------------------------------|"
 D N:$X>0 Q:'DN  W ?0 W "IMPORTANT: MARK ALL PACKAGES & PAPERS WITH CONTRACT &/OR ORDER NO."
 D N:$X>66 Q:'DN  W ?66 W "|"
 W ?69 W ?70,ACRDC K DIP K:DN Y
 D N:$X>0 Q:'DN  W ?0 W "--------------------------------------------------------------------------------"
 D N:$X>0 Q:'DN  W ?0 W "DATE OF ORDER"
 D N:$X>19 Q:'DN  W ?19 W "|CONTRACT NO."
 D N:$X>39 Q:'DN  W ?39 W "|ORDER NO."
 D N:$X>59 Q:'DN  W ?59 W "|REQUISITION/REF #"
 S X=$G(^ACRDOC(D0,"PO")) D N:$X>3 Q:'DN  W ?3 S Y=$P(X,U,1) D DT
 D N:$X>19 Q:'DN  W ?19 W "|"
 D N:$X>23 Q:'DN  W ?23,$E($P(X,U,2),1,15)
 D N:$X>39 Q:'DN  W ?39 W "|"
 S X=$G(^ACRDOC(D0,0)) D N:$X>43 Q:'DN  W ?43,$E($P(X,U,2),1,15)
 D N:$X>59 Q:'DN  W ?59 W "|"
 D N:$X>63 Q:'DN  W ?63,$E($P(X,U,1),1,17)
 D N:$X>19 Q:'DN  W ?19 W "|"
 D N:$X>24 Q:'DN  W ?24 W "DHHS #:  "
 W $$EXPDN^ACRFUTL(D0) K DIP K:DN Y
 D N:$X>59 Q:'DN  W ?59 W "|"
 D N:$X>0 Q:'DN  W ?0 W "--------------------------------------------------------------------------------"
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
