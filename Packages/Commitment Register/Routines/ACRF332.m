ACRF332 ;IHS/OIRM/DSD/THL,AEF - SOLICITATION, OFFER AND AWARD - CON'T; [ 11/01/2001   9:44 AM ]
 ;;2.1;ADMIN RESOURCE MGT SYSTEM;;NOV 05, 2001
PSC D H
 W !
 W:$G(ACR4)=2 ?39,"XX"
 W !
 I $G(ACR9(3))=""&($G(ACR16(3))="") W !
 W ?2,$G(ACR9(1)),?41,$G(ACR16(1))
 W !?2
 W $G(ACR9(2)),?41,$G(ACR16(2))
 I $G(ACR9(3))]""!($G(ACR16(3))]"") D
 .W !?2,$G(ACR9(3)),?41,$G(ACR16(3))
 W !?2,$G(ACR9(4)),", ",$G(ACR9(5)),"  ",$G(ACR9(6))
 W ?41,$G(ACR16(4)),", ",$G(ACR16(5)),"  ",$G(ACR16(6))
 W !!!!?18,$G(ACRCOPY)
 W !?23,$G(ACRDET),?59,$G(ACRHOUR),?69,$G(ACRDATE)
 K ACRDET
 W !!!!!?17,$G(ACR7A),?48,$G(ACR7B)
 W !!!
 W !?2,$P($G(ACR21),U),?41,$P($G(ACR21),U,9)
 W !?2,$P($G(ACR21),U,2)
 W !?2,$P($G(ACR21),U,3),?41,$P($G(ACR21),U,10)
 W !?2,$P($G(ACR21),U,4)
 W !?2,$P($G(ACR21),U,5),?41,$P($G(ACR21),U,11)
 W !?2,$P($G(ACR21),U,6)
 W !?2,$P($G(ACR21),U,7),?41,$P($G(ACR21),U,12)
 W !?2,$P($G(ACR21),U,8),?41,$P($G(ACR21),U,13)
VENDOR F X=$Y:1:35 W !
 I $G(ACR17(3))="" W !
 W !!?11
 W $G(ACR17(1))
 W !?11
 W $G(ACR17(2))
 I $G(ACR17(3))]"" D
 .W !?11,$G(ACR17(3))
 W !?11,$G(ACR17(4)),", ",$G(ACR17(5))," ",$G(ACR17(6))," (",$G(ACR17(7))_")"
 W !!!
 D ^ACRFPSS
 W !!!!?2
 W $G(ACR16(1)),?41,$G(ACR18(1))
 W !?2
 W $G(ACR16(2)),?41,$G(ACR18(2))
 W !?2,$E($G(ACR15(4)),1,13),", ",$G(ACR16(5))," ",$G(ACR16(6))," (",$G(ACR16(7))_")"
 W ?41,$E($G(ACR18(4)),1,13),", ",$G(ACR18(5))," ",$G(ACR18(6))," (",$G(ACR18(7))_")"
 D ^ACRFPAPV
 F X=$Y:1:54 W !
 W !?2,ACRUS,?68,$P(ACRAP,"@")
 W @IOF
 Q
H G @("L"_ACRADJST)
L0 W !?60,$G(ACR13B)
 W ?77,$G(ACRPOPG)
L1 W !
L2 W !?2,$P($G(ACRDOC0),U,2)
 W ?20,$G(ACR5)
 W:$G(ACR4)=1 ?39,"XX"
 W ?51,$G(ACR6)
 W ?66,$P($G(ACRDOC0),U)
 Q
DISP ;EP
 Q
HEAD ;EP;
 Q
