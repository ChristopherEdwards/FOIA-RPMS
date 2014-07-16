ABMMUELG ;IHS/SD/SDR - Meaningful Use Report - count patients/eligibility ;
 ;;2.6;IHS 3P BILLING SYSTEM;**5,11,12**;NOV 12, 2009;Build 187
 ;IHS/SD/SDR - 2.6*12 - HEAT120278 - Made change to correct Railroad member#
 ;IHS/SD/SDR - 2.6*12 - VMBP RQMT_103 - Added VA elig to summary and detail
 ;
 W !!,"The date range selected will be used for: "
 W !,?3,"1. Was the patient's record active during that range"
 W !,?3,"2. Did the patient have eligibility in that range"
 W !,?3,"3. How many encounters they had during that time"
 W !!,"Detail information will be supplied for validation purposes but once validated"
 W !,"the summary option should be used."
 K ABMY,ABMP
 K ^TMP($J,"ABM-MURPT")
DT ;
 W !!," ============ Entry of Date Range =============",!
 D ^XBFMK
 S DIR("A")="Enter STARTING Date"
 S DIR(0)="DO^::EP"
 D ^DIR
 Q:$D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)
 S ABMY("DT",1)=Y
 W !
 S DIR("A")="Enter ENDING Date"
 D ^DIR
 K DIR
 G DT:$D(DIRUT)
 S ABMY("DT",2)=Y
 I ABMY("DT",1)>ABMY("DT",2) W !!,*7,"INPUT ERROR: Start Date is Greater than than the End Date, TRY AGAIN!",!! G DT
RTYPE ;
 W !
 K DIC,DIE,DIR,X,Y,DA
 S DIR(0)="S^S:SUMMARY;D:DETAIL (will include Summary)"
 S DIR("A")="SUMMARY OR DETAIL"
 S DIR("B")="SUMMARY"
 D ^DIR K DIR
 S ABMSUMDT=Y
SEL ;
 ; Select device
 I ABMSUMDT="D" D
 .W !!,"There will be two outputs, one for SUMMARY and one for DETAIL."
 .W !,"The first one should be a terminal or a printer."
 .W !,"The second forces an HFS file because it could be a large file",!
 S %ZIS="NQ"
 S %ZIS("A")="Enter DEVICE: "
 D ^%ZIS Q:POP
 U IO(0) W !!,"Searching...."
 I IO=IO(0) D TOTALS S DIR(0)="E" D ^DIR K DIR
 I IO'=IO(0) D QUE^ABMMUELG,HOME^%ZIS S DIR(0)="E" D ^DIR K DIR Q
 I $D(IO("S")) S IOP=ION D ^%ZIS
 D ^%ZISC
 D HOME^%ZIS
 ;
 I ABMSUMDT="D" D
 .W !!,"Will now write detail to file",!!
 .D ^XBFMK
 .S DIR(0)="F"
 .S DIR("A")="Enter Path"
 .S DIR("B")=$P($G(^ABMDPARM(DUZ(2),1,4)),"^",7)
 .D ^DIR K DIR
 .Q:$D(DIRUT)!$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 .S ABMPATH=Y
 .S DIR(0)="F",DIR("A")="Enter File Name"
 .D ^DIR K DIR
 .Q:$D(DIRUT)!$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 .S ABMFN=Y
 .W !!,"Creating file..."
 .D OPEN^%ZISH("ABM",ABMPATH,ABMFN,"W")
 .Q:POP
 .U IO
 .D WRTPTS
 .D WRTELIG
 .D WRTVSTS
 .D CLOSE^%ZISH("ABM")
 .W "DONE"
XIT ;
 K ^TMP($J,"ABM-MURPT")
 K ABMP,ABMY,ABMPTINA,ABMPT,ABMMFLG
 Q
QUE ;QUE TO TASKMAN
 S ZTRTN="TOTALS^ABMMUELG"
 S ZTDESC="3P MEANINGFUL USE ELIGIBILITY REPORT"
 S ZTSAVE("ABM*")=""
 K ZTSK
 D ^%ZTLOAD
 W:$G(ZTSK) !,"Task # ",ZTSK," queued.",!
 Q
GETPTS ;
 S ABMP("PDFN")=0
 F  S ABMP("PDFN")=$O(^AUPNPAT(ABMP("PDFN"))) Q:'ABMP("PDFN")  D
 .I $D(^AUPNPAT(ABMP("PDFN"),41,DUZ(2))) D
 ..S ABMPTINA=$P($G(^AUPNPAT(ABMP("PDFN"),41,DUZ(2),0)),U,3)  ;dt inactive/deleted
 ..I ABMPTINA'=""&((ABMPTINA<ABMY("DT",1))!(ABMPTINA>ABMY("DT",2))) Q  ;pt inactive prior to or after range of rpt
 ..S ^TMP($J,"ABM-MURPT","PTS",ABMP("PDFN"))=""
 ..S ^TMP($J,"ABM-MURPT","CNT","PTS")=+$G(^TMP($J,"ABM-MURPT","CNT","PTS"))+1  ;cnt pts
 Q
 ;
GETELIG ;
 ;medicaid
 S ABMP("PDFN")=0
 F  S ABMP("PDFN")=$O(^TMP($J,"ABM-MURPT","PTS",ABMP("PDFN"))) Q:'ABMP("PDFN")  D
 .I $D(^AUPNMCD("B",ABMP("PDFN"))) D  ;pt has mcd entry
 ..S ABMP("MDFN")=0
 ..F  S ABMP("MDFN")=$O(^AUPNMCD("B",ABMP("PDFN"),ABMP("MDFN"))) Q:'ABMP("MDFN")  D
 ...S ABMP("EFFDT")=0,ABMMFLG=0
 ...F  S ABMP("EFFDT")=$O(^AUPNMCD(ABMP("MDFN"),11,ABMP("EFFDT"))) Q:'ABMP("EFFDT")  D  Q:(ABMMFLG=1)
 ....S ABMP("ENDDT")=$P($G(^AUPNMCD(ABMP("MDFN"),11,ABMP("EFFDT"),0)),U,2)  ;end date
 ....;effective date after end of range or end date before start of range
 ....I (ABMP("EFFDT")>ABMY("DT",2))!((ABMP("ENDDT")'="")&(ABMP("ENDDT")<ABMY("DT",1))) Q
 ....S ABMMFLG=1  ;if it gets here pt has elig in our window
 ...I ABMMFLG=1 D  ;pt has at least one entry that's what we want
 ....S ^TMP($J,"ABM-MURPT","MCD",ABMP("PDFN"),ABMP("MDFN"))=""
 ....S ^TMP($J,"ABM-MURPT","CNT","MCD")=+$G(^TMP($J,"ABM-MURPT","CNT","MCD"))+1  ;cnt mcd pts
 ;
 ;medicare
 S ABMP("PDFN")=0
 F  S ABMP("PDFN")=$O(^TMP($J,"ABM-MURPT","PTS",ABMP("PDFN"))) Q:'ABMP("PDFN")  D
 .I $D(^AUPNMCR(ABMP("PDFN"))) D  ;pt had mcr entry
 ..S ABMP("MDFN")=0,ABMMFLG=0
 ..F  S ABMP("MDFN")=$O(^AUPNMCR(ABMP("PDFN"),11,ABMP("MDFN"))) Q:'ABMP("MDFN")  D  Q:(ABMMFLG=1)
 ...S ABMP("EFFDT")=$P($G(^AUPNMCR(ABMP("PDFN"),11,ABMP("MDFN"),0)),U)  ;effective dt
 ...S ABMP("ENDDT")=$P($G(^AUPNMCR(ABMP("PDFN"),11,ABMP("MDFN"),0)),U,2)  ;end dt
 ...;effective date after end of range or end date before start of range
 ...I (ABMP("EFFDT")>ABMY("DT",2))!((ABMP("ENDDT")'="")&(ABMP("ENDDT")<ABMY("DT",1))) Q
 ...S ABMMFLG=1  ;if it gets here pt has elig in our window
 ..I ABMMFLG=1 D  ;pt has at least one entry that's what we want
 ...S ^TMP($J,"ABM-MURPT","MCR",ABMP("PDFN"),ABMP("MDFN"))=""
 ...S ^TMP($J,"ABM-MURPT","CNT","MCR")=+$G(^TMP($J,"ABM-MURPT","CNT","MCR"))+1  ;cnt mcr pts
 ;
 ;railroad
 S ABMP("PDFN")=0
 F  S ABMP("PDFN")=$O(^TMP($J,"ABM-MURPT","PTS",ABMP("PDFN"))) Q:'ABMP("PDFN")  D
 .I $D(^AUPNRRE(ABMP("PDFN"))) D  ;patient had medicare entry
 ..S ABMP("MDFN")=0,ABMMFLG=0
 ..F  S ABMP("MDFN")=$O(^AUPNRRE(ABMP("PDFN"),11,ABMP("MDFN"))) Q:'ABMP("MDFN")  D  Q:(ABMMFLG=1)
 ...S ABMP("EFFDT")=$P($G(^AUPNRRE(ABMP("PDFN"),11,ABMP("MDFN"),0)),U)  ;effective dt
 ...S ABMP("ENDDT")=$P($G(^AUPNRRE(ABMP("PDFN"),11,ABMP("MDFN"),0)),U,2)  ;end dt
 ...;effective dt after end of range or end dt before start of range
 ...I (ABMP("EFFDT")>ABMY("DT",2))!((ABMP("ENDDT")'="")&(ABMP("ENDDT")<ABMY("DT",1))) Q
 ...S ABMMFLG=1  ;if it gets here pt has elig in our window
 ..I ABMMFLG=1 D  ;pt has at least one entry that's what we want
 ...S ^TMP($J,"ABM-MURPT","RR",ABMP("PDFN"),ABMP("MDFN"))=""
 ...S ^TMP($J,"ABM-MURPT","CNT","RR")=+$G(^TMP($J,"ABM-MURPT","CNT","RR"))+1  ;cnt rr pts
 ;
 ;private
 S ABMP("PDFN")=0
 F  S ABMP("PDFN")=$O(^TMP($J,"ABM-MURPT","PTS",ABMP("PDFN"))) Q:'ABMP("PDFN")  D
 .I $D(^AUPNPRVT(ABMP("PDFN"))) D  ;patient has private entry
 ..S ABMP("MDFN")=0,ABMMFLG=0
 ..F  S ABMP("MDFN")=$O(^AUPNPRVT(ABMP("PDFN"),11,ABMP("MDFN"))) Q:'ABMP("MDFN")  D  Q:(ABMMFLG=1)
 ...S ABMP("EFFDT")=$P($G(^AUPNPRVT(ABMP("PDFN"),11,ABMP("MDFN"),0)),U,6)  ;effective dt
 ...S ABMP("ENDDT")=$P($G(^AUPNPRVT(ABMP("PDFN"),11,ABMP("MDFN"),0)),U,7)  ;end dt
 ...;effective dt after end of range or end dt before start of range
 ...I (ABMP("EFFDT")>ABMY("DT",2))!((ABMP("ENDDT")'="")&(ABMP("ENDDT")<ABMY("DT",1))) Q
 ...S ABMMFLG=1  ;if it gets here pt has elig in our window
 ..I ABMMFLG=1 D  ;pt has at least one entry that's what we want
 ...S ^TMP($J,"ABM-MURPT","PI",ABMP("PDFN"),ABMP("MDFN"))=""
 ...S ^TMP($J,"ABM-MURPT","CNT","PI")=+$G(^TMP($J,"ABM-MURPT","CNT","PI"))+1  ;cnt private pts
 ;
 ;start new abm*2.6*12 VMBP RQMT_103
 ;medicare
 S ABMP("PDFN")=0
 F  S ABMP("PDFN")=$O(^TMP($J,"ABM-MURPT","PTS",ABMP("PDFN"))) Q:'ABMP("PDFN")  D
 .I $D(^AUPNVAMB(ABMP("PDFN"))) D  ;pt had VAMB eligible entry
 ..S ABMP("MDFN")=0,ABMMFLG=0
 ..F  S ABMP("MDFN")=$O(^AUPNVAMB(ABMP("PDFN"),11,ABMP("MDFN"))) Q:'ABMP("MDFN")  D  Q:(ABMMFLG=1)
 ...S ABMP("EFFDT")=$P($G(^AUPNVAMB(ABMP("PDFN"),11,ABMP("MDFN"),0)),U)  ;effective dt
 ...S ABMP("ENDDT")=$P($G(^AUPNVAMB(ABMP("PDFN"),11,ABMP("MDFN"),0)),U,2)  ;end dt
 ...;effective date after end of range or end date before start of range
 ...I (ABMP("EFFDT")>ABMY("DT",2))!((ABMP("ENDDT")'="")&(ABMP("ENDDT")<ABMY("DT",1))) Q
 ...S ABMMFLG=1  ;if it gets here pt has elig in our window
 ..I ABMMFLG=1 D  ;pt has at least one entry that's what we want
 ...S ^TMP($J,"ABM-MURPT","VAMB",ABMP("PDFN"),ABMP("MDFN"))=""
 ...S ^TMP($J,"ABM-MURPT","CNT","VAMB")=+$G(^TMP($J,"ABM-MURPT","CNT","VAMB"))+1  ;cnt VAMB pts
 ;end new VMBP RQMT_103
 ;
 ;no insurance
 S ABMP("PDFN")=0
 F  S ABMP("PDFN")=$O(^TMP($J,"ABM-MURPT","PTS",ABMP("PDFN"))) Q:'ABMP("PDFN")  D
 .I '$D(^TMP($J,"ABM-MURPT","PI",ABMP("PDFN")))&'$D(^TMP($J,"ABM-MURPT","MCD",ABMP("PDFN")))&'$D(^TMP($J,"ABM-MURPT","MCR",ABMP("PDFN")))&'$D(^TMP($J,"ABM-MURPT","RR",ABMP("PDFN"))) D
 ..S ^TMP($J,"ABM-MURPT","CNT","NO")=+$G(^TMP($J,"ABM-MURPT","CNT","NO"))+1  ;cnt no insurance pts
 ..S ^TMP($J,"ABM-MURPT","NO",ABMP("PDFN"))=""
 ;
 Q
 ;
GETVSTS ;
 S ABMP("SDT")=ABMY("DT",1)-.5
 S ABMP("EDT")=ABMY("DT",2)+.999999
 F  S ABMP("SDT")=$O(^AUPNVSIT("B",ABMP("SDT"))) Q:('ABMP("SDT")!(ABMP("SDT")>ABMP("EDT")))  D
 .S ABMP("VDFN")=0
 .F  S ABMP("VDFN")=$O(^AUPNVSIT("B",ABMP("SDT"),ABMP("VDFN"))) Q:'ABMP("VDFN")  D
 ..S ABMPT=$P($G(^AUPNVSIT(ABMP("VDFN"),0)),U,5)  ;pt
 ..Q:ABMPT=""  ;no patient on visit
 ..I '$D(^TMP($J,"ABM-MURPT","PTS",ABMPT)) Q  ;not one of our pts
 ..S ^TMP($J,"ABM-MURPT","ENC",ABMP("VDFN"))=""
 ..S ^TMP($J,"ABM-MURPT","CNT","ENC")=+$G(^TMP($J,"ABM-MURPT","CNT","ENC"))+1  ;cnt encounters
 ..I '$D(^TMP($J,"ABM-MURPT","UNQ",ABMPT)) D
 ...S ^TMP($J,"ABM-MURPT","UNQ",ABMPT)=""
 ...S ^TMP($J,"ABM-MURPT","CNT","UNQ")=+$G(^TMP($J,"ABM-MURPT","CNT","UNQ"))+1  ;cnt unique pts
 Q
 ;
TOTALS ;
 ;Practice Demographics
 ;# of Patient
 ;Encounters/Year
 ;# of Unique Patients/Year
 S ABM("HD",0)="Meaningful Use Eligibility Report"
 S ABM("PG")=1
 D GETPTS
 D GETELIG
 D GETVSTS
 D WHD
 W !!,"Practice Demographics"
 W !?2,$J(+$G(^TMP($J,"ABM-MURPT","CNT","PTS")),7)_" Patients"
 W !?2,$J(+$G(^TMP($J,"ABM-MURPT","CNT","ENC")),7)_" Encounters"
 W !?2,$J(+$G(^TMP($J,"ABM-MURPT","CNT","UNQ")),7)_" Unique Patients"
 ;
 ;Patient Demographics
 I +$G(^TMP($J,"ABM-MURPT","CNT","PTS"))=0 W !!,"(REPORT COMPLETE)" Q  ;no patients found so it cause a DIVIDE error if we continue
 W !!,"Patient Demographics"
 ;medicaid
 W !?2,$J(+$G(^TMP($J,"ABM-MURPT","CNT","MCD")),7)_" Patients with Medicaid ( "_$J($FN((+$G(^TMP($J,"ABM-MURPT","CNT","MCD"))/(+$G(^TMP($J,"ABM-MURPT","CNT","PTS")))*100),",",2),5)_"% )"
 ;medicare
 W !?2,$J(+$G(^TMP($J,"ABM-MURPT","CNT","MCR")),7)_" Patients with Medicare ( "_$J($FN((+$G(^TMP($J,"ABM-MURPT","CNT","MCR"))/(+$G(^TMP($J,"ABM-MURPT","CNT","PTS")))*100),",",2),5)_"% )"
 ;railroad
 W !?2,$J(+$G(^TMP($J,"ABM-MURPT","CNT","RR")),7)_" Patients with Railroad ( "_$J($FN((+$G(^TMP($J,"ABM-MURPT","CNT","RR"))/(+$G(^TMP($J,"ABM-MURPT","CNT","PTS")))*100),",",2),5)_"% )"
 ;private
 W !?2,$J(+$G(^TMP($J,"ABM-MURPT","CNT","PI")),7)_" Patients with Private  ( "_$J($FN((+$G(^TMP($J,"ABM-MURPT","CNT","PI"))/(+$G(^TMP($J,"ABM-MURPT","CNT","PTS")))*100),",",2),5)_"% )"
 ;no eligibility
 W !?2,$J(+$G(^TMP($J,"ABM-MURPT","CNT","NO")),7)_" Patients Uninsured     ( "_$J($FN((+$G(^TMP($J,"ABM-MURPT","CNT","NO"))/(+$G(^TMP($J,"ABM-MURPT","CNT","PTS")))*100),",",2),5)_"% )"
 ;start new abm*2.6*11 VMBP#9 RQMT_103
 ;vmbp
 W !?2,$J(+$G(^TMP($J,"ABM-MURPT","CNT","VAMB")),7)_" Patients with VA Med B ( "_$J($FN((+$G(^TMP($J,"ABM-MURPT","CNT","VAMB"))/(+$G(^TMP($J,"ABM-MURPT","CNT","PTS")))*100),",",2),5)_"% )"
 ;end new VMBP#9 RQMT_103
 W !!,"(REPORT COMPLETE)"
 Q
 ;
WRTPTS ;^TMP($J,"ABM-MURPT","PTS",ABMP("PDFN"))
 D WRTPTS^ABMMUEL1
 Q
 ;
WRTELIG ;
 D WRTELIG^ABMMUEL1
 Q
 ;
WRTVSTS ;^TMP($J,"ABM-MURPT","ENC",ABMP("VDFN"))
 D WRTVSTS^ABMMUEL1
 Q
WHD ;EP for writing Report Header
 W $$EN^ABMVDF("IOF"),!
 K ABM("LINE") S $P(ABM("LINE"),"=",$S($D(ABM(132)):132,1:80))="" W ABM("LINE"),!
 D NOW^%DTC  ;abm*2.6*1 NO HEAT
 W ABM("HD",0),?$S($D(ABM(132)):103,1:48) S Y=% X ^DD("DD") W Y,"   Page ",ABM("PG")
 S ABM("HD",1)="For date range: "_$$SDT^ABMDUTL(ABMY("DT",1))_" to "_$$SDT^ABMDUTL(ABMY("DT",2))
 W:$G(ABM("HD",1))]"" !,ABM("HD",1)
 W:$G(ABM("HD",2))]"" !,ABM("HD",2)
 W !,"Billing Location: ",$P($G(^AUTTLOC(DUZ(2),0)),U,2)
 W !,ABM("LINE") K ABM("LINE")
 Q
