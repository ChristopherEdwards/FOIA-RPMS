BLRBARB ; IHS/DIR/FJE - INTERMEC 4100 10 PART LABEL FORMAT 12:36 ; [ 03/18/1999  6:51 AM ]
 ;;5.2;LR;**1006,1007**;MAR 1, 1999
 ;;5.2;LR;;NOV 01, 1997
 ;;5.2;LAB SERVICE;;Sep 27, 1994
 ;This routine will program the Intermec 4100 for a 10 part 2.5X4.0 in
 ;label which can be used with LRLABELB routine to print a 10 part
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
 S ZTIO=ION,ZTDTH=$H,ZTDESC="BAR CODE FORMAT DOWN LOAD",ZTRTN="BAR^LRBARB" D ^%ZTLOAD Q
BAR ;FORMAT BAR CODE LABELS
 S X=0 X ^%ZOSF("RM") W *2,*27,"P",*3 ;SET INTO PROGRAM MODE
 W *2,"E4;F4;",*3 ;ERASES FORMAT STORED IN FORMAT 4 AND ACCESSES FORMAT 4
L0 W *2,"F4;H0;o0,166;f1;c2;h2;w1;d0,14;",*3 ;ACC#
L1 W *2,"F4;H1;o35,183;f1;c2;h1;w1;d0,17;",*3 ;DATEIHS/FJE 3/18/99
L2 W *2,"F4;H2;o89,140;f0;c2;h1;w1;d0,14;",*3 ;TUBE
L3 W *2,"F4;H3;o89,1;f0;c2;h2;w1;d0,21;",*3 ;NAME
L4 ;W *2,"F4;H4;o89,37;f0;c2;h1;w1;d0,11;",*3 ;SSN
 W *2,"F4;H4;o89,37;f0;c2;h1;w1;d0,7;",*3 ;HRCN
L5 W *2,"F4;H5;o260,37;f0;c2;h1;w1;d0,9;",*3 ;LOCATION
L6 W *2,"F4;B6;o93,59;f0;c0,0;h60;w2;d0,5;",*3 ;BARCODE
L7 W *2,"F4;H7;o89,125;f0;c2;h1;w1;d0,13;",*3 ;ORDER#
L8 W *2,"F4;H8;o89,157;f0;c2;h2;w1;d0,22;",*3 ;TESTS
L9 W *2,"F4;H9;o278,133;f0;c0;h2;w3;b1;d0,4;",*3 ;STAT
L10 W *2,"F4;H10;o6,219;f0;c2;h2;w1;d0,14;",*3 ;1-SMALL LABEL/ACC#
L11 W *2,"F4;H11;o6,267;f0;c2;h1;w1;d0,14;",*3 ;1-SMALL LABEL/TOP
L12 W *2,"F4;H12;o6,311;f0;c2;h2;w1;d0,14;",*3 ; 1-LL LABEL/ACC#
L13 W *2,"F4;H13;o6,345;f0;c2;h2;w1;d0,20;",*3 ;1-LL LABEL/NAME
L14 W *2,"F4;H14;o6,380;f0;c2;h1;w1;d0,7;",*3 ;1-LL LABEL/HRCN
L15 W *2,"F4;H15;o6,406;f0;c2;h1;w1;d0,17;",*3 ;1-LL LABEL/DATE IHS/FJE 3/18/99
L16 W *2,"F4;H16;o6,438;f0;c2;h2;w1;d0,13;",*3 ;1-LL LABEL/TEST
L17 W *2,"F4;H17;o202,219;f0;c2;h2;w1;d0,14;",*3 ;2-ML/ACC#
L18 W *2,"F4;H18;o202,267;f0;c2;h1;w1;d0,14;",*3 ;2-ML/TOP
L19 W *2,"F4;H19;o202,311;f0;c2;h2;w1;d0,14;",*3 ;2-LL LABEL ACC#
L20 W *2,"F4;H20;o202,345;f0;c2;h2;w1;d0,20;",*3 ;2-LL LABEL/NAME
L21 W *2,"F4;H21;o202,380;f0;c2;h1;w1;d0,7;",*3 ;2-LL LABEL/HRCN
L22 W *2,"F4;H22;o202,406;f0;c2;h1;w1;d0,14;",*3 ;2-LL LABEL/DATE
L23 W *2,"F4;H23;o202,438;f0;c2;h2;w1;d0,13;",*3 ;2-LL LABEL/TEST
L24 W *2,"F4;H24;o390,1;f0;c2;h2;w1;d0,14;",*3 ;2-TR LABEL/ACC#
L25 W *2,"F4;H25;o390,35;f0;c2;h1;w1;d0,14;",*3 ;2-TR LABEL/DATE
L26 W *2,"F4;H26;o390,55;f0;c2;h1;w1;d0,30;",*3 ;2-TR LABEL/TUBE
L27 W *2,"F4;H27;o475,79;f0;c2;h2;w1;d0,21;",*3 ;2-TR LABEL/NAME
L28 W *2,"F4;H28;o475,110;f0;c2;h1;w1;d0,7;",*3 ;2-TR LABEL/HRCN
L29 W *2,"F4;H29;o655,133;f0;c2;h1;w1;d0,9;",*3 ;2-TR LABEL/LOCATION
L30 W *2,"F4;H30;o390,133;f0;c2;h1;w1;d0,13;",*3 ;2-TR LABEL/OR#
L31 W *2,"F4;H31;o390,157;f0;c2;h2;w1;d0,22;",*3 ;2-TR LABEL/TEST
L32 W *2,"F4;H32;o668,35;f0;c0;h3;w3;b1;d0,4;",*3 ;2-TR LABEL/STAT
L33 W *2,"F4;H33;o405,219;f0;c2;h2;w1;d0,14;",*3 ;3-MR LABEL/ACC#
L34 W *2,"F4;H34;o405,267;f0;c2;h1;w1;d0,14;",*3 ;3-MR LABEL/TOP
L35 W *2,"F4;H35;o405,311;f0;c2;h2;w1;d0,14;",*3 ;3-BR LABEL/ACC#
L36 W *2,"F4;H36;o405,345;f0;c2;h2;w1;d0,20;",*3 ;3-BR LABEL/NAME
L37 W *2,"F4;H37;o405,380;f0;c2;h1;w1;d0,7;",*3 ;3-BR LABEL/HRCN
L38 W *2,"F4;H38;o405,406;f0;c2;h1;w1;d0,17;",*3 ;3-BR LABEL/DATE IHS/FJE 3/18/99
L39 W *2,"F4;H39;o405,438;f0;c2;h2;w1;d0,13;",*3 ;3-BR LABEL/TEST
L40 W *2,"F4;H40;o605,219;f0;c2;h2;w1;d0,14;",*3 ;4-MR LABEL/ACC#
L41 W *2,"F4;H41;o605,267;f0;c2;h1;w1;d0,14;",*3 ;4-MR LABEL/TOP
L42 W *2,"F4;H42;o605,311;f0;c2;h2;w1;d0,14;",*3 ;3-BR LABEL/ACC#
L43 W *2,"F4;H43;o605,345;f0;c2;h2;w1;d0,20;",*3 ;3-BR LABEL/NAME
L44 ;W *2,"F4;H44;o605,380;f0;c2;h1;w1;d0,11;",*3 ;3-BR LABEL/SSN
 W *2,"F4;H44;o605,380;f0;c2;h1;w1;d0,7;",*3 ;3-BR LABEL/HRCN
L45 W *2,"F4;H45;o605,406;f0;c2;h1;w1;d0,17;",*3 ;3-BR LABEL/DATE IHS/FJE 3/18/99
L46 W *2,"F4;H46;o605,438;f0;c2;h2;w1;d0,13;",*3 ;3-BR LABEL/TEST
 W *2,"R",*3 ;Terminate programming function, returns to print mode.
 Q
