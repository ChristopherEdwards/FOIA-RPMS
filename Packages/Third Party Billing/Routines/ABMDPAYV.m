ABMDPAYV ; IHS/ASDST/DMJ - View Payment Activity ; 
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 W $$EN^ABMVDF("IOF")
 N ABM
 S ABM="",$P(ABM,"-",80)="" W !,ABM
PREV S (ABM("TB"),ABM("TP"),ABM("TW"),ABM("TD"))=0
 W !?25,"***** BILLING ACTIVITY ******"
 W !?1,"Bill",?35,"Amount",?45,"Amount",?54,"Co-Ins",?62,"Write"
 W !,"Number",?16,"Insurer",?35,"Billed",?46,"Paid",?54,"Deduct",?63,"Off",?71,"Balance"
 S ABM="",$P(ABM,"=",80)="" W !,ABM
 S ABM("C")="" F  S ABM("C")=$O(^ABMDBILL(DUZ(2),"AS",+ABMP("BILL"),ABM("C"))) Q:ABM("C")=""  S ABM=$O(^(ABM("C"),"")) Q:'ABM  D
 .S ABM=0 F ABM("I")=1:1 S ABM=$O(^ABMDBILL(DUZ(2),"AS",+ABMP("BILL"),ABM("C"),ABM)) Q:'ABM  D
 ..Q:$P($G(^ABMDBILL(DUZ(2),ABM,0)),U,5)'=ABMP("PDFN")
 ..S ABM("D",$P(^ABMDBILL(DUZ(2),ABM,0),U))=ABM
 S ABM("L")="" F  S ABM("L")=$O(ABM("D",ABM("L"))) Q:ABM("L")=""  D
 .S ABM=ABM("D",ABM("L"))
 .S ABM("OB")=+$G(^ABMDBILL(DUZ(2),ABM,2)) S ABM("TB")=ABM("TB")+ABM("OB")
 .W !,$P(^ABMDBILL(DUZ(2),ABM,0),U),?8,$E($P(^AUTNINS($P(^(0),U,8),0),U),1,25)
 .W ?34,$J($FN(ABM("OB"),",",2),9)
 .S ABM("J")=0 F ABM("K")=1:1 S ABM("J")=$O(^ABMDBILL(DUZ(2),ABM,3,ABM("J"))) Q:'ABM("J")  W:ABM("K")>1 ! D
 ..S ABM("P0")=^ABMDBILL(DUZ(2),ABM,3,ABM("J"),0),ABM("PD")=$P(^(0),U,2),ABM("DD")=$P(^(0),U,3)+$P(^(0),U,4),ABM("WO")=$P(^(0),U,6)
 ..S ABM("OB")=ABM("OB")-ABM("DD")-ABM("PD")-ABM("WO")
 ..S ABM("TW")=ABM("TW")+ABM("WO")
 ..S ABM("TP")=ABM("PD")+ABM("TP"),ABM("TD")=ABM("TD")+ABM("DD")
 ..W ?44,$J($FN(ABM("PD"),",",2),9)
 ..W ?54,$J($FN(ABM("DD"),",",0),5)
 ..W ?60,$J($FN(ABM("WO"),",",2),9)
 ..W:'$O(^ABMDBILL(DUZ(2),ABM,3,ABM("J"))) ?70,$J($FN(ABM("OB"),",",2),9)
 I ABM("I")>1 D  I 1
 .S ABM("OB")=ABM("TB")-ABM("TD")-ABM("TP")-ABM("TW")
 .W !,?34,"--------- --------- ----- --------- ---------"
 .W !,?34,$J($FN(ABM("TB"),",",2),9),?44,$J($FN(ABM("TP"),",",2),9)
 .W ?54,$J($FN(ABM("TD"),",",0),5)
 .W ?60,$J($FN(ABM("TW"),",",2),9),?70,$J($FN(ABM("OB"),",",2),9)
 E  W !
 S ABM="",$P(ABM,"-",80)="" W !,ABM
 W ! K DIR S DIR(0)="E" D ^DIR K DIR
 Q
 ;
DISP ; EP for displaying bill payment summary
 K ABM("I") S (ABM("I"),ABM("PDT"))=0 F  S ABM("PDT")=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),3,"B",ABM("PDT"))) Q:'ABM("PDT")  D
 .S ABM=0 F  S ABM=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),3,"B",ABM("PDT"),ABM)) Q:'ABM  D
 ..S ABM("P0")=^ABMDBILL(DUZ(2),ABMP("BDFN"),3,ABM,0),ABM("I")=ABM("I")+1
 ..S ABM(ABM("I"))=ABM("P0"),ABM("I",ABM("I"))=ABM
 ..S ABM("DD")=$P(ABM("P0"),U,3)+$P(ABM("P0"),U,4)
 ..S ABM("WO")=+$P(ABM("P0"),U,6),ABM("PD")=+$P(ABM("P0"),U,2)
 ..S ABM("OB")=ABM("OBL")-ABM("DD")-ABM("WO")-ABM("PD")
 ..;I 'ABM("WO"),$P(ABMP("B0"),U,4)="C",ABM("OB")>0,'$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),3,ABM)) S ABM("WO")=ABM("OB"),ABM("OB")=0,DA(1)=ABMP("BDFN"),DIE="^ABMDBILL(DUZ(2),"_DA(1)_",3,",DA=ABM,DR=".06////"_ABM("WO") D ^DIE
 ..W !,"[",ABM("I"),"]"
 ..I ABM("I")=1 W ?5,$J(($FN(ABM("BL"),",",2)),10)
 ..W ?17,$$HDT^ABMDUTL(+ABM("P0"))
 ..W ?27,$J(($FN(ABM("PD"),",",2)),10)
 ..W ?39,$J(($FN(ABM("DD"),",",2)),10)
 ..W ?51,$J(($FN(ABM("WO"),",",2)),10)
 ..W ?63,$J(($FN(ABM("OB"),",",2)),10)
 ..F ABM("T")="1^PD","2^DD","3^WO" S $P(ABM("TOT"),U,+ABM("T"))=$P(ABM("TOT"),U,+ABM("T"))+ABM($P(ABM("T"),U,2))
 ..S $P(ABM("TOT"),U,4)=ABM("OB")
 ..S ABM("OBL")=ABM("OB")
 Q
