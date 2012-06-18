BLRP41UI ; IHS/OIT/MKK - INTERMEC PC41 UID Barcoded Initialization ;DEC 09, 2008 8:30 AM
 ;;5.2;IHS LABORATORY;**1025**;NOV 01, 1997
 ;
 ; Initializes Intermec PC41 Label Printer.  Used in the RPMS Lab Module.
 ; Sets up UID to be barcoded, NOT, repeat NOT, the Accession's Number
 ; 
 ; Cloned from BLRBARC
 ;
FMT ; EP -- E3;F3 erases form 3 and accesses form #
 ;
ZIS K %ZIS S %ZIS="QN" D ^%ZIS I POP W !?7,*7,"NO DEVICE SELECTED ",! D ^%ZISC Q
 S ZTIO=ION,ZTDTH=$H,ZTDESC="BAR CODE FORMAT DOWN LOAD",ZTRTN="BAR^BLRP41UI" D ^%ZTLOAD
 D ^%ZISC W !!?5,"Barcode Formating Program",$S($G(ZTSK):" Queued ",1:" NOT QUEUED"),!!
 D ^%ZISC K ZTSK Q
 ;
BAR ; EP - programs format F3 for label with the accession # barcoded
 S:$D(ZTQUEUED) ZTREQ="@"
 S X=0 X ^%ZOSF("RM")
 ;
 NEW STX,ETX
 S STX=$C(2)                                 ; Start of Text
 S ETX=$C(3)                                 ; End of Text
 ;
 S X=0 X ^%ZOSF("RM")
 ;
 D BARUIDV                                   ; BARCODE Format
 ;
 D PLAINDEF                                  ; Plain, No barcode Format
 ;
PRT ; EP - programs the Intermec for print mode
 W *2,"R",*3                                 ; Exit Program Mode
 ;
 D ^%ZISC
 ;
 Q
 ;
BARUIDV ; EP -- BARCODE Format
 W *2,*27,"C",*3                                ; Selects ADVANCED mode
 W *2,*27,"P",*3                                ; Selects Program Mode
 ;
 ; Erases Format 3 & Readies Format 3 for redefinition
 W *2,"E3;F3;",*3
 ;
 ; Define the format
 W *2,"F3;H1;o165,580;f1;c2;h1;w1;d0,32;",*3    ; Test(s)                 (01)
 W *2,"F3;H2;o148,335;f1;c2;h1;w1;d0,12;",*3    ; Top/Specimen            (02)
 W *2,"F3;H3;o47,580;f1;c2;h1;w1;d0,13;",*3     ; Order #                 (03)
 W *2,"F3;H4;o130,580;f1;c2;h1;w1;d0,14;",*3    ; UID String              (04)
 W *2,"F3;H5;o130,370;f1;c2;h1;w1;d0,16;",*3    ; Date/Time               (05)
 W *2,"F3;H6;o30,580;f1;c2;h1;w1;d0,7;",*3      ; Health Record Number    (06)
 W *2,"F3;H7;o47,330;f1;c2;h1;w1;d0,12;",*3     ; Location                (07)
 W *2,"F3;H8;o0,580;f1;c2;h2;w1;d0,26;",*3      ; Patient Name            (08)
 W *2,"F3;H9;o30,260;f1;c2;h1;w1;d0,4;",*3      ; Urgency                 (09)
 ;
 ; UID Barcode 128 -- Doesn't have a Check Digit
 W *2,"F3;B10;o67,575;f1;c6;h60;w3.5;d0,10;",*3 ; UID Barcode 128         (10)
 ;
 W *2,"F3;H11;o0,270;f1;c2;h1;w1;d0,5;",*3      ; Sex                     (11)
 W *2,"F3;H12;o148,580;f1;c2;h1;w1;d0,20;",*3   ; Provider                (12)
 W *2,"F3;H13;o30,470;f1;c2;h1;w1;d0,15;",*3    ; Date of Birth           (13)
 Q
 ;
PLAINDEF ; EP - PLAIN LABEL Format
 W *2,*27,"C",*3                                ; Selects ADVANCED mode
 W *2,*27,"P",*3                                ; Selects Program Mode
 ;
 ; Erases Format 2 & Readies Format 2 for redefinition
 W *2,"E2;F2;",*3
 ;
 ; Define the format
 W *2,"F2;H14;o164,570;f1;c2;h1;w1;d0,30;",*3   ; TEST(S)           (01)
 W *2,"F2;H15;o147,570;f1;c2;h1;w1;d0,14;",*3   ; TOP/SPECIMEN      (02)
 W *2,"F2;H16;o53,570;f1;c2;h1;w1;d0,13;",*3    ; ORDER#            (03)
 W *2,"F2;H17;o75,570;f1;c2;h2;w1;d0,21;",*3    ; UID STRING        (04)
 W *2,"F2;H18;o108,570;f1;c2;h1;w1;d0,16;",*3   ; DATE/TIME         (05)
 W *2,"F2;H19;o33,570;f1;c2;h1;w1;d0,7;",*3     ; HRCN              (06)
 W *2,"F2;H20;o147,340;f1;c2;h1;w1;d0,12",*3    ; LOCATION          (07)
 W *2,"F2;H21;o0,570;f1;c2;h2;w1;d0,32;",*3     ; PT.NAME           (08)
 W *2,"F2;H22;o45,200;f0;c0;h3;w3;b2;d0,4;",*3  ; Urgency           (09)
 W *2,"F2;H23;o53,340;f1;c2;h1;w1;d0,5;",*3     ; Sex               (10)
 W *2,"F2;H24;o128,570;f1;c2;h1;w1;d0,28;",*3   ; Provider          (11)
 W *2,"F2;H25;o33,460;f1;c2;h1;w1;d0,16;",*3    ; DOB               (12)
 Q
 ;
TEST ; EP - Tests formats
 NEW DOB,HRCN,LRACCAP,LRAN,LRAS,LRCE,LRDAT
 NEW LRLLOC,LRPROV,LRRB,LRSPEC,LRTOP,LRTXT,LRURG,LRUID
 NEW NUMBER,PNM,SEX
 NEW PDOB,PHRCN,PLRACCAP,PLRAN,PLRAS,PLRCE,PLRDAT
 NEW PLRLLOC,PLRPROV,PLRRB,PLRSPEC,PLRTOP,PLRTXT,PLRURG,PLRUID
 NEW PNUMBER,PPNM,PSEX
 ;
 ; Sets variables to be used with the test labels
 D SETVARS
 ;
F3 ; Prints TEST label with UID # barcoded
 ;
 S X=0 X ^%ZOSF("RM")
 W *2,"R",*3                                     ; "Exit" Program Mode
 ;
 W *2,*27,"E3",*24,!,$G(LRTXT),*3                ; Test(s)              (01)
 W *2,!,$G(LRTOP),*3                             ; Top/Specimen         (02)
 W *2,!,"Ord#:"_$G(LRCE),*3                      ; Order Number         (03)
 W *2,!,"UID:"_$G(LRUID),*3                      ; UID String           (04)
 S LRDAT=$TR($$HTE^XLFDT($H,"2MZ"),"@"," ")      ; Now Date/Time
 W *2,!,$G(LRDAT),*3                             ; Date/Time            (05)
 W *2,!,$G(HRCN),*3                              ; Health Record Number (06)
 W *2,!,$G(LRLLOC)," ",$G(LRRB),*3               ; Location             (07)
 W *2,!,$E($G(PNM),1,27),*3                      ; Patient Name         (08)
 W *2,!,$G(LRURG),*3                             ; Urgency              (09)
 W *2,!,$G(LRUID),*3                             ; UID # -- Bar Coded   (10)
 W *2,!,"Sex:",$G(SEX),*3                        ; Sex                  (11)
 W *2,!,"Prov:"_$G(LRPROV),*3                    ; Provider             (12)
 W *2,!,"DoB:"_$G(DOB),*3                        ; Date of Birth        (13)
 ;
 ; W *2,*23,*15,"S30",*12,*3                     ; Ending WITH Form Feed
 W *2,*23,*15,"S30",*3          ; Ending WITHOUT Form Feed
 ;
F2 ; Prints TEST label WITHOUT a barcoded UID number
 S X=0 X ^%ZOSF("RM")
 ;
 W *2,*27,"E2",*24,!,$G(PLRTXT),*3               ; Test(s)              (01)
 W *2,!,$G(PLRTOP),*3                            ; Top/Specimen         (02)
 W *2,!,"Ord#:",$G(PLRCE),*3                     ; Order Number         (03)
 W *2,!,"UID:",$G(PLRUID),*3                     ; UID String           (04)
 S PLRDAT=$TR($$HTE^XLFDT($H,"2MZ"),"@"," ")     ; Now Date/Time
 W *2,!,$G(PLRDAT),*3                            ; Date/Time            (05)
 W *2,!,$G(PHRCN),*3                             ; Health Record Number (06)
 W *2,!,$G(PLRLLOC)," ",$G(LRRB),*3              ; Location             (07)
 W *2,!,$E($G(PPNM),1,27),*3                     ; Patient Name         (08)
 W *2,!,$G(PLRURG),*3                            ; Urgency              (09)
 W *2,!,"Sex:",$G(PSEX),*3                       ; Sex                  (10)
 W *2,!,"Prov:"_$G(PLRPROV),*3                   ; Provider             (11)
 W *2,!,"DoB:"_$G(PDOB),*3                       ; Date of Birth        (12)
 ;
 ; W *2,*23,*15,"S30",*12,*3                     ; Ending WITH Form Feed
 W *2,*23,*15,"S30",*3                           ; Ending WITHOUT Form Feed
 Q
 ;
SETVARS ; EP - Initialize variables for testing
 S (LRTXT,PLRTXT)="CHEM 7,GLUCOSE,A1C.K,IRON"
 S (LRTOP,PLRTOP)="MARBLED RED"
 S LRCE=$TR($J($R(1000000),6)," ","0")
 S PLRCE=$TR($J($R(1000000),6)," ","0")
 S (LRAS,PLRAS)="CH 1008 87"
 S (LRAN,PLRAN)=87
 S HRCN=$TR($J($R(10000000),7)," ","0")
 S PHRCN=$TR($J($R(10000000),7)," ","0")
 S (LRLLOC,PLRLLOC)="TTLAB"
 S (PNM,PPNM)="DO NOT USE,TEST LABEL LABEL LABEL LABELX"
 S (LRURG,PLRURG)="URGT"
 S LRUID=$TR($J($R(10000000000),10)," ","0")
 S PLRUID=$TR($J($R(10000000000),10)," ","0")
 S (NUMBER,PNUMBER)="00087"
 ;
 S (SEX,PSEX)="M"
 S (LRPROV,PLRPROV)="DOCTOR,DOCTOR DOCTOR"
 S (DOB,PDOB)="10/30/1955"
 ;
 S (LRACCAP,PLRACCAP)="SURG 1008 999"
 S (LRSPEC,PLRSPEC)="WOUND TISSUE"
 S (LRRB,PLRRB)="B:22"
 ;
 Q
