ABMDRBR ; IHS/ASDST/DMJ - Brief Claims Listing ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;
 ;
 ; IHS/SD/SDR - v2.5 p13 - NO IM
 ;
 K ABM,ABMY
 S ABM("RTYP")=1,ABM("RTYP","NM")="BRIEF LISTING (80 Width)"
 S ABM("STA")="F"
 S ABM("STA","NM")="Flagged as Billable"
 ;
SEL S ABM("NODX")="" D ^ABMDRSEL Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 S ABM("HD",0)="BRIEF LISTING of CLAIMS "_ABM("STA","NM")
 D ^ABMDRHD
 S ABMQ("RC")="COMPUTE^ABMDRBR",ABMQ("RX")="POUT^ABMDRUTL",ABMQ("NS")="ABM"
 S ABMQ("RP")="PRINT^ABMDRBR"_ABM("RTYP")
 ;S ABM("$J")=DUZ_"-"_$P($H,",",1)_"-"_$P($H,",",2)
 D ^ABMDRDBQ
 Q
 ;
COMPUTE ;EP - Entry Point for Setting up Data
 S ABM("SUBR")="ABM-BR" K ^TMP("ABM-BR",$J) Q:'$D(ABM("STA"))  S ABM("PG")=0
ALL ;ALL STATUS
 I ABM("STA")="" D  Q
 .;F ABM("STA")="E","F","U","R","C" D SLOOP  ;abm*2.5*13 NO IM
 .F ABM("STA")="E","F","U","R","C","O" D SLOOP  ;abm*2.5*13 NO IM
 I ABM("STA")="F" D  Q
 .F ABM("STA")="E","F" D SLOOP
SLOOP I $D(ABMY("DT")) D  Q
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
 S ^TMP("ABM-BR",$J,ABM("L")_U_ABM("SORT")_U_$P(^DPT(ABM("P"),0),U)_U_ABM)=""
 S ABM("ST",ABM("L"),ABM("SORT"))=$G(ABM("ST",ABM("L"),ABM("SORT")))+1
 Q
