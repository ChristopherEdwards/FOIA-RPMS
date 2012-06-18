ABMDTFED ; IHS/ASDST/DMJ - REPORT OF 3P FEE SCHEDULES ; 
 ;;2.6;IHS Third Party Billing System;**3,8**;NOV 12, 2009
 ;
 ; IHS/SD/SDR - v2.5 p9 - IM11865 - Made change so it will print to printer
 ; IHS/SD/SDR - abm*2.6*3 - FIXPMS10008 and FIXPMS10012 - Modified to not use templates and to print by
 ;   effective dates that were introduced in patch 2.
 ;
 S U="^"
FEE W ! K DIC
 S DIC="^ABMDFEE("
 S DIC(0)="QEAM"
 S DIC("A")="Select FEE SCHEDULE: "
 S:$P($G(^ABMDPARM(DUZ(2),1,0)),U,9)]"" DIC("B")=$P(^(0),U,9)
 D ^DIC
 G XIT:$D(DUOUT)!$D(DTOUT)
 I +Y<1 G FEE
 S ABM("FEE")=+Y
SEL W !!,"======== FEE SCHEDULE CATEGORIES ========",!
 K DIR
 S (ABM("S"),DIR(0))="SO^1:MEDICAL;2:SURGICAL;3:RADIOLOGY;4:LABORATORY;5:ANESTHESIA;6:DENTAL;7:REVENUE CODE;8:HCPCS;9:DRUG;10:CHARGE MASTER"
 S DIR("A")="Select Desired CATEGORY"
 D ^DIR
 G XIT:$D(DIROUT)!$D(DIRUT)
 S ABM=+Y
 S ABM("S")=$P($P($P(ABM("S"),U,2),";",+Y),":",2)
 ;start new code abm*2.6*3 FIXPMS10008
 S:ABM("S")="MEDICAL" ABM("CAT")=19
 S:ABM("S")="SURGICAL" ABM("CAT")=11
 S:ABM("S")="RADIOLOGY" ABM("CAT")=15
 S:ABM("S")="LABORATORY" ABM("CAT")=17
 S:ABM("S")="ANESTHESIA" ABM("CAT")=23
 S:ABM("S")="DENTAL" ABM("CAT")=21
 S:ABM("S")="REVENUE CODE" ABM("CAT")=31
 S:ABM("S")="HCPCS" ABM("CAT")=13
 S:ABM("S")="DRUG" ABM("CAT")=25
 S:ABM("S")="CHARGE MASTER" ABM("CAT")=32
 ;start new code abm*2.6*8 HEAT19236
 W !,"Looking for effective dates..."
 S ABMCODE=0
 F  S ABMCODE=$O(^ABMDFEE(ABM("FEE"),ABM("CAT"),ABMCODE)) Q:'ABMCODE  D
 .S ABMEFFDT=0
 .F  S ABMEFFDT=$O(^ABMDFEE(ABM("FEE"),ABM("CAT"),ABMCODE,1,"B",ABMEFFDT)) Q:'ABMEFFDT  D
 ..S ABMELST(ABMEFFDT)=""
 W !!,"Possible effective dates:"
 S ABMEFFDT=0
 F  S ABMEFFDT=$O(ABMELST(ABMEFFDT)) Q:'ABMEFFDT  W !?3,$$SDT^ABMDUTL(ABMEFFDT)
 ;end new code HEAT19236
 D ^XBFMK
 S DIR(0)="DA"
 S DIR("A")="Use what effective date? "
 D ^DIR
 K DIR
 Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)!$D(DIROUT)
 S ABM("EFFDT")=Y
 ;start old code abm*2.6*8 HEAT19236
 ;S ABM("TMP")=$O(^ABMDFEE(ABM("FEE"),1,"B",0))
 ;I (ABM("EFFDT")<($P(ABM("TMP"),".",1))) D  G FEE
 ;.W !!?2,"The effective date you selected is before any effective date in this"
 ;.W !?2,"fee schedule."
 ;end old code HEAT19236
 ;end new code FIXPMS10008
 ;
W1 ;EP
 W !!!
 ;start old code abm*2.6*8 HEAT26652
 ;S %ZIS="NQ"
 ;S %ZIS("B")=""
 ;D ^%ZIS
 ;G:'$D(IO)!$G(POP) XIT
 ;S ABM("ION")=ION
 ;G:$D(IO("Q")) QUE
 ;I IO'=IO(0),$E(IOST)'="C",'$D(IO("S")),$P($G(^ABMDPARM(DUZ(2),1,0)),U,13)="Y" W !!,"As specified in the 3P Site Parameters File FORCED QUEUEING is in effect!",! G QUE
 ;end old code start new code HEAT26652
 S %ZIS="NQ"
 S %ZIS("A")="Enter DEVICE: "
 D ^%ZIS Q:POP
 I IO'=IO(0) D QUE,HOME^%ZIS S DIR(0)="E" D ^DIR K DIR Q
 I $D(IO("S")) S IOP=ION D ^%ZIS
 ;end new code HEAT26652
PRQUE ;EP - Entry Point for Taskman
S2 ;start old code abm*2.6*3 FIXPMS10008
 ;S L=0
 ;S DIC="^ABMDFEE("
 ;S FLDS="[ABMD TM "_ABM("S")_" FEES]"
 ;S BY=$S(ABM("S")="DENTAL":"[ABMD TM DENTAL FEE SCHEDULE]",1:"[ABMD TM FEE SCHEDULE]")
 ;S FR=$S(ABM("S")="DENTAL":ABM("FEE"),1:ABM("FEE"))
 ;S TO=$S(ABM("S")="DENTAL":ABM("FEE")_",?",1:ABM("FEE"))
 ;S IOP=ABM("ION")_";"_IOST_";"_80_";"_IOSL
 ;S PG=1
 ;D EN1^DIP
 ;end old code start new code FIXPMS10008
 S ABM("PG")=0
 S ABM("HD",0)=ABM("S")_" SERVICES FEE SCHEDULE"
 S ABM("HD",1)="FEE SCHEDULE NUMBER "_ABM("FEE")_" WITH EFFECTIVE DATE "_$$SDT^ABMDUTL(ABM("EFFDT"))
 K ^TMP("ABM-FS",$J)
 D RANGE^ABMFEAPI(ABM("FEE"),ABM("CAT"),ABM("EFFDT"))
 D HDB
 S ABMCD=""
 F  S ABMCD=$O(^TMP("ABM-FS",$J,ABMCD)) Q:($G(ABMCD)="")  D  Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 .S ABMCODE="",ABMDESC=""
 .I $Y>(IOSL-5) D HD Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)  W " (cont)"
 .I ABM("CAT")=25 S ABMCODE=$P($G(^PSDRUG($P($G(^TMP("ABM-FS",$J,ABMCD)),U),0)),U)  ;drug
 .I ABM("CAT")=32 S ABMCODE=$P($G(^ABMCM(ABMCD,0)),U)  ;charge master
 .I (ABM("CAT")'=25&(ABM("CAT")'=32)) S ABMCODE=ABMCD
 .I "^19^11^15^17^23^13^"[("^"_ABM("CAT")_"^") S ABMDESC=$P($$CPT^ABMCVAPI($P(^TMP("ABM-FS",$J,ABMCD),U),ABM("EFFDT")),U,3)
 .I ABM("CAT")=21 S ABMDESC=$P($G(^AUTTADA($P($G(^TMP("ABM-FS",$J,ABMCODE)),U),0)),U,2)
 .I ABM("CAT")=31 S ABMDESC=$P($G(^AUTTREVN(ABMCD,0)),U,2)
 .W !,ABMCODE
 .W ?10,$E(ABMDESC,1,32)
 .I "^19^11^15^17^23^13^21^31^"[("^"_ABM("CAT")_"^") D
 ..W ?44,+$P($G(^TMP("ABM-FS",$J,ABMCD)),U,2)
 ..W ?56,+$P($G(^TMP("ABM-FS",$J,ABMCD)),U,3)
 ..W ?68,+$P($G(^TMP("ABM-FS",$J,ABMCD)),U,4)
 .I "^19^11^15^17^23^13^21^31^"'[("^"_ABM("CAT")_"^") D
 ..W ?44,+$P($G(^TMP("ABM-FS",$J,ABMCD)),U,2)
 ;end new code FIXPMS10008
XIT D ^%ZISC
 K ABM
 Q
 ;
QUE ;EP
 ;start old code abm*2.6*8
 ;K IO("Q")
 ;S ZTRTN="PRQUE^ABMDTFED"
 ;S ZTDESC="REPORT OF 3P FEE SCHEDULES"
 ;F ABM="ABM(" S ZTSAVE(ABM)=""
 ;D ^%ZTLOAD
 ;W:$D(ZTSK) !,"REQUEST QUEUED!",! G XIT
 ;end old code start new code
 S ZTRTN="PRQUE^ABMDTFED"
 S ZTDESC="REPORT OF 3P FEE SCHEDULES"
 S ZTSAVE("ABM*")=""
 K ZTSK
 D ^%ZTLOAD
 W:$G(ZTSK) !,"Task # ",ZTSK," queued.",!
 Q
 ;end new code
 ;
 ;start new code abm*2.6*3 FIXPMS10008
HD D PAZ^ABMDRUTL Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
HDB S ABM("PG")=ABM("PG")+1
 D WHD^ABMDRHD
 I "^19^11^15^17^23^13^21^31^"[("^"_ABM("CAT")_"^") W !?44,"GLOBAL",?56,"TECH",?68,"PROF"
 I "^19^11^15^17^23^13^"[("^"_ABM("CAT")_"^") W !,"CPT CODE",?10,"SHORT NAME",?44,"CHARGE",?56,"CHARGE",?68,"CHARGE"
 I ABM("CAT")=21 W !,"ADA CODE",?15,"SHORT NAME",?44,"CHARGE",?56,"CHARGE",?68,"CHARGE"
 I ABM("CAT")=25 W !,"DRUG",?44,"PRICE PER DISPENSING UNIT"
 I ABM("CAT")=31 W !,"REV CODE",?10,"STANDARD ABBREV.",?44,"CHARGE",?56,"CHARGE",?68,"CHARGE"
 I ABM("CAT")=32 W !,"CHARGE MASTER",?44,"CHARGE",?56,"CHARGE",?68,"CHARGE"
 S $P(ABM("LINE"),"-",80)="" W !,ABM("LINE") K ABM("LINE")
 Q
 ;end new code FIXPMS10008
