AQAOPC21 ; IHS/ORDC/LJF - CALCULATE OCC BY ICD CODES ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contains the code to find the occurrences for the selected
 ;indicator & date range screened by the diagnoses & procedures the
 ;user selected.
 ;
 K ^TMP("AQAOPC2",$J)
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
 ...Q:$$EXCEP^AQAOLKP(AQAOIFN)
 ...I $D(AQAOXSN) Q:$$CHK^AQAOPCX(AQAOXSN)=0  ;spec rev type searches
 ...;                                        ;AQAOARS array returned
 ...S AQAOFLG=0 D ICDCHK ;check if occ has icd code in range
 ...Q:AQAOFLG=0  ;no icd code in ranges
 ...S AQAOCNT=AQAOCNT+1 ;increment total cases
 ...;
 ...S AQAOSUB=0
 ...I '$D(AQAOXSN) S ^TMP("AQAOPC2",$J,AQAOSUB,AQAODT,AQAOIFN)="" Q
 ...F  S AQAOSUB=$O(AQAOARS(AQAOSUB)) Q:AQAOSUB=""  D
 ....S ^TMP("AQAOPC2",$J,AQAOSUB,AQAODT,AQAOIFN)=""
 ;
NEXT ; >>> go to print rtn
 G ^AQAOPC22
 ;
 ;
ICDCHK ; >> SUBRTN to check occ for icd codes in range
 I $D(AQAOARR("ALL")),$D(AQAOARR1("ALL")) S AQAOFLG=1 Q  ;all codes
 F I=8,9 D
 .I I=8,$D(AQAOARR("ALL")) S AQAOFLG(I)=1 Q  ;bypass dx chk if all dx
 .I I=9,$D(AQAOARR1("ALL")) S AQAOFLG(I)=1 Q  ;bypass chk if all proc
 .S AQAOFLG(I)=0 ;init flag for type of code
 .S X=0 F  S X=$O(^AQAOCC(I,"AB",AQAOIFN,X)) Q:X'=+X  Q:AQAOFLG(I)=1  D
 ..Q:'$D(^AQAOCC(I,X,0))  S Y=+^(0) ;set pointer to icd file
 ..S AQAOY=$S(I=8:$P(^ICD9(Y,0),U),1:$P(^ICD0(Y,0),U)) ;icd code #
 ..S AQAOX=$S(I=8:"AQAOARR(",1:"AQAOARR1(") D RANGE ;is code in range
 ..S AQAOFLG(I)=AQAOFLG,AQAOFLG=0
 I AQAOFLG(8)=1,AQAOFLG(9)=1 S AQAOFLG=1
 Q
 ;
 ;
RANGE ; >> SUBRTN to check occ code against range selected
 S Y=AQAOY-1,AQAOFLG=0
 ;                                          ;case1:past AQAOY
 F  S Y=$O(@(AQAOX_""""_Y_""")")) Q:Y=""  Q:AQAOY<+Y  Q:AQAOFLG=1  D
 .S Z=AQAOX_""""_Y_""")",Z=@Z I AQAOY>+Z Q  ;case2:continu loop-too low
 .S AQAOFLG=1 Q
 Q
