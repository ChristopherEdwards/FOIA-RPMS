ZIBVKMSM ; IHS/ADC/GTH - KILL VARIABLES ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 ; This routine kills variables in the namespace of the
 ; variable passed in the parameter.
 ; This routine is accessed thru the front end routine XBVK.
 ;
 ; Original routine provided by Don Enos, OHPRD, 2 Oct 1995.
 ;
 Q  ;        No entry from top
 ;
EN(ZIBVKNS) ;EP - KILL Local variables in the passed namespace.
 ;
 Q:$G(ZIBVKNS)=""
 NEW ZIBVKX
 S ZIBVKX=$O(@ZIBVKNS,-1)
 S:ZIBVKX="" ZIBVKX="%"
 K:ZIBVKNS="%" @ZIBVKNS
 F  S ZIBVKX=$O(@ZIBVKX) Q:ZIBVKX=""  Q:$E(ZIBVKX,1,$L(ZIBVKNS))]ZIBVKNS  I $E(ZIBVKX,1,$L(ZIBVKNS))=ZIBVKNS,ZIBVKX'["ZIBVK" K @ZIBVKX
 Q
 ;
