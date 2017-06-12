ABMDRDX ; IHS/ASDST/DMJ - DX Summary Report ;
 ;;2.6;IHS 3P BILLING SYSTEM;**14**;NOV 12, 2009;Build 238
 ;Original;TMD;
 ;
 ; IHS/SD/SDR - v2.6 CSV
 ;IHS/SD/SDR - 2.6*14 - ICD10 009 - Correct to report found while coding for ICD10. was using code,
 ;   not IEN so any codes starting with alpha wouldn't print.
 ;IHS/SD/SDR - 2.6*14 - Updated DX^ABMCVAPI call to be numeric
 ;
 K ABM,ABMY
 D ^ABMDRSEL G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
HD S ABM("HD",0)="BILLED PRIMARY DIAGNOSIS" D ^ABMDRHD
 S ABMQ("RC")="COMPUTE^ABMDRDX",ABMQ("RP")="PRINT^ABMDRDX1",ABMQ("RX")="POUT^ABMDRUTL",ABMQ("NS")="ABM"
 D ^ABMDRDBQ
 Q
 ;
COMPUTE ;EP - Entry Point for Setting up Data
 S ABM("SUBR")="ABM-DX" K ^TMP(ABM("SUBR"),$J)
 S ABMP("RTN")="ABMDRDX" D LOOP^ABMDRUTL
 Q
 ;
DATA S ABMP("HIT")=0 D ^ABMDRCHK Q:'ABMP("HIT")
 S ABM("DX")=$O(^ABMDBILL(DUZ(2),ABM,17,"C",0)) Q:'ABM("DX")
 S ABM("DX")=$O(^ABMDBILL(DUZ(2),ABM,17,"C",ABM("DX"),0)) Q:'ABM("DX")
 Q:'$D(^ABMDBILL(DUZ(2),ABM,17,ABM("DX"),0))  S ABM("DX")=+^(0)
 S ABM("BL")=+^ABMDBILL(DUZ(2),ABM,2)
TL S:'$D(^TMP("ABM-DX",$J)) ^TMP("ABM-DX",$J)=0_U_0
 S $P(^TMP("ABM-DX",$J),U)=$P(^($J),U)+1,$P(^($J),U,2)=$P(^($J),U,2)+ABM("BL")
 ;S ABM("CD")=+$P($$DX^ABMCVAPI(ABM("DX"),ABM("D")),U,2)  ;CSV-c  ;abm*2.6*14 ICD10 009
 S ABM("CD")=+$P($$DX^ABMCVAPI(+ABM("DX"),ABM("D")),U)  ;CSV-c  ;abm*2.6*14 ICD10 009 and updated API call
 S:'$D(^TMP("ABM-DX",$J,ABM("CD"),ABM("DX"))) ^TMP("ABM-DX",$J,ABM("CD"),ABM("DX"))=0_U_0
 S $P(^TMP("ABM-DX",$J,ABM("CD"),ABM("DX")),U)=$P(^TMP("ABM-DX",$J,ABM("CD"),ABM("DX")),U)+1,$P(^(ABM("DX")),U,2)=$P(^(ABM("DX")),U,2)+ABM("BL")
 Q
 ;
XIT K ABM,ABMY,ABMP
 Q
