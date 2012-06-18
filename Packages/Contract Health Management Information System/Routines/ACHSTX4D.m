ACHSTX4D ;IHS/SET/GTH - RECORD 4(VENDOR FOR AO/FI) FORMAT ; [ 12/06/2002  10:36 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**5**;JUN 11, 2001
 ;IHS/SET/GTH ACHS*3.1*5 12/06/2002 - New Routine.
 ;;
 ;;Record 4A - VENDOR RECORD.
 ;;Routine:  ACHSTX4
 ;;
 ;;   POSIT  LENGTH  VAR       NAME                         JUSTIFY
 ;;   -----  ------  --------  --------------------------   -------
 ;;    1- 2       2  constant  4A                           -
 ;;    3-14      12  ACHSEIN   VENDOR ID NUMBER & SUF       L
 ;;   15-44      30  ACHSNAME  VENDOR NAME                  L
 ;;   45-46       2  ACHSPTYP  VENDOR TYPE                  L
 ;;   47-         1  ACHSFED   FED NON FED CODE             -
 ;;   48-53       6  ACHSFAC   FACILITY CODE                -
 ;;   54-63      10  ACHSDAP   VENDOR YTD PAID              R
 ;;   64-69       6  ACHSUPDT  DATE OF LAST UPDATE          MMDDYY
 ;;         Note:  Century for above date is in 4B, 77-78.
 ;;   70-79      10  ACHSCN    CONTRACT NUMBER              L
 ;;   80          1            DOCUMENT DESTINATION         -
 ;;
 ;;Record 4B - VENDOR RECORD.
 ;;Routine:  ACHSTX4
 ;;
 ;;   POSIT  LENGTH  VAR       NAME                         JUSTIFY
 ;;   -----  ------  --------  --------------------------   -------
 ;;    1- 2       2  constant  4B                           -
 ;;    3-32      30            STREET ADDRESS               L
 ;;   33-52      20            CITY                         L
 ;;   53-54       2  ACHSST    STATE                        -
 ;;   55-63       9            ZIP CODE                     L
 ;;   64-         1  ACHS1099  1099 PRINTED                 -
 ;;   65-74      10  ACHSFONE  VENDOR PHONE NUMBER          R
 ;;   75-76       2  ACHSAPN   SITE ACCOUNTING POINT NUM    R
 ;;   77-78       2            DATE OF LAST UPDATE, CENTURY CC
 ;;   78-         1            blank                        -
 ;;   80          1            DOCUMENT DESTINATION         -
 ;
