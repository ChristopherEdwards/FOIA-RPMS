AZANWRN ; IHS/PHXAO/TMJ - Medicaid Warning Message ; [ 02/03/03  11:55 AM ]
 ;1.9;AZAM ANMC Medicaid Utilities;June 21,1994
 ;
MAIN ; -- main warning driver    
 D SET,ON,WARN,OFF
 Q
 ;
SET ; -- set up reverse video on,off
 D CURRENT^%ZIS
 S AZAM=$O(^%ZIS(1,"C",$I,0))
 Q:^%ZIS(1,AZAM,"TYPE")'="TRM"
 Q:'$D(^%ZIS(2,^%ZIS(1,AZAM,"SUBTYPE"),5))
 S AZAMSUB=+^%ZIS(1,AZAM,"SUBTYPE")
 S AZAMON=$P(^%ZIS(2,AZAMSUB,5),U,4),AZAMOFF=$P(^%ZIS(2,AZAMSUB,5),U,5)
 Q    
 ;
ON ; -- turn reverse video on
 I $D(AZAMSUB) W @AZAMON
 Q
 ;
WARN ; -- display warning
 W @IOF,"WARNING:  MAKE SURE YOU HAVE BEEN NOTIFIED THAT THE MOST "
 W "CURRENT MEDICAID"
 W !,?10,"FILE IS READY FOR USE, PLEASE CALL THE PHOENIX AREA BUSINESS OFFICE !!!!"
 Q
 ;
OFF ; -- turn reverse video off
 I $D(AZAMSUB) W @AZAMOFF
 Q
