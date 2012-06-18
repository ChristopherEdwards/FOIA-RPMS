BDGSTAT1 ; IHS/ANMC/LJF - AVERAGE DAILY PATIENT LOAD ; 
 ;;5.3;PIMS;;APR 26, 2002
 ;
 ;
SELECT ; -- have user select report by ward or by service
 NEW BDGFRM,BDGBD,BDGED,BDGIA
 S BDGFRM=$$READ^BDGF("SO^1:By Ward;2:By Service","Select Format")
 Q:BDGFRM<1
 S BDGIA=$$READ^BDGF("Y","Include INACTIVE "_$S(BDGFRM=1:"Wards",1:"Services"),"NO")
 ;
 S BDGBD=$$READ^BDGF("DO^::EX","Select Beginning Date") Q:BDGBD<1
 S BDGED=$$READ^BDGF("DO^::EX","Select Ending Date") Q:BDGED<1
 ;
 ;
 D ZIS^BDGF("PQ","EN^BDGSTAT1","ADPL REPORT","BDGFRM;BDGBD;BDGED;BDGIA")
 Q
 ;
 ;
EN ;EP; entry point from queuing
 I $E(IOST,1,2)="P-" D INIT,PRINT Q
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BDG STAT ADPL"_BDGFRM)
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 NEW X
 S X="For "_$$FMTE^XLFDT(BDGBD)_" through "_$$FMTE^XLFDT(BDGED)
 S VALMHDR(1)=$$SP(75-$L(X)\2)_X
 Q
 ;
INIT ; -- init variables and list array
 NEW BDGDAYS
 K ^TMP("BDGSTAT1",$J)
 S VALMCNT=0
 S BDGDAYS=$$FMDIFF^XLFDT(BDGED,BDGBD)+1   ;# of days in date range
 ;
 D @BDGFRM         ;gather ward or service stats for date range
 ;
 I '$D(^TMP("BDGSTAT1",$J)) D SET("No data found",.VALMCNT)
 ;
 Q
 ;
1 ; step thru ADT Census-Ward file for date range
 NEW WARD,WRDNM,DATE,BDGA,X,LINE,TOTAL
 S WARD=0
 F  S WARD=$O(^BDGCWD(WARD)) Q:'WARD  D
 . I BDGIA=0,'$D(^BDGWD(WARD)) Q          ;old ward, no longer used
 . I BDGIA=0,$$GET1^DIQ(9009016.5,WARD,.03)="INACTIVE" Q
 . S WRDNM=$$GET1^DIQ(42,WARD,.01)        ;ward name
 . ;
 . S DATE=BDGBD-.001
 . F  S DATE=$O(^BDGCWD(WARD,1,DATE)) Q:DATE>BDGED  Q:'DATE  D
 .. ; count patients remaining and one day patients
 .. S X=$P($G(^BDGCWD(WARD,1,DATE,0)),U,2)+$P($G(^(0)),U,8)
 .. ; increment array for total inpatient days
 .. S BDGA(WRDNM)=$G(BDGA(WRDNM))+X
 ;
 ; put sorted data into display array
 S WARD=0 F  S WARD=$O(BDGA(WARD)) Q:WARD=""  D
 . S LINE=$$PAD(WARD,40)_$J(BDGA(WARD),5)
 . S LINE=$$PAD(LINE,65)_$J(BDGA(WARD)/BDGDAYS,5,2)
 . D SET(LINE,.VALMCNT)
 . ;
 . ; increment totals
 . S TOTAL=$G(TOTAL)+BDGA(WARD)
 ;
 ; put totals line into display array
 I $G(TOTAL) D
 . S LINE=$$PAD($$PAD("TOTALS",40)_$J(TOTAL,5),65)_$J(TOTAL/BDGDAYS,5,2)
 . D SET($$REPEAT^XLFSTR("=",80),.VALMCNT),SET(LINE,.VALMCNT)
 Q
 ;
2 ; step thru ADT Census-Treating Specialty file by date
 NEW SRV,DATE,SRVNM,BDGA,X,LINE,TOTAL,SUBTOT
 S SRV=0
 F  S SRV=$O(^BDGCTX(SRV)) Q:'SRV  D
 . ;
 . ; quit if not including inactive services; check begin & end dates
 . I BDGIA=0,('$$ACTSRV^BDGPAR(SRV,BDGBD)),('$$ACTSRV^BDGPAR(SRV,BDGED)) Q
 . S SRVNM=$$GET1^DIQ(45.7,SRV,.01)           ;service name
 . ;
 . S DATE=BDGBD-.001
 . F  S DATE=$O(^BDGCTX(SRV,1,DATE)) Q:DATE>BDGED  Q:'DATE  D
 .. ;
 .. ; count patients remaining and one day patients
 .. S X=$G(^BDGCTX(SRV,1,DATE,0))
 .. ;
 .. ; increment by adult vs. peds for total inpt days
 .. S BDGA(SRVNM,"A")=$G(BDGA(SRVNM,"A"))+$P(X,U,2)+$P(X,U,8)
 .. S BDGA(SRVNM,"P")=$G(BDGA(SRVNM,"P"))+$P(X,U,12)+$P(X,U,18)
 ;
 ; put sorted data into display array
 S SRV=0 F  S SRV=$O(BDGA(SRV)) Q:SRV=""  D
 . S LINE=$$PAD(SRV,35)_$J(+$G(BDGA(SRV,"A")),5)     ;adult inpt days
 . S LINE=$$PAD(LINE,45)_$J(+$G(BDGA(SRV,"P")),5)    ;peds inpt days
 . S SUBTOT=$G(BDGA(SRV,"A"))+$G(BDGA(SRV,"P"))      ;total inpt days
 . S LINE=$$PAD($$PAD(LINE,55)_$J(SUBTOT,5),70)_$J(SUBTOT/BDGDAYS,5,2)
 . D SET(LINE,.VALMCNT)
 . ;
 . ; increment totals
 . S TOTAL("A")=$G(TOTAL("A"))+$G(BDGA(SRV,"A"))
 . S TOTAL("P")=$G(TOTAL("P"))+$G(BDGA(SRV,"P"))
 . S TOTAL=$G(TOTAL)+SUBTOT
 ;
 ; put totals line into display array
 S LINE=$$PAD("TOTALS",35)_$J(+$G(TOTAL("A")),5)     ;adult
 S LINE=$$PAD(LINE,45)_$J(+$G(TOTAL("P")),5)         ;peds
 S LINE=$$PAD(LINE,55)_$J($G(TOTAL),5)               ;total
 S LINE=$$PAD(LINE,70)_$J($G(TOTAL)/BDGDAYS,5,2)     ;adpl
 D SET($$REPEAT^XLFSTR("=",80),.VALMCNT),SET(LINE,.VALMCNT)
 Q
 ;
SET(DATA,NUM) ; put data line into display array
 S NUM=NUM+1
 S ^TMP("BDGSTAT1",$J,NUM,0)=DATA
 Q
 ;
PRINT ; print report to paper
 NEW BDGLN,BDGPG
 U IO D INIT^BDGF,HDG
 S BDGLN=0
 F  S BDGLN=$O(^TMP("BDGSTAT1",$J,BDGLN)) Q:'BDGLN  D
 . I $Y>(IOSL-4) D HDG
 . W !,^TMP("BDGSTAT1",$J,BDGLN,0)
 D ^%ZISC,PRTKL^BDGF,EXIT
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 Q
 ;
EXPND ; -- expand code
 Q
 ;
 ;
HDG ; print heading on paper
 S BDGPG=$G(BDGPG)+1 I BDGPG>1 W @IOF
 NEW X
 S X="AVERAGE DAILY PATIENT LOAD by "_$S(BDGFRM=1:"WARD",1:"SERVICE")
 W !,BDGTIME,?80-$L(X)/2,X,?71,"Page: ",BDGPG
 S X="For "_$$FMTE^XLFDT(BDGBD)_" through "_$$FMTE^XLFDT(BDGED)
 W !,BDGDATE,?(80-$L(X)\2),X,?76,BDGUSR
 W !,$$REPEAT^XLFSTR("-",80)
 I BDGFRM=1 W !,"Ward",?40,"Patient Days",?65,"ADPL"
 I BDGFRM=2 W !,"Service",?25,"Pat. Days:  Adult",?45,"Peds",?55,"Total",?70,"ADPL"
 W !,$$REPEAT^XLFSTR("=",80)
 Q
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
