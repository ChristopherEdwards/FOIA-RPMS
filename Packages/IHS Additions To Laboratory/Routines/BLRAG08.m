BLRAG08 ; IHS/MSC/SAT - LABORATORY ACCESSION GUI RPCS ;NOV 12, 2012
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
 ;Cancel tests - Tests are no longer deleted, instead the status is changed to Not Performed.
DELTST(BLRY,BLRP,BLRRES) ;
 ;  rpc: BLR DELETE TEST
 ;INPUT:
 ;  BLRP    = (required) list of TEST POINTERS to LAB ORDER ENTRY file 69
 ;               BLRDT:BLRSP:BLRTEST^...
 ;               These pointers come from the return from
 ;                 BLR ALL-ACCESSIONED.
 ;  BLRRES  = (required) list of reasons delimited by ^
 ;                         reason_IEN:comment^...
 ;               reason_IEN = pointer to ORDER REASON file 100.03
 ;               comment is free-text
 ;     The 1st entry in the REASONS list will align with the 1st entry in
 ;      the TEST POINTERS, and so on.  So, the REASONS input string is
 ;      expected to be the same length as the TEST POINTERS input string.
 ;
 ;RETURNS:
 ;    General error returns a single entry:
 ;     ERROR_ID^MESSAGE
 ;        2=general error
 ;    Accession related errors return an entry for each lab pointer
 ;    that is passed in:
 ;     ERROR_ID^MESSAGE
 ;        0=clean   0^MESSAGE^BLRD:BLRSP:BLRTEST
 ;        1=error   1^MESSAGE^BLRD:BLRSP:BLRTEST
 ;
 S BLRGUI=1
 S LREND=0
 D ^XBKVAR S X="ERROR^BLRAGUT",@^%ZOSF("TRAP")
 S BLRI=0
 K ^TMP("BLRAG",$J)
 S BLRY="^TMP(""BLRAG"","_$J_")"
 S ^TMP("BLRAG",$J,0)="ERROR_ID"
 ;
 N BLRJ
 N BLRDT,BLREF,BLREFF,BLRSP,BLRTEST
 N LRAA,LRAD,LRAN,LRCTST
 I $G(BLRP)="" S BLRI=BLRI+1 S ^TMP("BLRAG",$J,BLRI)="2^BLRAG08: Null order pointer." Q
 S BLROPT="DELACC"
 D ^LRPARAM Q:$G(LREND)
 I '$D(LRLABKY) S BLRI=BLRI+1 S ^TMP("BLRAG",$J,BLRI)="2^BLRAG08: You are not authorized to change test status." Q
 S BLREF=0
 F BLRJ=1:1:$L(BLRP,"^") D
 .K LRXX,LRSCNXB
 .S BLRDT=$P($P(BLRP,"^",BLRJ),":",1)
 .S BLRSP=$P($P(BLRP,"^",BLRJ),":",2)
 .S BLRTEST=$P($P(BLRP,"^",BLRJ),":",3)
 .I '$D(^LRO(69,BLRDT,1,BLRSP,2,BLRTEST)) S BLRI=BLRI+1 S ^TMP("BLRAG",$J,BLRI)="1^Invalid order pointer.^"_$P(BLRP,"^",BLRJ) S BLREF=1 Q
 .S BLRNODT=^LRO(69,BLRDT,1,BLRSP,2,BLRTEST,0)
 .S LRAA=$P(BLRNODT,U,4)
 .S LRAD=$P(BLRNODT,U,3)
 .S LRAN=$P(BLRNODT,U,5)
 .I $P(BLRRES,U,BLRJ)="" S BLRI=BLRI+1 S ^TMP("BLRAG",$J,BLRI)="1^Reason is required. "_$P($G(^LRO(68,LRAA,1,LRAD,1,LRAN,.2)),U,1) S BLREF=1 Q
 .S LRCTST=$P(BLRNODT,U,1) ;points to test in file 68
 .I '$D(^LRO(68,+LRAA,1,+LRAD,1,+LRAN,4,+LRCTST)) S BLRI=BLRI+1 S ^TMP("BLRAG",$J,BLRI)="1^Invalid accession/test pointer."_$P(BLRP,"^",BLRJ) S BLREF=1 Q
 .I $$VER() S BLRI=BLRI+1 S ^TMP("BLRAG",$J,BLRI)="1^BLRAG08: Test has been verified and cannot be deleted. "_$P($G(^LRO(68,LRAA,1,LRAD,1,LRAN,.2)),U,1) S BLREF=1 Q
 .S (LREND,LRNOP)=0 D FIX I LREND=1 D UNLOCK D END Q
 .D CHG D UNLOCK D END
 .S BLRI=BLRI+1 S ^TMP("BLRAG",$J,BLRI)=0_U_$P(BLRP,"^",BLRJ)
 ;I '$D(BLRDT)!'$D(BLRSP)!'$D(BLRTEST) D ERR^BLRAGUT("1^BLRAG08: Invalid order pointer^"_$P(BLRP,"^",BLRJ)) Q
 S:'BLREF ^TMP("BLRAG",$J,0)="T00020CLEAN^T00020MESSAGE^LRO69_POINTERS"
 ;S ^TMP("BLRAG",$J,0)="T00020CLEAN^T00020MESSAGE^LRO69_POINTERS"
 Q
 ;
FIX ;get locks and setup variables
 S (LREND,LRNOP)=0,LRNOW=$$NOW^XLFDT
 K LRACC,LRNATURE
 I '$P($G(^LRO(68,+$G(LRAA),1,+$G(LRAD),1,+$G(LRAN),0)),U,2) S BLRI=BLRI+1 S ^TMP("BLRAG",$J,BLRI)="1^BLRAG08: Accession has no Test. "_$P($G(^LRO(68,LRAA,1,LRAD,1,LRAN,.2)),U,1) S (BLREF,LREND)=1 Q
 L +^LRO(68,LRAA,1,LRAD,1,LRAN):1 I '$T S BLRI=BLRI+1 S ^TMP("BLRAG",$J,BLRI)="1^BLRAG08: Someone else is working on this accession. "_$P($G(^LRO(68,LRAA,1,LRAD,1,LRAN,.2)),U,1) S BLREF=1 S LREND=1 Q
 S LRX=^LRO(68,LRAA,1,LRAD,1,LRAN,0),LRACN=$P(^(.2),U),LRUID=$P(^(.3),U)
 S LRDFN=+LRX,LRSN=+$P(LRX,U,5),LRODT=+$P(LRX,U,4)
 S LRDPF=$P(^LR(LRDFN,0),U,2),DFN=$P(^(0),U,3)
 D PT^LRX
 S LRSS=$P($G(^LRO(68,LRAA,0)),U,2)
 S LRIDT=$P($G(^LRO(68,LRAA,1,LRAD,1,LRAN,3)),U,5)
 L +^LR(LRDFN,LRSS,LRIDT):1 I '$T S BLRI=BLRI+1 S ^TMP("BLRAG",$J,BLRI)="1^BLRAG08:Someone else is working on this data. "_$P($G(^LRO(68,LRAA,1,LRAD,1,LRAN,.2)),U,1) L -^LRO(68,LRAA,1,LRAD,1,LRAN):1 S BLREF=1 S LREND=1 Q
 I '$G(^LR(LRDFN,LRSS,LRIDT,0)) S BLRI=BLRI+1 S ^TMP("BLRAG",$J,BLRI)="1^BLRAG08: Can't find Lab Data for this accession "_$P($G(^LRO(68,LRAA,1,LRAD,1,LRAN,.2)),U,1) D UNLOCK S BLREF=1 S LREND=1 Q
 Q
CHG ;
 K DIC
 K LRCCOM S LRCCOM="",LREND=0 I '$D(^LRO(69,BLRDT,1,BLRSP,0))#2 S BLRI=BLRI+1 S ^TMP("BLRAG",$J,BLRI)="1^BLRAG08: There is no Order for this Accession^"_$P(BLRP,"^",BLRJ) D UNLOCK,END S BLREF=1 S LREND=1 Q
 S LRCCOM=$E($S('$D(LRLABKY):"*Floor Cancel Reason:",1:"*NP Reason:")_$P($P($G(BLRRES),U,BLRJ),":",2),1,68)
 Q:'$D(^LAB(60,LRCTST,0))#2  S LRTNM=$P(^(0),U)
 S LRORDTST=$P(^LRO(68,LRAA,1,LRAD,1,LRAN,4,LRCTST,0),U,9) D SET
 S LREND=0
 Q
SET ;
 S:'$G(LRNOW) LRNOW=$$NOW^XLFDT
 S LRLLOC=$P(^LRO(69,BLRDT,1,BLRSP,0),U,7) D
 . N II,X,LRI,LRSTATUS,OCXTRACE
 . S:$G(LRDBUG) OCXTRACE=1
 . I $D(^LRO(69,BLRDT,1,BLRSP,2,BLRTEST,0))#2,LRCTST=+^LRO(69,BLRDT,1,BLRSP,2,BLRTEST,0) S (LRSTATUS,II(LRCTST))="" D  K II
 . . Q:$P(^LRO(69,BLRDT,1,BLRSP,2,BLRTEST,0),U,11)  S ORIFN=$P(^(0),U,7)
 . . S X=1+$O(^LRO(69,BLRDT,1,BLRSP,2,BLRTEST,1.1,"A"),-1),X(1)=$P($G(^(0)),U,4)
 . . S ^LRO(69,BLRDT,1,BLRSP,2,BLRTEST,1.1,X,0)=$P($G(^ORD(100.03,$P($P($G(BLRRES),U,BLRJ),":",1),0)),U,1)_": "_LRCCOM,X=X+1,X(1)=X(1)+1
 . . S ^LRO(69,BLRDT,1,BLRSP,2,BLRTEST,1.1,X,0)=$S($G(LRMERG):"*Merged:",'$D(LRLABKY):"*Cancel by Floor:",1:"*NP Action:")_$$FMTE^XLFDT(LRNOW,"5MZ")
 . . S ^LRO(69,BLRDT,1,BLRSP,2,BLRTEST,1.1,0)="^^"_X_"^"_X(1)_"^"_DT
 . . I $G(ORIFN),$D(II) D NEW^LR7OB1(BLRDT,BLRSP,$S($G(LRMSTATI)=""!($G(LRMSTATI)=1):"OC",1:"SC"),$G(LRNATURE),.II,LRSTATUS)
 . . I ORIFN,$$VER^LR7OU1<3 D DC^LRCENDE1
 . . S $P(^LRO(69,BLRDT,1,BLRSP,2,BLRTEST,0),"^",9)="CA",$P(^(0),U,10)="L",$P(^(0),U,11)=DUZ
 . . S:$D(^LRO(69,BLRDT,1,BLRSP,"PCE")) ^LRO(69,"AE",DUZ,BLRDT,BLRSP,BLRTEST)=""
 K ORIFN,ORSTS
 I $D(^LRO(68,+$G(LRAA),1,+$G(LRAD),1,+$G(LRAN),0))#2,$D(^(4,$G(LRCTST),0))#2 S $P(^(0),U,4,6)=DUZ_U_LRNOW_U_$S($G(LRMERG):"*Merged",1:"*Not Performed") D
 . S LROWDT=$P($G(^LRO(68,LRAA,1,LRAD,1,LRAN,0)),U,3) I LROWDT,LROWDT'=LRAD D ROL Q
 . S LROWDT=+$G(^LRO(68,LRAA,1,LRAD,1,LRAN,9)) I LROWDT D ROL
 I $G(LRIDT),$L($G(LRSS)),$L(LRCCOM),$G(^LR(LRDFN,LRSS,LRIDT,0)) D
 . D 63(LRDFN,LRSS,LRIDT,LRTNM,LRCCOM)
 . D:'$D(^LRO(68,LRAA,1,LRAD,1,"AD",DT,LRAN)) XREF^LRVER3A
 D EN^LA7ADL($P($G(^LRO(68,+$G(LRAA),1,+$G(LRAD),1,+$G(LRAN),.3)),"^")) ; Put in list to check for auto download.
 Q
ROL ;
 Q:+$G(^LRO(68,LRAA,1,LROWDT,1,LRAN,0))'=LRDFN  Q:'$D(^(4,LRCTST,0))#2
 S $P(^LRO(68,LRAA,1,LROWDT,1,LRAN,4,LRCTST,0),U,4,6)=DUZ_U_LRNOW_U_"*Not performed"
 Q
UNLOCK ;
 L -(^LR($G(LRDFN),$G(LRSS),$G(LRIDT)),^LRO(68,$G(LRAA),1,$G(LRAD),1,$G(LRAN))) D END Q
END ;
 K LRCCOM0,LRCCOM1,LRCCOMX,LREND,LRI,LRL,LRNATURE,LRNOP,LRSCN,LRMSTATI,LRORDTST,LROWDT,LRPRAC,LRCTST,LRUID
 K Q9,LRXX,DIR,LRCOM,LRAGE,DI,LRCTST,LRACN,LRACN0,LRDOC,LRLL,LRNOW
 K LROD0,LROD1,LROD3,LROOS,LROS,LROSD,LROT,LRROD,LRTT,X4
 ;BEGIN IHS MODIFICATIONS LR*5.2*1018
 D KVA^BLRDPT,END^LRTSTJAM  ;IHS/ITSC/TPF 04/17/03
 K HRCN
 ;END IHS MODIFICATIONS
 Q
 ;
63(LRDFN,LRSS,LRIDT,LRTNM,LRCCOM) ;
 N X,Y,D0,D1,DA,DR,DIC,DIE,LRCCOM0,LRNOECHO,DLAYGO
 S DLAYGO=63,DIC(0)="SL"
 S:'$G(LRNOW) LRNOW=$$NOW^XLFDT
 S LRNOECHO=1
 S LRCCOM0=$E("*"_LRTNM_$S($G(LRMERG):" Merged: ",'$D(LRLABKY):" Floor Canceled: ",1:" Not Performed: ")_$$FMTE^XLFDT(LRNOW,"5FMPZ")_" by "_DUZ,1,68)
 S DA=LRIDT,DA(1)=LRDFN,DIE="^LR("_LRDFN_","""_LRSS_""","
 S LRCCOM0=$TR(LRCCOM0,";","-") ; Strip ";" - FileMan uses ";" to parse DR string.
 S DR=".99///^S X="_""""_LRCCOM0_"""" D ^DIE
 Q:LRSS="MI"
631 K D0,D1,DA,DR,DIC,DIE
 S DIC(0)="SL"
 S DA=LRIDT,DA(1)=LRDFN,DIE="^LR("_LRDFN_","""_LRSS_""",",DIC=DIE
 S LRCCOM=$TR(LRCCOM,";","-") ; Strip ";" - FileMan uses ";" to parse DR string.
 S DR=".99///^S X="_""""_LRCCOM_""""
 D ^DIE
 Q
 ;
VER() ;check to see if a test has been verified
 ;0 = no; 1=yes
 N LRDFN,LRIDT,LRRET,LRSS
 S LRDFN=+$G(^LRO(68,LRAA,1,LRAD,1,LRAN,0))
 S LRSS=$P($G(^LRO(68,LRAA,0)),U,2)
 S LRIDT=$P($G(^LRO(68,LRAA,1,LRAD,1,LRAN,3)),U,5)
 S LRRET=$S($P($G(^LR(LRDFN,LRSS,LRIDT,0)),U,4)'="":1,1:0)
 Q LRRET
 ;
TEST ;
 S U="^"
 S DT=$P($$NOW^XLFDT(),".",1)
 S DTIME=9000
 S IOSTBM="$C(27,91)_(+IOTM)_$C(59)_(+IOBM)_$C(114)"
 D DUZ^XUP(2)
 D ^%ZIS
 S BLRY=""
 TSTART
 D DELTST(.BLRY,"3121101:5:1^3121113:1:1","")
 TROLLBACK
 Q
