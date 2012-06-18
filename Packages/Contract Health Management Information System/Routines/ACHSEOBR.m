ACHSEOBR ;IHS/SET/GTH - EOBR RECORD FORMATS ; [ 12/06/2002  10:36 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**5**;JUN 11, 2001
 ;IHS/SET/GTH ACHS*3.1*5 12/06/2002 - New routine.
 ;
 ;;EXPLANATION OF BENEFITS RECORDS LAYOUTS
 ;;----------- -- -------- ------- -------
 ;;
 ;;                  ( ALL RECORDS ARE 80 CHARACTERS )
 ;;
 ;;  Pieces of information identifying the claim, Purchase Order,
 ;;  CHECK, PATIENT, AUTHORIZING FACILITY, PROVIDER, ETC., ARE ON
 ;;  RECORD FORMATS A-E.
 ;;
 ;;  FILLER ADDED AS NEEDED.
 ;;
 ;;  DETAIL RECORDS ARE ON FORMAT F & G.  THERE ARE A POSSIBLE 999
 ;;  LINES OF DETAIL PROCESSED UNDER A CLAIM CONTROL NUMBER (CCN).
 ;;  IF A CLAIM HAS MORE THAN 999 LINES OF DETAIL, IT IS SPLIT USING
 ;;  A "7" IN THE SIXTH POSITION OF THE CCN WHERE A "0" NORMALLY
 ;;  APPEARS.  IT WOULD BE TRANSMITTED AS A SEPARATE EOBR.  EACH
 ;;  LINE HAS A NUMBER WHICH APPEARS ON FORMAT F FIELD 7.  CLAIMS
 ;;  ARE SPLIT FOR OTHER REASONS ALSO (MATERNITY CLAIMS WHERE THE
 ;;  BILL INCLUDES CHARGES FOR MOM AND BABY, PROFESSIONAL FEES
 ;;  BILLED ON A UB-82, BILLING CYCLE UB-82 WITH A PATIENT DISCHARGE
 ;;  OF 30).  THE MULTIPLE CLAIM INDICATOR IS NOT SENT ON THE EOBR.
 ;;  HOWEVER, ANY CLAIM WITH A CCN THAT HAS A "7" IN THE SIXTH POSITION
 ;;  IS A SPLIT CLAIM.  THESE MAY NEED TO BE HANDLED IN SOME UNIQUE
 ;;  WAY BY IHS TO POST THE PAYMENT TO THE CHS/MIS SYSTEM AND UPDATE
 ;;  THE COMMITMENT REGISTER RECOGNIZING ANOTHER PAYMENT FOR THAT
 ;;  PURCHASE ORDER NUMBER WILL BE FORTHCOMING.
 ;;
 ;;  ANOTHER KEY ELEMENT MIGHT BE THE INTERIM/FINAL DESIGNATION WHICH
 ;;  APPEARS ON FORMAT C FIELD 13.  THE FI'S SYSTEM IDENTIFIES THE
 ;;  SPLIT CLAIMS AND SENDS THE EOBR AND PAYMENT DHR AS AN INTERIM
 ;;  UNLESS IT IS THE LAST CLAIM PROCESSED WITH THAT PURCHASE ORDER
 ;;  NUMBER WHICH BECOMES THE FINAL, AND CLOSES THE SHR424 OBLIGATION.
 ;;  AN INTERIM DECREASES THE OBLIGATION AMOUNT BUT DOES NOT CLOSE IT.
 ;;  EOBR AND DHR FOR BLANKET PURCHASE ORDERS ARE ALWAYS REPORTED AS
 ;;  INTERIM PAYMENTS.
 ;;
 ;;     A - HEADING
 ;;     B - HEADING
 ;;     C - HEADING
 ;;     D - HEADING
 ;;     E - HEADING
 ;;     F - DETAIL
 ;;     G - PROCEDURE CODES
 ;;     H - SUMMARY
 ;;
 ;;                      A - HEADING
 ;;
 ;;   NUM NAME               PIC   COMMENTS                LOC
 ;;   --- ------------------ ----- ----------------------- -----
 ;;    01 AREA OFFICE        X(02) MUST BE A VALID AREA    01-02
 ;;    02 SERVICE UNIT       X(02)                         03-04
 ;;    03 FACILITY NUMBER    X(02)                         05-06
 ;;    04 FISCAL YEAR        X(02)                         07-08
 ;;    05 CLAIM NUMBER       9(10) 2ND PART OF CONTROL NBR 09-18
 ;;    06 RECORD TYPE        X(01) ALWAYS 'A'              19-19
 ;;    07 SEQUENCE NUMBER    9(03) ALWAYS 001              20-22
 ;;    08 CLAIM SEQUENCE CNT 9(09) A COUNT ON 2ND LINE OF  23-31
 ;;                                REPORT
 ;;    09 CHECK NUMBER       9(07)                         32-38
 ;;    10 REMITTANCE NBR     9(07)                         39-45
 ;;    11 PAID DATE          X(08) FORMAT CCYYMMDD         46-53
 ;;    12 PURCHASE ORDER NBR X(12) FORMAT XX-XXX-XXXXX     54-65
 ;;    13 CERTIFICATE NBR    X(07) 1ST PART OF CONTROL NBR 66-72
 ;;    14 FACILITY CODE      X(06)                         73-78
 ;;    15 DOCUMENTATION TYPE X(02)                         79-80
 ;;
 ;;                      B - HEADING
 ;;
 ;;   NUM NAME               PIC   COMMENTS                LOC
 ;;   --- ------------------ ----- ----------------------- -----
 ;;    01 AREA OFFICE        X(02) MUST BE A VALID AREA    01-02
 ;;    02 SERVICE UNIT       X(02)                         03-04
 ;;    03 FACILITY NUMBER    X(02)                         05-06
 ;;    04 FISCAL YEAR        X(02)                         07-08
 ;;    05 CLAIM NUMBER       9(10)                         09-18
 ;;    06 RECORD TYPE        X(01) ALWAYS 'B'              19-19
 ;;    07 SEQUENCE NUMBER    9(03) ALWAYS 001              20-22
 ;;    08 PATIENT NAME       X(30)                         23-52
 ;;    09 HEALTH RECORD NBR  X(07)                         53-59
 ;;    10 AUTHORIZATION DATE X(08) FORMAT CCYYMMDD         60-67
 ;;    11 ACTUAL DAYS        9(02) INPATIENT DAYS          68-69
 ;;    12 DRG                9(03)                         70-72
 ;;    13 DISCHARGE STATUS   X(02)                         73-74
 ;;    14 SERVICE CLASS CODE X(04)                         75-78
 ;;    15 FILLER             X(02)                         79-80
 ;;
 ;;
 ;;                      C - HEADING
 ;;
 ;;   NUM NAME               PIC   COMMENTS                LOC
 ;;   --- ------------------ ----- ----------------------- -----
 ;;    01 AREA OFFICE        X(02) MUST BE A VALID AREA    01-02
 ;;    02 SERVICE UNIT       X(02)                         03-04
 ;;    03 FACILITY NUMBER    X(02)                         05-06
 ;;    04 FISCAL YEAR        X(02)                         07-08
 ;;    05 CLAIM NUMBER       9(10)                         09-18
 ;;    06 RECORD TYPE        X(01) ALWAYS 'C'              19-19
 ;;    07 SEQUENCE NUMBER    9(03) 001 OR 002              20-22
 ;; For 001:
 ;;    08 COMMON ACCT NBR    X(16)                         23-38
 ;;    09 OBJECT CLASS CODE  X(04)                         39-42
 ;;    10 SERVICES BILLED    X(01) A = PROF B = INPATIENT  43-43
 ;;                                C = OUTPAT D = DENTAL
 ;;    11 BLANKET INDICATOR  X(01) Y = YES, ELSE NO        44-44
 ;;    12 CONTRACT NUMBER    X(10)                         45-54
 ;;    13 INTERIM/FINAL IND  X(01) F = FINAL  I = INTERIM  55-55
 ;;    16 VENDOR NUMBER      X(13) PROVIDER ID - SUFFIX    56-68
 ;;       FILLER                                           69-80
 ;; For 002:
 ;;    14 SERVICE START DATE X(08) FORMAT CCYYMMDD         23-30
 ;;    15 SERVICE END DATE   X(08) FORMAT CCYYMMDD         31-38
 ;;
 ;;                      D - HEADING
 ;;
 ;;   NUM NAME               PIC   COMMENTS                LOC
 ;;   --- ------------------ ----- ----------------------- -----
 ;;    01 AREA OFFICE        X(02) MUST BE A VALID AREA    01-02
 ;;    02 SERVICE UNIT       X(02)                         03-04
 ;;    03 FACILITY NUMBER    X(02)                         05-06
 ;;    04 FISCAL YEAR        X(02)                         07-08
 ;;    05 CLAIM NUMBER       9(10)                         09-18
 ;;    06 RECORD TYPE        X(01) ALWAYS 'D'              19-19
 ;;    07 SEQUENCE NUMBER    9(03) ALWAYS 001              20-22
 ;;    08 VENDOR NAME        X(30)                         23-52
 ;;    09 BILLED BY PROVIDER S9(07)V99 FIELD WILL CONTAIN  53-61
 ;;                                    ALL '*' IF IT IS NOT
 ;;                                    APPLICABLE
 ;;    10 ALLOWABLE AMOUNT   S9(07)V99                     62-70
 ;;    11 PAID BY 3RD PARTY  S9(07)V99                     71-79
 ;;    12 FILLER             X(01)                         80-80
 ;;
 ;;                      E - HEADING
 ;;
 ;;   NUM NAME               PIC   COMMENTS                LOC
 ;;   --- ------------------ ----- ----------------------- -----
 ;;    01 AREA OFFICE        X(02) MUST BE A VALID AREA    01-02
 ;;    02 SERVICE UNIT       X(02)                         03-04
 ;;    03 FACILITY NUMBER    X(02)                         05-06
 ;;    04 FISCAL YEAR        X(02)                         07-08
 ;;    05 CLAIM NUMBER       9(10)                         09-18
 ;;    06 RECORD TYPE        X(01) ALWAYS 'E'              19-19
 ;;    07 SEQUENCE NUMBER    9(03) ALWAYS 001              20-22
 ;;    08 IHS COST           S9(07)V99                     23-31
 ;;    09 OBLIGATION IND     X(01) 1=P.O. NBR, 2=SHR 424   32-32
 ;;    10 OBLIGATION AMOUNT  S9(07)V99 FIELD WILL CONTAIN  33-41
 ;;                                    ALL '*' IF IT IS NOT
 ;;                                    APPLICABLE
 ;;    11 ADJUSTMENT AMOUNT  S9(07)V99 FIELD WILL CONTAIN  42-50
 ;;                                    ALL '*' IF IT IS NOT
 ;;                                    APPLICABLE
 ;;    12 DIAGNOSIS CODE 1   X(05)                         51-55
 ;;    13 DIAGNOSIS CODE 2   X(05)                         56-60
 ;;    14 DIAGNOSIS CODE 3   X(05)                         61-65
 ;;    15 DIAGNOSIS CODE 4   X(05)                         66-70
 ;;    16 DIAGNOSIS CODE 5   X(05)                         71-75
 ;;    17 FILLER             X(05)                         76-80
 ;;
 ;;                      F - DETAIL
 ;;
 ;;   NUM NAME               PIC   COMMENTS                LOC
 ;;   --- ------------------ ----- ----------------------- -----
 ;;    01 AREA OFFICE        X(02) MUST BE A VALID AREA    01-02
 ;;    02 SERVICE UNIT       X(02)                         03-04
 ;;    03 FACILITY NUMBER    X(02)                         05-06
 ;;    04 FISCAL YEAR        X(02)                         07-08
 ;;    05 CLAIM NUMBER       9(10)                         09-18
 ;;    06 RECORD TYPE        X(01) ALWAYS 'F'              19-19
 ;;    07 SEQUENCE NUMBER    9(03) FROM 001 TO 999         20-22
 ;;    08 FROM DATE OF SVC   X(08) FORMAT CCYYMMDD         23-30
 ;;    09 TO DATE OF SVC     X(09) FORMAT CCYYMMDD         31-38
 ;;    10 PROCEDURE CODE     X(05)                         39-43
 ;;    11 UNITS BILLED       9(03)                         44-46
 ;;    12 BILLED CHARGES     S9(07)V99                     47-55
 ;;    13 ALLOWABLE CHARGES  S9(07)V99                     56-64
 ;;    14 MESSAGE            X(04)                         65-68
 ;;    15 TOOTH NUMBER       X(02)                         69-70
 ;;    16 TOOTH SURFACE      X(05)                         71-75
 ;;    17 FILLER             X(05)                         76-80
 ;;
 ;;                      G - PROCEDURES
 ;;
 ;;   NUM NAME               PIC   COMMENTS                LOC
 ;;   --- ------------------ ----- ----------------------- -----
 ;;    01 AREA OFFICE        X(02) MUST BE A VALID AREA    01-02
 ;;    02 SERVICE UNIT       X(02)                         03-04
 ;;    03 FACILITY NUMBER    X(02)                         05-06
 ;;    04 FISCAL YEAR        X(02)                         07-08
 ;;    05 CLAIM NUMBER       9(10)                         09-18
 ;;    06 RECORD TYPE        X(01) ALWAYS 'G'              19-19
 ;;    07 SEQUENCE NUMBER    9(03) ALWAYS 001              20-22
 ;;    08 PROCEDURE CODE 1   9(04)                         23-26
 ;;    09 PROCEDURE CODE 2   9(04)                         27-30
 ;;    10 PROCEDURE CODE 3   9(04)                         31-34
 ;;    11 FILLER             X(46)                         35-80
 ;;
 ;;               I - INTEREST INFORMATION FOR A GIVEN CLAIM
 ;;
 ;;   NUM NAME               PIC   COMMENTS                LOC
 ;;   --- ------------------ ----- ----------------------- -----
 ;;    01 AREA OFFICE        X(02) MUST BE A VALID AREA    01-02
 ;;    02 SERVICE UNIT       X(02)                         03-04
 ;;    03 FACILITY NUMBER    X(02)                         05-06
 ;;    04 FISCAL YEAR        X(02)                         07-08
 ;;    05 CLAIM NUMBER       9(10)                         09-18
 ;;    06 RECORD TYPE        X(01) ALWAYS 'I'              19-19
 ;;    07 SEQUENCE NUMBER    9(03) ALWAYS 001              20-22
 ;;    08 INTEREST CAN       X(07)                         23-29
 ;;    09 INTEREST OCC       X(04)                         30-33
 ;;    10 INTEREST RATE      S9(02)V999                    34-38
 ;;    11 DAYS ELIGIBLE      9(03)                         39-41
 ;;    12 INTEREST PAID      S9(07)V99                     42-50
 ;;    13 ADD'L PENALTY PAID S9(04)V99                     51-56
 ;;    14 TOT PD THIS CLAIM  S9(08)V99                     57-66
 ;;    15 FILLER             X(14)                         67-80
 ;;
 ;;                      H - SUMMARY
 ;;
 ;;   NUM NAME               PIC   COMMENTS                LOC
 ;;   --- ------------------ ----- ----------------------- -----
 ;;    01 AREA OFFICE        X(02) MUST BE A VALID AREA    01-02
 ;;    02 SERVICE UNIT       X(02)                         03-04
 ;;    03 FACILITY NUMBER    X(02)                         05-06
 ;;    04 FISCAL YEAR        X(02)                         07-08
 ;;    05 CLAIM NUMBER       9(10)                         09-18
 ;;    06 RECORD TYPE        X(01) ALWAYS 'H'              19-19
 ;;    07 SEQUENCE NUMBER    9(03) 001 OR 002              20-22
 ;; For 001:
 ;;    08 FACILITY CODE      X(06)                         23-28
 ;;    11 TYPE 43 CLAIMS     9(05)                         41-45
 ;;    12 TYPE 57 CLAIMS     9(05)                         46-50
 ;;    13 TYPE 64 CLAIMS     9(05)                         51-55
 ;;    14 TOTAL OF PAYMENTS  S9(07)V99                     56-65
 ;;    16 # OF OCC4319 PYMTS 9(05)                         66-70
 ;;    15 TOT INT/LATE PEN   S9(08)V99                     71-80
 ;; For 002:
 ;;    09 PERIOD FROM DATE   X(08) FORMAT CCYYMMDD         23-30
 ;;    10 PERIOD TO DATE     X(08) FORMAT CCYYMMDD         31-38
 ;;
 ; 
