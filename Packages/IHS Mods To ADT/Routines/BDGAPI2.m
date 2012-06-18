BDGAPI2 ; IHS/ANMC/LJF - PATIENT MOVEMENT API'S ;  [ 09/26/2002  12:56 PM ]
 ;;5.3;PIMS;**1010**;APR 26, 2002
 ;
 ;cmi/flag/maw 08/31/2009 PATCH 1010 changed references of UB92 to UB04
 ;
 ; See BDGAPI for full details on variables
 ;
EDIT(BDGR) ;EP; silent API to edit patient movement entries to file 405
 NEW DGQUIET,BDGAPI,ERR,BDGCA,BDGN,BDGTRAN,VST,BDGV,BDGMVT,X
 S DGQUIET=1              ;must be in quiet mode
 S BDGAPI=1               ;let DGPMV rtns know using API
 ;
 S ERR=$$CHECK(.BDGR) I ERR Q ERR   ;check common req fields
 ;
 D FINDADM   ;find admission to edit
 ;
 ; if none found, try to add admission
 I ('BDGV),('BDGCA) S BDGR("TRAN")=1 Q $$ADD^BDGAPI(.BDGR)
 ;
 I '$G(BDGCA) Q 2_U_"Cannot find 405 entry for visit ien "_BDGV
 ;
 ; if no acct # on visit, add it now
 I BDGV,$$GET1^DIQ(9000010,BDGV,1211)="" D
 . S DA=BDGV,DIE="^AUPNVSIT(",DR="1211///"_BDGR("ACCT") D ^DIE
 ;
 ;
 ; now look for what was changed
 S BDGTRAN=""             ;will be reset to transaction if edit found
 ;
 ; if discharge date sent, assume editing discharge
 I BDGR("DISCHARGE DATE")]"" D  Q ERR
 . NEW BDGN S BDGN=$$GET1^DIQ(405,BDGCA,.17,"I")   ;discharge ien
 . ;  if not discharged yet, add one
 . I 'BDGN S BDGR("TRAN")=3 S ERR=$$ADD^BDGAPI(.BDGR) Q
 . ;  otherwise look for changes to discharge
 . I BDGR("DISCHARGE DATE")'=+$G(^DGPM(BDGN,0)) S BDGTRAN=3
 . ;8/26/2002 WAR per LJF27
 . ;I BDGR("DSCT")'=$$GET1^DIQ(405.1,+$$GET1^DIQ(405,BDGN,.04,"I"),9999999.1) S BDGTRAN=3
 . I BDGR("DSCT")'=$$GET1^DIQ(405,BDGN,.04,"I") S BDGTRAN=3  ;IHS/ANMC/LJF 9/12/2002 pointer sent, not ihs code
 . I BDGTRAN=3 D @BDGTRAN
 ;
 ; check admission data for changes
 NEW BDGRM S BDGRM=BDGR("ROOM")   ;save orignal room value
 I BDGR("ADMIT DATE")'=+^DGPM(BDGCA,0) S BDGTRAN=1
 I BDGR("UBAS")]"",BDGR("UBAS")'=$$GET1^DIQ(9999999.53,+$$GET1^DIQ(405,BDGCA,9999999.06,"I"),.02) S BDGTRAN=1
 I BDGR("UBAT")]"",BDGR("UBAT")'=$$GET1^DIQ(405,BDGCA,9999999.05,"I") S BDGTRAN=1
 I BDGR("TFAC")]"",BDGR("TFAC")'=$$GET1^DIQ(405,BDGCA,.05) S BDGTRAN=1
 I BDGR("ADMD")'=$$GET1^DIQ(405,+$$ADMTXN^BDGF1(BDGCA,BDGR("PAT")),9999999.02) S BDGTRAN=1
 I BDGTRAN=1 D @BDGTRAN Q ERR
 ;
 ; check last movement for ward or room changes
 S BDGTRAN=""
 S BDGN=$$PRIORMVT^BDGF1(BDGR("DATE"),BDGCA,BDGR("PAT"))
 S BDGMVT=$S(BDGN=BDGCA:1,1:2)  ;is movement admit or transfer
 I 'BDGN Q 2_U_"Cannot find last movement before event date; DATE="_BDGR("DATE")
 I BDGR("WARD")'=$$GET1^DIQ(405,BDGN,.06) S BDGTRAN=BDGMVT
 I BDGTRAN]"" D @BDGTRAN I ERR Q ERR
 ;
 ; check last service transfer for changes
 S BDGTRAN=""
 S BDGN=$$PRIORTXN^BDGF1(BDGR("DATE"),BDGCA,BDGR("PAT"))
 I 'BDGN Q 2_U_"Cannot find last service transfer for event date: "_BDGR("DATE")
 I BDGR("ATMD")'=$$GET1^DIQ(405,BDGN,.19) S BDGTRAN=6
 I BDGR("SRV")'=$$GET1^DIQ(45.7,+$$GET1^DIQ(405,BDGN,.09,"I"),9999999.01) S BDGTRAN=6
 I BDGTRAN=6,BDGR("DATE")=BDGR("ADMIT DATE") D 1 Q ERR
 I BDGTRAN=6 S BDGR("TRAN")=6 Q $$ADD^BDGAPI(.BDGR)
 ;
 I BDGR("ROOM")'=$G(^DPT(BDGR("PAT"),.101)) S DGPMCA=BDGCA,DFN=BDGR("PAT") D BED^BDGAPI
 ;
 Q $G(ERR)
 ;
 ;
1 ; edit admission
 NEW DGPMT,DGPMP,DFN,I,DGPMY,DGPMCA,DGPMSA,DGPMUC,DGPMN,BDGN,X
 S DGPMT=1,DFN=BDGR("PAT"),ERR="",DGPMN=0
 ;
 ; check admission fields for validity
 F I="WARD","SRV","ADMT","ADX","ADMD","ATMD" D @I I +ERR=2 Q
 I +ERR=2 Q   ;at least one required field failed check
 ;
 ; if enough fields are okay, edit admission
 S BDGR("DATE")=BDGR("ADMIT DATE")   ;"date" used by serv transfer
 S DGPMY=BDGR("ADMIT DATE"),(DGPMCA,DGPMDA,DA)=BDGCA,DGPMSA=0,DGPMOUT=0
 S DGPMP=$G(^DGPM(DGPMDA,0))        ;prior state of data
 D UC^DGPMV  ; sets DGPMUC = transaction type external format
 D VAR^DGPMV3,DR^DGPMV3
 Q
 ;
2 ; edit transfer
 NEW DGPMT,DGPMP,DFN,I,DGPMY,DGPMCA,DGPMSA,DGPMUC,DGPMN,DGPMAN
 S DGPMT=2,DGPMP="",DFN=BDGR("PAT"),ERR=""
 S DGPMN=1   ;prevents date from being asked
 S DGPMDA=BDGN,DGPMCA=BDGCA
 ;
 ;
 ; check transfer fields for validity
 F I="WARD" D @I I +ERR=2 Q
 I +ERR=2 Q   ;at least one required field failed check
 ;
 ; if enough fields are okay, edit event
 S DGPMY=BDGR("DATE"),DGPMAN=$G(^DGPM(DGPMCA,0))
 D UC^DGPMV  ; sets DGPMUC = transaction type external format
 D VAR^DGPMV3,DR^DGPMV3
 Q
 ;
3 ; add discharge
 NEW DGPMT,DGPMP,DFN,I,DGPMY,DGPMCA,DGPMSA,DGPMUC,DGPMN,DGPMAN
 S DGPMT=3,DGPMP="",DFN=BDGR("PAT"),ERR=""
 S DGPMN=1   ;prevents date from being asked
 S DGPMDA=BDGN,DGPMCA=BDGCA
 ;
 ;
 ; check discharge fields for validity
 F I="DSCT" D @I I +ERR=2 Q
 I +ERR=2 Q   ;at least one required field failed check
 ;
 ; if enough fields are okay, create event
 S DGPMY=BDGR("DISCHARGE DATE"),DGPMAN=$G(^DGPM(DGPMCA,0))
 ;
 ;6/19/2002 LJF9 (per Linda) change errors to warnings -next line was
 ;   already changed via LJF6
 I DGPMY<$P(DGPMAN,U) S ERR=2_U_"Discharge Date BEFORE Admission Date; Cannot Edit" Q  ;IHS/ANMC/LJF 5/31/2002 (per LJF6)
 ;
 D UC^DGPMV  ; sets DGPMUC = transaction type external format
 D VAR^DGPMV3,DR^DGPMV3
 Q
 ;
6 ; add treating specialty transfer
 NEW DGPMT,DGPMP,DFN,I,DGPMY,DGPMCA,DGPMSA,DGPMUC,DGPMN,DGPMAN
 S DGPMT=6,DGPMP="",DFN=BDGR("PAT"),ERR=""
 S DGPMN=1   ;prevents date from being asked
 S DGPMDA=BDGN,DGPMCA=BDGCA
 ;
 ; check service transfer fields for validity
 F I="SRV","ATMD" D @I I +ERR=2 Q
 I +ERR=2 Q   ;at least one required field failed check
 ;
 ; if transfer being edited is 1st one, use admit date for date
 I $P(^DGPM(DGPMDA,0),U,24)=DGPMCA S BDGR("DATE")=BDGR("ADMIT DATE")
 ;
 ; if enough fields are okay, create event
 S DGPMY=BDGR("DATE"),DGPMAN=$G(^DGPM(DGPMDA,0))
 D UC^DGPMV  ; sets DGPMUC = transaction type external format
 D VAR^DGPMV3,DR^DGPMV3
 Q
 ;
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
 Q:BDGR("UBAS")=""   ;if not sent with edit, don't check
 D ADMT^BDGAPI
 Q
 ;
DSCT ; -- check discharge types
 NEW X,DIC,Y
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
 S X=$G(BDGR("ADX")) I X="" Q
 I $L(X)<3 S ERR=2_U_"Admitting dx too short: "_X Q
 I $L(X)>30 S ERR=2_U_"Admitting dx too long: "_X Q
 Q
 ;
ADMD ; check admitting and referring provider fields
 NEW X,DIC,Y
 ; check required admitting physician
 Q:BDGR("ADMD")=""   ;if not sent with edit, don't check
 S X=$G(BDGR("ADMD")) I X="" S ERR=2_U_"Admitting Provider Missing" Q
 S DIC=200,DIC(0)="M"
 S DIC("S")="I $D(^XUSEC(""PROVIDER"",+Y)),$P($G(^VA(200,+Y,""PS"")),U,4)="""""
 D ^DIC I Y<1 S ERR=2_U_"Invalid Admitting Provider: "_BDGR("ADMD") Q
 ;
 ; check optional referring provider
 S X=$G(BGR("REFP")) Q:X=""
 I $L(X)<3 W ERR=ERR_1_U_"Referring Provider too short: "_X,BDGR("REFP")="" Q
 I $L(X)>30 W ERR=ERR_1_U_"Referring Provider too long: "_X,BDGR("REFP")=""
 Q
 ;
ATMD ; check attending and primary provider fields
 NEW X,DIC,Y
 ; check required attending physician
 Q:BDGR("ATMD")=""   ;if not sent with edit, don't check
 S X=$G(BDGR("ATMD")) I X="" S ERR=2_U_"Attending Provider Missing" Q
 S DIC=200,DIC(0)="M"
 S DIC("S")="I $D(^XUSEC(""PROVIDER"",+Y)),$P($G(^VA(200,+Y,""PS"")),U,4)="""""
 D ^DIC I Y<1 S ERR=2_U_"Invalid Attending Provider: "_BDGR("ATMD") Q
 ;
 ; check primary provider (use attending if missing)
 S X=$G(BGR("PRMD")) I X="" S BDGR("PRMD")=BDGR("ATMD") Q
 S DIC=200,DIC(0)="M"
 S DIC("S")="I $D(^XUSEC(""PROVIDER"",+Y)),$P($G(^VA(200,+Y,""PS"")),U,4)="""""
 D ^DIC I Y<1 S ERR=2_U_"Invalid Primary Provider: "_BDGR("PRMD") Q
 Q
 ;
CHECK(ARRAY) ; check common required fields
 NEW X,Y,%DT
 I '$G(BDGR("PAT")) Q 2_U_"Patient ID error"
 S X=$G(BDGR("DATE")) I X'?7N1".".N D  I Y=-1 Q 2_U_"Date Error"
 . S %DT="RX" D ^%DT Q:Y=-1
 . S BDGR("DATE")=Y   ;reset date to FM format
 I $$GET1^DIQ(200,+$G(BDGR("USER")),.01)="" Q 2_U_"User Error"
 Q ""
 ;
FINDADM ; find admission based on acct # or admit date or current status
 ;returns BDGV=visit ien & BDGCA=admission ien
 ;
 ; find visit based on acct #
 NEW VST,X
 S (VST,BDGV,BDGCA)=0
 F  S VST=$O(^AUPNVSIT("AXT",BDGR("ACCT"),VST)) Q:'VST  Q:BDGV  D
 . S X=$$GET1^DIQ(9000010,VST,.07,"I") I (X="H")!(X="O") D
 .. ;check to make sure acct # on correct patient
 .. I $P($G(^AUPNVSIT(VST,0)),U,5)=BDGR("PAT") S BDGV=VST
 ;
 ; if not found, try finding visit based on admit date
 I 'BDGV S BDGV=$$VISIT^BDGF1(+BDGR("PAT"),+BDGR("ADMIT DATE"))
 ;
 ; if visit found, find admit entry
 I BDGV S BDGCA=$O(^DGPM("AVISIT",BDGV,0))
 ;
 ; if still no visit found, try to find ADT event for admit date
 I 'BDGV D
 . S BDGCA=$O(^DGPM("AMV1",+BDGR("PAT"),+BDGR("ADMIT DATE"),0))
 ;
 ; if no admit entry found yet, use current entry
 I 'BDGCA S BDGCA=$G(^DPT(+BDGR("PAT"),.105))
 ;
 ; if admit entry found, but not visit, try file 405
 I BDGCA,'BDGV S BDGV=$$GET1^DIQ(405,BDGCA,.27,"I")
 ;
 Q
