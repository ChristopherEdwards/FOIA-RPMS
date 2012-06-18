ANSQPAH ; GENERATED FROM 'ANS ASSESSMENT-HEAD' PRINT TEMPLATE (#335) ; 06/09/98 ; (FILE 9009052, MARGIN=80)
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
 D T Q:'DN  D N D N D N:$X>4 Q:'DN  W ?4 W "NURSING PATIENT ACUITY SYSTEM"
 D T Q:'DN  D N D N:$X>4 Q:'DN  W ?4 W "LIST OF DATE AND SHIFT OF COMPLETED ASSESSMENTS"
 D N:$X>4 Q:'DN  W ?4 W "AND DICSHARGE DATE FOR THE PATIENT"
 D N:$X>0 Q:'DN  W ?0 W "================================================================================"
 D N:$X>53 Q:'DN  W ?53 W "* ASSESSMENTS *"
 D N:$X>70 Q:'DN  W ?70 W "DISCHARGE"
 D N:$X>4 Q:'DN  W ?4 W "NAME"
 D N:$X>36 Q:'DN  W ?36 W "UNIT"
 D N:$X>53 Q:'DN  W ?53 W "DATE"
 D N:$X>63 Q:'DN  W ?63 W "SHIFT"
 D N:$X>70 Q:'DN  W ?70 W "DATE"
 D N:$X>0 Q:'DN  W ?0 W "--------------------------------------------------------------------------------"
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
