BLRAG09A ; IHS/MSC/SAT - LABORATORY ACCESSION GUI RPCS ; NOV 16, 2012
 ;;5.2;IHS LABORATORY;**1031**;NOV 01, 1997;Build 185
 ;from LA7SMB
 ; Shipping Manifest support routines
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
SC(BLRY) ;return shipping configurations (BLR SHIP CONFIG)
 ;    ^ = Ship Config data piece delimiter
 ;    | = Manifest List delimiter
 ;    ; = Manifest List data piece delimiter
 ;    { = 1st level data piece list delimiter
 ;    ~ = 2nd level data piece separater within piece list
 ;RETURNS:
 ; CONFIG_IEN ^ CONFIG_NAME ^ CONFIG_AREA_LIST ^ MANIFEST_LIST
 ;
 ; CONFIG_IEN     = Shipping Configuration IEN - pointer to the
 ;                  LAB SHIPPING CONFIGURATION file 62.9
 ; CONFIG_NAME    = Shipping Configuration name as defined in the
 ;                  NAME field .01 of the LAB SHIPPING CONFIGURATION FILE.
 ; CONFIG_AREA_LIST= List of ACCESSION AREAs separated by commas ","
 ;                   AREA_IEN~AREA_NAME,...
 ; MANIFEST_LIST  = Pipe delimited list of 'OPEN', 'CLOSED', & 'SHIPPED'
 ;                  Manifests that have belonged to this
 ;                  Shipping Configuration.
 ;
 ;  Each Manifest entry contains the following semicolon ";" pieces:
 ; MANIFEST_IEN     = ien of active shipping manifest in file #62.8
 ;                  LAB SHIPPING MANIFEST
 ;                  There is not an active manifest if null or zero
 ; MANIFEST_INVOICE = Invoice of active Manifest
 ;                   null if ACTIVE_IEN is not returned
 ; MANIFEST_STATUS= only 0=CANCELLED; 1=OPEN; 3=CLOSED are allowed
 ; MANIFEST_EVENT_DATE = Event date for Manifest Status
 ; TESTS_ON_MANIF = List of tests that are on this manifest
 ;                  separated by open curly bracket "{" pieced by "~":
 ;               TEST_IEN~TEST_NAME~TEST_SPECIMENT_PTR~BLRPDFN~BLRPNAM~
 ;                 CONFIG_NAM~CONFIG_IEN{...
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
 ;  ADDABLE_TESTS  = List of tests that can be added
 ;                   separated by open curly bracket "{" pieced by "~"
 ;               TEST_IEN~TEST_NAME~UID~EXT_ACC_#~AREA~DATE~ACC_#~PAT_DFN~
 ;                PAT_NAM~CONFIG_NAM~CONFIG_IEN{...
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
 N BLRI
 D ^XBKVAR S X="ERROR^BLRAGUT",@^%ZOSF("TRAP")
 S BLRI=0
 K ^TMP("BLRAG",$J)
 S BLRY=$$TMPGLB^BLRAGUT()
 S @BLRY@(0)="ERROR_ID"
 N BLRAA,BLRAAL,BLRAAN,BLRJ,BLRK,BLRMA,BLRMINV,BLRML,BLRMST,BLRNTAL
 K BLRAAL
 S (BLRSCN,BLRMA,BLRML,BLRNTAL,BLRMAN,BLRMINV,BLRAAL,BLRMST,BLRTSTL)=""
 ;build local xref of Manifests by Shipping Configurations
 D SCA(.BLRMA)
 ;            0          1           2                3                 ;            4                5               6              7
 S @BLRY@(0)="CONFIG_IEN^CONFIG_NAME^CONFIG_AREA_LIST^MANIFEST_LIST"    ;IEN^MANIFEST_INVOICE^MANIFEST_STATUS^MANIFEST_TESTL^ADDABLE_TESTS"
 S BLRSCN="" F  S BLRSCN=$O(^LAHM(62.9,"B",BLRSCN)) Q:BLRSCN=""  D
 .S BLRML=""
 .S BLRSC=$O(^LAHM(62.9,"B",BLRSCN,0))   ;get config IEN  BLRSCN=config name
 .Q:BLRSC=""
 .;get areas
 .S BLRJ=0 F  S BLRJ=$O(^LAHM(62.9,BLRSC,60,BLRJ)) Q:BLRJ'>0  D
 ..S BLRAA=$P($G(^LAHM(62.9,BLRSC,60,BLRJ,0)),U,2)
 ..S BLRAAN=$P($G(^LRO(68,+$G(BLRAA),0)),U,1)
 ..S BLRAAL=$S(BLRAAL'="":BLRAAL_",",1:"")_BLRAA_"~"_BLRAAN  ;collect list of areas
 .;build manifest list
 .S BLRJ="" F  S BLRJ=$O(BLRMA(BLRSC,BLRJ)) Q:BLRJ=""  D
 ..S BLRML=$S(BLRML'="":BLRML_"|",1:"")_BLRMA(BLRSC,BLRJ)
 .;                            0       1        2        3
 .S BLRI=BLRI+1 S @BLRY@(BLRI)=BLRSC_U_BLRSCN_U_BLRAAL_U_BLRML
 Q
 ;
SCA(BLRMA) ;build local xref of Manifests by Shipping Configurations
 ; BLRMA(<SHIP_CONFIG_IEN>,<COUNT>)=<MANIFEST_IEN>;<MANIFEST_INVOICE>;<MANIFEST_STATUS>;<MANIFEST_EVENT_DATE>;<TESTS_ON_MANIFESTS>;<ADDABLE_TESTS>
 N BLRCNT,BLRLSE,BLREVD,BLRNTAL,BLRSC,BLRSM,BLRSMN,BLRSM0,BLRST,BLRTSTL
 S (BLRTSTL,BLRNTAL)=""
 S BLRCNT=0
 S BLRSMN="" F  S BLRSMN=$O(^LAHM(62.8,"B",BLRSMN)) Q:BLRSMN=""  D
 .S (BLRNTAL,BLRTSTL)=""
 .S BLRSM=$O(^LAHM(62.8,"B",$G(BLRSMN),0))
 .Q:BLRSM=""
 .S BLRSM0=$G(^LAHM(62.8,BLRSM,0))
 .Q:"134"'[+$P(BLRSM0,U,3)  ;only use open, closed, and shipped manifests
 .S BLRSC=$P(BLRSM0,U,2)
 .S BLRST=$$GET1^DIQ(62.8,BLRSM_",",.03)
 .D:BLRST="OPEN" MTL(.BLRTSTL,BLRSM) ;get tests on this manifest
 .S:BLRTSTL'="" BLRTSTL=$TR($TR(BLRTSTL,"|","{"),":","~")
 .S:BLRST="OPEN" BLRNTAL=$$TA^BLRAG09B(+$G(BLRSC),+$G(BLRSM))  ;get test that can be added to manifest
 .S:BLRNTAL'="" BLRNTAL=$TR($TR(BLRNTAL,"|","{"),":","~")
 .S BLRLSE=$O(^LAHM(62.85,"B",$P(BLRSM0,U,1),9999999),-1)  ;get pointer to most recent entry in LAB SHIPPING EVENT file
 .S BLREVD=$$FMTE^XLFDT($P($G(^LAHM(62.85,+$G(BLRLSE),0)),U,7),2)
 .S BLRCNT=BLRCNT+1 S BLRMA(BLRSC,BLRCNT)=$G(BLRSM)_";"_$G(BLRSMN)_";"_$G(BLRST)_";"_$G(BLREVD)_";"_$G(BLRTSTL)_";"_$G(BLRNTAL)
 Q
 ;
MTL(BLRTSTL,BLRMAN) ;get list of tests already on manifest
 ; RETURNS list of tests from the manifest separated by pipe:
 ;      BLRTST : BLRTSTN : BLRSP : BLRPDFN : BLRPNAM | ...
 ;   BLRTST  = pointer to file 60
 ;   BLRTSTN = Test name from file 60
 ;   BLRSP   = pointer to SPECIMENS multiple in file 62.8
 ;   BLRPDFN = patient IEN pointer to the VA Patient file 2
 ;   BLRPNAM = patient name
 ;   CONFIG_NAM = Shipping Configuration Name
 ;   CONFIG_IEN = pointer to file 62.9
 ;   UID     = Test Unique ID
 N BLRSP,BLRTST,BLRTSTN,BLRUID
 Q:$G(BLRMAN)=""
 S BLRSC=$P($G(^LAHM(62.8,+BLRMAN,0)),U,2)
 Q:BLRSC=""
 S BLRSCN=$P($G(^LAHM(62.9,BLRSC,0)),U,1)
 S BLRSP=0 F  S BLRSP=$O(^LAHM(62.8,+BLRMAN,10,BLRSP)) Q:BLRSP'>0  D
 .I $P($G(^LAHM(62.8,+BLRMAN,10,BLRSP,0)),U,8)'=0 D
 ..S BLRNODSP=$G(^LAHM(62.8,+BLRMAN,10,BLRSP,0))
 ..S BLRLRDFN=$P(BLRNODSP,U,1)
 ..S BLRPDFN=$P($G(^LR(+$G(BLRLRDFN),0)),U,3)  ;get patient DFN
 ..S BLRPNAM=$P($G(^DPT(+$G(BLRPDFN),0)),U,1)  ;get patient NAME
 ..S BLRTST=$P($G(^LAHM(62.8,+BLRMAN,10,BLRSP,0)),U,2)
 ..S BLRTSTN=$P($G(^LAB(60,+$G(BLRTST),0)),U,1)
 ..S BLRUID=$P($G(^LAHM(62.8,+BLRMAN,10,BLRSP,0)),U,5)  ;get UID (specimen ID)
 ..S BLRTSTL=$S(BLRTSTL'="":BLRTSTL_"|",1:"")_BLRTST_":"_BLRTSTN_":"_BLRSP_":"_BLRPDFN_":"_BLRPNAM_":"_BLRSCN_":"_BLRSC_":"_BLRUID   ;collect manifest test list
 Q
