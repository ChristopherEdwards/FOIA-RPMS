BLRAG02A ; IHS/MSC/SAT - LABORATORY ACCESSION GUI RPCS - PRINTING UTILITIES ; JAN 24, 2013; SAT
 ;;5.2;IHS LABORATORY;**1031**;NOV 01, 1997;Build 185
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
LBLTYP ; Determine label routine to use. (LBLTYP^LRLABLD)
 ; Sets LRLABEL to label print routine (label^routine).
 ; Called by above, LRLABLD0, LRLABLIO, LRLABXOL, LRLABXT, LRPHLIS1
 ;
 N BLRDEVLS
 ; Default label routine
 S LRLABEL="^LRLABEL"_$P($G(^LAB(69.9,1,3)),U,3)
 S BLRIOS=$P($G(^LAB(69.9,1,0)),U,1)
 S BLRDEVLS=$O(^LAB(69.9,1,3.6,"B",+BLRDEV,0))
 I BLRDEVLS D
 . S BLRDEVLS(0)=$G(^LAB(69.9,1,3.6,BLRDEVLS,0))
 . ; default accession area for characteristics.
 . I '$G(LRAA),$P(BLRDEVLS(0),"^",6) S LRAA=$P(BLRDEVLS(0),"^",6)
 ;
 ; Site's local accession area label routine.
 I $G(LRAA)>0,$L($P(^LRO(68,LRAA,.4),"^",5)) D  Q
 . S LRLABEL=$P(^LRO(68,LRAA,.4),"^",4,5)
 ;
 ; This device not defined in file #69.9.
 I BLRDEVLS<1 Q  ; D ERR^BLRAGUT("BLRAG02A: Label device "_$P($G(^%ZIS(1,+BLRDEV,0)),U,1)_"is not defined in the LABORATORY SITE file.") Q
 ;
 ; Site's designated local label routine.
 I $L($P(BLRDEVLS(0),"^",5)) D  Q
 . S LRLABEL=$P(BLRDEVLS(0),"^",4,5)
 ;
 ; Intermec 3000/4000 printer
 I $P(BLRDEVLS(0),"^",2)=1 D
 . I $P(BLRDEVLS(0),"^",3)=1 S LRLABEL="^LRLABELC" Q  ; 1x3 label
 . I $P(BLRDEVLS(0),"^",3)=2 S LRLABEL="^LRLABELA" Q  ; 1x2 label
 . I $P(BLRDEVLS(0),"^",3)=3 S LRLABEL="^LRLABELB" Q  ; 10 part label
 ;
 ; Zebra ZPL II compatible printer
 I $P(BLRDEVLS(0),"^",2)=2 D
 . I $P(BLRDEVLS(0),"^",3)=1 S LRLABEL="^LRLABELG" Q  ; 1x3 label
 . I $P(BLRDEVLS(0),"^",3)=2 S LRLABEL="^LRLABELD" Q  ; 1x2 label
 . I $P(BLRDEVLS(0),"^",3)=3 S LRLABEL="^LRLABELE" Q  ; 10 part label
 ;
 Q
