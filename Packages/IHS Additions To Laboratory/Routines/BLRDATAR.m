BLRDATAR ; IHS/OIT/MKK - DATARAY SPECIFIC     ; [ 12/10/2010  10:30 AM ]
 ;;5.2;IHS LABORATORY;**1028**;NOV 01, 1997;Build 46
 ;
 ; Cloned from pieces of BLRIPLUP & BLRLABLZ
 ;
EN ; EP
 S:$D(ZTQUEUED) ZTREQ="@"
 N I1,J
 NEW BLRURG
 ;
 ; S X=0 X ^%ZOSF("RM")
 S:'$L($G(LRRB)) LRRB=""
 S BLRURG=""  ;IHS/DIR TUC/AAB 03/23/98
 S J=0
 S LRTXT=""
 S FLAG=0
 F I1=1:1 S J=$O(LRTS(J)) Q:J<1  I ($L(LRTXT)+$L(LRTS(J))'>24) S LRTXT=LRTXT_LRTS(J) S:$O(LRTS(J))>0 FLAG=1,LRTXT=LRTXT_";"
 ;
FLAG ; EP
 S:FLAG=0 LRDTXT=LRTXT S:FLAG=1 LRDTXT=".............."
 S LRLPNM=$P(PNM,",",1),LRLPNM=LRLPNM_$S($L(LRLPNM)<18:","_$E($P(PNM,",",2),1),1:"")
 ;
 NEW LRAPTR,LRSUB
 S LRSUB=$P($G(LRACC)," ",1)
 S LRAPTR=+$O(^LRO(68,"B",LRSUB,""))
 I LRAPTR>0&(+$P($G(^LRO(68,LRAPTR,0)),"^",15)) D BAR Q
 I LRAPTR>0&('+$P($G(^LRO(68,LRAPTR,0)),"^",15)) D PRT Q
 ;
 I $D(LRBAR) D BAR Q
 ;
 D PRT
 ;
 Q
 ;
BAR ; EP - Barcode label; Accession # Barcoded
 NEW PROVSTR,FORMFEED,ZFLRAN
 ;
 S PROVSTR=$$PROVN($G(LRAA),$G(LRAD),$G(LRAN))          ; Provider Function
 S ZFLRAN=$E("0000",$L(LRAN),4)_$G(LRAN)                ; Zero-Fill Accession #
 ;
 W "Test(s):",$$TESTSVAR($G(LRTXT)),!              ; Test(s)              (01)
 W "Prov:",$G(PROVSTR),!                           ; Provider             (02)
 W "Top:",$G(LRTOP),!                              ; Top/Specimen         (03)
 W "Accession:",$G(LRACC),!                        ; ACCESSION String     (04)
 W "UID:",$G(LRUID),!                              ; UID                  (05)
 W "Date/Time:",$$LRDSHRT($G(LRDAT)),!             ; Date/Time            (06)
 W "Ord#:",$G(LRCE),!                              ; Order Number         (07)
 W "Location:",$$LOCVAR($G(LRLLOC),$G(LRRB)),!     ; Location             (08)
 W "HRCN:",$G(HRCN),!                              ; Health Record Number (09)
 W $$DOBSTR($G(DOB)),!                             ; Date of Birth        (10)
 W "Urgency:",$$BLRURG($G(LRURG0)),!               ; Urgency              (11)
 W "Pt Name:",$E($G(PNM),1,27),!                   ; Patient Name         (12)
 W "Sex:",$G(SEX),!                                ; Sex                  (13)
 ;
 W !
 ;
 Q
 ;
PRT ; EP - plain label..no barcode
 ;
 NEW PROVSTR,FORMFEED
 S PROVSTR=$$PROVN($G(LRAA),$G(LRAD),$G(LRAN))          ; Provider Function
 ;
 W "Test(s):",$$TESTSVAR($G(LRTXT)),!              ; Test(s)              (01)
 W "Prov:",$G(PROVSTR),!                           ; Provider             (02)
 W "Top:",$G(LRTOP),!                              ; Top/Specimen         (03)
 W "Accession:",$G(LRACC),!                        ; ACCESSION String     (04)
 W "UID:",$G(LRUID),!                              ; UID                  (05)
 W "Date/Time:",$$LRDSHRT($G(LRDAT)),!             ; Date/Time            (06)
 W "Ord#:",$G(LRCE),!                              ; Order Number         (07)
 W "Location:",$$LOCVAR($G(LRLLOC),$G(LRRB)),!     ; Location             (08)
 W "HRCN:",$G(HRCN),!                              ; Health Record Number (09)
 W $$DOBSTR($G(DOB)),!                             ; Date of Birth        (10)
 W "Urgency:",$$BLRURG($G(LRURG0)),!               ; Urgency              (11)
 W "Pt Name:",$E($G(PNM),1,27),!                   ; Patient Name         (12)
 W "Sex:",$G(SEX),!                                ; Sex                  (13)
 ;
 Q
 ;
TESTSVAR(LRTXT) ; EP -- Test(s) variable
 NEW TESTSVAR
 S TESTSVAR=$E($G(LRTXT),1,32)
 I $L($G(LRTXT))>32 S TESTSVAR=$E($G(LRTXT),1,29)_"..."
 Q TESTSVAR
 ;
BLRURG(LRURG0)      ; EP -- Urgency variable
 NEW BLRURG
 S BLRURG="N/A"    ; Make sure BLRURG has something in it
 I $G(LRURG0)'="" S BLRURG=$E($P(^LAB(62.05,LRURG0,0),U,1),1,4)  ;IHS/DIR TUC/AAB 03/23/98
 Q BLRURG
 ;
DOBSTR(DOB) ; EP -- Make certain DOB has something in it
 I DOB="XX/XX/XXXX" Q "DoB:"_DOB    ; If TEST DoB
 ;
 NEW FMDOB
 ; Data in VADM array initialized by LRU routine
 S FMDOB=+$G(VADM(3))
 I FMDOB<1 Q "DoB:"_DOB
 ;
 Q "DoB:"_$$FMTE^XLFDT(FMDOB,"5DZ")       ; Return MM/DD/CCYY as DOB
 ;
LRDSHRT(LRDAT)      ; EP -- Make certain date string has a 2-digit year
 I LRDAT="XX/XX/XX" Q LRDAT_" XX:XX"             ; Test Date string
 ;
 NEW LRDSHRT
 S LRDSHRT=$G(LRDAT)
 I $L($P($P(LRDAT,"/",3)," ",1))>2 D
 . S LRDSHRT=$P(LRDAT,"/",1,2)_"/"_$E($P(LRDAT,"/",3),3,$L(LRDAT))
 Q LRDSHRT
 ;
PROVN(LRAA,LRAD,LRAN)      ; EP -- Make certain provider name has data
 I +$G(LRAA)=0!(+$G(LRAD)=0) Q "TEST,PROVIDER"
 ;
 NEW PROVN                             ; Provider Name
 NEW PTR                               ; Provider Pointer
 ;
 S PROVN=""
 I $G(LRAA)'=""&($G(LRAD)'="")&($G(LRAN)'="")  D
 . S PTR=$P($G(^LRO(68,LRAA,1,LRAD,1,LRAN,0)),"^",8)
 . I $G(PTR)'="" S PROVN=$P($G(^VA(200,PTR,0)),"^",1)
 Q $E(PROVN,1,18)
 ;
LOCVAR(LRLLOC,LRRB)      ; EP -- Location variable
 NEW LOCVAR
 S LOCVAR="L:"_$E($G(LRLLOC),1,7)
 I $L(LRRB)>0 S LOCVAR=LOCVAR_" B:"_LRRB
 Q LOCVAR
