BDGILD62 ; IHS/ANMC/LJF - TRANSFERS BETWEEN FACILITIES(PRINT) ; 
 ;;5.3;PIMS;;APR 26, 2002
 ;
 I BDGTYP>1 D STAT
 I BDGTYP'=2 D LISTS
 Q
 ;
STAT ; gather stats by facility
 NEW FAC,SRV,LINE,BDGTI,BDGTO
 S (BDGTI,BDGTO)=0  ;zero out totals
 S FAC=0 F  S FAC=$O(DGCT(FAC)) Q:FAC=""  D
 . S LINE=$E(FAC,1,24)       ;print facility
 . S SRV=0 F  S SRV=$O(DGCT(FAC,SRV)) Q:SRV=""  D
 .. S LINE=$$PAD(LINE,26)_SRV       ; service
 .. ; print transfer counts and increment totals
 .. S LINE=$$PAD(LINE,55)_$J($P(DGCT(FAC,SRV),U),3)
 .. S BDGTI=BDGTI+$P(DGCT(FAC,SRV),U)
 .. S LINE=$$PAD(LINE,70)_$J($P(DGCT(FAC,SRV),U,2),3)
 .. S BDGTO=BDGTO+$P(DGCT(FAC,SRV),U,2)
 .. D SET(LINE,.VALMCNT) S LINE=""
 ;
 ; gather transfer totals
 D SET($$REPEAT^XLFSTR("-",80),.VALMCNT)
 S LINE=$$PAD($$PAD($$SP(30)_"TOTALS:",55)_$J(BDGTI,3),70)_$J(BDGTO,3)
 D SET(LINE,.VALMCNT),SET("",.VALMCNT)
 Q
 ;
LISTS ; gather patient lists
 NEW DATE,SRV,FAC,IEN,DFN
 ;
 ; admissions by date, service, then facility
 D SET($$SP(30)_"ADMISSIONS",.VALMCNT)
 S DATE=0 F  S DATE=$O(^TMP("BDGILD6A",$J,DATE)) Q:DATE=""  D
 . S SRV=0 F  S SRV=$O(^TMP("BDGILD6A",$J,DATE,SRV)) Q:SRV=""  D
 .. S FAC=0 F  S FAC=$O(^TMP("BDGILD6A",$J,DATE,SRV,FAC)) Q:FAC=""  D
 ... S IEN=0
 ... F  S IEN=$O(^TMP("BDGILD6A",$J,DATE,SRV,FAC,IEN)) Q:'IEN  D
 .... S DFN=^TMP("BDGILD6A",$J,DATE,SRV,FAC,IEN)
 .... D LINE
 ;
 ; discharges by date, service, then facility
 D SET("",.VALMCNT),SET($$SP(30)_"DISCHARGES",.VALMCNT)
 S DATE=0 F  S DATE=$O(^TMP("BDGILD6D",$J,DATE)) Q:DATE=""  D
 . S SRV=0 F  S SRV=$O(^TMP("BDGILD6D",$J,DATE,SRV)) Q:SRV=""  D
 .. S FAC=0 F  S FAC=$O(^TMP("BDGILD6D",$J,DATE,SRV,FAC)) Q:FAC=""  D
 ... S IEN=0
 ... F  S IEN=$O(^TMP("BDGILD6D",$J,DATE,SRV,FAC,IEN)) Q:'IEN  D
 .... S DFN=^TMP("BDGILD6D",$J,DATE,SRV,FAC,IEN)
 .... D LINE
 ;
 K ^TMP("BDGILD6A",$J),^TMP("BDGILD6D",$J)
 Q
 ;
LINE ; build patient data line
 S LINE=$$PAD($$NUMDATE^BDGF(DATE),17)_$E($$GET1^DIQ(2,DFN,.01),1,20)
 S LINE=$$PAD(LINE,40)_$J($$HRCN^BDGF2(DFN,DUZ(2)),6)
 S LINE=$$PAD($$PAD(LINE,52)_SRV,60)_$E(FAC,1,18)
 D SET(LINE,.VALMCNT)
 Q
 ;
SET(DATA,NUM) ; put display line into array
 S NUM=NUM+1
 S ^TMP("BDGILD6",$J,NUM,0)=DATA
 Q
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
