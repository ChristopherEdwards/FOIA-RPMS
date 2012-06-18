ACHSTX6D ;IHS/SET/GTH - RECORD 6(PAY FOR AO) FORMAT ; [ 12/06/2002  10:36 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**5**;JUN 11, 2001
 ;IHS/SET/GTH ACHS*3.1*5 12/06/2002 - New Routine.
 ;;
 ;;Record 6A - PAYMENT RECORD FOR AREA OFFICE.
 ;;Routine:  ACHSTX6
 ;;
 ;;   POSIT  LENGTH  VAR       NAME                         JUSTIFY
 ;;   -----  ------  --------  --------------------------   -------
 ;;    1- 2       2  constant  6A                           -
 ;;    3-11       9  ACHSDOCN  PURCHASE ORDER NUMBER        -
 ;;   12-13       2  ACHSTOS   PO TYPE (43, 57, 64)         -
 ;;   14-19       6            PO DATE (YYMMDD)             -
 ;;   20          1  constant  6                            -
 ;;   21-26       6  FAC       FACILITY CODE                -
 ;;   27-32       6  ACHSHRN   HEALTH RECORD NUMBER         R
 ;;   33-44      12  ACHSEIN   VENDOR ID NUMBER             L
 ;;   45-46       2  ACHSPTYP  VENDOR TYPE                  -
 ;;   47          1  ACHSFED   VENDOR FED/NON FED CODE      -
 ;;   48-57      10  ACHSCN    CONTRACT NUMBER              L
 ;;   58-64       7  ACHSCAN   COMMON ACCOUNTING NUMBER     -
 ;;   65-68       4  ACHSOBJC  OBJECT CLASSIFICATION        -
 ;;   69          1  ACHSDCR   DCR ACCOUNT NUMBER           -
 ;;   70-80      11  -         blanks                       -
 ;;
 ;;Record 6B - PAYMENT RECORD FOR AREA OFFICE.
 ;;Routine:  ACHSTX6.
 ;;
 ;;   POSIT  LENGTH  VAR       NAME                         JUSTIFY
 ;;   -----  ------  --------  --------------------------   -------
 ;;    1- 2       2  constant  6B                           -
 ;;    3-10       8  ACHSOAMT  TOTAL AMOUNT OBLIGATED       R
 ;;   11-18       8  ACHSIPA   IHS PAYMENT AMOUNT           R
 ;;   19          1  ACHSFULP  FULL PAYMENT CODE            -
 ;;   20-39      20  ACHSLNAM  PATIENT LAST NAME            L
 ;;   40-49      10  ACHSFNAM  PATIENT FIRST NAME           L
 ;;   50-55       6  ACHSDOS   DATE OF SERVICE (MMDDYY)     R
 ;;   56-58       3  ACHSWKLD  WORKLOAD                     R
 ;;   59-66       8  ACHSTHRD  3P AMOUNT
 ;;   67-80      14  -         blanks                       -
 ;
