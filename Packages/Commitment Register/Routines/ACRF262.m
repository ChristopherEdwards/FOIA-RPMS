ACRF262 ;IHS/OIRM/DSD/THL,AEF - AWARD/CONTRACT - CON'T;  [ 11/01/2001   9:44 AM ]
 ;;2.1;ADMIN RESOURCE MGT SYSTEM;;NOV 05, 2001
PSC D H
 W !?2
 I $G(ACR9(3))=""&($G(ACR16(3))="") W !?2
 W $G(ACR9(1)),?41,$G(ACR16(1))
 W !?2
 W $G(ACR9(2)),?41,$G(ACR16(2))
 W !?2
 I $G(ACR9(3))]""!($G(ACR16(3))]"") D
 .W !?2,$G(ACR9(3)),?41,$G(ACR16(3))
 W !?2,$G(ACR9(4)),", ",$G(ACR9(5)),"  ",$G(ACR9(6))
 W ?41,$G(ACR16(4)),", ",$G(ACR16(5)),"  ",$G(ACR16(6))
 W !?2,$G(ACR7A)," (",$G(ACR7B),")"
VENDOR W !!
 I $G(ACR17(3))="" W !
 W !?2
 W $G(ACR17(1))
 W !?2
 W $G(ACR17(2))
 I $G(ACR17(3))]"" D
 .W !?2,$G(ACR17(3))
 W !?2,$G(ACR17(4)),", ",$G(ACR17(5))," ",$G(ACR17(6))," (",$G(ACR17(7))_")"
 W !?9,$G(ACR17(7))
 W !!!!!?2
 W $G(ACR15(1)),?41,$G(ACR18(1))
 W !?2
 W $G(ACR15(2)),?41,$G(ACR18(2))
 W !?2,$G(ACR15(4)),", ",$G(ACR15(5))," ",$G(ACR15(6))," (",$G(ACR15(7))_")"
 W ?41,$G(ACR18(4)),", ",$G(ACR18(5))," ",$G(ACR18(6))," (",$G(ACR18(7))_")"
 D ^ACRFPSS
 W !
 K ACRTOP
 D DISPLAY^ACRFSS12
 I $D(ACRTOP) K ACRTOP Q
DISP ;EP;
 F X=$Y:1:36 W !
 W !?2,$P($G(ACR21),U),?41,$P($G(ACR21),U,9)
 W !?2,$P($G(ACR21),U,2)
 W !?2,$P($G(ACR21),U,3),?41,$P($G(ACR21),U,10)
 W !?2,$P($G(ACR21),U,4)
 W !?2,$P($G(ACR21),U,5),?41,$P($G(ACR21),U,11)
 W !?2,$P($G(ACR21),U,6)
 W !?2,$P($G(ACR21),U,7),?41,$P($G(ACR21),U,12)
 W !?2,$P($G(ACR21),U,8),?41,$P($G(ACR21),U,13)
 D ^ACRFPAPV
 F X=$Y:1:53 W !
 W !?41,$G(ACRUS),"  ",$P($G(ACRAP),"@")
 W:'$D(ACRTOP) @IOF
 Q
L W $$DASH^ACRFMENU
 Q
HEAD ;EP;
 W !,"AWARD/CONTRACT  (CON'T)"
 W !?2,"CONTRACT NO.",?30,"EFFECTIVE DATE",?49,"REQUISITION NUMBER"
 W $$DASH^ACRFMENU
H G @("L"_ACRADJST)
L0 W !?60,$G(ACR13B)
 W ?77,$G(ACRPOPG)
L1 W !
L2 W !?2,$P($G(ACRDOC0),U,2)
 W ?30,$G(ACREFFD)
 W ?49,$P($G(ACRDOC0),U)
 Q
