ACRFUFMZ ;IHS/OIRM/DSD/AEF - MATCH OPEN DOCUMENTS FROM CORE FOR UFMS [ 05/16/2007   9:44 AM ]
 ;;2.1;ADMIN RESOURCE MGMT SYSTEM;**22**;NOV 05, 2001
 ;NEW ROUTINE ACR*2.1*22 UFMS
 ;
 ; File ^ACRZ("ACRCORE",##) is created by READ^ACRFUFMR
 ;     by reading the flat file provided by CORE.
 ;     File name is Docs##.txt where ## is the Accounting Point.
 ;     Comma delimiters were stripped and replaced by the ARMS
 ;     up-arrow (^) delimiter, which is used throughout.
 ;
 ; ^ACRZ("ACRCORE",##)=
 ;   Piece 1: AP       = Accounting Point
 ;         2: doc_type = CORE Document Type (see below)
 ;         3: doc_no   = CORE Document number
 ;         4: fy       = 4-digit Fiscal Year
 ;         5: can      = Common Accounting Number (CAN)
 ;         6: obj_cls  = Object Class Code (OCC)
 ;         7: amt      = Dollar Amount
 ;         8: ref      = Reference Code
 ;         9: ein      = CORE Vendor EIN
 ;    
 ; CORE DOC_TYPE =
 ;   AP - Requisition/Purchase Order/Contracts
 ;   AT - Airline
 ;   GP - Government Payment
 ;   GR - Grants (Non-PMS)
 ;   PM - Grants (PMS)
 ;   PR - Payroll
 ;   TN - Training
 ;   TR - Travel
 ;   MO - Mixed obligations
 ;   MD - Miscellaneous documents
 ;
 ; ****************************************
 ; ****************************************
 ; This routine loops through the ^ACRZ("ACRCORE" entries and
 ; attempts to match the CORE document number with ARMS
 ; documents in the FMS Document, FMS Document History Record and
 ; the 1166 Approvals for Payment files.
 ;
 ; When it finds a document hit, the routine matches the CAN,
 ; Fiscal Year, and Object Class Code supplied by CORE.
 ;
 ; When it finds a match the routine:
 ; 1) sets the error variable ACRERR to null
 ; 2) sets ^ACRZ("ACRDOC",CORE Index number) = DOCUMENT String
 ;   Piece 1 = Accounting Point_-_Vendor IEN
 ;         2 = ASUFAC number_-_Vendor IEN
 ;         3 = Vendor name
 ;         4 = Vendor EIN
 ;         5 = Vendor suffix
 ;         6 = ARMS Requisition number or blank
 ;         7 = Document or Transaction dates
 ;         8 = Identifier, Invoice number or blank
 ;         9 = Accounting point (begins CORE data string)
 ;        10 = CORE Document Type
 ;        11 = CORE Document number
 ;        12 = 4 digit Fiscal Year
 ;        13 = Common Accounting Number (CAN)
 ;        14 = Object Class Code (OCC)
 ;        15 = CORE Dollar amount
 ;        16 = CORE Reference code
 ;        17 = Receiving Report Status
 ;        18 = Invoice Status
 ;        19 = Vendor Error flag
 ; 3) retreives the Vendor IEN from ARMS record (can be zero if no Vendor)
 ; 4) if no Vendor in the FMS Document file, sets
 ;    ^ACRZ("NOVNDR",Core Index number) = DOCUMENT_CORE strings
 ;     As Travel documents will not have a vendor they are captured
 ;     in the ^ACRZ("TR",Core Index number)= DOCUMENT_CORE strings regardless
 ;     of whether or not they are matched in ARMS
 ;     Other entries will be obligations only
 ; 5) checks the entry in the VENDOR file for errors
 ;    if an error is found, ACRERR = Error string
 ;       errors are set in ^ACRZ("ERR",CORE Index number) = DOCUMENT_CORE_ACRERR
 ; 6) sets ^ACRZ("VNDR",Vendor IEN) =DOCUMENT_CORE_ACRERR
 ;       ACRERR can = "NO ERRORS" or Vendor file errors
 ; 7) in addition, sets non-ARMS documents and certain subsets into:
 ;    a. ^ACRZ("PAY",CORE Index number)= CORE string   (Non-ARMS Payroll)
 ;    b. ^ACRZ("CHS",CORE Index number)= CORE string   (Non-ARMS Contract Health)
 ;    c. ^ACRZ("GR",CORE Index number)= CORE string    (Non-ARMS Grants)
 ;    d. ^ACRZ("GTRIP",CORE Index number)= CORE string (Non-ARMS GovTrip Travel)
 ;    e. ^ACRZ("ITEMS",CORE Index number)= CORE string (ARMS Items in matched documents)
 ;    f. ^ACRZ("NOMATCH",CORE Index number)= CORE string (ARMS Hit, no precise match)
 ;    g. ^ACRZ("TR",CORE Index number)= CORE string    (All Old ARMS Travel match)
 ;    h. ^ACRZ("TOTALS",CORE Index number)= CORE string (Totals of all reports)
 ;    i. ^ACRZ("CEIN",CORE Index number)= CORE string  (CORE/ARMS Vendor mismatches) 
 ;    j. ^ACRZ("NOHIT",CORE Index number)= CORE string (No known category)
 ; *********************************
 ; *********************************
EN ;EP; MAIN ENTRY POINT -- CALLED BY READ^ACRFUFMR THROUGH TASKMAN
 D INIT
 D LOOP
 D TOTAL
 D ENW^ACRFUFMR                     ;CREATE REPORTS IN CSV FORMAT
 Q
 ; *********************************
 ; *********************************
INIT ;SET UP GLOBALS
 K ^ACRZ("ACRDOC")
 K ^ACRZ("VNDR")
 K ^ACRZ("ERR")
 K ^ACRZ("NOVNDR")
 K ^ACRZ("NOHIT")
 K ^ACRZ("NOMATCH")
 K ^ACRZ("PAY")
 K ^ACRZ("TOTALS")
 K ^ACRZ("ITEMS")
 K ^ACRZ("GTRIP")
 K ^ACRZ("CHS")
 K ^ACRZ("TR")
 K ^ACRZ("GR")
 K ^ACRZ("CEIN")                ;AUDIT FOR MISMATCHED EIN'S
 ;INITIALIZE VARIABLES
 K ACR,ACRDCNT,ACRVCNT,ACRECNT,ACRERR,ACRTCNT,ACRZCNT,ACRMCNT,ACRAP,ACRPCNT
 K ACRGTRIP,ACRGTOT,ACRCHST,ACRTRTOT,ACRTAIL,ACRNTRT,ACRGRTOT
 K ACRCEIN,ACRAMT,ACRHIT,ACRCORE
 S (ACR,ACRDCNT,ACRVCNT,ACRECNT,ACRERR,ACRTCNT,ACRZCNT,ACRMCNT,ACRPCNT)=0
 S (ACRGTOT,ACRCHST,ACRTRTOT,ACRGRTOT,ACRAMT)=0
 S ASUFAC=$$ASUFAC^ACRFFF4(+$P(^AUTTSITE(1,0),U))
 Q
 ; *********************************
 ; *********************************
LOOP ;LOOP THROUGH CORE OPEN DOCUMENTS
 F  S ACR=$O(^ACRZ("ACRCORE",ACR)) Q:'ACR  D
 .S ACRMATCH=0
 .D SETCORE                       ;PIECE OUT CORE VARIABLES (they will float)
 .Q:ACRCDOC=""                    ;SCREEN EXEMPTIONS
 .;LOOK FOR MATCH IN ARMS FILES
 .I $D(^ACRDOC("B",ACRCDOC))!($D(^ACRDOC("C",ACRCDOC))) D  Q:ACRMATCH
 ..D HITDOC(ACRCDOC)                       ;FMS DOCUMENT FILE
 .I $$REQ D HITDOC(ACRREQ) S ACRREQ=""  Q:ACRMATCH      ;FOUND REBUILT REQ
 .I $D(^AFSLAFP("N",ACRCDOC)) D HIT1166^ACRFUFMX(ACRCDOC,0) Q:ACRMATCH  ;1166 APPROVALS FOR PAYMENT FILE
 .I $D(^ACRDHR("B",ACRCDOC)) D HITDHR^ACRFUFMX(ACRCDOC)  Q  ;FMS DOCUMENT HISTORY RECORD FILE
 .Q:$D(^ACRZ("NOMATCH",ACR))               ;ALREADY COUNTED
 .;NO HIT -- ACCOUNT FOR NONARMS
 .D NONARMS
 Q
 ; ***********************************
NONARMS ;ASSIGN NON-ARMS TO APPROPRIATE FILES
 ; ***********************************
 ;
 ;CHS FI PAID **********************
 I ACRCHS D CHSSET(ACR) Q                 ;DON'T CHECK CHS VENDOR
 ;
 ;CHECK CORE VENDOR ****************
 S ACRV=$$VEN^ACRFUFMU(ACRCEIN)           ;CHECK CORE VENDOR
 S:ACRV=0 ACRERR="NO VENDOR FOUND"
 I ACRV,ACRCEIN'[111111111,'$D(^ACRZ("VNDR",ACRV)) D
 .Q:ACRCTYP="TR"                          ;DON'T WANT TRAVEL VENDORS
 .D CKVEND^ACRFUFMU(ACRV)
 .S ACRSTR="CORE VENDOR FOUND"_U_U_U_ACRCORE_U_U
 .D SETVND
 ;
 ;GOVTRIP  *************************
 I ACRGTRIP D  Q
 .S ^ACRZ("GTRIP",ACR)="NO HIT GOV TRIP"_U_ACRCORE_U_ACRERR
 .S ACRGTOT=ACRGTOT+1
 ;
 ;ARMS TRAVEL/AIRLINE  *************
 I ACRCTYP="TR"!(ACRCTYP="AT") D  Q       ;CAPTURE TRAVEL/AIRLINE
 .Q:$D(^ACRZ("TR",ACR))
 .S ^ACRZ("TR",ACR)="NO HIT TRAVEL"_U_U_U_U_ACRCORE
 .S ACRTRTOT=ACRTRTOT+1
 ;
 ;GRANTS  **************************
 I ACRCTYP="GR"!(ACRCTYP="PM") D  Q
 .S ^ACRZ("GR",ACR)="NO HIT GRANT"_U_ACRCORE_U_ACRERR
 .S ACRGRTOT=ACRGRTOT+1
 ;
 ;NOHIT -- LEFTOVERS  **************
 S ^ACRZ("NOHIT",ACR)="NO HIT UNKNOWN"_U_ACRCORE_U_ACRERR
 S ACRTCNT=ACRTCNT+1
 Q
 ; *********************************
TOTAL ;SET TOTALS ***********************
 S ^ACRZ("TOTALS","TOTAL")=ACRAMT         ;Total amount from all CORE Docs
 S ^ACRZ("ACRDOC","TOTAL")=ACRDCNT        ;# of matched documents w/Vendor
 S ^ACRZ("VNDR","TOTAL")=ACRVCNT          ;# of unique Vendors
 S ^ACRZ("NOHIT","TOTAL")=ACRTCNT         ;# of Unidentified No Hits
 S ^ACRZ("NOMATCH","TOTAL")=ACRMCNT       ;# of Hits with No Match
 S ^ACRZ("NOVNDR","TOTAL")=ACRZCNT        ;# of matched Documents w/o Vendors
 S ^ACRZ("ERR","TOTAL")=ACRECNT           ;# of Vendors with Errors
 S ^ACRZ("PAY","TOTAL")=ACRPCNT           ;# of Payroll documents (No Hit)
 S ^ACRZ("GTRIP","TOTAL")=ACRGTOT         ;# of GovTrip documents (No Hit)
 S ^ACRZ("CHS","TOTAL")=ACRCHST           ;# of CHS documents (No Hit)
 S ^ACRZ("TR","TOTAL")=ACRTRTOT           ;# of non-GovTrip Travel documents
 S ^ACRZ("GR","TOTAL")=ACRGRTOT           ;# of Grants documents (No Hit)
 Q
 ; *********************************
 ; *********************************
SETCORE ; SET VARIABLES FROM CORE FILE STRING
 S (ACRV,ACRCDOC,ACRREQ,ACRSTR)=""
 S ACRGTRIP=0
 S ACRCORE=^ACRZ("ACRCORE",ACR)
 S ACRCTYP=$P(ACRCORE,U,2)                      ;CORE DOCUMENT TYPE
 S ACRCAMT=$P(ACRCORE,U,7)                      ;CORE DOLLAR AMOUNT
 S ACRAMT=ACRAMT+ACRCAMT                        ;TOTAL ALL AMOUNTS FOR AREA
 ;
 I ACRCTYP="PR" D  Q                            ;DON'T WANT PAYROLL ************
 .S ^ACRZ("PAY",ACR)="PAYROLL"_U_ACRCORE
 .S ACRPCNT=ACRPCNT+1
 ;
 S ACRCDOC=$P(ACRCORE,U,3)                       ;CORE DOCUMENT NUMBER
 I $E(ACRCDOC,1,3)="HHS",$L(ACRCDOC)>19 D
 .S ACRCDOC=$E(ACRCDOC,11,25)                    ;CHECK FOR EXTENSION DOC NUMBERS
 ;
 S:ACRCTYP="AT" ACRCTYP="TR"                     ;CHANGE AIRLINE TO TRAVEL
 I ACRCTYP="TR"!(ACRCTYP="TN") D                 ;CHECK GOVTRIP TRAVEL DOC
 .F I="CB","TA","RM" I $E(ACRCDOC,9,10)=I S ACRGTRIP=1
 .S MRSTR=$G(MRSTR)+1                            ;COUNT TRAVEL
 ;
 S ACRCAP=$P(ACRCORE,U)                          ;CORE ACCOUNTING POINT
 S ACRCFY=$P(ACRCORE,U,4)                        ;CORE FISCAL YEAR
 S ACRCCAN=$P(ACRCORE,U,5)                       ;CORE CAN
 S ACRCOCC=$P(ACRCORE,U,6)                       ;CORE OBJECT CLASS CODE
 S ACRCREF=$P(ACRCORE,U,8)                       ;CORE REFERENCE CODE
 S ACRCEIN=$P(ACRCORE,U,9)                       ;CORE VENDOR EIN
 S ACRAP=$E(ACRCCAN,2,3)                         ;GET ACTUAL AP FROM CAN
 S ACRCHS=$$CHS^ACRFUFMU                         ;SET CHS FLAG
 Q
 ;
 ; ***********************************
HITDOC(ACRDOC) ;FOUND CORE DOCUMENT NUMBER IN ARMS FMS DOCUMENT FILE
 ;
 ; - Enters with: ACRCDOC = CORE document number
 ;    
 ;      ACRCORE VARIABLES FROM string from CORE file   
 ;
 N ACRDA,ACRREQ,ACRXZ
 F ACRXZ="B","C" D  Q:ACRMATCH
 .Q:'$D(^ACRDOC(ACRXZ,ACRDOC))
 .S ACRDA=0
 .F  S ACRDA=$O(^ACRDOC(ACRXZ,ACRDOC,ACRDA)) Q:'ACRDA  D  Q:ACRMATCH
 ..S ACRMATCH=$$MATCHDOC(ACRDA)
 Q
 ;
 ; ***********************************
MATCHDOC(ACRDA)         ;Check ARMS against CORE
 ;
 ;----- LOOP THROUGH PO ITEMS IN FMS SUPPLIES AND SERVICES FILE
 ;      AND MATCH WITH CORE DATA
 ;    Enters with: ACRDOCDA = FMS Document file IEN
 ;                 ACRCOCC  = CORE OCC
 ;                 ACRCFY   = CORE Fiscal Year
 ;                 ACRCCAN  = CORE CAN
 ;                 ACRCEIN  = CORE VENDOR EIN
 ;                 ACRFY    = ARMS
 ;                 ACROCC   = ARMS OCC
 ;                 ACRCAN   = ARMS CAN
 ;    Returns:  0 = No match
 ;              1 = Match
 ;                
 N ACRCANDA,ACRCAN,ACRSS0,ACRIDA,ACRDEPT,ACROCCDA,ACROCC,ACRFY
 N ACRRFIN,ACRIFIN,ACRID
 K ACRXX
 S (ACRCAN,ACROCC)=""
 S (ACRMATCH,ACRHIT)=0
 S ACRDOC0=$G(^ACRDOC(ACRDA,0))
 S ACRREQ=$P(ACRDOC0,U)                             ;REQUISITION/TRAVEL NUMB
 S ACRCC=$P(ACRDOC0,U,4)                            ;REQUEST TYPE
 ;GET VENDOR FROM DOCUMENT OR THE CREDIT CARD DEFAULT VENDOR
 S ACRV=$S(ACRCC=35:$$CCVEN^ACRFUFMU,1:$$VENDOR^ACRFUFMU(ACRDA))
 I ACRV,'ACRCHS,ACRCTYP="TR" S ACRV=0               ;DON'T WANT TRAVELER
 S ACRID=$P(ACRDOC0,U,14)
 S ACRSTR=ACRREQ_U_$$DOCDT^ACRZFFU(ACRDA)_U_ACRID   ;DOC DAT,IDENTIFIER
 F ACRX="C","J" D  Q:ACRHIT
 .S ACRIDA=0
 .F  S ACRIDA=$O(^ACRSS(ACRX,ACRDA,ACRIDA)) Q:'ACRIDA  D
 ..S ACRSS0=$G(^ACRSS(ACRIDA,0))
 ..S ACRSS0=$TR(ACRSS0,"""")
 ..S ACROCCDA=$P(ACRSS0,U,4)          ;OBJECT CLASS CODE
 ..S ACRCANDA=$P(ACRSS0,U,5)          ;COMMON ACCOUNTING NUMBER
 ..S ACRDEPT=$P(ACRSS0,U,6)
 ..S ACRFY=$$FYFUN^ACRFUTL1(ACRDEPT)
 ..D PIECE^ACRFUFMU
 ..S ACRMATCH=$$MATCH^ACRFUFMU        ;LOOK FOR FY,CAN,OCC MATCH
 ..I ACRMATCH D
 ...D ITEMS^ACRFUFMI(ACRCDOC,ACRIDA,ACRCORE,.ACRRFIN,.ACRIFIN,.ACRHIT) ;SETS ITEMS INTO ^ACRZ("ITEMS"
 .I ACRHIT D SET
 .I 'ACRHIT D SETCK^ACRFUFMU("NO MATCH DOC",ACR)
 Q ACRHIT
 ;
 ; ***********************************
SET ;EP; SET ACRZ(NODE,# WITH MATCHED DATA
 ; ENTERS WITH DATA STRING FROM
 ;   FMS DOCUMENT FILE or
 ;   1166 APPROVALS FOR PAYMENT FILE or
 ;   FMS DOCUMENT HISTORY RECORD FILE
 ; ACRV = VENDOR FILE IEN
 ;
 S ACRMATCH=1
 I ACRV'>0 S ACRV=$$VEN^ACRFUFMU(ACRCEIN)        ;CHECK CORE VENDOR
 S ACRERR=$S(ACRV>0:$$CKVEND^ACRFUFMU(ACRV),1:"") ;CHECK FOR VENDOR ERRORS
 S:ACRERR="" ACRERR="NO VENDOR ERRORS"
 S ACRSTR=ACRSTR_U_ACRCORE_U_ACRRFIN_U_ACRIFIN ;ADD ARMS RR & INVOICE STATUS
 ;
 ; TRAVEL ****************************
 I ACRCTYP="TR"!(ACRCTYP="AT") D  Q
 .S MSG=$S(ACRV>0:$$VNAME^ACRFUFMU(ACRV),1:"TRAVELLER")
 .S ^ACRZ("TR",ACR)=MSG_U_ACRSTR_U_ACRERR
 .D SETVND
 .S ACRTRTOT=ACRTRTOT+1
 .D SETCK^ACRFUFMU(MSG,ACR)
 ;
 ; NO VENDOR IN ARMS *****************
 I ACRV=0 D  Q
 .S ^ACRZ("NOVNDR",ACR)="NO VENDOR"_U_ACRSTR
 .I ACRCEIN'["1111111111" D
 ..S ^ACRZ("CEIN",ACR)=ACRCEIN_"/NO IHS"_U_ACRCORE ;CAPTURE CORE VENDOR EIN FOR DOCUMENT
 .S ACRZCNT=ACRZCNT+1
 .D SETCK^ACRFUFMU("",ACR)
 ;
 ; ARMS MATCH WITH VENDOR ************
 D SETVND
 S ^ACRZ("ACRDOC",ACR)=ACRSTR
 S ACRDCNT=ACRDCNT+1
 D SETCK^ACRFUFMU("",ACR)
 Q
SETVND ;EP - SET STRING INTO VNDR NODE *********
 Q:ACRV'>0
 S ACRAPV=ACRAP_"-"_ACRV
 S ACRASV=ASUFAC_"-"_ACRV
 S:ACRERR="" ACRERR="NO VENDOR ERRORS"
 S ACRVNAM=$$VNAME^ACRFUFMU(ACRV)
 S ACREIN=$$EIN^ACRFUFMU(ACRV)
 S ACRSFX=$$SFX^ACRFUFMU(ACRV)
 S ACRSTR=ACRAPV_U_ACRASV_U_ACRVNAM_U_ACREIN_U_ACRSFX_U_ACRSTR_U_ACRERR  ;ADD VENDOR INFORMATION
 Q:$D(^ACRZ("VNDR",ACRV))                    ;SET STRING AND QUIT IF FOUND
 S ^ACRZ("VNDR",ACRV)=ACRSTR                 ;SET VNDR
 S ACRVCNT=ACRVCNT+1
 I ACRERR'["NO VENDOR ERRORS" D
 .S ACRECNT=ACRECNT+1
 .S ^ACRZ("ERR",ACR)=ACRSTR
 Q
 ; ***********************************
CHSSET(ACR) ;EP;
 S ^ACRZ("CHS",ACR)="NO HIT CHS"_U_ACRCORE
 S ACRCHST=ACRCHST+1
 Q
 ; ***********************************
REQ() ;BUILD ORIGINAL REQUISITION NUMBER
 N ACRCANDA,ACRLOCDA,ACRLOC
 S ACRCANDA=$O(^AUTTCAN("B",ACRCCAN,0))
 I ACRCANDA="" Q 0                        ;NOT IN COMMON ACCOUNTING NUM FILE
 S ACRLOCDA=$P($G(^AUTTCAN(ACRCANDA,0)),U,6)
 I ACRLOCDA="" S ACRLOCDA=$P($G(^ACRCAN(ACRCANDA,0)),U,7)
 I ACRLOCDA="" Q 0                       ;NO LOCATION POINTER
 S ACRLOC=$P(^AUTTLCOD(ACRLOCDA,0),U)
 S ACRREQ=$E(ACRLOC)_$E(ACRCDOC,1,2)_"-"_$E(ACRCDOC,3,5)_"-"_$E(ACRCDOC,6)_"-"_$E(ACRCDOC,7,10)
 I '$D(^ACRDOC("B",ACRREQ)) S ACRREQ="" Q 0        ;NOT IN DOC FILE
 Q 1
