AFSLVNV ; GENERATED FROM 'AFSL.VNDLST' PRINT TEMPLATE (#1076) ; 09/29/09 ; (FILE 9999999.11, MARGIN=80)
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
 I $D(DXS)<9 M DXS=^DIPT(1076,"DXS")
 S I(0)="^AUTTVNDR(",J(0)=9999999.11
 S X=$G(^AUTTVNDR(D0,0)) D N:$X>0 Q:'DN  W ?0,$E($P(X,U,1),1,30)
 S X=$G(^AUTTVNDR(D0,11)) D N:$X>31 Q:'DN  W ?31,$E($P(X,U,1),1,10)
 W ?0,$E($P(X,U,2),1,30)
 D N:$X>46 Q:'DN  W ?46 S DIP(1)=$S($D(^AUTTVNDR(D0,0)):^(0),1:"") S X=$P(DIP(1),U,5) S:X X=$E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3) K DIP K:DN Y W X
 S X=$G(^AUTTVNDR(D0,11)) W ?57 S Y=$P(X,U,7) W:Y]"" $J(Y,13,2)
 S X=$G(^AUTTVNDR(D0,13)) D N:$X>0 Q:'DN  W ?0,$E($P(X,U,5),1,20)
 D N:$X>0 Q:'DN  W ?0,$E($P(X,U,1),1,30)
 D N:$X>0 Q:'DN  W ?0,$E($P(X,U,2),1,20)
 W ", "
 S Y=$P(X,U,3) S Y=$S(Y="":Y,$D(^DIC(5,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 W "  "
 W ?0,$E($P(X,U,4),1,10)
 D N:$X>34 Q:'DN  W ?34 W "YTD PAID:"
 S X=$G(^AUTTVNDR(D0,11)) D N:$X>44 Q:'DN  W ?44 S Y=$P(X,U,7) W:Y]"" $J(Y,13,2)
 D N:$X>56 Q:'DN  W ?56 W "1099 PRINTED:"
 D N:$X>71 Q:'DN  W ?71 S Y=$P(X,U,6) W:Y]"" $S($D(DXS(1,Y)):DXS(1,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "CONTRACT#"
 S I(1)="""CN""",J(1)=9999999.1112 F D1=0:0 Q:$O(^AUTTVNDR(D0,"CN",D1))'>0  X:$D(DSC(9999999.1112)) DSC(9999999.1112) S D1=$O(^(D1)) Q:D1'>0  D:$X>11 T Q:'DN  D A1
 G A1R
A1 ;
 S X=$G(^AUTTVNDR(D0,"CN",D1,0)) D N:$X>11 Q:'DN  W ?11,$E($P(X,U,1),1,18)
 W ?31 S DIP(1)=$S($D(^AUTTVNDR(D0,"CN",D1,0)):^(0),1:"") S X=$P(DIP(1),U,2) S:X X=$E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3) K DIP K:DN Y W X
 W "-"
 S DIP(1)=$S($D(^AUTTVNDR(D0,"CN",D1,0)):^(0),1:"") S X=$P(DIP(1),U,3) S:X X=$E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3) K DIP K:DN Y W X
 S X=$G(^AUTTVNDR(D0,"CN",D1,0)) D N:$X>54 Q:'DN  W ?54 S Y=$P(X,U,4) W:Y]"" $J(Y,14,2)
 Q
A1R ;
 D N:$X>0 Q:'DN  W ?0 W "- - - - - - - - - - - - - - - - - - - - "
 D N:$X>40 Q:'DN  W ?40 W "- - - - - - - - - - - - - - - - - - - - "
 K Y
 Q
HEAD ;
 W !,?31,"EIN# &",?46,"DATE"
 W !,?0,"NAME",?31,"SFX.",?46,"INACTIVE",?62,"YTD PAID"
 W !,?0,"MAILING"
 W !,?0,"ADDRESS-ATTENTION"
 W !,?0,"MAILING ADDRESS-STREET"
 W !,?0,"MAILING ADDRESS-CITY",?49,"YTD PAID"
 W !,?71,"1099"
 W !,?71,"(Y/N)"
 W !,?59,"AMOUNT OF"
 W !,?11,"CONTRACT NUMBER",?31,"BEG.DATE",?60,"CONTRACT"
 W !,"--------------------------------------------------------------------------------",!!
