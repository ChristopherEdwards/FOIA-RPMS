BLRAG09C ; IHS/MSC/SAT - LABORATORY ACCESSION GUI RPCS ; NOV 20, 2012
 ;;5.2;IHS LABORATORY;**1031**;NOV 01, 1997;Build 185
 ;from LA7SM
 ;  BLR REF LAB USING LEDI   - UL^BLRAG02      = return the value of the 'REF LAB USING LEDI?' field in the BLR MASTER CONTROL file
 ;  BLR ICD LOOKUP           - ICDLKUP^BLRAG07 = ICD code lookup
 ;  BLR ORDER REASON LKUP    - ORL^BLRAG07     = return order reasons from file 100.03
 ;  BLR PATIENT LOOKUP       - PTLK^BLRAG04    = Patient Lookup
 ;  BLR PRINTERS AVAILABLE   - DEVICE^BLRAG10  = return available printers from the DEVICE file
 ;  BLR USER LOOKUP          - NP^BLRAG06      = return entries from the NEW PERSON table 200 that are 'active'
 ;
 ;  BLR ACCESSION            - ACC^BLRAG05     = lab accession processor
 ;  BLR ACCESSION PRINT      - ABR^BLRAG02     = reprint accession label or manifest
 ;  BLR ALL NON-ACCESSIONED  - ANA^BLRAG01     = return all non-accessioned lab records
 ;  BLR ALL-ACCESSIONED      - ABD^BLRAG02     = return all accessioned records for given date range
 ;  BLR COLLECTION INFO      - BLC^BLRAG06     = check BLR PT CONFIRM parameter and return insurances for patient
 ;  BLR DELETE TEST          - DELTST^BLRAG08  = Cancel tests - Test are no longer deleted, instead the status is changed to Not Performed.
 ;  BLR ORDER/TEST STATUS    - LROS^BLRAG03    = return order/test status for given patient and date range
 ;
 ;  BLR SHIP CONF            - SC^BLRAG09A     = select a shipping configuration
 ;  BLR MANIFEST BUILD       - BM^BLRAG09B     = build a shipping manifest
 ;  BLR MANIFEST CLOSE/SHIP  - CLSHIP^BLRAG09C = Close/ship a shipping manifest
 ;  BLR MANIFEST DISPLAY     - DISP^BLRAG09G   = screen formatted text for manifest display
 ;  BLR MANIFEST START       - SMONLY^BLRAG09C = Start a shipping manifest only, no building
 ;  BLR MANIFEST TEST ADD    - ADDTEST^BLRAG09C= Add tests to an existing manifest\
 ;  BLR MANIFEST TEST REMOVE - REMVTST^BLRAG09C= Remove a test from manifest - actually flags test as "removed".
 ;  BLR MANIFEST TESTS TO ADD- TARPC^BLRAG09B  = return tests that can be added to a manifest
 ;
CLSHIP(BLRY,BLRSCFG,BLRSM,BLRCSF,BLRSHTIM,BLRDEV) ; Close/ship a shipping manifest
 ; BLR MANIFEST CLOSE/SHIP rpc
 ;INPUT:
 ; BLRSCFG  = (required) Shipping Configuration pointer to the
 ;             LAB SHIPPING CONFIGURATION file 62.9
 ; BLRSM    = (required) Shipping Manifest pointer to the
 ;             LAB SHIPPING MANIFEST file 62.8
 ; BLRCSF   = (optional) close/ship manifest flag
 ;             0=print manifest only (default)
 ;             1=close manifest
 ;             2=ship manifest
 ;              if manifest status=3 (closed), only ship or print manifest is allowed
 ; BLRSHTIM = Manifest Ship date/time in external format
 ; BLRDEV  = Printer for Manifest printing - IEN pointer to the DEVICE file
 ;             No printing will occur if null or undefined in the DEVICE file
 ;
 ;RETURNS:
 ; MESSAGE
 ;
 N BLRI
 D ^XBKVAR S X="ERROR^BLRAG09C",@^%ZOSF("TRAP")
 S BLRI=0
 K ^TMP("BLRAG",$J)
 S BLRY=$$TMPGLB^BLRAGUT()
 ;            0
 S @BLRY@(0)="ERROR_ID"
 ;
 N BLREF,BLRTXT
 S BLRTXT=""
 S (BLREF,BLREFF)=0
 D INIT
 ;I LA7QUIT D CLEANUP Q
 S LA7SM=BLRSM   ;manifest
 D LOCKSM
 I LA7QUIT D  Q
 . D UNLOCKSM,CLEANUP
 S LA7SM(0)=$G(^LAHM(62.8,+LA7SM,0))
 N DIR,DIROUT,DIRUT,DTOUT,DUOUT,MSG,X,Y
 S LA7ST=+$G(BLRCSF)
 I BLRCSF=1 D
 .D SMSUP^LA7SMU(LA7SM_U_$P(LA7SM(0),U,1),3,"SM04") ; Close manifest
 .S BLRTXT="MANIFEST "_$P(LA7SM(0),U,1)_" has been closed."
 I BLRCSF=2 D
 .D SHIP        ; Ship Manifest
 .I MSG'="" S BLRTXT=$S(BLRTXT'="":BLRTXT_" ",1:"")_MSG  ;LA7QUIT
 .S BLREFF=+BLREF
 ;print manifest
 I ('BLRCSF)!$G(BLRDEV) D DEV^BLRAG09F($G(BLRDEV))  ;print manifest
 I $P($G(BLREF),U,1)=-1 S BLRTXT=$S(BLRTXT'="":BLRTXT_" ",1:"")_" Error printing manifest# "_$P(LA7SM(0),U,1)_"." S BLREFF=1
 S:$G(BLREFF)'=1 @BLRY@(0)="MESSAGE"
 S BLRI=BLRI+1 S @BLRY@(BLRI)=BLRTXT
 D UNLOCKSM,CLEANUP
 Q
 ;
SHIP ; Ship a manifest only called from CLSHIP
 ; Used to flag shipping manifest for shipping
 ; If electronically connected -> transmit shipping manifest in HL7 message.
 N DIR,DIROUT,DIRUT,DTOUT,DUOUT,I,LA7I,LA7TCNT,X,Y
 ;
 S (LA7I,LA7TCNT)=0
 F  S LA7I=$O(^LAHM(62.8,+LA7SM,10,LA7I)) Q:'LA7I  D
 . I $$CHKTST^LA7SMU(+LA7SM,LA7I) Q
 . I $P($G(^LAHM(62.8,+LA7SM,10,LA7I,0)),"^",8)'=1 Q
 . S LA7TCNT=LA7TCNT+1 ; Test ready to ship.
 . D CHKREQI^LA7SM2(+LA7SM,LA7I)
 ;
 I 'LA7TCNT D  Q
 . S LA7QUIT=1
 . S MSG="No tests on shipping manifest - Shipping Aborted"
 . S BLREF=1
 ;
 I $G(LA7ERR) D  Q
 . S LA7QUIT=1
 . S MSG="Print shipping manifest for complete listing of errors"
 . S BLREF=1
 . ;D EN^DDIOL("The following errors were found - Shipping Aborted","","!?5")
 . ;S LA7X=""
 . ;F  S LA7X=$O(LA7ERR(LA7X)) Q:LA7X=""  D EN^DDIOL(LA7ERR(LA7X),"","!?5")
 . ;D EN^DDIOL("","","!")
 ;
 ;S DIR(0)="D^::EFRX",DIR("A")="Enter Manifest Shipping Date",DIR("B")="NOW"
 ;D ^DIR
 ;I $D(DIRUT) S LA7QUIT=1 Q
 S LA7SDT=$G(BLRSHTIM)
 D SMSUP^LA7SMU(LA7SM_U_$P(LA7SM(0),U,1),4,"SM05^"_LA7SDT)
 ;
 K LA7I
 S LA7I=0
 F  S LA7I=$O(^LAHM(62.8,+LA7SM,10,LA7I)) Q:'LA7I  D
 . S LA7I(0)=$G(^LAHM(62.8,+LA7SM,10,LA7I,0))
 . I $P(LA7I(0),"^",8)'=1 Q  ; Not "pending shipment".
 . ; Change status to "shipped".
 . S LA762801=LA7I_","_+LA7SM_","
 . S FDA(62.8,62.801,LA762801,.08)=2
 . D FILE^DIE("","FDA(62.8)","LA7DIE(2)")
 . ; Update event file
 . S LA7DATA="SM53^"_$$NOW^XLFDT_"^"_$P(LA7I(0),"^",2)_"^"_$P(LA7SM,"^",2)
 . D SEUP^LA7SMU($P(LA7I(0),"^",5),2,LA7DATA)
 ;
 ; Do tasking of transmission
 I $P($G(^LAHM(62.9,+LA7SCFG,0)),"^",7) D TASKSM
 ;
 Q
 ;
TASKSM ; Task electronic transmission of manifest  called from SHIP
 ;
 N ZTDTH,ZTIO,ZTRTN,ZTSAVE,ZTSK
 ;
 S ZTRTN="BUILD^LA7VORM1("""_+$P(LA7SM,"^")_""")",ZTDESC="E-Transmission of Lab Shipping Manifest"
 S ZTSAVE("LA7SM")="",ZTIO="",ZTDTH=$$NOW^XLFDT
 D ^%ZTLOAD
 ;
 S MSG="Electronic Transmission of Shipping Manifest "_$S($G(ZTSK):"queued as task# "_ZTSK,1:"NOT queued!")
 ;D EN^DDIOL(MSG,"","!?5")
 Q
 ;
ERR(BLRERR) ;Error processing
 ; BLRERR = Error text OR error code
 ; BLRI   = pointer into return global array
 D UNLOCKSM,CLEANUP
 S BLRI=BLRI+1
 S ^TMP("BLRAG",$J,BLRI)=BLRERR_$C(30)
 ;S BLRI=BLRI+1
 ;S ^TMP("BLRAG",$J,BLRI)=$C(31)
 Q
 ;
ERROR ;
 D ENTRYAUD^BLRUTIL("ERROR^BLRAG09C 0.0")  ; Store Error data
 NEW ERRORMSG
 S ERRORMSG="$"_"Z"_"E=""ERROR^BLRAG09C"""  ; BYPASS SAC Checker
 S @ERRORMSG  D ^%ZTER
 D ERR("RPMS Error")
 Q
 ;
ADDTEST(BLRY,BLRSCFG,BLRSM,BLRTAL) ; Add tests to an existing manifest
 ; BLR MANIFEST TEST ADD rpc
 ;INPUT:
 ; BLRSCFG = Shipping Configuration pointer to the
 ;            LAB SHIPPING CONFIGURATION file 62.9
 ; BLRSM  = Shipping Manifest pointer to the LAB SHIPPING MANIFEST
 ;           file 62.8
 ; BLRTAL = List of tests to be added to manifest separated by pipe:
 ;  TEST_IEN_":"_TEST_NAME_":"_UID_":"_EXT_ACC_#_":"_AREA_":"_DATE_":"
 ;  _ACC_#|...
 ;     TEST_IEN  = pointer to LABORATORY TEST file 60
 ;     TEST_NAME = Text from NAME field in LABORATORY TEST file 60
 ;     UID       = Test Unique ID
 ;     EXT_ACC_# = External accession number
 ;     AREA      = area pointer into file 68
 ;     DATE      = date pointer into file 68
 ;     ACC_#     = accession # pointer into file 68
 ;     PAT_DFN   = Patient IEN pointer to the VA Patient file 2
 ;     PAT_NAM   = Patient name
 ;     CONFIG_NAM = Shipping Configuration Name
 ;RETURNS:
 ; TEST_ON_MANIF ^ ADDABLE_TESTS
 ;  TESTS_ON_MANIF = List of tests on manifest separated by pipe:
 ;                   See MTL^BLRAG09A
 ;  ADDABLE_TESTS  = List of tests that can be added separated by pipe:
 ;                   See TA^BLRAG9B
 N BLRI
 D ^XBKVAR S X="ERROR^BLRAGUT",@^%ZOSF("TRAP")
 S BLRI=0
 K ^TMP("BLRAG",$J)
 S BLRY=$$TMPGLB^BLRAGUT()
 S @BLRY@(0)="ERROR_ID"
 ;
 N BLRJ,BLRTSTL
 N LA760,LA7AA,LA7AD,LA7AN,LA7BY,LA7DIV,LA7I,LA7UID,LA7X
 S LA7SCFG=BLRSCFG
 S LA7SM=BLRSM
 S BLRTSTL=""
 S LA7QUIT=0
 ;
 F BLRJ=1:1:$L(BLRTAL,"|") D
 .S LA760=$P($P(BLRTAL,"|",BLRJ),":",1)   ;test pointer to file 60
 .S LA7UID=$P($P(BLRTAL,"|",BLRJ),":",3)  ;UID
 .S LA7AA=$P($P(BLRTAL,"|",BLRJ),":",5)   ;accession area
 .S LA7AD=$P($P(BLRTAL,"|",BLRJ),":",6)   ;accession date
 .S LA7AN=$P($P(BLRTAL,"|",BLRJ),":",7)   ;accession number (internal)
 .S LA760(0)=$G(^LRO(68,LA7AA,1,LA7AD,1,LA7AN,4,LA760,0))   ;Test's zeroth node
 .I $P(LA760(0),"^",5) S LA7QUIT="1^Test already completed" Q  ; Test completed - skip
 .S LA76205=+$P(LA760(0),"^",2)   ; Test urgency
 .I LA76205>49 S LA76205=$S(LA76205=50:9,1:LA76205-50)
 .; Specimen type
 .S LA76805=0 S X=+$O(^LRO(68,LA7AA,1,LA7AD,1,LA7AN,5,0)) I X S LA76805=+$G(^LRO(68,LA7AA,1,LA7AD,1,LA7AN,5,X,0))
 .I $P($G(^LRO(68,LA7AA,1,LA7AD,1,LA7AN,0)),"^",2)=62.3 S LA7QUIT="1^Cannot select controls" Q  ; Don't build controls
 .S LA7I=0
 .F  S LA7I=$O(^LAHM(62.8,+LA7SM,10,"UID",LA7UID,LA7I)) Q:'LA7I  D  Q:LA7QUIT
 .. N X
 .. S X(0)=$G(^LAHM(62.8,+LA7SM,10,LA7I,0))
 .. I $P(X(0),"^",2)=LA760,$P(X(0),"^",8)'=0 S LA7QUIT="1^Test already on shipping manifest"
 .I LA7QUIT Q
 .D SCBLD^LA7SM1(+LA7SCFG)   ; Build TMP global with test profile
 .S LA7DIV=+$P($G(^LRO(68,LA7AA,1,LA7AD,1,LA7AN,.4)),"^")  ; Accession's division
 .D SCHK^LA7SM1   ; Check if test eligible for manifest
 .I 'LA7FLAG S LA7QUIT="1^Test not selectable for this configuration" Q
 .D LOCK68^LA7SMB
 .S LA7I=0
 .F  S LA7I=$O(LA7X(LA7I)) Q:'LA7I  D ADD^LA7SMB
 .D UNLOCK68^LA7SMB
 D MTL^BLRAG09A(.BLRTSTL,BLRSM) ;get tests already on manifest
 S BLRNTAL=$$TA^BLRAG09B(BLRSCFG,BLRSM)  ;get test that can be added to manifest
 ;            0              1
 S @BLRY@(0)="TESTS_ON_MANIF^ADDABLE_TESTS"
 S BLRI=BLRI+1 S @BLRY@(BLRI)=BLRTSTL_U_BLRNTAL
 Q
 ;
 ;
REMVTST(BLRY,BLRSM,BLRMTL) ; Remove a test from manifest - actually flags test as "removed".
 ; BLR MANIFEST TEST REMOVE rpc
 ;INPUT:
 ;   BLRSM      = Manifest IEN pointer to LAB SHIPPING MANIFEST file 62.8
 ;   BLRMTL      = List of manifest tests separated by pipe:
 ;                     TEST_IEN:TEST_NAME:TEST_SPEC_PTR|...
 ;                   TEST_IEN  = pointer to LABORATORY TEST file 60
 ;                   TEST_NAME = Text from NAME field in
 ;                                LABORATORY TEST file 60
 ;                   TEST_SPECIMEN_PTR = Specimen pointer
 ;                                   pointer to SPECIMENS multiple of
 ;                                    LAB SHIPPING MANIFEST file 62.8
 ;RETURNS:
 ;   ERROR_ID ^ MESSAGE ^ MANIFEST_TESTL ^ ADDABLE_TESTS
 ;    ERROR_ID       = 0=test removed
 ;                     1=error removing test
 ;    MESSAGE        = Text message describing error
 ;    MANIFEST_TESTL = Remaining List of manifest tests separated by pipe:
 ;                     See MTL^BLRAG09A
 ;   ADDABLE_TESTS  = List of tests that can be added separated by pipe:
 ;                    See TA^BLRAG09B
 N BLRI
 D ^XBKVAR S X="ERROR^BLRAGUT",@^%ZOSF("TRAP")
 S BLRI=0
 K ^TMP("BLRAG",$J)
 S BLRY=$$TMPGLB^BLRAGUT()
 S @BLRY@(0)="ERROR_ID"
 ;
 N BLRCNT,BLRJ,BLRTSTL
 N DIR,DIROUT,DIRUT,DTOUT,DUOUT,LA7I,LA7TCNT,LA7Y,LA760,X,Y
 S BLRTSTL=""
 S LA7SM=BLRSM
 ;build LA760 array
 K LA760
 S BLRCNT=0
 F BLRJ=1:1:$L(BLRMTL,"|") D
 .S BLRCNT=BLRCNT+1
 .S LA760(BLRCNT)=$P($P(BLRMTL,"|",BLRJ),":",3)_U_$G(^LAHM(62.8,+$G(BLRSM),10,$P($P(BLRMTL,"|",BLRJ),":",3),0))
 ;
 S LA7X="" F  S LA7X=$O(LA760(LA7X)) Q:LA7X=""  D
 .N FDA,LA7628,LA768,LA7DATA
 .S LA762801="" F  S LA762801=$O(^LAHM(62.8,+LA7SM,10,"UID",+(LA760(LA7X)),LA762801)) Q:LA762801=""  Q:$P($G(^LAHM(62.8,LA7SM,10,LA762801,0)),U,8)'=0
 .I LA762801'="" D
 ..S LA762801=LA762801_","_+LA7SM_","
 ..S FDA(62.8,62.801,LA762801,.08)=0
 ..D FILE^DIE("","FDA(62.8)","LA7DIE(2)") ; "Remove" test from shipping manifest
 ..; Update event file
 ..S LA7DATA="SM51^"_$$NOW^XLFDT_"^"_$P(LA760(LA7X),"^",3)_"^"_""    ;$P(LA7SM,"^",2) no associated manifest for GUI
 ..S LA7UID=$P(LA760(LA7X),"^",6)  ;get SPECIMEN ID (UID) (add 1 to piece number)
 ..D SEUP^LA7SMU(LA7UID,2,LA7DATA)
 ..; Update accession
 ..D ACCSUP^LA7SMU(LA7UID,$P(LA760(LA7X),"^",3),"@")
 D MTL^BLRAG09A(.BLRTSTL,BLRSM) ;get tests on Manifest
 S BLRSCFG=$P($G(^LAHM(62.8,BLRSM,0)),U,2)
 S BLRNTAL=$$TA^BLRAG09B(BLRSCFG,BLRSM)  ;get test that can be added to manifest
 ;            0        1       2              3
 S @BLRY@(0)="CLEAN^MESSAGE^MANIFEST_TESTL^ADDABLE_TESTS"
 ;                            0   1    2         3
 S BLRI=BLRI+1 S @BLRY@(BLRI)=0_U_""_U_BLRTSTL_U_BLRNTAL
 Q
 ;
INIT ; Initialize variables
 S DT=$$DT^XLFDT
 S LA7QUIT=0
 S LA7SCFG=BLRSCFG  ;shipping configuration
 ;I LA7SCFG<1 S LA7QUIT=1 Q
 S LA7SCFG(0)=$G(^LAHM(62.9,+LA7SCFG,0))
 S MSG=""
 K ^TMP("LA7ERR",$J)
 Q
 ;
 ;
LOCKSM ; Lock entry in file 62.8
 L +^LAHM(62.8,+LA7SM):1 ; Set lock.
 I '$T S LA7QUIT="1^Someone else is editing this shipping manifest"
 Q
 ;
 ;
UNLOCKSM ; Unlock entry in file 62.8
 L -^LAHM(62.8,+LA7SM) ; Release lock.
 Q
 ;
 ;
CLEANUP ; Cleanup variables
 I $D(ZTQUEUED) S ZTREQ="@"
 K DA,DIC,DIR,DIRUT,DTOUT,DUOUT,X,Y
 K LA7AA,LA7ACTON,LA7AD,LA7AN,LA7EV,LA7FLAG,LA7I,LA7QUIT,LA7SCFG,LA7SDT,LA7SM,LA7ST,LA7UID,LA7X,LA7YARRY
 K LA760,LA76205,LA762801,LA76805
 K ^TMP("LA7ERR",$J)
 Q
