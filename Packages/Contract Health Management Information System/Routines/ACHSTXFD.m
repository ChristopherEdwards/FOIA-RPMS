ACHSTXFD ;IHS/OIT/FCJ - RECORD 2(UFMS) FORMAT ;
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**13**;JUN 11, 2001
 ;IHS/OIT/FCJ ACHS*3.1*13 - New routine
 ;
 ;Routine: ACHSTXF
 ;;Record type 2 - FACILITY GENERATED UFMS RECORD.
 ;;   POS     LEN       VAR      NAME            JUSTIFY
 ;;   -----  ------  -------------------------------------
 ;;    1       2  constant RECORD TYPE (U2)
 ;;    3- 8    6  ACHSEFDT EFF DATE (MMDDYY)
 ;;    9-11    3           DESTINATION CODE
 ;;                           values: 050
 ;;    12      1           Reverse code
 ;;                           values: 2 = (-)
 ;;                           values: 1 = +
 ;;    13      1           Modifier code
 ;;                           values: 3 new
 ;;                           values: 5 Mod
 ;;                           values: 4 cancel
 ;;    14-16   3  ACHSTOS  323, 324, OR 325
 ;;    17-21   4           DEPT-AGENCY "HHSI"
 ;;    22-24   3  ACHSARCO Area contracting number
 ;;    25-36  12  ACHSDOCN DOCUMENT NUMBER
 ;;                   ACHSDFY  4 digit fy
 ;;                            3 Area Finance location code
 ;;                            5 numeric document number
 ;;                            1 Contract purchase type
 ;;    37-39  3            blanks
 ;;    40      1            Geographic code constant=1
 ;;    41      1  X1        FISCAL YEAR
 ;;    42-48   7  ACHSCAN   COMMON ACCOUNTING NUMBER
 ;;    49-52   4  ACHSOBJC  OBJECT CLASS CODE
 ;;    53-64  12  ACHSIPA   IHS PAYMENT AMOUNT       R zero fill
 ;;    65      1  ACHSFED   FED NON FED CODE
 ;;    66-77  13  ACHSEIN   EIN Vendor               R
 ;;    78-92  15            EIN secondary vendor
 ;;   93-131  39            Blanks
 ;;  132-133   2  ACHSY     FISCAL YEAR (YY)
 ;;  134       1            PAYMENT DESTINATION "F" OR "I"
 ;;  135-138   4  ACHSFC    USER ID (FINANCIAL CODE USED)
 ;;  138-151  13  ACHSDUNS  DUNS+4                    L
 ;;  152-161  10  -         blanks
 ;;
