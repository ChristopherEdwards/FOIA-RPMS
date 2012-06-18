BLRIPLZI ; IHS/OIT/MKK - INTERMEC IPL ACCESSION NUMBER Barcode 39 Lab Label Intialization ; [ 04/04/2009  8:30 AM ]
 ;;5.2;IHS LABORATORY;**1030**;NOV 01, 1997
 ;
 ; For IPL capable printers only.  NO BINARY CODE VERSION.
 ; 
 ; NOTE: Allows Users to specify SHIFT variable by using the
 ;       PROGINIT label.
 ; 
 ; Cloned from BLRBARZ
 ; Accession Number Barcoded using BARCODE 39 ONLY.
 ; 
FMT ;EP - E3;F3 erases format 3 (BARCODE) and accesses form #
 ;     E2;F2 erases format 2 (PLAIN) and accesses form #
 ;
ZIS ; EP
 K %ZIS
 S %ZIS="QN"
 D ^%ZIS I POP W !?7,*7,"NO DEVICE SELECTED ",! D ^%ZISC Q
 ;
 S ZTIO=ION
 S ZTDTH=$H
 S ZTDESC="BAR CODE FORMAT DOWN LOAD"
 S ZTRTN="BAR^BLRIPLZI"
 D ^%ZTLOAD
 D ^%ZISC W !!?5,"Barcode Formating Program",$S($G(ZTSK):" Queued ",1:" NOT QUEUED"),!!
 D ^%ZISC
 K ZTSK
 Q
 ;
BAR ; EP
 NEW SHIFT
 ;
 S:$D(ZTQUEUED) ZTREQ="@"
 ; S X=0 X ^%ZOSF("RM")
 ;
 S SHIFT=200
 ;
 D BARCODEI(SHIFT)             ; Initializes format F3: accession # barcoded
 D PLAININI(SHIFT)             ; Initializes format F2: no barcode
 W "<STX>R<ETX>"               ; "Exit" Program Mode
 ;
 D ^%ZISC
 Q
 ;
PROGINIT ; EP -- SHIFT Prompt.
 NEW SHIFT
 ;
 D ^XBFMK
 S DIR(0)="NOA^-200:200"
 S DIR("A")="SHIFT Parameter (-200 to +200) "
 D ^DIR
 S SHIFT=+$G(Y)
 ;
 K %ZIS
 S %ZIS="QN"
 D ^%ZIS I POP W !?7,*7,"NO DEVICE SELECTED ",! D ^%ZISC Q
 ;
 S ZTSAVE("SHIFT")=""
 S ZTIO=ION
 S ZTDTH=$H
 S ZTDESC="SHIFT BAR CODE FORMAT DOWN LOAD"
 S ZTRTN="PROGBAR^BLRIPLZI"
 D ^%ZTLOAD
 D ^%ZISC W !!?5,"SHIFT Barcode Formating Program",$S($G(ZTSK):" Queued ",1:" NOT QUEUED"),!!
 D ^%ZISC
 K ZTSK
 Q
 ;
PROGBAR ; EP - SHIFT Initialization
 S:$D(ZTQUEUED) ZTREQ="@"
 ; S X=0 X ^%ZOSF("RM")
 ;
 D BARCODEI(SHIFT)             ; Initializes format F3: accession # barcoded
 D PLAININI(SHIFT)             ; Initializes format F2: no barcode
 W "<STX>R<ETX>"               ; "Exit" Program Mode
 ;
 D ^%ZISC
 Q
 ;
BARCODEI(SHIFT) ; EP - Bar code format, By ROWs,
 NEW SYMBOLGY
 D PREPCODE(3)
 ;
 W "<STX>F3;H1;o165,"_(575-SHIFT)_";f1;c2;h1;w1;d0,32<ETX>"    ; Test(s)              (01)
 W "<STX>F3;H2;o148,"_(575-SHIFT)_";f1;c2;h1;w1;d0,18<ETX>"    ; Provider             (02)
 W "<STX>F3;H3;o148,"_(325-SHIFT)_";f1;c2;h1;w1;d0,11<ETX>"    ; Top/Specimen         (03)
 W "<STX>F3;H4;o130,"_(575-SHIFT)_";f1;c2;h1;w1;d0,14<ETX>"    ; Accession String     (04)
 W "<STX>F3;H5;o130,"_(360-SHIFT)_";f1;c2;h1;w1;d0,16<ETX>"    ; Date/Time            (05)
 S SYMBOLGY=+$G(^BLRSITE(+$G(DUZ(2)),6))                       ; Intermec Symbology
 S SYMBOLGY=17
 ; W "<STX>F3;B6;o67,"_(570-SHIFT)_";f1;c0;h60;w3;d0,10<ETX>"    ; Acc # Barcode 39     (06)
 W "<STX>F3;B6;o67,"_(570-SHIFT)_";f1;c"_SYMBOLGY_";h60;w3;d0,10<ETX>"    ; Acc # Barcode 39     (06)
 W "<STX>F3;H7;o47,"_(575-SHIFT)_";f1;c2;h1;w1;d0,13<ETX>"     ; Order #              (07)
 W "<STX>F3;H8;o47,"_(330-SHIFT)_";f1;c2;h1;w1;d0,12<ETX>"     ; Location             (08)
 W "<STX>F3;H9;o30,"_(575-SHIFT)_";f1;c2;h1;w1;d0,7<ETX>"      ; Health Record Number (09)
 W "<STX>F3;H10;o30,"_(470-SHIFT)_";f1;c2;h1;w1;d0,15<ETX>"    ; Date of Birth        (10)
 W "<STX>F3;H11;o30,"_(260-SHIFT)_";f1;c2;h1;w1;d0,4<ETX>"     ; Urgency              (11)
 W "<STX>F3;H12;o0,"_(575-SHIFT)_";f1;c2;h2;w1;d0,25<ETX>"     ; Patient Name         (12)
 W "<STX>F3;H13;o0,"_(265-SHIFT)_";f1;c2;h1;w1;d0,5<ETX>"      ; Sex                  (13)
 ;
 Q
 ;
PREPCODE(FORMAT) ;EP - Code Common to BAR & PLAIN labels initialization
 S:$G(SHIFT)="" SHIFT=0
 S:+$G(SHIFT)<(-200) SHIFT=-200
 S:+$G(SHIFT)>200 SHIFT=200
 ; 
 W "<STX><ESC>C<ETX>"
 W "<STX><ESC>P<ETX>"
 W "<STX>E"_FORMAT_";F"_FORMAT_"<ETX>"
 Q
 ;
PLAININI(SHIFT) ; EP -- PLAIN format - By ROWs,
 D PREPCODE(2)
 ;
 W "<STX>F2;H14;o165,"_(575-SHIFT)_";f1;c2;h1;w1;d0,32<ETX>"   ; Test(s)              (01)
 W "<STX>F2;H15;o146,"_(575-SHIFT)_";f1;c2;h1;w1;d0,11;<ETX>"  ; Top/Specimen         (02)
 W "<STX>F2;H16;o146,"_(330-SHIFT)_";f1;c2;h1;w1;d0,12<ETX>"   ; Location             (03)
 W "<STX>F2;H17;o127,"_(575-SHIFT)_";f1;c2;h1;w1;d0,28<ETX>"   ; Provider             (04)
 W "<STX>F2;H18;o108,"_(575-SHIFT)_";f1;c2;h1;w1;d0,16<ETX>"   ; Date/Time            (05)
 W "<STX>F2;H19;o72,"_(575-SHIFT)_";f1;c2;h2;w1;d0,14<ETX>"    ; Accession String     (06)
 W "<STX>F2;H20;o51,"_(575-SHIFT)_";f1;c2;h1;w1;d0,13;<ETX>"   ; Order #              (07)
 W "<STX>F2;H21;o51,"_(350-SHIFT)_";f1;c2;h1;w1;d0,5<ETX>"     ; Sex                  (08)
 W "<STX>F2;H22;o35,"_(200-SHIFT)_";f0;c0;h3;w3;b2;d0,4<ETX>"  ; Urgency              (09)
 W "<STX>F2;H23;o32,"_(575-SHIFT)_";f1;c2;h1;w1;d0,7;<ETX>"    ; Health Record Number (10)
 W "<STX>F2;H24;o32,"_(460-SHIFT)_";f1;c2;h1;w1;d0,15<ETX>"    ; Date of Birth        (11)
 W "<STX>F2;H25;o0,"_(575-SHIFT)_";f1;c2;h2;w1;d0,32<ETX>"     ; Patient Name         (12)
 Q
 ;
TEST ; EP - sets variables used with the test labels
 NEW DOB,HRCN,LRACCAP,LRAN,LRAS,LRCE,LRDAT
 NEW LRLLOC,LRPROV,LRRB,LRSPEC,LRTOP,LRTXT,LRURG,LRUID
 NEW NUMBER,PNM,SEX
 ;
 D ^%ZIS
 I POP D  Q
 . W !!,"DEVICE ISSUE.  ROUTINE STOPPING.",!
 . D PRESSKEY(5)
 ;
 U IO
 D F3
 D ^%ZISC
 Q
 ;
PRESSKEY(TAB) ; EP - Generic "PRESS RETURN KEY TO CONTINUE"
 S DIR(0)="EA"
 S DIR("A")=$J("",+$G(TAB))_"Press RETURN Key to continue: "
 D ^DIR
 Q
 ;
F3 ; EP - Prints TEST label with Accession # barcoded
 D BARCODET
 ;
 ;
F2 ; Prints TEST label WITHOUT a barcoded UID number
 D PLAINTST
 ;
 W "<STX><FF><ETX>"                   ; Form Feed
 Q
 ;
BARCODET ; EP - BARCODE format Test print
 D SETVARS
 ;
 W "<STX><ESC>E3<CAN><ETX>"                       ; Format 3 -- Barcode
 W "<STX><CR>",$G(LRTXT),"<ETX>"                  ; Test(s)              (01)
 W "<STX><CR>","Prov:"_$G(LRPROV),"<ETX>"         ; Provider             (02)
 W "<STX><CR>",$G(LRTOP),"<ETX>"                  ; Top/Specimen         (03)
 W "<STX><CR>"_$G(LRAS),"<ETX>"                   ; ACCESSION String     (04)
 W "<STX><CR>",$G(LRDAT),"<ETX>"                  ; Date/Time            (05)
 W "<STX><CR>",$G(LRAN),"<ETX>"                   ; UID # -- Bar Coded   (06)
 W "<STX><CR>","Ord#:"_$G(LRCE),"<ETX>"           ; Order Number         (07)
 W "<STX><CR>",$G(LRLLOC)," ",$G(LRRB),"<ETX>"    ; Location             (08)
 W "<STX><CR>",$G(HRCN),"<ETX>"                   ; Health Record Number (09)
 W "<STX><CR>","DoB:"_$G(DOB),"<ETX>"             ; Date of Birth        (10)
 W "<STX><CR>",$G(LRURG),"<ETX>"                  ; Urgency              (11)
 W "<STX><CR>",$E($G(PNM),1,27),"<ETX>"           ; Patient Name         (12)
 W "<STX><CR>","Sex:",$G(SEX),"<ETX>"             ; Sex                  (13)
 W "<STX><ETB><SI>S30<ETX>"                       ; End WITHOUT Form Feed
 Q
 ;
PLAINTST ; EP - PLAIN label TeST print
 D SETVARS
 ;
 W "<STX><ESC>E2<CAN><ETX>"                       ; Format 2 -- Plain
 W "<STX><CR>",$G(LRTXT),"<ETX>"                  ; Test(s)              (01)
 W "<STX><CR>",$G(LRTOP),"<ETX>"                  ; Top/Specimen         (02)
 W "<STX><CR>",$G(LRLLOC)," ",$G(LRRB),"<ETX>"    ; Location             (03)
 W "<STX><CR>","Prov:"_$G(LRPROV),"<ETX>"         ; Provider             (04)
 W "<STX><CR>",$G(LRDAT),"<ETX>"                  ; Date/Time            (05)
 W "<STX><CR>",$G(LRAS),"<ETX>"                   ; ACCESSION String     (06)
 W "<STX><CR>","Ord#:",$G(LRCE),"<ETX>"           ; Order Number         (07)
 W "<STX><CR>","Sex:",$G(SEX),"<ETX>"             ; Sex                  (08)
 W "<STX><CR>",$G(LRURG),"<ETX>"                  ; Urgency              (09)
 W "<STX><CR>",$G(HRCN),"<ETX>"                   ; Health Record Number (10)
 W "<STX><CR>","DoB:"_$G(DOB),"<ETX>"             ; Date of Birth        (11)
 W "<STX><CR>",$E($G(PNM),1,32),"<ETX>"           ; Patient Name         (12)
 W "<STX><ETB><SI>S30<ETX>"                       ; End WITHOUT Form Feed
 Q
 ;
SETVARS ; EP - Initialize variables for testing
 D MAKERNDM
 ;                 123456789012345678901234567890123
 S LRTXT="CHEM 7,GLUCOSE,A1C,LIPID,CK,CRP,Chem7"
 S LRTOP="MARBLED RED"
 S LRDAT=$TR($$HTE^XLFDT($H,"2MZ"),"@"," ")      ; Now Date/Time
 S LRLLOC="TTLAB"
 S LRURG="ROUTINE"
 ;
 S SEX="M"
 S LRPROV="DOCTOR,DOCTOR DOCTOR"
 ;
 S LRACCAP="SURG 1008 999"
 S LRSPEC="WOUND TISSUE"
 S LRRB="B:22"
 ;
 Q
 ;
MAKERNDM ; EP - Randomly set certain variables
 NEW DAY,LDM,FNAME,LNAME,MON,NUM
 ;
 S LRCE=$TR($J($R(1000000),6)," ","0")
 S HRCN=$TR($J($R(10000000),7)," ","0")
 S LRUID=$TR($J($R(10000000000),10)," ","0")
 ;
 S LRAS=$$ACCRNDOM()
 S NUM=+$P(LRAS," ",3)
 S (LRAN,NUMBER)=$TR($J(NUM,5)," ","0")
 ;
 S DOB=$$DOBSTR()
 ;
 ; S (PNM,PPNM)="DO NOT USE,TEST LABEL 12345678901234567890"
 S FNAME=$$RANDNAME(10)
 S LNAME=$$RANDNAME(10)
 S PNM=LNAME_","_FNAME_"  "_$TR($J($R(10000000000000000),18)," ","0")
 ;
 Q
 ;
DOBSTR() ; EP - Make DoB random
 NEW DOBMO,DOBDY,DOBYR
 ; 
 S DOBMO=0  F  Q:DOBMO>0&(DOBMO<13)  S DOBMO=$R(100)
 S DOBDY=0  F  Q:DOBDY>0&(DOBDY<28)  S DOBDY=$R(10)
 S DOBYR=1000  F  Q:DOBYR>1900&(DOBYR<2009)  S DOBYR=$R(10000)
 Q $TR($J(DOBMO,2)," ","0")_"/"_$TR($J(DOBDY,2)," ","0")_"/"_DOBYR
 ;
RANDNAME(LEN) ; EP - Make Random (Gibberish) Name
 NEW NAME,WOTALFA
 ;
 S NAME=$J($R($RE($TR($J(1,LEN)," ","0")))," ","0")
 S WOTALFA=$R(10)#2
 S:WOTALFA NAME=$TR(NAME,"1234567890","ABCDEFGHIJ")
 S:'WOTALFA NAME=$TR(NAME,"1234567890","KLMNOPQRST")
 Q NAME
 ;
ACCRNDOM() ; EP - Make Random Accession numbers.  CH only.
 S MON=0  F  Q:MON>0&(MON<13)  S MON=$R(100)
 S:MON=1!(MON=3)!(MON=5)!(MON=7)!(MON=8)!(MON=10)!(MON=12) LDM=31
 S:MON=2 LDM=28
 S:MON=4!(MON=6)!(MON=9)!(MON=11) LDM=31
 S MON=$TR($J(MON,2)," ","0")
 S DAY=0  F  Q:DAY>0&(DAY<LDM)  S DAY=$R(100)
 S DAY=$TR($J(DAY,2)," ","0")
 S NUM=0  F  Q:NUM>0&(NUM<99)  S NUM=$R(100)
 S NUM=$TR($J(NUM,2)," ","0")
 Q "CH "_MON_DAY_" "_NUM
 ;
JUSTBAR ; EP - Tests BARCODE format only
 NEW DOB,HRCN,LRACCAP,LRAN,LRAS,LRCE,LRDAT
 NEW LRLLOC,LRPROV,LRRB,LRSPEC,LRTOP,LRTXT,LRURG,LRUID
 NEW NUMBER,PNM,SEX
 ;
 ;
 D ^%ZIS
 I POP D  Q
 . W !!,"DEVICE ISSUE.  ROUTINE STOPPING.",!!
 . D PRESSKEY(5)
 ;
 U IO
 ;
 D BARCODET
 ;
 W "<STX><FF><ETX>"                   ; Form Feed
 D ^%ZISC
 Q
 ;
JUSTPLN ; EP - Tests PLAIN format only
 NEW DOB,HRCN,LRACCAP,LRAN,LRAS,LRCE,LRDAT
 NEW LRLLOC,LRPROV,LRRB,LRSPEC,LRTOP,LRTXT,LRURG,LRUID
 NEW NUMBER,PNM,SEX
 ;
 D ^%ZIS
 I POP D  Q
 . W !!,"DEVICE ISSUE.  ROUTINE STOPPING.",!!
 . D PRESSKEY(5)
 ;
 U IO
 ;
 D PLAINTST
 ;
 W "<STX><FF><ETX>"                   ; Form Feed
 D ^%ZISC
 Q
