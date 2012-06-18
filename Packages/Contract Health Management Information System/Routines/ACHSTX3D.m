ACHSTX3D ;IHS/SET/GTH - RECORD 3(PATIENT FOR AO/FI) FORMAT ; [ 12/06/2002  10:36 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**5**;JUN 11, 2001
 ;IHS/SET/GTH ACHS*3.1*5 12/06/2002 - New Routine.
 ;;
 ;;Record 3A - PATIENT RECORD.
 ;;Routine :  ACHSTX3
 ;;
 ;;   POSIT  LENGTH  VAR       NAME                         JUSTIFY
 ;;   -----  ------  --------  --------------------------   -------
 ;;    1          2  constant  3A                           -
 ;;    3- 8       6  ACHSFAC   AUTHORIZING FACILITY         -
 ;;    9-14       6  ACHSHRN   HEALTH RECORD NUMBER         R
 ;;   15-21       7  ACHSDOB   DATE OF BIRTH                L
 ;;   22          1  ACHSSEX   SEX                          -
 ;;   23-25       3  ACHSTRIB  TRIBE                        -
 ;;   26-55      30  ACHSNAME  NAME                         L
 ;;   56          1  ACHSCOV   CARE, CAID "AB", RR or PVT   -
 ;;   57-63       7  ACHSCOMM  COMMUNITY CODE               L
 ;;   64-72       9  ACHSSSN   SSN                          -
 ;;   73-78       6  ACHSUPDT  DATE OF LAST PT UPDATE       -
 ;;   79          1  $$SSV     SSN VERIFICATION STATUS      -
 ;;   80          1  ACHSDEST  DOCUMENT DESTINATION         -
 ;;
 ;;Record 3B - PATIENT RECORD.
 ;;Routine:  ACHSTX3
 ;;
 ;;   POSIT  LENGTH  VAR       NAME                         JUSTIFY
 ;;   -----  ------  --------  --------------------------   -------
 ;;    1- 2       2  constant  3B                           -
 ;;    3-32      30  ACHSADDR  STREET ADDRESS               L
 ;;   33-52      20  ACHSCITY  CITY                         L
 ;;   53-54       2  ACHSST    STATE                        -
 ;;   55-63       9  ACHSZIP   ZIP CODE                     L
 ;;   64-80      17  ACHSINSR  INSURED NAME                 L
 ;;
 ;;Record 3C - PATIENT RECORD 3RD PARTY COVERAGE.
 ;;Routine:  ACHSTX3C
 ;;   POSIT  LENGTH  VAR       NAME                         JUSTIFY
 ;;   -----  ------  --------  --------------------------   -------
 ;;    1- 2       2            "3C"
 ;;    3-32      30            INSURER NAME                 L
 ;;   33-47      15            POLICY NUMBER                L
 ;;   48-49       2            STATE
 ;;   50-51       2            POLICY SUFFIX
 ;;   52-57       6            ELIG BEGIN DATE (YYMMDD)
 ;;   58-63       6            ELIG END DATE   (YYMMDD)
 ;;   64-80      17            COVERAGE TYPE                L 
 ;
