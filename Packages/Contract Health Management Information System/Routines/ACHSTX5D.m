ACHSTX5D ;IHS/SET/GTH - RECORD 5(DOCUMENT FOR AO/FI) FORMAT ; [ 04/23/2003  10:19 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**5,19**;JUN 11, 2001
 ;IHS/SET/GTH ACHS*3.1*5 12/06/2002 - New Routine.
 ;;
 ;;Record 5A - DOCUMENT (PURCHASE ORDER) RECORD.
 ;;Routine:  ACHSTX5
 ;;
 ;;   POSIT  LENGTH  VAR       NAME                         JUSTIFY
 ;;   -----  ------  --------  --------------------------   -------
 ;;    1- 2       2  constant  5A                           -
 ;;    3-12      10  ACHSDOCN  PURCHASE ORDER NUMBER        -
 ;;   13-14       2  ACHSTOS   PO TYPE (43, 57,64)          -
 ;;   15-20       6  FAC       FACILITY CODE                -
 ;;   21-         1  ACHSBIND  BLANKET INDICATOR            -
 ;;   22-33      12  ACHSEIN   VENDOR ID NUMBER             L
 ;;   34-39       6  ACHSHRN   HEALTH RECORD NUMBER         R
 ;;   40-39      10  ACHSCN    CONTRACT NUMBER              L
 ;;   50-56       7  ACHSCAN   COMMON ACCOUNTING NUMBER     -
 ;;   57-60       4  ACHSOBJC  OBJECT CLASSIFICATION        -
 ;;   61-66       6            ORDER DATE (YYMMDD)          -
 ;;   67-68       2  ACHSSTS   PO SUFFIX (2 blanks or "AD") -
 ;;   69-76       8  ACHSIPA   AMOUNT                       R
 ;;   77-79       3  ACHSESDA  EST. INPATIENT DAYS          R
 ;;   80          1  ACHSFED   FED NON FED CODE             -
 ;;
 ;;Record 5B - DOCUMENT (PO) RECORD (PART 2).
 ;;Routine:  ACHSTX5
 ;;
 ;;   POSIT  LENGTH  VAR       NAME                         JUSTIFY
 ;;   -----  ------  --------  --------------------------   -------
 ;;    1-2        2  constant  5B                           -
 ;;    3-4        2  ACHSREFT  REFERRAL TYPE (DENTAL ONLY)  R
 ;;    5-10       6  ACHSEDOS  DATE OF SERV. (EST) (YYMMDD) -
 ;;   11-16       6  ACHSFDT   BEGIN AUTH. DATE (YYMMDD)    -
 ;;   17-22       6  ACHSTDT   ENDING AUTH. DATE (YYMMDD)   -
 ;;   23-38      16            PATIENT NAME (LAST,FIRST)    -
 ;;   39-54      16            PATIENT INSURER # 1          -
 ;;   55-70      16            PATIENT INSURER # 2          -
 ;;   71-73       3            TRIBAL CODE (3 DIGIT)
 ;;   74-80       7            COMMUNITY CODE (COMM_CO_ST)
 ;;
 ;;Record  5C - DOCUMENT (PO) RECORD (PART 3).
 ;;
 ;;   POSIT  LENGTH  VAR       NAME                         JUSTIFY
 ;;   -----  ------  --------  --------------------------   -------
 ;;    1-2        2  constant 5C                            -
 ;;    3-6        4  ACHSSCC   SERVICE CLASS CODE           -
 ;;    7-14       8            ORDER DATE                   CCYYMMDD
 ;;   15-22       8            DATE OF SERVICE (EST)        CCYYMMDD
 ;;   23-30       8            BEGIN AUTH. DATE             CCYYMMDD
 ;;   31-38       8            ENDING AUTH. DATE            CCYYMMDD
 ;;   39-54      16  ACHSAGID  PT REG UNIQ ID 15 CHAR 1 BLNK  -
 ;;    55         1            APPROVE STERILIZATON
 ;;    56         1            APPROVE IN SUPPORT DIRECT CARE
 ;;    57         1  ACHSDB    DATABASE ID 1-NEW BLNK-OLD   -
 ;;    58-80      26            blanks                       -
 ;
