ABMESTAT ; IHS/SD/SDR - Bills Export Statistical Report;
 ;;2.6;IHS Third Party Billing System;**3**;NOV 12, 2009
 ; IHS/SD/SDR - abm*2.6*3 - MU - new routine
 ;
 K ABM,ABMY
 S ABM("NODX")=""
 ;
 D ^XBFMK
 S DIR(0)="S^1:Summarized Report by ALLOWANCE CATEGORY;2:Summarized Report by INSURER;3:Summarized Report by INSURER TYPE"
 S DIR("A")="Select the desired REPORT TYPE: "
 S DIR("B")="1"
 D ^DIR K DIR
 S ABM("SRT")=$S(Y=2:"I",Y=3:"T",1:"A")
 S ABM("DT")="A"
 S ABM("DT",1)=3090101
 S ABM("DT",2)=DT
 ;
SEL ;
 D ^ABMDRSEL Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 S ABM("HD",0)="BILLS Export Statistical Report"
 D ^ABMDRHD
 S ABMQ("RC")="COMPUTE^ABMESTAT"
 S ABMQ("RX")="POUT^ABMDRUTL"
 S ABMQ("NS")="ABM"
 S ABMQ("RP")="PRINT^ABMESTAT"
 D ^ABMDRDBQ
 Q
 ;
COMPUTE ;EP - Entry Point for Setting up Data
 S ABM("SUBR")="ABM-ES" K ^TMP("ABM-ES",$J) S ABM("PG")=0
SLOOP I $D(ABMY("DT")) D  Q
 .S ABM("RD")=ABMY("DT",1)-1
 .S ABMY("DT",2)=ABMY("DT",2)_".999999"
 .I ABMY("DT")="A" D  Q
 ..F  S ABM("RD")=$O(^ABMDBILL(DUZ(2),"AP",ABM("RD"))) Q:'+ABM("RD")!(ABM("RD")>ABMY("DT",2))  D
 ...S ABM="" F  S ABM=$O(^ABMDBILL(DUZ(2),"AP",ABM("RD"),ABM)) Q:'ABM  D DATA
 .I ABMY("DT")="V" D  Q
 ..S ABMVDFN=0
 ..F  S ABMVDFN=$O(^ABMDBILL(DUZ(2),"AV",ABMVDFN)) Q:'ABMVDFN  D
 ...S ABMVDT=$P($P($G(^AUPNVSIT(ABMVDFN,0)),U),".")
 ...I (ABMVDT<ABMY("DT",1)!(ABMVDT>ABMY("DT",2))) Q
 ...S ABM="" F  S ABM=$O(^ABMDBILL(DUZ(2),"AV",ABMVDFN,ABM)) Q:'ABM  D DATA
 .S ABMXMT=0
 .F  S ABMXMT=$O(^ABMDBILL(DUZ(2),"AX",ABMXMT)) Q:'ABMXMT  D
 ..S ABMXDT=$P($P($G(^ABMDTXST(DUZ(2),ABMXMT,0)),U),".")
 ..I (ABMXDT<ABMY("DT",1)!(ABMXDT>ABMY("DT",2))) Q
 ..S ABM=0 F  S ABM=$O(^ABMDBILL(DUZ(2),"AX",ABMXMT,ABM)) Q:'ABM  D DATA
 ;
 S ABM=0
 F  S ABM=$O(^ABMDBILL(DUZ(2),ABM)) Q:'ABM  D DATA
 Q
 ;
DATA ;
 S ABMP("HIT")=0 D BILL^ABMDRCHK Q:'ABMP("HIT")
 I ABM("SRT")="I" S ABM("SORT")=$P($G(^AUTNINS(ABM("I"),0)),U)
 I ABM("SRT")="T" D
 .S ABM("SORT")=$$GET1^DIQ(9999999.18,ABM("I"),".21","E")
 I ABM("SRT")="A" S ABM("SORT")=$P($T(@($P(^AUTNINS(ABM("I"),2),U))),";;",2)
 S ABM("L")=$P(^DIC(4,ABM("L"),0),U)
 S ABM("EXP")=$P($G(^ABMDBILL(DUZ(2),ABM,0)),U,6)
 S:$G(ABM("EXP"))="" ABM("EXP")="MANUAL BILL W/O EXPORT MODE"  ;no export mode--manual bill
 S:($G(^TMP("ABM-ES",$J,ABM("L"),ABM("EXP"),ABM("SORT")))="") ^TMP("ABM-ES",$J,ABM("L"),ABM("EXP"),ABM("SORT"))=ABM("L")_U_ABM("EXP")_U_ABM("SORT")
 S $P(^TMP("ABM-ES",$J,ABM("L"),ABM("EXP"),ABM("SORT")),U,4)=+$P($G(^TMP("ABM-ES",$J,ABM("L"),ABM("EXP"),ABM("SORT"))),U,4)+1  ;number bills
 S $P(^TMP("ABM-ES",$J,ABM("L"),ABM("EXP"),ABM("SORT")),U,5)=+$P($G(^TMP("ABM-ES",$J,ABM("L"),ABM("EXP"),ABM("SORT"))),U,5)+$P($G(^ABMDBILL(DUZ(2),ABM,2)),U)  ;total
 Q
PRINT ;
 S ABM("TXT")=""
 S ABM("PG")=0
 D HDB
 S (ABM("SUBCNT"),ABM("SUBAMT"))=0,(ABM("EXP"),ABM("V"))=""
 S (ABM("TCNT"),ABM("TAMT"))=0
 S ABM("A")="TMP(""ABM-ES"","_$J
 S ABM="^"_ABM("A")_")" I '$D(@ABM) Q
 ;
 F  S ABM=$Q(@ABM) Q:ABM'[ABM("A")  D  Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 .S ABM("TCNT")=ABM("TCNT")+$P($G(@ABM),U,4)
 ;
 S ABM="^"_ABM("A")_")" I '$D(@ABM) Q
 F  S ABM=$Q(@ABM) Q:ABM'[ABM("A")  D  Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 .I $Y>(IOSL-5) D HD Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)  D EXP W " (cont)"
 .S ABM("TXT")=$G(@ABM)
 .I ABM("EXP")'=$P(ABM("TXT"),U,2) S ABM("V")="" D SUB,EXP
 .S ABM("EXP")=$P(ABM("TXT"),U,2)
 .W !?10,$P(ABM("TXT"),U,3)
 .W ?40,$J($P(ABM("TXT"),U,4),"6R")
 .W ?64,$J($FN($P(ABM("TXT"),U,5),",",2),"12R")
 .S ABM("SUBCNT")=ABM("SUBCNT")+$P(ABM("TXT"),U,4)
 .S ABM("TAMT")=ABM("TAMT")+$P(ABM("TXT"),U,5),ABM("SUBAMT")=ABM("SUBAMT")+$P(ABM("TXT"),U,5)
 Q:$D(DIROUT)!($D(DUOUT))!($D(DTOUT))
 D SUB
 W !!?40,"======",?64,"============"
 W !?20,"Total:",?40,$J(ABM("TCNT"),"6R"),?64,$J($FN(ABM("TAMT"),",",2),"12R")
 Q
 ;
HD D PAZ^ABMDRUTL Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
HDB S ABM("PG")=ABM("PG")+1 D WHD^ABMDRHD
 W !?40,"Number"
 W !?10,$S(ABM("SRT")="I":"Insurer",ABM("SRT")="A":"Allowance Category",1:"Insurer Type")
 W ?40,"Bills",?53,"Percent",?68,"Total"
 S $P(ABM("LINE"),"-",80)="" W !,ABM("LINE") K ABM("LINE")
 Q
 ;
EXP W !!?3,"Export Mode: "_$S(+$P(ABM("TXT"),U,2):$P($G(^ABMDEXP($P(ABM("TXT"),U,2),0)),U),1:$P(ABM("TXT"),U,2))
 Q
 ;
SUB Q:'ABM("SUBCNT")
 W !?40,"------",?64,"------------"
 W !?20,"Subtotal:",?40,$J(ABM("SUBCNT"),"6R"),?55,$J((ABM("SUBCNT")/ABM("TCNT")*100),".",1),?64,$J($FN(ABM("SUBAMT"),",",2),"12R")
 S ABM("SUBCNT")=0,ABM("SUBAMT")=0
 Q
TXT ;
H ;;PRIVATE
M ;;PRIVATE
D ;;MEDICAID
R ;;MEDICARE
P ;;PRIVATE
W ;;OTHER
C ;;OTHER
F ;;PRIVATE
N ;;OTHER
I ;;OTHER
K ;;MEDICAID
T ;;OTHER
G ;;OTHER
MD ;;MEDICARE
MH ;;MEDICARE
