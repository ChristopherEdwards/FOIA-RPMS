ZIBVKCA ; IHS/ADC/GTH - KILL VARIABLES ; [ 10/29/2002   7:42 AM ]
 ;;3.0;IHS/VA UTILITIES;**9**;FEB 07, 1997
 ; XB*3*9 IHS/SET/GTH XB*3*9 10/29/2002
 ; 
 ; This routine kills variables in the namespace of the
 ; variable passed in the parameter.
 ; This routine is accessed thru the front end routine XBVK.
 ;
 ; Original routine provided by Dr. Mark Delaney, TASSC, 12 Dec 2001.
 ; 
 Q  ;        No entry from top
 ;
EN(ZIBVKNS) ;EP - KILL Local variables in the passed namespace.
 ;
 Q:$G(ZIBVKNS)=""
 NEW ZIBVKX
 S ZIBVKX=ZIBVKNS K @ZIBVKNS
 F  S ZIBVKX=$O(@ZIBVKX) Q:ZIBVKX=""  Q:$E(ZIBVKX,1,$L(ZIBVKNS))]ZIBVKNS  I $E(ZIBVKX,1,$L(ZIBVKNS))=ZIBVKNS,ZIBVKX'["ZIBVK" K @ZIBVKX
 Q
 ;
