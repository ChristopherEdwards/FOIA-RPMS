BKMIMRP1 ;PRXM/HC/BWF - BKMV UTILITY PROGRAM; [ 1/19/2005  7:16 PM ]
 ;;2.2;HIV MANAGEMENT SYSTEM;;Apr 01, 2015;Build 40
 Q
 ; 
AGE(DFN) ;EP - PATIENT AGE
 ; Extrinsic Age function
 ; Input = DFN - IEN of patient
 N DOB,DATE,AGE,TDATE
 S DOB=$$GET1^DIQ(2,DFN_",",.03,"I","","")
 ;PRXM/HC/DLS 9/21/2005 Added TDATE variable for configuring age
 ; based on today (if still living) or DOD (Date of Death), if applicable.
 S TDATE=$$GET1^DIQ(2,DFN,".351","I")
 I 'TDATE S TDATE=DT
 S DATE=$E(TDATE,1,3)
 S AGE=DATE-$E(DOB,1,3)
 S:$E(TDATE,4,7)<$E(DOB,4,7) AGE=AGE-1
 I AGE<3 D
 .S DAYS=$$FMDIFF^XLFDT(TDATE,DOB,1)
 .I DAYS<7 S AGE=DAYS_"d" Q
 .I DAYS<30 S AGE=DAYS\7_"w" Q
 .S AGE=DAYS\30_"m"
 Q AGE
 ;
HDR(HEADER,PAGE) ; EP - Print page number and center data.
 ; Input - HEADER: Header text (required)
 ;- PAGE (optional)
 ; This will print a page number on the header line.
 ; This utility will look at the screen width chosen by the user, and
 ; center the data on the screen.
 ; Note: you must first call ^%ZIS to get the parameters.
 I '$D(PAGE) S PAGE=""
 S LEN=$L(HEADER)
 S CENTER=LEN/2,CLINE=IOM/2
 S START=$P(CLINE-CENTER,".",1)
 I (PAGE'="") W ?START,HEADER,?68,"Page: ",PAGE,! Q
 I PAGE="" W ?START,HEADER,!
 Q
 ;
HDR3 ; EP - Print a dashed line.
 ; This utility will write a screen-width wide line of dashes (stored in IOM).
 ; Note: you must first call ^%ZIS to get the parameters.
 W ?1 F I=1:1:(IOM-2) W "-"
 W !?1
 Q
