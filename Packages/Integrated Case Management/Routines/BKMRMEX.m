BKMRMEX ;PRXM/HC/ALA-HMS Exam Reminders ; 13 Nov 2007  4:02 PM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
EX01(GUI) ;EP - REM.P.01
 ; Eye Exam Due
 ; Due date = Today, if no dilated eye exam (P.03) ever documented.
 ; Due date = Date of most recent dilated eye exam + 183 days (or 6 months)
 ;            if any CD4 Absolute laboratory test (T.30) since most recent
 ;            dilated eye exam is < 50.
 ; Above definition changed from CD4 (T.2) to CD4 Absolute (T.30) and from most recent to any.
 ; Due date = Date of most recent dilated eye exam + 365 days (or 12 months).
 ; If "Now," then text = "Dilated eye exam may be due now; last documented [date]."
 NEW LAST,DUE,LAST1,LRESULT,LIST,PRV,CLN,CD4
 S GUI=$G(GUI,0)
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
 D WRITE("29 REM.P.01",GUI)
 Q
 ;
EX02(GUI) ;EP - REM.P.02
 ; Dental Exam Due
 ; Due date = Today, if no dental exam (P.02) ever documented.
 ; Due date = Date of most recent dental exam + 365 days (or 12 months)
 ; If "Now," then text = "Dental Exam may be due now; last documented [date]."
 NEW LAST,DUE,LAST1,LIST
 S GUI=$G(GUI,0)
 S (LAST,DUE,LAST1)=""
 D EXAMTAX^BKMIXX1(DFN,"30","","","",.LAST)
 D ADATAX^BKMIXX(DFN,"BGP DENTAL EXAM DENTAL CODE","","","",.LAST1)
 S LAST=$S(LAST>LAST1:LAST,1:LAST1)
 D ICDTAX^BKMIXX1(DFN,"BKM DENTAL EXAMINATION","","","",.LAST1)
 S LAST=$S(LAST>LAST1:LAST,1:LAST1)
 I LAST'="" S DUE=+$$SCH^XLFDT("12M",LAST)
 I LAST="" S DUE=DT
 D ADDLINE^BKMVF32("30 REM.P.02",.LIST,"Dental Exam",LAST,DUE)
 D WRITE("30 REM.P.02",GUI)
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
