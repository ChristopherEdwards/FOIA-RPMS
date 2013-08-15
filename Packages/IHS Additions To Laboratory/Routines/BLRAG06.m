BLRAG06 ; IHS/MSC/SAT - LABORATORY ACCESSION GUI RPCS ;
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
BLC(BLRY,BLRDFN) ;check BLR PT CONFIRM parameter and return insurances for patient
 ; RPC = BLR COLLECTION INFO
 ;INPUT:
 ;  .BLRY    = returned pointer to appointment data
 ;   BLRDFN  = (required) pointer to VA PATIENT file 2
 ;
 ; Returns in first record:
 ;   Patient IEN
 ;   Current User IEN
 ;   Current User Name
 ;   Patient Confirmation enabled; 0='no' (default); 1='yes'
 ; 2nd and following records are INSURANCE_DATA as returned in ^AGINS:
 ;      INS_NAME^INS_IEN^??^COVERAGE_NUMBER^ELIGIBILITY_DATE^EXP_DATE^
 ;      INS_FILE_POINTER^POLICY_HOLDER_NAME^POLICY^...
 ;
 N BLRI
 N BLRINSD,BLRINSI,BLRINS,BLRPTCF,BLRUSERN
 S (BLRINSD,BLRINSI,BLRINS)=""
 D ^XBKVAR S X="ERROR^BLRAGUT",@^%ZOSF("TRAP")
 K BLRIFNL,BLRLTMP
 S BLRI=0
 K ^TMP("BLRAG",$J)
 S BLRY="^TMP(""BLRAG"","_$J_")"
 S ^TMP("BLRAG",$J,0)="ERROR_ID"
 ;
 I '+$G(BLRDFN) D ERR^BLRAGUT("BLRAG06: Invalid patient.") Q
 I '+$G(DUZ) D ERR^BLRAGUT("BLRAG06: Invalid user defined.") Q
 ;
 S BLRUSERN=$$GET1^DIQ(200,DUZ_",",.01)  ;get user name
 S BLRPTCF=$$PTC^BLRAGUT()               ;get patient confirmation flag
 S BLRI=BLRI+1 S ^TMP("BLRAG",$J,BLRI)=BLRDFN_U_DUZ_U_BLRUSERN_U_BLRPTCF
 K AGINS
 S DFN=BLRDFN
 D ^AGINS
 S BLRINSI="" F  S BLRINSI=$O(AGINS(BLRINSI)) Q:BLRINSI=""  D
 .S BLRINSD=AGINS(BLRINSI)
 .;S BLRINS=BLRINS_$S(BLRINS'="":"|",1:"")_$P(BLRINSD,U,1)_":"_$P(BLRINSD,U,2)_":"_$P(BLRINSD,U,9)_":"_$P(BLRINSD,U,6)
 .S BLRI=BLRI+1 S ^TMP("BLRAG",$J,BLRI)=BLRINSD
 ;                      0         1                      2                       3                4
 S ^TMP("BLRAG",$J,0)="T00020DFN^T00020DEFAULT_USER_IEN^T00020DEFAULT_USER_NAME^T00020PT_CONFIRM^T00400INSURANCE_DATA"
 Q
 ;
NP(BLRY,BLRPN) ;EP BLR USER LOOKUP remote procedure
 ; return entries from the NEW PERSON table 200 that are 'active'
 ;INPUT:
 ;  BLRPN = text representing partial name for NEW PERSON lookup; must be at least 3 characters
 ;RETURN:
 ;   Global array containing entries from the NEW PERSON file 200.
 ;     NEW_PERSON_IEN^NAME
 N BLRC,BLRN,BLRI,BLRNPS
 ;
 D ^XBKVAR S X="ERROR^BLRAGUT",@^%ZOSF("TRAP")
 S BLRI=0
 K ^TMP("BLRAG",$J)
 S BLRY="^TMP(""BLRAG"","_$J_")"
 S ^TMP("BLRAG",$J,0)="ERROR_ID"
 I $L($G(BLRPN))<3 D ERR^BLRAGUT("BLRAG06: User name lookup requires at least 3 characters.") Q
 S BLRN=$$PREP(BLRPN) F  S BLRN=$O(^VA(200,"B",BLRN)) Q:BLRN=""  Q:BLRPN'[$E(BLRN,1,$L(BLRPN))  D
 . S BLRC=$O(^VA(200,"B",BLRN,""))
 . S BLRNPS=$G(^VA(200,BLRC,"PS"))
 . I ($P(BLRNPS,U,4)="") D
 . . S BLRI=BLRI+1 S ^TMP("BLRAG",$J,BLRI)=BLRC_U_BLRN
 S ^TMP("BLRAG",$J,0)="T00020NEW_PERSON_IEN^T00020NAME"
 Q
 ;
PREP(NAME) ;prep input for partial name lookup - decrement last char of name for $O; up-shift all alpha characters
 N BLRL
 Q:$G(NAME)="" -1
 S NAME=$$UPS(NAME)
 Q:$E(NAME,$L(NAME))'?1A NAME
 S BLRL=$E(NAME,$L(NAME))
 S BLRL=$A(BLRL)-1
 Q $E(NAME,1,$L(NAME)-1)_$C(BLRL)_"~"
 ;
UPS(NAME) ;upshift and check punctuation of input
 N BLRDGC,BLRDGI
 F BLRDGI=1:1:$L(NAME) S BLRDGC=$E(NAME,BLRDGI) D:$$FC1(.BLRDGC,1)
 .S NAME=$E(NAME,0,BLRDGI-1)_BLRDGC_$E(NAME,BLRDGI+1,999)
 .Q
 Q NAME
 ;
FC1(DGC,DGCOMA) ;Transform single character
 ;Input: DGC=character to transform (pass by reference)
 ;    DGCOMA=comma indicator
 ;Output: 1 if value is changed, 0 otherwise
 ;
 S DGC=$E(DGC) Q:'$L(DGC) 0
 ;See if comma stays
 I DGCOMA'=3,DGC?1"," Q 0
 ;Retain uppercase, numeric, hyphen, apostrophe and space
 Q:DGC?1U!(DGC?1N)!(DGC?1"-")!(DGC?1"'")!(DGC?1" ") 0
 ;Retain parenthesis, bracket and brace characters
 Q:DGC?1"("!(DGC?1")")!(DGC?1"[")!(DGC?1"]")!(DGC?1"{")!(DGC?1"}") 0
 ;Transform lowercase to uppercase
 I DGC?1L S DGC=$C($A(DGC)-32) Q 1
 ;Set all other characters to space
 S DGC=" " Q 1
