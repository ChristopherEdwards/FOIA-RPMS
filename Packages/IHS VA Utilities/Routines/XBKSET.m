XBKSET ; IHS/ADC/GTH - SET MINIMUM KERNEL VARIABLES ; [ 10/29/2002   7:42 AM ]
 ;;3.0;IHS/VA UTILITIES;**9**;FEB 07, 1997
 ;
 ; This routine is for programmers in direct mode only.  It
 ; should not be called within a routine.
 ;
START ;
 D ^XBKVAR
KERNEL ;
 KILL ^XUTL("XQ",$J),^UTILITY($J)
 S %ZIS="L",IOP="HOME"
 D ^%ZIS
 Q:POP
 D SAVE^XUS1 ; IHS/SET/GTH XB*3*9 10/29/2002
 ; F X="DUZ","DUZ(0)","DUZ(2)","IO","IOBS","IOF","ION","IOM","IOS","IOSL","IOST","IOST(0)","IOXY" I $D(@X) S ^XUTL("XQ",$J,X)=@X ; IHS/SET/GTH XB*3*9 10/29/2002
 Q
 ;
