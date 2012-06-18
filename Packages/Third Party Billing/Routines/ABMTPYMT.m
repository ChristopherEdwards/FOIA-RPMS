ABMTPYMT ; IHS/SD/SDR - Tribal Payment Report ;
 ;;2.6;IHS 3P BILLING SYSTEM;**8**;NOV 12, 2009
 ;
 K ABM,ABMY
 ;
SEL ;
 ;location
 D GETFACS^ABMMUMUP  ;get list of facilities
 S ABMCNT=0,ABMDIR="",ABMFQHC=0
 F  S ABMCNT=$O(ABMFLIST(ABMCNT)) Q:'ABMCNT  D
 .S:ABMDIR'="" ABMDIR=ABMDIR_";"_ABMCNT_":"_$$GET1^DIQ(9999999.06,$G(ABMFLIST(ABMCNT)),.01,"E")
 .S:ABMDIR="" ABMDIR=ABMCNT_":"_$$GET1^DIQ(9999999.06,$G(ABMFLIST(ABMCNT)),.01,"E")
 .I $D(^ABMMUPRM(1,1,"B",ABMFLIST(ABMCNT))) S ABMFQHC=1
 S ABMCNT=$O(ABMFLIST(99999),-1)  ;get last entry#
 S (ABMCNT,ABMTOT)=ABMCNT+1
 I ABMFQHC=0!(ABMCNT<2) S ABMDIR=ABMDIR_";"_ABMCNT_":All facilities"
 W !!
 K ABMFANS,ABMF
 F  D  Q:+$G(Y)<0!(Y=ABMTOT)!$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)  ;they didn't answer or ALL was selected
 .D ^XBFMK
 .S DIR(0)="SO^"_$G(ABMDIR)
 .S:'$D(ABMF) DIR(0)="S^"_$G(ABMDIR)
 .S DIR("A")="Select one or more facilities"
 .D ^DIR K DIR
 .Q:$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)
 .S ABMFANS=Y
 .I ABMFANS'=(ABMTOT) S ABMF($G(ABMFLIST(ABMFANS)))=""
 .I ABMFANS=(ABMTOT) D
 ..S ABMCNT=0
 ..F  S ABMCNT=$O(ABMFLIST(ABMCNT)) Q:'ABMCNT  S ABMF($G(ABMFLIST(ABMCNT)))=""
 K ABMFQHC
 ;
 ;insurer or insurer type?
 K DIR,ABMY("ITYP"),ABMY("INS")
 S DIR(0)="SO^1:INSURER;2:INSURER TYPE"
 S DIR("A")="Sort by INSURER or INSURER TYPE"
 D ^DIR
 K DIR
 Q:$D(DIRUT)!$D(DIROUT)
 I Y=1 S ABMY("INS")="" D INSURER
 I Y=2 S ABMY("ITYP")="" D INSTYPE
 ;
 ;tribe
 K ABMY("TRIBE")
 W !
 F  D  Q:+$G(Y)<0!$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)
 .D ^XBFMK
 .S DIC="^AUTTTRI("
 .S DIC(0)="QEAM"
 .S DIC("A")="Select Tribe: "_$S('$D(ABMY("TRIBE")):"ALL// ",1:"")
 .D ^DIC
 .Q:+Y<0
 .S ABMY("TRIBE")=""
 .S ABMY("TRIBE",+Y)=""
 ;
 ;date range
DT ;
 Q:$D(DIRUT)
 S ABMY("DT")="V"
 W !!," ============ Entry of Visit Date Range =============",!
 S DIR("A")="Enter STARTING Visit Date for the Report"
 S DIR(0)="DO^::EP"
 D ^DIR
 G DT:$D(DIRUT)
 S ABMY("DT",1)=Y
 W !
 S DIR("A")="Enter ENDING DATE for the Report"
 D ^DIR
 K DIR
 G DT:$D(DIRUT)
 S ABMY("DT",2)=Y
 I ABMY("DT",1)>ABMY("DT",2) W !!,*7,"INPUT ERROR: Start Date is Greater than than the End Date, TRY AGAIN!",!! G DT
 ;
 K DIR
 S DIR(0)="S^A:ALL bills;P:POSTED bills w/pymts and pymt credits"
 S DIR("A")="All bills, or just bills with payments/payment credits posted?"
 S DIR("B")="ALL"
 D ^DIR
 I Y="A" S ABMY("ALL")=""
 I Y="P" S ABMY("POST")=""
 W !
 ;
 K DIR
 S DIR(0)="SA^C:CLINIC;V:VISIT TYPE"
 S DIR("A")="Sort Report by [V]isit Type or [C]linic: "
 S DIR("B")="V"
 S DIR("?")="Enter 'V' to sort the report by Visit Type (inpatient, outpatient, etc.) or a 'C' to sort it by the Clinic associated with each visit."
 D ^DIR
 I '$D(DIROUT)&('$D(DIRUT)) D
 .S ABMY("SORT")=Y
 .I ABMY("SORT")="C" D CLIN Q
 .D VTYP
 ;
 S ABM("HD",0)="TRIBAL PAYMENT REPORT"
 S ABMQ("RC")="COMPUTE^ABMTPYMT"
 S ABMQ("RX")="POUT^ABMDRUTL"
 S ABMQ("NS")="ABM"
 S ABMQ("RP")="PRINT^ABMTPYMT"
 D ^ABMDRDBQ
 Q
INSURER ;
 ;insurer
 W !
 F  D  Q:+$G(Y)<0!$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)
 .D ^XBFMK
 .S DIC="^AUTNINS("
 .S DIC(0)="QEAM"
 .S DIC("A")="Select Insurer: "_$S(($D(ABMY("INS"))<10):"ALL// ",1:"")
 .D ^DIC
 .Q:+Y<0
 .S ABMY("INS")=""
 .S ABMY("INS",+Y)=""
 Q
 ;
INSTYPE ;
 ;insurer type
 F  D  Q:+$G(Y)<0!$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)
 .D ^XBFMK
 .S DIR(0)="SO^R:MEDICARE FI;D:MEDICAID FI;P:PRIVATE;N:NON-BENEFICIARY PATIENTS;I:BENEFICIARY PATIENTS;W:WORKMAN'S COMP;K:CHIP;H:HMO;M:MEDICARE SUPPL"
 .S DIR(0)=DIR(0)_";C:CHAMPUS;F:FRATERNAL ORG;T:3P LIABILITY;G:GUARANTOR;MD:MCR PART D;MH:MEDICARE HMO;A:ALL"
 .S DIR("A")="Select INSURER TYPE to Display"
 .S:$D(ABMY("ITYP"))<10 DIR("B")="ALL"
 .D ^DIR
 .K DIR
 .Q:$D(DIRUT)!$D(DIROUT)
 .S ABMY("ITYP")=""
 .I Y="A" S Y=-1 Q
 .S ABMY("ITYP",Y)=""
 Q
CLIN ;SELECT CLINICS
 K ABMY("CLIN")
 S DIC="^DIC(40.7,"
 S DIC(0)="AEMQ"
 S DIC("A")="Select Clinic: ALL// "
 F  D  Q:+Y<0
 .I $D(ABMY("CLIN")) S DIC("A")="Select Another Clinic: "
 .D ^DIC
 .Q:+Y<0
 .S ABMY("CLIN",+Y)=""
 I '$D(ABMY("CLIN")) D
 .I $D(DUOUT) K ABMY("SORT") Q
 .W "ALL"
 K DIC
 Q
 ;
VTYP ;SELECT VISIT TYPES
 K ABMY("VTYP")
 S DIC="^ABMDVTYP("
 S DIC(0)="AEMQ"
 S DIC("A")="Select Visit Type: ALL// "
 F  D  Q:+Y<0
 .I $D(ABMY("VTYP")) S DIC("A")="Select Another Visit Type: "
 .D ^DIC
 .Q:+Y<0
 .S ABMY("VTYP",+Y)=""
 I '$D(ABMY("VTYP")) D
 .I $D(DUOUT) K ABMY("SORT") Q
 .W "ALL"
 K DIC
 Q
 ;
COMPUTE ;EP - Entry Point for Setting up Data
 S ABM("SUBR")="ABM-TPYMT" K ^TMP("ABM-TPYMT",$J)
 S ABM("SD")=ABMY("DT",1)-.5
 F  S ABM("SD")=$O(^ABMDBILL(DUZ(2),"AD",ABM("SD"))) Q:'+ABM("SD")!(ABM("SD")>ABMY("DT",2))  D
 .S ABM=""
 .F  S ABM=$O(^ABMDBILL(DUZ(2),"AD",ABM("SD"),ABM)) Q:'ABM  D DATA
 Q
 ;
DATA ;
 S ABMP("HIT")=0 D BILL Q:'ABMP("HIT")
 S ABM("L")=$P(^DIC(4,ABM("L"),0),U)
 I $D(ABMY("ITYP")) D
 .S ABM("I")=$P($G(^AUTNINS(ABM("I"),2)),U)
 .S ABM("I")=$P($T(@ABM("I")),";;",2)
 I $D(ABMY("INS")) S ABM("I")=$P($G(^AUTNINS(ABM("I"),0)),U)
 S ABM("TRIBE")=$P($G(^AUTTTRI(ABM("TRIBE"),0)),U)
 S ABM("S")=$S(ABMY("SORT")="V":ABM("V"),1:ABM("C"))
 S ^TMP("ABM-TPYMT",$J,ABM("L")_U_ABM("TRIBE")_U_ABM("S")_U_ABM("I")_U_ABM("P")_U_ABM("D")_U_ABM_U_ABM("PD"))=""
 Q
H ;;HMO
M ;;MEDICARE SUPPL.
D ;;MEDICAID FI
R ;;MEDICARE FI
P ;;PRIVATE
W ;;WORKMEN'S COMP
C ;;CHAMPUS
F ;;FRATERNAL ORG
N ;;NON-BENEFICIARY
I ;;BENEFICIARY
K ;;KIDSCARE (CHIP)
T ;;THIRD PARTY LIABILITY
G ;;GUARANTOR
MD ;;MEDICARE PART D
MH ;;MEDICARE HMO
 ;
BILL ;EP for checking Bill File data parameters
 Q:'$D(^ABMDBILL(DUZ(2),ABM,0))!('$D(^(1)))
 Q:$P(^ABMDBILL(DUZ(2),ABM,0),"^",4)="X"
 ;ABM("L") is piece 3 of bill file
 S ABM("V")=$P($G(^ABMDBILL(DUZ(2),ABM,0)),U,7)
 S ABM("C")=$P($G(^ABMDBILL(DUZ(2),ABM,0)),U,10)
 Q:($D(ABMY("VTYP"))&(ABM("V")=""))
 Q:($D(ABMY("CLIN"))&(ABM("C")=""))
 I $D(ABMY("CLIN")),'$D(ABMY("CLIN",+$P(^ABMDBILL(DUZ(2),ABM,0),U,10))) Q
 I $D(ABMY("VTYP")),'$D(ABMY("VTYP",+$P(^ABMDBILL(DUZ(2),ABM,0),U,7))) Q
 S ABM("L")=$P($G(^ABMDBILL(DUZ(2),ABM,0)),U,3)
 S ABM("I")=$P($G(^ABMDBILL(DUZ(2),ABM,0)),U,8)
 S ABM("P")=$P($G(^ABMDBILL(DUZ(2),ABM,0)),U,5)
 S ABM("TRIBE")=$P($G(^AUPNPAT(ABM("P"),11)),U,8)
 S ABM("D")=$P($G(^ABMDBILL(DUZ(2),ABM,7)),U)
 Q:ABM("L")=""!(ABM("I")="")!(ABM("P")="")!(ABM("D")="")
 Q:'$D(^AUTNINS(ABM("I"),0))
 I $D(ABMY("LOC"))>10,ABMY("LOC")'=ABM("L") Q
 I $D(ABMY("INS"))>10,'$D(ABMY("INS",ABM("I"))) Q
 I $D(ABMY("ITYP"))>10,'$D(ABMY("ITYP",$P($G(^AUTNINS(ABM("I"),2)),U))) Q
 I $D(ABMY("TRIBE"))>10,'$D(ABMY("TRIBE",ABM("TRIBE"))) Q
 K ABM("QUIT")
 S ABMP("HIT")=1
 S ABM("PD")=0
 I +$O(^ABMDBILL(DUZ(2),ABM,3,0))=0 S:$D(ABMY("POST")) ABMP("HIT")=0 Q  ;no pymts/adjs
 S ABMPIEN=0
 F  S ABMPIEN=$O(^ABMDBILL(DUZ(2),ABM,3,ABMPIEN)) Q:'ABMPIEN  D
 .;quit if no payments or payment adjustments
 .I (+$P($G(^ABMDBILL(DUZ(2),ABM,3,ABMPIEN,0)),U,10)=0)&(+$P($G(^ABMDBILL(DUZ(2),ABM,3,ABMPIEN,0)),U,14)=0)  Q
 .S ABM("PD")=ABM("PD")+$P($G(^ABMDBILL(DUZ(2),ABM,3,ABMPIEN,0)),U,10)+$P($G(^ABMDBILL(DUZ(2),ABM,3,ABMPIEN,0)),U,14)
 I +ABM("PD")=0&($D(ABMY("POST"))) S ABMP("HIT")=0  ;no pymt/pymt credit was found on bill
 Q
 ;
PRINT ;
 S ABM("PG")=1
 D HDR
 S ABM("TXT")="",ABM("L")="",ABM("I")="",ABM("T")="",ABM("V")=""
 S ABMBILLS=0,ABMPAIDS=0
 S ABMBILLT=0,ABMPAIDT=0
 S ABMBILLV=0,ABMPAIDV=0
 F  S ABM("TXT")=$O(^TMP("ABM-TPYMT",$J,ABM("TXT"))) Q:$G(ABM("TXT"))=""  D  Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 .I $Y>(IOSL-5) D HD Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)  W " (cont)"
 .I ABM("L")=""!(ABM("L")'=$P(ABM("TXT"),U)) D LOC S (ABM("T"),ABM("I"),ABM("S"))=""
 .I ABM("T")'="",ABM("T")'=$P(ABM("TXT"),U,2) S (ABM("L"),ABM("I"))="" D VSUB,TSUB,TRIBE S (ABM("S"),ABM("I"))=""
 .I ABM("T")="" D TRIBE
 .;I ABM("S")=""!(ABM("S")'=$P(ABM("TXT"),U,3)) D VIS S (ABM("I"))=""
 .I ABM("S")'="",ABM("S")'=$P(ABM("TXT"),U,3) S (ABM("I"))="" D VSUB,VIS S ABM("I")=""
 .I ABM("S")="" D VIS
 .I ABM("I")=""!(ABM("I")'=$P(ABM("TXT"),U,4)) D INS S (ABM("I"))=""
 .S ABM("L")=$P(ABM("TXT"),U)
 .S ABM("T")=$P(ABM("TXT"),U,2)
 .S ABM("S")=$P(ABM("TXT"),U,3)
 .S ABM("I")=$P(ABM("TXT"),U,4)
 .W !,$E($$GET1^DIQ(2,$P(ABM("TXT"),U,5),".01","E"),1,26)
 .W ?28,$P($G(^ABMDBILL(DUZ(2),$P(ABM("TXT"),U,7),0)),U)
 .W ?37,$$SDT^ABMDUTL($P(ABM("TXT"),U,6))
 .W ?48,$J($FN($P($G(^ABMDBILL(DUZ(2),$P(ABM("TXT"),U,7),2)),U),",",2),12)
 .W ?62,$J($FN(+$P(ABM("TXT"),U,8),",",2),12)
 .S ABMBILLS=+$G(ABMBILLS)+$P($G(^ABMDBILL(DUZ(2),$P(ABM("TXT"),U,7),2)),U)
 .S ABMBILLV=+$G(ABMBILLV)+$P($G(^ABMDBILL(DUZ(2),$P(ABM("TXT"),U,7),2)),U)
 .S ABMBILLT=+$G(ABMBILLT)+$P($G(^ABMDBILL(DUZ(2),$P(ABM("TXT"),U,7),2)),U)
 .S ABMPAIDS=+$G(ABMPAIDS)+$P(ABM("TXT"),U,8)
 .S ABMPAIDV=+$G(ABMPAIDV)+$P(ABM("TXT"),U,8)
 .S ABMPAIDT=+$G(ABMPAIDT)+$P(ABM("TXT"),U,8)
 D VSUB
 D TSUB
 W !!?48,"============",?62,"============"
 W !?30,"Report Totals",?48,$J($FN(ABMBILLT,",",2),12),?62,$J($FN(ABMPAIDT,",",2),12)
 K ^TMP("ABM-TPYMT",$J)
 Q
 ;
HD ;
 D PAZ^ABMDRUTL Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 S ABM("PG")=+$G(ABM("PG"))+1
HDR ;
 D EN^ABMVDF("IOF")
 W !
 S ABM("HD",0)="TRIBAL PAYMENT REPORT"
 D NOW^%DTC  ;abm*2.6*1 NO HEAT
 W ABM("HD",0),?$S($D(ABM(132)):103,1:48) S Y=% X ^DD("DD") W Y,"   Page ",ABM("PG")  ;abm*2.6*1 NO HEAT  ;abm*2.6*3 HEAT12210
 W !,"for Visit Dates from ",$$SDT^ABMDUTL(ABMY("DT",1))," to ",$$SDT^ABMDUTL(ABMY("DT",2))
 W !,"Billing Location: ",$P($G(^AUTTLOC(DUZ(2),0)),U,2)
 W !
 F ABM=1:1:80 W "="
 W !,"PATIENT",?28,"CLAIM",?37,"DOS",?48,"AMOUNT BILLED",?62,"AMOUNT PAID",!
 F ABM=1:1:80 W "="
 W !
 Q
LOC ;
 W !,"Location: ",$P(ABM("TXT"),U)
 Q
VIS ;
 W !
 I ABMY("SORT")="C" W ?5,"Clinic: ",$P(^DIC(40.7,$P(ABM("TXT"),U,3),0),U)
 I ABMY("SORT")="V" W ?5,"Visit Type: ",$P(^ABMDVTYP($P(ABM("TXT"),U,3),0),U)
 Q
VSUB ;
 W !?48,"============",?62,"============"
 W !?30
 I ABMY("SORT")="C" W ?5,"Clinic"
 I ABMY("SORT")="V" W ?5,"Visit Type"
 W " Totals",?48,$J($FN(ABMBILLV,",",2),12),?62,$J($FN(ABMPAIDV,",",2),12)
 S ABMBILLV=0,ABMPAIDV=0
 Q
INS ;
 I $D(ABMY("INS")) W !?7,"Insurer: "
 I $D(ABMY("ITYP")) W !?7,"Insurer Type: "
 W $P(ABM("TXT"),U,4)
 Q
TRIBE ;
 W !!?3,"Tribe: ",$P(ABM("TXT"),U,2)
 Q
TSUB ;
 W !?48,"============",?62,"============"
 W !?30,"Tribe Totals",?48,$J($FN(ABMBILLS,",",2),12),?62,$J($FN(ABMPAIDS,",",2),12)
 S ABMBILLS=0,ABMPAIDS=0
 Q
