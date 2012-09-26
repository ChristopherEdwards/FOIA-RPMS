PSGWINI5 ; ; 04-JAN-1994
 ;;2.3; Automatic Replenishment/Ward Stock ;;4 JAN 94
 K ^UTILITY("DIF",$J) S DIFRDIFI=1 F I=1:1:20 S ^UTILITY("DIF",$J,DIFRDIFI)=$T(IXF+I),DIFRDIFI=DIFRDIFI+1
 Q
IXF ;;AUTO REPLENISHMENT/WARD STOCK^PSGW
 ;;50I;DRUG;^PSDRUG(;1;y;n;;y;;;n;;y
 ;;
 ;;58.1I;PHARMACY AOU STOCK;^PSI(58.1,;0;y;n;;y;;;n;;y
 ;;
 ;;58.16;AOU INVENTORY TYPE;^PSI(58.16,;0;y;n;;y;;;n;;y
 ;;
 ;;58.17I;AOU ITEM LOCATION;^PSI(58.17,;0;y;n;;y;;;n;;y
 ;;
 ;;58.19ID;PHARMACY AOU INVENTORY;^PSI(58.19,;0;y;n;;y;;;n;;y
 ;;
 ;;58.2;AOU INVENTORY GROUP;^PSI(58.2,;0;y;n;;y;;;n;;y
 ;;
 ;;58.3P;PHARMACY BACKORDER;^PSI(58.3,;0;y;n;;y;;;n;;y
 ;;
 ;;58.5D;AR/WS STATS FILE;^PSI(58.5,;0;y;n;;y;;;n;;y
 ;;
 ;;59.4;INPATIENT SITE;^PS(59.4,;1;y;n;;y;;;n;;y
 ;;
 ;;59.7;PHARMACY SYSTEM;^PS(59.7,;1;y;y;;y;;;n;;y
 ;;
