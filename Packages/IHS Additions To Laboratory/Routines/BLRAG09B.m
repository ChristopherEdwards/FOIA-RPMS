BLRAG09B ;IHS/MSC/SAT - LABORATORY ACCESSION GUI RPCS ;NOV 16, 2012
 ;;5.2;IHS LABORATORY;**1031**;NOV 01, 1997;Build 185
 ; (from LA7SMB)
 ;
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
BM(BLRY,BLRSCFG,BLRDEF,BLRAREAL,BLREXPRV,BLRIOM,BLRIOSL,BLRDEV) ; build a shipping manifest
 ; BLR MANIFEST BUILD rpc
 ; If there is not a manifest started, this routine will start a new one.
 ; In the return from BLR SHIP MANIFEST (SHIPPING CONFIGURATION), if
 ;  ACTIVE_IEN is returned, there is already an active shipping manifest.
 ;INPUT:
 ; BLRSCFG     = (required) Shipping Configuration IEN - pointer to the
 ;                LAB SHIPPING CONFIGURATION file 62.9
 ; BLRDEF      = (optional) Use default accession dates flag
 ;                0='No'; 1="Yes"; default to 'Yes'
 ; BLRAREAL    = Used if NOT using default accession dates
 ;                list of input data for each area separated by pipe |.
 ;                each pipe piece contains the following colon pieces:
 ;   AREA : ACCESSION DATE : FIRST ACCESSION NUMBER : LAST ACCESSION NUMBER
 ;       AREA                = (optional) ACCESSION AREA IEN
 ;                              pointer to the ACCESSION file 68.
 ;       ACCESSION DATE      = (optional) Accession date in external format.
 ;                              If this date is null, processing for
 ;                              "Use default accession dates?"
 ;                              will take place.
 ;    FIRST ACCESSION NUMBER = (optional)
 ;                              used if ACCESSION DATE is not null
 ;                              First accession number; defaults to 1
 ;    LAST ACCESSION NUMBER  = (optional)
 ;                              used if Accession date BLRAD is not null
 ;                              Last accession number
 ;                              defaults to LAST (9999999)
 ; BLREXPRV    = Exclude Previous flag; Should build exclude tests from
 ;               building that have previously been removed from a manifest.
 ;                0='No'; 1='Yes'; default to 'Yes'
 ; BLRIOM  = page width character count; defaults to 132
 ; BLRIOSL = page line count; defaults to 51
 ; BLRDEV  = Printer for Manifest printing - IEN pointer to the DEVICE file
 ;             No printing will occur if null or undefined in the DEVICE file
 ;
 ;RETURNS:
 ;   ERROR_ID ^ MESSAGE ^ TESTS_ON_MANIF ^ ADDABLE_TESTS ^ MANIFEST_IEN ^
 ;   MANIFEST_INVOICE ^ MANIFEST_DISPLAY
 ; TESTS_ON_MANIF = List of tests that are on this manifest
 ;                  separated by pipe:
 ;                     TEST_IEN:TEST_NAME:TEST_SPEC_PTR|...
 ;                   TEST_IEN  = pointer to LABORATORY TEST file 60
 ;                   TEST_NAME = Text from NAME field in
 ;                                LABORATORY TEST file 60
 ;                   TEST_SPECIMEN_PTR = Specimen pointer
 ;                                   pointer to SPECIMENS multiple of
 ;                                    LAB SHIPPING MANIFEST file 62.8
 ;                   BLRPDFN = patient IEN pointer to the VA Patient file 2
 ;                   BLRPNAM = patient name
 ;                   CONFIG_NAM = Shipping Configuration Name
 ;                   CONFIG_IEN = pointer to file 62.9
 ;  ADDABLE_TESTS  = List of tests that can be added separated by pipe:
 ;   TEST_IEN_":"_TEST_NAME_":"_UID_":"_EXT_ACC_#_":"_AREA_":"_DATE_":"_
 ;    ACC_#|...
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
 ;     CONFIG_IEN = pointer to file 62.9
 ; MANIFEST_IEN     = ien of active shipping manifest in file #62.8
 ;                  LAB SHIPPING MANIFEST
 ;                  There is not an active manifest if null or zero
 ; MANIFEST_INVOICE = Invoice of active Manifest
 ;                   null if ACTIVE_IEN is not returned
 ; MANIFEST_DISPLAY = Formatted Manifest text for screen display
 ;                     Each array entry is a single line of display and
 ;                     ends with a pipe |.
 ;
 N BLRI
 D ^XBKVAR S X="ERROR^BLRAGUT",@^%ZOSF("TRAP")
 S BLRI=0
 K ^TMP("BLRAG",$J)
 S BLRY=$$TMPGLB^BLRAGUT()
 S @BLRY@(0)="ERROR_ID"
 ;
 N BLRNTAL,BLRRET,BLRTSTL
 N LA7AA,LA7SMON
 K BLRTXT
 S (BLRNTAL,BLRTSTL,BLRTXT)=""
 S BLRQ=0
 S BLRIOM=$G(BLRIOM)
 S BLRIOSL=$G(BLRIOSL)
 S BLREXPRV=$S($G(BLREXPRV)'="":+BLREXPRV,1:1)
 S BLRRET=0
 S LA7SMON=0
 D EN^BLRAG09
 I +BLRRET S BLRI=BLRI+1 S @BLRY@(BLRI)=BLRRET D CLEANUP^BLRAG09 Q
 ;            0     1       2              3             4            5                6
 S @BLRY@(0)="CLEAN^MESSAGE^TESTS_ON_MANIF^ADDABLE_TESTS^MANIFEST_IEN^MANIFEST_INVOICE^MANIFEST_DISPLAY"
 I '+BLRRET D
 .D MTL^BLRAG09A(.BLRTSTL,+$G(LA7SM))                  ;get tests already on manifest
 .S BLRNTAL=$$TA^BLRAG09B(BLRSCFG,+$G(LA7SM))  ;get test that can be added to manifest
 .D DEVT^BLRAG09D(.BLRTXT,BLRSCFG,LA7SM,BLRIOM,BLRIOSL)  ;get manifest display text array
 .I $G(BLRDEV) D DEV^BLRAG09F()  ;print manifest
 .S BLRI=BLRI+1 S @BLRY@(BLRI)=0_U_"Shipping manifest# "_$P(LA7SM,"^",2)_" is available."_$S($P($G(BLREF),U,1)=-1:" Error printing manifest# "_$P(LA7SM,U,2)_".",1:"")_U_$G(BLRTSTL)_U_$G(BLRNTAL)_U_$P(LA7SM,U,1)_U_$P(LA7SM,U,2)_U
 .S BLRTXT="" F  S BLRTXT=$O(BLRTXT(BLRTXT)) Q:BLRTXT=""  S BLRI=BLRI+1 S @BLRY@(BLRI)=BLRTXT(BLRTXT)_"|"
 D CLEANUP^BLRAG09
 Q
 ;
TARPC(BLRY,BLRSC,BLRSM) ;RPC to return tests that can be added to a manifest
 ; BLR MANIFEST TESTS TO ADD
 ;INPUT:
 ; BLRSCFG = Shipping Configuration pointer to the
 ;            LAB SHIPPING CONFIGURATION file 62.9
 ; BLRSM  = Shipping Manifest pointer to the LAB SHIPPING MANIFEST
 ;           file 62.8
 ;RETURNS:
 ; TEST_ON_MANIF ^ ADDABLE_TESTS
 ;  TESTS_ON_MANIF = List of tests on manifest separated by pipe:
 ;                     TEST_IEN:TEST_NAME:TEST_SPEC_PTR|...
 ;                   TEST_IEN  = pointer to LABORATORY TEST file 60
 ;                   TEST_NAME = Text from NAME field in
 ;                                LABORATORY TEST file 60
 ;                   TEST_SPECIMEN_PTR = Specimen pointer
 ;                                   pointer to SPECIMENS multiple of
 ;                                    LAB SHIPPING MANIFEST file 62.8
 ;                   BLRPDFN = patient IEN pointer to the VA Patient file 2
 ;                   BLRPNAM = patient name
 ;                   CONFIG_NAM = Shipping Configuration Name
 ;                   CONFIG_IEN = pointer to file 62.9
 ;  ADDABLE_TESTS  = List of tests that can be added separated by pipe:
 ;   TEST_IEN_":"_TEST_NAME_":"_UID_":"_EXT_ACC_#_":"_AREA_":"_DATE_":"_
 ;    ACC_#|...
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
 ;     CONFIG_IEN = pointer to file 62.9
 N BLRI
 D ^XBKVAR S X="ERROR^BLRAGUT",@^%ZOSF("TRAP")
 S BLRI=0
 K ^TMP("BLRAG",$J)
 S BLRY=$$TMPGLB^BLRAGUT()
 S @BLRY@(0)="ERROR_ID"
 N BLRNTAL,BLRTSTL
 S BLRTSTL=""
 I '$D(^LAHM(62.9,BLRSC)) S @BLRY@(0)=1_U_"Invalid SHIPPING CONFIGURATION pointer passed in." Q
 I '$D(^LAHM(62.8,BLRSM)) S @BLRY@(0)=1_U_"Invalid SHIPPING MANIFEST pointer passed in." Q
 I BLRSC'=$P(^LAHM(62.8,BLRSM,0),U,2) S @BLRY@(0)=1_U_"Manifest does not belong to given Configuration." Q
 D MTL^BLRAG09A(.BLRTSTL,BLRSM) ;get tests already on manifest
 S BLRNTAL=$$TA^BLRAG09B(BLRSC,BLRSM)  ;get test that can be added to manifest
 ;            0              1
 S @BLRY@(0)="TESTS_ON_MANIF^ADDABLE_TESTS"
 S BLRI=BLRI+1 S @BLRY@(BLRI)=BLRTSTL_U_BLRNTAL
 Q
 ;
TA(BLRSC,BLRSM) ;return tests that can be added to a manifest
 ;INPUT:
 ; BLRSC  = Shipping Configuration pointer to the
 ;           LAB SHIPPING CONFIGURATION file 62.9
 ; BLRSM  = Shipping Manifest pointer to the LAB SHIPPING MANIFEST
 ;           file 62.8
 ;RETURNS:
 ; List of Tests and data accumulated in BLRRET that can be added
 ;  to the Manifest
 ; OR -- 1^error_message
 ; List of test pointers separated by pipe:
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
 ;     CONFIG_IEN = pointer to file 62.9
 ;
 N BLRAA,BLRAD,BLRAN,BLRAT
 N BLRACN,BLRAD,BLRAN,BLRAT,BLRAT0,BLRMF,BLRSC60,BLRSCTI,BLRSMF,BLRSMT0,BLRTF,BLRTNAM,BLRUID
 N LA7I
 S (BLRRET,BLRSC60)=""
 S BLRMF=0
 S BLRSC=+$G(BLRSC)
 S BLRSM=+$G(BLRSM)
 Q:'$D(^LAHM(62.9,BLRSC)) 1_U_"Invalid SHIPPING CONFIGURATION pointer passed in."
 Q:'$D(^LAHM(62.8,BLRSM)) 1_U_"Invalid SHIPPING MANIFEST pointer passed in."
 Q:BLRSC'=$P(^LAHM(62.8,BLRSM,0),U,2) 1_U_"Manifest does not belong to given Configuration."
 S BLRSCN=$P($G(^LAHM(62.9,BLRSC,0)),U,1)
 S BLRAA=0 F  S BLRAA=$O(^LRO(68,BLRAA)) Q:BLRAA'>0  D
 .;S BLRAD=$$FMADD^XLFDT($P($$NOW^XLFDT(),".",1),-90) F  S BLRAD=$O(^LRO(68,BLRAA,1,BLRAD)) Q:BLRAD'>0  D
 .F BLRLP=90:-1:0 D  Q:$E(BLRAD,4,7)="0000"  ;only go back 90 days
 ..S BLRNOW=$P($$NOW^XLFDT(),".",1)
 ..S BLRAREAL=BLRAA_":"_$S(BLRLP'=0:$$FMADD^XLFDT(BLRNOW,-BLRLP),1:BLRNOW)_":1:9999999"
 ..K LA7AA
 ..D ADATE^BLRAG09
 ..I $D(LA7AA) S BLRAD=$P($G(LA7AA(BLRAA)),U,1) Q:BLRAD=""  D
 ...S BLRAN=0 F  S BLRAN=$O(^LRO(68,BLRAA,1,BLRAD,1,BLRAN)) Q:BLRAN'>0  D
 ....Q:$P($G(^LRO(68,BLRAA,1,BLRAD,1,BLRAN,0)),"^",2)=62.3   ;skip controls
 ....S BLRACN=$P($G(^LRO(68,BLRAA,1,BLRAD,1,BLRAN,.2)),"^",1)
 ....S BLRUID=$P($G(^LRO(68,BLRAA,1,BLRAD,1,BLRAN,.3)),"^",1)
 ....Q:BLRUID=""
 ....S BLRLRDFN=$P($G(^LRO(68,BLRAA,1,BLRAD,1,BLRAN,0)),U,1)
 ....Q:BLRLRDFN=""
 ....S BLRPDFN=$P($G(^LR(+BLRLRDFN,0)),U,3)  ;get patient DFN
 ....S BLRPNAM=$P($G(^DPT(+BLRPDFN,0)),U,1)  ;get patient NAME
 ....S BLRAT=0 F  S BLRAT=$O(^LRO(68,BLRAA,1,BLRAD,1,BLRAN,4,BLRAT)) Q:BLRAT'>0  D   ;BLRAT subscript is also the pointer to file 60
 .....S BLRAT0=^LRO(68,BLRAA,1,BLRAD,1,BLRAN,4,BLRAT,0)
 .....Q:$P(BLRAT0,U,5)  ;skip if test already completed
 .....S BLRSCT=$O(^LAHM(62.9,BLRSC,60,"B",BLRAT,0))
 .....Q:BLRSCT=""   ;quit if test not found in Shipping Configuration
 .....S BLRSC60=$G(^LAHM(62.9,BLRSC,60,BLRSCT,0)) ;check accession area match
 .....Q:BLRAA'=$P(BLRSC60,U,2)
 .....;
 .....S BLRTF=0
 .....I $P(BLRAT0,U,10)'="" S BLRTF=$$TAA($P(BLRAT0,U,10),BLRUID,BLRAT)   ;SAT NOV 16, 2012: if there is already a previous manifest in the accession, see if it has been 'removed'
 .....Q:BLRTF
 .....S BLRTF=$$TAA(BLRSM,BLRUID,BLRAT)   ;SAT NOV 16, 2012: if THIS test is already on THIS manifest, see if it has been 'removed'
 .....Q:BLRTF
 .....Q:$P($G(^LRO(68,BLRAA,1,BLRAD,1,BLRAN,9)),"^")  ;quit if rollover accession - current accession date is another date
 .....;
 .....;D TAM
 .....S BLRTNAM=$P($G(^LAB(60,BLRAT,0)),U,1),BLRRET=$S(BLRRET'="":BLRRET_"|",1:"")_BLRAT_":"_BLRTNAM_":"_+$G(BLRUID)_":"_BLRACN_":"_BLRAA_":"_BLRAD_":"_BLRAN_":"_BLRPDFN_":"_BLRPNAM_":"_BLRSCN_":"_BLRSC
 ;S:BLRRET="" BLRRET=1_U_"No tests to add."
 Q BLRRET
 ;
TAA(BLRSM,BLRUID,BLRAT) ;look for test on manifest
 S BLRTF=0
 Q:'+$P($G(^LAHM(62.8,BLRSM,0)),U,3)   ;quit if manifest is not active
 S LA7I=0 F  S LA7I=$O(^LAHM(62.8,+BLRSM,10,"UID",+$G(BLRUID),LA7I)) Q:'LA7I  D  Q:BLRTF=1
 .N X
 .S X(0)=$G(^LAHM(62.8,+BLRSM,10,LA7I,0))
 .S:($P(X(0),"^",2)=BLRAT)&($P(X(0),"^",8)'=0) BLRTF=1  ;Test already on shipping manifest and has not been previously removed
 Q BLRTF
