ABMDRSU2 ; IHS/ASDST/DMJ - Summarized Claim Display-PART 2 ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;
 ;
 ; IHS/SD/SDR - v2.6 CSV
 ;
GPRV ;
 K ABMX
 S ABM(0)=""
 F ABM=1:1 S ABM(0)=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),41,"C",ABM(0))) Q:ABM(0)=""  S ABMX(0)=$O(^(ABM(0),"")) D  S ABMX(ABM)=ABM("X")
 .S ABM("X")=""
 .S ABMX(0)=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),41,ABMX(0),0)),U)
 .Q:ABMX(0)=""
 .Q:'$D(^VA(200,ABMX(0)))
 .N X0
 .S X0=$P($G(^VA(200,ABMX(0),"PS")),U,5)
 .I X0="" S ABM("ERR")=ABM("ERR")+1,ABM("ERR",ABM("ERR"))="Provider: "_$P(^VA(200,ABMX(0),0),U)_" does not have a PROVIDER DISCIPLINE entry" Q
 .S ABMX(0)=X0
 .Q:'$D(^DIC(7,ABMX(0),0))  S ABM("X")=$E($P(^(0),U,1),1,16)
 .Q
 ;
 I '$D(ABMX(1)) S ABMX(1)="no providers"
GPOV ;
 S ABM(0)=""
 F ABM=1:1 S ABM(0)=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C",ABM(0))) Q:ABM(0)=""  S ABMX(0)=$O(^(ABM(0),"")) D CHKPOV S $P(ABMX(ABM),U,2)=ABM("X")
 I $P(ABMX(1),U,2)="" S $P(ABMX(1),U,2)="no primary DX"
 G GPRC
 ;
CHKPOV ;
 S ABM("X")=""
 S ABMX(0)=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,ABMX(0),0)),U)
 Q:ABMX(0)=""
 Q:'$D(^ICD9(ABMX(0),0))  S ABM("X")=$E($P($$DX^ABMCVAPI(ABMX(0),""),U,4),1,28)
 Q
 ;
GPRC ;
 S ABM(0)=""
 F ABM=1:1 S ABM(0)=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),19,"C",ABM(0))) Q:ABM(0)=""  S ABMX(0)=$O(^(ABM(0),"")) D CHKPRC S $P(ABMX(ABM),U,3)=ABM("X")
 I $P(ABMX(1),U,3)="" S $P(ABMX(1),U,3)="no procedures"
 G PWRT
 ;
CHKPRC ;
 S ABM("X")=""
 S ABMX(0)=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),19,ABMX(0),0)),U)
 Q:ABMX(0)=""
 Q:'$D(^ICD0(ABMX(0),0))  S ABM("X")=$E($P($$ICDOP^ABMCVAPI(ABMX(0),""),U,5),1,27)  ;CSV-c
 Q
 ;
PWRT ;
 S ABM=0
 F  S ABM=$O(ABMX(ABM)) Q:ABM=""
 I $Y>(IOSL-(8+ABM)) S ABM("CONT")="" D HEAD^ABMDRSU1 Q:$D(ABMP("QUIT"))  D HD^ABMDRSU1
 W !!?4,"ICD Diagnosis",?34,"Procedure Narrative",?63,"Provider Class"
 W !,?4,"----------------------------",?34,"---------------------------",?63,"----------------"
 S ABM=0
 F  S ABM=$O(ABMX(ABM)) Q:ABM=""  D WRT Q:$D(ABMP("QUIT"))
 I $D(ABMP("QUIT")) G XIT
 G GINS
 ;
WRT ;
 W !?4,$P(ABMX(ABM),U,2),?34,$P(ABMX(ABM),U,3),?63,$P(ABMX(ABM),U)
 Q
 ;
GINS ;
 K ABMX
 S ABM(0)=0
 F ABM=1:1 S ABM(0)=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,ABM(0))) Q:'ABM(0)  S ABM("INSCO")=$P(^(ABM(0),0),U) D CHKINS S ABMX(ABM)=ABM("X")
 G IWRT
 ;
CHKINS ;
 S ABM("X")=""
 Q:'$D(^AUTNINS(ABM("INSCO"),0))  S ABM("X")=$E($P(^(0),U),1,30)
 ;
COV ;
 S ABM("G")=0,ABM("C")=""
 F  S ABM("G")=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,ABM(0),11,ABM("G"))) Q:'ABM("G")  S ABM("C")=$S(ABM("C")]"":ABM("C")_";"_$P(^AUTTPIC(ABM("G"),0),U),1:$P(^AUTTPIC(ABM("G"),0),U))
 S $P(ABM("X"),U,2)=ABM("C")
 S $P(ABM("X"),U,4)=$S($P(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,ABM(0),0),U,3)="F":"FLAGGED",$P(^(0),U,3)="U":"BILLED",$P(^(0),U,3)="I":"ACTIVE",$P(^(0),U,3)="C":"COMPLETED",1:"PENDING")
 Q
 ;
IWRT ;
 S ABM=0
 F  S ABM=$O(ABMX(ABM)) Q:ABM=""
 I $Y>(IOSL-(4+ABM)) S ABM("CONT")="" D HEAD^ABMDRSU1 Q:$D(ABMP("QUIT"))  D HD^ABMDRSU1
 W !!,?4,"Insurance Company",?38,"Coverage Types",?68,"Status"
 W !?4 F I=1:1:75 W "-"
 S ABM=0
 F  S ABM=$O(ABMX(ABM)) Q:ABM=""  D IWRT1 Q:$D(ABMP("QUIT"))
 I $D(ABMP("QUIT")) G XIT
 I $Y'>(IOSL-10) W !!!,ABM("80E")
 K ABMX
 Q
 ;
IWRT1 ;
 W !?4,$P(ABMX(ABM),U,1),?40,$P(ABMX(ABM),U,2),?42,$P(ABMX(ABM),U,3),?68,$P(ABMX(ABM),U,4)
 Q
 ;
XIT Q
