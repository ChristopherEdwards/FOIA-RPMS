BKMVF32 ;PRXM/HC/JGH - Reminders From Patient Record and Menu Tree (Functions - 2); Mar 21, 2005 ; 09 Jun 2005  12:37 PM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 QUIT
 ; KJH - 04/13/2005 - Split from original routine due to size restrictions.
 ;
POSITIVE(RESULT) ; EP - If the result is positive return a 1 else return a 0.
 I $E(RESULT,1)="+" Q 1
 I $E(RESULT,1)=">" Q 1
 S RESULT=$$UP^XLFSTR(RESULT)
 I RESULT="P" Q 1 ; Positive
 I RESULT="R" Q 1 ; Reactive
 I RESULT="WR" Q 1 ; Weakly Reactive
 I RESULT="REACTIVE" Q 1 ; Reactive
 I RESULT="WEAKLY REACTIVE" Q 1 ; Weakly Reactive
 ; Result field contains a word that starts with "POS" or "pos"
 N FLG,I
 S FLG=0
 I $E(RESULT,1,3)="POS" S FLG=1 Q FLG
 F I=1:1:$L(RESULT) I $E(RESULT,I)?1P,$E(RESULT,I+1,I+3)="POS" S FLG=1 Q
 Q FLG
 ;I RESULT["POS" Q 1 ; Positive
 ;Q 0
 ;
NEGATIVE(RESULT) ; EP - If the result is negative return a 1 else return a 0.
 I $E(RESULT,1)="-" Q 1
 ; **NOTE: Documentation does not specify if "<" is considered negative.
 S RESULT=$$UP^XLFSTR(RESULT)
 I RESULT="N" Q 1 ; Negative (or Non-Reactive)
 I RESULT="NR" Q 1 ; Non-Reactive
 I RESULT="NON-REACTIVE" Q 1 ; Non-Reactive
 I RESULT="NON REACTIVE" Q 1 ; Non-Reactive
 I RESULT="NONREACTIVE" Q 1 ; Non-Reactive
 ; Result field contains a word that starts with "NEG" or "neg"
 N FLG,I
 S FLG=0
 I $E(RESULT,1,3)="NEG" S FLG=1 Q FLG
 F I=1:1:$L(RESULT) I $E(RESULT,I)?1P,$E(RESULT,I+1,I+3)="NEG" S FLG=1 Q
 Q FLG
 ;I RESULT["NEG" Q 1 ; Negative
 ;Q 0
 ;
PPDPOS(RESULT) ; EP - If the result is positive return a 1 else return a 0.
 ;                    This change is specific to PPD.
 S RESULT=$$UP^XLFSTR(RESULT)
 I RESULT="P" Q 1 ; Positive
 I RESULT="R" Q 1 ; Reactive
 I RESULT="WR" Q 1 ; Weakly Reactive
 I RESULT="REACTIVE" Q 1 ; Reactive
 I RESULT="WEAKLY REACTIVE" Q 1 ; Weakly Reactive
 I RESULT="+" Q 1 ; Positive
 I RESULT?.N,RESULT>4 Q 1 ; Positive numeric result
 ; Result field contains a word that starts with "POS" or "pos"
 N FLG,I
 S FLG=0
 I $E(RESULT,1,3)="POS" S FLG=1 Q FLG
 F I=1:1:$L(RESULT) I $E(RESULT,I)?1P,$E(RESULT,I+1,I+3)="POS" S FLG=1 Q
 Q FLG
 ;
PPDNEG(RESULT) ; EP - If the result is negative return a 1 else return a 0.
 ;                    This change is specific to PPD.
 ;I $E(RESULT,1)="-" Q 1
 ; **NOTE: Documentation does not specify if "<" is considered negative.
 S RESULT=$$UP^XLFSTR(RESULT)
 I RESULT="N" Q 1 ; Negative (or Non-Reactive)
 I RESULT="NR" Q 1 ; Non-Reactive
 I RESULT="NON-REACTIVE" Q 1 ; Non-Reactive
 I RESULT="NON REACTIVE" Q 1 ; Non-Reactive
 I RESULT="NONREACTIVE" Q 1 ; Non-Reactive
 I RESULT="-" Q 1 ; Negative
 I RESULT?1.N,RESULT<5 Q 1 ; Negative numeric result
 ; Result field contains a word that starts with "NEG" or "neg"
 N FLG,I
 S FLG=0
 I $E(RESULT,1,3)="NEG" S FLG=1 Q FLG
 F I=1:1:$L(RESULT) I $E(RESULT,I)?1P,$E(RESULT,I+1,I+3)="NEG" S FLG=1 Q
 Q FLG
 ; 
ADDLINE(REM,ARRAY,TEXT,LAST,DUE,LASTTXT) ; EP - Update reminder output array
 S ARRAY(REM)=$G(ARRAY(REM))+1
 S ARRAY(REM,ARRAY(REM),0)=$G(TEXT)
 S ARRAY(REM,ARRAY(REM),"LAST")=$G(LAST)
 S ARRAY(REM,ARRAY(REM),"DUE")=$G(DUE)
 S ARRAY(REM,ARRAY(REM),"LASTTXT")=$G(LASTTXT)
 Q
 ;
 ; Check for any positive STD tests (other than the one specified in STD) after LDATE.
 ; Check for any STD diagnoses  (other than the one specified in STD) after LDATE.
 ; Valid values for STD are "CHLAMYDIA", "GONORRHEA", "SYPHILIS", "TRICHOMONIASIS" and "OTHER".
 ; NOTE: "TRICHOMONIASIS" and "OTHER" are not likely to be used but are maintained for consistency.
STDS(DFN,STD,LDATE) ;EP
 NEW PDATE,PRCTEST,PRCDT,PRC,DDATE,LDATE1
 ; Use the newer of LDATE or report date minus 365 days.
 I $G(BDATE)="" S BDATE=DT
 S LDATE1=$$FMADD^XLFDT(BDATE,-365)
 I LDATE>LDATE1 S LDATE1=LDATE
 S LDATE1=LDATE1\1_".2400" ;Start search on the next day
 ; Chlamydia (T.3)
 I STD'="CHLAMYDIA" D LABCODES(DFN,"BGP CHLAMYDIA TESTS TAX","BGP CHLAMYDIA LOINC CODES","BGP CHLAMYDIA CPTS","BGP CHLAMYDIA TEST PROCEDURES",LDATE1,"","","",.PDATE) I PDATE'="" Q 1
 ; Gonorrhea (T.10)
 I STD'="GONORRHEA" D LABCODES(DFN,"BKM GONORRHEA TEST TAX","BKM GONORRHEA LOINC CODES","BKM GONORRHEA TESTS CPTS","",LDATE1,"","","",.PDATE) I PDATE'="" Q 1
 ; Syphilis (T.22)
 I STD'="SYPHILIS" D LABCODES(DFN,"BKM RPR TAX","BKM RPR LOINC CODES","BKM RPR CPTS","",LDATE1,"","","",.PDATE) I PDATE'="" Q 1
 ; Syphilis (T.9)
 I STD'="SYPHILIS" D LABCODES(DFN,"BKM FTA-ABS TEST TAX","BKM FTA-ABS LOINC CODES","BKM FTA-ABS CPTS","",LDATE1,"","","",.PDATE) I PDATE'="" Q 1
 ;PRXM/HC/BHS - 04/19/2006 - Removed per IHS Issue # 1467
 ; Trichomoniasis (T.24)
 ;I STD'="TRICHOMONIASIS" D LABCODES(DFN,"BKM TRICH TESTS TAX","BKM TRICH LOINC CODES","","BKM TRICHOMONIASIS DXS",LDATE1,"","","",.PDATE) I PDATE'="" Q 1
 ;PRXM/HC/KJH - 04/19/2006 - Removed per IHS Issue # 1460, 1464, 1465 and replaced with other POV diagnosis checks below.
 ; Other STD (DX.9)
 ;I STD'="OTHER" D LABCODES(DFN,"","","","BKM OTHER STD DXS",LDATE1,"","","",.PDATE) I PDATE'="" Q 1
 ; Chlamydia (DX.2)
 I STD'="CHLAMYDIA" D ICDTAX^BKMIXX1(DFN,"BKM CHLAMYDIA DXS","",LDATE1,"",.DDATE) I DDATE'="" Q 1
 ; Gonorrhea (DX.4)
 I STD'="GONORRHEA" D ICDTAX^BKMIXX1(DFN,"BKM GONORRHEA DXS","",LDATE1,"",.DDATE) I DDATE'="" Q 1
 ; Syphilis (DX.11)
 I STD'="SYPHILIS" D ICDTAX^BKMIXX1(DFN,"BKM SYPHILIS DXS","",LDATE1,"",.DDATE) I DDATE'="" Q 1
 ; Trichomoniasis (DX.13)
 I STD'="TRICHOMONIASIS" D ICDTAX^BKMIXX1(DFN,"BKM TRICHOMONIASIS DXS","",LDATE1,"",.DDATE) I DDATE'="" Q 1
 ; Other STD (DX.9)
 I STD'="OTHER" D ICDTAX^BKMIXX1(DFN,"BKM OTHER STD DXS","",LDATE1,"",.DDATE) I DDATE'="" Q 1
 Q 0
 ;
 ; This function cycles through the V-Lab file checking
 ; each lab, CPT4, ICD9, and LOINC associated with a DFN to
 ; see if each is in an appropriate taxonomy, old enough,
 ; and if required positive.
 ;
 ; DFN is the patient DFN from file 2 or 9000001.
 ;
 ; LABT is the text name of the lab taxonomy.
 ; LOINCT is the text name of the LOINC taxonomy.
 ; CPTT is the text name of the CPT taxonomy.
 ; ICDT is the text name of the ICD9 taxonomy.
 ;
 ; BDATE is the base (starting) date for the search.
 ;
 ; IDATE is the date of the last item (LAB, LOINC, CPT, or ICD) passed by reference.
 ;
 ; LDATE is the date of the last LAB passed by reference.
 ; LR if there is a LDATE then the LR will be equal to the result.
 ; LV if there is a LDATE then the LV is the V Lab IEN.
 ;
 ; PDATE is the date of the last positive LAB passed by reference.
 ; PR if there is a PDATE then the PR will be equal to the positive result.
 ; PV if there is a PDATE then the PV is the V Lab IEN.
 ;
 ; NDATE is the date of the last negative LAB passed by reference.
 ; NR if there is a NDATE then the NR will be equal to the negative result.
 ; NV if there is a NDATE then the NV is the V Lab IEN.
 ;
LABCODES(DFN,LABT,LOINCT,CPTT,ICDT,BDATE,IDATE,LDATE,LR,PDATE,PR,NDATE,NR,ODATE,OR,OFLG) ;EP
 ; EP - Retrieve lab codes.
 N QDATE,QV,LV,TARGET,LABTEST,LAB,LABDT,RESULT
 S LABT=$G(LABT,""),LOINCT=$G(LOINCT,""),CPTT=$G(CPTT,""),ICDT=$G(ICDT,""),OFLG=$G(OFLG,"")
 S BDATE=$G(BDATE,""),IDATE=$G(IDATE,""),LDATE=$G(LDATE,""),PDATE=$G(PDATE,""),NDATE=$G(NDATE,""),ODATE=$G(ODATE,"")
 S (LV,LR,PR,NR,OR)=""
 S TARGET="LABTEST(VSTDT,TEST)"
 S QDATE="",QV=""
 D LABTAX^BKMIXX(DFN,LABT,"",BDATE,TARGET,.QDATE,.QV)
 S IDATE=QDATE,LDATE=QDATE,LV=QV
 S QDATE="",QV=""
 D LOINC^BKMIXX(DFN,LOINCT,"",BDATE,TARGET,.QDATE,.QV)
 I QDATE>IDATE S IDATE=QDATE,LDATE=QDATE,LV=QV
 S QDATE="",QV=""
 D CPTTAX^BKMIXX(DFN,CPTT,"",BDATE,TARGET,.QDATE,.QV)
 I QDATE>IDATE S IDATE=QDATE,LDATE=QDATE,LV=QV
 S QDATE="",QV=""
 D ICDTAX^BKMIXX1(DFN,ICDT,"",BDATE,TARGET,.QDATE,.QV)
 I QDATE>IDATE S IDATE=QDATE,LDATE=QDATE,LV=QV
 I LV'="" S LR=LABTEST(LDATE,LV)
 S LABDT=""
 F  S LABDT=$O(LABTEST(LABDT),-1) Q:LABDT=""  D  I PDATE]"",NDATE]"" Q
 . S LAB=""
 . F  S LAB=$O(LABTEST(LABDT,LAB),-1) Q:LAB=""  D  I PDATE]"",NDATE]"" Q
 . . S RESULT=$P(LABTEST(LABDT,LAB),U)
 . . I PDATE="",$$POSITIVE^BKMVF32(RESULT) S PDATE=LABDT,PR=RESULT
 . . I NDATE="",$$NEGATIVE^BKMVF32(RESULT) S NDATE=LABDT,NR=RESULT
 . . I ODATE="",OFLG'="",@OFLG S ODATE=LABDT,OR=RESULT
 . . Q
 . Q
 Q
