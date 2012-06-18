%AUDSET ; BUILDS LIST OF FILEMAN FILES [ 06/05/87  1:23 PM ]
 ;
 ; This routine can be called from another routine by setting the
 ; variables AUDSLO, AUDSHI and then D EN1^%AUDSET.
 ;
 W !!,"This program selects FileMan dictionaries.",!
 K ^UTILITY("AUDSET",$J)
 ;
LO R !,"Enter first dictionary number to be selected: ",AUDSLO G:AUDSLO'=+AUDSLO EOJ
HI W !,"Enter last dictionary number to  be selected: ",AUDSLO,"// " R AUDSHI S:AUDSHI="" AUDSHI=AUDSLO G:AUDSHI'=+AUDSHI!(AUDSHI<AUDSLO) EOJ
 ;
EN1 ;
 K ^UTILITY("AUDSET",$J)
 I '$D(AUDSLO)!('$D(AUDSHI)) W !!,"AUDSLO and/or AUDSHI does not exist!" G EOJ
 S AUDSFILE=(AUDSLO-.00000001) F AUDSL=0:0 S AUDSFILE=$O(^DIC(AUDSFILE)) Q:AUDSFILE>AUDSHI!(AUDSFILE'=+AUDSFILE)  S ^UTILITY("AUDSET",$J,AUDSFILE)=""
 ;
EOJ ;
 K AUDSLO,AUDSHI,AUDSL,AUDSFILE
 Q
