BLRBARA ; IHS/DIR/FJE - INTERMEC 4100 2 LABEL FORMAT 12:36 ; [ 03/18/1999  6:44 AM ]
 ;;5.2;LR;**1003,1007,1019**;MAR 25,2005
 ;
 ;This routine will program the Intermec 4100 for two label formats
 ;which can be used with BLRLABLA routine to print one normal label
 ;and one with the accesion # barcoded if the BARCODE LABEL field in
 ;file 68 (Accession area) is set to YES
FMT ;E3;F3 erases form 3 and accesses form #
 ;Hx defines field 0 as human readable code where x is variable # sent
 ;o150,390 sets origin from center of label for the variable #
 ;fx rotate value, 0=donot rotate,f1=90deg
 ;c2 field 0 will print in font 2
 ;;c0=7X9font,c1=7x11,c2=10x14,c7=5x7,c20=8,c21=12,c22=20
 ;h1=height of field is normal, h2=twice actual size
 ;w1=width of field is normal, w2=twice actual size
 ;d0,30 data entered is in printable mode and expect 30 char long
 ;b1 prints stat in reverse color
 ;Bx is barcode,o=origin,c0,1=Code3-9,h60=60dots high
 ;
 ;The code S X=0 X ^%ZOSF("RM") is used to replace U IO:0 which only
 ;works on an MSM system. This code will work with both DSM and MSM
 ;
ZIS K %ZIS S %ZIS="QN" D ^%ZIS I POP W !?7,*7,"NO DEVICE SELECTED ",! D ^%ZISC Q
 S ZTIO=ION,ZTDTH=$H,ZTDESC="BAR CODE FORMAT DOWN LOAD",ZTRTN="BAR^BLRBARA" D ^%ZTLOAD
 D ^%ZISC W !!?5,"Barcode Formating Program",$S($G(ZTSK):" Queued ",1:" NOT QUEUED"),!!
 ;
 ;----- BEGIN IHS/OIT/MKK MODIFICATIONS LR*5.2*1019
 ;      Modifying code to make more readable (making it easier
 ;      to maintain) and to make sure default 3400E label will
 ;      will print correctly.  Because of the number of extensive
 ;      changes the original code is at the end.
 ;
 ; D ^%ZISC K ZTSK Q
 D ^%ZISC
 K ZTSK
 Q
 ;
BAR ;programs format F3 for label with the accession # barcoded
 S:$D(ZTQUEUED) ZTREQ="@"
 S X=0 X ^%ZOSF("RM") W *2,*27,"C",*3
 W *2,*27,"P",*3
 W *2,"E3;F3;",*3
 ;
 W *2,"F3;H1;o155,295;f1;c2;h1;w1;d0,35;",*3       ; (01) TEST(S)
 W *2,"F3;H2;o138,295;f1;c2;h1;w1;d0,14;",*3       ; (02) TOP/SPECIMEN
 W *2,"F3;H3;o121,295;f1;c2;h1;w1;d0,13;",*3       ; (03) ORDER#
 W *2,"F3;H4;o160,375;f2;c2;h2;w1;d0,14;",*3       ; (04) ACCESSION
 W *2,"F3;H5;o175,335;f2;c2;h1;w1;d0,17;",*3       ; (05) DATE
 W *2,"F3;H6;o35,295;f1;c2;h1;w1;d0,7;",*3         ; (06) HRCN
 W *2,"F3;H7;o35,150;f1;c2;h1;w1;d0,20;",*3        ; (07) LOCATION
 W *2,"F3;H8;o0,295;f1;c2;h2;w1;d0,21;",*3         ; (08) PT.NAME
 W *2,"F3;H9;o125,100;f1;c0;h3;w3;b2;d0,4;",*3     ; (09) URGENCY
 W *2,"F3;B10;o55,295;f1;c0,1;h60;w2;d0,5;",*3     ; (10) BAR CODE
 ;
PLAIN ;programs format F2 for plain label /no barcoded accession #
 W *2,*27,"C",*3
 W *2,*27,"P",*3
 W *2,"E2;F2;",*3
 ;
 W *2,"F2;H14;o164,350;f1;c2;h1;w1;d0,35;",*3    ; (01) TEST(S)
 W *2,"F2;H15;o147,350;f1;c2;h1;w1;d0,14;",*3    ; (02) TOP/SPECIMEN
 W *2,"F2;H16;o53,350;f1;c2;h1;w1;d0,13;",*3     ; (03) ORDER#
 W *2,"F2;H17;o75,350;f1;c2;h2;w1;d0,21;",*3     ; (04) ACCESSION STRING
 W *2,"F2;H18;o108,350;f1;c2;h1;w1;d0,16;",*3    ; (05) DATE
 W *2,"F2;H19;o33,350;f1;c2;h1;w1;d0,7;",*3      ; (06) HRCN
 W *2,"F2;H20;o147,200;f1;c2;h1;w1;d0,12",*3     ; (07) LOCATION
 W *2,"F2;H21;o0,350;f1;c2;h2;w1;d0,21;",*3      ; (08) PT.NAME
 W *2,"F2;H22;o30,30;f0;c0;h3;w3;b2;d0,4;",*3    ; (09) URGENCY
 ;
 W *2,"F2;H23;o53,180;f1;c2;h1;w1;d0,5;",*3      ; (10) Sex
 W *2,"F2;H24;o130,350;f1;c2;h1;w1;d0,50;",*3    ; (11) Provider
 W *2,"F2;H25;o33,260;f1;c2;h1;w1;d0,16;",*3     ; (12) DOB
 ;
PRT ;programs the Intermec for print mode
 W *2,"R",*3
 D ^%ZISC
 Q
 ;
TEST ;sets variables used with the test labels
 S LRTXT="CHEM 7",LRTOP="MARBLED RED",LRCE="203987"
 S LRACC="CH 1008 87",LRDAT="10/08/93 18:00",HRCN="1234567"
 S LRLLOC="SICU",PNM="YOKUM,HOKUM",LRURG="STAT",LRAN=87
 ;
F3 ;prints sample of label with accession # barcoded
 S X=0 X ^%ZOSF("RM")
 W *2,*27,"E3",*24,!,LRTXT,*3               ; (01) Test(s)
 W *2,!,LRTOP,*3                            ; (02) Collection sample - tube top/specimen
 W *2,!,"Order#:",LRCE,*3                   ; (03) Order Number
 W *2,!,LRACC,*3                            ; (04) Accession String
 W *2,!,LRDAT,*3                            ; (05) Date
 W *2,!,HRCN,*3                             ; (06) Health Record Number
 W *2,!,LRLLOC,*3                           ; (07) Location
 W *2,!,$E(PNM,1,27),*3                     ; (08) Patient Name
 W *2,!,LRURG,*3                            ; (09) Urgency
 W *2,!,$E("0000",$L(LRAN),4)_LRAN,*3       ; (10) Accession Number -- Bar Coded
 W *2,*23,*15,"S30",*3
 ;
F2 ;prints sample of label without a barcoded accession number
 ; set variables needed for plain label
 S SEX="M",PROVN="TEST,DOCTOR",DOB="10/30/55"
 ;
 S X=0 X ^%ZOSF("RM")
 W *2,"R",*3
 W *2,*27,"E2",*24,!,LRTXT,*3               ; (01)
 W *2,!,LRTOP,*3                            ; (02)
 W *2,!,"Order#:",LRCE,*3                   ; (03)
 W *2,!,LRACC,*3                            ; (04)
 W *2,!,LRDAT,*3                            ; (05)
 W *2,!,HRCN,*3                             ; (06)
 W *2,!,LRLLOC,*3                           ; (07)
 W *2,!,PNM,*3                              ; (08)
 W *2,!,LRURG,*3                            ; (09)
 W *2,!,"Sex:",SEX,*3                       ; (10) Sex
 W *2,!,"Prov:"_$E(PROVN,1,18),*3           ; (11) Provider
 W *2,!,DOB,*3                              ; (12) Date of Birth
 W *2,*23,*15,"S30",*3
 ;
 ;----- END IHS/OIT/MKK MODIFICATIONS LR*5.2*1019
 Q
 ;
ORIGCODE ;
 ; BARCODE -- ORIGINAL
L1 W *2,"F3;H1;o150,390;f1;c2;h1;w1;d0,35;",*3       ; TEST
L2 W *2,"F3;H2;o133,350;f1;c2;h1;w1;d0,14;",*3       ; TOP/SPECIMEN
L3 W *2,"F3;H3;o116,350;f1;c2;h1;w1;d0,13;",*3       ; ORDER#
L4 W *2,"F3;H4;o160,450;f2;c2;h2;w1;d0,14;",*3       ; ACCESSION
L5 W *2,"F3;H5;o175,418;f2;c2;h1;w1;d0,17;",*3       ; DATE
L6 W *2,"F3;H6;o30,350;f1;c2;h1;w1;d0,7;",*3         ; HRCN
L7 W *2,"F3;H7;o30,250;f1;c2;h1;w1;d0,20;",*3        ; LOCATION
L8 W *2,"F3;H8;o0,350;f1;c2;h2;w1;d0,21;",*3         ; PT.NAME
L9 W *2,"F3;H9;o115,160;f1;c0;h3;w3;b1;d0,4;",*3     ; STAT
L10 W *2,"F3;B10;o50,350;f1;c0,1;h60;w2;d0,5;",*3     ; BAR CODE
 ;
 ; PLAIN -- ORIGINAL
 W *2,"F2;H11;o150,450;f1;c2;h1;w1;d0,35;",*3      ; TEST
 W *2,"F2;H12;o133,450;f1;c2;h1;w1;d0,13;",*3      ; ORDER#
 W *2,"F2;H13;o133,250;f1;c2;h1;w1;d0,12",*3       ; LOCATION
 W *2,"F2;H14;o105,350;f1;c2;h1;w1;d0,7;",*3       ; HRCN
 W *2,"F2;H15;o105,250;f1;c2;h1;w1;d0,14;",*3      ; DOB
 W *2,"F2;H16;o75,350;f1;c2;h2;w1;d0,21;",*3       ; PT.NAME
 W *2,"F2;H17;o50,450;f1;c2;h1;w1;d0,14;",*3       ; TOP/SPECIMEN
 W *2,"F2;H18;o33,450;f1;c2;h1;w1;d0,14;",*3       ; DATE
 W *2,"F2;H19;o0,450;f1;c2;h2;w1;d0,21;",*3        ; ACCESSION
 W *2,"F2;H20;o30,155;f1;c0;h3;w3;b1;d0,4;",*3     ; STAT
 ;
 ; TEST -- ORIGINAL
 S NUMBER="00087",LRAN="CH 1008 87",LRDAT="10/08/93 18:00" D
 .;S LRTOP="MARBLED RED",PNM="YOKUM,HOKUM",SSN="123-45-6789"
 .S LRTOP="MARBLED RED",PNM="YOKUM,HOKUM",HRCN="1234567"  ;IHS/ANMC/CLS 11/1/95
 .S DOB="10/30/55"  ;IHS/DIR TUC/AAB 04/15/98
 .S LRLLOC="SICU",LRCE="203987",LRTXT="CHEM 7",LRURG="STAT"
 .S LRACCAP="SURG 1008 999",LRSPEC="WOUND TISSUE"
 ;
OF3 ;prints sample of label with accession # barcoded
 S X=0 X ^%ZOSF("RM") W *2,*27,"E3",*24,!,LRTXT,!,LRTOP,!,"Order#:",LRCE,!,LRAN,*3
 ;W *2,!,LRDAT,!,SSN,!,"W:",LRLLOC,*3
 W *2,!,LRDAT,!,HRCN,!,"W:",LRLLOC,*3  ;IHS/ANMC/CLS 11/1/95
 W *2,!,PNM,*3
 W *2,! W:$D(LRURG)&(LRURG="STAT") LRURG W *3
 W *2,!,NUMBER,*3
 W *2,*23,*15,"S30",*3
 ;
OF2 ;prints sample of label without a barcoded accession number
 ;S X=0 X ^%ZOSF("RM") W *2,*27,"E2",*24,!,LRTXT,!,"Order#:",LRCE,!,"W:",LRLLOC,!,SSN,!,PNM,!,LRTOP,*3
 ;S X=0 X ^%ZOSF("RM") W *2,*27,"E2",*24,!,LRTXT,!,"Order#:",LRCE,!,"W:",LRLLOC,!,HRCN,!,PNM,!,LRTOP,*3  ;IHS/ANMC/CLS 11/1/95
 S X=0 X ^%ZOSF("RM") W *2,*27,"E2",*24,!,LRTXT,!,"Order#:",LRCE,!,"W:",LRLLOC,!,HRCN,!,"DOB:",DOB,*3  ;IHS/DIR TUC/AAB 04/15/98
 W *2,!,PNM,!,LRTOP,*3  ;IHS/DIR TUC/AAB 04/15/98
 W *2,!,LRDAT,!,LRAN,*3
 W *2,! W:$D(LRURG)&(LRURG="STAT") LRURG W *3
 W *2,*23,*15,"S30",*3
 Q
