BKMRMIM ;PRXM/HC/ALA-HMS Immunization Reminders ; 13 Nov 2007  4:05 PM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
IZ01(GUI) ;EP - REM.IZ.01
 ; Pneumovax Due
 ; Due date = Today, if no Pneumovax vaccine (IZ.6) ever documented. OR
 ; Due date = Date of most recent Pneumovax vaccine + 1825 days or 5 years or 60 months).
 ; If "Now," then text = "Pneumovax immunization may be due now; last documented [date]."  
 NEW LAST,DUE,LAST1,LIST
 S GUI=$G(GUI,0)
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
 D WRITE("25 REM.IZ.01",GUI)
 Q
 ;
IZ02(GUI) ;EP - REM.IZ.02
 ; Influenza IZ Due
 ; Due date = Today, if no Influenza vaccine (IZ.5) ever documented. OR
 ; Due date = Date of most recent Influenza vaccine + 365 days (or 12 months)
 ; If "Now," then text = "Influenza immunization may be due now; last documented [date]."  
 NEW LAST,DUE,LAST1,LIST
 S GUI=$G(GUI,0)
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
 D WRITE("26 REM.IZ.02",GUI)
 Q
 ;
IZ03(GUI) ;EP - REM.IZ.03
 ; Hepatitis A IZ Due
 ; Due date = Today, if no Hepatitis A diagnosis (DX.5) POV or Problem list ever documented. OR
 ; Due date = Today, if no Hepatitis A immunization (IZ.3) ever documented.                   
 ; If "Now," then text = "Hepatitis A immunization may be due now.  This patient has no documentation of either immunization for or diagnosis of Hepatitis A, and is considered at risk." 
 NEW LASTTXT,LAST,DUE,LAST1,LIST
 S GUI=$G(GUI,0)
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
 D WRITE("24 REM.IZ.03",GUI)
 Q
 ;
IZ04(GUI) ;EP - REM.IZ.04
 ; Hepatitis B IZ Due
 ; Due date = Today, if no Hepatitis B diagnosis (DX.15) POV or Problem list ever documented.
 ; Due date = Today, if no Hepatitis B immunization (IZ.4) ever documented.                   
 ; If "Now," then text = "Hepatitis B immunization may be due now.  This patient has no documentation of either immunization for or diagnosis of Hepatitis B and is considered at risk."  
 NEW LAST,DUE,LAST1,LASTTXT,LIST
 S GUI=$G(GUI,0)
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
 D WRITE("23 REM.IZ.04",GUI)
 Q
 ;
IZ05(GUI) ;EP - REM.IZ.05
 ; Tetanus IZ Due
 ; Due date = Today, if no Tetanus immunization (IZ.7) ever documented.
 ; Due date = Date of most recent Tetanus immunization + 3650 days or 10 years or 120 months). 
 ; If "Now," then text = "Tetanus immunization may be due now; last documented [date]." 
 NEW LAST,DUE,LAST1,LIST
 S GUI=$G(GUI,0)
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
 D WRITE("27 REM.IZ.05",GUI)
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
