BLRBARE ; IHS/DIR/FJE - INTERMEC 4100 2 LABEL FORMAT 12:36 ; [ 10/12/1999  12:25 PM ]
 ;;5.2;LR;**1003,1007,1009**;OCT 10, 1999
 ;;MODIFIED FOR SSMARIE 10/12/99 fje
 ;This routine will program the Intermec 4100 for two label formats
 ;which can be used with BLRLABLE routine to print one normal label
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
 S ZTIO=ION,ZTDTH=$H,ZTDESC="BAR CODE FORMAT DOWN LOAD",ZTRTN="BAR^BLRBARE" D ^%ZTLOAD
 D ^%ZISC W !!?5,"Barcode Formating Program",$S($G(ZTSK):" Queued ",1:" NOT QUEUED"),!!
 D ^%ZISC K ZTSK Q
BAR ;programs format F3 for label with the accession # barcoded
 S:$D(ZTQUEUED) ZTREQ="@"
 S X=0 X ^%ZOSF("RM") W *2,*27,"C",*3
 W *2,*27,"P",*3
 W *2,"E3;F3;",*3
L1 W *2,"F3;H1;o150,390;f1;c2;h1;w1;d0,35;",*3 ;TEST
L2 W *2,"F3;H2;o133,350;f1;c2;h1;w1;d0,14;",*3 ;TOP/SPECIMEN
L3 W *2,"F3;H3;o116,350;f1;c2;h1;w1;d0,13;",*3 ;ORDER#
L4 W *2,"F3;H4;o160,450;f2;c2;h2;w1;d0,14;",*3 ;ACCESSION
L5 W *2,"F3;H5;o175,418;f2;c2;h1;w1;d0,17;",*3 ;DATE IHS/FJE 3/18/99
L6 W *2,"F3;H6;o30,350;f1;c2;h1;w1;d0,7;",*3 ;HRCN
L7 W *2,"F3;H7;o30,250;f1;c2;h1;w1;d0,12;",*3 ;LOCATION
L8 W *2,"F3;H8;o0,350;f1;c2;h2;w1;d0,21;",*3 ;PT.NAME
L9 W *2,"F3;H9;o116,90;f1;c0;h1;w1;d0,4;",*3 ;STAT remove b1  (w3;b1:d0)
L10 W *2,"F3;B10;o50,350;f1;c0,1;h60;w2;d0,5;",*3 ;BAR CODE
L11 W *2,"F3;H11;o133,200;f1;c2;h1;w1;d0,16;",*3 ;PROVIDER
L12 W *2,"F3;H12;o116,225;f1;c2;h1;w1;d0,14;",*3 ;DOB
 ;
PLAIN ;programs format F2 for plain label /no barcoded accession #
 W *2,*27,"C",*3
 W *2,*27,"P",*3
 W *2,"E2;F2;",*3
L13 W *2,"F2;H13;o150,450;f1;c2;h1;w1;d0,35;",*3 ;TEST
L14 W *2,"F2;H14;o133,450;f1;c2;h1;w1;d0,13;",*3 ;ORDER#
L15 W *2,"F2;H15;o133,250;f1;c2;h1;w1;d0,12",*3 ;LOCATION
L16 W *2,"F2;H16;o105,350;f1;c2;h1;w1;d0,7;",*3 ;HRCN
L17 W *2,"F2;H17;o105,250;f1;c2;h1;w1;d0,14;",*3 ;DOB
L18 W *2,"F2;H18;o75,350;f1;c2;h2;w1;d0,21;",*3 ;PT.NAME
L19 W *2,"F2;H19;o50,450;f1;c2;h1;w1;d0,14;",*3 ;TOP/SPECIMEN
L20 W *2,"F2;H20;o33,450;f1;c2;h1;w1;d0,17;",*3 ;DATE IHS/FJE 10/12/99
L21 W *2,"F2;H21;o0,450;f1;c2;h2;w1;d0,21;",*3 ;ACCESSION
L22 W *2,"F2;H22;o33,155;f1;c0;h1;w1;d0,4;",*3 ;STAT remove b1 (w3;b1;d0)
L23 W *2,"F2;H23;o50,300;f1;c2;h1;w1;d0,16;",*3 ;PROVIDER
 ;
PRT ;programs the Intermec for print mode
 W *2,"R",*3
 D ^%ZISC Q
TEST ;sets variables used with the test labels
 S NUMBER="00087",LRAN="CH 1008 87",LRDAT="10/08/93 18:00" D
 .S LRTOP="MARBLED RED",PNM="YOKUM,HOKUM",HRCN="1234567"
 .S DOB="10/30/1955"
 .S LRLLOC="SICU",LRCE="203987",LRTEST="CHEM 7",LRURG="STAT"
 .S LRACCAP="SURG 1008 999",LRSPEC="WOUND TISSUE"
 .S LRDOC="DR. SMITH"
F3 ;prints sample of label with accession # barcoded
 S X=0 X ^%ZOSF("RM") W *2,*27,"E3",*24,!,LRTEST,!,LRTOP,!,"O#:",LRCE,!,LRAN,*3
 W *2,!,LRDAT,!,HRCN,!,"W:",LRLLOC,*3
 W *2,!,PNM,*3
 W *2,!,LRURG W *3
 W *2,!,NUMBER,*3
 W *2,!,LRDOC,*3
 W *2,!,DOB,*3
 W *2,*23,*15,"S30",*3
 ;
F2 ;prints sample of label without a barcoded accession number
 S X=0 X ^%ZOSF("RM") W *2,*27,"E2",*24,!,LRTEST,!,"O#:",LRCE,!,"W:",LRLLOC,!,HRCN,!,"DOB:",DOB,*3
 W *2,!,PNM,!,LRTOP,*3
 W *2,!,LRDAT,!,LRAN,*3
 W *2,!,LRURG W *3
 W *2,!,LRDOC,*3
 W *2,*23,*15,"S30",*3
 Q
