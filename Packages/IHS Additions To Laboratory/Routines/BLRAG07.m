BLRAG07 ; IHS/MSC/SAT - LABORATORY ACCESSION GUI RPCS ;
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
 ;---------------------------------------------------------------
 ; Lookup ICD's matching input
 ;  BLRINP   = (required) Partial name lookup - free text
 ;  BLRLEX   = (optional) Use Lexicon
 ;                           0=ICD9 lookup (default)
 ;                           1=Lexicon lookup
 ;  BLRVDT   = (optional) Visit date in external format
 ;  BLRGEN   = (optional) patient gender
 ;  BLRECOD  = (optional) allow ECodes flag:
 ;                           0=exclude (default)
 ;                           1=include
 ;                           2=ecodes only
 ;  BLRVCOD  = (optional) allow VCodes flag:
 ;                           0=include
 ;                           1=exclude
 ;                           2=vcodes only
 ;  Returned as a list of records in the format:
 ;    0                  1         2                3
 ;    Descriptive Text ^ ICD IEN ^ Narrative Text ^ ICD Code
ICDLKUP(BLRY,BLRINP,BLRLEX,BLRVDT,BLRGEN,BLRECOD,BLRVCOD) ;EP - ICD lookup
 ;  rpc: BLR ICD LOOKUP
 ;INPUT:
 ;  BLRINP = (required) Partial name lookup - free text; must be at least 3 characters
 ;  BLRLEX = (optional) Use Lexicon
 ;    0=ICD9 lookup (default)
 ;    1=Lexicon lookup
 ;  BLRVDT = (optional) Visit date in external format
 ;  BLRGEN = (optional) patient gender
 ;  BLRECOD = (optional) allow ECodes flag:
 ;    0=exclude (default)
 ;    1=include
 ;    2=ecodes only
 ;  BLRVCOD = (optional) allow VCodes flag:
 ;    0=include
 ;    1=exclude
 ;    2=vcodes only
 ;RETURN:
 ; Returned as a list of records in the format:
 ;  0                  1         2                3
 ;  Descriptive Text ^ ICD IEN ^ Narrative Text ^ ICD Code
 ;
 N DIC,X,Y,I,ICD,LEX,RES
 N AICDRET,XTLKSAY,REC,DESC,CODE,NARR
 N BLRI
 S BLRLEX=$G(BLRLEX)
 S BLRVDT=$G(BLRVDT)
 S BLRGEN=$G(BLRGEN)
 S BLRECOD=$G(BLRECOD)
 S BLRVCOD=$G(BLRVCOD)
 D ^XBKVAR S X="ERROR^BLRAGUT",@^%ZOSF("TRAP")
 S BLRI=0
 K ^TMP("BLRAG",$J)
 S BLRY=$$TMPGLB^BLRAGUT()
 S @BLRY@(0)="ERROR_ID"
 ;
 I $L($G(BLRINP))<3 D ERR^BLRAGUT("BLRAG07: User name lookup requires at least 3 characters.") Q
 S:BLRVDT'="" BLRVDT=$$CVTDATE^BLRAGUT(BLRVDT)  ;convert date to FM format
 ; 
 I BLRLEX D
 .N HITS
 .D LEXLKUP^BLRAGUT(.HITS,BLRINP_"^ICD")
 .S HITS=0
 .F  S HITS=$O(HITS(HITS)) Q:'HITS  D
 ..S BLRLEX=+HITS(HITS)
 ..S X=$$ICDONE^LEXU(BLRLEX)
 ..Q:X=""
 ..S ICD=$O(^ICD9("BA",X,0))
 ..S:'ICD ICD=$O(^ICD9("BA",X_" ",0))
 ..D:ICD CHKHITS
 E  I $G(DUZ("AG"))="I"  D
 .S DIC="^ICD9(",DIC(0)="TM",X=BLRINP,XTLKSAY=0
 .K ^UTILITY("AICDHITS",$J),^TMP("XTLKHITS",$J)
 .D ^DIC
 .I Y'=-1 D
 ..S ICD=+Y
 ..D CHKHITS
 .E  I $G(^DD(80,0,"DIC"))="XTLKDICL" D
 ..D XTLKUP
 .E  D AICDLKUP
 .I 'BLRI,$L(BLRINP)>2 D
 ..N LK,LN
 ..S LK=BLRINP,LN=$L(BLRINP)
 ..F  D  S LK=$O(^ICD9("BA",LK)) Q:$E(LK,1,LN)'=BLRINP
 ...S ICD=0
 ...F  S ICD=$O(^ICD9("BA",LK,ICD)) Q:'ICD  D CHKHITS
 .K ^UTILITY("AICDHITS",$J),^TMP("XTLKHITS",$J)
 E  D
 .D FIND^DIC(80,,".01;10","M",BLRINP,,,,,"RES")
 .I '$O(RES("DILIST",0)) Q
 .M ^TMP("XTLKHITS",$J)=RES("DILIST",2)
 .D XTLKUP
 .K ^TMP("XTLKHITS",$J)
 K @BLRY@(0)
 ;            0           1       2         3
 S @BLRY@(0)="DESCRIPTION^ICD_IEN^NARRATIVE^ICD_CODE"
 Q
AICDLKUP S I=0
 F  S I=$O(^UTILITY("AICDHITS",$J,I)) Q:'I  D
 .S ICD=$G(^UTILITY("AICDHITS",$J,I))
 .D CHKHITS
 Q
XTLKUP S I=0
 F  S I=$O(^TMP("XTLKHITS",$J,I)) Q:'I  D
 .S ICD=$G(^TMP("XTLKHITS",$J,I))
 .D CHKHITS
 Q
CHKHITS Q:$D(@BLRY@(0,ICD))  S @BLRY@(0,ICD)=""
 S REC=$G(^ICD9(ICD,0))
 Q:$P(REC,U,9)
 I 'BLRECOD,$E(REC)="E" Q
 I BLRECOD=2,$E(REC)'="E" Q
 I BLRVCOD=1,$E(REC)="V" Q
 I BLRVCOD=2,$E(REC)'="V" Q
 I BLRVDT,$P(REC,U,11),$$FMDIFF^XLFDT(BLRVDT,$P(REC,U,11))>-1 Q
 I $L(BLRGEN),$P(REC,U,10)'="",BLRGEN'=$P(REC,U,10) Q
 S NARR=$G(^ICD9(ICD,1)),CODE=$P(REC,U),DESC=$P(REC,U,3)
 S BLRI=BLRI+1
 S @BLRY@(BLRI)=DESC_U_ICD_U_NARR_U_CODE
 Q
 ;
ORL(BLRY,BLRINP)  ;return order reasons from file 100.03
 ; rpc: BLR ORDER REASON LKUP
 ;  BLRINP   = (optional) Partial name lookup - free text
 ;  Returned as a list of records in the format:
 ;    0     1
 ;    IEN ^ NAME
 ;   If the DEFAULT DC REASON from the LABORATORY SITE file 69.9 is
 ;      defined, it will be the 1st entry in the return.
 N BLRDEF,BLRI,BLRIEN,BLRJ
 S BLRINP=$G(BLRINP)
 D ^XBKVAR S X="ERROR^BLRAGUT",@^%ZOSF("TRAP")
 S BLRI=0
 K ^TMP("BLRAG",$J)
 S BLRY=$$TMPGLB^BLRAGUT()
 ;            0   1
 S @BLRY@(0)="IEN^NAME"
 S BLRDEF=$P($G(^LAB(69.9,1,"OR")),"^",2)
 I BLRDEF'="" S BLRI=BLRI+1 S @BLRY@(BLRI)=BLRDEF_U_$P($G(^ORD(100.03,BLRDEF,0)),U,1)  ;set default DC reason as first entry
 S BLRJ=$S(BLRINP'="":$$PREP^BLRAGUT(BLRINP),1:"") F  S BLRJ=$O(^ORD(100.03,"B",BLRJ)) Q:BLRJ=""  Q:BLRINP'[$E(BLRJ,1,$L(BLRINP))  D
 .S BLRIEN=$O(^ORD(100.03,"B",BLRJ,0))
 .S BLRI=BLRI+1 S @BLRY@(BLRI)=BLRIEN_U_BLRJ
 Q
