BKM100P2 ;PRXM/HC/ALA-BKM 1.00 Patch 2 ; 08 Mar 2007  6:12 PM
 ;;2.0;HIV MANAGEMENT SYSTEM;;May 29, 2009
 ;
EN ;
 ;
 ; Set up new taxonomies for STI and updates
 D ^BKMETX
 ;
LTAX ;  Add Lab Taxonomies to ^ATXLAB
 NEW X,DIC,DLAYGO,DA,DR,DIE,Y,LTAX
 S DIC="^ATXLAB(",DIC(0)="L",DLAYGO=9002228
 ; Loop through the Taxonomies as stored in routine BKMVTAX4.
 D LDLAB(.LTAX)
 F BJ=1:1 Q:'$D(LTAX(BJ))  S X=LTAX(BJ) D
 . I $D(^ATXLAB("B",X)) Q  ; Skip pre-existing Lab taxonomies
 . D ^DIC S DA=+Y
 . I DA<1 Q
 . S BQTXUP(9002228,DA_",",.02)=$P(X," ",2,999)
 . S BQTXUP(9002228,DA_",",.05)=DUZ
 . S BQTXUP(9002228,DA_",",.06)=DT
 . S BQTXUP(9002228,DA_",",.09)=60
 . D FILE^DIE("I","BQTXUP")
 . S BQTXUP(9002228,DA_",",.08)="B"
 . D FILE^DIE("E","BQTXUP")
 ;
 K DA,BJ,BQTXUP
 ;
 ;  Set up the HMS Reminders as inactive in the standard Health
 ;  Summary Maintenance Items file #9001018 (APCHSURV)
 ;NEW BKMDATA,BKMI,BKMJ,BKMD,PRGM
 ;F BKMI=1:1:13 S BKMDATA=$P($T(REM+BKMI),";;",2) D
 ;. NEW X,DIC,DA,BKMUPD,Y
 ;. S X=$P(BKMDATA,"|",1)
 ;. S DIC="^APCHSURV(",DIC(0)="LZ" D ^DIC
 ;. ; If this is not a new entry, quit
 ;. I $P(Y,U,3)'=1 Q
 ;. S DA=+Y
 ;. S BKMUPD(9001018,DA_",",.03)="INACTIVE (OFF)"
 ;. S BKMUPD(9001018,DA_",",.05)="HIV"
 ;. S BKMUPD(9001018,DA_",",.06)="YES"
 ;. S PRGM=$P(BKMDATA,"|",2),PRGM=$TR(PRGM,"~",";")
 ;. S BKMUPD(9001018,DA_",",1)=PRGM
 ;. D FILE^DIE("E","BKMUPD","ERROR")
 ;. F BKMJ=1:1 S BKMD=$T(@BKMI+BKMJ) Q:BKMD[" Q"  S BKWP(BKMJ)=$P(BKMD,";;",2)
 ;. D WP^DIE(9001018,DA_",",2,"","BKWP","ERROR")
 ;. K BKWP
 ;
 ; Load HMS Supplement in ^APCHSUP
 ;
 ;NEW BKMDATA,BKMI,BKMJ,BKMD
 ;F BKMI=1 S BKMDATA=$P($T(SUP+BKMI),";;",2) D
 ;. NEW X,DIC,DA,BKMUPD,Y
 ;. S X=$P(BKMDATA,"|",1)
 ;. S DIC="^APCHSUP(",DIC(0)="LZ" D ^DIC
 ;. ; If this is not a new entry, quit
 ;. I $P(Y,U,3)'=1 Q
 ;. S DA=+Y
 ;. S BKMUPD(9001022,DA_",",1100)=$P(BKMDATA,"|",2)
 ;. D FILE^DIE("E","BKMUPD","ERROR")
 ;. F BKMJ=1:1 S BKMD=$T(@("S"_BKMI)+BKMJ) Q:BKMD[" Q"  S BKWP(BKMJ)=$P(BKMD,";;",2)
 ;. D WP^DIE(9001022,DA_",",1200,"","BKWP","ERROR")
 ;. K BKWP
 Q
 ;
PRE ;  Preinstall
 NEW DA,DIK
 S DIK="^BKM(90454,"
 S DA=0
 F  S DA=$O(^BKM(90454,DA)) Q:'DA  D ^DIK
 Q
 ;
REM ;
 ;;SAFE SEX EDUCATION|ED01~BKMVF33
 ;;FAMILY PLANNING EDUCATION|ED02~BKMVF33
 ;;HMS PNEUMOVAX|IZ01~BKMVF33
 ;;HMS INFLUENZA|IZ02~BKMVF33
 ;;HEPATITIS A|IZ03~BKMVF33
 ;;HEPATITIS B|IZ04~BKMVF33
 ;;TETANUS|IZ05~BKMVF33
 ;;EYE EXAM|EX01~BKMVF33
 ;;DENTAL EXAM|EX02~BKMVF33
 ;;HMS MAMMOGRAM|WMH~BKMVF33
 ;;CD4|TST01~BKMVF33
 ;;CHLAMYDIA|TST02~BKMVF33
 ;;SYPHILIS|TST03~BKMVF33
 Q
 ;
1 ;;
 ;;Numerator: All patients, ages 13 and older.
 ;; Due date = Today, if patients have not had Safe Sex Education (ED.3)
 ;;ever documented.
 ;;   OR
 ;; Due date = Last documented education date + 183 days (or 6 months)
 Q
2 ;;
 ;;Numerator: All patients, ages 13 and older.
 ;;Due date = Today, if patients have not had Safe Sex Education
 ;;(ED.3) ever
 ;;documented.
 ;;OR
 ;;Due date = Last documented education date + 183 days (or 6 months)
 Q
3 ;;
 ;;Due date = Today, if no Pneumovax vaccine (IZ.6) ever 
 ;;documented.
 ;;OR
 ;;Due date = Date of most recent Pneumovax vaccine + 1825 days 
 ;;or 5 years
 ;;or 60 months).
 Q
4 ;;
 ;;Due date = Today, if no Influenza vaccine (IZ.5) ever documented.
 ;;OR
 ;;Due date = Date of most recent Influenza vaccine + 365 days (or 
 ;;12 months)
 Q
5 ;;
 ;;Due date = Today, if no Hepatitis A diagnosis (DX.5) POV or 
 ;;Problem list ever documented.
 ;;OR
 ;;Due date = Today, if no Hepatitis A immunization (IZ.3) ever documented.
 Q
6 ;;
 ;;Due date = Today, if no Hepatitis B diagnosis (DX.15) POV or
 ;;Problem list ever documented.
 ;;OR
 ;;Due date = Today, if no Hepatitis B immunization (IZ.4) ever documented.
 Q
7 ;;
 ;;Due date = Today, if no Tetanus immunization (IZ.7) ever documented.
 ;;OR
 ;;Due date = Date of most recent Tetanus immunization + 3650 days or 10 years or 120 months).
 Q
8 ;;
 ;;Due date = Today, if no dilated eye exam (P.03) ever documented.
 ;;Due date = Date of most recent dilated eye exam + 183 days (or 6 months)
 ;;           if any CD4 Absolute laboratory test (T.30) since most recent
 ;;           dilated eye exam is < 50.
 ;;Due date = Date of most recent dilated eye exam + 365 days (or 12 months).
 Q
9 ;;
 ;;Due date = Today, if no dental exam (P.02) ever documented.
 ;;Due date = Date of most recent dental exam + 365 days (or 12 months)
 Q
10 ;;
 ;;Numerator: All female patients ages 50-69 without documented bilateral
 ;;mastectomy (P.01)
 ;; 
 ;;Due date = Today, if no Mammogram (P.05) ever documented.
 ;;Due date = Date of most mammogram + 365 days (or 12 months).
 Q
11 ;;
 ;;Due date = Today, if no CD4 test (T.2) documented ever.
 ;;Due date = Date of most recent CD4 test + 120 days (or 4 months).
 Q
12 ;;
 ;;Numerator: All patients 18 years of age and older
 ;;Due date = Today, if no Chlamydia test (T.3) ever documented
 ;;OR
 ;;Due date = Today, if most recent test results for any of the following
 ;;are positive
 ;;   since the most recent Chlamydia test and =<365 days from today:
 ;;   Gonorrhea (T.10); Syphilis (T.22) or (T.9).
 ;;OR
 ;;Due date = Today, if patient has any of the following POV diagnoses
 ;;   since the most recent Chlamydia test and =<365 days from today:
 ;;   Gonorrhea (DX.4), Syphilis (DX.11), Trichomoniasis (DX.13) or other
 ;;STD (DX.9)
 ;;OR
 ;;Due date = Date of most recent positive Chlamydia test + 56 days (for
 ;;retest after cure)
 ;;OR
 ;;Due date = Date of most recent Chlamydia test + 365 days (or 12 months).
 Q
13 ;;
 ;;Numerator:  Patients with a positive RPR laboratory value (T.22) (defined
 ;;as positive, reactive, indeterminate or any number values) and no FTA-ABS
 ;;(T.9) documented after the date of the positive RPR
 ;; 
 ;;Due date = Date of the most recent positive RPR laboratory test + 14 days.
 Q
 ;
SUP ; Load HMS Supplement in ^APCHSUP
 ;;HMS PATIENT CARE SUPPLEMENT|D EP^BKMVSUP(APCHSPAT)
 Q
 ;
S1 ;;
 ;;The HMS Supplement has been designed to display information
 ;;specifically related to HIV.  You will be able to see, at a glance, the
 ;;relevant labs, related diagnoses, medications and reminders.
 Q
 ;
LDLAB(ARRAY) ;EP - Load site-populated Lab tests
 NEW I,TEXT
 F I=1:1 S TEXT=$P($T(LAB+I),";;",2) Q:TEXT=""  S ARRAY(I)=TEXT
 Q
 ;
LAB ;EP - LAB TESTS (SITE-POPULATED)
 ;;BGP CHLAMYDIA TESTS TAX
 ;;BGP HIV TEST TAX
 ;;BKM GONORRHEA TEST TAX
 ;;BKM HEP B TAX
 ;;BKM FTA-ABS TEST TAX
 ;;BKM RPR TAX
 ;;
