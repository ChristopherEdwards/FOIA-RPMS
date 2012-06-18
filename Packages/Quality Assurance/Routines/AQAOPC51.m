AQAOPC51 ; IHS/ORDC/LJF - CALC FOR QTR PROGRESS RPT ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn counts occ finding/action pairs by month for indicator(s)
 ;selected by user.  It also finds action plans tied to the indicators.
 ;
 K ^TMP("AQAOPC5A",$J),^TMP("AQAOPC5B",$J) ;start with clean globals
 ;
TMP ; >>> loop thru ^TMP to find indicators
 F AQAOI="SINGLE","MED STAFF F","FACILITY WIDE","KEY FUNCTION","OTHER","DIMENSION" D
 .S AQAOF=AQAOI
 .F  S AQAOF=$O(^TMP("AQAOPC5",$J,1,AQAOF)) Q:AQAOF'[AQAOI  D
 ..S AQAOIND=0
 ..F  S AQAOIND=$O(^TMP("AQAOPC5",$J,1,AQAOF,AQAOIND)) Q:AQAOIND=""  D
 ...;
 ...; >>for this indicator, find occ for date range
 ...S AQAODT=AQAOBD-.001
 ...F  S AQAODT=$O(^AQAOC("AA",AQAOIND,AQAODT)) Q:AQAODT=""  Q:AQAODT>(AQAOED_".24")  D
 ....S DFN=0
 ....F  S DFN=$O(^AQAOC("AA",AQAOIND,AQAODT,DFN)) Q:DFN=""  D
 .....S AQAOIFN=0
 .....F  S AQAOIFN=$O(^AQAOC("AA",AQAOIND,AQAODT,DFN,AQAOIFN)) Q:AQAOIFN=""  D
 ......D CHECK ;check occ for validity
 ......Q:'$D(AQAOK)  ;occ not valid for this report
 ......D COUNT ;increment counts
 ...;
 ...; >>for this indicator, find any action plans linked to it for dates
 ...D ACTION ;check if action plan linked for date range
 ;
PRINT ; >>> go to print rtn
 I $D(AQAODLM) G ^AQAOPC53 ; ASCIIformat
 G ^AQAOPC52
 ;
 ;
 ;
CHECK ; >> SUBRTN to check out occurrence
 K AQAOK ;occ okay flag
 I '$D(^AQAOC(AQAOIFN,0)) Q  ;bad xref
 Q:'$D(^AQAOC(AQAOIFN,1))  Q:$P(^(1),U)'=1  ;not closed
 Q:$$EXCEP^AQAOLKP(AQAOIFN)  ;exception to criteria
 Q:'$D(^AQAOC(AQAOIFN,"FINAL"))  S AQAOS=^("FINAL")
 ;Q:$P(AQAOS,U,4)=""  Q:$P(AQAOS,U,6)=""  ;need final finding & action
 S AQAOK="" Q
 ;
 ;
COUNT ; >> SUBRTN to increment counts of findings, actions by indicator
 ;
 S X=$P(AQAOS,U,4),AQAOFA=$S(X="":"??",1:$P(^AQAO(8,X,0),U,2)) ;findng
 S X=$P(AQAOS,U,6),AQAOAA=$S(X="":"??",1:$P(^AQAO(6,X,0),U,2)) ;action
 S AQAOMON=$E(AQAODT,1,5) ;month of occ
 ;
 ;increment total count for indicator
 S ^TMP("AQAOPC5A",$J,AQAOF,AQAOIND)=$G(^TMP("AQAOPC5A",$J,AQAOF,AQAOIND))+1
 ;increment count for ind for find&action
 S ^TMP("AQAOPC5A",$J,AQAOF,AQAOIND,AQAOFA,AQAOAA)=$G(^TMP("AQAOPC5A",$J,AQAOF,AQAOIND,AQAOFA,AQAOAA))+1
 ;increment for find&act&month
 S ^TMP("AQAOPC5A",$J,AQAOF,AQAOIND,AQAOFA,AQAOAA,AQAOMON)=$G(^TMP("AQAOPC5A",$J,AQAOF,AQAOIND,AQAOFA,AQAOAA,AQAOMON))+1
 Q
 ;
 ;
ACTION ; >> SUBRTN to find any action plans tied to ind for date range
 S AQAOAC=0
 F  S AQAOAC=$O(^AQAO(5,"C",AQAOIND,AQAOAC)) Q:AQAOAC=""  D
 .Q:'$D(^AQAO(5,AQAOAC,0))  S AQAOS=^(0)
 .Q:$P(AQAOS,U,5)=9  ;deleted action plan
 .Q:$P(AQAOS,U,3)<AQAOBD  ;implemented before those occurrences
 .S ^TMP("AQAOPC5B",$J,AQAOIND,AQAOAC)=""
 Q
