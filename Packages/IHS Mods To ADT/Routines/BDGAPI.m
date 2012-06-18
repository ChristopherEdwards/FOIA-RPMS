BDGAPI ; IHS/ANMC/LJF - PATIENT MOVEMENT API'S ;  [ 09/26/2002  12:59 PM ]
 ;;5.3;PIMS;**1010**;APR 26, 2002
 ;
 ;cmi/flag/maw 08/31/2009 PATCH 1010 changed references of UB92 to UB04
 ;
 ; Calls to be made:  S ERR=$$ADD^BDGAPI(.ARRAY)
 ;                    S ERR=$$CANCEL^BDGAPI(.ARRAY)
 ;                    S ERR=$$EDIT^BDGAPI(.ARRAY)
 ;
 ; Input: BDGR array that can be changed but is not killed
 ;         passed by reference
 ;
 ; Output: returns error status
 ;         ="" means all went well
 ;         =1^MESSAGE means event stored but one or more required
 ;               fields were not filed; original value of those fields
 ;               in error message
 ;         =2^MESSAGE means event was NOT stored; one or more required
 ;               fields could not be filed
 ;
 ;Incoming Array BDGR has the following definition:
 ; ALWAYS REQUIRED:
 ;  BDGR("PAT")   = patient ien
 ;  BDGR("TRAN")  = transaction type (1=admit, 2=ward transfer, 
 ;                  3=discharge, 4=check-in lodger, 5=check-out lodger,
 ;                  6=service transfer)
 ;  BDGR("DATE")  = date/time for movement, in FM or external format
 ;  BDGR("USER")  = user who entered movement
 ;
 ; CONDITIONALLY REQUIRED:
 ;  if editing or canceling -
 ;  BDGR("ACCT")  = outside account number for linking to visit
 ;
 ;  if admission -
 ;  BDGR("UBAS")  = 1-digit UB92 admit source code, valid 1-9 & A
 ;    BDGR("ADMT")  = 1-digit IHS admission code, created from UBAS
 ;  BDGR("ADX")   = admitting dx, free text to 30 characters, no ";"
 ;  BDGR("ACCT")  = external account # - to be passed to PCC on add
 ;
 ;  if ADMT=2 or 3 on admission or DSCT=2 on discharge
 ;  BDGR("TFAC")  = transfer facility (in or out), name or ien
 ;
 ;  if admission or ward transfer
 ;  BDGR("WARD")  = ward location, name or ien
 ; 
 ;  if admission or service transfer
 ;  BDGR("SRV")   = treating specialty, 2-digit IHS code (file 45.7)
 ;  BDGR("ADMD")  = admitting physician, IHS ADC code or name
 ;  BDGR("PRMD")  = primary provider, IHS ADC code or  name
 ;                    if not sent, will be stuffed with attending
 ;  BDGR("ATMD")  = attending provider, IHS ADC or code
 ;
 ;  if discharge
 ;  BDGR("DSCT")  = internal entry number in file 405.1
 ;
 ; OPTIONAL:
 ;  if admission
 ;  BDGR("UBAT")  = 1-digit UB92 admission code, valid values 1-4
 ;  BDGR("REFP")  = referring provider, free text, up to 30 characters
 ;
 ;  if admission or ward transfer
 ;  BDGR("ROOM")  = room/bed, formatted free text (room-bed)
 ;
 ;  if discharge
 ;  BDGR("UBDS")  = 1-2 digit UB92 disch status code, valid 1-7,10,20,30
 ;
 ; New variable set and passed back
 ;  BDGR("VIEN")  = visit ien
 ;
ADD(BDGR) ;PEP; silent API to add patient movement entries to file 405
 NEW DGQUIET,BDGAPI,ERR
 S DGQUIET=1                                   ;must be in quiet mode
 S BDGAPI=1                                    ;let DGPMV rtns know using API
 I $G(DUZ("AG"))="" Q 2_U_"Agency not set"     ;must have agency set to IHS
 ;
 S ERR=$$CHECK(.BDGR) I ERR Q ERR   ;check common req fields
 ;
 D @BDGR("TRAN")
 Q $G(ERR)
 ;
 ;
1 ; add admission
 NEW DGPMT,DFN,I,DGPMY,DGPMCA,DGPMSA,DGPMUC,DGPMN,HRCN,VA
 S DGPMT=BDGR("TRAN"),DGPMP="",DFN=BDGR("PAT"),ERR=""
 D PID^VADPT6    ;to set HRCN
 S DGPMN=1   ;prevents date from being asked
 ;
 L +^DGPM(0):300
 ;6/19/2002 LJF9 (per Linda) change errors to warnings.
 ;I $G(^DPT(DFN,.1))]"" S ERR=2_U_"Patient already admitted; cannot add new one" L -^DGPM(0) Q
 I $G(^DPT(DFN,.1))]"" S ERR=1_U_"Patient already admitted; cannot add new one" L -^DGPM(0) Q
 ; check admission fields for validity
 F I="DATE","WARD","SRV","ADMT","ADX","ADMD","ATMD" D @I I +ERR=2 L -^DGPM(0) Q
 I +ERR=2 L -^DGPM(0) Q   ;at least one required field failed check
 ;
 ;
 ; if enough fields are okay, create event
 S BDGR("DATE")=BDGR("ADMIT DATE")   ;reset date for service entry
 S DGPMY=BDGR("ADMIT DATE"),DGPMCA="",DGPMSA=0
 D UC^DGPMV  ; sets DGPMUC = transaction type external format
 D ^DGPMV3
 L -^DGPM(0)
 I '$D(^DGPM("APTT1",DFN,BDGR("ADMIT DATE"))) S ERR=2_U_"Admission NOT added for date: "_BDGR("ADMIT DATE") Q
 ;
 ; add account number if sent to PCC visit
 NEW DA,DIE,DR
 S DA=$$GET1^DIQ(405,+$O(^DGPM("APTT1",DFN,BDGR("ADMIT DATE"),0)),.27,"I")
 I DA S DIE="^AUPNVSIT(",DR="1211///"_BDGR("ACCT") D ^DIE
 S BDGR("VIEN")=+$G(DA)   ;pass back visit to calling routine
 Q
 ;
2 ; add transfer
 NEW DGPMT,DFN,I,DGPMY,DGPMCA,DGPMSA,DGPMUC,DGPMN,DGPMAN,BDGCA,BDGV
 S DGPMT=BDGR("TRAN"),DGPMP="",DFN=BDGR("PAT"),ERR=""
 NEW HRCN,VA D PID^VADPT
 S DGPMN=1   ;prevents date from being asked
 ;
 ; find corresponding admission
 D FINDADM^BDGAPI2
 I 'BDGCA S ERR=2_U_"No corresponding admission found for transfer date: "_BDGR("DATE") Q
 S DGPMCA=BDGCA
 S X=$$GET1^DIQ(405,DGPMCA,.17,"I")
 S Y=$S(X="":"",1:$$GET1^DIQ(405,X,.01,"I"))
 I Y]"",(Y<BDGR("DATE")) S ERR=2_U_"Cannot add transfer for "_BDGR("DATE")_"; patient discharged at "_Y_"  IEN ="_X Q
 I +$G(^DGPM(DGPMCA,0))>BDGR("DATE") S ERR=2_U_"Cannot add transfer for "_BDGR("DATE")_"; patient admitted at "_$P(^DGPM(DGPMCA,0),U)_"  IEN ="_X Q
 ;
 ; check transfer fields for validity
 NEW BDGRM S BDGRM=BDGR("ROOM")   ;save orignal room value
 F I="DATE","WARD" D @I I +ERR=2 Q
 I +ERR=2 Q   ;at least one required field failed check
 ;
 ; if ward did not change, assume switch bed
 I $G(^DPT(DFN,.1))=BDGR("WARD") D BED Q
 ;
 ; if enough fields are okay, create event
 S DGPMY=BDGR("DATE"),DGPMAN=$G(^DGPM(DGPMCA,0))
 D UC^DGPMV  ; sets DGPMUC = transaction type external format
 D ^DGPMV3
 I '$D(^DGPM("APTT2",DFN,BDGR("DATE"))) S ERR=2_U_"Transfer NOT added for date: "_BDGR("DATE")
 Q
 ;
3 ; add discharge
 NEW DGPMT,DFN,I,DGPMY,DGPMCA,DGPMSA,DGPMUC,DGPMN,DGPMAN,RVDT,X
 S DGPMT=BDGR("TRAN"),DGPMP="",DFN=BDGR("PAT"),ERR=""
 NEW HRCN,VA D PID^VADPT
 S DGPMN=1   ;prevents date from being asked
 ;
 ; find corresponding admission
 S X=$O(^DGPM("APTT1",DFN,BDGR("DISCHARGE DATE")),-1)
 I X S DGPMCA=$O(^DGPM("APTT1",DFN,X,0))
 I ('X)!('$G(DGPMCA)) S ERR=2_U_"No corresponding admission found for discharge date: "_BDGR("DISCHARGE DATE") Q
 ;
 ; check if admission has discharge already
 ;6/19/2002 LJF9 (per Linda) change errors to warnings
 ;S X=$P($G(^DGPM(DGPMCA,0)),U,17) I X,$G(^DGPM(X,0)) S ERR=2_U_"Admission already discharged; cannot add another." Q
 S X=$P($G(^DGPM(DGPMCA,0)),U,17) I X,$G(^DGPM(X,0)) S ERR=1_U_"Admission already discharged: cannot add another." Q
 ;
 S RVDT=9999999.9999999-BDGR("DISCHARGE DATE")
 S X=$O(^DGPM("APMV",DFN,DGPMCA,0)) I X<RVDT S ERR=2_U_"Discharge earlier than last ward transfer" Q
 S X=$O(^DGPM("ATS",DFN,DGPMCA,0)) I X<RVDT S ERR=2_U_"Discharge earlier than last service transfer" Q
 ;
 ; check discharge fields for validity
 F I="DATE","DSCT" D @I I +ERR=2 Q
 I +ERR=2 Q   ;at least one required field failed check
 ;
 ; if enough fields are okay, create event
 S DGPMY=BDGR("DISCHARGE DATE"),DGPMAN=$G(^DGPM(DGPMCA,0))
 D UC^DGPMV  ; sets DGPMUC = transaction type external format
 D ^DGPMV3
 I '$D(^DGPM("APTT3",DFN,BDGR("DISCHARGE DATE"))) S ERR=2_U_"Discharge NOT added for date: "_BDGR("DISCHARGE DATE")
 Q
 ;
6 ; add treating specialty transfer
 NEW DGPMT,DFN,I,DGPMY,DGPMCA,DGPMSA,DGPMUC,DGPMN,DGPMAN,BDGCA,BDGV
 S DGPMT=BDGR("TRAN"),DGPMP="",DFN=BDGR("PAT"),ERR=""
 NEW HRCN,VA D PID^VADPT
 S DGPMN=1   ;prevents date from being asked
 ;
 ; find corresponding admission
 D FINDADM^BDGAPI2
 I 'BDGCA S ERR=2_U_"No corresponding admission found for service transfer date: "_BDGR("DATE") Q
 S DGPMCA=BDGCA
 ;
 S X=$$GET1^DIQ(405,DGPMCA,.17,"I")
 I X S X=$$GET1^DIQ(405,X,.01,"I")
 I X]"",(X<BDGR("DATE")) S ERR=2_U_"Cannot add service transfer for "_BDGR("DATE")_"; patient discharged at "_X Q
 I +$G(^DGPM(DGPMCA,0))>BDGR("DATE") S ERR=2_U_"Cannot add service transfer for "_BDGR("DATE")_"; patient admitted at "_$P(^DGPM(DGPMCA,0),U) Q
 ;
 ; check service transfer fields for validity
 F I="DATE","SRV","ATMD" D @I I +ERR=2 Q
 I +ERR=2 Q   ;at least one required field failed check
 ;
 ;
 ; if enough fields are okay, create event
 S DGPMY=BDGR("DATE"),DGPMAN=$G(^DGPM(DGPMCA,0))
 D UC^DGPMV  ; sets DGPMUC = transaction type external format
 D ^DGPMV3
 I '$D(^DGPM("APTT6",DFN,BDGR("DATE"))) S ERR=2_U_"Service transfer NOT added for date: "_BDGR("DATE")
 Q
 ;
EDIT(BDGR) ;PEP; silent API to edit patient movement entry in file 405
 Q $$EDIT^BDGAPI2(.BDGR)
 ;
CANCEL(BDGR) ;PEP; silent API to cancel patient movement entry in file 405
 Q $$CANCEL^BDGAPI1(.BDGR)
 ;
 ;
DATE ; check event date field
 NEW DATE S DATE=$S(BDGR("TRAN")=1:BDGR("ADMIT DATE"),BDGR("TRAN")=3:BDGR("DISCHARGE DATE"),1:BDGR("DATE"))
 I $D(^DGPM("APTT"_BDGR("TRAN"),DFN,DATE)) S ERR=2_U_"Cannot add event; already there"
 Q
 ;
WARD ; -- check ward and room-bed
 NEW X,DIC,Y
 ; check required ward
 S X=$G(BDGR("WARD")),DIC=42,DIC(0)="M"
 S DIC("S")="I $P($G(^BDGWD(+Y,0)),U,3)=""A""" D ^DIC
 I Y=-1 S ERR=2_U_"Ward error: "_BDGR("WARD") Q
 ;
 ; check optional room-bed
 S X=$G(BDGR("ROOM")) I X]""  D
 . K DIC S DIC=405.4,DIC(0)="M" D ^DIC
 . I Y<1 S ERR=ERR_1_U_"Invalid room-"_BDGR("ROOM")_U,BDGR("ROOM")="" Q
 . I $D(^DPT("RM",BDGR("ROOM"))),'$D(^DPT("RM",BDGR("ROOM"),DFN)) S ERR=ERR_1_U_"Room-bed already occupied: "_BDGR("ROOM")_U,BDGR("ROOM")=""
 Q
 ;
SRV ; -- check service (screen for active admitting services)
 NEW X,DIC,Y
 ; check if observation event has observation type service
 I $G(BDGR("MINOR TYPE"))="V",BDGR("SRV")'["O" S BDGR("SRV")=BDGR("SRV")_"O"
 ;
 S X=$G(BDGR("SRV")),DIC=45.7,DIC(0)="M"
 S DIC("S")="I $$ACTIVE^DGACT(45.7,+Y,BDGR(""DATE""))" D ^DIC
 I Y<1 S ERR=2_U_"Invalid Service: "_BDGR("SRV")
 Q
 ;
ADMT ; -- check admit types/source
 NEW X,DIC,Y
 ; check required ub92 admission source
 S X=$G(BDGR("UBAS")) I X="" S ERR=2_U_"Admission Source Missing" Q
 K DIC S DIC=9999999.53,DIC(0)="M" D ^DIC
 I Y<1 S ERR=2_U_"Invalid Admission Source: "_BDGR("UBAS") Q
 ;
 ; IHS admit type derived from admission source
 S X=$$GET1^DIQ(9999999.53,+Y,.03,"I")   ;crosswalk to IHS admit type
 I $$GET1^DIQ(405.1,+X,.02,"I")=1 S BDGR("ADMT")=$$GET1^DIQ(405.1,+X,9999999.1)
 I '$G(BDGR("ADMT")) S ERR=2_U_"IHS Admit Type INVALID: BDGR(UBAS)="_BDGR("UBAS") Q
 ;
 I (BDGR("ADMT")=2)!(BDGR("ADMT")=3)!(BDGR("UBAS")=7) D  Q:+ERR=2
 . ;
 . S X=$G(BDGR("TFAC")) I X="" D  Q
 .. Q:BDGR("UBAS")=7               ;not required if source is ER
 .. S ERR=2_U_"Transfer Facility Missing" Q
 . ;
 . K DIC S DIC=9999999.91,DIC(0)="M"
 . S DIC("S")="I $P(^AUTTTFAC(+Y,0),U,2)=""""" D ^DIC
 . I Y<1 S ERR=2_U_"Invalid Transfer Facility: "_BDGR("TFAC")
 . ;
 . I BDGR("UBAS")=7 S BDGR("ADMT")=2  ;reset transfer via ER
 ;
 ; check optional ub04 admit type
 S X=$G(BDGR("UBAT")) I X]"" D
 . I X=9 S BDGR("UBAT")="" Q
 . I (X<1)!(X>4) S ERR=ERR_1_U_"Invalid UB04 Admit Type: "_$G(BDGR("UBAT"))_U,BDGR("UBAT")=""  ;cmi/maw 08/31/2009 PATCH 1010
 Q
 ;
DSCT ; -- check discharge types
 NEW X,DIC,Y
 S BDGR("DSCT")=+BDGR("DSCT")
 ; check required IHS discharge type
 S X=$G(BDGR("DSCT")),DIC=405.1,DIC(0)="M"
 S DIC("S")="I $P(^DG(405.1,+Y,0),U,2)=3" D ^DIC
 I Y<1 S ERR=2_U_"IHS Discharge Type Invalid: "_BDGR("DSCT") Q
 ;
 I (BDGR("DSCT")=13) D  Q:+ERR=2
 . S X=$G(BDGR("TFAC")) I X="" S ERR=2_U_"Transfer Facility Missing" Q
 . K DIC S DIC=9999999.91,DIC(0)="M"
 . S DIC("S")="I $P(^AUTTTFAC(+Y,0),U,2)=""""" D ^DIC
 . I Y<1 S ERR=2_U_"Invalid Transfer Facility: "_BDGR("TFAC")
 ;
 ; check optional ub04 discharge status
 S X=$G(BDGR("UBDS")) I X]"" D
 . I "^1^2^3^4^5^6^7^10^20^30"'[X S ERR=ERR_1_U_"Invalid UB04 Discharge Status: "_$G(BDGR("UBDS"))_U,BDGR("UBDS")=""  ;cmi/maw 08/31/2009 PATCH 1010
 Q
 ;
ADX ; check admitting dx
 NEW X
 S X=$G(BDGR("ADX")) I X="" S ERR=2_U_"Admitting Dx Missing" Q
 I $L(X)<3 S ERR=2_U_"Admitting dx too short: "_X Q
 I $L(X)>30 S ERR=2_U_"Admitting dx too long: "_X Q
 Q
 ;
ADMD ; check admitting and referring provider fields
 NEW X,DIC,Y
 ; check required admitting physician
 I $G(BDGR("ADMD"))="" S BDGR("ADMD")=$G(BDGR("ATMD"))
 S X=$G(BDGR("ADMD")) I X="" S ERR=2_U_"Admitting Provider Missing" Q
 S DIC=200,DIC(0)="M"
 S DIC("S")="I $D(^XUSEC(""PROVIDER"",+Y)),$P($G(^VA(200,+Y,""PS"")),U,4)="""""
 D ^DIC I Y<1 S ERR=2_U_"Invalid Admitting Provider: "_BDGR("ADMD") Q
 ;
 ; check optional referring provider
 S X=$G(BDGR("REFP")) Q:X=""
 I $L(X)<3 W ERR=ERR_1_U_"Referring Provider too short: "_X,BDGR("REFP")="" Q
 I $L(X)>30 W ERR=ERR_1_U_"Referring Provider too long: "_X,BDGR("REFP")=""
 Q
 ;
ATMD ; check attending and primary provider fields
 NEW X,DIC,Y
 ; check required attending physician
 S X=$G(BDGR("ATMD")) I X="" S ERR=2_U_"Attending Provider Missing" Q
 S DIC=200,DIC(0)="M"
 S DIC("S")="I $D(^XUSEC(""PROVIDER"",+Y)),$P($G(^VA(200,+Y,""PS"")),U,4)="""""
 D ^DIC I Y<1 S ERR=2_U_"Invalid Attending Provider: "_BDGR("ATMD") Q
 ;
 ; check primary provider (use attending if missing)
 S X=$G(BDGR("PRMD")) I X="" S BDGR("PRMD")=BDGR("ATMD") Q
 S DIC=200,DIC(0)="M"
 S DIC("S")="I $D(^XUSEC(""PROVIDER"",+Y)),$P($G(^VA(200,+Y,""PS"")),U,4)="""""
 D ^DIC I Y<1 S ERR=2_U_"Invalid Primary Provider: "_BDGR("PRMD") Q
 Q
 ;
CHECK(ARRAY) ; check common required fields
 NEW X,Y,%DT
 I '$G(BDGR("PAT")) Q 2_U_"Patient ID error"
 I ($G(BDGR("TRAN"))<1)!($G(BDGR("TRAN"))>6) Q 2_U_"Trans Code Error"
 S X=$G(BDGR("DATE")) I X'?7N1".".N D  I Y=-1 Q 2_U_"Date Error"
 . S %DT="RX" D ^%DT Q:Y=-1
 . S BDGR("DATE")=Y   ;reset date to FM format
 I $$GET1^DIQ(200,+$G(BDGR("USER")),.01)="" Q 2_U_"User Error"
 Q 0
 ;
BED ; switch bed
 I BDGRM'=BDGR("ROOM") Q                ;don't edit if lookup failed
 I BDGR("ROOM")="",BDGR("PROOM")="" Q   ;no change
 I $G(^DPT(DFN,.101))=BDGR("ROOM") Q  ;already in that bed
 I BDGR("ROOM")]"",$D(^DPT("RM",BDGR("ROOM"))) S ERR=ERR_1_U_"Room-bed already occupied: "_BDGR("ROOM")_U,BDGR("ROOM")="" Q
 ;
 ; rest of this code taken from ^DGSWITCH
 NEW DIE,DA,DR
 K ^UTILITY("DGPM",$J) S (DGSWITCH,DGOERR)=0,XQORQUIT=1 K ORACTION
 S DIE="^DGPM(",DR=".07///"_BDGR("ROOM")
 S:BDGR("ROOM")="" DR=".07///@"
 S DA=$$PRIORMVT^BDGF1(BDGR("DATE"),DGPMCA,DFN) Q:'DA
 S DGPMT=$$GET1^DIQ(405,DA,.02,"I")   ;equals 1 (admit) or 2 (transfer)
 D DIE^DGSWITCH,Q^DGSWITCH
 Q
