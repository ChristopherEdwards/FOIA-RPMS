BLRAG09G ; IHS/MSC/SAT - LABORATORY ACCESSION GUI RPCS ;
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
DISP(BLRY,LA7SM,BLRIOM,BLRIOSL) ;screen formatted text for manifest display
 ; BLR MANIFEST DISPLAY
 ;INPUT:
 ; LA7SM   = ien of active shipping manifest in file #62.8
 ;                  LAB SHIPPING MANIFEST
 ; BLRIOM  = page width character count; defaults to 132
 ; BLRIOSL = page line count; defaults to 51
 ;RETURNS:
 ;  Formatted Manifest text for screen display
 ;  Each array entry is a single line of display and
 ;  ends with a pipe |.
 N BLRI
 D ^XBKVAR S X="ERROR^BLRAGUT",@^%ZOSF("TRAP")
 S BLRI=0
 K ^TMP("BLRAG",$J)
 S BLRY=$$TMPGLB^BLRAGUT()
 ;            0
 S @BLRY@(0)="ERROR_ID"
 N BLRTXT
 S BLRTXT=""
 S LA7SM=+$G(LA7SM)
 I '$D(^LAHM(62.8,+$G(LA7SM))) D ERR^BLRAGUT("BLRAG09G: Invalid Manifest IEN") Q
 S BLRIOM=$G(BLRIOM)
 S BLRIOSL=$G(BLRIOSL)
 D DEVT^BLRAG09D(.BLRTXT,"",LA7SM,BLRIOM,BLRIOSL)  ;get manifest display text array
 S @BLRY@(0)="MANIFEST_DISPLAY"
 S BLRTXT="" F  S BLRTXT=$O(BLRTXT(BLRTXT)) Q:BLRTXT=""  S BLRI=BLRI+1 S @BLRY@(BLRI)=BLRTXT(BLRTXT)_"|"
 Q
