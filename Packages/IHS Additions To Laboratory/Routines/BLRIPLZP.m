BLRIPLZP ; IHS/OIT/MKK - INTERMEC IPL ACCESSION NUMBER Barcode 39 Lab Label Print ; [ 04/04/2009  8:30 AM ]
 ;;5.2;IHS LABORATORY;**1030**;NOV 01, 1997
 ;
 ; Total Rewrite
 ; For IPL capable printers only.  NO BINARY CODE VERSION.
 ; Accession Number & BARCODE 39 ONLY.
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
 W "<STX>R<ETX>"                                        ; "Exit" Program Mode
 ;
 W "<STX><ESC>E3<CAN><ETX>"                             ; Format 3 -- Barcode
 W "<STX><CR>"_$$TESTSVAR($G(LRTXT))_"<ETX>"            ; Test(s)              (01)
 W "<STX><CR>","Prov:"_$G(PROVSTR)_"<ETX>"              ; Provider             (02)
 W "<STX><CR>"_$G(LRTOP)_"<ETX>"                        ; Top/Specimen         (03)
 W "<STX><CR>"_$G(LRACC)_"<ETX>"                        ; ACCESSION String     (04)
 W "<STX><CR>"_$$LRDSHRT($G(LRDAT))_"<ETX>"             ; Date/Time            (05)
 W "<STX><CR>"_ZFLRAN_"<ETX>"                           ; Acces # - BarCode 39 (06)
 W "<STX><CR>Ord#:"_$G(LRCE)_"<ETX>"                    ; Order Number         (07)
 W "<STX><CR>"_$$LOCVAR($G(LRLLOC),$G(LRRB))_"<ETX>"    ; Location             (08)
 W "<STX><CR>"_$G(HRCN)_"<ETX>"                         ; Health Record Number (09)
 W "<STX><CR>"_$$DOBSTR($G(DOB))_"<ETX>"                ; Date of Birth        (10)
 W "<STX><CR>"_$$BLRURG($G(LRURG0))_"<ETX>"             ; Urgency              (11)
 W "<STX><CR>"_$E($G(PNM),1,27)_"<ETX>"                 ; Patient Name         (12)
 W "<STX><CR>Sex:"_$G(SEX)_"<ETX>"                      ; Sex                  (13)
 ;
 ; W "<STX><ETB><SI>S30<FF><ETX>"                         ; Ending WITH Form Feed
 W "<STX><ETB><SI>S30<ETX>"                             ; Ending WITHOUT Form Feed
 ;
 Q
 ;
PRT ; EP - plain label..no barcode
 ;
 NEW PROVSTR,FORMFEED
 S PROVSTR=$$PROVN($G(LRAA),$G(LRAD),$G(LRAN))          ; Provider Function
 ;
 W "<STX>R<ETX>"                                        ; "Exit" Program Mode
 W "<STX><ESC>E2<CAN><ETX>"                             ; Format 2 -- Plain
 W "<STX><CR>"_$$TESTSVAR($G(LRTXT))_"<ETX>"            ; Test(s)              (01)
 W "<STX><CR>"_$G(LRTOP)_"<ETX>"                        ; Top/Specimen         (02)
 W "<STX><CR>"_$$LOCVAR($G(LRLLOC),$G(LRRB))_"<ETX>"    ; Location             (03)
 W "<STX><CR>Prov:"_$G(PROVSTR)_"<ETX>"                 ; Provider             (04)
 W "<STX><CR>"_$$LRDSHRT($G(LRDAT))_"<ETX>"             ; Date/Time            (05)
 W "<STX><CR>"_$G(LRACC)_"<ETX>"                        ; Accession String     (06)
 W "<STX><CR>Ord#:"_$G(LRCE)_"<ETX>"                    ; Order Number         (07)
 W "<STX><CR>Sex:"_$G(SEX)_"<ETX>"                      ; Sex                  (08)
 W "<STX><CR>"_$$BLRURG(LRURG0)_"<ETX>"                 ; Urgency              (09)
 W "<STX><CR>"_$G(HRCN)_"<ETX>"                         ; Health Record Number (10)
 W "<STX><CR>"_$$DOBSTR($G(DOB))_"<ETX>"                ; Date of Birth        (11)
 W "<STX><CR>"_$E($G(PNM),1,32)_"<ETX>"                 ; Patient Name         (12)
 ;
 ; W "<STX><ETB><SI>S30<FF><ETX>"                         ; Ending WITH Form Feed
 W "<STX><ETB><SI>S30<ETX>"                             ; Ending WITHOUT Form Feed
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
