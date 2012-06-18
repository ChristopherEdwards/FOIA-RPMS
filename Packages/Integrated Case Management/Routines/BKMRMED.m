BKMRMED ;PRXM/HC/ALA-HMS Education Reminders ; 13 Nov 2007  4:03 PM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
ED01(GUI) ;EP - REM.ED.01
 ; Safe Sex Education Due
 ; Numerator: All patients, ages 13 and older.
 ; Due date = Today, if patients have not had Safe Sex Education (ED.3) ever documented. OR
 ; Due date = Last documented education date + 183 days (or 6 months)
 ; If "Now," then text = "Safe Sex Education may be due now; last documented [date]."
 NEW LAST,DUE,LIST
 S GUI=$G(GUI,0)
 S (LAST,DUE)=""
 I APCHSAGE'<13 D
 . D PTEDTAX^BKMIXX1(DFN,"BKM SAFE SEX ED CODES","","","",.LAST)
 . I LAST'="" S DUE=+$$SCH^XLFDT("6M",LAST)
 . I LAST="" S DUE=DT
 D ADDLINE^BKMVF32("31 REM.ED.01",.LIST,"Safe Sex Educ",LAST,DUE)
 D WRITE("31 REM.ED.01",GUI)
 Q
 ;
ED02(GUI) ;EP - REM.ED.02
 ; Family Planning Education Due
 ; Numerator: All female patients, ages 13 - 44 and all male patients ages 13 and older.
 ; Due date = Today, if patients have not had Family Planning Education (ED.1) ever documented. OR
 ; Due date = Last documented education date + 183 days (or 6 months)
 ; If "Now," then text = "Family Planning Education may be due now; last documented [date]."
 NEW LAST,DUE,LAST1,LIST
 S GUI=$G(GUI,0)
 S (LAST,DUE,LAST1)=""
 I (APCHSEX="F"&(APCHSAGE'<13)&(APCHSAGE'>44))!(APCHSEX="M"&(APCHSAGE'<13)) D
 . D PTEDTAX^BKMIXX(DFN,"FP-","","","",.LAST)
 . D ICDTAX^BKMIXX1(DFN,"BKM FAMILY PLANNING POV","","","",.LAST1)
 . S LAST=$S(LAST>LAST1:LAST,1:LAST1)
 . I LAST'="" S DUE=+$$SCH^XLFDT("6M",LAST)
 . I LAST="" S DUE=DT
 D ADDLINE^BKMVF32("32 REM.ED.02",.LIST,"Family Planning Educ",LAST,DUE)
 D WRITE("32 REM.ED.02",GUI)
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
