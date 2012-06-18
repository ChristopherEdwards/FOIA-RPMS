ABMDRPT ; IHS/ASDST/DMJ - Bill Listing ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;
 ;
 K ABM,ABMY S ABM("PAY")="",ABMP("TYP")=3
 S ABM("PRIVACY")=1,ABM("COST")=""
SEL S DIC="^AUPNPAT(",DIC(0)="QEAM" D ^DIC G XIT:X=""!$D(DTOUT)!$D(DUOUT),SEL:+Y<1 S ABM("PAT")=+Y
 W ! K DIR
 S DIR(0)="YO",DIR("A")="Screen out BILLS that are COMPLETED"
 S DIR("?")="Answer YES if those Bills that are in a Completed Status (unobligated balance equal to zero) are to be screened out (not included)."
 S DIR("B")="N" D ^DIR G XIT:$D(DIRUT)!$D(DIROUT)
 S ABMP("COMPL")=+Y
 S ABM("RTYP")=1,ABM("RTYP","NM")="BRIEF LISTING (80 Width)" D ^ABMDRSEL G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
HD S ABM("HD",0)="BILLING ACTIVITY of "_$P(^DPT(ABM("PAT"),0),U)
 D ^ABMDRHD
 S ABMQ("RC")="COMPUTE^ABMDRPT",ABMQ("RX")="POUT^ABMDRUTL",ABMQ("NS")="ABM"
 I ABM("RTYP")<3 S ABMQ("RP")="PRINT^ABMDRPT"_ABM("RTYP")
 E  S ABMQ("RP")="PRINT^ABMDRAL"_ABM("RTYP")
 ;S ABM("$J")=DUZ_"-"_$P($H,",",1)_"-"_$P($H,",",2)
 D ^ABMDRDBQ
 Q
 ;
COMPUTE ;EP - Entry Point for Setting up Data
 S ABM("SUBR")="ABM-PT" K ^TMP("ABM-PT",$J),^TMP("ABM-PT",$J,"ST")
PAT S ABM="" F  S ABM=$O(^ABMDBILL(DUZ(2),"D",ABM("PAT"),ABM)) Q:'ABM  D DATA
 Q
 ;
DATA S ABMP("HIT")=0 D ^ABMDRCHK Q:'ABMP("HIT")
 S:ABM("XD")]"" ABM("XD")=$P($G(^ABMDTXST(DUZ(2),ABM("XD"),0)),U)
 I $G(ABMY("DT"))="X",ABM("XD")<ABMY("DT",1)!(ABM("XD")>ABMY("DT",2)) Q
 I $G(ABMY("DT"))="A",ABM("AD")<ABMY("DT",1)!(ABM("AD")>ABMY("DT",2)) Q
 I $G(ABMY("DT"))="V",ABM("D")<ABMY("DT",1)!(ABM("D")>ABMY("DT",2)) Q
 S ABM("S1")=$S(ABMY("SORT")="C":ABM("C"),1:ABM("V"))
 S ABM("S2")=$S(ABM("RTYP")=3:0,1:$P(^AUTNINS(ABM("I"),0),U))
 S ABM("S3")=$S(ABM("RTYP")=3:0,1:ABM)
 S ABM("L")=$P(^DIC(4,ABM("L"),0),U)
 G STAT:ABM("RTYP")>2
 S ^TMP("ABM-PT",$J,$E(ABM("L"),1,18)_U_ABM("S1")_U_$E(ABM("S2"),1,15)_U_$E($P(^DPT(ABM("P"),0),U),1,15)_U_ABM)=""
 Q
 ;
STAT I '$D(^TMP("ABM-PT",$J,"ST",ABM("L"),ABM("S1"),ABM("S2"),ABM("S3"))) S ^TMP("ABM-PT",$J,"ST",ABM("L"),ABM("S1"),ABM("S2"),ABM("S3"))=""
 S $P(^TMP("ABM-PT",$J,"ST",ABM("L"),ABM("S1"),ABM("S2"),ABM("S3")),U)=$P(^TMP("ABM-PT",$J,"ST",ABM("L"),ABM("S1"),ABM("S2"),ABM("S3")),U)+1
 S $P(^TMP("ABM-PT",$J,"ST",ABM("L"),ABM("S1"),ABM("S2"),ABM("S3")),U,2)=$P(^TMP("ABM-PT",$J,"ST",ABM("L"),ABM("S1"),ABM("S2"),ABM("S3")),U,2)+$P($G(^ABMDBILL(DUZ(2),ABM,2)),U)
 ;
PREV S (ABM("J"),ABM("PD"),ABM("DEDCT"))=0
 F  S ABM("J")=$O(^ABMDBILL(DUZ(2),ABM,3,ABM("J"))) Q:'ABM("J")  S ABM("PDD")=+^(ABM("J"),0) D
 .I $G(ABMY("DT"))="P",ABM("PDD")<ABMY("DT",1)!(ABM("PDD")>ABMY("DT",2)) Q
 .S ABM("PD")=$P(^ABMDBILL(DUZ(2),ABM,3,ABM("J"),0),U,2)+ABM("PD"),ABM("DEDCT")=ABM("DEDCT")+$P(^(0),U,3)+$P(^(0),U,4)
 S (ABM("WO"),ABM("OB"))=0
 I $P(^ABMDBILL(DUZ(2),ABM,0),U,4)="C" S ABM("WO")=^(2)-ABM("PD")-ABM("DEDCT")
 E  S ABM("OB")=$P(^ABMDBILL(DUZ(2),ABM,2),U)-ABM("PD")-ABM("DEDCT")
 I ABM("WO")<0 S ABM("OB")=ABM("WO"),ABM("WO")=0
 S $P(^TMP("ABM-PT",$J,"ST",ABM("L"),ABM("S1"),ABM("S2"),ABM("S3")),U,3)=$P(^TMP("ABM-PT",$J,"ST",ABM("L"),ABM("S1"),ABM("S2"),ABM("S3")),U,3)+ABM("PD")
 S $P(^TMP("ABM-PT",$J,"ST",ABM("L"),ABM("S1"),ABM("S2"),ABM("S3")),U,4)=$P(^TMP("ABM-PT",$J,"ST",ABM("L"),ABM("S1"),ABM("S2"),ABM("S3")),U,4)+ABM("DEDCT")
 S $P(^TMP("ABM-PT",$J,"ST",ABM("L"),ABM("S1"),ABM("S2"),ABM("S3")),U,5)=$P(^TMP("ABM-PT",$J,"ST",ABM("L"),ABM("S1"),ABM("S2"),ABM("S3")),U,5)+ABM("WO")
 S $P(^TMP("ABM-PT",$J,"ST",ABM("L"),ABM("S1"),ABM("S2"),ABM("S3")),U,6)=$P(^TMP("ABM-PT",$J,"ST",ABM("L"),ABM("S1"),ABM("S2"),ABM("S3")),U,6)+ABM("OB")
 Q
 ;
XIT K ABM,ABMY,ABMP
 Q
