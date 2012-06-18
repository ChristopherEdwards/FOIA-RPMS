ACRF3472 ;IHS/OIRM/DSD/THL,AEF - AWARD/CONTRACT - CON'T; [ 11/01/2001   9:44 AM ]
 ;;2.1;ADMIN RESOURCE MGT SYSTEM;;NOV 05, 2001
PSC G @("L"_ACRADJST)
L0 W !?67,$G(ACRPOPG)
L1 W !!
L2 W !!?2,$G(ACREFFD)
 W ?21,$P($G(ACRDOC0),U,2)
 W ?41,$G(ACR3)
 W ?61,$P($G(ACRDOC0),U)
 I $G(ACR5(3))=""&($G(ACR6(3))="") W !
 W !?2
 W $G(ACR5(1)),?41,$G(ACR6(1))
 W !?2
 W $G(ACR5(2)),?41,$G(ACR6(2))
 I $G(ACR5(3))]""!($G(ACR6(3))]"") D
 .W !?2,$G(ACR5(3)),?41,$G(ACR6(3))
 W !?2,$G(ACR5(4)),", ",$G(ACR5(5))," ",$G(ACR5(6))," (",$G(ACR5(7))_")"
 W ?41,$G(ACR6(4)),", ",$G(ACR6(5))," ",$G(ACR6(6))," (",$G(ACR6(7))_")"
 W !!
 I $G(ACR7(3))="" W !
 W !?2
 W $G(ACR7(1))
 W !?2
 W $G(ACR7(2))
 I $G(ACR7(3))]"" D
 .W !?2,$G(ACR7(3))
 W !?2,$G(ACR7(4)),", ",$G(ACR7(5))," ",$G(ACR7(6))," (",$G(ACR7(7))_")"
 W !?9,$G(ACR7(7))
 F X=$Y:1:15 W !
 W !?41,$G(ACR10)
 D ^ACRFPSS
 F X=$Y:1:21 W ! I $Y>20 D 11
 F X=$Y:1:22 W !
 W !?2,$G(ACR12),?30,$G(ACR14),?47,$G(ACR15),?64,$G(ACR16(1))
 I $Y>24 W !?2,$G(ACR13),?64,$G(ACR16(2))
 E  W !?64,$G(ACR16(2)),!?2,$G(ACR13)
 F X=$Y:1:29 W !
 K ACRTOP
 D DISPLAY^ACRFSS12
 I $D(ACRTOP) K ACRTOP Q
DISP ;EP;
 F X=$Y:1:50 W !
 W !?10,$G(ACR18)
 W ?30,$G(ACR19),?47,$G(ACR20)
 W !!?10
 W $G(ACR21(1))
 W !?10
 W $G(ACR21(2)),"  ",$G(ACR21(3)),?60,$J($FN($G(ACRPOTOT),"P,",2),13)
 W !?10,$G(ACR21(4)),", ",$G(ACR21(5))," ",$G(ACR21(6))," (",$G(ACR21(7))_")"
 D ^ACRFPAPV
 F X=$Y:1:50 W !
 W !?47,$G(ACRUS)
 W:'$D(ACRTOP) @IOF
 K ACRTOP
 Q
11 ;EP;
 Q:$G(ACR11)=""
 W:$G(ACR11)="S" ?41
 W:$G(ACR11)="O" ?51
 W:$G(ACR11)="D" ?61
 W:$G(ACR11)="W" ?71
 W "XX"
 Q
