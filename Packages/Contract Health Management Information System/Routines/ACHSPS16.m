ACHSPS16 ; IHS/ITSC/PMF - COMPRESSED PRINTING SETUP ;  [ 10/16/2001   8:16 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 ;
CHK16 ;EP for Compressed print for printer.
 W !?5,"(This report requires 132 Width Printer format)",!
 Q:'$$DIR^XBDIR("Y","Should Output be in CONDENSED PRINT","Y","","(This report requires 132 Width Printer format)","",1)
 K ACHS("PRINT")
 S ACHS("PRINT",16)=$P($G(^%ZIS(2,IOST(0),12.1)),U)
 S ACHS("PRINT",10)=$P($G(^%ZIS(2,IOST(0),5)),U)
 I ACHS("PRINT",16)="" W !,*7,"=== Condensed Print not set for device -- Request Cancelled.  ===" G ERROR
 I ACHS("PRINT",10)="" W !,*7,"=== Standard Print not set for device -- Request Cancelled.  ===" G ERROR
 Q
 ;
10 ;EP - Reset to standard print.
 I $D(^%ZIS(2,IOST(0),5)),$P(^(5),U)'="" S ACHS("PRINT",10)=$P(^(5),U,1) W @ACHS("PRINT",10)
 Q
 ;
ERROR ;
 S ACHS("PRINT","ERROR")=""
 Q
 ;
