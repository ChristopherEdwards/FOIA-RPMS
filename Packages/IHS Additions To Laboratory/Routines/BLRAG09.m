BLRAG09 ;IHS/MSC/SAT - LABORATORY ACCESSION GUI RPCS ;NOV 19, 2012
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
 ;  BLR MANIFEST START       - SMONLY^BLRAG09  = Start a shipping manifest only, no building
 ;  BLR MANIFEST TEST ADD    - ADDTEST^BLRAG09C= Add tests to an existing manifest\
 ;  BLR MANIFEST TEST REMOVE - REMVTST^BLRAG09C= Remove a test from manifest - actually flags test as "removed".
 ;  BLR MANIFEST TESTS TO ADD- TARPC^BLRAG09B  = return tests that can be added to a manifest
 ;
SMONLY(BLRY,BLRSCFG) ; Start a shipping manifest only, no building
 ; BLR MANIFEST START rpc
 ;INPUT:
 ; BLRSCFG     = Shipping Configuration IEN - pointer to the
 ;                LAB SHIPPING CONFIGURATION file 62.9
 ;RETURNS:
 ; ERROR_ID ^ MESSAGE ^ ADDABLE_TESTS
 ;  ADDABLE_TESTS  = List of tests that can be added separated by pipe:
 ;   TEST_IEN_":"_TEST_NAME_":"_UID_":"_EXT_ACC_#_":"_AREA_":"_DATE_":"_
 ;    ACC_# ":" PAT_DFN ":" PAT_NAM ":" CONFIG_NAM |...
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
 ;
 N BLRI,BLRNTAL
 S BLRNTAL=""
 D ^XBKVAR S X="ERROR^BLRAGUT",@^%ZOSF("TRAP")
 S BLRI=0
 K ^TMP("BLRAG",$J)
 S BLRY=$$TMPGLB^BLRAGUT()
 S @BLRY@(0)="ERROR_ID"
 ;
 N BLRRET,LA7SMON
 S BLRRET=0
 S LA7SMON=1
 D EN
 I +BLRRET S BLRI=BLRI+1 S @BLRY@(BLRI)=BLRRET D CLEANUP Q
 I '+BLRRET D
 .S:+LA7SM'="" BLRNTAL=$$TA^BLRAG09B(BLRSCFG,$P(LA7SM,U,1))  ;get test that can be added to manifest
 .S BLRI=BLRI+1 S @BLRY@(BLRI)=0_U_"Shipping manifest# "_$P(LA7SM,U,2)_" is available"_U_$G(BLRNTAL)_U_$P(LA7SM,U,1)_U_$P(LA7SM,U,2)
 .;            0     1       2             3            4
 .S @BLRY@(0)="CLEAN^MESSAGE^ADDABLE_TESTS^MANIFEST_IEN^MANIFEST_INVOICE"
 D CLEANUP
 Q
 ;
EN ;
 ;
 D CLEANUP
 S LA7SCFG=BLRSCFG
 S LA7QUIT=0
 ;
 ; Select shipping configuration
 ;S LA7SCFG=$$SSCFG^LA7SUTL(1)
 I LA7SCFG<1 S BLRRET=1_U_"Invalid shipping configuration defined." D CLEANUP Q
 ;
 ; Determine if there's an active manifest.
 S LA7SM=$$CHKSM^LA7SMU(+LA7SCFG)
 I +$G(LA7SMON),+LA7SM>0 S BLRRET=1_U_"An active manifest already exists." D CLEANUP Q
 ;
 I LA7SM=0 D
 . N DIR,DIRUT,DTOUT,X,Y
 . ;S DIR(0)="YO",DIR("A",1)="There's no open shipping manifest for "_$P(LA7SCFG,"^",2)
 . ;S DIR("A")="Do you want to start one",DIR("B")="NO"
 . ;D ^DIR
 . ;I Y'=1 S LA7QUIT=1 Q
 . S LA7SM=$$CSM^LA7SMU(+LA7SCFG)
 . I LA7SM<1 S BLRRET=1_U_$P(LA7SM,U,2) D CLEANUP Q
 ;
 ; Only starting a new manifest, no building
 I $G(LA7SMON) Q
 ;
 ;I LA7QUIT=1 D CLEANUP Q
 ;
 D:'BLRDEF ADATE          ;not using default accession dates
 ;I LA7QUIT=1 D CLEANUP Q
 ;
 ; Flag to exclude previously removed tests from building.
 S LA7EXPRV=BLREXPRV
 ;I LA7EXPRV<0 S LA7QUIT=1
 ;
 ;I LA7QUIT=1 D CLEANUP Q
 ;
DQ ; Taskman entry point
 ; Build list of tests and criteria for manifest.
 S LA7SCFG(0)=$G(^LAHM(62.9,+LA7SCFG,0))
 ;I '$D(ZTQUEUED) D EN^DDIOL("Using shipping manifest# "_$P(LA7SM,"^",2),"","!?5")
 ;
 ; Lock this shipping manifest
 L +^LAHM(62.8,+LA7SM,0):5
 I '$T D  Q
 . S BLRRET=1_U_"Unable to obtain lock for shipping manifest "_$P(LA7SCFG,"^",2)
 . D CLEANUP
 ;
 ; Update status
 D SMSUP^LA7SMU(LA7SM,2,"SM03")
 S LA7SMCNT=0
 ;
 ; Build TMP global with test profiles
 D SCBLD^LA7SM1(+LA7SCFG)
 S LA7AA=""
 F  S LA7AA=$O(^TMP("LA7SMB",$J,LA7AA)) Q:LA7AA=""  D
 . N LA7END,LRSS
 . ;I '$D(ZTQUEUED) D EN^DDIOL("Searching accession area: "_$P($G(^LRO(68,LA7AA,0)),"^"),"","!?5")
 . ; Use selected accession date else get current accession day for this acession area
 . I $G(LA7AA(LA7AA)) S LA7AD=$P(LA7AA(LA7AA),"^")
 . E  S LA7AD=$$AD^LA7SUTL(LA7AA)
 . S LRSS=$P($G(^LRO(68,LA7AA,0)),"^",2)
 . S LA7AN=+$P($G(LA7AA(LA7AA)),"^",2),LA7LAN=+$P($G(LA7AA(LA7AA)),"^",3),LA7END=0
 . I LA7AN S LA7AN=LA7AN-1
 . F  S LA7AN=$O(^LRO(68,LA7AA,1,LA7AD,1,LA7AN)) Q:'LA7AN!(LA7END)  D SCAN
 ;
 ; Update status
 D SMSUP^LA7SMU(LA7SM,1,"SM02")
 ;
 ; Release lock on this shipping manifest
 L -^LAHM(62.8,+LA7SM,0)
 ;
 ;I '$D(ZTQUEUED) D
 ;. N DIR,DIRUT,DIROUT,DTOUT,X,Y
 ;. D EN^DDIOL("There were "_$S(LA7SMCNT:LA7SMCNT,1:"NO")_" specimens added","","!?5")
 ;. D ASK^LA7SMP(LA7SM)
 ;D CLEANUP
 Q
 ;
ADATE ; Select accession dates if specified
 ;
 N DIR,DIRUT,DTOUT,LRAA,X,Y
 ;
 S LA7QUIT=0
 S LA7AA=0
 F BLRJ=1:1:$L(BLRAREAL,"|") D  Q:LA7QUIT
 . N %DT,DTOUT,LRAA,LRAD,LREND,LRFAN,LRLAN
 . S LA7AA=$P($P(BLRAREAL,"|",BLRJ),":",1)
 . S LRAA=LA7AA
 . S LRAD=$P($P(BLRAREAL,"|",BLRJ),":",2)
 . ;S X=LRAD,%DT="XT" D ^%DT S LRAD=$P(Y,".")
 . D ADATE1
 . S LRFAN=$P($P(BLRAREAL,"|",BLRJ),":",3)
 . S:LRFAN="" LRFAN=1
 . S LRLAN=$P($P(BLRAREAL,"|",BLRJ),":",4)
 . S:LRLAN="" LRLAN=9999999
 . S LA7AA(LA7AA)=$G(LRAD)_"^"_$G(LRFAN)_"^"_$G(LRLAN)
 Q
 ;
ADATE1 ;Get an accession date
 S LREND=0 S X=$S(LRAD'="":LRAD,1:"T")
 S %DT="P" D ^%DT Q:Y=-1
 I $G(LRAA),$D(^LRO(68,+LRAA,0)) S %=$P(^LRO(68,+LRAA,0),U,3),Y=$S("D"[%:Y,%="Y":$E(Y,1,3)_"0000","M"[%:$E(Y,1,5)_"00","Q"[%:$E(Y,1,3)_"0000"+(($E(Y,4,5)-1)\3*300+100),1:Y)
 S LRAD=Y K %DT Q
 ;
SCAN ; Scan accession for tests to build
 ;
 N LA76805,LA7DIV,LA7END
 ;
 I LA7LAN,LA7AN>LA7LAN S LA7END=1 Q
 ;
 ; Don't build controls
 I $P($G(^LRO(68,LA7AA,1,LA7AD,1,LA7AN,0)),"^",2)=62.3 Q
 ;
 ; Don't build uncollected specimens
 I '$P(LA7SCFG(0),"^",14),'$P($G(^LRO(68,LA7AA,1,LA7AD,1,LA7AN,3)),"^",3) Q
 ;
 ; Get Specimen type - if no specimen then quit
 ; Anatomic path does not store specimen type in #68.
 S LA76805=""
 I "CY^EM^SP"[LRSS S LA76805=0
 E  D
 . S X=+$O(^LRO(68,LA7AA,1,LA7AD,1,LA7AN,5,0))
 . I 'X Q
 . S LA76805=+$G(^LRO(68,LA7AA,1,LA7AD,1,LA7AN,5,X,0))
 I LA76805="" Q
 ;
 ; Accession's division
 S LA7DIV=+$P($G(^LRO(68,LA7AA,1,LA7AD,1,LA7AN,.4)),"^")
 ;
 S LA760=0
 F  S LA760=$O(^LRO(68,LA7AA,1,LA7AD,1,LA7AN,4,LA760)) Q:'LA760  D
 . ; Not looking for this test.
 . I '$D(^TMP("LA7SMB",$J,LA7AA,LA760)) Q
 . ; Set lock.
 . D LOCK68
 . ; NOTE *** Do NOT add any "QUIT" after this point unless releasing LOCK set above ***.
 . ; Test's zeroth node.
 . S LA760(0)=$G(^LRO(68,LA7AA,1,LA7AD,1,LA7AN,4,LA760,0))
 . ; Test completed - skip
 . I "CY^EM^SP"'[LRSS,$P(LA760(0),"^",5) D UNLOCK68 Q
 . ;test already on shipping manifest; not removed
 . S BLRTF=0
 . S:$P(LA760(0),"^",10) BLRTF=$$TAA^BLRAG09B($P(LA760(0),"^",10),$P($G(^LRO(68,LA7AA,1,LA7AD,1,LA7AN,.3)),U,1),LA760)
 . I BLRTF=1 D UNLOCK68 Q
 . ; Test already on shipping manifest - skip
 . ;I $P(LA760(0),"^",10) D UNLOCK68 Q
 . ; Previously removed - skip
 . I LA7EXPRV,$$PREV^LA7SMU1($P($G(^LRO(68,LA7AA,1,LA7AD,1,LA7AN,.3)),"^"),$P(LA760(0),"^")) D UNLOCK68 Q
 . ; Test urgency
 . S LA76205=+$P(LA760(0),"^",2)
 . I LA76205>49 S LA76205=$S(LA76205=50:9,1:LA76205-50)
 . ; Check if test is eligible for manifest
 . D SCHK^LA7SM1
 . I LA7FLAG S LA7FLAG=$$CKTEST(LA7AA,LA7AD,LA7AN,LA760)
 . ; Add test to shipping manifest.
 . I LA7FLAG D
 . . S LA7I=0
 . . F  S LA7I=$O(LA7X(LA7I)) Q:'LA7I  D ADD
 . ; Release lock.
 . D UNLOCK68
 Q
 ;
ADD ; Add test to shipping manifest
 ; Called from above, LA7SM
 ; Lock on ^LRO(68,LA7AA,1,LA7AD,1,LA7AN,4,LA760) should be set before entering here.
 ;
 N FDA,IENS,LA7628,LA768,LA7DATA
 ;
 S LRDFN=+$G(^LRO(68,LA7AA,1,LA7AD,1,LA7AN,0))
 S LA7UID=$P($G(^LRO(68,LA7AA,1,LA7AD,1,LA7AN,.3)),"^")
 I LA7UID="" S LA7UID=$$LRUID^LRX(LA7AA,LA7AD,LA7AN)
 S LA7SMCNT=$G(LA7SMCNT)+1
 ;S ^TMP("LA7SMADD",$J,LA7SMCNT)=LRDFN_"^"_LA760_"^"_LA76805_"^"_LA76205_"^"_LA7UID
 S LA7628(1)=+LA7SM,IENS="+2,"_LA7628(1)_","
 S FDA(2,62.801,IENS,.01)=LRDFN
 S FDA(2,62.801,IENS,.02)=LA760
 I LA76805 S FDA(2,62.801,IENS,.03)=LA76805
 S FDA(2,62.801,IENS,.04)=LA76205
 S FDA(2,62.801,IENS,.05)=LA7UID
 S FDA(2,62.801,IENS,.08)=1
 I $D(LA7X(LA7I,0)) D
 . I $P(LA7X(LA7I,0),"^",5) S FDA(2,62.801,IENS,.06)=$P(LA7X(LA7I,0),"^",5)
 . I $P(LA7X(LA7I,0),"^",6) S FDA(2,62.801,IENS,.07)=$P(LA7X(LA7I,0),"^",6)
 . I $P(LA7X(LA7I,0),"^",7) S FDA(2,62.801,IENS,.09)=$P(LA7X(LA7I,0),"^",7)
 I $D(LA7X(LA7I,1)) D
 . I $P(LA7X(LA7I,1),"^",1)]"" S FDA(2,62.801,IENS,1.1)=$P(LA7X(LA7I,1),"^",1)
 . I $P(LA7X(LA7I,1),"^",2)]"" S FDA(2,62.801,IENS,1.13)=$P(LA7X(LA7I,1),"^",2)
 . I $P(LA7X(LA7I,1),"^",5)]"" S FDA(2,62.801,IENS,1.14)=$P(LA7X(LA7I,1),"^",5)
 . I $P(LA7X(LA7I,1),"^",3)]"" S FDA(2,62.801,IENS,1.2)=$P(LA7X(LA7I,1),"^",3)
 . I $P(LA7X(LA7I,1),"^",4)]"" S FDA(2,62.801,IENS,1.23)=$P(LA7X(LA7I,1),"^",4)
 . I $P(LA7X(LA7I,1),"^",6)]"" S FDA(2,62.801,IENS,1.24)=$P(LA7X(LA7I,1),"^",6)
 I $D(LA7X(LA7I,2)) D
 . I $P(LA7X(LA7I,2),"^",1)]"" S FDA(2,62.801,IENS,2.1)=$P(LA7X(LA7I,2),"^",1)
 . I $P(LA7X(LA7I,2),"^",2)]"" S FDA(2,62.801,IENS,2.13)=$P(LA7X(LA7I,2),"^",2)
 . I $P(LA7X(LA7I,2),"^",7)]"" S FDA(2,62.801,IENS,2.14)=$P(LA7X(LA7I,2),"^",7)
 . I $P(LA7X(LA7I,2),"^",3)]"" S FDA(2,62.801,IENS,2.2)=$P(LA7X(LA7I,2),"^",3)
 . I $P(LA7X(LA7I,2),"^",4)]"" S FDA(2,62.801,IENS,2.23)=$P(LA7X(LA7I,2),"^",4)
 . I $P(LA7X(LA7I,2),"^",8)]"" S FDA(2,62.801,IENS,2.24)=$P(LA7X(LA7I,2),"^",8)
 . I $P(LA7X(LA7I,2),"^",5)]"" S FDA(2,62.801,IENS,2.3)=$P(LA7X(LA7I,2),"^",5)
 . I $P(LA7X(LA7I,2),"^",6)]"" S FDA(2,62.801,IENS,2.33)=$P(LA7X(LA7I,2),"^",6)
 . I $P(LA7X(LA7I,2),"^",9)]"" S FDA(2,62.801,IENS,2.34)=$P(LA7X(LA7I,2),"^",9)
 I $D(LA7X(LA7I,5)) D
 . F I=1:1:9 I $P(LA7X(LA7I,5),"^",I)]"" S FDA(2,62.801,IENS,"5."_I)=$P(LA7X(LA7I,5),"^",I)
 D UPDATE^DIE("","FDA(2)","LA7628","LA7DIE(2)")
 ;
 ; Update event file
 S LA7DATA="SM50^"_$$NOW^XLFDT_"^"_LA760_"^"_$P(LA7SM,"^",2)
 D SEUP^LA7SMU(LA7UID,2,LA7DATA)
 ;
 ; Update accession
 D ACCSUP^LA7SMU(LA7UID,LA760,+LA7SM)
 Q
 ;
 ;
CKTEST(LA7AA,LA7AD,LA7AN,LA760) ; Check other tests on accession if test is part of another panel that
 ; has been flagged for shipping.
 ; Call with LA7AA = ien of accession area.
 ;           LA7AD = accession date
 ;           LA7AN = accession number
 ;           LA760 = ien of lab test
 ; Returns   LA7FLAG = 0 (part of another panel)
 ;                   = 1 (not part of another panel)
 ;
 N LA7FLAG,LA7PCNT,LA7K,LA7J,X
 ;
 K ^TMP("BLRTREE",$J)
 ;
 S LA7FLAG=1
 S LA7AD(LA7AD)=""
 S LA7K=+$P($G(^LRO(68,LA7AA,1,LA7AD,1,LA7AN,0)),"^",3)
 ;
 I LA7K D
 . ; Check original accession date.
 . S LA7AD(LA7K)=""
 . ; Check rollover accession
 . I $P($G(^LRO(68,LA7AA,1,LA7K,1,LA7AN,9)),"^") S LA7AD($P($G(^LRO(68,LA7AA,1,LA7K,1,LA7AN,9)),"^"))=""
 S LA7AD=0
 F  S LA7AD=$O(LA7AD(LA7AD)) Q:'LA7AD  D
 . S LA7J=0
 . F  S LA7J=$O(^LRO(68,LA7AA,1,LA7AD,1,LA7AN,4,LA7J)) Q:'LA7J  D
 . . I LA7J=LA760 Q
 . . ; Not on manifest
 . . I '$P($G(^LRO(68,LA7AA,1,LA7AD,1,LA7AN,4,LA7J,0)),"^",10) Q
 . . S LA7PCNT=0 D UNWIND(LA7J)
 ;
 ; Test is part of another test previously shipped.
 I $D(^TMP("BLRTREE",$J,LA760)) S LA7FLAG=0
 ;
 K ^TMP("BLRTREE",$J)
 ;
 Q LA7FLAG
 ;
UNWIND(LA760) ; Unwind profile - set tests into global ^TMP("BLRTREE",$J).
 ; Initialize variable LA7PCNT=0 before calling.
 ; Kill ^TMP("BLRTREE",$J) before calling.
 ;
 N I,II
 ;
 ; Recursive panel, caught in a loop.
 I $G(LA7PCNT)>50 Q
 ; Test does not exist in file 60.
 I '$D(^LAB(60,LA760,0)) Q
 ; Bypass "workload" type tests.
 I $P(^LAB(60,LA760,0),"^",4)="WK" Q
 ; Atomic test
 I $L($P(^LAB(60,LA760,0),"^",5)) S ^TMP("BLRTREE",$J,LA760)="" Q
 ; Check panels
 I $O(^LAB(60,LA760,2,0)) D
 . ; Increment panel counter.
 . S LA7PCNT=$G(LA7PCNT)+1
 . S I=0
 . ; Expand test on panel.
 . F  S I=$O(^LAB(60,LA760,2,I)) Q:'I  D
 . . ; IEN of test on panel.
 . . S II=+$G(^LAB(60,LA760,2,I,0))
 . . ; Recursive panel, panel calls itself.
 . . I II,II=LA760 Q
 . . I II S ^TMP("BLRTREE",$J,LA760)="" D UNWIND(II)
 Q
 ;
LOCK68 ; Lock entry in file 68
 ; Called from above, LA7SM
 ;
 NEW LOCKIT
 ;
 S LOCKIT=0
 F  Q:LOCKIT  L +^LRO(68,LA7AA,1,LA7AD,1,LA7AN,4,LA760):5  S LOCKIT=$T  ; Set lock.  Wait 5 seconds.  If can't lock, keep trying
 ;
 Q
 ;
UNLOCK68 ; Unlock entry in file 68
 ; Called from above, LA7SM
 ;
 L -^LRO(68,LA7AA,1,LA7AD,1,LA7AN,4,LA760) ; Release lock.
 ;
 Q
 ;
CLEANUP ; Cleanup variables
 ;
 I $D(ZTQUEUED) S ZTREQ="@"
 ;
 K ^TMP("LA7SMB",$J),^TMP("LA7SMADD",$J),^TMP("BLRTREE",$J)
 ;
 K LA760,LA76205,LA76805,LA7AA,LA7AD,LA7AN,LA7EXPRV,LA7FLAG,LA7LAN,LA7PCNT,LA7QUIT,LA7SCFG,LA7SM,LA7SMCNT,LA7UID,LA7X
 K LRDFN
 Q
