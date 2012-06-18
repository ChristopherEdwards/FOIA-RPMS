BKMVF31 ;PRXM/HC/JGH - Reminders From Patient Record and Menu Tree (Functions - 1); Mar 21, 2005
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 Q
 ; KJH - 04/13/2005 - Split from original routine due to size restrictions.
 ;
REMIND1 ; EP - Continue from REMIND^BKMVF3. Do not call this tag directly.
 ; REM.T.08
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
 S (LAST,DUE)=""
 I AGE'<18 D
 . D LABCODES^BKMVF32(DFN,"BKM GONORRHEA TEST TAX","BKM GONORRHEA LOINC CODES","BKM GONORRHEA TESTS CPTS","","",.LAST)
 . I LAST'="" D
 . . S DUE=+$$SCH^XLFDT("12M",LAST)
 . . ; If any STD tests (except Gonorrhea) are positive since the last Gonorrhea test (or diagnoses found)
 . . I $$STDS^BKMVF32(DFN,"GONORRHEA",LAST) S DUE=BDATE
 . I LAST="" S DUE=BDATE
 D ADDLINE^BKMVF32("21 REM.T.08",.LIST,"Gonorrhea Test",LAST,DUE)
 ;
 ; REM.T.13
 ; Hepatitis B Retest Due
 ; Numerator: All patients with 3 documented Hepatitis B immunizations (IZ.4) and no 
 ;            Hepatitis B test (T.27) documented after the final immunization
 ; Due date = Today
 ; If "Now," then text = "Hepatitis B retest may be indicated at this time to ensure adequate coverage since this patient has completed all 3 Hepatitis B immunizations; last documented immunization was given on [date]."
 S (LAST,DUE,LAST1,VISIT)="",CNT=0 K TEMP
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
 ;
 ; REM.T.12
 ; Hepatitis B Test Due
 ; Numerator: Any patient with no Hepatitis B (DX.15) diagnosis (POV or problem list) ever AND 
 ;            no Hepatitis B test results (T.27) ever documented.
 ; Due date = Today
 ; If "Now," then text = "This patient may benefit from a Hepatitis B Test."
 S (LAST,DUE)=""
 D
 . D ICDTAX^BKMIXX1(DFN,"BKM HEP B DXS","","","",.LAST)
 . I LAST'="" Q
 . D PRBTAX^BKMIXX(DFN,"BKM HEP B DXS","","","",.LAST)
 . I LAST'="" Q
 . D LABCODES^BKMVF32(DFN,"BKM HEP B TAX","BKM HEP B LOINC CODES","BKM HEP B TESTS CPTS","","",.LAST)
 . I LAST'="" Q
 . S DUE=BDATE
 D ADDLINE^BKMVF32("16 REM.T.12",.LIST,"Hep B Test",LAST,DUE)
 ;
 ; REM.T.09
 ; Hepatitis C EIA Test Due
 ; Numerator: Any patient with no Hepatitis C (DX.16) diagnosis (POV or problem list) ever documented. 
 ; Due date = Today, if no Hepatitis C EIA (T.13) or Hepatitis C RIBA (T.14) ever documented  OR
 ; Due date = if no documented Hepatitis C EIA (T.13) test but a Hepatitis C confirmation test (T.14) is documented, date of most recent confirmation test + 365 days (1 year) OR
 ; Due date = if most recent EIA test is not positive, date of most recent, not positive Hepatitis C EIA test + 365 days (or 12 months)  OR
 ; Due date = if most recent EIA test is positive followed by a negative Hepatitis C RIBA test, date of EIA test +365 days (or 12 months).
 ; If most recent EIA test is positive AND is not followed by documented Hep C confirmation test, then go to REM.T.14
 ; If "Now," then text = "This patient may be due for a Hepatitis C testing; last documented [date]."
 N SKIP ; If set to 1, skip this reminder and continue with REM.T.14
 S SKIP=""
 S (LAST,DUE,LAST1,EPDATE,ENDATE,RLAST,RNDATE)=""
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
 . I EPDATE'="",EPDATE=LAST,RNDATE'="",RNDATE>EPDATE S DUE=+$$SCH^XLFDT("12M",EPDATE)
 . I EPDATE'="",EPDATE=LAST,RNDATE'>EPDATE S SKIP=1
 I 'SKIP D ADDLINE^BKMVF32("14 REM.T.09",.LIST,"Hep C EIA Test",LAST,DUE)
 ;
 ; REM.T.14
 ; Hepatitis C RIBA Test Due
 ; Numerator: Patients with no Hepatitis C (DX.16) diagnosis (POV or problem list) and positive 
 ;            Hepatitis C EIA test (T.13) and no documented Hepatitis C RIBA test (T.14) 
 ;            occurring after EIA test date.
 ; Due date = Today
 ; If "Now," then text = "A Hepatitis C RIBA test is indicated because your patient had a positive Hepatitis C EIA test result documented on [date]."
 S (LAST,DUE,EPDATE,LAST1)=""
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
 ;
 ; REM.T.06
 ; Pap Smear Due
 ; Numerator: All female patients ages 18 through 64 (on Report end date) without documented hysterectomy (P.04)
 ; Due date = Today, if Pap smear (T.20) not ever documented. OR
 ; ** EN/KH - Next two lines conflict (<= and >=) and Eric P. agreed, go with 6/4/2004 logic (+183 days if <200, else +365)
 ; Due date = Most recent Pap smear + 183 days (or 6 months) if most recent CD4 Absolute laboratory (T.30) value is <= 200. OR
 ; Due date = Most recent Pap smear + 365 days (or 12 months) if most recent CD4 Absolute laboratory (T.30) value is >= 200.
 ; Above two lines were changed from CD4 (T.2) to CD4 Absolute (T.30)
 ; If "Now," then text = "A Pap smear may be due now; last documented [date]."
 S (LAST,DUE,LAST1,LRESULT)=""
 I SEX="F",AGE'<18,AGE'>64 D
 . D CPTTAX^BKMIXX(DFN,"BGP HYSTERECTOMY CPTS","","","",.LAST1)
 . I LAST1'="" Q
 . D PRCTAX^BKMIXX1(DFN,"BGP HYSTERECTOMY PROCEDURES","","","",.LAST1)
 . I LAST1'="" Q
 . D LABCODES^BKMVF32(DFN,"BGP PAP SMEAR TAX","BGP PAP LOINC CODES","BGP CPT PAP","BGP PAP ICDS","",.LAST)
 . D PRCTAX^BKMIXX1(DFN,"BGP PAP PROCEDURES","","","",.LAST1)
 . S LAST=$S(LAST>LAST1:LAST,1:LAST1)
 . D WHTAX^BKMIXX2(DFN,"PAP SMEAR","","","",.LAST1)
 . S LAST=$S(LAST>LAST1:LAST,1:LAST1)
 . I LAST="" S DUE=BDATE Q
 . ; Check result of CD4 T.2
 . D LABCODES^BKMVF32(DFN,"BKMV CD4 ABS TESTS TAX","BKMV CD4 ABS LOINC CODES","BKMV CD4 ABS CPTS","","","","",.LRESULT)
 . I LRESULT]"",LRESULT<200 S DUE=+$$SCH^XLFDT("6M",LAST) Q
 . S DUE=+$$SCH^XLFDT("12M",LAST)
 D ADDLINE^BKMVF32("19 REM.T.06",.LIST,"Pap Smear",LAST,DUE)
 ;
 ; REM.T.05
 ; PPD Due
 ; Numerator: Patients with:
 ;   1) No TB DX (DX.14) ever
 ;   2) No positive PPD results (T.21) ever (positive result or no result but PPD reading >=5 mm) 
 ;   3) No TB treatment (M.08) ever
 ; Due date = Today, if PPD (T.21) never documented OR
 ; Due date = Date of most recent PPD + 365 days (or 12 months)
 ; If "Now," then text = "PPD skin test may be due now; last documented [date]."
 S (LAST,DUE,LAST1,LRESULT,PR,OR)=""
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
 ;
 ; REM.T.03
 ; RPR (Syphilis) Due
 ; Due date = Today, if no RPR (T.22) or FTA-ABS (T.9) tests ever documented. OR
 ; Due date = Date of last FTA-ABS (T.9) test + 365 days (or 12 months) if no RPR (T.22) ever documented. OR
 ; Due date = RPR test date + 90 days (or 3 months)
 ;            if most recent RPR is positive and =<365 days from today. OR
 ; Due date = Today, if most recent RPR is not positive (negative or undetermined)
 ;            AND if most recent test results for any of the following are positive
 ;            since the most recent RPR test and =<365 days from today:
 ;            Gonorrhea (T.10); Chlamydia (T.3). OR
 ; Due date = Today, if most recent RPR is not positive (negative or undetermined)
 ;            AND if patient has any of the following POV diagnoses
 ;            since the most recent RPR test and =<365 days from today:
 ;            Gonorrhea (DX.4), Chlamydia (DX.2), Trichomoniasis (DX.13) or other STD (DX.9) OR
 ; Due date = Date of last RPR + 365 days (or 12 months)
 ; If "Now," then text = "An RPR Syphilis test may be due.  Please review your patient's history; last documented [date]."
 S (LAST,DUE,LAST1,LAST2,MLAST,DIFF,PDATE)=""
 D LABCODES^BKMVF32(DFN,"BKM FTA-ABS TEST TAX","BKM FTA-ABS LOINC CODES","BKM FTA-ABS CPTS","","",.LAST)
 D LABCODES^BKMVF32(DFN,"BKM RPR TAX","BKM RPR LOINC CODES","BKM RPR CPTS","","",.LAST1,"","",.PDATE)
 ; If no tests found
 I LAST="",LAST1="" S DUE=BDATE
 ; If FTA-ABS tests (but no RPR tests) found
 I LAST'="",LAST1="" S DUE=+$$SCH^XLFDT("12M",LAST)
 ; If RPR tests found
 I LAST1'=""  D
 . ; If last RPR test result was positive and within the year
 . I PDATE=LAST1,$$FMDIFF^XLFDT(BDATE,PDATE)'>365 S DUE=+$$SCH^XLFDT("3M",PDATE) Q
 . ; If last RPR test result is not positive but if any STD tests (except Syphilis) are positive (or diagnoses found)
 . I PDATE<LAST1,$$STDS^BKMVF32(DFN,"SYPHILIS",LAST1) S DUE=BDATE Q
 . ; Otherwise, due date is 12 months from last RPR test
 . S DUE=+$$SCH^XLFDT("12M",LAST1)
 D ADDLINE^BKMVF32("12 REM.T.03",.LIST,"RPR Syphilis Test",LAST1,DUE)
 ;
 ; REM.T.11
 ; Toxoplasmosis
 ; Numerator: All patients with no history of positive Toxoplasmosis test (T.28)
 ; Due date = Today, if no Toxoplasmosis test (T.28) ever documented. OR                  
 ; Due date = Date of most recent Toxoplasmosis test + 365 days (or 12 months).
 ; If "Now," then text = "A Toxoplasmosis test may be due now; last documented [date]."
 S (LAST,DUE,PDATE)=""
 D LABCODES^BKMVF32(DFN,"BKM TOXOPLASMOSIS TESTS TAX","BKM TOXOPLASMOSIS LOINC CODES","BKM TOXOPLASMOSIS CPTS","","",.LAST,"","",.PDATE)
 I PDATE="" D
 . I LAST="" S DUE=BDATE Q
 . I LAST'="" S DUE=+$$SCH^XLFDT("12M",LAST)
 I PDATE'="" S LAST=""
 D ADDLINE^BKMVF32("18 REM.T.11",.LIST,"Toxoplasmosis Test",LAST,DUE)
 ;
 ;PRXM/HC/BHS - 04/19/2006 - Removed per IHS Issue # 1467
 ; REM.T.10
 ; Trichomoniasis
 ; Due date = Today, if no Trichonomiasis test (T.24) ever documented.  OR
 ; Due date = Today, if most recent test results for any of the following are 
 ;            positive since the most recent Trichomoniasis test: Gonorrhea (T.10); 
 ;            Chlamydia (T.3); Syphilis (T.9) or (T.22) or other STD (DX.9). OR
 ; Due date = Date of most recent Trichomoniasis test + 365 days (or 12 months).
 ; If "Now," then text = "A Trichomoniasis test may be due now; last documented [date]."
 ;S (LAST,DUE)=""
 ;D LABCODES^BKMVF32(DFN,"BKM TRICH TESTS TAX","BKM TRICH LOINC CODES","","BKM TRICHOMONIASIS DXS","",.LAST)
 ;I LAST="" S DUE=BDATE
 ;I LAST'="" D
 ;. ; If any STD tests (except Trichomoniasis) are positive since the last Trichomoniasis test
 ;. I $$STDS^BKMVF32(DFN,"TRICHOMONIASIS",LAST) S DUE=BDATE Q
 ;. S DUE=+$$SCH^XLFDT("12M",LAST)
 ;D ADDLINE^BKMVF32("22 REM.T.10",.LIST,"Trichomoniasis Test",LAST,DUE)
 ;
 ; REM.T.02
 ; Viral Load Due
 ; Due date = Today, if no Viral Load Test (T.26) ever documented.  OR
 ; Due date = Most recent Viral Load Test + 120 days (or 4 months).
 ; If "Now," then text = "A Viral Load test may be due now; last documented [date]."
 S (LAST,DUE)=""
 D LABCODES^BKMVF32(DFN,"BGP HIV VIRAL LOAD TAX","BGP VIRAL LOAD LOINC CODES","BGP HIV VIRAL LOAD CPTS","","",.LAST)
 I LAST="" S DUE=BDATE
 I LAST'="" S DUE=+$$SCH^XLFDT("4M",LAST)
 D ADDLINE^BKMVF32("10 REM.T.02",.LIST,"Viral Load",LAST,DUE)
 ; Do NOT kill variable LIST. This used to build temp global for display of reminders.
 ; Also, do NOT kill variables AGE and SEX. These are killed by the calling routine.
 K BDATE,CPTNMBR,DFN,DIFF,DUE,ELAST,ENDATE,EPDATE,IMMNMBR,TEMP,CNT
 K LAST,LAST1,LAST2,MLAST,PDATE,PREADING,RLAST,RNDATE,SLAST
 K OLAST,OR,PPD,PPDTEST,LRESULT,LVISIT,TARGET,VISIT
 Q
