BKMVF33 ;PRXM/HC/ALA-HMS Reminders ; 05 Mar 2007  4:07 PM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
ED01 ;EP - REM.ED.01
 ; Safe Sex Education Due
 ; Numerator: All patients, ages 13 and older.
 ; Due date = Today, if patients have not had Safe Sex Education (ED.3) ever documented. OR
 ; Due date = Last documented education date + 183 days (or 6 months)
 ; If "Now," then text = "Safe Sex Education may be due now; last documented [date]."
 NEW LAST,DUE,LIST
 S (LAST,DUE)=""
 I APCHSAGE'<13 D
 . D PTEDTAX^BKMIXX1(DFN,"BKM SAFE SEX ED CODES","","","",.LAST)
 . I LAST'="" S DUE=+$$SCH^XLFDT("6M",LAST)
 . I LAST="" S DUE=DT
 D ADDLINE^BKMVF32("31 REM.ED.01",.LIST,"Safe Sex Educ",LAST,DUE)
 D WRITE("31 REM.ED.01")
 Q
 ;
ED02 ;EP - REM.ED.02
 ; Family Planning Education Due
 ; Numerator: All female patients, ages 13 - 44 and all male patients ages 13 and older.
 ; Due date = Today, if patients have not had Family Planning Education (ED.1) ever documented. OR
 ; Due date = Last documented education date + 183 days (or 6 months)
 ; If "Now," then text = "Family Planning Education may be due now; last documented [date]."
 NEW LAST,DUE,LAST1,LIST
 S (LAST,DUE,LAST1)=""
 I (APCHSEX="F"&(APCHSAGE'<13)&(APCHSAGE'>44))!(APCHSEX="M"&(APCHSAGE'<13)) D
 . D PTEDTAX^BKMIXX(DFN,"FP-","","","",.LAST)
 . D ICDTAX^BKMIXX1(DFN,"BKM FAMILY PLANNING POV","","","",.LAST1)
 . S LAST=$S(LAST>LAST1:LAST,1:LAST1)
 . I LAST'="" S DUE=+$$SCH^XLFDT("6M",LAST)
 . I LAST="" S DUE=DT
 D ADDLINE^BKMVF32("32 REM.ED.02",.LIST,"Family Planning Educ",LAST,DUE)
 D WRITE("32 REM.ED.02")
 Q
 ;
IZ01 ;EP - REM.IZ.01
 ; Pneumovax Due
 ; Due date = Today, if no Pneumovax vaccine (IZ.6) ever documented. OR
 ; Due date = Date of most recent Pneumovax vaccine + 1825 days or 5 years or 60 months).
 ; If "Now," then text = "Pneumovax immunization may be due now; last documented [date]."  
 NEW LAST,DUE,LAST1,LIST
 S (LAST,DUE,LAST1)=""
 D CVXTAX^BKMIXX1(DFN,"BKM PNEUMO IZ CVX CODES","","","",.LAST)
 D ICDTAX^BKMIXX1(DFN,"BGP PNEUMO IZ DXS","","","",.LAST1)
 S LAST=$S(LAST>LAST1:LAST,1:LAST1)
 D CPTTAX^BKMIXX(DFN,"BGP PNEUMO IZ CPTS","","","",.LAST1)
 S LAST=$S(LAST>LAST1:LAST,1:LAST1)
 D PRCTAX^BKMIXX1(DFN,"BGP PNEUMO IZ PROCEDURES","","","",.LAST1)
 S LAST=$S(LAST>LAST1:LAST,1:LAST1)
 I LAST'="" S DUE=+$$SCH^XLFDT("60M",LAST)
 I LAST="" S DUE=DT
 D ADDLINE^BKMVF32("25 REM.IZ.01",.LIST,"Pneumovax IZ",LAST,DUE)
 D WRITE("25 REM.IZ.01")
 Q
 ;
IZ02 ;EP - REM.IZ.02
 ; Influenza IZ Due
 ; Due date = Today, if no Influenza vaccine (IZ.5) ever documented. OR
 ; Due date = Date of most recent Influenza vaccine + 365 days (or 12 months)
 ; If "Now," then text = "Influenza immunization may be due now; last documented [date]."  
 NEW LAST,DUE,LAST1,LIST
 S (LAST,DUE,LAST1)=""
 D CVXTAX^BKMIXX1(DFN,"BGP FLU IZ CVX CODES","","","",.LAST)
 D ICDTAX^BKMIXX1(DFN,"BGP FLU IZ DXS","","","",.LAST1)
 S LAST=$S(LAST>LAST1:LAST,1:LAST1)
 D CPTTAX^BKMIXX(DFN,"BGP CPT FLU","","","",.LAST1)
 S LAST=$S(LAST>LAST1:LAST,1:LAST1)
 D PRCTAX^BKMIXX1(DFN,"BGP FLU IZ PROCEDURES","","","",.LAST1)
 S LAST=$S(LAST>LAST1:LAST,1:LAST1)
 I LAST'="" S DUE=+$$SCH^XLFDT("12M",LAST)
 I LAST="" S DUE=DT
 D ADDLINE^BKMVF32("26 REM.IZ.02",.LIST,"Influenza IZ",LAST,DUE)
 D WRITE("26 REM.IZ.02")
 Q
 ;
IZ03 ;EP - REM.IZ.03
 ; Hepatitis A IZ Due
 ; Due date = Today, if no Hepatitis A diagnosis (DX.5) POV or Problem list ever documented. OR
 ; Due date = Today, if no Hepatitis A immunization (IZ.3) ever documented.                   
 ; If "Now," then text = "Hepatitis A immunization may be due now.  This patient has no documentation of either immunization for or diagnosis of Hepatitis A, and is considered at risk." 
 N LASTTXT,LAST,DUE,LAST1,LIST
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
 I LAST="" S DUE=DT
 D ADDLINE^BKMVF32("24 REM.IZ.03",.LIST,"Hep A IZ",LAST,DUE,LASTTXT)
 D WRITE("24 REM.IZ.03")
 Q
 ;
IZ04 ;EP - REM.IZ.04
 ; Hepatitis B IZ Due
 ; Due date = Today, if no Hepatitis B diagnosis (DX.15) POV or Problem list ever documented.
 ; Due date = Today, if no Hepatitis B immunization (IZ.4) ever documented.                   
 ; If "Now," then text = "Hepatitis B immunization may be due now.  This patient has no documentation of either immunization for or diagnosis of Hepatitis B and is considered at risk."  
 NEW LAST,DUE,LAST1,LASTTXT,LIST
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
 I LAST="" S DUE=DT
 D ADDLINE^BKMVF32("23 REM.IZ.04",.LIST,"Hep B IZ",LAST,DUE,LASTTXT)
 D WRITE("23 REM.IZ.04")
 Q
 ;
IZ05 ;EP - REM.IZ.05
 ; Tetanus IZ Due
 ; Due date = Today, if no Tetanus immunization (IZ.7) ever documented.
 ; Due date = Date of most recent Tetanus immunization + 3650 days or 10 years or 120 months). 
 ; If "Now," then text = "Tetanus immunization may be due now; last documented [date]." 
 NEW LAST,DUE,LAST1,LIST
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
 I LAST="" S DUE=DT
 D ADDLINE^BKMVF32("27 REM.IZ.05",.LIST,"Tetanus IZ",LAST,DUE)
 D WRITE("27 REM.IZ.05")
 Q
 ;
EX01 ;EP - REM.P.01
 ; Eye Exam Due
 ; Due date = Today, if no dilated eye exam (P.03) ever documented.
 ; Due date = Date of most recent dilated eye exam + 183 days (or 6 months)
 ;            if any CD4 Absolute laboratory test (T.30) since most recent
 ;            dilated eye exam is < 50.
 ; Above definition changed from CD4 (T.2) to CD4 Absolute (T.30) and from most recent to any.
 ; Due date = Date of most recent dilated eye exam + 365 days (or 12 months).
 ; If "Now," then text = "Dilated eye exam may be due now; last documented [date]."
 NEW LAST,DUE,LAST1,LRESULT,LIST,PRV,CLN,CD4
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
 I LAST=""  S DUE=DT
 D ADDLINE^BKMVF32("29 REM.P.01",.LIST,"Dilated Eye Exam",LAST,DUE)
 D WRITE("29 REM.P.01")
 Q
 ;
EX02 ;EP - REM.P.02
 ; Dental Exam Due
 ; Due date = Today, if no dental exam (P.02) ever documented.
 ; Due date = Date of most recent dental exam + 365 days (or 12 months)
 ; If "Now," then text = "Dental Exam may be due now; last documented [date]."
 NEW LAST,DUE,LAST1,LIST
 S (LAST,DUE,LAST1)=""
 D EXAMTAX^BKMIXX1(DFN,"30","","","",.LAST)
 D ADATAX^BKMIXX(DFN,"BGP DENTAL EXAM DENTAL CODE","","","",.LAST1)
 S LAST=$S(LAST>LAST1:LAST,1:LAST1)
 D ICDTAX^BKMIXX1(DFN,"BKM DENTAL EXAMINATION","","","",.LAST1)
 S LAST=$S(LAST>LAST1:LAST,1:LAST1)
 I LAST'="" S DUE=+$$SCH^XLFDT("12M",LAST)
 I LAST="" S DUE=DT
 D ADDLINE^BKMVF32("30 REM.P.02",.LIST,"Dental Exam",LAST,DUE)
 D WRITE("30 REM.P.02")
 Q
 ;
WMH ;EP - REM.P.03
 ; Mammogram Due
 ; Numerator: All female patients ages 50-69 without documented bilateral mastectomy (P.01)
 ; Due date = Today, if no Mammogram (P.05) ever documented.
 ; Due date = Date of most mammogram + 365 days (or 12 months).
 ; If "Now," then text = "Mammogram may be due now; last documented [date]."
 NEW LAST,DUE,LAST1,LIST
 S (LAST,DUE,LAST1)=""
 I APCHSEX="F",APCHSAGE'<50,APCHSAGE'>69 D
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
 . I LAST="" S DUE=DT
 D ADDLINE^BKMVF32("28 REM.P.03",.LIST,"Mammogram",LAST,DUE)
 D WRITE("28 REM.P.03")
 Q
 ;
TST01 ;EP - REM.T.01
 ; CD4 Due
 ; Due date = Today, if no CD4 test (T.2) documented ever.
 ; Due date = Date of most recent CD4 test + 120 days (or 4 months).
 ; If "Now," then text = "CD4 laboratory test may be due now; last documented [date]."
 NEW LAST,DUE,LAST1,LIST
 S (LAST,DUE,LAST1)=""
 D LABCODES^BKMVF32(DFN,"BGP CD4 TAX","BGP CD4 LOINC CODES","BGP CD4 CPTS","","",.LAST)
 D LABCODES^BKMVF32(DFN,"BKMV CD4 ABS TESTS TAX","BKMV CD4 ABS LOINC CODES","BKMV CD4 ABS CPTS","","",.LAST1)
 S LAST=$S(LAST>LAST1:LAST,1:LAST1)
 I LAST'="" S DUE=+$$SCH^XLFDT("4M",LAST)
 I LAST="" S DUE=DT
 D ADDLINE^BKMVF32("1 REM.T.01",.LIST,"CD4",LAST,DUE)
 D WRITE("1 REM.T.01")
 Q
 ;
TST02 ;EP - REM.T.07
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
 D WRITE("20 REM.T.07")
 Q
 ;
TST03 ;EP - REM.T.04
 ; FTA-ABS (Syphilis) Due 
 ; Numerator:  Patients with a positive RPR laboratory value (T.22) (defined as positive, 
 ;             reactive, indeterminate or any number values) and no FTA-ABS (T.9) documented 
 ;             after the date of the positive RPR
 ; Due date = Date of the most recent positive RPR laboratory test + 14 days.
 ; If "Now," then text = "An FTA-ABS Syphilis test is strongly recommended at this time because your patient had a positive RPR test documented on [date]."
 NEW LAST,DUE,PDATE,ODATE,LIST
 S (LAST,DUE,PDATE,ODATE)=""
 D LABCODES^BKMVF32(DFN,"BKM RPR TAX","BKM RPR LOINC CODES","BKM RPR CPTS","","","","","",.PDATE,.PR,"","",.ODATE,.OR,"$$UP^XLFSTR(RESULT)[""INDETERMINATE""!(RESULT?0.N0.1"".""1.N&(RESULT'=0))")
 S PDATE=$S(PDATE>ODATE:PDATE,1:ODATE)
 I PDATE'="" D
 . D LABCODES^BKMVF32(DFN,"BKM FTA-ABS TEST TAX","BKM FTA-ABS LOINC CODES","BKM FTA-ABS CPTS","",PDATE,"",.LAST)
 . I LAST="" S DUE=$$FMADD^XLFDT(PDATE,14)
 D ADDLINE^BKMVF32("13 REM.T.04",.LIST,"FTA/ABS Syphilis Test",LAST,DUE)
 D WRITE("13 REM.T.04")
 Q
 ;
WRITE(REM) ;  Write out the reminder
 S APCHLAST=$G(LIST(REM,1,"LAST"))
 I APCHLAST="" S APCHSTEX(1)="MAY BE DUE NOW"
 S APCHNEXT=$G(LIST(REM,1,"DUE"))
 I APCHNEXT>DT S APCHSTEX(1)=$$DATE^APCHSMU(APCHNEXT)
 I APCHNEXT'>DT S APCHSTEX(1)="MAY BE DUE NOW (WAS DUE "_$$DATE^APCHSMU(APCHNEXT)_")"
 D WRITE^APCHSMU
 K APCHLAST,APCHNEXT,APCHSTEX,LIST
 Q
