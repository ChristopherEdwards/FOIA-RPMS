ABMDRXC ; IHS/SD/DMJ - Closed Claims Listing ;
 ;;2.6;IHS 3P BILLING SYSTEM;**4**;NOV 12, 2009
 ;Original;TMD;
 ; IHS/SD/SDR - abm*2.6*4 - NOHEAT -fixed report header for closed/exported dates
 ;
 K ABM,ABMY
 S ABM("RTYP")=1,ABM("RTYP","NM")="BRIEF LISTING (80 Width)"
 ;
SEL S ABM("CLOS")=DUZ
 ;S ABM("STA")="X",ABM("STA","NM")="Closed Claims Report"  ;abm*2.6*4 NOHEAT
 S ABM("STA")="M",ABM("STA","NM")="Closed Claims Report"  ;abm*2.6*4 NOHEAT
 S ABM("NODX")=""
 D ^ABMDRSEL Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 S ABM("HD",0)="BRIEF LISTING of CLAIMS "_ABM("STA","NM")
 D ^ABMDRHD
 S ABMQ("RC")="COMPUTE^ABMDRXC"
 S ABMQ("RX")="POUT^ABMDRUTL"
 S ABMQ("NS")="ABM"
 S ABMQ("RP")="PRINT^ABMDRXC"_ABM("RTYP")
 D ^ABMDRDBQ
 Q
 ;
COMPUTE ;EP - Entry Point for Setting up Data
 S ABM("STA")="X"  ;abm*2.6*4 NOHEAT
 I $G(ABMY("DT"))="M" S ABMY("DT")="X"  ;abm*2.6*4 NOHEAT
 S ABM("SUBR")="ABM-CLS" K ^TMP("ABM-CLS",$J) Q:'$D(ABM("STA"))  S ABM("PG")=0
ALL ;ALL STATUS
SLOOP I $D(ABMY("DT")),($G(ABMY("DT"))="V") D  Q
 .S ABM("RD")=ABMY("DT",1)-1
 .F  S ABM("RD")=$O(^ABMDCLM(DUZ(2),"AD",ABM("RD"))) Q:'+ABM("RD")!(ABM("RD")>ABMY("DT",2))  D
 ..S ABM="" F  S ABM=$O(^ABMDCLM(DUZ(2),"AD",ABM("RD"),ABM)) Q:'ABM  D DATA
 ;LOOP THROUGH STATUS
 S ABM="" F  S ABM=$O(^ABMDCLM(DUZ(2),"AS",ABM("STA"),ABM)) Q:'ABM  D DATA
 Q
 ;
DATA S ABMP("HIT")=0 D CLM^ABMDRCHK Q:'ABMP("HIT")
 S ABM("SORT")=$S(ABMY("SORT")="C":ABM("C"),1:ABM("V"))
 S ABM("L")=$P(^DIC(4,ABM("L"),0),U)
 S ^TMP("ABM-CLS",$J,ABMY("CLOSER")_U_ABM("L")_U_ABM("SORT")_U_ABM("REAS")_U_$P(^DPT(ABM("P"),0),U)_U_ABM_$S(+$G(ABMCLSCT)>1:"*",1:""))=""
 S ABM("ST",ABMY("CLOSER"),ABM("L"),ABM("SORT"))=$G(ABM("ST",ABMY("CLOSER"),ABM("L"),ABM("SORT")))+1
 Q
