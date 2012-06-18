BDGIPL3 ; IHS/ANMC/LJF - CURR INPTS BY WARD/ROOM ; 
 ;;5.3;PIMS;**1007**;FEB 27, 2007
 ;
 ;cmi/anch/maw 2/21/2007 added code to INIT to not print a page break if BDGONE is there from user questions PATCH 1007 item 1007.38
 ;cmi/anch/maw 2/22/2007 added code in PRINT to not close device if multiple copies PATCH 1007 item 1007.39
 ;
 ;
 NEW BDGIOM S BDGIOM=IOM
 I $E(IOST,1,2)="P-" D INIT,PRINT Q
 ;
EN ; -- main entry point for BDG IPL BY WARD/ROOM
 ; assumes BDGSRT and BDGSRT2 are set
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BDG IPL BY WARD/ROOM")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 NEW X
 S VALMHDR(1)=$$SP(12)_"** "_$$CONF^BDGF_" **"
 S X=$S(BDGSRT="A":"For ALL Ward Locations",1:$P(BDGSRT,U,2))
 S VALMHDR(2)=$$SP(75-$L(X)\2)_X
 I BDGSRT2=4 S VALMCAP=$$PAD($$PAD($$PAD($$PAD($$PAD($$SP(5)_"Room",14)_"Patient Name",34)_"Chart #",44)_"Diagnosis",64)_"Attending",80)
 Q
 ;
INIT ; -- init variables and list array
 NEW BDGWD,BDGWDN,BDGCNT,SRV,NAME,LINE,DFN,ORD,WD,RM
 K ^TMP("BDGIPL",$J),^TMP("BDGIPL1",$J)
 S VALMCNT=0,BDGCNT=1
 D ^BDGIPL31   ;collect wards, rooms and patients
 ;
 ; pull sorted list and create display array
 S ORD=0 F  S ORD=$O(^TMP("BDGIPL1",$J,"BED",ORD)) Q:'ORD  D
 . S WD=0 F  S WD=$O(^TMP("BDGIPL1",$J,"BED",ORD,WD)) Q:WD=""  D
 .. ;
 .. I BDGSRT="A" D  ;display ward subheading
 ... D SET($G(IORVON)_WD_$G(IORVOFF),.VALMCNT,BDGCNT,"")
 ... ;
 ... ; if printer, mark stop to add form feed
 ... ;I $E(IOST,1,2)="P-" D SET("@@@@"_WD,.VALMCNT,BDGCNT,"")  ;cmi/anch/maw 2/21/2007 orig line PATCH 1007 item 1007.38
 ... D SET("@@@@"_WD,.VALMCNT,BDGCNT,"")  ;cmi/anch/maw 2/21/2007 new line to not have a page break for each ward PATCH 1007 item 1007.38
 ... ;I $E(IOST,1,2)="P-",$G(BDGONE) D SET("@@@@"_WD,.VALMCNT,BDGCNT,"")  ;cmi/anch/maw 2/21/2007 new line to not have a page break for each ward PATCH 1007 item 1007.38
 .. ;
 .. S RM=0 F  S RM=$O(^TMP("BDGIPL1",$J,"BED",ORD,WD,RM)) Q:RM=""  D
 ... ;
 ... ; if no patient in room, just print room number
 ... I '$D(^TMP("BDGIPL1",$J,"PAT",WD_";"_RM)) D  Q
 .... D SET($$SP(5)_RM,.VALMCNT,BDGCNT,"")
 .... I BDGSRT2'=4 D SET("",.VALMCNT,BDGCNT,""),DASHES
 ... ;
 ... ; set up patient info lines
 ... S DFN=^TMP("BDGIPL1",$J,"PAT",WD_";"_RM) Q:'DFN
 ... D LINES S BDGCNT=BDGCNT+1
 ... ;
 .. ; if end of ward, print patients without rooms
 .. S DFN=0 F  S DFN=$O(^TMP("BDGIPL1",$J,"PAT",WD_";",DFN)) Q:DFN=""  D
 ... I DFN["P" D PEND Q     ;pending DSO/SDA patients
 ... D LINES S BDGCNT=BDGCNT+1               ;else inpts without rooms
 ;
 K ^TMP("BDGIPL1",$J)
 Q
 ;
LINES ; set up dislay lines for patient
 NEW LINE
 ;
 ; set up line 1
 S LINE=$S($E(IOST,1,2)="P-":$$SP(5),1:$J(BDGCNT,3)_") ")_RM
 S LINE=$$PAD(LINE,14)_$E($$GET1^DIQ(2,DFN,.01),1,18)   ;name
 S LINE=$$PAD(LINE,34)_$$HRCND^BDGF2($$HRCN^BDGF2(DFN,DUZ(2)))
 ;
 I BDGSRT2=4 D  Q   ;only one line in brief listing
 . S LINE=$$PAD(LINE,44)_$E($$CURDX^BDGF1(DFN),1,18)          ;dx
 . S LINE=$$PAD(LINE,64)_$E($$CURPRV^BDGF1(DFN,30),1,15)      ;prov
 . D SET(LINE,.VALMCNT,BDGCNT,DFN)
 ;
 S LINE=$$PAD(LINE,44)_$$GET1^DIQ(9000001,DFN,1102.98)     ;age
 S LINE=$$PAD(LINE,52)_$J($P($$CURLOS^BDGF1(DFN)," "),3)   ;los
 S LINE=$$PAD(LINE,58)_$$LASTCOL(BDGSRT2,DFN)     ;last column data
 D SET(LINE,.VALMCNT,BDGCNT,DFN)
 ;
 Q:BDGSRT2=4    ;only one line if brief listing
 ;
 ; set up line 2
 S LINE=$$SP(6)_$$OBSERV(DFN)   ;obs if observation
 S LINE=$$PAD(LINE,15)_"("_$$CURPRV^BDGF1(DFN,30)_")"         ;provs
 S LINE=$$PAD(LINE,50)_"("_$$GET1^DIQ(9000001,DFN,1118)_")"   ;commun
 I BDGSRT2=3 S LINE=$$PAD(LINE,15)_"("_$$CURDX^BDGF1(DFN)_")"  ;or dx
 D SET(LINE,.VALMCNT,BDGCNT,DFN)
 D DASHES
 Q
 ;
PEND ; display line for pending DSO/SDA patients for ward
 NEW LINE,NODE,PAT
 S PAT=$P(DFN,";",2)                     ;dfn="P"_time_;_dfn
 S NODE=^TMP("BDGIPL1",$J,"PAT",WD_";",DFN)    ;stored data
 S LINE="Schd "_$P(NODE,U,3)                        ;ds status
 S LINE=$$PAD(LINE,14)_$E($P(NODE,U,2),1,18)             ;name
 S LINE=$$PAD(LINE,34)_$$HRCND^BDGF2($$HRCN^BDGF2(PAT,DUZ(2)))
 S LINE=$$PAD(LINE,44)_$$GET1^DIQ(9000001,PAT,1102.98)   ;age
 S LINE=$$PAD(LINE,58)_$P(NODE,U,4)                      ;service
 D SET(LINE,.VALMCNT,BDGCNT-1,DFN)
 ;
 ; set up line 2
 S LINE="  Surg at "_$$TIME^BDGF($P(NODE,U,7))          ;surgery time
 S LINE=$$PAD(LINE,19)_"("_$E($P(NODE,U,6),1,25)_")"     ;surgeon
 S LINE=$$PAD(LINE,46)_$P(NODE,U,5)                      ;procedure
 D SET(LINE,.VALMCNT,BDGCNT-1,DFN)
 D DASHES
 ;
 Q
 ;
SET(LINE,NUM,COUNT,IEN) ; put display line into array
 D SET^BDGIPL1(LINE,.NUM,COUNT,IEN)
 Q
 ;
LASTCOL(X,P) ; returns last column data based on request from user
 I X=3 Q ""                      ;notes column to be left blank
 I X=1 Q $$CURDX^BDGF1(DFN)      ;adm dx for current inpt
 I X=2 Q $$GET1^DIQ(2,DFN,.103)  ;current service
 Q ""
 ;
OBSERV(P) ; obs if observatrion service
 Q $S($$GET1^DIQ(2,P,.103)["OBSERVATION":"OBS",1:"")
 ;
PRINT ; print report to paper
 NEW BDGX,BDGLN,BDGWD,BDGPG
 U IO D INIT^BDGF      ;initialize hdg variables
 ;
 ; if only one ward chosen, set ward and print header
 I BDGSRT S BDGWD=$P(BDGSRT,U,2) D HDG
 ;
 ; loop thru display array
 S BDGX=0 F  S BDGX=$O(^TMP("BDGIPL",$J,BDGX)) Q:'BDGX  D
 . S BDGLN=^TMP("BDGIPL",$J,BDGX,0)
 . ;
 . ;marker for form feed between wards
 . I $E(BDGLN,1,4)="@@@@" S BDGWD=$P(BDGLN,"@@@@",2) D HDG Q
 . ;
 . ;try to keep patient data together
 . I $E(BDGLN,1,5)="-----",($Y>(IOSL-7)) D HDG
 . I $Y>(IOSL-4) D HDG
 . W !,$E(BDGLN,1,80)
 ;
 I '$G(BDGCOP) D ^%ZISC  ;cmi/anch/maw 2/22/2007 added for no close of device if multiple copies PATCH 1007 item 1007.39
 D PRTKL^BDGF,EXIT
 ;D ^%ZISC,PRTKL^BDGF,EXIT  cmi/anch/maw 2/22/2007 orig line
 Q  ;7/6/2007 cmi/anch/maw patch 1007
 ;
HDG ; heading for paper report
 S BDGPG=$G(BDGPG)+1 I BDGPG>1 W @IOF
 W !?16,$$CONF^BDGF
 W !,BDGUSR,?(80-$L(BDGFAC)\2),BDGFAC
 W !,BDGTIME,?27,"Current Inpatients by Ward",?71,"Page: ",BDGPG
 NEW X S X="*** "_BDGWD_"***" W !,BDGDATE,?(80-$L(X)\2),X
 W !,$$REPEAT^XLFSTR("=",80)
 I BDGSRT2=4 W !?5,"Room",?14,"Patient",?34,"Chart #",?44,"Diagnosis",?64,"Attending",!,$$REPEAT^XLFSTR("-",80) Q
 W !?5,"Room",?14,"Patient",?34,"Chart #",?44,"Age",?52,"LOS"
 W ?58,$S(BDGSRT2=1:"Admitting Diagnosis",BDGSRT2=2:"Service",1:"Nursing Notes")
 W !,$$REPEAT^XLFSTR("-",80)
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BDGIPL",$J)
 ;K BDGSRT  cmi/anch/maw 7/10/2007 patch 1007
 Q
 ;
EXPND ; -- expand code
 Q
 ;
DASHES ; adds line of dashes
 D SET($$REPEAT^XLFSTR("-",BDGIOM),.VALMCNT,BDGCNT,"")
 Q
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
