BSDAPI2 ; IHS/ANMC/LJF - PUBLIC API'S THAT LIST APPT DATA;  [ 04/14/2003  4:17 PM ]
 ;;5.3;PIMS;;APR 26, 2002
 ;
 ;
LIST(BSDDT,BSDTYP,BSDCLN,BSDARR) ;PEP; returns list of patient appts for date and clinic
 ;IHS/ITSC/WAR 4/14/03 - P60/WAR19 changed the passing of the 4th
 ;      parameter. The parameter should be passed by 'value' (no period
 ;      in front of variable) not by 'reference'. Problem occured at
 ;      APPTLN()+13^BSDAPI2 (when indirection processed @(X)=LINE).
 ; Bad Call:  D LIST^BSDAPI2(DATE,TYPE,.CLINIC,.ARRAY) where
 ; Good Call: D LIST^BSDAPI2(DATE,TYPE,.CLINIC,ARRAY) where
 ;
 ;  DATE   = Appointment date in FM format
 ;
 ;  TYPE contains "W" to include walk-ins; contains "C" to include cancelled appts or set to null for neither
 ;
 ;  CLINIC = "ALL" for all clinics with appts on date OR array of clinic internal entry numbers
 ;    >> If you set CLINIC=ALL and you have clinics from multiple facilities, you must set CLINIC("DEV")
 ;       equal to the internal entry number of Medical Center Division you want used.)
 ;    >> Principal clinics can be passed and they will expand to all clinics under them
 ;
 ;  ARRAY  = array name where you want list returns; can be local or global array
 ;           send array ending in ( or , such as S ARRAY="XYZ(" or S ARRAY="^ABC(""XYZ"","
 ;           will be subscripted by simple number count (XYZ(1), XYZ(2) or ^ABC("XYZ",1), ^ABC("XYZ",2))
 ;           structure: patient DFN ^ Clinic IEN ^ Appt Date/Time ^ Type ^ Length of Appt ^ Other Info
 ;
 ;
 NEW BSDC,VAUTD,BSDCR
 I $G(BSDCLN)="ALL" S VAUTD=$G(CLINIC("DEV"))   ;set up division for multi-facilities
 S BSDCR=0                                      ;don't include chart requests
 ; loop through array of clinics and create list one clinic at a time
 S BSDC=0 F  S BSDC=$S($G(BSDCLN)="ALL":$O(^SC(BSDC)),1:$O(BSDCLN(BSDC))) Q:'BSDC  D CLINIC
 Q
 ;
CLINIC ; called for each clinic
 NEW BSD,IEN
 ; check if clinic is active and not cancelled for date
 I $$CHECK(BSDC,BSDDT),$$ACTIVITY^BSDAL2(BSDC,BSDDT) D
 . ;get each appt time for date and clinic
 . S BSD=BSDDT
 . F  S BSD=$O(^SC(BSDC,"S",BSD)) Q:'BSD!(BSD\1>BSDDT)  D
 .. ;  find each appt at date/time then call APPTLN to print info
 .. S IEN=0
 .. F  S IEN=$O(^SC(BSDC,"S",BSD,1,IEN)) Q:'IEN  D APPTLN(BSDC,BSD,IEN)  ;build appt data line
 Q
 ;
APPTLN(CLN,DATE,IEN) ; -- for each individual appt, build patient data line
 NEW TYPE,DFN,LINE
 S TYPE="S"                                              ;scheduled
 I $P($G(^SC(BSDC,"S",BSD,1,IEN,0)),U,9)="C" S TYPE="C"  ;canceled
 S DFN=+$G(^SC(CLN,"S",DATE,1,IEN,0)) Q:'DFN
 I $P($G(^DPT(DFN,"S",DATE,0)),U,2)["C" S TYPE="C"       ;canceled
 I BSDTYP'["C",TYPE="C" Q                                ;quit if canceled not included
 I TYPE="S",$$WALKIN^BSDU2(DFN,DATE) S TYPE="W"          ;or a walk-in?
 I TYPE="W",BSDTYP'["W" Q                                ;quit if walk-ins not included
 ;
 ; -- build data line: patient^clinic^date/time^type^length^other info
 S LINE=DFN_U_CLN_U_DATE_U_TYPE_U_$P($G(^SC(CLN,"S",DATE,1,IEN,0)),U,2)_U_$P($G(^(0)),U,4)
 ; -- set data line into array
 S BSDCNT=$G(BSDCNT)+1,X=BSDARR_BSDCNT_")",@(X)=LINE
 Q
 ;
CHECK(CLN,APDT) ;check if clinic for this division and not cancelled or inactive
 I $$GET1^DIQ(44,CLN,2,"I")'="C" Q 0                       ;not a clinic
 I $G(VAUTD),$$GET1^DIQ(44,CLN,3.5,"I")'=VAUTD Q 0         ;wrong division
 I '$$ACTV^BSDU(CLN,APDT) Q 0                              ;not active
 I $G(^SC(CLN,"ST",APDT,1))["**CANCELLED" Q 0              ;cancelled
 Q 1
