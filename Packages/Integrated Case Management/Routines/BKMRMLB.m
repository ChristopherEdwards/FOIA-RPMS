BKMRMLB ;PRXM/HC/ALA-HMS Lab Reminders ; 13 Nov 2007  4:04 PM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
CD4(GUI) ;EP - REM.T.01
 ; CD4 Due
 ; Due date = Today, if no CD4 test (T.2) documented ever.
 ; Due date = Date of most recent CD4 test + 120 days (or 4 months).
 ; If "Now," then text = "CD4 laboratory test may be due now; last documented [date]."
 NEW LAST,DUE,LAST1,LIST
 S GUI=$G(GUI,0)
 S (LAST,DUE,LAST1)=""
 D LABCODES^BKMVF32(DFN,"BGP CD4 TAX","BGP CD4 LOINC CODES","BGP CD4 CPTS","","",.LAST)
 D LABCODES^BKMVF32(DFN,"BKMV CD4 ABS TESTS TAX","BKMV CD4 ABS LOINC CODES","BKMV CD4 ABS CPTS","","",.LAST1)
 S LAST=$S(LAST>LAST1:LAST,1:LAST1)
 I LAST'="" S DUE=+$$SCH^XLFDT("4M",LAST)
 I LAST="" S DUE=DT
 D ADDLINE^BKMVF32("1 REM.T.01",.LIST,"CD4",LAST,DUE)
 D WRITE("1 REM.T.01",GUI)
 Q
 ;
CHL(GUI) ;EP - REM.T.07
 ; Chlamydia Test Due
 ; Numerator: All patients 18 years of age and older
 ; Due date = Today, if no Chlamydia test (T.3) ever documented OR
 ; Due date = Today, if most recent test results for any of the following are positive
 ;            since the most recent Chlamydia test and =<365 days from today:
 ;            Gonorrhea (T.10); Syphilis (T.22) or (T.9). OR
 ; Due date = Today, if patient has any of the following POV diagnoses
 ;            since the most recent Chlamydia test and =<365 days from today:
 ;            Gonorrhea (DX.4), Syphilis (DX.11), Trichomoniasis (DX.13) or other STD (DX.9) OR
 ; Due date = Date of most recent positive Chlamydia test + 56 days (for retest after cure) OR
 ; Due date = Date of most recent Chlamydia test + 365 days (or 12 months).
 ; If "Now," then text = "Chlamydia test may be due now.  Please review your patient's recent and past history and consider ordering this test; last documented test was [date].
 ; *** What happens if a Chlamydia test is done on Monday and a Gonorrhea (etc.) is found positive on Tuesday? When should the next Chlamydia be scheduled?
 NEW LAST,DUE,PDATE,LAST1,LIST
 S GUI=$G(GUI,0)
 S (LAST,DUE,PDATE,LAST1)=""
 I APCHSAGE'<18 D
 . D LABCODES^BKMVF32(DFN,"BGP CHLAMYDIA TESTS TAX","BGP CHLAMYDIA LOINC CODES","BGP CHLAMYDIA CPTS","BGP CHLAMYDIA TEST PROCEDURES","",.LAST,"","",.PDATE)
 . I LAST'="" D
 .. S DUE=+$$SCH^XLFDT("12M",LAST)
 .. I PDATE'="" D
 ... I PDATE'<LAST S DUE=$$FMADD^XLFDT(PDATE,56)
 .. ; If any STD tests (except Chlamydia) are positive since the last Chlamydia test (or diagnoses found)
 .. I $$STDS^BKMVF32(DFN,"CHLAMYDIA",LAST) S DUE=DT
 . I LAST="" S DUE=DT
 D ADDLINE^BKMVF32("20 REM.T.07",.LIST,"Chlamydia Test",LAST,DUE)
 D WRITE("20 REM.T.07",GUI)
 Q
 ;
SYPF(GUI) ;EP - REM.T.04
 ; FTA-ABS (Syphilis) Due 
 ; Numerator:  Patients with a positive RPR laboratory value (T.22) (defined as positive, 
 ;             reactive, indeterminate or any number values) and no FTA-ABS (T.9) documented 
 ;             after the date of the positive RPR
 ; Due date = Date of the most recent positive RPR laboratory test + 14 days.
 ; If "Now," then text = "An FTA-ABS Syphilis test is strongly recommended at this time because your patient had a positive RPR test documented on [date]."
 NEW LAST,DUE,PDATE,ODATE,LIST
 S GUI=$G(GUI,0)
 S (LAST,DUE,PDATE,ODATE)=""
 D LABCODES^BKMVF32(DFN,"BKM RPR TAX","BKM RPR LOINC CODES","BKM RPR CPTS","","","","","",.PDATE,.PR,"","",.ODATE,.OR,"$$UP^XLFSTR(RESULT)[""INDETERMINATE""!(RESULT?0.N0.1"".""1.N&(RESULT'=0))")
 S PDATE=$S(PDATE>ODATE:PDATE,1:ODATE)
 I PDATE'="" D
 . D LABCODES^BKMVF32(DFN,"BKM FTA-ABS TEST TAX","BKM FTA-ABS LOINC CODES","BKM FTA-ABS CPTS","",PDATE,"",.LAST)
 . I LAST="" S DUE=$$FMADD^XLFDT(PDATE,14)
 D ADDLINE^BKMVF32("13 REM.T.04",.LIST,"FTA/ABS Syphilis Test",LAST,DUE)
 D WRITE("13 REM.T.04",GUI)
 Q
 ;
GON(GUI) ;EP - REM.T.08
 ; Gonorrhea Test Due
 ; Numerator:  All patients 18 years of age and older.
 ; Due date = Today, if no Gonorrhea test (T.10) ever documented. OR
 ; Due date = Today, if most recent test results for any of the following are positive
 ;            since the most recent Gonorrhea test and =<365 days from today:
 ;            Chlamydia (T.3); Syphilis (T.22) or (T.9). OR
 ; Due date = Today, if patient has any of the following POV diagnoses
 ;            since the most recent Gonorrhea test and =<365 days from today:
 ;            Chlamydia (DX.2), Syphilis (DX.11), Trichomoniasis (DX.13) or other STD (DX.9) OR
 ; Due date = Date of most recent Gonorrhea test + 365 days (or 12 months).
 ; If "Now," then text = "Gonorrhea test may be due now.  Please review your patient's recent and past history and consider ordering this test; last documented test was [date]."
 NEW LAST,DUE,BDATE
 S (LAST,DUE)=""
 I $G(BDATE)="" S BDATE=DT
 I APCHSAGE'<18 D
 . D LABCODES^BKMVF32(DFN,"BKM GONORRHEA TEST TAX","BKM GONORRHEA LOINC CODES","BKM GONORRHEA TESTS CPTS","","",.LAST)
 . I LAST'="" D
 . . S DUE=+$$SCH^XLFDT("12M",LAST)
 . . ; If any STD tests (except Gonorrhea) are positive since the last Gonorrhea test (or diagnoses found)
 . . I $$STDS^BKMVF32(DFN,"GONORRHEA",LAST) S DUE=BDATE
 . I LAST="" S DUE=BDATE
 D ADDLINE^BKMVF32("21 REM.T.08",.LIST,"Gonorrhea Test",LAST,DUE)
 D WRITE("21 REM.T.08",GUI)
 Q
 ;
HEPBR(GUI) ;EP - REM.T.13
 ; Hepatitis B Retest Due
 ; Numerator: All patients with 3 documented Hepatitis B immunizations (IZ.4) and no 
 ;            Hepatitis B test (T.27) documented after the final immunization
 ; Due date = Today
 ; If "Now," then text = "Hepatitis B retest may be indicated at this time to ensure adequate coverage since this patient has completed all 3 Hepatitis B immunizations; last documented immunization was given on [date]."
 NEW LAST,DUE,LAST1,VISIT,CNT,BDATE
 S (LAST,DUE,LAST1,VISIT)="",CNT=0 K TEMP
 I $G(BDATE)="" S BDATE=DT
 D CVXTAX^BKMIXX1(DFN,"BKM HEP B IZ CVX CODES","","","TEMP(VISIT)",.LAST)
 D CPTTAX^BKMIXX(DFN,"BKM HEP B IZ CPTS","","","TEMP(VISIT)",.LAST1)
 S LAST=$S(LAST>LAST1:LAST,1:LAST1)
 F  S VISIT=$O(TEMP(VISIT)) Q:'VISIT  S CNT=CNT+1
 I CNT<3 S LAST=""
 I CNT'<3 D
 . S LAST1=""
 . D LABCODES^BKMVF32(DFN,"BKM HEP B TAX","BKM HEP B LOINC CODES","BKM HEP B TESTS CPTS","",LAST,.LAST1)
 . I LAST1'="" S LAST="" Q
 . S DUE=BDATE,LAST=LAST1
 D ADDLINE^BKMVF32("17 REM.T.13",.LIST,"Hep B Retest",LAST,DUE)
 D WRITE("17 REM.T.13",GUI)
 Q
 ;
HEPB(GUI) ;EP - REM.T.12
 ; Hepatitis B Test Due
 ; Numerator: Any patient with no Hepatitis B (DX.15) diagnosis (POV or problem list) ever AND 
 ;            no Hepatitis B test results (T.27) ever documented.
 ; Due date = Today
 ; If "Now," then text = "This patient may benefit from a Hepatitis B Test."
 NEW LAST,DUE,BDATE
 S (LAST,DUE)=""
 I $G(BDATE)="" S BDATE=DT
 D
 . D ICDTAX^BKMIXX1(DFN,"BKM HEP B DXS","","","",.LAST)
 . I LAST'="" Q
 . D PRBTAX^BKMIXX(DFN,"BKM HEP B DXS","","","",.LAST)
 . I LAST'="" Q
 . D LABCODES^BKMVF32(DFN,"BKM HEP B TAX","BKM HEP B LOINC CODES","BKM HEP B TESTS CPTS","","",.LAST)
 . I LAST'="" Q
 . S DUE=BDATE
 D ADDLINE^BKMVF32("16 REM.T.12",.LIST,"Hep B Test",LAST,DUE)
 D WRITE("16 REM.T.12",GUI)
 Q
 ;
HEPCE(GUI) ;EP - REM.T.09
 ; Hepatitis C EIA Test Due
 ; Numerator: Any patient with no Hepatitis C (DX.16) diagnosis (POV or problem list) ever documented. 
 ; Due date = Today, if no Hepatitis C EIA (T.13) or Hepatitis C RIBA (T.14) ever documented  OR
 ; Due date = if no documented Hepatitis C EIA (T.13) test but a Hepatitis C confirmation test (T.14) is documented, date of most recent confirmation test + 365 days (1 year) OR
 ; Due date = if most recent EIA test is not positive, date of most recent, not positive Hepatitis C EIA test + 365 days (or 12 months)  OR
 ; Due date = if most recent EIA test is positive followed by a negative Hepatitis C RIBA test, date of EIA test +365 days (or 12 months).
 ; If most recent EIA test is positive AND is not followed by documented Hep C confirmation test, then go to REM.T.14
 ; If "Now," then text = "This patient may be due for a Hepatitis C testing; last documented [date]."
 NEW SKIP,LAST,DUE,LAST1,EPDATE,ENDATE,RLAST,RNDATE,BDATE
 ; If set to 1, skip this reminder and continue with REM.T.14
 S SKIP=""
 S (LAST,DUE,LAST1,EPDATE,ENDATE,RLAST,RNDATE)=""
 I $G(BDATE)="" S BDATE=DT
 D
 . D ICDTAX^BKMIXX1(DFN,"BKM HEP C DXS","","","",.LAST1)
 . I LAST1'="" Q
 . D PRBTAX^BKMIXX(DFN,"BKM HEP C DXS","","","",.LAST1)
 . I LAST1'="" Q
 . ; Check for T.13
 . D LABCODES^BKMVF32(DFN,"BKM HEP C SCREENING TAX","BKM HEP C SCREEN LOINC CODES","BKM HEP C SCREEN TESTS CPTS","","","",.LAST,"",.EPDATE,"",.ENDATE)
 . ; Check for T.14
 . D LABCODES^BKMVF32(DFN,"BKM HEP C CONFIRMATORY TAX","BKM HEP C CONFIRM LOINC CODES","BKM HEP C CONFIRM TESTS CPTS","","","",.RLAST,"","","",.RNDATE)
 . ; If no test found for either HEP C EIA or HEP C RIBA
 . I LAST="",RLAST="" S DUE=BDATE Q
 . I LAST="",RLAST]"" S DUE=+$$SCH^XLFDT("12M",RLAST) Q
 . I ENDATE'="",EPDATE'=LAST S DUE=+$$SCH^XLFDT("12M",LAST) Q
 . ;I ENDATE'="",EPDATE'=LAST S DUE=+$$SCH^XLFDT("12M",ENDATE) Q
 . I EPDATE'="",EPDATE=LAST,RNDATE'="",RNDATE>EPDATE S DUE=+$$SCH^XLFDT("12M",EPDATE)
 . I EPDATE'="",EPDATE=LAST,RNDATE'>EPDATE S SKIP=1
 ;. I LAST="",RLAST="" S DUE=BDATE
 ;. ELSE  D
 ;. . I ENDATE'="",ENDATE=LAST S DUE=+$$SCH^XLFDT("12M",ENDATE) Q
 ;. . I EPDATE'="",EPDATE=LAST,RNDATE'="",RNDATE>EPDATE S DUE=+$$SCH^XLFDT("12M",EPDATE)
 I 'SKIP D ADDLINE^BKMVF32("14 REM.T.09",.LIST,"Hep C EIA Test",LAST,DUE)
 D WRITE("14 REM.T.09",GUI)
 Q
 ;
HEPCR(GUI) ;EP - REM.T.14
 ; Hepatitis C RIBA Test Due
 ; Numerator: Patients with no Hepatitis C (DX.16) diagnosis (POV or problem list) and positive 
 ;            Hepatitis C EIA test (T.13) and no documented Hepatitis C RIBA test (T.14) 
 ;            occurring after EIA test date.
 ; Due date = Today
 ; If "Now," then text = "A Hepatitis C RIBA test is indicated because your patient had a positive Hepatitis C EIA test result documented on [date]."
 NEW LAST,DUE,EPDATE,LAST1,BDATE
 S (LAST,DUE,EPDATE,LAST1)=""
 I $G(BDATE)="" S BDATE=DT
 D
 . D ICDTAX^BKMIXX1(DFN,"BKM HEP C DXS","","","",.LAST1)
 . I LAST1'="" Q
 . D PRBTAX^BKMIXX(DFN,"BKM HEP C DXS","","","",.LAST1)
 . I LAST1'="" Q
 . ; Check for T.13
 . D LABCODES^BKMVF32(DFN,"BKM HEP C SCREENING TAX","BKM HEP C SCREEN LOINC CODES","BKM HEP C SCREEN TESTS CPTS","","","","","",.EPDATE)
 . I EPDATE="" Q
 . ; Check for T.14
 . D LABCODES^BKMVF32(DFN,"BKM HEP C CONFIRMATORY TAX","BKM HEP C CONFIRM LOINC CODES","BKM HEP C CONFIRM TESTS CPTS","",EPDATE,.LAST1)
 . I LAST1'="" Q
 . S DUE=BDATE
 D ADDLINE^BKMVF32("15 REM.T.14",.LIST,"Hep C Confirm",LAST,DUE)
 D WRITE("15 REM.T.14",GUI)
 Q
 ;
PPD(GUI) ;EP - REM.T.05
 ; PPD Due
 ; Numerator: Patients with:
 ;   1) No TB DX (DX.14) ever
 ;   2) No positive PPD results (T.21) ever (positive result or no result but PPD reading >=5 mm) 
 ;   3) No TB treatment (M.08) ever
 ; Due date = Today, if PPD (T.21) never documented OR
 ; Due date = Date of most recent PPD + 365 days (or 12 months)
 ; If "Now," then text = "PPD skin test may be due now; last documented [date]."
 NEW LAST,DUE,LAST1,LRESULT,PR,OR,BDATE
 S (LAST,DUE,LAST1,LRESULT,PR,OR)=""
 I $G(BDATE)="" S BDATE=DT
 D
 . D ICDTAX^BKMIXX1(DFN,"DM AUDIT PROBLEM TB DXS","","","",.LAST1)
 . I LAST1'="" Q  ; Exclude patient with a TB DX
 . D NDCTAX^BKMIXX1(DFN,"BKM TB MED NDCS","","","",.LAST1)
 . I LAST1'="" Q  ; Exclude patient with TB treatment
 . D MEDTAX^BKMIXX(DFN,"BKM TB MEDS","","","",.LAST1)
 . I LAST1'="" Q  ; Exclude patient with TB treatment
 . D LABCODES^BKMVF32(DFN,"BKM PPD TAX","BKM PPD LOINC CODES","BKM PPD CPTS","BKM PPD ICDS","","",.LAST,.LRESULT,"",.PR,"","","",.OR,"RESULT'<5")
 . I PR'=""!(OR'="") S LAST="" Q  ; Positive Result or PPD >= 5 mm
 . ; If patient had no PPD T.21 in Labs, also check Skin Tests and Immunizations.
 . K PPDTEST
 . S TARGET="PPDTEST(""SKN"",VSTDT,TEST)"
 . D SKNTAX^BKMIXX1(DFN,"21","","",TARGET,.LAST1)
 . S LAST=$S(LAST>LAST1:LAST,1:LAST1)
 . S TARGET="PPDTEST(""CVX"",VSTDT,TEST)"
 . D CVXTAX^BKMIXX1(DFN,"BKM PPD CVX CODES","","",TARGET,.LAST1)
 . S LAST=$S(LAST>LAST1:LAST,1:LAST1)
 . I LAST="" S DUE=BDATE Q  ;If never had PPD T.21
 . N PPDPOS
 . S PPD="PPDTEST",PPDPOS=""
 . F  S PPD=$Q(@PPD) Q:PPD=""  D  Q:PPDPOS
 .. ; For Skin test use result (2nd piece) if present, if not use reading (1st piece)
 .. I $P(PPD,",")="PPDTEST(""SKN""" D  Q
 ... I $P(@PPD,U,2)]"" S PPDPOS=$$POSITIVE^BKMVF32($P(@PPD,U,2)) Q
 ... I +@PPD'<5 S PPDPOS=1 Q
 .. I $$POSITIVE^BKMVF32(@PPD)!(@PPD'<5) S PPDPOS=1 Q
 . I PPDPOS S LAST="" Q  ; PPD is positive or >= 5 mm
 . S DUE=+$$SCH^XLFDT("12M",LAST)
 D ADDLINE^BKMVF32("11 REM.T.05",.LIST,"PPD Skin Test",LAST,DUE)
 D WRITE("11 REM.T.05",GUI)
 Q
 ;
WRITE(REM,GUI) ;  Write out the reminder
 S APCHLAST=$G(LIST(REM,1,"LAST"))
 I APCHLAST="" S APCHSTEX(1)="MAY BE DUE NOW"
 S APCHNEXT=$G(LIST(REM,1,"DUE"))
 I APCHNEXT>DT S APCHSTEX(1)=$$DATE^APCHSMU(APCHNEXT)
 I APCHNEXT'>DT S APCHSTEX(1)="MAY BE DUE NOW (WAS DUE "_$$DATE^APCHSMU(APCHNEXT)_")"
 I 'GUI D WRITE^APCHSMU
 I GUI S REMLAST=APCHLAST,REMNEXT=$G(APCHSTEX(1)),REMDUE=APCHNEXT
 K APCHLAST,APCHNEXT,APCHSTEX,LIST
 Q
