ACHSTX7D ;IHS/SET/GTH - RECORD 7(638 STATISTICAL DATA FOR NPIRS) FORMAT ; [ 09/20/2004  10:32 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**5,11**;JUN 11, 2001
 ;IHS/SET/GTH ACHS*3.1*5 12/06/2002 - New Routine.
 ;ITSC/SET/JVK ACHS*3.1*11 9/20/2004
 ;This routine format has changed considerably.  See the manual update
 ;for exact record layout.
 ;
 ;;Record 7A - 638 STATISTICAL RECORDS FOR NPIRS.
 ;;Routine:  ACHSTX7
 ;;
 ;;   POSIT  LENGTH  VAR       NAME                         JUSTIFY
 ;;   -----  ------  --------  --------------------------   -------
 ;;    1- 2       2  constant  7A                           -
 ;;    3- 9       7            PO NUMBER                    -
 ;;   10-15       6            FACILITY CODE                -
 ;;   16-24       9            SSN                          -
 ;;   25-30       6            DOB (MMDDYY)                 -
 ;;      31       1            SEX                          -
 ;;   32-34       3            TRIBE                        -
 ;;   35-37       3            blanks                       -
 ;;   38-40       3            COMMUNITY                    -
 ;;   41-42       2            COUNTY                       -
 ;;   43-44       2            STATE                        -
 ;;   45-46       2            AREA CODE                    -
 ;;   47-48       2            SERVICE UNIT CODE            -
 ;;   49-50       2            FACILITY CODE                -
 ;;   51-52       2            PROVIDER TYPE                -
 ;;   53-62      10            EIN                          -
 ;;         IF INPATIENT (43):
 ;;   63-68       6            ADMISSION DATE (MMDDYY)      -
 ;;   69-74       6            DISCHARGE DATE (MMDDYY)      -
 ;;   75-77       3            LENGTH OF STAY               -
 ;;      78       1            DISPOSITION                  -
 ;;   79-80       2            DX 1                         -
 ;;         IF OUTPATIENT (64):
 ;;   63-69       7            HOSP AUTH NUMBER             -
 ;;   70-75       6            DATE OF SERVICE (MMDDYY)     -
 ;;      76       1            I/P OR O/P INDICATOR         -
 ;;   77-79       3            DX 1                         -
 ;;      80       1            FIRST/REVISIT                -
 ;;
 ;;Record 7B - 638 STATISTICAL RECORDS FOR NPIRS.
 ;;Routine:  ACHSTX7
 ;;
 ;;   POSIT  LENGTH  VAR       NAME                         JUSTIFY
 ;;   -----  ------  --------  --------------------------   -------
 ;;             IF INPATIENT (43):
 ;;    1- 2                    7B                           -
 ;;       3       1            blank
 ;;    4- 8       5            DX 2                         -
 ;;    9-13       5            DX 3                         -
 ;;   14-18       5            DX 4                         -
 ;;   19-23       5            DX 5                         -
 ;;   24-27       4            OPER/PROCEDURE 1             -
 ;;   28-31       4            blanks                       -
 ;;   32-35       4            OPER/PROCEDURE 2             -
 ;;   36-39       4            OPER/PROCEDURE 3             -
 ;;   40-44       5            NEWBORN DX                   -
 ;;      45       1            NEWBORN D/H                  -
 ;;   46-49       4            ATTENDING PHYSICIAN CODE     -
 ;;   50-55                    INJURY
 ;;   50-53       4            ICD9 CAUSE E-CODE            -
 ;;   54-55       2            PLACE                        -
 ;;   56-63       8            CHARGES                      R
 ;;      64       1            FULL/PART PAY                -
 ;;   65-80      16            blanks                       -
 ;;             IF OUTPATIENT (64):
 ;;    1- 2                    7B                           -
 ;;    3- 5       3            DX 2                         -
 ;;       6       1            FIRST/REVISIT                -
 ;;    7- 8       2            NUMBER OF VISITS             R
 ;;    9-14       6            AMOUNT                       R
 ;;   15-24                    IMMUNIZATIONS
 ;;   15-16       2            1ST                          -
 ;;   17-18       2            2ND                          -
 ;;   19-20       2            3RD                          -
 ;;   21-22       2            4TH                          -
 ;;   23-24       2            5TH                          -
 ;;   25-27                    MATERNAL HEALTH
 ;;   25-26       2            GRAVIDA                      -
 ;;      27       1            TRIMESTER                    -
 ;;      28       1            FULL/PARTIAL PAY             -
 ;;   29-32       4            SURGICAL PROCEDURE           -
 ;;   33-80      48            blanks
 ;
 ;;The following is the format contained in the Federal Register of
 ;;Thursday, January 20, 1994.  It is the final format of data at
 ;;NPIRS, not that expected to be exported from 638 facilities by
 ;;the CHS s/w.  The export format follows this format.
 ;;
 ;;   POSIT  LENGTH       NAME                            JUSTIFY
 ;;   -----  ------       ------------------------------  -------
 ;;       1       1       TYPE OF PATIENT (I=Indian; O=Non-Indian)
 ;;       2       1       TYPE OF PROGRAM (D=Direct; K=Contract)
 ;;     3-4       2       AREA
 ;;    5-16      12       DENTIST ID (SSN)                L
 ;;   17-18       2       SERVICE UNIT CODE
 ;;   19-20       2       FACILITY CODE
 ;;   21-26       6       DATE OF VISIT (YYMMDD)
 ;;   27-29       3       PT AGE IN YEARS (3-digit numeric)
 ;;   30-35       6       DOB (YYMMDD)
 ;;      36       1       SEX (M=Male; F=Female)
 ;;   37-39       3       blanks
 ;;   40-48       9       SSN (Patient)
 ;;   49-53       5       PATIENT ZIP CODE (Numeric)
 ;;   54-57       4       PATIENT ZIP EXTENSION (Numeric)
 ;;      58       1       MEDICAID ELIGIBLE (Y or blank)
 ;;      59       1       COMMERCE ELIGIBLE (Y or blank)
 ;;      60       1       PRIVATE ELIGIBLE (Y or blank)
 ;;   61-67       7       CHARGE FOR VISIT ($$$$$cc) (Numeric)
 ;;  Services (can have 15).  If more than 15 ADA procedure codes are
 ;;  associated with a visit date, then a separate (second) input record
 ;;  must be created for processing purposes.
 ;;   68-71       4       ADA PROCEDURE CODE
 ;;   72-73       2       UNITS (Numeric, 1 to 99)
 ;;   74-78       5       FEE (Dollar amount only, cents not allowed)
 ;;       .
 ;;       .
 ;;       .
 ;;  Service # 15
 ;;  222-225      4       ADA PROCEDURE CODE
 ;;  226-227      2       UNITS
 ;;  228-232      5       FEE
 ;;
 ;;Records 7A/7B/7C - 638 DENTAL RECORD FOR NPIRS.
 ;;Routines: ACHSTX7, ACHSTX7A
 ;;
 ;;   POSIT  LENGTH       NAME                            JUSTIFY
 ;;   -----  ------       ------------------------------  -------
 ;;     1-2       2       25
 ;;     3-4       2       AREA CODE
 ;;     5-6       2       SERVICE UNIT CODE
 ;;     7-8       2       FACILITY CODE
 ;;    9-17       9       DENTIST SSN
 ;;      18       1       PATIENT SEX (M or F)
 ;;   19-26       8       PATIENT DATE OF BIRTH (CCMMDDYY)
 ;;   27-35       9       PATIENT I.D. NUMBER (SSN)
 ;;   36-95      60       ADA CODES (ADA code or blanks)
 ;;                               15 fields, 4 bytes each
 ;;   96-102      5       TOTAL FEE CHARGED
 ;;  103-108      6       DATE OF VISIT (MMDDYY)
 ;;  109-140     32       blanks
 ;;  141-142      2       AGE
 ;;  143-202     60       ADA Amounts (15 fields, 4 bytes each)
 ;;
 ;; Which translates into the four records exported:
 ;;Record #1:
 ;;Name           posit  Length  Data
 ;;Record Number   1-2     2      DO
 ;;Record Code     3-4     2      25
 ;;ASUFAC          5-10    6
 ;;Vendor SSN      11-19   9
 ;;Sex             20      1      Patient sex
 ;;Patient DOB     21-28   8      Patient Date of Birth
 ;;Patient SSN     29-37   9      Patient SSN
 ;;ADA string      38-80  43      ada code or blank
 ;;
 ;;Record # 2:
 ;;Name           posit  Length  Data
 ;;Record Number   1-2     2      D2
 ;;ADA string (con't)3-1917ada code's or blanks
 ;;Fee             20-267total amount charged
 ;;Date of Service 27-348date of visit
 ;;blanks          35-6632
 ;;Age             67-682Patient Age
 ;;ADA Units string69-8012
 ;;
 ;;Record # 3:
 ;;Name           posit  Length  Data
 ;;Record Number1-22D3
 ;;ADA Units string (con't)3-5048
 ;;
 ;;
 ;;Record #4: (this record should only be present if a Unique Registration ID is being sent with this data)
 ;;Name           posit  Length  Data
 ;;Record Number1-22D4
 ;;Unique ID3-1816
