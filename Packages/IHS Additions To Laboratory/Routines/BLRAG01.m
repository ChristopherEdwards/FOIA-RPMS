BLRAG01 ; IHS/MSC/SAT - LABORATORY ACCESSION GUI RPCS ;
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
 ;  BLR MANIFEST TEST ADD    - ADDTEST^BLRAG09C= Add tests to an existing manifest
 ;  BLR MANIFEST TEST REMOVE - REMVTST^BLRAG09C= Remove a test from manifest - actually flags test as "removed".
 ;  BLR MANIFEST TESTS TO ADD- TARPC^BLRAG09B  = return tests that can be added to a manifest
 ;
 ;return all non-accessioned lab records - RPC
ANA(BLRY,BLRDFN,BLRUSRDY) ;return appointment data for given patient - RPC
 ; RPC Name is BLR ALL NON-ACCESSIONED
 ;INPUT:
 ;  .BLRY   = returned pointer to appointment data
 ;   BLRDFN = (optional) return all non-accessioned lab records for this
 ;                        given patient only
 ;                       return for all patients of this parameter
 ;                        is not defined
 ;   BLRUSRDY = Temporary User Override of the BLR DAYS TO ACCESSION XPAR Parameter
 ;
 ;RETURNS:
 ;   (0) DFN
 ;   (1) PNAME
 ;   (2) HRN
 ;   (3) DOB
 ;   (5) IFN
 ;   (6) Grp
 ;   (7) ActTm
 ;   (8) StrtTm
 ;   (9) StopTm
 ;  (10) Sts
 ;  (11) Sig
 ;  (12) Nrs
 ;  (13) Clk
 ;  (14) PrvID
 ;  (15) PrvNam
 ;  (16) ActDA
 ;  (17) Flag
 ;  (18) DCType
 ;  (19) ChrtRev
 ;  (20) DEA#
 ;  (21) <NOT USED>
 ;  (22) SCHEDULE
 ;  (23) ORDER_TEXT
 ;  (24) DETAIL_TEXT
 ;  (25) STREET_LINE1
 ;  (26) STREET_LINE2
 ;  (27) STREET_LINE3
 ;  (28) CITY
 ;  (29) STATE
 ;  (30) ZIP
 ;  (31) SEX
 ;  (32) COLLECTION_TYPE
 ;  (33) DATE_TIME_ORDERED
 ;  (34) LAB_ORDER_#
 ;  (35) TEST_NAME
 ;  (36) COLLECTION_SAMPLE
 ;  (37) SPECIMENS
 ;  (38) SSN
 ;  (39) ACCESSION_#
 ;  (40) LRO69_POINTERS
 ;  (41)LAB_INSTRUCTS
 ;
 N BLR60NAM,BLR62NAM,BLRSPNS,BLRTOP
 N BLRACCNO
 N BLRDT,BLRI,BLRIFNL,BLRJ,BLRK,BLRLCNT,BLRLI,BLRLRDFN,BLRLST,BLRLSTI,BLROI
 N BLRLTMP,BLRNODS,BLRNODT,BLROERR,BLROLOC,BLRPADD
 N BLRPHRN,BLRPNAM,BLRSEX,BLRSP,BLRT,BLRTI,BLRSSN,BLRTMP
 NEW BLRSDAYS,LRDFN,PASTDAYS,FUTUDAYS
 ;
 ;   ^TMP("BLRAG01",$J,DFN,<BLRTI counter>)=data
 K ^TMP("BLRAG01",$J)  ;used to keep records for same patient together
 S (BLRACCNO,BLRPAD1,BLRPAD2,BLRPAD3,BLRPADC,BLRPADS,BLRPADZ,BLRSSN,BLRTMP)=""
 D ^XBKVAR S X="ERROR^BLRAGUT",@^%ZOSF("TRAP")
 K BLRIFNL,BLRLTMP
 S (BLRI,BLRLCNT,BLROI,BLRTI)=0
 S BLRDFN=$G(BLRDFN)
 K ^TMP("BLRAG",$J)
 S BLRY="^TMP(""BLRAG"","_$J_")"
 ; LRO69_POINTERS = pointers to the LAB ORDER ENTRY file 69; BLRDT:BLRSP:BLRTEST; passed into BLR DELETE TEST
 S BLRTMP($J,0)="ERROR_ID"
 ;
 ; Use the 'Return Days To Accession' XPAR Parameter to determine how many days to go back and forward.
 ; If the parameter is zero, use 90 Days.
 D RETDTA^BLRAG10(.BLRSDAYS)           ; Get 'Return Days To Accession' XPAR Parameter
 S:+$G(BLRUSRDY) BLRSDAYS=BLRUSRDY     ; If user over-ride passed in, then use that
 ;
 ; Set 'How many days in the past' Variable
 S PASTDAYS=$S(BLRSDAYS:$$HTFM^XLFDT(+$H-(BLRSDAYS+1)),1:$$HTFM^XLFDT(+$H-91))
 ;
 ; Set 'How many days in the future' Variable
 S FUTUDAYS=+$O(^LRO(69,"AA"),-1)      ; Get "last" Date in Lab Order Entry (#69) file
 S FUTUDAYS=$S(BLRSDAYS:$$HTFM^XLFDT(+$H+BLRSDAYS),FUTUDAYS>$$DT^XLFDT:FUTUDAYS,1:$$HTFM^XLFDT(+$H+89))
 ;
 S LRDFN=$S(+$G(BLRDFN):+$G(^DPT(BLRDFN,"LR")),1:0)   ; Set LRDFN variable
 ;
 I LRDFN D
 . S BLRDT=PASTDAYS
 . F  S BLRDT=$O(^LRO(69,"D",LRDFN,BLRDT)) Q:BLRDT'>0!(BLRDT>FUTUDAYS)  D      ; date level
 ..S BLRSP=0  F  S BLRSP=$O(^LRO(69,"D",LRDFN,BLRDT,BLRSP)) Q:BLRSP'>0  D      ; specimen mult level
 ...D ANA1(BLRDT,BLRSP,.BLRTI)
 ;
 I LRDFN<1 D
 . S BLRDT=PASTDAYS
 . F  S BLRDT=$O(^LRO(69,BLRDT)) Q:BLRDT'>0!(BLRDT>FUTUDAYS)  D     ; date level
 ..S BLRSP=0  F  S BLRSP=$O(^LRO(69,BLRDT,1,BLRSP)) Q:BLRSP'>0  D   ; specimen mult level
 ...D ANA1(BLRDT,BLRSP,.BLRTI)
 ;
 D ANAHD
 S BLRJ="" F  S BLRJ=$O(^TMP("BLRAG01",$J,BLRJ)) Q:BLRJ=""  D
 .S BLRK="" F  S BLRK=$O(^TMP("BLRAG01",$J,BLRJ,BLRK)) Q:BLRK=""  D
 ..S BLRI=BLRI+1
 ..S ^TMP("BLRAG",$J,BLRI)=^TMP("BLRAG01",$J,BLRJ,BLRK)
 ;
 ;S BLRI=BLRI+1
 ;S ^TMP("BLRAG",$J,BLRI)=$C(31)
 K ^TMP("BLRAG01",$J)
 Q
 ;
ANA1(BLRDT,BLRSP,BLRTI) ;
 ; BLRDT = date in FM format; pointer to LAB ORDER ENTRY file ^LRO(69,BLRDT
 ; BLRSP = Specimen pointer to LAB ORDER ENTRY file ^LRO(69,BLRDT,1,BLRSP
 ; BLRTI = counter for global array entries
 S BLRNODS=$G(^LRO(69,BLRDT,1,BLRSP,0))        ;get specimen mult node
 Q:$G(BLRNODS)=""
 Q:$P(BLRNODS,U,4)="LC"   ;do not include LAB COLLECT
 S BLRSPNS=""   ; list of specimen names delimited by pipe |
 S BLRK=0 F  S BLRK=$O(^LRO(69,BLRDT,1,BLRSP,4,BLRK)) Q:BLRK'>0  D
 .S BLRTOP=$P($G(^LRO(69,BLRDT,1,BLRSP,4,BLRK,0)),U,1)
 .S BLRSPNS=$S(BLRSPNS'="":"|",1:"")_$$GET1^DIQ(61,BLRTOP_",",.01)
 S BLR62NAM=$P($G(^LAB(62,+$P(BLRNODS,U,3),0)),U,1)
 S BLRORD=$P($G(^LRO(69,BLRDT,1,BLRSP,.1)),U,1)
 Q:$G(BLRORD)=""
 S BLRT=0 F  S BLRT=$O(^LRO(69,BLRDT,1,BLRSP,2,BLRT)) Q:BLRT'>0  D   ;test mult level
 .S BLRNODT=$G(^LRO(69,BLRDT,1,BLRSP,2,BLRT,0))  ;get test mult node
 .I $P(BLRNODT,U,3)="",$P(BLRNODT,U,9)'="CA" D                     ;If no accession date ...
 ..S BLRLRDFN=$P(BLRNODS,U,1)                ;get lab data IEN
 ..S BLRLRND=$G(^LR(BLRLRDFN,0))
 ..I $P(BLRLRND,U,2)=2 D
 ...; S BLR60NAM=$$GET1^DIQ(60,+$P(BLRNODT,U,1)_",",.01)  ;get test name
 ...S BLR60NAM=$$TESTNAME^BLRAGUT(+$P(BLRNODT,U,1))  ;get test name
 ...K BLRINST S BLRINST=""
 ...D INST(+$P(BLRNODT,U,1),+$P(BLRNODS,U,3),.BLRINST)         ;get lab instructions
 ...S BLRPDFN=$P(BLRLRND,U,3)               ;get patient IEN
 ...I ('$G(BLRDFN))!(BLRDFN=BLRPDFN) D
 ....S BLRPNAM=$P(^DPT(BLRPDFN,0),U,1)        ;get patient name
 ....S BLRPHRN=$$HRN^AUPNPAT(BLRPDFN,DUZ(2))  ;get patient HRN
 ....S BLRPDOB=$$DOB^AUPNPAT(BLRPDFN)         ;get patient DOB
 ....S BLRPSEX=$$SEX^AUPNPAT(BLRPDFN)         ;get patient gender
 ....S BLRPADD=$G(^DPT(BLRPDFN,.11))          ;get patient address node
 ....S BLRSSN=$$SSN^AUPNPAT(BLRPDFN)          ;get patient SSN
 ....S BLROERR=$P(BLRNODT,U,7)                ;get order IEN
 ....S BLRACCNO=$$GACE69^BLRAGUT(BLRDT,BLRSP,BLRT)  ;get accession number
 ....S BLRIFNL(1)=BLROERR
 ....K BLRDLST,BLRFLST
 ....S (BLRDLST,BLRFLST)=""
 ....D GET4V11^ORWORR(.BLRFLST,"",0,.BLRIFNL)
 ....D DETAIL^ORWOR(.BLRDLST,BLROERR)
 ....S BLRTI=BLRTI+1
 ....S ^TMP("BLRAG01",$J,BLRPDFN,BLRTI)=BLRPDFN_U_BLRPNAM_U_BLRPHRN_U_BLRPDOB_U
 ....S BLRTMP=""
 ....S BLRLSTI=$O(BLRFLST(0))
 ....S BLRTMP=$E($P(BLRFLST(BLRLSTI),U,1),2,$L(BLRFLST(BLRLSTI)))
 ....F BLRJ=2:1:18 D
 .....S $P(BLRTMP,U,BLRJ)=$P(BLRFLST(BLRLSTI),U,BLRJ)
 ....S BLRTI=BLRTI+1
 ....S ^TMP("BLRAG01",$J,BLRPDFN,BLRTI)=BLRTMP_U
 ....F  S BLRLSTI=$O(BLRFLST(BLRLSTI)) Q:BLRLSTI=""  D
 .....S BLRTI=BLRTI+1
 .....S ^TMP("BLRAG01",$J,BLRPDFN,BLRTI)=$E(BLRFLST(BLRLSTI),2,$L(BLRFLST(BLRLSTI)))
 ....S BLRTI=BLRTI+1,^TMP("BLRAG01",$J,BLRPDFN,BLRTI)=U
 ....S BLRLSTI=0 F  S BLRLSTI=$O(^TMP("ORTXT",$J,BLRLSTI)) Q:BLRLSTI=""  D
 .....S BLRTI=BLRTI+1
 .....S ^TMP("BLRAG01",$J,BLRPDFN,BLRTI)=^TMP("ORTXT",$J,BLRLSTI)_"|"
 ....S BLRTMP1=U_$P(BLRPADD,U,1)_U_$P(BLRPADD,U,2)_U_$P(BLRPADD,U,3)_U_$P(BLRPADD,U,4)_U_$P(BLRPADD,U,5)_U
 ....S BLRTMP1=BLRTMP1_$P(BLRPADD,U,6)_U_BLRPSEX_U_$P(BLRNODS,U,4)_U_$P(BLRNODS,U,5)_U
 ....S BLRTMP1=BLRTMP1_BLRORD_U_BLR60NAM_U_BLR62NAM_U_BLRSPNS_U_BLRSSN_U_BLRACCNO_U_BLRDT_":"_BLRSP_":"_BLRT_U
 ....S BLRTI=BLRTI+1
 ....S ^TMP("BLRAG01",$J,BLRPDFN,BLRTI)=BLRTMP1
 ....S BLRTMP1=""
 ....S BLRD="" F  S BLRD=$O(BLRINST(BLRD)) Q:BLRD=""  S BLRTI=BLRTI+1 S ^TMP("BLRAG01",$J,BLRPDFN,BLRTI)=BLRINST(BLRD)_"|"
 ....S BLRTI=BLRTI+1,^TMP("BLRAG01",$J,BLRPDFN,BLRTI)="~~~"_$C(30)
 Q
 ;
ANAHD ;
 ;               0         1           2         3
 S BLRTMP="T00020DFN^T00020PNAME^T00020HRN^T00020DOB^"
 ;                      4         5         6           7            8            9
 S BLRTMP=BLRTMP_"T00020IFN^T00020Grp^T00020ActTm^T00020StrtTm^T00020StopTm^T00020Sts^"
 ;                      10        11        12        13          14           15
 S BLRTMP=BLRTMP_"T00020Sig^T00020Nrs^T00020Clk^T00020PrvID^T00020PrvNam^T00020ActDA^"
 ;                      16         17           18            19  20      21
 S BLRTMP=BLRTMP_"T00020Flag^T00020DCType^T00020ChrtRev^T00020DEA#^^T00020SCHEDULE^"
 ;                      22               23
 S BLRTMP=BLRTMP_"T00900ORDER_TEXT^T00900DETAIL_TEXT^"
 ;                      24                 25                 26                 27         28          29        30
 S BLRTMP=BLRTMP_"T00020STREET_LINE1^T00020STREET_LINE2^T00020STREET_LINE3^T00020CITY^T00020STATE^T00020ZIP^T00020SEX^"
 ;                      31                    32                      33                34              35
 S BLRTMP=BLRTMP_"T00020COLLECTION_TYPE^T00020DATE_TIME_ORDERED^T00020LAB_ORDER_#^T00020TEST_NAME^T00020COLLECTION_SAMPLE^"
 ;                      36              37        38                39                   40
 S BLRTMP=BLRTMP_"T00020SPECIMENS^T00020SSN^T00020ACCESSION_#^T00020LRO69_POINTERS^T00500LAB_INSTRUCTS"
 S ^TMP("BLRAG",$J,0)=BLRTMP_"~~~"_$C(30)
 Q
 ;
INST(BLRLRDFN,BLRCS,BLRRET) ; get lab instructions for given lab test and collection sample
 ; BLRLRDFN = pointer to LABORATORY TEST file 60
 ; BLRCS    = pointer to COLLECTION SAMPLE file 62
 ; BLRRET   = returned lab instructions array
 ;            BLRRET(COUNT)=TEXT
 N BLRD,BLRCSIEN
 S BLRRET=""
 S BLRCSIEN=$O(^LAB(60,BLRLRDFN,3,"B",BLRCS,0))
 Q:BLRCSIEN=""
 S BLRD=0 F  S BLRD=$O(^LAB(60,BLRLRDFN,3,BLRCSIEN,2,BLRD)) Q:BLRD'>0  D
 .S BLRRET(BLRD)=^LAB(60,BLRLRDFN,3,BLRCSIEN,2,BLRD,0)
 Q
 ;
PTC(BLRY) ; rpc to return the value of the BLR PT CONFIRM parameter
 ; RPC: BLR PT CONFIRM ENABLED
 ; Returns Patient Confirmation enabled; 0='no' (default); 1='yes'
 N BLRDOM,BLRENT,BLRI,BLRPAR
 K ^TMP("BLRAG",$J)
 D ^XBKVAR S X="ERROR^BLRAGUT",@^%ZOSF("TRAP")
 S BLRI=0
 S BLRY="^TMP(""BLRAG"","_$J_")"
 S ^TMP("BLRAG",$J,BLRI)="T00020PT_CONFIRM"_$C(30)
 S BLRDOM=$$GET1^DIQ(8989.3,"1,",.01,"I")
 S BLRENT=BLRDOM_";"_"DIC(4.2,"
 S BLRPAR=$O(^XTV(8989.51,"B","BLR PT CONFIRM",0))
 S BLRRET=$$GET^XPAR(BLRENT,BLRPAR,1,"Q")
 S BLRI=BLRI+1 S ^TMP("BLRAG",$J,BLRI)=$S(BLRRET'="":BLRRET,1:0)_$C(30)
 ;S BLRI=BLRI+1 S ^TMP("BLRAG",$J,BLRI)=$C(31)
 Q
 ;
PTCS(BLRY,BLRDT,BLRSPN,BLRUSER,BLRDTCF,BLRMETH) ;rpc to store Patient Confirmation data to the Specimen Multiple of the LAB ORDER ENTRY file
 ; RPC: BLR PT CONFIRM STORE
 ; BLRDT   = (required) order date in external format - pointer to LAB ORDER ENTRY file 69
 ; BLRSPN  = (required) specimen number - pointer to specimen multiple in LAB ORDER ENTRY file 69
 ; BLRUSER = (required) user that did confirmation - pointer to NEW PERSON file 200
 ; BLRDTCF = (optional) Date/Time of user confirmation in external format - defaults to 'today'
 ; BLRMETH = (optional) method of confirmation - free text
 N BLRI,BLRM
 K ^TMP("BLRAG",$J)
 D ^XBKVAR S X="ERROR^BLRAGUT",@^%ZOSF("TRAP")
 S BLRI=0
 S BLRY="^TMP(""BLRAG"","_$J_")"
 S ^TMP("BLRAG",$J,BLRI)="T00020ERROR_ID"  ;0=clean; Text=error
 ;convert external date to FM format
 S X=$G(BLRDT),%DT="XT" D ^%DT S BLRDT=$P(Y,".")
 ;error if invalid date passed in
 I $$FR^XLFDT($G(BLRDT)) D ERR^BLRAGUT("BLRAG01: Invalid order date.") Q
 I '$G(BLRSPN) D ERR^BLRAGUT("BLRAG01: Invalid Specimen Number.") Q
 I '$G(BLRUSER)!'$D(^VA(200,BLRUSER)) D ERR^BLRAGUT("BLRAG01: Invalid User.") Q
 S BLRORD=$P(^LRO(69,BLRDT,1,BLRSPN,.1),U,1)
 I '$D(^LRO(69,BLRDT,1,BLRSPN))!(BLRORD="") D ERR^BLRAGUT("BLRAG01: Invalid Order.") Q
 ;;
 TSTART
 L +^LRO(69,"C",+$G(BLRORD)):1
 ;L +^LRO(69,BLRDT,1,BLRSPN):5
 I '$T TROLLBACK  D ERR^BLRAGUT("BLRAG01: File being modified elsewhere.") Q
 ;if confirmation date is null, default to NOW
 I $G(BLRDTCF)="" S BLRDTCF=$$HTFM^XLFDT($H)
 E  D
 .;convert external date to FM format
 .S X=BLRDTCF,%DT="XT" D ^%DT S BLRDTCF=Y
 .;default to 'NOW' if invalid date passed in
 .S:$$FR^XLFDT($G(BLRDTCF)) BLRDTCF=$$HTFM^XLFDT($H)
 K BLRM
 S BLRM=""
 S FDA(69.01,BLRSPN_","_+BLRDT_",",21400)=BLRUSER
 S FDA(69.01,BLRSPN_","_+BLRDT_",",21401)=BLRDTCF
 S FDA(69.01,BLRSPN_","_+BLRDT_",",21402)=BLRMETH
 D FILE^DIE("","FDA","BLRM")
 I $D(BLRM("DIERR")) D ERR^BLRAGUT("BLRAG01: "_BLRM("DIERR",1,"TEXT",1)) L -^LRO(69,BLRDT,1,BLRSPN) TROLLBACK  Q
 ; L -^LRO(69,BLRDT,1,BLRSPN)
 D UNL69
 TCOMMIT
 ;;
 S BLRI=BLRI+1 S ^TMP("BLRAG",$J,BLRI)=0_$C(30)
 ;S BLRI=BLRI+1 S ^TMP("BLRAG",$J,BLRI)=$C(31)
 Q
 ;
UNL69 ;
 L -^LRO(69,"C",+$G(LRORD))
 Q
