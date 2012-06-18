BKMRMWH ;PRXM/HC/ALA-HMS Women's Health Reminders ; 13 Nov 2007  4:13 PM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
MAM(GUI) ;EP - REM.P.03
 ; Mammogram Due
 ; Numerator: All female patients ages 50-69 without documented bilateral mastectomy (P.01)
 ; Due date = Today, if no Mammogram (P.05) ever documented.
 ; Due date = Date of most mammogram + 365 days (or 12 months).
 ; If "Now," then text = "Mammogram may be due now; last documented [date]."
 NEW LAST,DUE,LAST1,LIST
 S GUI=$G(GUI,0)
 S (LAST,DUE,LAST1)=""
 S APCHSDOB=$P(^DPT(APCHSPAT,0),U,3)
 S APCHSAGE=$$AGE^BQIAGE(APCHSPAT)
 S APCHSEX=$P(^DPT(APCHSPAT,0),U,2)
 I APCHSEX="F",APCHSAGE'<50,APCHSAGE'>69 D
 . D PRCTAX^BKMIXX1(APCHSPAT,"BGP MASTECTOMY PROCEDURES","","","",.LAST)
 . ; If patient had this procedure then no need for a mammogram.
 . Q:LAST'=""
 . D ICDTAX^BKMIXX1(APCHSPAT,"BGP MAMMOGRAM ICDS","","","",.LAST)
 . D CPTTAX^BKMIXX(APCHSPAT,"BGP CPT MAMMOGRAM","","","",.LAST1)
 . S LAST=$S(LAST>LAST1:LAST,1:LAST1)
 . D RADTAX^BKMIXX1(APCHSPAT,"BGP CPT MAMMOGRAM","","","",.LAST1)
 . S LAST=$S(LAST>LAST1:LAST,1:LAST1)
 . D PRCTAX^BKMIXX1(APCHSPAT,"BGP MAMMOGRAM PROCEDURES","","","",.LAST1)
 . S LAST=$S(LAST>LAST1:LAST,1:LAST1)
 . D WHTAX^BKMIXX2(APCHSPAT,"MAMMOGRAM DX BILAT","","","",.LAST1)
 . S LAST=$S(LAST>LAST1:LAST,1:LAST1)
 . D WHTAX^BKMIXX2(APCHSPAT,"MAMMOGRAM DX UNILAT","","","",.LAST1)
 . S LAST=$S(LAST>LAST1:LAST,1:LAST1)
 . D WHTAX^BKMIXX2(APCHSPAT,"MAMMOGRAM SCREENING","","","",.LAST1)
 . S LAST=$S(LAST>LAST1:LAST,1:LAST1)
 . I LAST'="" S DUE=+$$SCH^XLFDT("12M",LAST)
 . I LAST="" S DUE=DT
 D ADDLINE^BKMVF32("28 REM.P.03",.LIST,"Mammogram",LAST,DUE)
 D WRITE("28 REM.P.03",GUI)
 Q
 ;
PAP(GUI) ;EP - REM.T.06
 ; Pap Smear Due
 ; Numerator: All female patients ages 18 through 64 (on Report end date) without documented hysterectomy (P.04)
 ; Due date = Today, if Pap smear (T.20) not ever documented. OR
 ; ** EN/KH - Next two lines conflict (<= and >=) and Eric P. agreed, go with 6/4/2004 logic (+183 days if <200, else +365)
 ; Due date = Most recent Pap smear + 183 days (or 6 months) if most recent CD4 Absolute laboratory (T.30) value is <= 200. OR
 ; Due date = Most recent Pap smear + 365 days (or 12 months) if most recent CD4 Absolute laboratory (T.30) value is >= 200.
 ; Above two lines were changed from CD4 (T.2) to CD4 Absolute (T.30)
 ; If "Now," then text = "A Pap smear may be due now; last documented [date]."
 NEW LAST,DUE,LAST1,LRESULT
 S (LAST,DUE,LAST1,LRESULT)=""
 I $G(BDATE)="" S BDATE=DT
 S APCHSDOB=$P(^DPT(APCHSPAT,0),U,3)
 S APCHSAGE=$$AGE^BQIAGE(APCHSPAT)
 S APCHSEX=$P(^DPT(APCHSPAT,0),U,2)
 I APCHSEX="F",APCHSAGE'<18,APCHSAGE'>64 D
 . D CPTTAX^BKMIXX(APCHSPAT,"BGP HYSTERECTOMY CPTS","","","",.LAST1)
 . I LAST1'="" Q
 . D PRCTAX^BKMIXX1(APCHSPAT,"BGP HYSTERECTOMY PROCEDURES","","","",.LAST1)
 . I LAST1'="" Q
 . D LABCODES^BKMVF32(APCHSPAT,"BGP PAP SMEAR TAX","BGP PAP LOINC CODES","BGP CPT PAP","BGP PAP ICDS","",.LAST)
 . D PRCTAX^BKMIXX1(APCHSPAT,"BGP PAP PROCEDURES","","","",.LAST1)
 . S LAST=$S(LAST>LAST1:LAST,1:LAST1)
 . D WHTAX^BKMIXX2(APCHSPAT,"PAP SMEAR","","","",.LAST1)
 . S LAST=$S(LAST>LAST1:LAST,1:LAST1)
 . I LAST="" S DUE=BDATE Q
 . ; Check result of CD4 T.2
 . D LABCODES^BKMVF32(APCHSPAT,"BKMV CD4 ABS TESTS TAX","BKMV CD4 ABS LOINC CODES","BKMV CD4 ABS CPTS","","","","",.LRESULT)
 . I LRESULT]"",LRESULT<200 S DUE=+$$SCH^XLFDT("6M",LAST) Q
 . S DUE=+$$SCH^XLFDT("12M",LAST)
 D ADDLINE^BKMVF32("19 REM.T.06",.LIST,"Pap Smear",LAST,DUE)
 D WRITE("19 REM.T.06",GUI)
 Q
 ;
WRITE(REM,GUI) ;  Write out the reminder
 S APCHLAST=$G(LIST(REM,1,"LAST"))
 ;I APCHLAST="" S APCHSTEX(1)="MAY BE DUE NOW"
 S APCHNEXT=$G(LIST(REM,1,"DUE"))
 I APCHNEXT'="",APCHNEXT>DT S APCHSTEX(1)=$$DATE^APCHSMU(APCHNEXT)
 I APCHNEXT'="",APCHNEXT'>DT S APCHSTEX(1)="MAY BE DUE NOW (WAS DUE "_$$DATE^APCHSMU(APCHNEXT)_")"
 I 'GUI D WRITE^APCHSMU
 I GUI S REMLAST=APCHLAST,REMNEXT=$G(APCHSTEX(1)),REMDUE=APCHNEXT
 K APCHLAST,APCHNEXT,APCHSTEX,LIST
 Q
