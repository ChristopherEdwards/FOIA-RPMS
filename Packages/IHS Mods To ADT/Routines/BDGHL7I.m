BDGHL7I ; IHS/ANMC/LJF - INBOUND HL7 DATA TO PIMS ;
 ;;5.3;PIMS;;APR 26, 2002
 ;
 ; Called by BHLPV1I to process PV1 segments
 ; Variables set in BHL routines:
 ;   CS      =  component separator
 ;   BHLET   =  Event type (A01, A03, etc.)
 ;   BHLTMP  =  array of message items (BHL("PV1"))
 ;
PARSE ; -- parse through array BHLTMP and build PIMS array   
 NEW ARRAY,ITEM
 S ITEM=$G(@BHLTMP@(1,3))     ;location info (fac, cln/ward, room)
 S LOC=$P(ITEM,CS),HLOC=$P(ITEM,CS,2)
 ; DO LOOKUP ON LOCATION AND GET ASUFAC CODE
 S ARRAY("LOC")=$$GET1^DIQ(9999999.06,+ITEM,.0799)  ;asufac code
 ; DO LOOKUP ON HOSP LOCATION AND DETERMINE IF WARD OR CLINIC
 I $$GET1^DIQ(44,+$P(ITEM,CS,2),2)="WARD" D
 . S ARRAY("WARD")=$P(ITEM,CS,2)
 ;
 ; location determines if call is to ADT or Scheduling
 I $D(ARRAY("WARD")) D ADT Q
 D APPT
 Q
 ;
ADT ; -- continue parsing ADT items
 NEW ITEM,X
 S ITEM=$G(@BHLTMP@(1,4))     ;admission type
 ;NEED TO KNOW IF THIS WILL BE IHS OR UB92 ADMIT TYPE
 ;
 S ITEM=$G(@BHLTMP@(1,7))     ;attending doctor
 ;WILL PROVIDER ID BE USED?  NAMES ARE NOT UNIQUE
 ;
 S ITEM=$G(@BHLTMP@(1,8))     ;referring doctor
 ;WILL WE STILL USE FREE TEXT?  ONLY IF NOT REQUIRED ON MS4 SIDE
 ;
 S ITEM=$G(@BHLTMP@(1,10))    ;hospital service
 ;IHS SPECS SAY SERVICE CATEGORY?????
 ;
 S ITEM=$G(@BHLTMP@(1,14))    ;admit source
 ;WAITING FOR VALID VALUES FROM MS4 PROGRAMMER
 ;
 S ITEM=$G(@BHLTMP@(1,17))    ;admitting doctor
 ;SAME QUESTIONS ABOUT ID AS ATTENDING
 ;
 S ITEM=$G(@BHLTMP@(1,36))    ;discharge disposition
 ;WAITING FOR VALID VALUES FROM MS4
 ;
 S ITEM=$G(@BHLTMP@(1,37))    ;discharged to location
 S ARRAY("TFAC")=ITEM
 ;NEED MS4 TO SUPPORT FIELD AND LOCAL TABLE
 ;ALSO NEED FOR ADMITS
 ;
 S ITEM=$G(@BHLTMP@(1,44))    ;admit date/time
 S ARRAY("DATE")=ITEM
 ;WOULD BOTH ADMIT AND DISCHARGE DATE BE SENT AT SAME TIME?
 ;WOULD MORE THAN ONE MOVEMENT BE SENT IN ONE PV1 SEGMENT?
 ;
 S ITEM=$G(@BHLTMP@(1,45))    ;discharge date/time
 S ARRAY("DATE")=ITEM
 ;
 ;DETERMINE IF ADD, EDIT OR CANCEL
 ;THEN CALL ^BDGAPI AT ADD, EDIT OR CANCEL ENTRY POINT
 Q
 ;
APPT ; -- continue parsing Scheduling items
 Q
