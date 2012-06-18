BLRLUAC9 ; IHS/OIT/MKK - IHS LRUPAC 9, I/O routines ; [ 05/15/11  7:50 AM ]
 ;;5.2;LR;**1030**;NOV 01, 1997
 ;
 ; I/O Setup for Reports
 ;
OPENIO(MAXLINES,LINES) ; EP
 D ^%ZIS
 I POP D  Q
 . W !,?4,"Could not open device.  Will print to the screen.",!
 . D PRESSKEY^BLRGMENU(9)
 U IO
 S MAXLINES=IOSL-3,LINES=MAXLINES+10
 Q
 ;
CLOSEIO ; EP
 D ^%ZISC
 Q
