AQAOPC41 ; IHS/ORDC/LJF - CALCULATE OCC WITH FINDINGS ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contains the code to find occurrences for the selected
 ;indicator & date range subtotaled by finding and action.
 ;
 K ^TMP("AQAOPC4",$J)
 S AQAOCNT=0 ;initialize total count
DTLOOP ; >>> loop thru occ file by date for indicator
 S AQAODT=AQAOBD-.0001,AQAOEDT=AQAOED_.2400
 F  S AQAODT=$O(^AQAOC("AA",AQAOIND,AQAODT)) Q:AQAODT=""  Q:AQAODT>AQAOEDT  D
 .S DFN=0
 .F  S DFN=$O(^AQAOC("AA",AQAOIND,AQAODT,DFN)) Q:DFN=""  D
 ..S AQAOIFN=0
 ..F  S AQAOIFN=$O(^AQAOC("AA",AQAOIND,AQAODT,DFN,AQAOIFN)) Q:AQAOIFN=""  D
 ...Q:'$D(^AQAOC(AQAOIFN,0))  S AQAOSTR=^(1) Q:$P(^(1),U)=2  ;deleted
 ...Q:$P(^AQAOC(AQAOIFN,0),U,9)'=DUZ(2)  ;PATCH 3
 ...Q:$$EXCEP^AQAOLKP(AQAOIFN)
 ...I AQAOSTAT="C" Q:$P(AQAOSTR,U)=0  ;no open cases allowed
 ...I ($P(AQAOSTR,U,5)="")!($P(AQAOSTR,U,6)="") Q  ;not reviewed
 ...I $D(AQAOXSN) Q:$$CHK^AQAOPCX(AQAOXSN)=0  ;spec rev type search
 ...;                                        ;returns AQAOARS array
 ...S AQAOCNT=AQAOCNT+1 ;increment total cases
 ...;
 ...S AQAOSUB=0
 ...I '$D(AQAOXSN) S ^TMP("AQAOPC4",$J,AQAOSUB,AQAODT,AQAOIFN)="" Q
 ...F  S AQAOSUB=$O(AQAOARS(AQAOSUB)) Q:AQAOSUB=""  D
 ....S ^TMP("AQAOPC4",$J,AQAOSUB,AQAODT,AQAOIFN)=""
 ;
NEXT ; >>> go to print rtn
 G ^AQAOPC42
