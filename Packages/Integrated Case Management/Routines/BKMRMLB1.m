BKMRMLB1 ;PRXM/HC/ALA-HMS Lab Reminders continued ; 13 Nov 2007  4:32 PM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
TOX(GUI) ;EP - REM.T.11
 ; Toxoplasmosis
 ; Numerator: All patients with no history of positive Toxoplasmosis test (T.28)
 ; Due date = Today, if no Toxoplasmosis test (T.28) ever documented. OR                  
 ; Due date = Date of most recent Toxoplasmosis test + 365 days (or 12 months).
 ; If "Now," then text = "A Toxoplasmosis test may be due now; last documented [date]."
 NEW LAST,DUE,PDATE,BDATE
 S (LAST,DUE,PDATE)=""
 I $G(BDATE)="" S BDATE=DT
 D LABCODES^BKMVF32(DFN,"BKM TOXOPLASMOSIS TESTS TAX","BKM TOXOPLASMOSIS LOINC CODES","BKM TOXOPLASMOSIS CPTS","","",.LAST,"","",.PDATE)
 I PDATE="" D
 . I LAST="" S DUE=BDATE Q
 . I LAST'="" S DUE=+$$SCH^XLFDT("12M",LAST)
 I PDATE'="" S LAST=""
 D ADDLINE^BKMVF32("18 REM.T.11",.LIST,"Toxoplasmosis Test",LAST,DUE)
 D WRITE("18 REM.T.11",GUI)
 Q
 ;
VIR(GUI) ; REM.T.02
 ; Viral Load Due
 ; Due date = Today, if no Viral Load Test (T.26) ever documented.  OR
 ; Due date = Most recent Viral Load Test + 120 days (or 4 months).
 ; If "Now," then text = "A Viral Load test may be due now; last documented [date]."
 NEW LAST,DUE,BDATE
 S (LAST,DUE)=""
 I $G(BDATE)="" S BDATE=DT
 D LABCODES^BKMVF32(DFN,"BGP HIV VIRAL LOAD TAX","BGP VIRAL LOAD LOINC CODES","BGP HIV VIRAL LOAD CPTS","","",.LAST)
 I LAST="" S DUE=BDATE
 I LAST'="" D
 . S DUE=+$$SCH^XLFDT("4M",LAST)
 D ADDLINE^BKMVF32("10 REM.T.02",.LIST,"Viral Load",LAST,DUE)
 D WRITE("10 REM.T.02",GUI)
 Q
 ;
SYPR(GUI) ;EP - REM.T.03
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
 NEW LAST,DUE,LAST1,LAST2,MLAST,DIFF,PDATE,BDATE
 S (LAST,DUE,LAST1,LAST2,MLAST,DIFF,PDATE)=""
 I $G(BDATE)="" S BDATE=DT
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
 D WRITE("12 REM.T.03",GUI)
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
