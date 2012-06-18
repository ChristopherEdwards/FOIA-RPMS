BLRP41UP ; IHS/OIT/MKK - INTERMEC PC41 UID Barcoded Print ;DEC 09, 2008 8:30 AM
 ;;5.2;IHS LABORATORY;**1025**;NOV 01, 1997
 ;
 ; Prints Labels with UID barcoded, NOT, repeat
 ; NOT, the Accession's Number barcoded
 ; 
 ; Cloned from BLRLABLC
 ;
EN ; EP
 S:$D(ZTQUEUED) ZTREQ="@"
 N I1,J
 NEW BLRURG
 ;
 S X=0 X ^%ZOSF("RM")
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
 I $D(LRBAR) D BAR Q  ;IHS/MJL 3/18/99
 ;
 D PRT
 K BLRURG
 ;
 Q
 ;
BAR ; EP - Barcode label; UID Barcoded
 ;
 NEW PROVSTR,FORMFEED
 S PROVSTR=$$PROVN($G(LRAA),$G(LRAD),$G(LRAN))   ; Provider Function
 ;
 W *2,"R",*3                                     ; Exit Program Mode
 ;
 W *2,!,*27,"E3",*24,!,$$TESTSVAR($G(LRTXT)),*3  ; Test(s)              (01)
 W *2,!,$G(LRTOP),*3                             ; Tube top/specimen    (02)
 W *2,!,"Ord#:"_$G(LRCE),*3                      ; Order Number         (03)
 W *2,!,"UID:"_$G(LRUID),*3                      ; UID String           (04)
 W *2,!,$$LRDSHRT(LRDAT),*3                      ; Date                 (05)
 W *2,!,$G(HRCN),*3                              ; Health Record Number (06)
 W *2,!,$$LOCVAR(LRLLOC,LRRB),*3                 ; Location             (07)
 W *2,!,$G(PNM),*3                               ; Patient Name         (08)
 W *2,!,$$BLRURG(LRURG0),*3                      ; Urgency              (09)
 W *2,!,$TR($J($G(LRUID),10)," ","0"),*3         ; UID Bar Coded [ZF]   (10)
 W *2,!,"Sex:"_$G(SEX),*3                        ; Sex                  (11)
 W *2,!,"Prov:"_PROVSTR,*3                       ; Provider             (12)
 W *2,!,$$DOBSTR(DOB),*3                         ; Date of Birth        (13)
 ;
 W *2,*23,*15,"S30",*12,*3                       ; End WITH Form Feed
 ;W *2,*23,*15,"S30",*3                          ; End WITHOUT Form Feed
 ;
 Q
 ;
PRT ; EP - plain label..no barcode
 ;
 NEW PROVSTR,FORMFEED
 S PROVSTR=$$PROVN($G(LRAA),$G(LRAD),$G(LRAN))   ; Provider Function
 ;
 W *2,"R",*3                                     ; Exit Program Mode
 ;
 W *2,!,*27,"E2",*24,!,$$TESTSVAR($G(LRTXT)),*3  ; Test(s)              (01)
 W *2,!,$G(LRTOP),*3                             ; Tube top/specimen    (02)
 W *2,!,"Ord#:",$G(LRCE),*3                      ; Order Number         (03)
 W *2,!,"UID:",$G(LRUID),*3                      ; UID String           (04)
 W *2,!,$$LRDSHRT($G(LRDAT)),*3                  ; Date                 (05)
 W *2,!,$G(HRCN),*3                              ; Health Record Number (06)
 W *2,!,$$LOCVAR($G(LRLLOC),$G(LRRB)),*3         ; Location             (07)
 W *2,!,$G(PNM),*3                               ; Patient Name         (08)
 W *2,!,$$BLRURG(LRURG0),*3                      ; Urgency              (09)
 W *2,!,"Sex:",$G(SEX),*3                        ; Sex                  (10)
 W *2,!,"Prov:",PROVSTR,*3                       ; Provider             (11)
 W *2,!,$$DOBSTR($G(DOB)),*3                     ; Date of Birth        (12)
 ;
 W *2,*23,*15,"S30",*12,*3                       ; End WITH Form Feed
 ;W *2,*23,*15,"S30",*3                          ; End WITHOUT Form Feed
 ;
 Q
 ;
 ; Test(s) variable
TESTSVAR(LRTXT) ;
 NEW TESTSVAR
 S TESTSVAR=$E($G(LRTXT),1,32)
 I $L($G(LRTXT))>32 S TESTSVAR=$E($G(LRTXT),1,29)_"..."
 Q TESTSVAR
 ;
 ; Urgency variable
BLRURG(LRURG0)      ;
 NEW BLRURG
 S BLRURG="N/A"    ; Make sure BLRURG has something in it
 I $G(LRURG0)'="" S BLRURG=$E($P(^LAB(62.05,LRURG0,0),U,1),1,4)  ;IHS/DIR TUC/AAB 03/23/98
 Q BLRURG
 ;
 ; Make certain DOB has something in it
DOBSTR(DOB) ;
 I DOB="XX/XX/XXXX" Q "DoB:"_DOB    ; If TEST DoB
 ;
 NEW FMDOB
 ; Data in VADM array initialized by LRU routine
 S FMDOB=+$G(VADM(3))
 I FMDOB<1 Q "DoB:"_DOB
 ;
 Q "DoB:"_$$FMTE^XLFDT(FMDOB,"5DZ")       ; Return MM/DD/CCYY as DOB
 ;
 ; Make certain date string has a 2-digit year
LRDSHRT(LRDAT)      ;
 I LRDAT="XX/XX/XX" Q LRDAT_" XX:XX"             ; Test Date string
 ;
 NEW LRDSHRT
 S LRDSHRT=$G(LRDAT)
 I $L($P($P(LRDAT,"/",3)," ",1))>2 D
 . S LRDSHRT=$P(LRDAT,"/",1,2)_"/"_$E($P(LRDAT,"/",3),3,$L(LRDAT))
 Q LRDSHRT
 ;
 ; Make certain provider name has data
PROVN(LRAA,LRAD,LRAN)      ;
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
 ; Location variable
LOCVAR(LRLLOC,LRRB)      ;
 NEW LOCVAR
 S LOCVAR="L:"_$E($G(LRLLOC),1,7)
 I $L(LRRB)>0 S LOCVAR=LOCVAR_" B:"_LRRB
 Q LOCVAR
