ZU ;GFT/SF ; 01OCT84 16:58 ;TIE ALL TERMINALS EXCEPT CONSOLE TO THIS ROUTINE!! [ 01/14/86  9:27 AM ]
 ;4.1
 W !,"DEVICE ",$I,!
 S $ZT="ERR^ZU" G ^XUS ;  $ZE if you're running M/11
 ;
ERR ;
 G:$E($ZE,1,7)="<INRPT>" CTLC
 W !!,*7,"An error has occurred.  Please notify your supervisor.",!!
 D ^%ET D H^XUS G ^XUS
 ;
CTLC ;
 U 0 W !,"-- INTERRUPT ACKNOWLEDGED",!
 S Y=^UTILITY("XQ",$J,^UTILITY("XQ",$J,"T")),Y(0)=$P(Y,"^",2,99),Y=$P(Y,"^",1)
 S $ZT="ERR^ZU"
 G M1^XQ
