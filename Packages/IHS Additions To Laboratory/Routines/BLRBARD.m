BLRBARD ; IHS/DIR/FJE - INTERMEC 7421 3 PART LABEL FORMAT 12:36 ; [ 03/17/1999  12:28 PM ]
 ;;5.2;LR;**1006**;MAR 1, 1999
 ;;5.2;LR;;NOV 01, 1997
 ;;5.2;LAB SERVICE;;Sep 27, 1994
 ;This routine will program the Intermec 7421,2 a 3 part 1.5X3.0 in
 ;label which can be used with BLRLABLD routine to print a 3 part
 ;accession label which includes barcoded accession labels. The large
 ;labels are small enough to fit the small hematology tubes with the
 ;hemaguard
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
 ;The code S X=0 X ^%ZOSF("RM") is needed to replace U IO:0 which only
 ;works on an MSM system. This code will work with both DSM and MSM
 ;printer settings
 ;9600,7,PARITY EVEN - SW1-1   ON, SW2-1 ON
 ;4800,7,PARITY EVEN - SW1-2   ON, SW2-1 ON
 ;2400,7,PARITY EVEN - SW1-1,1 ON, SW2-1 ON
 ;1200,7,PARITY EVEN - SW1-3   ON, SW2-1 ON
ZIS S %ZIS="QN" D ^%ZIS I POP W ?20,*7,"NO DEVICE SELECTED " Q
 S ZTIO=ION,ZTDTH=$H,ZTDESC="BAR CODE FORMAT DOWN LOAD",ZTRTN="BAR^BLRBARD" D ^%ZTLOAD Q
BAR ;FORMAT BAR CODE LABELS
 S X=0 X ^%ZOSF("RM") W *2,*27,"P",*3 ;SET INTO PROGRAM MODE
 W *2,"E4;F4;",*3 ;ERASES FORMAT STORED IN FORMAT 4 AND ACCESSES FORMAT 4
L0 W *2,"F4;H0;o160,485;f2;c2;h2;w1;d0,14;",*3 ;ACC#
L1 W *2,"F4;H1;o200,453;f2;c2;h1;w1;d0,16;",*3 ;DATE
L2 W *2,"F4;H2;o133,350;f1;c2;h1;w1;d0,14;",*3 ;TUBE
L3 W *2,"F4;H3;o0,390;f1;c2;h2;w1;d0,21;",*3 ;NAME
L4 W *2,"F4;H4;o30,390;f1;c2;h1;w1;d0,7;",*3 ;HRCN
L5 W *2,"F4;H5;o30,290;f1;c2;h1;w1;d0,9;",*3 ;LOCATION
L6 W *2,"F4;B6;o50,400;f1;c0,0;h60;w2;d0,5;",*3 ;BARCODE
L7 W *2,"F4;H7;o116,390;f1;c2;h1;w1;d0,13;",*3 ;ORDER#
L8 W *2,"F4;H8;o150,390;f1;c2;h1;w1;d0,22;",*3 ;TESTS
L9 W *2,"F4;H9;o170,240;f1;c0;h3;w3;b1;d0,4;",*3 ;STAT
L10 W *2,"F4;H10;o0,700;f1;c2;h2;w1;d0,14;",*3 ;1-SMALL LABEL/ACC#
L11 W *2,"F4;H11;o35,700;f1;c2;h1;w1;d0,16;",*3 ;1-SMALL LABEL/DATE
L12 W *2,"F4;H12;o90,700;f1;c2;h2;w1;d0,14;",*3 ; 1-LL LABEL/ACC#
L13 W *2,"F4;H13;o133,700;f1;c2;h1;w1;d0,20;",*3 ;1-LL LABEL/NAME
L14 W *2,"F4;H14;o150,700;f1;c2;h1;w1;d0,7;",*3 ;1-LL LABEL/HRCN
L15 W *2,"F4;H15;o166,700;f1;c2;h1;w1;d0,7;",*3 ;1-LL LABEL/LOCATION
L16 W *2,"F4;H16;o181,700;f1;c2;h1;w1;d0,16;",*3 ;1-LL LABEL/DATE
L17 W *2,"F4;H17;o200,700;f1;c2;h1;w1;d0,13;",*3 ;1-LL LABEL/TEST
PLAIN ;programs format F2 for plain label /no barcoded accession #
 W *2,*27,"C",*3
 W *2,*27,"P",*3
 W *2,"E5;F5;",*3
L18 W *2,"F5;H18;o0,450;f1;c2;h2;w1;d0,21;",*3 ;ACC#
L19 W *2,"F5;H19;o33,450;f1;c2;h1;w1;d0,16;",*3 ;DATE
L20 W *2,"F5;H20;o50,450;f1;c2;h1;w1;d0,14;",*3 ;TUBE
L21 W *2,"F5;H21;o75,450;f1;c2;h2;w1;d0,21;",*3 ;NAME
L22 W *2,"F5;H22;o105,450;f1;c2;h1;w1;d0,7;",*3 ;HRCN
L23 W *2,"F5;H23;o105,350;f1;c2;h1;w1;d0,14;",*3 ;DOB
L24 W *2,"F5;H24;o133,280;f1;c2;h1;w1;d0,9;",*3 ;LOCATION
L25 W *2,"F5;H25;o133,450;f1;c2;h1;w1;d0,13;",*3 ;ORDER#
L26 W *2,"F5;H26;o150,450;f1;c2;h1;w1;d0,22;",*3 ;TESTS
L27 W *2,"F5;H27;o170,240;f1;c0;h3;w3;b1;d0,4;",*3 ;STAT
L28 W *2,"F5;H28;o0,700;f1;c2;h2;w1;d0,14;",*3 ;1-SMALL LABEL/ACC#
L29 W *2,"F5;H29;o35,700;f1;c2;h1;w1;d0,16;",*3 ;1-SMALL LABEL/DATE
L30 W *2,"F5;H30;o90,700;f1;c2;h2;w1;d0,14;",*3 ; 1-LL LABEL/ACC#
L31 W *2,"F5;H31;o133,700;f1;c2;h1;w1;d0,20;",*3 ;1-LL LABEL/NAME
L32 W *2,"F5;H32;o150,700;f1;c2;h1;w1;d0,7;",*3 ;1-LL LABEL/HRCN
L33 W *2,"F5;H33;o166,700;f1;c2;h1;w1;d0,7;",*3 ;1-LL LABEL/LOCATION
L34 W *2,"F5;H34;o181,700;f1;c2;h1;w1;d0,16;",*3 ;1-LL LABEL/DATE
L35 W *2,"F5;H35;o200,700;f1;c2;h1;w1;d0,13;",*3 ;1-LL LABEL/TEST
 W *2,"R",*3 ;Terminate programming function, returns to print mode.
 Q
TEST ;sets variables used with the test labels
 S NUMBER="00087",LRAN="CH 1008 87",LRDAT="10/08/1998 18:00" D
 .S LRTOP="MARBLED RED",PNM="YOKUM,HOKUM",HRCN="1234567"
 .S DOB="10/30/1955"
 .S LRLLOC="SICU",LRCE="203987",LRTXT="CHEM 7",LRURG="STAT"
 .;S LRACCAP="SURG 1008 999",LRSPEC="WOUND TISSUE"
F5 ;prints sample of label with accession # barcoded
 S X=0 X ^%ZOSF("RM")
 W *2,*27,"E4",*24,LRAN,!,LRDAT,!,LRTOP,*3
 W *2,!,PNM,!,HRCN,!,"W:",LRLLOC,*3
 W *2,!,NUMBER,!,"Order#:",LRCE,!,LRTXT,*3
 W *2,! W:$D(LRURG)&(LRURG="STAT") LRURG W *3
 W *2,!,LRAN,!,LRDAT,*3
 W *2,!,LRAN,*3
 W *2,!,PNM,!,HRCN,!,LRLLOC,!,LRDAT,!,LRTXT,*3
 W *2,*23,*15,"S30",*3
 W *2,*27,"E5",*24,!,LRAN,!,LRDAT,!,LRTOP,*3
 W *2,!,PNM,!,HRCN,!,DOB,!,"W:",LRLLOC,*3
 W *2,!,"Order#:",LRCE,!,LRTXT,*3
 W *2,! W:$D(LRURG)&(LRURG="STAT") LRURG W *3
 W *2,!,LRAN,!,LRDAT,*3
 W *2,!,LRAN,*3
 W *2,!,PNM,!,HRCN,!,LRLLOC,!,LRDAT,!,LRTXT,*3
 W *2,*23,*15,"S30",*3
 Q
