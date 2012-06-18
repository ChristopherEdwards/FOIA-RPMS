ACHSTX2D ;IHS/SET/GTH - RECORD 2(DHR) FORMAT ; [ 12/06/2002  10:36 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**5**;JUN 11, 2001
 ;IHS/SET/GTH ACHS*3.1*5 12/06/2002 - New routine.
 ;
 ;;Record 2 - FACILITY GENERATED DHR RECORD.
 ;;   POSIT  LENGTH  VAR      NAME                          JUSTIFY
 ;;   -----  ------  ------   ------------------------      -------
 ;;    1          1  constant RECORD TYPE (2)               -
 ;;    2- 7       6  ACHSEFDT EFFECTIVE DATE (MMDDYY)       -
 ;;    8-12       5  CDE      DESTINATION CODE              -
 ;;                           values: 05013 INITIAL
 ;;                                   05024 FULL CANCEL
 ;;                                   05025 PARTIAL CANCEL
 ;;                                   05015 SUPPLEMENT
 ;;   13-15       3  ACHSTOS  323, 324, OR 325              -
 ;;   16-25      10  ACHSDOCN DOCUMENT NUMBER               -
 ;;   26-38      13  -        blanks                        -
 ;;   39          1  -        constant=1                    -
 ;;   40          1  X1       FISCAL YEAR                   -
 ;;   41-47       7  ACHSCAN  COMMON ACCOUNTING NUMBER      -
 ;;   48-51       4  ACHSOBJC OBJECT CLASS CODE             -
 ;;   52-63      12  ACHSIPA  IHS PAYMENT AMOUNT            R
 ;;   64          1  ACHSFED  FED NON FED CODE              -
 ;;   65-80      16  -        blanks                        -
 ;;
 ;;Record 2B - EXTRA DHR INFO FOR CORE.
 ;;Routine: ACHSTX2
 ;;
 ;;   POSIT  LENGTH  VAR      NAME                          JUSTIFY
 ;;   -----  ------  ------   ------------------------      -------
 ;;    1- 2       2  constant "2B"                          -
 ;;    3- 6       4           USER ID (FINANCIAL CODE)      -
 ;;    7-36      30  ACHSCAN  CAN DESCRIPTION               L
 ;;   37-56      20  ACHSOBJC OCC SHORT DESCRIPTION         L
 ;;   57-60       4  ACHSY    Fiscal Year   (CCYY)          -
 ;;   61-80      20  -        blanks                        -
 ;;
 ;;Record 2C - EXTRA DHR INFO FOR CORE.
 ;;Routine: ACHSTX2
 ;;
 ;;   POSIT  LENGTH  VAR      NAME                          JUSTIFY
 ;;   -----  ------  ------   ------------------------      -------
 ;;    1- 2       2  constant "2C"                          -
 ;;    3-14      12           Vendor EIN & Suffix           L
 ;;   15-44      30           Vendor Name                   L
 ;;   45-74      30           Vendor City,State,Zip         L
 ;;   75-80       6           blanks                        -
 ;
