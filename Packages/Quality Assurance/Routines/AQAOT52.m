AQAOT52 ; GENERATED FROM 'AQAO IND DSPL HEADING' PRINT TEMPLATE (#1275) ; 05/13/96 ; (FILE 9002168.2, MARGIN=80)
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
 D N:$X>0 Q:'DN  W ?0 S X=$S('$D(DUZ(2)):"",DUZ(2)="":"",1:$P(^DIC(4,DUZ(2),0),U)) K DIP K:DN Y W $E(X,1,25)
 D N:$X>59 Q:'DN  W ?59 S %=$P($H,",",2),X=DT_(%\60#60/100+(%\3600)+(%#60/10000)/100) S Y=X K DIP K:DN Y S Y=X D DT
 D N:$X>0 Q:'DN  W ?0 S X="CLINICAL INDICATOR DISPLAY",X=$J("",$S($D(DIWR)+$D(DIWL)=2:DIWR-DIWL+1,$D(IOM):IOM,1:80)-$L(X)\2-$X)_X K DIP K:DN Y W X
 D N:$X>0 Q:'DN  W ?0 W "================================================================================"
 D N:$X>0 Q:'DN  W ?0 W " "
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
