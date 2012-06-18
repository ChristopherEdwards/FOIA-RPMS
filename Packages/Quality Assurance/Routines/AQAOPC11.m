AQAOPC11 ; IHS/ORDC/LJF - CALCULATE OCC BY IND ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contains the code to find the occ by indicator & date range
 ;and find criteria values.
 ;
 K ^TMP("AQAOPC1",$J) K ^TMP("AQAOPC11",$J)
 S AQAOCNT=0 ;initialize total count
DTLOOP ; >>> loop thru occ file by date for indicator
 S AQAODT=AQAOBD-.0001,AQAOEDT=AQAOED_.2400
 F  S AQAODT=$O(^AQAOC("AA",AQAOIND,AQAODT)) Q:AQAODT=""  Q:AQAODT>AQAOEDT  D
 .S DFN=0
 .F  S DFN=$O(^AQAOC("AA",AQAOIND,AQAODT,DFN)) Q:DFN=""  D
 ..S AQAOIFN=0
 ..F  S AQAOIFN=$O(^AQAOC("AA",AQAOIND,AQAODT,DFN,AQAOIFN)) Q:AQAOIFN=""  D
 ...Q:'$D(^AQAOC(AQAOIFN,0))  S AQAOSTR=^(0) Q:$P(^(1),U)=2  ;deleted
 ...Q:$P(^AQAOC(AQAOIFN,0),U,9)'=DUZ(2)  ;PATCH 3
 ...Q:$$EXCEP^AQAOLKP(AQAOIFN)  ;exception to criteria?
 ...I $D(AQAOXSN) Q:$$CHK^AQAOPCX(AQAOXSN)=0  ;flag for special searches
 ...;                                        ;also returns AQAOARS arry
 ...S AQAOCNT=AQAOCNT+1 ;increment occ total
 ...;
 ...; >> loop thru criteria values for occurrence
 ...S AQAOCRT=0
 ...F  S AQAOCRT=$O(^AQAOCC(5,"AC",AQAOIFN,AQAOCRT)) Q:AQAOCRT=""  D
 ....Q:'$D(AQAOCR(AQAOCRT))  ;criteria not chosen for report
 ....S AQAOT=$P($G(^AQAO1(6,AQAOCRT,0)),U,2) ;set crit type
 ....S AQAOC=0
 ....F  S AQAOC=$O(^AQAOCC(5,"AC",AQAOIFN,AQAOCRT,AQAOC)) Q:AQAOC=""  D
 .....D SET ;set ^tmp and increment totals
 ;
NEXT ; >>> go to print rtn
 G ^AQAOPC12
 ;
 ;
SET ; >> SUBRTN to set ^tmp & increment totals
 I AQAOT="" S AQAOVAL="" G SET1 ;no value
 S AQAOVAL=$P(^AQAOCC(5,AQAOC,0),U,AQAOT+4) ;crit value
 S AQAOVALP="" I AQAOVAL="" G SET1 ;no value set, skip counts
 I AQAOT=2 S AQAOVALP=$P($G(^AQAO1(4,AQAOVAL,0)),U,2)
 S X=$S(AQAOT=1:.05,AQAOT=2:.06,AQAOT=3:.07,1:.08),Y=AQAOVAL
 I X=.08 S AQAOVAL=$E(Y,4,5)_" "_$E(Y,6,7)_" "_$E(Y,2,3)
 E  S C=$P(^DD(9002166.5,X,0),U,2) D Y^DIQ S AQAOVAL=Y ;printable form
COMMAS I AQAOVAL["," S AQAOVAL=$P(AQAOVAL,",")_" "_$P(AQAOVAL,",",2,99) G COMMAS
 ;
SET1 S AQAOSUB=0 I '$D(AQAOXSN) D SET2 Q
 F  S AQAOSUB=$O(AQAOARS(AQAOSUB)) Q:AQAOSUB=""  D SET2
 Q
 ;
 ;
SET2 ; >> SUBRTN to increment counts
 I (AQAOT'=2),(AQAOVAL]"") D  ;increment value cnt
 .S ^TMP("AQAOPC11",$J,AQAOSUB,AQAOCRT,AQAOVAL)=$G(^TMP("AQAOPC11",$J,AQAOSUB,AQAOCRT,AQAOVAL))+1
 I (AQAOT=2),(AQAOVALP]"") D  ;increment value counts for set of codes
 .S ^TMP("AQAOPC11",$J,AQAOSUB,AQAOCRT,AQAOVALP)=$G(^TMP("AQAOPC11",$J,AQAOSUB,AQAOCRT,AQAOVALP))+1
 I '$D(^TMP("AQAOPC1",$J,AQAOSUB,AQAODT,AQAOIFN)) D
 .S ^TMP("AQAOPC1",$J,AQAOSUB,AQAODT,AQAOIFN)=$P(AQAOSTR,U)_U_AQAOCRT_U_AQAOVAL
 E  S ^TMP("AQAOPC1",$J,AQAOSUB,AQAODT,AQAOIFN)=^(AQAOIFN)_U_AQAOCRT_U_AQAOVAL
 Q
