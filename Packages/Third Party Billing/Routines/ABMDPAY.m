ABMDPAY ; IHS/ASDST/DMJ - Payment of Bill ;  
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 S Y=1 I $L($T(TPB^BARUP)) D  Q:'Y
 .W !!,$$EN^ABMVDF("RVN"),"NOTE:",$$EN^ABMVDF("RVF")
 .W " It appears the new A/R package has been installed."
 .W !,"Payments should be posted in the new A/R package.",!
 .S DIR(0)="Y",DIR("A")="Continue",DIR("B")="NO" D ^DIR K DIR
SEL K DIC,ABMP S U="^",ABMP("I")=0
 K DIR S DIR(0)="YO",DIR("B")="Y" W !
 S DIR("A")="Screen-out the Selection of Bills that are Completed"
 S DIR("?")="Answer YES if those Bills that are in a Completed Status (unobligated balance equal to zero) are to be screened out (unselectable)."
 D ^DIR K DIR
 G XIT:$D(DIRUT)!$D(DIROUT)
 K ABMP("BDFN") D ^ABMDBDIC G XIT:'$G(ABMP("BDFN"))
 L +^ABMDBILL(DUZ(2),ABMP("BDFN"),0):1 I '$T W *7,!!,"Record is in USE by another User, try Later!" G XIT
 I $P($G(^AUTNINS(+$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U,8),2)),U)="I" W *7,!!,"Payment can't be Posted for BENEFICIARY PATIENT Bills!" K DIR S DIR(0)="E" D ^DIR G XIT
 S ABMP("SPAY")=0
 I "AR"[$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U,4) D  G SEL:'ABMP("SPAY")
 .I $P($G(^AUTNINS(+$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U,8),2)),U)'="N" W *7,!!,"Payment can only be Posted for Bills that have been Printed!" Q
 .S ABMP("SPAY")=1
 .W *7,!!,"Although this Bill has not yet been Printed, since the Patient is Self Pay,"
 .W !,"payment can still be posted. If payment is posted the Bill will be removed",!,"from the batch print queue.",!
 S ABMP("BILL")=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U),ABMP("B0")=^(0),ABMP("VDT")=$S($P(^(0),U,7)=111:$P($G(^(6)),U),1:$P($G(^(7)),U))
 I $P(ABMP("B0"),U,4)="C",'$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),3,0)) S DIE="^ABMDBILL(DUZ(2),",DA=ABMP("BDFN"),DR=".04////B",$P(ABMP("B0"),U,4)="B" D ^DIE
 S ABMP("INS")=$P(ABMP("B0"),U,8),ABMP("VTYP")=$P(ABMP("B0"),U,7),ABMP("LDFN")=$P(ABMP("B0"),U,3),ABMP("PDFN")=$P(ABMP("B0"),U,5)
 S ABMP("SIS")=0,ABM=0 F  S ABM=$O(^ABMDCLM(DUZ(2),+ABMP("BILL"),65,ABM)) Q:'ABM  D  Q:+ABMP("SIS")
 .I ABM'=ABMP("BDFN"),$D(^ABMDCLM(DUZ(2),+ABMP("BILL"),65,ABMP("BDFN"),0)),$D(^ABMDBILL(DUZ(2),ABM,0)),+^(0)=+ABMP("BILL") S ABMP("SIS")=$P(^(0),U)_U_$P($G(^(2)),U,5) Q
 ;
DISP K ABM W $$EN^ABMVDF("IOF")
 S ABMP="",$P(ABMP,"~",32)="",ABMP("I")=ABMP("I")+1
 W !,ABMP," PAYMENT POSTING ",ABMP
 W !,"Patient: ",$P(^DPT(ABMP("PDFN"),0),U,1)," ",$$HRN^ABMDUTL(ABMP("PDFN"))
 W ?55,$P(^DPT(ABMP("PDFN"),0),U,2),?59,$$HDT^ABMDUTL($P(^(0),U,3)),?70,$P(^(0),U,9)
 S ABMP="",$P(ABMP,".",80)="" W !,ABMP
 W !,"Visit: ",$$HDT^ABMDUTL(ABMP("VDT"))
 W ?17,$E($P(^DIC(4,ABMP("LDFN"),0),U),1,30)
 W ?50,$E($P(^ABMDVTYP(ABMP("VTYP"),0),U),1,14)
 I $P(ABMP("B0"),U,10) W ?66,$J($E($P(^DIC(40.7,$P(ABMP("B0"),U,10),0),U),1,14),13)
BL S ABM("BL")=+^ABMDBILL(DUZ(2),ABMP("BDFN"),2),ABM("ST")=$P(^(0),U,4)
 S ABM("OBL")=ABM("BL")
 S ABM("Y0")=$P(^DD(9002274.4,.04,0),U,3),ABM("Y0")=$P($P(ABM("Y0"),ABM("ST")_":",2),";",1)
 W !," Bill: ",ABMP("BILL"),?17,$E($P(^AUTNINS(ABMP("INS"),0),U),1,30),?50,$E(ABM("Y0"),1,15),?68,$J("$"_$FN(ABM("BL"),",",2),11)
 S ABMP="",$P(ABMP,"-",80)="" W !,ABMP
 W !!?7,"Amount",?17,"Payment",?41,"Deduct",?51,"Write Off-"
 W !?7,"Billed",?19,"Date",?28,"Payment",?41,"Co-Ins",?51,"Adjustment",?64,"Balance"
 W !?5,"==========  ========  ==========  ==========  ==========  =========="
 S ABM("TOT")=0,ABM("I")=0
 D DISP^ABMDPAYV
 I ABM("I")>1 D  I 1
 .W !?5,"----------",?27,"----------  ----------  ----------  ----------"
 .W !?5,$J($FN(ABM("BL"),",",2),10)
 .F ABM=1:1:4 W ?(ABM*12+15),$J($FN($P(ABM("TOT"),U,ABM),",",2),10)
 E  W !
 S ABM("OB")=$S($P(ABM("TOT"),U,4)="":ABM("BL"),1:$P(ABM("TOT"),U,4))
 I ABM("OB")'=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),2),U,5) S DIE="^ABMDBILL(DUZ(2),",DA=ABMP("BDFN"),DR=".25////"_ABM("OB") D ^DIE
 I ABM("I")=0 W ?5,$J(($FN(ABM("BL"),",",2)),10)
 S ABM="",$P(ABM,"-",80)="" W !,ABM
 I ABMP("SIS") W !,"NOTE: A Sister Bill (",$P(ABMP("SIS"),U),") exists with a balance of $",$FN($P(ABMP("SIS"),U,2),",",2),!,ABM
 S ABM("DFLT")=$S(ABMP("I")>1:"",ABM("ST")="C":"E",1:"A")
 S ABM("OPT")=$S(ABM("ST")="C":"EVQ",ABM("I"):"ADEVQ",1:"AVQ")
 D SEL^ABMDPOPT
 G XIT:$D(DIROUT)!$D(DTOUT)!$D(DUOUT)!("ADEV"'[$E(Y)),SEL:$D(DIRUT)
 W ! D @($E(Y)_"^ABMDPAY1")
 G XIT:$D(DTOUT)!$D(DUOUT),SEL:$G(ABMP("PAYM")),DISP
 ;
XIT ;CLEAN UP AND QUIT
 I $G(ABMP("BDFN")) L -^ABMDBILL(DUZ(2),ABMP("BDFN"),0)
 K ABMP,ABM
 Q
