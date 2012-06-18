INHQRIN ; dmw ; 17 Aug 1999 17:54; Process Inbound Generic Query 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;;This supports inbound HL7 query messages. It is specific to CHCS.
 ;;As the IHS develops its own query capbility, this routine should
 ;;be modified or used as a template for the incoming messages.
 ;W $$ROUDOC^DGFUNC2("INHQRIN") Q
 ;
 ; Invoked by:
 ;         Inbound query script (HL GIS QUERY IN)
 ; Invokes application query/response routines, based on category
 ;         of query
 ; Input variables:
 ;         INV  - array with field values from inbound message
 ;         UIF  - Universal Interface File IEN for Query Message
 ; Output variables:
 ;         INOA - array of data used by the GIS to process inbound
 ;                queries and return responses
 ;         INQA - array of data needed by application teams to process
 ;                responses to query
 ;                INQA("INQPID")   = CHCS Patient IEN
 ;                INQA("INQCAT")   = Category of query
 ;                INQA("INQFRM")   = Begin date for response processing
 ;                INQA("INQTHRU")  = End date for response processing
 ;                INQA("INQWHICH") = Date used for processing
 ;                INQA("INQUID")   = Unique ID for category
 ;
EN ; Entry point for inbound query processing.
 N INQA,INXV
 ;
 ; If unique identifier exists (Lab and Rad only), bypass other checks
 ;   and invoke application
 ; Get OTHER QRY SUBJECT FILTER from INV array
 ;   Sub-components:
 ;     1 - Lab accession number
 ;     2 - Radiology exam number) 
 ; ** NOTES: This is not the IEN of the identity, but the actual
 ;           assigned number.  If multiple values are transmitted, only 
 ;           the first value encountered will be processed by the 
 ;           application.
 ;
 ;           No validation of this value occurs within this function.
 ;           It will be passed to the application routine as it is 
 ;           received.
 ; If data in OTHER QRY SUBJECT FILTER, set unique ID and category.  
 ;  Go to MISC
 ;
 I $$UID() D MISC Q
 I '$$WHO() D LOGERR("No unique CHCS patient identified.") Q
 I '$$WHAT() D LOGERR("No Query Category defined.") Q
 D WHEN,MISC
 Q
UID() S INXV=$G(@INV@("QRF5.1")) I $L(INXV) S INQA("INQUID")=INXV,INQA("INQCAT")="LAB" Q 1
 S INXV=$G(@INV@("QRF5.2")) I $L(INXV) S INQA("INQUID")=INXV,INQA("INQCAT")="RAD" Q 1
 Q 0
 ;
WHO() ; Find CHCS patient
 ; Get WHO SUBJECT FILTER from INV array (INV("QRD8")
 ;   Sub-components:
 ;     1  - CHCS Patient IEN
 ;     2  - Patient Family Name
 ;     3  - Patient Given Name
 ;     4  - Patient Middle Name/Initial
 ;     10 - Patient FMP/SSN
 ; If valid CHCS patient IEN, set INQA("INQPID")=IEN.
 ;
 ; Note:  See description in field definition, HL QUERY WHO SUBJECT 
 ; FILTER, for design considerations.
 F INXV=1,2,3,4,10 S @INV@("QRD8."_INXV)=$P($G(@INV@("QRD8")),SUBDELIM,INXV)
 S INXV=$G(@INV@("QRD8.1")) I $G(INXV),$D(^DPT(INXV)) S INQA("INQPID")=INXV Q 1
 ; If valid patient FMP/SSN, get patient IEN. Set INQA("INQPID")=IEN.
 S INXV=$G(@INV@("QRD8.10")) I INXV["/" S INQA("INQPID")=$$GETPAT(INXV) I $G(INQA("INQPID")) Q 1
 ; Look up on patient name.  If unique patient identified, set
 ;   INQA("INQPID")=IEN.
 S INXV=$G(@INV@("QRD8.2"))_","_$G(@INV@("QRD8.3"))_$S($L(@INV@("QRD8.4")):" "_@INV@("QRD8.4"),1:"")
 I $L(INXV)>1 S INQA("INQPID")=$$GETPAT(INXV) I $G(INQA("INQPID")) Q 1
 ; Else,
 ;   Abort processing with error, "No Unique Patient Identified." Quit.
 ;   (Application error will be transmitted in MSA-6 of application ack)
 Q 0
 ;
WHAT() ; Get category for processing.
 ; Get WHAT SUBJECT FILTER from INV array (INV("QRD9"))
 S INXV=$G(@INV@("QRD9")) S:$L(INXV) (INQA("INQCAT"),INOA("INQWHAT"))=INXV
 I ",DEM,ORD,RES,SBK,"'[(","_INXV_",") K INQA("INQCAT")
 ; Valid values:
 ;  DEM - Patient Demograpic data
 ;  ORD - Order data
 ;  RES - Results data
 ;  SBK - Booked slots on the identified schedule
 ;
 ; Get subclassification for processing.
 ; Get WHERE SUBJECT FILTER from INV array (INV("QRF1"))
 S INXV=$G(@INV@("QRF1"))
 ;
 ; Valid values (based on WHAT SUBJECT FILTER):
 ;  (* indicates default if WHERE SUBJECT FILTER not defined)
 ;
 ;    WHAT                WHERE
 ;    ----                -----
 ;    DEM                *PID (patient demographics only)
 ;                        ALG (allergy data)
 ;    ORD                *PHR (medication profile)
 ;                        PHR/RX (prescriptions only)
 ;    RES                *LAB (all laboratory results)
 ;                        LAB/AP (anatomic pathology results only)
 ;                        LAB/BB (blood bank results only)
 ;                        LAB/CH (chemistry results only)
 ;                        LAB/MI (microbiology results only)
 ;                        RAD (all radiology results)
 ;    SBK                *SBK (booked slots on the identified schedule)
 ;
 ; *** NOTE: WHERE SUBJECT FILTER takes precedence over WHAT SUBJECT
 ;           FILTER.  If WHERE defined, reset CATEGORY to correspond.
 ; If valid value in WHERE SUBJECT FILTER, set INQA("INQCAT")=category.
 ;   Go to WHEN.
 ;
 I ",PID,ALG,PHR,PHR/RX,LAB,LAB/AP,LAB/BB,LAB/CH,LAB/MI,RAD,SBK,"[(","_INXV_",") S INQA("INQCAT")=INXV Q 1
 ;
 ; If valid value in WHAT SUBJECT FILTER, set INQA("INQCAT")=default
 ;   for WHAT SUBJECT FILTER.  Go to WHEN
 I $D(INQA("INQCAT")) S INXV=INQA("INQCAT") D
 .I INXV="DEM" S INQA("INQCAT")="PID" Q
 .I INXV="ORD" S INQA("INQCAT")="PHR" Q
 .I INXV="RES" S INQA("INQCAT")="LAB" Q
 .I INXV="SBK" S INQA("INQCAT")="SBK" Q
 .K INQA("INQCAT")
 Q:$D(INQA("INQCAT")) 1
 ;
 ; Else,
 ;   Abort processing with error, "No category defined" and quit.
 ;   (Application error will be transmitted in MSA-6 of application ack)
 Q 0
 ;
WHEN ; Determine start and end dates.
 ; Get WHEN QTY/TIMING QUAL from INV array (INV("QRF9"))
 ;   Sub-components:
 ;     4 - Start date/time
 ;     5 - End date/time
 ; Start date/time not required.  Will default to T-(1 month). Derive
 ;   FileMan date/time.  Set INQA("INQFRM")=fileman start date.
 S INXV=$G(@INV@("QRF9.4"))\1 I 'INXV S INXV=$$ADDM^%ZTFDT($$DT^%ZTFDT,-1)
 S INQA("INQFRM")=INXV
 ; End date/time not required.  Will default to current date. Derive
 ;   FileMan date/time.  Set INQA("INQTHRU")=fileman end date.
 ;
 ; *** NOTE: The end date will be sent to the application routine.
 ;           No time is sent.  The application routine should include
 ;           all responses for the date equal to the end date.
 S INXV=$G(@INV@("QRF9.5"))\1 I 'INXV S INXV=$$DT^%ZTFDT
 S INQA("INQTHRU")=INXV
 ; Get WHICH value.  If not defined, set default.
 ; Valid Values:
 ;  ALG and PHR will only support ORD - Order Date/Time
 ;  PID is not date sensitive data
 ;  RAD and LAB will support COL (Collection/Exam Date/Time),
 ;                           REP (Report/Certify Date/Time), and
 ;                           ORD (Order Start Date/Time)
 ;  SBK will support SCHED (Schedule Date/Time)
 ;
 ; Default Values:
 ;   Category            Which Date Value
 ;   --------            ----------------
 ;   ALG,PHR             ORD - Order Date/Time
 ;   LAB,RAD             REP - Report/Certify Date/Time
 ;   PID                 Not Linked to a dated field
 ;   SBK                 SCHED - Schedule Date/Time
 ;
 S INQA("INQWHICH")=$G(@INV@("QRF6"))
 I ",ORD,COL,REP,SCHED,"'[(","_INQA("INQWHICH")_",") S INQA("INQWHICH")=""
 I '$L(INQA("INQWHICH")) S INXV=$G(INQA("INQCAT")),INQA("INQWHICH")=$S("LABRAD"[$P(INXV,"/"):"REP","SBK":"SCHED",1:"ORD")
 Q
 ;
MISC ; Set INDEST and Original Message (Query) message ID for processing.
 ; Set INOA("INDEST")=query destination
 ; Set INOA("INSTAT")=application accept
 ;
 S INOA("INMIDGEN")=$P($G(^INTHU(UIF,0)),U,5)
 S INOA("INDEST")=$P($G(^INTHU(UIF,2)),U,2)
 S INOA("INSTAT")="AA"
 ;
 ; Set QRD values into INOA array for return in responses.
 S INOA("INQDTM")=$G(@INV@("QRD1"))
 S INOA("INQPRI")="D"
 S INOA("INQTAG")=$G(@INV@("QRD4"))
 S INOA("INQWHO")=$G(@INV@("QRD8"))
 S INOA("INQWHAT")=$G(@INV@("QRD9"))
 ;
 ; Get routine for processing.
 S INQAPPL=$P($T(@$P(INQA("INQCAT"),"/")),";",3)
 ;
 ; Call routine, passing in INOA, and INQA arrays.
 ;   Will return number of responses in INOA array for application
 ;   ACK processing.
 S @("INOA(""INQRSP"")=$$"_INQAPPL_"(.INOA,.INQA)")
 ;
 ; Set variables for application ack
 ; Quit Lookup/Store routine.
 S INOA("INQRSTAT")=$S(INOA("INQRSP"):"OK",1:"NF")
 Q
 ;
GETPAT(INXV) ; Get CHCS patient IEN
 ; Initialize variables for FileMan Lookup
 N X,Y,DIC
 ; If FMP/SSN or name search, perform lookup. If unique patient found,
 ;   quit with CHCS patient IEN.  Function returns CHCS Patient IEN
 ;   in Y(1) if found.
 S INXV=$TR(INXV,"-","")
 S DIC=2,X=INXV,DIC(0)="MSX"
 D ^DIC
 ;
 ; If no unique patient found, quit with 0 to continue processing error.
 I '$G(Y(1)) Q 0
 ; Else,
 ;   Quit with IEN of unique CHCS patient.
 Q +Y(1)
 ;
LOGERR(E) ; Log error message E.  Set values for ack error.
 ; Quit Lookup/Store routine.
 ;
 S INOA("INSTAT")="AE"
 S INOA("INORIGID")=$G(@INV@("MSH10"))
 S INODA=""
 D ERROR^INHS(E,2)
 Q
 ;
PID ;;PID^DGGISQ
ALG ;;ALG^ORGISQR
PHR ;;PHR^ORGISQR
RAD ;;RAD^RAGISQ
LAB ;;LAB^LRGISQ
SBK ;;SBK^SDGISQ
