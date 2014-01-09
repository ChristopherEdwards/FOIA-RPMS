BLRAG03 ; IHS/MSC/SAT - LABORATORY ACCESSION GUI RPCS ;
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
 ; Return Order/Test Status RPC: BLR ORDER/TEST STATUS
LROS(BLRY,BLRDFN,BLRBDT,BLREDT) ;return order/test status for given patient and date range - RPC
 ; RPC Name is BLR ORDER/TEST STATUS
 ;INPUT:
 ;   BLRDFN  = (required) Patient code - pointer to ^DPT
 ;   BLRBDT  = (optional) Begin Date in external date form; defaults to <End Date> - <GRACE PERIOD FOR ORDERS in file 69.9>
 ;   BLREDT  = (optional) End Date in external date form; defaults to 'today'
 ;RETURNS:
 ;   (1) DFN
 ;   (2) PNAME
 ;   (3) DATE
 ;   (4) ORDER_#
 ;   (5) SPEC_#
 ;   (6) URGENCY_STATUS
 ;   (7) STATUS
 ;   (8) PROVIDER
 ;   (9) ACCESSION_#
 ;  (10) SIGN_OR_SYMPTOM
 ;  (11) TEST_NAME
 ;  (12) COLLECTION_DATE_TIME
 ;  (13) ACCESSION_#
 ;
 N BLRACCNO,BLRASN,BLRASND,BLRASNN
 N BLRCTIM,BLRDT,BLRI,BLRTMP
 N LRDFN,LREND,LRODT,LRSDT
 N LRLOOKUP S LRLOOKUP=1 ; Variable to indicate to lookup patients, prevent adding new entries in ^LRDPA
 S (BLRACCNO,BLRCTIM)=""
 S LREND=0
 D ^XBKVAR S X="ERROR^BLRAGUT",@^%ZOSF("TRAP")
 K BLRLTMP
 S BLRI=0
 K ^TMP("BLRAG",$J)
 S BLRY="^TMP(""BLRAG"","_$J_")"
 S ^TMP("BLRAG",$J,0)="T00020ERROR_ID"
 I $G(BLRDFN)="" D ERR^BLRAGUT("BLRAG03: Invalid Patient IEN") Q
 S LRDFN=$P($G(^DPT(BLRDFN,"LR")),U,1)
 I LRDFN="" D ERR^BLRAGUT("BLRAG03: No LAB DATA reference for this patient") Q
 ;
 ;if end date is null, default to today
 I $G(BLREDT)="" S BLREDT=$$HTFM^XLFDT($H,1)
 E  D
 .;convert external date to FM format
 .S X=BLREDT,%DT="XT" D ^%DT S BLREDT=$P(Y,".")
 .;default to 'today' if invalid date passed in
 .S:$$FR^XLFDT($G(BLREDT)) BLREDT=$$HTFM^XLFDT($H,1)
 ;
 ;if begin date is null or invalid, default to <end date> - <GRACE PERIOD FOR ORDERS in file 69.9>
 I $G(BLRBDT)="" S BLRBDT=$$BDTSET(BLREDT)
 E  D
 .;convert external date to FM format
 .S X=BLRBDT,%DT="XT" D ^%DT S BLRBDT=$P(Y,".")
 .;default to begin date if invalid date passed in
 .S:$$FR^XLFDT($P($G(BLRBDT),".",1))!(BLRBDT>BLREDT) BLRBDT=$$BDTSET(BLREDT)
 ;
 S (LRSDT,LRODT)=BLREDT
 S LRLDAT=BLRBDT
 ;                      0         1           2          3             4            5                    6            7              8                 9                     10              11                         12
 S ^TMP("BLRAG",$J,0)="T00020DFN^T00020PNAME^T00020DATE^T00020ORDER_#^T00020SPEC_#^T00020URGENCY_STATUS^T00020STATUS^T00020PROVIDER^T00020ACCESSION_#^T00020SIGN_OR_SYMPTOM^T00020TEST_NAME^T00020COLLECTION_DATE_TIME^T00020ACCESSION_#"
L2 S LRSN=$O(^LRO(69,LRODT,1,"AA",LRDFN,0)) I LRSN<1 S X1=LRODT,X2=-1 D C^%DTC S LRODT=X I LRODT<LRLDAT G LREND
 G LREND:LREND,L2:LRSN<1
 S Y=LRODT D DD^LRX
 S BLRDT=Y
 D ENTRY
 S X1=LRODT,X2=-1 D C^%DTC S LRODT=X
 G L2
ENTRY D HED
 S BLRF=0
 S LRSN=0 F  S LRSN=$O(^LRO(69,LRODT,1,"AA",LRDFN,LRSN)) Q:LRSN<1  K BLRTMP S BLRTI=0,BLRTMP="" D ORDER
 Q
ORDER ;call with LRSN, from LROE, LROE1, LRORD1, LROW2, LROR1
 K D,LRTT S LREND=0
 Q:'$D(^LRO(69,LRODT,1,LRSN,0))  S LROD0=^LRO(69,LRODT,1,LRSN,0),LROD1=$S($D(^(1)):^(1),1:""),LROD3=$S($D(^(3)):^(3),1:"")
 S BLRORD=$S($D(^LRO(69,LRODT,1,LRSN,.1)):^(.1),1:"")
 ;S BLRTMP="  "_"-Lab Order # "_$S($D(^LRO(69,LRODT,1,LRSN,.1)):^(.1),1:"")
 S (BLRDOC,X)=$P(LROD0,U,6) D DOC^LRX
 S BLRDOCN=$E(LRDOC,1,25)
 ;S BLRTI=BLRTI+1 S BLRTMP(BLRTI)=BLRTMP S BLRTMP=""
 S X=$P(LROD0,U,3),X=$S(X:$S($D(^LAB(62,+X,0)):$P(^(0),U),1:""),1:""),X4="" I $D(^LRO(69,LRODT,1,LRSN,4,1,0)),+^(0) S X4=+^(0),X4=$S($D(^LAB(61,X4,0)):$P(^(0),U),1:"")
 ;I $E($P(LROD1,U,6))="*" S BLRTI=BLRTI+1 S BLRTMP(BLRTI)=$P(LROD1,U,6)
 ;I $G(^LRO(69,LRODT,1,LRSN,"PCE")) S BLRTI=BLRTI+1 S BLRTMP(BLRTI)="     "_"Visit Number(s): "_$G(^("PCE"))
 ;S BLRTI=BLRTI+1 S BLRTMP(BLRTI)=" "_X_"  "_$S(X'[X4:X4,1:"") S I=0 F  S I=$O(^LRO(69,LRODT,1,LRSN,6,I)) Q:I<1  S BLRTI=BLRTI+1 S BLRTMP(BLRTI)="    "_": "_^(I,0)
 ;S LRACN=0 F  S LRACN=$O(^LRO(69,LRODT,1,LRSN,2,LRACN)) Q:LRACN'>0  I $D(^(LRACN,0))#2 S LRACN0=^(0) D TEST
 S LRACN=0 F  S LRACN=$O(^LRO(69,LRODT,1,LRSN,2,LRACN)) Q:LRACN'>0  D
 .I $D(^LRO(69,LRODT,1,LRSN,2,LRACN,0)) S LRACN0=^LRO(69,LRODT,1,LRSN,2,LRACN,0) D TEST
 Q
TEST N LRY,LRURG
 S LRROD=$P(LRACN0,U,6),(Y,LRLL,LROT,LROS,LROSD,LRURG)="",X3=0
 I $P(LRACN0,"^",11) Q
 S BLRURG=$P($G(^LAB(62.05,$P(LROD0,U,2),0)),U,1)
 S BLRASN=$P(LRACN0,U,4)   ;area
 S BLRASND=$P(LRACN0,U,3)  ;date
 S BLRASNN=$P(LRACN0,U,5)  ;internal number
 ;S BLRACCNO=$P($G(^LRO(68,+$G(BLRASN),1,+$G(BLRASND),1,+$P(LRACN0,U,5),.2)),U,1)   ;ext number
 S:(BLRASN'="")&(BLRASND'="")&(BLRASNN'="") BLRACCNO=$P($G(^LRO(68,BLRASN,1,BLRASND,1,BLRASNN,.2)),U,1)
 S BLRSOS=$P($G(^LRO(69,LRODT,1,LRSN,2,LRACN,9999999)),U,1)
 S BLRTN=$P(LRACN0,U,1)
 S BLRTN=$P($G(^LAB(60,BLRTN,0)),U,1)  ;get test name
 ;S BLRTN=$P($G(^LRO(69,LRODT,1,LRSN,2,LRACN,9999999)),U,1)
 S X=$P(LROD0,U,4),LROT=$S(X="WC":"Requested (WARD COL)",X="SP":"Requested (SEND PATIENT)",X="LC":"Requested (LAB COL)",X="I":"Requested (IMM LAB COL)",1:"undetermined")
 S X=$P(LROD1,U,4),(LROOS,LROS)=$S(X="C":"Collected",X="U":"Uncollected, cancelled",1:"On Collection List") S:X="C" LROT=""
 I '(+LRACN0) /* S BLRTI=BLRTI+1 S BLRTMP(BLRTI)="" S BLRTI=BLRTI+1 S BLRTMP(BLRTI)="BAD ORDER "_LRSN */ Q
 G NOTACC:LROD1="" ;,NOTACC:$P(LROD1,"^",4)="U"
TST1 S X1=+$P(LRACN0,U,4),X2=+$P(LRACN0,U,3),X3=+$P(LRACN0,U,5)
 G NOTACC:'$D(^LRO(68,X1,1,X2,1,X3,0)),NOTACC:'$D(^(3)) S LRACD=$S($D(^(9)):^(9),1:"")
 I '$D(LRTT(X1,X2,X3)) S LRTT(X1,X2,X3)="",I=0 F  S I=$O(^LRO(68,X1,1,X2,1,X3,4,I)) Q:I<.5  D
 .S LRACC=^LRO(68,X1,1,X2,1,X3,4,I,0),LRTSTS=+LRACC
 .D TST2
 .S BLRCTIM=$P($P(LROD1,U,1),".",1)_"."_$E($P($P(LROD1,U,1),".",2),1,4)
 .;                                0        1                        2                       3        4      5        6      7         8          9        10      11
 .S BLRI=BLRI+1 S ^TMP("BLRAG",$J,BLRI)=BLRDFN_U_$P(^DPT(BLRDFN,0),U,1)_U_$$FMTE^XLFDT(BLRDT,5)_U_BLRORD_U_LRSN_U_BLRURG_U_LROS_U_BLRDOCN_U_BLRACCNO_U_BLRSOS_U_BLRTN_U_$$FMTE^XLFDT(BLRCTIM,5)
 Q
TST2 ;
 N I
 S LRURG=+$P(LRACC,U,2) I LRURG>49 Q
 I 'LRTSTS S BLRTI=BLRTI+1 S BLRTMP(BLRTI)="" S BLRTI=BLRTI+1 S BLRTMP(BLRTI)="BAD ACCESSION TEST POINTER: "_LRTSTS Q
 S LROT="",LROS=LROOS,LRLL=$P(LRACC,U,3),Y=$P(LRACC,U,5) I Y S LROS=$S($E($P(LRACC,U,6))="*":$P(LRACC,U,6),1:"Test Complete") D DATE S LROSD=Y D WRITE,COM(1.1),COM(1) Q
 S Y=$P(LROD3,U) D DATE S LROSD=Y I LRLL S LROS="Testing In Progress"
 I $P(LROD1,"^",4)="U" S (LROS,LROOS)=""
 ;D WRITE,COM(1.1),COM(1)
 Q
WRITE ;
 S BLRTMP=" "_$S($D(^LAB(60,+LRTSTS,0)):$P(^(0),U),1:"BAD TEST POINTER")
 I $X>20 S BLRTI=BLRTI+1 S BLRTMP(BLRTI)=BLRTMP S BLRTMP=""
 S BLRTMP=BLRTMP_$$FILL^BLRAGUT(19-$L(BLRTMP))_$S($D(^LAB(62.05,+LRURG,0)):$P(^(0),U),1:"")_" "
 I $X>28 S BLRTI=BLRTI+1 S BLRTMP(BLRTI)=BLRTMP S BLRTMP=""
 S BLRTMP=BLRTMP_$$FILL^BLRAGUT(27-$L(BLRTMP))_LROT_" "_LROS
 S BLRTMP=BLRTMP_$$FILL^BLRAGUT(42-$L(BLRTMP))_" "_LROSD
 I X3 S BLRTMP=BLRTMP_$$FILL^BLRAGUT(59-$L(BLRTMP))_" "_$S($D(^LRO(68,X1,1,X2,1,X3,.2)):^(.2),1:"")
 I LRROD S BLRTI=BLRTI+1 S BLRTMP(BLRTI)=BLRTMP S BLRTMP="" S BLRTI=BLRTI+1 S BLRTMP(BLRTI)=$$FILL^BLRAGUT(45)_"  See order: "_LRROD
 ;----- BEGIN IHS MODIFICATIONS LR*5.2*1018
 ;IHS/ITSC/TPF 11/08/02 'SIGN OR SYMPTOM' LAB POV **1015**
 S BLRTI=BLRTI+1 S BLRTMP(BLRTI)="Sign or Symptom: "_$G(^LRO(69,LRODT,1,LRSN,2,LRACN,9999999))
 ;----- END IHS MODIFICATIONS
 ;
 Q
COM(LRMMODE) ;
 ;Write comments
 ;LRMMODE=comments node to display
 N LRTSTI
 S:'$G(LRMMODE) LRMMODE=1
 S LRTSTI=$O(^LRO(69,LRODT,1,LRSN,2,"B",+LRTSTS,0)) Q:'LRTSTI
 D COMWRT(LRODT,LRSN,LRTSTI,LRMMODE,3)
 Q
COMWRT(LRODT,LRSN,LRTSTI,NODE,TAB) ;
 ;Write comment node
 I $S('LRODT:1,'LRSN:1,'LRTSTI:1,'NODE:1,1:0) Q
 Q:'$D(^LRO(69,LRODT,1,LRSN,2,LRTSTI))
 S:'$G(TAB) TAB=3
 N LRI
 S LRI=0 F  S LRI=$O(^LRO(69,LRODT,1,LRSN,2,LRTSTI,NODE,LRI)) Q:LRI<1!($G(LREND))  I $D(^(LRI,0)) S BLRTI=BLRTI+1 S BLRTMP(BLRTI)=$$FILL^BLRAGUT(TAB-1)_": "_^(0)
 Q
NOTACC I $G(LROD3)="" S LROS="" G NO2
 I $P(LROD3,U,2)'="" S LROS=" ",Y=$P(LROD3,U,2) G NO2
 S Y=$P(LROD3,U) S LROS=" "
NO2 S:'Y Y=$P(LROD0,U,8) S Y=$S(Y:Y,+LROD3:+LROD3,+LROD1:+LROD1,1:LRODT) D DATE S LROSD=Y
 S LRTSTS=+LRACN0,LRURG=$P(LRACN0,U,2)
 S LROS=$S(LRROD:"Combined",1:LROS) S:LROS="" LROS="for: "_LROSD
 I LRTSTS S BLRI=BLRI+1 S ^TMP("BLRAG",$J,BLRI)=BLRDFN_U_$P(^DPT(BLRDFN,0),U,1)_U_BLRDT_U_BLRORD_U_LRSN_U_BLRURG_U_LROS_U_BLRDOCN_U_BLRASN_U_BLRSOS_U_BLRTN_U_$P(LROD1,U,1)_$C(30)
 Q
DATE S Y=$$FMTE^XLFDT(Y,"5MZ") Q
HED Q
    S BLRTMP="  Test",BLRTMP=BLRTMP_$$FILL^BLRAGUT(20-$L(BLRTMP))_"Urgency",BLRTMP=BLRTMP_$$FILL^BLRAGUT(30-$L(BLRTMP))_"Status",BLRTMP=BLRTMP_$$FILL^BLRAGUT(64-$L(BLRTMP))_"Accession"
    S BLRI=BLRI+1 S ^TMP("BLRAG",$J,BLRI)=BLRTMP
 Q
LREND ;I $E(IOST)="P" W @IOF
 ;S BLRI=BLRI+1 S ^TMP("BLRAG",$J,BLRI)=$C(31)
 S:$D(ZTQUEUED) ZTREQ="@"
 K LRLDAT,LRURG,LROSD,LRTT,LROS,LROOS,LRROD,X1,X2,X3,%,A,DFN,DIC,I,K,LRACC,LRACN,LRACN0,LRDFN,LRDOC,LRDPF,LREND,LRLL,LROD0,LROD1,LROD3,LRODT,LROT,LRSDT,LRSN,LRTSTS,X,X4,Y,Z,%Y,DIWL,DIWR,DPF,PNM Q
CANC ;For Canceled tests
 S LRTSTS=+$G(LRACN0),LROT="*Canceled by: "_$P(^VA(200,$P(LRACN0,"^",11),0),U)
 I LRTSTS D WRITE,COM(1.1),COM(1) ;second call for backward compatitility - can be removed in future years (1/98)
 Q
 ;
BDTSET(BLREDT) ;
 N BLRGPO
 S BLRGPO=$P($G(^LAB(69.9,1,0)),U,9)
 S:'+BLRGPO BLRGPO=180
 S BLRRET=$$FMADD^XLFDT(BLREDT,-BLRGPO)
 Q BLRRET
 ;
