BLRALAF ;DAOU/ALA-Set Lab Results Flag 
 ;;5.2T9;LR;**1018**;Nov 17, 2004
 ;;5.2;LR;**1013,1015**;Nov 18, 2002
 ;
 ;**Program Description**
 ;  This program will check for the results flag and
 ;  set up all pertinent information in the results file #63
 ;
 ;**PARAMETERS**
 ;  BLRARFL  = Review Flag
 ;  BLRARPHY = Responsible Physician
 ;  BLRACT   = Count of Abnormal Results
 ;  BLRPCT  = Count of Pending Results
 ;  BLRCCT  = Count of Critical Results
 ;  BLRRCT  = Count of Results with no references
 ;
CHK ; Check to see if Accession has results before setting in BLRA queue
 ;----- BEGIN IHS MODIFICATIONS LR*5.2*1018
 ; THIS SET MOVED TO CHKNXT+3
 ;S BLRACHK=0
 ;----- END IHS MODIFICATIONS
CHKNXT I $G(LRSS)="",$G(LRAA)'="" S LRSS=$P($G(^LRO(68,LRAA,0)),U,2)  ;IHS/ITSC/TPF 03/18/03 FIX LRSS UNDEFINED ERROR REPORTED AT BLACKFEET COMMUNITY **1016**
 ;
 ;----- BEGIN IHS MODIFICATIONS LR*5.2*1018
 S BLRACHK=$S(LRSS="CH":1,1:0)  ;BYPASS COMMENTS FOR CH; NOT PERFORMED TESTS WILL HAVE COMMENTS ;START AT 0 FOR MICROS
 ;----- END IHS MODIFICATIONS
 ;
 ;----- BEGIN IHS MODIFICATIONS LR*5.2*1018
 ;THIS IGNORES ENTRY BY OPTION:
 ;    Itemized routine lab collection" and "Receipt of routine lab collection from wards" as these are not processed at this time. They will be when resulted
 I $G(LRIDT)="",((U_"LRPHEXCPT"_U_"LRPHITEM"_U)[$P(XQY0,U)) Q
 ;----- END IHS MODIFICATIONS
 ;
 S BLRACHK=$O(^LR(LRDFN,LRSS,LRIDT,BLRACHK))  ; FIX #40
 ;I '(BLRACHK>0&(BLRACHK<9009027)) Q
 I BLRACHK=9009027 G CHKNXT
 I BLRACHK<1 Q
 KILL BLRACHK
 ;
PHY ;  Physician setup
 ;  Get the ordering physician
 S BLRAPRAC=$P($G(^LR(LRDFN,LRSS,LRIDT,0)),U,$S(LRSS="MI":7,1:10))
 ; If no requesting person not found then this is a referral patient 
 ; requesting person is not prompted for. 
 Q:'$G(BLRAPRAC)
 ;  If not a participating physician, quit
 I '$D(^BLRALAB(9009027.1,BLRAPRAC)) K BLRAPRAC Q
 ; If physician is INACTIVE, quit -ejn 3/22/02
 I $P($G(^BLRALAB(9009027.1,BLRAPRAC,0)),U,7)="I" Q
 ;  Check what's there
 S BLRADATA=$G(^LR(LRDFN,LRSS,LRIDT,9009027))
 S BLRARFL=+$P(BLRADATA,U,1),BLRARPHY=$P(BLRADATA,U,2)
 ; 
 ;I LRSS="CH"&(BLRARFL)&('$D(LRSA)) K BLRARFL,BLRAPRAC,BLRADATA,BLRARPHY Q
 ;
 ;  If the Clin Chem accession was already reviewed or completed and
 ;  then amended, the status will be set back for completion
 ;  again.  The record of the previous reviewed or completion
 ;  are to be added to the amended values.
 I LRSS="CH"&(BLRARFL)&($D(LRSA)) D RSET
 ;
 I BLRARPHY="" S BLRARPHY=BLRAPRAC
 ;
 ;  Count the number of abnormal and pending results
 S BLRACT=0,BLRPCT=0,BLRCCT=0,BLRRCT=0
 I LRSS="CH" S BLRAJ=1 D
 . D ACC
 . ;F  S BLRAJ=$O(^LR(LRDFN,LRSS,LRIDT,BLRAJ)) Q:'BLRAJ!(BLRAJ=9009027)  D  ; FIX #40
 . F  S BLRAJ=$O(^LR(LRDFN,LRSS,LRIDT,BLRAJ)) Q:'BLRAJ  D
 .. Q:BLRAJ=9009027
 .. I $P($G(^LR(LRDFN,LRSS,LRIDT,BLRAJ)),U,2)["*" S BLRCCT=BLRCCT+1 Q
 .. I $P($G(^LR(LRDFN,LRSS,LRIDT,BLRAJ)),U,2)'="" S BLRACT=BLRACT+1
 .. ;I $P($G(^LR(LRDFN,LRSS,LRIDT,BLRAJ)),U,1)="pending" S BLRPCT=BLRPCT+1  ; FIX #41 for dup pendings
 ;
 ;  If microbiology check for preliminary and set the pending flag
 ;  if set to final, set pending flag to complete
 ;
 ;----- BEGIN IHS MODIFICATIONS LR*5.2*1018
 I LRSS="MI" Q:'$D(^LR(LRDFN,LRSS,LRIDT,1))
 ;----- END IHS MODIFICATIONS THIS TAKES CARE OF "EMPTY" MICROS THAT ARE DELETED. IF THE DOCTORS WISH TO SEE MICROS WHICH WERE ORDERS BUT THEN "NOT PERFORMED" COMMENT THIS LINE OUT
 I LRSS="MI" D
 . S BLRAJ=0
 . F  S BLRAJ=$O(^LR(LRDFN,LRSS,LRIDT,3,BLRAJ)) Q:'BLRAJ  D
 .. I $P($G(^LR(LRDFN,LRSS,LRIDT,3,BLRAJ,0)),U,1)'="" S BLRACT=BLRACT+1
 . I $P($G(^LR(LRDFN,LRSS,LRIDT,1)),U,2)="P" S BLRPCT=1
 . I $P($G(^LR(LRDFN,LRSS,LRIDT,1)),U,2)="F" S BLRPCT=0
 . D ACC
 ;
 S $P(^LR(LRDFN,LRSS,LRIDT,9009027),U,1)=BLRARFL
 S $P(^LR(LRDFN,LRSS,LRIDT,9009027),U,2)=BLRARPHY
 S $P(^LR(LRDFN,LRSS,LRIDT,9009027),U,6)=BLRACT
 S $P(^LR(LRDFN,LRSS,LRIDT,9009027),U,7)=BLRPCT
 S $P(^LR(LRDFN,LRSS,LRIDT,9009027),U,8)=BLRCCT
 S $P(^LR(LRDFN,LRSS,LRIDT,9009027),U,9)=BLRRCT
 ;
 ;  Set the cross-reference
 D SX^BLRALUT1
 ;
 K BLRACT,BLRPCT,BLRCCT,BLRARFL,BLRARPHY,BLRAJ,BLRNM,BLRADATA,BLRAPRAC
 K BLRPFL,BLRPRDT,BLRPSDT,BLRPSPH,BLRATXT,BLRRCT
 K BREF,RFL,BLRLOW,BLRCLOW,BLRCHI,BLRHI,TST,TST1,SUBTEST,NUM
 Q
 ;
ACC ;  Check the Accession File
 I LRSS'="MI" D
 . S LRORU=$G(^LR(LRDFN,LRSS,LRIDT,"ORU")) Q:LRORU=""
 . I $D(^LRO(68,"C",LRORU)) D
 .. S LRAA=$O(^LRO(68,"C",LRORU,"")) Q:'LRAA
 .. S LRAD=$O(^LRO(68,"C",LRORU,LRAA,"")) Q:'LRAD
 .. S LRAN=$O(^LRO(68,"C",LRORU,LRAA,LRAD,"")) Q:'LRAN
 ;
 NEW TST
 S TST=0
 F NUMTST=0:1 S TST=$O(^LRO(68,LRAA,1,LRAD,1,LRAN,4,TST)) Q:'TST  D
 .;----- BEGIN IHS MODIFICATIONS LR*5.2*1018
 .I $P($G(^LRO(68,LRAA,1,LRAD,1,LRAN,4,TST,0)),U,6)[("*Not Performed") X:LRSS="MI" $S(BLRPCT=0:"S BLRPCT=0",1:"S BLRPCT=BLRPCT-1") Q
 .;----- END IHS MODIFICATIONS
 . I $P($G(^LRO(68,LRAA,1,LRAD,1,LRAN,4,TST,0)),U,5)="" D
 .. ;FORMAT OF SET BELOW ^LAB(60,1,0)=WBC^^B^CH^CH;384;1^^0^1^3^^^DD(63.04,384,^^^^1^1^9^^0
 .. ;I.E. GET DATANAME
 .. S LRDN=$P($P($G(^LAB(60,TST,0)),U,5),";",2)
 .. ; Do not combine the 4 if statements below into fewer statements. ;DAOU/DJW 1/23/02
 .. ;----- BEGIN IHS MODIFICATIONS
 .. I $P($G(^LRO(68,LRAA,1,LRAD,1,LRAN,4,TST,0)),U,6)[("*Not Performed") Q
 .. ;----- END IHS MODIFCATIONS
 .. I '$D(LRDN) D PEND Q
 .. I $G(LRDN)="" D PEND Q
 .. I '$D(^LR(LRDFN,LRSS,LRIDT,LRDN)) D PEND Q
 .. I $P($G(^LR(LRDFN,LRSS,LRIDT,LRDN)),U,1)["pending" D PEND Q
 . ; FIX #45 EJN
 . ; Check for lab test references
 . ;LAB(60,D0,2,0)=^60.02P^^  (#200) LAB TEST INCLUDED IN PANEL
 . I $P($G(^LAB(60,TST,1,0)),U,4)'>0 S BLRRCT=BLRRCT+1
 . S TST1=TST D CHKREF
 . ; Check to see if it is a panel, reset BLRRCT for panels
 . I $P($G(^LAB(60,TST,2,0)),U,4)>0 D
 .. S BLRRCT=0
 .. S NUM=0,SUBTST=""
 .. F  S NUM=$O(^LAB(60,TST,2,NUM)) Q:'NUM  D
 ... S SUBTST=$P($G(^LAB(60,TST,2,NUM,0)),U,1)
 ... S TST1=SUBTST D CHKREF
 Q
CHKREF ;
 S BREF=0,RFL=0
 I $G(TST1)="" Q
 F  S BREF=$O(^LAB(60,TST1,1,BREF)) Q:'BREF  D
 . S BLRLOW=$P($G(^LAB(60,TST1,1,BREF,0)),U,2),BLRLOW=$$STRIP^XLFSTR(BLRLOW,"""")
 . S BLRHI=$P($G(^LAB(60,TST1,1,BREF,0)),U,3),BLRHI=$$STRIP^XLFSTR(BLRHI,"""")
 . S BLRCLOW=$P($G(^LAB(60,TST1,1,BREF,0)),U,4),BLRCLOW=$$STRIP^XLFSTR(BLRCLOW,"""")
 . S BLRCHI=$P($G(^LAB(60,TST1,1,BREF,0)),U,5),BLRCHI=$$STRIP^XLFSTR(BLRCHI,"""")
 . I BLRLOW=""&(BLRHI="")&(BLRCLOW="")&(BLRCHI="") S RFL=1
 . I ((BLRLOW?.A)&(BLRLOW'["$S")&(BLRLOW'=""))!((BLRHI?.A)&(BLRHI'["$S")&(BLRHI'="")) S RFL=1
 . I ((BLRCLOW?.A)&(BLRCLOW'["$S")&(BLRCLOW'=""))!((BLRCHI?.A)&(BLRCHI'["$S")&(BLRCHI'="")) S RFL=1
 . I BLRLOW["<"!(BLRLOW[">")!(BLRHI["<")!(BLRHI[">")!(BLRCLOW["<")!(BLRCLOW[">")!(BLRCHI["<")!(BLRCHI[">") S RFL=1
 I RFL>0 S BLRRCT=BLRRCT+1
 Q
PEND ; Add 1 to the pending count
 S BLRPCT=$G(BLRPCT)+1
 I BLRARFL=2 D RSET
 Q
RSET ;  Reset if signed
 S BLRPFL=BLRARFL,BLRPRDT=$P(BLRADATA,U,4)
 D KX^BLRALUT1
 S BLRPSDT=$P(BLRADATA,U,5),BLRPSPH=$P(BLRADATA,U,3)
 S BLRARFL=0,$P(BLRADATA,U,5)="",$P(BLRADATA,U,3)=""
 ;I BLRPFL=2 D
 ;. S BLRATXT="Changed lab results previously signed by "_$P(^VA(200,BLRPSPH,0),U,1)_" on "_$$FMTE^XLFDT(BLRPSDT)
 ;. S BLRNM=$P($G(^LR(LRDFN,LRSS,LRIDT,1,0)),U,3),BLRNM=BLRNM+1
 ;. S $P(^LR(LRDFN,LRSS,LRIDT,1,0),U,3,4)=BLRNM_U_BLRNM
 ;. S ^LR(LRDFN,LRSS,LRIDT,1,BLRNM,0)=BLRATXT
 ;. S ^LR(LRDFN,LRSS,LRIDT,1,"B",$E(BLRATXT,1,30),BLRNM)=""
 Q
