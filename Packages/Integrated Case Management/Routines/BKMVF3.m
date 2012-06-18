BKMVF3 ;PRXM/HC/JGH - Reminders From Patient Record and Menu Tree (Main); Mar 21, 2005 ; 24 May 2005  5:55 PM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 QUIT
 ; KJH - 04/13/2005 - Split into several routines due to size restrictions.
 ;
REMIND(DFN,BDATE,LIST) ;Reminders ; PEP
 ; PRX/DLS 3/30/06 Kill REMLIST before proceeding.
 K REMLIST
 N PNT,BKMRIEN,PTNAME,AGE,SEX
 S HIVIEN=$$HIVIEN^BKMIXX3()
 I HIVIEN="" W !,"There is no HMS register defined." H 2 Q
 ;
 ; The following line no longer applies
 ;I '$D(^BKM(90450,HIVIEN,11,"B",DUZ)) Q
 ;
 ; Get Sex and Age for Patient
 S SEX=$E($$GET1^DIQ(9000001,DFN,1101.2,"E"),1)
 S AGE=$$GET1^DIQ(9000001,DFN,1102.99,"E")
 ;
ED ; REM.ED.01
 ; Safe Sex Education Due
 ; Numerator: All patients, ages 13 and older.
 ; Due date = Today, if patients have not had Safe Sex Education (ED.3) ever documented. OR
 ; Due date = Last documented education date + 183 days (or 6 months)
 ; If "Now," then text = "Safe Sex Education may be due now; last documented [date]."
 S (LAST,DUE)=""
 I AGE'<13 D
 . D PTEDTAX^BKMIXX1(DFN,"BKM SAFE SEX ED CODES","","","",.LAST)
 . I LAST'="" S DUE=+$$SCH^XLFDT("6M",LAST)
 . I LAST="" S DUE=BDATE
 D ADDLINE^BKMVF32("31 REM.ED.01",.LIST,"Safe Sex Educ",LAST,DUE)
 ;
 ; REM.ED.02
 ; Family Planning Education Due
 ; Numerator: All female patients, ages 13 - 44 and all male patients ages 13 and older.
 ; Due date = Today, if patients have not had Family Planning Education (ED.1) ever documented. OR
 ; Due date = Last documented education date + 183 days (or 6 months)
 ; If "Now," then text = "Family Planning Education may be due now; last documented [date]."
 S (LAST,DUE,LAST1)=""
 I (SEX="F"&(AGE'<13)&(AGE'>44))!(SEX="M"&(AGE'<13)) D
 . D PTEDTAX^BKMIXX(DFN,"FP-","","","",.LAST)
 . D ICDTAX^BKMIXX1(DFN,"BKM FAMILY PLANNING POV","","","",.LAST1)
 . S LAST=$S(LAST>LAST1:LAST,1:LAST1)
 . I LAST'="" S DUE=+$$SCH^XLFDT("6M",LAST)
 . I LAST="" S DUE=BDATE
 D ADDLINE^BKMVF32("32 REM.ED.02",.LIST,"Family Planning Educ",LAST,DUE)
 ; 
IZ ; REM.IZ.01
 ; Pneumovax Due
 ; Due date = Today, if no Pneumovax vaccine (IZ.6) ever documented. OR
 ; Due date = Date of most recent Pneumovax vaccine + 1825 days or 5 years or 60 months).
 ; If "Now," then text = "Pneumovax immunization may be due now; last documented [date]."  
 S (LAST,DUE,LAST1)=""
 D CVXTAX^BKMIXX1(DFN,"BKM PNEUMO IZ CVX CODES","","","",.LAST)
 D ICDTAX^BKMIXX1(DFN,"BGP PNEUMO IZ DXS","","","",.LAST1)
 S LAST=$S(LAST>LAST1:LAST,1:LAST1)
 D CPTTAX^BKMIXX(DFN,"BGP PNEUMO IZ CPTS","","","",.LAST1)
 S LAST=$S(LAST>LAST1:LAST,1:LAST1)
 D PRCTAX^BKMIXX1(DFN,"BGP PNEUMO IZ PROCEDURES","","","",.LAST1)
 S LAST=$S(LAST>LAST1:LAST,1:LAST1)
 I LAST'="" S DUE=+$$SCH^XLFDT("60M",LAST)
 I LAST="" S DUE=BDATE
 D ADDLINE^BKMVF32("25 REM.IZ.01",.LIST,"Pneumovax IZ",LAST,DUE)
 ;
 ; REM.IZ.02
 ; Influenza IZ Due
 ; Due date = Today, if no Influenza vaccine (IZ.5) ever documented. OR
 ; Due date = Date of most recent Influenza vaccine + 365 days (or 12 months)
 ; If "Now," then text = "Influenza immunization may be due now; last documented [date]."  
 S (LAST,DUE,LAST1)=""
 D CVXTAX^BKMIXX1(DFN,"BGP FLU IZ CVX CODES","","","",.LAST)
 D ICDTAX^BKMIXX1(DFN,"BGP FLU IZ DXS","","","",.LAST1)
 S LAST=$S(LAST>LAST1:LAST,1:LAST1)
 D CPTTAX^BKMIXX(DFN,"BGP CPT FLU","","","",.LAST1)
 S LAST=$S(LAST>LAST1:LAST,1:LAST1)
 D PRCTAX^BKMIXX1(DFN,"BGP FLU IZ PROCEDURES","","","",.LAST1)
 S LAST=$S(LAST>LAST1:LAST,1:LAST1)
 I LAST'="" S DUE=+$$SCH^XLFDT("12M",LAST)
 I LAST="" S DUE=BDATE
 D ADDLINE^BKMVF32("26 REM.IZ.02",.LIST,"Influenza IZ",LAST,DUE)
 ;
 ; REM.IZ.03
 ; Hepatitis A IZ Due
 ; Due date = Today, if no Hepatitis A diagnosis (DX.5) POV or Problem list ever documented. OR
 ; Due date = Today, if no Hepatitis A immunization (IZ.3) ever documented.                   
 ; If "Now," then text = "Hepatitis A immunization may be due now.  This patient has no documentation of either immunization for or diagnosis of Hepatitis A, and is considered at risk." 
 N LASTTXT
 S (LAST,DUE,LAST1,LASTTXT)=""
 D CVXTAX^BKMIXX1(DFN,"BKM HEP A IZ CVX CODES","","","",.LAST)
 D CPTTAX^BKMIXX(DFN,"BKM HEP A IZ CPTS","","","",.LAST1)
 S LAST=$S(LAST>LAST1:LAST,1:LAST1)
 D ICDTAX^BKMIXX1(DFN,"BKM HEP A DXS","","","",.LAST1)
 I LAST1>LAST S LASTTXT=" (dx)"
 S LAST=$S(LAST>LAST1:LAST,1:LAST1)
 D PRBTAX^BKMIXX(DFN,"BKM HEP A DXS","","","",.LAST1)
 I LAST1>LAST S LASTTXT=" (dx)"
 S LAST=$S(LAST>LAST1:LAST,1:LAST1)
 I LAST="" S DUE=BDATE
 D ADDLINE^BKMVF32("24 REM.IZ.03",.LIST,"Hep A IZ",LAST,DUE,LASTTXT)
 ;
 ; REM.IZ.04
 ; Hepatitis B IZ Due
 ; Due date = Today, if no Hepatitis B diagnosis (DX.15) POV or Problem list ever documented.
 ; Due date = Today, if no Hepatitis B immunization (IZ.4) ever documented.                   
 ; If "Now," then text = "Hepatitis B immunization may be due now.  This patient has no documentation of either immunization for or diagnosis of Hepatitis B and is considered at risk."  
 S (LAST,DUE,LAST1,LASTTXT)=""
 D CVXTAX^BKMIXX1(DFN,"BKM HEP B IZ CVX CODES","","","",.LAST)
 D CPTTAX^BKMIXX(DFN,"BKM HEP B IZ CPTS","","","",.LAST1)
 S LAST=$S(LAST>LAST1:LAST,1:LAST1)
 D ICDTAX^BKMIXX1(DFN,"BKM HEP B DXS","","","",.LAST1)
 I LAST1>LAST S LASTTXT=" (dx)"
 S LAST=$S(LAST>LAST1:LAST,1:LAST1)
 D PRBTAX^BKMIXX(DFN,"BKM HEP B DXS","","","",.LAST1)
 I LAST1>LAST S LASTTXT=" (dx)"
 S LAST=$S(LAST>LAST1:LAST,1:LAST1)
 I LAST="" S DUE=BDATE
 D ADDLINE^BKMVF32("23 REM.IZ.04",.LIST,"Hep B IZ",LAST,DUE,LASTTXT)
 ;
 ; REM.IZ.05
 ; Tetanus IZ Due
 ; Due date = Today, if no Tetanus immunization (IZ.7) ever documented.
 ; Due date = Date of most recent Tetanus immunization + 3650 days or 10 years or 120 months). 
 ; If "Now," then text = "Tetanus immunization may be due now; last documented [date]." 
 S (LAST,DUE,LAST1)=""
 D CVXTAX^BKMIXX1(DFN,"BKM TETANUS IZ CVX CODES","","","",.LAST)
 D ICDTAX^BKMIXX1(DFN,"BKM TETANUS IZ DXS","","","",.LAST1)
 S LAST=$S(LAST>LAST1:LAST,1:LAST1)
 D CPTTAX^BKMIXX(DFN,"BKM TETANUS IZ CPTS","","","",.LAST1)
 S LAST=$S(LAST>LAST1:LAST,1:LAST1)
 D PRCTAX^BKMIXX1(DFN,"BKM TETANUS IZ PROCEDURES","","","",.LAST1)
 S LAST=$S(LAST>LAST1:LAST,1:LAST1)
 ; $$SCH function won't accept values greater than 99, but we need to add 120.
 I LAST'="" S DUE=+$$SCH^XLFDT("60M",LAST),DUE=+$$SCH^XLFDT("60M",DUE)
 I LAST="" S DUE=BDATE
 D ADDLINE^BKMVF32("27 REM.IZ.05",.LIST,"Tetanus IZ",LAST,DUE)
 ;
RET ; REM.P.01
 ; Eye Exam Due
 ; Due date = Today, if no dilated eye exam (P.03) ever documented.
 ; Due date = Date of most recent dilated eye exam + 183 days (or 6 months)
 ;            if any CD4 Absolute laboratory test (T.30) since most recent
 ;            dilated eye exam is < 50.
 ; Above definition changed from CD4 (T.2) to CD4 Absolute (T.30) and from most recent to any.
 ; Due date = Date of most recent dilated eye exam + 365 days (or 12 months).
 ; If "Now," then text = "Dilated eye exam may be due now; last documented [date]."
 S (LAST,DUE,LAST1,LRESULT)=""
 D EXAMTAX^BKMIXX1(DFN,"03","","","",.LAST)
 D CPTTAX^BKMIXX(DFN,"BGP EYE EXAM CPTS","","","",.LAST1)
 S LAST=$S(LAST>LAST1:LAST,1:LAST1)
 ;Check provider codes
 F PRV="79","24","08" D
 . D PRVTAX^BKMIXX2(DFN,PRV,"","","",.LAST1)
 . S LAST=$S(LAST>LAST1:LAST,1:LAST1)
 ;Check clinic codes
 F CLN="17","18","64","A2" D
 . D CLNTAX^BKMIXX2(DFN,CLN,"","","",.LAST1)
 . S LAST=$S(LAST>LAST1:LAST,1:LAST1)
 ;I LAST'="" D
 ;. D LABCODES^BKMVF32(DFN,"BKMV CD4 ABS TESTS TAX","BKMV CD4 ABS LOINC CODES","BKMV CD4 ABS CPTS","","","","",.LRESULT)
 ;. ;D LABCODES^BKMVF32(DFN,"BGP CD4 TAX","BGP CD4 LOINC CODES","BGP CD4 CPTS","","","","",.LRESULT)
 ;. I $G(LRESULT)="" S DUE=+$$SCH^XLFDT("12M",LAST) Q
 ;. I $G(LRESULT)<50 S DUE=+$$SCH^XLFDT("6M",LAST) Q
 ;. S DUE=+$$SCH^XLFDT("12M",LAST)
 I LAST'="" D
 . N GLOBAL,LABTEST,SINCE,CD4
 . S SINCE=LAST\1_".2400" ;Get tests since most recent eye exam
 . S GLOBAL="LABTEST(VSTDT,TEST,""LAB"")"
 . D LABTAX^BKMIXX(DFN,"BKMV CD4 ABS TESTS TAX","",SINCE,GLOBAL)
 . D LOINC^BKMIXX(DFN,"BKMV CD4 ABS LOINC CODES","",SINCE,GLOBAL)
 . S GLOBAL="LABTEST(VSTDT,TEST,""CPT"")"
 . D CPTTAX^BKMIXX(DFN,"BKMV CD4 ABS CPTS","",SINCE,GLOBAL)
 . S DUE=+$$SCH^XLFDT("12M",LAST)
 . S CD4="LABTEST"
 . F  S CD4=$Q(@CD4) Q:CD4=""  I $P(@CD4,U)]"",$P(@CD4,U)<50 S DUE=+$$SCH^XLFDT("6M",LAST) Q
 I LAST=""  S DUE=BDATE
 D ADDLINE^BKMVF32("29 REM.P.01",.LIST,"Dilated Eye Exam",LAST,DUE)
 ; 
 ; REM.P.02
 ; Dental Exam Due
 ; Due date = Today, if no dental exam (P.02) ever documented.
 ; Due date = Date of most recent dental exam + 365 days (or 12 months)
 ; If "Now," then text = "Dental Exam may be due now; last documented [date]."
 S (LAST,DUE,LAST1)=""
 D EXAMTAX^BKMIXX1(DFN,"30","","","",.LAST)
 D ADATAX^BKMIXX(DFN,"BGP DENTAL EXAM DENTAL CODE","","","",.LAST1)
 S LAST=$S(LAST>LAST1:LAST,1:LAST1)
 D ICDTAX^BKMIXX1(DFN,"BKM DENTAL EXAMINATION","","","",.LAST1)
 S LAST=$S(LAST>LAST1:LAST,1:LAST1)
 I LAST'="" S DUE=+$$SCH^XLFDT("12M",LAST)
 I LAST="" S DUE=BDATE
 D ADDLINE^BKMVF32("30 REM.P.02",.LIST,"Dental Exam",LAST,DUE)
 ;
WMH ; REM.P.03
 ; Mammogram Due
 ; Numerator: All female patients ages 50-69 without documented bilateral mastectomy (P.01)
 ; Due date = Today, if no Mammogram (P.05) ever documented.
 ; Due date = Date of most mammogram + 365 days (or 12 months).
 ; If "Now," then text = "Mammogram may be due now; last documented [date]."
 S (LAST,DUE,LAST1)=""
 I SEX="F",AGE'<50,AGE'>69 D
 . D PRCTAX^BKMIXX1(DFN,"BGP MASTECTOMY PROCEDURES","","","",.LAST)
 . ; If patient had this procedure then no need for a mammogram.
 . Q:LAST'=""
 . D ICDTAX^BKMIXX1(DFN,"BGP MAMMOGRAM ICDS","","","",.LAST)
 . D CPTTAX^BKMIXX(DFN,"BGP CPT MAMMOGRAM","","","",.LAST1)
 . S LAST=$S(LAST>LAST1:LAST,1:LAST1)
 . D RADTAX^BKMIXX1(DFN,"BGP CPT MAMMOGRAM","","","",.LAST1)
 . S LAST=$S(LAST>LAST1:LAST,1:LAST1)
 . D PRCTAX^BKMIXX1(DFN,"BGP MAMMOGRAM PROCEDURES","","","",.LAST1)
 . S LAST=$S(LAST>LAST1:LAST,1:LAST1)
 . D WHTAX^BKMIXX2(DFN,"MAMMOGRAM DX BILAT","","","",.LAST1)
 . S LAST=$S(LAST>LAST1:LAST,1:LAST1)
 . D WHTAX^BKMIXX2(DFN,"MAMMOGRAM DX UNILAT","","","",.LAST1)
 . S LAST=$S(LAST>LAST1:LAST,1:LAST1)
 . D WHTAX^BKMIXX2(DFN,"MAMMOGRAM SCREENING","","","",.LAST1)
 . S LAST=$S(LAST>LAST1:LAST,1:LAST1)
 . I LAST'="" S DUE=+$$SCH^XLFDT("12M",LAST)
 . I LAST="" S DUE=BDATE
 D ADDLINE^BKMVF32("28 REM.P.03",.LIST,"Mammogram",LAST,DUE)
 ; 
TST ; REM.T.01
 ; CD4 Due
 ; Due date = Today, if no CD4 test (T.2) documented ever.
 ; Due date = Date of most recent CD4 test + 120 days (or 4 months).
 ; If "Now," then text = "CD4 laboratory test may be due now; last documented [date]."
 S (LAST,DUE,LAST1)=""
 D LABCODES^BKMVF32(DFN,"BGP CD4 TAX","BGP CD4 LOINC CODES","BGP CD4 CPTS","","",.LAST)
 D LABCODES^BKMVF32(DFN,"BKMV CD4 ABS TESTS TAX","BKMV CD4 ABS LOINC CODES","BKMV CD4 ABS CPTS","","",.LAST1)
 S LAST=$S(LAST>LAST1:LAST,1:LAST1)
 I LAST'="" S DUE=+$$SCH^XLFDT("4M",LAST)
 I LAST="" S DUE=BDATE
 D ADDLINE^BKMVF32("1 REM.T.01",.LIST,"CD4",LAST,DUE)
 ;
 ; REM.T.07
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
 S (LAST,DUE,PDATE,LAST1)=""
 I AGE'<18 D
 . D LABCODES^BKMVF32(DFN,"BGP CHLAMYDIA TESTS TAX","BGP CHLAMYDIA LOINC CODES","BGP CHLAMYDIA CPTS","BGP CHLAMYDIA TEST PROCEDURES","",.LAST,"","",.PDATE)
 . I LAST'="" D
 . . S DUE=+$$SCH^XLFDT("12M",LAST)
 . . I PDATE'="" D
 . . . I PDATE'<LAST S DUE=$$FMADD^XLFDT(PDATE,56)
 . . ; If any STD tests (except Chlamydia) are positive since the last Chlamydia test (or diagnoses found)
 . . I $$STDS^BKMVF32(DFN,"CHLAMYDIA",LAST) S DUE=BDATE
 . I LAST="" S DUE=BDATE
 D ADDLINE^BKMVF32("20 REM.T.07",.LIST,"Chlamydia Test",LAST,DUE)
 ;
 ; REM.T.04
 ; FTA-ABS (Syphilis) Due 
 ; Numerator:  Patients with a positive RPR laboratory value (T.22) (defined as positive, 
 ;             reactive, indeterminate or any number values) and no FTA-ABS (T.9) documented 
 ;             after the date of the positive RPR
 ; Due date = Date of the most recent positive RPR laboratory test + 14 days.
 ; If "Now," then text = "An FTA-ABS Syphilis test is strongly recommended at this time because your patient had a positive RPR test documented on [date]."
 S (LAST,DUE,PDATE,ODATE)=""
 D LABCODES^BKMVF32(DFN,"BKM RPR TAX","BKM RPR LOINC CODES","BKM RPR CPTS","","","","","",.PDATE,.PR,"","",.ODATE,.OR,"$$UP^XLFSTR(RESULT)[""INDETERMINATE""!(RESULT?0.N0.1"".""1.N&(RESULT'=0))")
 S PDATE=$S(PDATE>ODATE:PDATE,1:ODATE)
 I PDATE'="" D
 . D LABCODES^BKMVF32(DFN,"BKM FTA-ABS TEST TAX","BKM FTA-ABS LOINC CODES","BKM FTA-ABS CPTS","",PDATE,"",.LAST)
 . I LAST="" S DUE=$$FMADD^XLFDT(PDATE,14)
 D ADDLINE^BKMVF32("13 REM.T.04",.LIST,"FTA/ABS Syphilis Test",LAST,DUE)
 D REMIND1^BKMVF31
 K DUE,HIVIEN,LAST,LAST1,LRESULT,PDATE,CLN,PRV
 Q
 ;
 ; Prompts for user from Patient Management menu option.
PREMIND ;  EP - Called from outside of patient record
 N BKMRIEN,PTNAME,PNT,RCRDHDR,HRN
 K REMLIST
 ;
 ; Check taxonomies
 NEW DFLAG
 S DFLAG=1 D EN^BKMVC1
 ;
PAT ; Select patient
 I '$$GETPAT^BKMVA1A() Q
 S HRN=$$HRN^BKMVA1(DFN)
 ; PRX/DLS 4/5/06 REM message and Call (after getting DFN).
 W !!,"Calculating Reminders.. This may take a moment."
 D REMIND^BKMVF3(DFN,DT,.REMLIST)
 S RCRDHDR=$$PAD^BKMIXX4("Patient: ",">"," ",16)_$$PAD^BKMIXX4(PNT,">"," ",34)_$$PAD^BKMIXX4("HRN: ",">"," ",16)_$$PAD^BKMIXX4(HRN,">"," ",34)
 D EN^BKMVC8
 G PAT
