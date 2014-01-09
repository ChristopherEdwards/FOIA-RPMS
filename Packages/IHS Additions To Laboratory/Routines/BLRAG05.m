BLRAG05 ; IHS/MSC/SAT - LABORATORY ACCESSION GUI RPCS ; 01 MAY 2013  1300;SAT
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
 ;accessioning GUI (from LROE)
ACC(BLRY,BLRTSTL,BLRCDT,BLRCUSR,BLRPTCM,BLRPTCU,BLRRO,BLRUNC,BLRPAC,BLRBT,BLRAGINS,BLRRLCLA,BLRAOE) ; BLR ACCESSION rpc
 ; BLRTSTL   = (required) The "TEST POINTERS" portion of this data comes
 ;                   element 39 in the return from BLR ALL NON-ACCESSIONED.
 ;                       List of test pointers with ICD9 pointers for each
 ;                       test/procedure being accessioned separated by ^.
 ;                       Each ^ piece is made up of these pipe pieces:
 ;                       TEST POINTERS | [ICD9_IEN:ICD9_IEN:...] ^ ...
 ;                        Test pointers = pointers to the LAB ORDER ENTRY
 ;                        file 69 - DATE:SPECIMEN:TEST
 ;                       ICD9_IEN - pointer to ICD DIAGNOSIS file 80
 ; BLRCDT   = (required) Specimen Collection Date in external format
 ; BLRCUSR  = (required) Specimen Collector - pointer to NEW PERSON file 200
 ; BLRPTCM  = (optional) Method of patient confirmation - free-text up
 ;                       to 80 characters
 ; BLRPTCU  = (optional) user that performed patient confirmation - pointer
 ;                       to NEW PERSON file 200
 ; BLRRO    = (optional) 'Continue if Rollover' Flag?
 ;                       0=(default) return with message if Rollover has
 ;                                   not happened or is in progress
 ;                        1=continue as if user chose to 'continue anyway'
 ; BLRUNC   = (optional) 'Continue if Uncollected' flag?
 ;                        0=(default) return with message if not collected
 ;                        1=continue as if user chose to 'continue anyway'
 ; BLRPAC   = (optional) 'Continue if previously accessioned' flag
 ;               0=(default) return with message if previously accessioned
 ;               1=continue as if user chose to 'continue anyway'
 ; BLRBT    = (optional) Billing Type; P=Patient, C=Client, T=Third Party
 ; BLRAGINS = Required if Billing Type = T;
 ;                     INSURANCE_DATA as returned in BLR COLLECTION INFO:
 ;      INS_NAME^INS_IEN^??^COVERAGE_NUMBER^ELIGIBILITY_DATE^EXP_DATE^
 ;        INS_FILE_POINTER^POLICY_HOLDER_NAME^POLICY^...
 ; BLRRLCLA = reference lab client account number
 ;            REF LAB CLIENT ACCOUNT NUMBER multiple
 ;            in BLR MASTER CONTROL
 ; BLRAOE   = List of Ask At Order Questions separated by pipe |
 ;            Each pipe piece contains the following ^ pieces:
 ;              <question prompt> ^ <result code> ^ <free-text answer> ^ <test name> (test name if from the LABORATORY TEST file 60
 ;
 ; RETURNS:
 ;  ERROR_ID ^ POINTER ^ ACCESSION_OR_MESSAGE ^ UID ^ TEST_NAME
 ;   ERROR_ID =  0=clean
 ;               1=error against a single record
 ;                             processing will continue for remaining tests
 ;               2=general error - nothing filed
 ;                             only 1 record will be in the return array
 ;   POINTER  = is from the list of passed in pointers in BLRTSTL
 ;   ACCESSION_OR_MESSAGE =  
 ;               a return record will exist for each UID passed in.
 ;               POINTER is from the list of passed in pointers in BLRTSTL
 ;               ACCESSION_OR_MESSAGE = Accession # if a clean return of 0
 ;               ACCESSION_OR_MESSAGE = Text string message for an error=1
 ;   TEST_UID = Test Unique ID
 ;   TEST_NAME = Text from the NAME field of LABORATORY TEST file 60
 K LRORIFN,LRNATURE,LREND,LRORDRR
 ;  BLREF  = Error flag
 K BLRAGI,BLRAGRL,BLREF,BLRAGUI,BLRIFNL,BLRJ,BLRLTMP
 K BLREF,BLREFF,BLRMESS,BLRTMP,BLRTST,BLRUIDC,BLRUIDF
 S BLRTMP=""
 S BLRMESS=""
 S BLREF=0
 S BLREFF=0
 S (BLRGUI,BLRAGUI)=1
 D ^XBKVAR S X="ERROR^BLRAG05D",@^%ZOSF("TRAP")
 S BLRAGI=0
 K ^TMP("BLRAG",$J)
 S BLRY="^TMP(""BLRAG"","_$J_")"
 S ^TMP("BLRAG",$J,0)="T00020ERROR_ID^T00020POINTERS^T00200ACCESSION_OR_MESSAGE"
 S BLRTSTL=$G(BLRTSTL)
 S BLRCDT=$G(BLRCDT)
 S BLRCUSR=$G(BLRCUSR)
 S BLRPTCM=$G(BLRPTCM)
 S BLRPTCU=$G(BLRPTCU)
 S BLRRO=$G(BLRRO)
 S BLRUNC=$G(BLRUNC)
 S BLRPAC=$G(BLRPAC)
 S BLRBT=$G(BLRBT)
 S BLRAGINS=$G(BLRAGINS)
 S LRLWC="WC"
 S XQY0=^DIC(19,$O(^DIC(19,"B","LROE",0)),0)
 I '$G(DUZ(2)) D ERR^BLRAG05D("BLRAG05: You must have a site defined. (NO DUZ(2))") Q
 S:$G(BLRRLCLA)="" BLRRLCLA=$P($$CLIENT^BLRAG02(),"|",1)
 I $G(BLRRLCLA)="" D ERR^BLRAG05D("BLRAG05: You must have a Client Account Number defined.") Q
 S (MSCRLCLA,BLRRLCLA)=$G(BLRRLCLA)
 I 0,+$G(BLRRO)'=1,$D(^LAB(69.9,1,"RO")),+$H'=+$P(^("RO"),U) D ERR^BLRAG05D("BLRAG05: ROLLOVER "_$S($P(^("RO"),U,2):"IS RUNNING.",1:"HAS NOT RUN.")_" ACCESSIONING SHOULDN'T BE DONE NOW. Continue anyway?") Q
 D BLRTSTL^BLRAG05A(.BLRTSTL) ;make sure all tests for the specimens represented in the input are processed
 D ^LRPARAM
 ; 
 S:$G(BLROPT)=""!($G(BLROPT(0))'=$P(XQY0,U)) BLROPT="ITMCOL",BLROPT(0)=$P(XQY0,U)  ;IHS/OIRM TUC/AAB 2/1/97
 D ^LRPARAM
 ;I $G(LREND) S LREND=0 Q
 ;
L5 ;
NEXT ;from LROE1
 ;convert external dates to FM format
 ;  collection date
 I BLRCDT'="" D
 .S X=BLRCDT,%DT="XT" D ^%DT S BLRCDT=Y
 .I $$FR^XLFDT($G(BLRCDT)) D ERR^BLRAG05D("BLRAG05: Invalid Collection Date.") S BLREF=1
 Q:BLREF=1
 ;S BLRCDT=$P(BLRCDT,".",1)
 ;verify patient confirmation input
 I $$PTC^BLRAGUT() D
 .I $G(BLRPTCM)="" D ERR^BLRAG05D("BLRAG05: Patient Confirmation Method is Required.") S BLREF=1 Q
 .I $G(BLRPTCU)="" D ERR^BLRAG05D("BLRAG05: Patient Confirmation User is Required.") S BLREF=1 Q
 Q:BLREF
 ;I $D(LROESTAT) D:$P(LRPARAM,U,14) ^LRCAPV I $G(LREND) K LRLONG,LRPANEL Q
 S (LRODT,X,DT)=$$DT^XLFDT(),LRODT0=$$FMTE^XLFDT(DT,5)
 S X="T-7",%DT="" D ^%DT S LRTM7=+Y
 ;
 ;process TESTs
 S BLRCNT=0
 F BLRJ=1:1:$L(BLRTSTL,U) D
 .S BLRRET=""
 .S BLREF=0
 . ;
 .I 0 D  ;'$P($G(^BLRSITE($S($G(BLRALTDZ):BLRALTDZ,1:DUZ(2)),"RL")),U,22) D  ;not using LEDI
 ..S BLRDT=$P($P($P(BLRTSTL,U,BLRJ),"|",1),":",1)
 ..S BLRSP=$P($P($P(BLRTSTL,U,BLRJ),"|",1),":",2)
 ..S BLRTST=$P($P($P(BLRTSTL,U,BLRJ),"|",1),":",3)
 ..;S BLRTSN=$$GET1^DIQ(60,$P($G(^LRO(69,BLRDT,1,BLRSP,2,BLRTST,0)),U,1)_",",.01)
 ..S BLRTSN=$$TESTNAME^BLRAGUT(+$P($G(^LRO(69,BLRDT,1,BLRSP,2,BLRTST,0)),U,1))  ;get test name
 ..S (BLRTST60,LRTS)=$P($G(^LRO(69,+$G(BLRDT),1,+$G(BLRSP),2,+$G(BLRTST),0)),U,1)  ;get test
 ..S BLRAGRL=+$G(^BLRSITE(DUZ(2),"RL"))             ;get reference lab
 ..S BLRAGRLN=$P($G(^BLRRL(BLRAGRL,0)),U,1)
 ..I '+$$CODE^BLRRLEVT(BLRAGRL,BLRTST60) S BLRRET="Test "_BLRTSN_" is not defined in the BLR REFERENCE LAB file for reference lab "_BLRAGRLN_"." S BLREF=1
 . ;
 .D:'BLREF UID($P(BLRTSTL,U,BLRJ),BLRAGINS,.BLREF,.BLRRET)
 .S:BLREF BLREFF=1
 .S BLRDT=$P($P($P(BLRTSTL,U,BLRJ),"|",1),":",1)
 .S BLRSP=$P($P($P(BLRTSTL,U,BLRJ),"|",1),":",2)
 .S BLRTST=$P($P($P(BLRTSTL,U,BLRJ),"|",1),":",3)
 .S (BLRUID,LRUID)=$P($G(^LRO(69,BLRDT,1,BLRSP,2,BLRTST,.3)),U,1)
 .S BLRTSN=$P($G(^LRO(69,BLRDT,1,BLRSP,2,BLRTST,0)),U,1)
 .;S BLRTSN=$$GET1^DIQ(60,BLRTSN_",",.01)
 .S BLRTSN=$$TESTNAME^BLRAGUT(+BLRTSN)
 .S BLRAGI=BLRAGI+1 S BLRTMP("BLRAG",$J,BLRAGI)=+BLREF_U_$P(BLRTSTL,U,BLRJ)_U_BLRRET_U_BLRUID_U_BLRTSN
 .;S BLRAGI=BLRAGI+1 S ^TMP("BLRAG",$J,BLRAGI)=+BLREF_U_$P(BLRTSTL,U,BLRJ)_U_BLRRET_U_BLRUID_U_BLRTSN
 S ^TMP("BLRAG",$J,0)=$S(+BLREFF:"T00020ERROR_ID",1:"T00020CLEAN")_"^T00020POINTERS^T00200ACCESSION_OR_MESSAGE"
 S BLRAGI="" F  S BLRAGI=$O(BLRTMP("BLRAG",$J,BLRAGI)) Q:BLRAGI=""  D
 .S ^TMP("BLRAG",$J,BLRAGI)=BLRTMP("BLRAG",$J,BLRAGI)
 K BLRTMP
 Q
 ;
UID(BLRPTR,BLRAGINS,BLREF,BLRRET) ; process single UID
 ;  BLRPTR   = pointer to the LAB ORDER ENTRY
 ;              file 69 - DATE:SPECIMEN:TEST|INSURANCE_DATA
 ;  BLRDX    = Required if Billing Type = T;
 ;             List of ICD9 ien(s) delimited by colon :
 ;              pointer to the ICD DIAGNOSIS file 80.
 ;  BLREF    = returned error flag - set to 1 if an error is encountered
 ; .BLRRET   = <accession #> OR <error message>
 D BLRRL^BLRAG05D           ; IHS/cmi/maw 9/9/2004 added check for ship manifest
 K DIC,LRSND,LRSN
 S BLRRET=""
 S BLRP69=$P(BLRPTR,"|",1)
 S BLRAGDX=$P(BLRPTR,"|",2)
 S LRODT=$P(BLRP69,":",1)
 S (BLRSN,DA)=$P(BLRP69,":",2)
 S BLRTST=$P(BLRP69,":",3)
 I '$G(^LRO(69,LRODT,1,DA,2,BLRTST,0)) S BLRRET="BLRAG05: Order pointers do not point to a valid Order Number" S BLREF=1 Q
 S LRORD=$P(^LRO(69,LRODT,1,DA,.1),U,1)
 I '+$G(LRORD) S BLRRET="BLRAG05: UID does not point to a valid Order Number" S BLREF=1 Q
 S M9=0
 D BLRRL^BLRAG05D ;cmi/anch/maw 8/4/2004 check for shipping manifest from previous order
 I '$D(^LRO(69,"C",LRORD)) S BLRRET="BLRAG05: No order exist with that order number." S BLREF=1 Q
 ;
 K BLRPTRF
 S (BLRC1,BLRC3,BLRPTRC,BLRPTRF,LRNONE,M9)=0
 S LRCHK=1
 D LROE2^BLRAG05D
 ;
 S BLRSNOD=$G(^LRO(69,LRODT,1,DA,0))
 S:BLRCDT="" BLRCDT=$P(BLRSNOD,U,1)
 S:BLRCUSR="" BLRCUSR=$P(BLRSNOD,U,3)
 I (BLRCDT="")!(BLRCUSR="") S BLRRET="BLRAG05: "_$S(BLRCDT="":"Collection date/time ",1:"")_$S((BLRCDT="")&(BLRCUSR=""):"and ",1:"")_$S(BLRCUSR="":"Collector ",1:"")_"not defined." S BLREF=1 Q
 I LRNONE=2 I 0,$G(BLRPAC)'=1 S BLRRET="BLRAG05: The order has already been"_$S(LRCHK<1:" partially",1:"")_" accessioned." S BLREF=1 Q
 I LRNONE=1 S BLRRET="BLRAG05: No order exists with that number." S BLREF=1 Q
 I '$$GOT^BLRAG05D(LRORD,LRODT) S BLRRET="BLRAG05: All tests for this order have been canceled." S BLREF=1 Q
 ;
 TSTART
 L +^LRO(69,"C",LRORD):1
 I '$T S BLRRET="BLRAG05: Someone else is editing this Order" S BLREF=1 TROLLBACK  Q
 I '$D(^LRO(69,DT,1,0)) S ^LRO(69,DT,0)=DT,^LRO(69,DT,1,0)="^69.01PA^^",^LRO(69,"B",DT,DT)=""
 K %DT
 S LRSTATUS="C",%DT("B")=""
 S LRCDT=BLRCDT
 S LRTIM=+LRCDT
 S LRUN=$P(LRCDT,U,2) K LRCDT,LRSN
MORE ; I M9>1 K DIR S DIR("A")="Do you have the entire order",DIR(0)="Y" D ^DIR K DIR S:Y=1 M9=0
 ;I M9>1 I $G(BLRMSP)'=1 S BLRRET="BLRAG05: Do you have the entire order" D UNL69ERR^BLRAG05D S BLREF=1 Q
 S (BLREF,LRSND)=0
 S YYYLRORD=LRORD
 S LRSND=DA
 S LRSN(LRSND)=LRSND,LRSN=LRSND
 S BLRODT=LRODT
 S BLRSND=LRSND
 K LRAA D Q15^BLRAG05D K LRSN
 D TASK^BLRAG05D,UNL69^BLRAG05D
 D:$G(YYYLRORD)'="" ORDNSTOR^BLRAAORU(YYYLRORD)  K YYYLRORD      ; IHS/OIT/MKK - LR*5.2*1030 - Store Ask-At-Order Questions
 S BLRTNOD=$G(^LRO(69,LRODT,1,LRSND,2,BLRTST,0))
 S BLRAA=$P(BLRTNOD,U,4)
 S BLRAD=$P(BLRTNOD,U,3)
 S BLRAN=$P(BLRTNOD,U,5)
 S:BLRAA'="" BLRRET=$P($G(^LRO(68,+$G(BLRAA),1,+$G(BLRAD),1,+$G(BLRAN),.2)),U,1)
 Q
