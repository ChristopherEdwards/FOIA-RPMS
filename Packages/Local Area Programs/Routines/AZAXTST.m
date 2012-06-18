AZAXTST ; GENERATED FROM 'AEF TEST TEMPLATE' PRINT TEMPLATE (#3490) ; 04/14/04 ; (FILE 1991212, MARGIN=80)
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
 I $D(DXS)<9 M DXS=^DIPT(3490,"DXS")
 S I(0)="^DIZ(1991212,",J(0)=1991212
 S X=$G(^DIZ(1991212,D0,0)) W ?0,$E($P(X,U,1),1,30)
 W ?32 S Y=$P(X,U,3) D DT
 W ?45 S Y=$P(X,U,4) W:Y]"" $S($D(DXS(1,Y)):DXS(1,Y),1:Y)
 D T Q:'DN  W ?2 S Y=$P(X,U,2) S Y(0)=Y S Y=$E(Y,1,3)_"-"_$E(Y,4,5)_"-"_$E(Y,6,9) W $E(Y,1,30)
 S I(1)=3,J(1)=1991212.09 F D1=0:0 Q:$O(^DIZ(1991212,D0,3,D1))'>0  X:$D(DSC(1991212.09)) DSC(1991212.09) S D1=$O(^(D1)) Q:D1'>0  D:$X>34 T Q:'DN  D A1
 G A1R
A1 ;
 S X=$G(^DIZ(1991212,D0,3,D1,0)) W ?34,$E($P(X,U,1),1,30)
 W ?66 S Y=$P(X,U,2) W:Y]"" $S($D(DXS(2,Y)):DXS(2,Y),1:Y)
 Q
A1R ;
 S X=$G(^DIZ(1991212,D0,4)) D T Q:'DN  W ?2,$E($P(X,U,1),1,15)
 W ?19 S Y=$P(X,U,2) W:Y]"" $J(Y,11,2)
 W ?32 S Y=$P(X,U,3) D DT
 W ?45 S Y=$P(X,U,5) D DT
 W ?58 S Y=$P(X,U,6) D DT
 D T Q:'DN  W ?2,$E($P(X,U,7),1,50)
 W ?54 S Y=$P(X,U,8) W:Y]"" $J(Y,4,0)
 K Y
 Q
HEAD ;
 W !,?0,"NAME",?32,"DOB",?45,"SEX"
 W !,?2,"SSN",?34,"HOBBIES",?66,"SKILL LEVEL"
 W !,?24,"ANNUAL",?32,"DATE",?45,"DATE OF",?58,"DATE OF"
 W !,?2,"TITLE",?24,"INCOME",?32,"ENTERED",?45,"HIRE",?58,"SEPARATION"
 W !,?54,"LUCKY"
 W !,?2,"REASON FOR SEPARATION",?54,"NUMBER"
 W !,"--------------------------------------------------------------------------------",!!
