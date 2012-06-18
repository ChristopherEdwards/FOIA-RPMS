AQAOPC71 ; IHS/ORDC/LJF - CALC FOR SINGLE CRIT RPT ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This routine contains the code for calculating the totals for each
 ;possible value of a review criterion by occurrence date grouped
 ;by month.
 ;
 ;start with clean globals
 K ^TMP("AQAOPC7",$J),^TMP("AQAOPC7A",$J),^TMP("AQAOPC7B",$J)
 ;
LOOP ; >>for this indicator, find occ for date range
 S AQAODT=AQAOBD-.001
 F  S AQAODT=$O(^AQAOC("AA",AQAOIND,AQAODT)) Q:AQAODT=""  Q:AQAODT>(AQAOED_".24")  D
 .S DFN=0
 .F  S DFN=$O(^AQAOC("AA",AQAOIND,AQAODT,DFN)) Q:DFN=""  D
 ..S AQAOIFN=0
 ..F  S AQAOIFN=$O(^AQAOC("AA",AQAOIND,AQAODT,DFN,AQAOIFN)) Q:AQAOIFN=""  D
 ...Q:'$D(^AQAOC(AQAOIFN,0))  S AQAOSTR=^(0) Q:$P(^(1),U)=2  ;deleted
 ...Q:$P(^AQAOC(AQAOIFN,0),U,9)'=DUZ(2)  ;PATCH 3
 ...Q:$$EXCEP^AQAOLKP(AQAOIFN)
 ...I $D(AQAOXSN) Q:$$CHK^AQAOPCX(AQAOXSN)=0  ;flag for special searches
 ...;                                        ;also returns AQAOARS arry
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
 ;
 ;
PRINT ; >>> go to print rtn
 I $D(AQAODLM) G ^AQAOPC73 ; ASCIIformat
 G ^AQAOPC72
 ;
 ;
 ;
SET ; >> SUBRTN to set ^tmp & increment totals
 S AQAOMON=$E(AQAODT,1,5) ;month of occ
 I AQAOT="" Q  ;no value
 S AQAOVAL=$P(^AQAOCC(5,AQAOC,0),U,AQAOT+4) ;crit value
 I AQAOVAL="" Q  ;no value set, skip counts
 ;I AQAOT=2 S AQAOVAL=$P(^AQAO1(4,AQAOVAL,0),U,2) G SET1
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
 Q:AQAOVAL="N/A"
 S AQAOCNT(AQAOSUB)=$G(AQAOCNT(AQAOSUB))+1 ;increment occ total
 S ^TMP("AQAOPC7",$J,AQAOSUB,AQAOVAL)=$G(^TMP("AQAOPC7",$J,AQAOSUB,AQAOVAL))+1
 S ^TMP("AQAOPC7",$J,AQAOSUB,AQAOVAL,AQAOMON)=$G(^TMP("AQAOPC7",$J,AQAOSUB,AQAOVAL,AQAOMON))+1
 S ^TMP("AQAOPC7B",$J,AQAOSUB,AQAOMON)=$G(^TMP("AQAOPC7B",$J,AQAOSUB,AQAOMON))+1
 I AQAOTYPE="L" D
 .S AQAOID=$P(^AQAOC(AQAOIFN,0),U)
 .K ^UTILITY("DIQ1",$J) S DIC="^AQAOC(",DA=AQAOIFN,DR=".025" D EN^DIQ1
 .S X=^UTILITY("DIQ1",$J,9002167,AQAOIFN,.025) ;age at time of occ
 .S DFN=$P(^AQAOC(AQAOIFN,0),U,2) Q:DFN=""
 .S X=X_U_$P(^DPT(DFN,0),U,2)_U_AQAOVAL
 .S ^TMP("AQAOPC7A",$J,AQAOSUB,AQAODT,AQAOID)=X
 Q
