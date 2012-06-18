BDGCEN32 ; IHS/ANMC/LJF - CENSUS WARD LIST-SUMMARY ; 
 ;;5.3;PIMS;;APR 26, 2002
 ;
 ;
 NEW LINE,DGWN,DGWD,UNDER
 S UNDER=$$REPEAT^XLFSTR("_",6)    ;underline of 6 spaces
 ;
 S LINE="<<< SUMMARY PAGE >>>"
 D SET($$SP(75-$L(LINE)\2)_$G(IORVON)_LINE_$G(IORVOFF),.VALMCNT)
 S LINE=$$PAD("Ward",16)_"Beg Census  Admits  Net Transfers  Discharges  Ending Census"
 D SET($$REPEAT^XLFSTR("=",80),.VALMCNT)
 D SET(LINE,.VALMCNT)
 D SET($$REPEAT^XLFSTR("-",80),.VALMCNT)
 ;
 ; loop through active wards by name
 S DGWN=0
 F  S DGWN=$O(^DIC(42,"B",DGWN)) Q:DGWN=""  D
 . S DGWD=0 F  S DGWD=$O(^DIC(42,"B",DGWN,DGWD)) Q:'DGWD  D
 .. I '$D(^BDGWD(DGWD)) Q                         ;deleted ward
 .. I $$GET1^DIQ(9009016.5,DGWD,.03)="INACTIVE" Q  ;inactive
 .. ;
 .. ; for each ward, list changes
 .. S LINE=$$PAD(DGWN,16)_UNDER_"  +"
 .. S LINE=$$PAD(LINE,30)_(+$G(BDGSUB(DGWN,"A")))        ;admits
 .. S LINE=$$PAD(LINE,42)_(+$G(BDGSUB(DGWN,"T")))        ;net transfers
 .. S LINE=$$PAD($$PAD(LINE,49)_"-",55)_(+$G(BDGSUB(DGWN,"D")))  ;dsch
 .. S LINE=$$PAD(LINE,65)_UNDER
 .. D SET(LINE,.VALMCNT),SET("",.VALMCNT)
 .. ;
 .. ; increment totals for whole facility
 .. S BDGTOT("A")=$G(BDGTOT("A"))+$G(BDGSUB(DGWN,"A"))
 .. S BDGTOT("T")=$G(BDGTOT("T"))+$G(BDGSUB(DGWN,"T"))
 .. S BDGTOT("D")=$G(BDGTOT("D"))+$G(BDGSUB(DGWN,"D"))
 ;
 D SET($$REPEAT^XLFSTR("=",80),.VALMCNT)
 S LINE=$$PAD("TOTALS:",16)_UNDER_"  +"
 S LINE=$$PAD(LINE,30)_(+$G(BDGTOT("A")))
 S LINE=$$PAD(LINE,42)_(+$G(BDGTOT("T")))
 S LINE=$$PAD($$PAD(LINE,49)_"-",55)_(+$G(BDGTOT("D")))
 S LINE=$$PAD(LINE,63)_"= "_UNDER
 D SET(LINE,.VALMCNT)
 ;
 S LINE=$$PAD("NEWBORNS:",16)_UNDER_"  +"
 S LINE=$$PAD(LINE,30)_(+$G(BDGNB("A")))
 S LINE=$$PAD(LINE,42)_(+$G(BDGNB("T")))
 S LINE=$$PAD($$PAD(LINE,49)_"-",55)_(+$G(BDGNB("D")))
 S LINE=$$PAD(LINE,63)_"+ "_UNDER
 D SET(LINE,.VALMCNT)
 ;
 K BDGTOT,BDGSUB,BDGNB
 Q
 ;
SET(DATA,NUM) ; put display data into array
 S NUM=NUM+1
 S ^TMP("BDGCEN3",$J,NUM,0)=DATA
 Q
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
