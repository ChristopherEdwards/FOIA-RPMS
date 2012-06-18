BLRVPTCH ; IHS/OIT/MKK - LAB VERSION & LATEST PATCH REPORT ;DEC 09, 2008 8:30 AM
 ;;5.2;IHS LABORATORY;**1025**;NOV 01, 1997
 ;
 ; Show latest Lab Patch & Lab Version
 ;
EP ; EP
 NEW HEADER,INSTALLN,INSTLLDT,LABPATCH,LABVER,STATUS
 ;
 S HEADER(1)="IHS LAB Package"
 S HEADER(2)="Current VERSION & PATCH Report"
 ;
 D LATEST(.LABPATCH,.INSTALLN)     ; Latest IHS Lab Patch & Install IEN
 ;
 S LABVER=$P(LABPATCH,"*",2)                      ; Version Number
 ;
 S INSTLLDT=$P($G(^XPD(9.7,INSTALLN,0)),"^",3)    ; Latest Patch Install Date
 S INSTLLDT=$$UP^XLFSTR($$FMTE^XLFDT(INSTLLDT,"MP"))
 ;
 D HEADERDT^BLRGMENU
 ;
 W $$CJ^XLFSTR("Lab Version "_LABVER,IOM)
 W !!
 W $$CJ^XLFSTR("Latest IHS Lab Patch: "_LABPATCH,IOM)
 W !!
 W $$CJ^XLFSTR("Latest IHS Lab Patch Install Date/Time: "_INSTLLDT,IOM)
 W !
 ;
 D PRESSKEY^BLRGMENU(0)
 Q
 ;
 ; This is necessary because Kernel DOES NOT return the proper
 ; Install IF there were multiple installs in one day.
LATEST(LABPATCH,INSTALLN) ; EP
 NEW LRP,LRPIN,LROKAY
 ;
 S LRP="LR*5.2*1000"
 S LROKAY=""
 F  S LRP=$O(^XPD(9.7,"B",LRP))  Q:LRP=""!($P(LRP,"*",1)'="LR")  D
 . S LRPIN=0
 . F  S LRPIN=$O(^XPD(9.7,"B",LRP,LRPIN))  Q:LRPIN=""  D
 .. I $P($G(^XPD(9.7,LRPIN,0)),"^",9)'=3 Q  ; Complete Status?
 .. ;
 .. I +$P(LRP,"*",3)>+$P($P(LROKAY,"^",1),"*",3) S LROKAY=LRP_"^"_LRPIN
 ;
 S LABPATCH=$P(LROKAY,"^",1)
 S INSTALLN=$P(LROKAY,"^",2)
 ;
 Q
