BDGIPL7 ; IHS/ANMC/LJF - CURR INPTS W/INSURANCE ; 
 ;;5.3;PIMS;**1007,1009,1010**;FEB 27, 2007
 ;
 ;
 ;cmi/anch/maw 2/22/2007 added code in PRINT to not close device if multiple copies PATCH 1007 item 1007.39
 ;cmi/anch/maw 2/22/2007 added code in INIT and INITC to sort by coverage type PATCH 1007 item 1007.40.
 ;cmi/anch/maw 05/08/2008 PATCH 1009 requirements 22,31,71 for insurance display
 ;
 ;
 I $E(IOST,1,2)="P-" D INIT,PRINT Q
 ;
EN ; -- main entry point for BDG IPL INSURANCE
 ; assumes BDGSRT is set
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BDG IPL INSURANCE")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 NEW X
 S VALMHDR(1)=$$SP(12)_"** "_$$CONF^BDGF_" **"
 S X=$S(BDGSRT="A":"For ALL Ward Locations",1:$P(BDGSRT,U,2))
 S VALMHDR(2)=$$SP(75-$L(X)\2)_X
 Q
 ;
INIT ; -- init variables and list array
 NEW WD,DFN,BDGCNT,NAME,FIRST
 K ^TMP("BDGIPL",$J),^TMP("BDGIPL1",$J)
 S VALMCNT=0,BDGCNT=1,FIRST=1
 ;
 I $G(BDGSRT2)="C" D INITC Q  ;cmi/anch/maw 2/22/2007 added for Coverage Type
 ; if only one ward chosen
 I BDGSRT D
 . S WD=$P(BDGSRT,U,2),DFN=0 F  S DFN=$O(^DPT("CN",WD,DFN)) Q:'DFN  D
 .. S ^TMP("BDGIPL1",$J,WD,$$GET1^DIQ(2,DFN,.01),DFN)=""
 ;
 ; OR for all wards, find current inpatients & sort by ward then name
 E  S WD=0 F  S WD=$O(^DPT("CN",WD)) Q:WD=""  D
 . S DFN=0 F  S DFN=$O(^DPT("CN",WD,DFN)) Q:'DFN  D
 .. S ^TMP("BDGIPL1",$J,WD,$$GET1^DIQ(2,DFN,.01),DFN)=""
 ;
 ; pull sorted list and create display array
 S WD=0 F  S WD=$O(^TMP("BDGIPL1",$J,WD)) Q:WD=""  D
 . ;
 . I BDGSRT="A" D  ;display ward subheading
 .. ;
 .. ; if printer, mark stop to add form feed
 .. I 'FIRST,$E(IOST,1,2)="P-" D SET("@@@@",.VALMCNT,BDGCNT,"")
 .. S FIRST=0
 .. ;
 .. D SET($G(IORVON)_"WARD: "_WD_$G(IORVOFF),.VALMCNT,BDGCNT,"")
 . ;
 . S NAME=0 F  S NAME=$O(^TMP("BDGIPL1",$J,WD,NAME)) Q:NAME=""  D
 .. S DFN=0 F  S DFN=$O(^TMP("BDGIPL1",$J,WD,NAME,DFN)) Q:'DFN  D
 ... D LINE
 ;
 K ^TMP("BDGIPL1",$J)
 Q
 ;
INITC ;-- init variables for coverage type and list array
 ;cmi/anch/maw 2/22/2007 added to sort by coverage type patch 1007 item 1007.40
 ;cmi/anch/maw 5/08/2008 changed insurance call to new insurance calls in BDGF2
 N BDGADM,BDGCOV,BDGMCR,BDGMCD,BDGRR,BDGRAIL
 I BDGSRT D
 . S WD=$P(BDGSRT,U,2),DFN=0 F  S DFN=$O(^DPT("CN",WD,DFN)) Q:'DFN  D
 . S BDGCOV=0          ;used to find patients with no coverage
 . S BDGADM=+$$GET1^DIQ(2,DFN,.105,"I")                  ;admit ien
 . S BDGMCD=$$NEWINS^BDGF2(DFN,BDGADM,"MCD")         ;medicaid # if any
 . I $G(BDGMCD)]"" S BDGCOV="MCD"
 . S BDGMCR=$$NEWINS^BDGF2(DFN,BDGADM,"MCR")         ;medicare # if any
 . I $G(BDGMCR)]"" S BDGCOV="MCR"
 . S BDGRAIL=$$NEWINS^BDGF2(DFN,BDGADM,"RR")
 . I $G(BDGRAIL)]"" S BDGCOV="RR"
 . D NEWINS^BDGF2(DFN,BDGADM,"PI")  ;check for pvt ins
 . I $D(BDGRR) S BDGCOV="PI"
 . I BDGCOV=0 S BDGCOV="ZZ"
 . S ^TMP("BDGIPL1",$J,WD,BDGCOV,$$GET1^DIQ(2,DFN,.01),DFN)=""
 ;
 ; OR for all wards, find current inpatients & sort by ward then name
 E  S WD=0 F  S WD=$O(^DPT("CN",WD)) Q:WD=""  D
 . S DFN=0 F  S DFN=$O(^DPT("CN",WD,DFN)) Q:'DFN  D
 .. S BDGCOV=0          ;used to find patients with no coverage
 .. S BDGADM=+$$GET1^DIQ(2,DFN,.105,"I")                  ;admit ien
 .. ;S BDGMCD=$$MCD^BDGF2(DFN,BDGADM)         ;medicaid # if any
 .. ;I BDGMCD S BDGCOV="MCD"
 .. ;S BDGMCR=$$MCR^BDGF2(DFN,BDGADM)         ;medicare # if any
 .. ;I BDGMCR S BDGCOV="MCR"
 .. ;D INS^BDGF2(DFN,BDGADM,.BDGRR)  ;check for pvt ins
 .. ;I $D(BDGRR) S BDGCOV="PI"
 .. ;cmi/maw 5/8/2008 PATCH 1009 next lines for new insurance display
 .. S BDGMCD=$$NEWINS^BDGF2(DFN,BDGADM,"MCD")         ;medicaid # if any
 .. I $G(BDGMCD)]"" S BDGCOV="MCD"
 .. S BDGMCR=$$NEWINS^BDGF2(DFN,BDGADM,"MCR")         ;medicare # if any
 .. I $G(BDGMCR)]"" S BDGCOV="MCR"
 .. S BDGRAIL=$$NEWINS^BDGF2(DFN,BDGADM,"RR")
 .. I $G(BDGRAIL)]"" S BDGCOV="RR"
 .. D NEWINS^BDGF2(DFN,BDGADM,"PI")  ;check for pvt ins
 .. I BDGCOV=0 S BDGCOV="ZZ"
 .. S ^TMP("BDGIPL1",$J,WD,BDGCOV,$$GET1^DIQ(2,DFN,.01),DFN)=""
 ;
 ; pull sorted list and create display array
 S WD=0 F  S WD=$O(^TMP("BDGIPL1",$J,WD)) Q:WD=""  D
 . ;
 . I BDGSRT="A" D  ;display ward subheading
 .. ;
 .. ; if printer, mark stop to add form feed
 .. I 'FIRST,$E(IOST,1,2)="P-" D SET("@@@@",.VALMCNT,BDGCNT,"")
 .. S FIRST=0
 .. ;
 .. D SET($G(IORVON)_"WARD: "_WD_$G(IORVOFF),.VALMCNT,BDGCNT,"")
 . ;
 . N COV
 . S COV=0 F  S COV=$O(^TMP("BDGIPL1",$J,WD,COV)) Q:COV=""  D
 .. S NAME=0 F  S NAME=$O(^TMP("BDGIPL1",$J,WD,COV,NAME)) Q:NAME=""  D
 ... S DFN=0 F  S DFN=$O(^TMP("BDGIPL1",$J,WD,COV,NAME,DFN)) Q:'DFN  D
 .... D LINE
 ;
 K ^TMP("BDGIPL1",$J)
 Q
 ;
LINE ; set up dislay line for patient
 NEW LINE,BDGCOV,ADM
 S LINE=$S($E(IOST,1,2)="P-":$$SP(5),1:$J(BDGCNT,3)_") ")
 S LINE=$$PAD(LINE,5)_$E($$GET1^DIQ(2,DFN,.01),1,18)            ;name
 S LINE=$$PAD(LINE,25)_$$HRCND^BDGF2($$HRCN^BDGF2(DFN,DUZ(2)))  ;chart#
 S LINE=$$PAD(LINE,35)_$G(^DPT(DFN,.101))                       ;room
 S LINE=$$PAD(LINE,43)_$$GET1^DIQ(45.7,+$G(^DPT(DFN,.103)),99)  ;srv
 S LINE=$$PAD(LINE,50)_$E($P($$CURPRV^BDGF1(DFN),"/"),1,15)  ;prim prov
 S LINE=$$PAD(LINE,67)_$P($$INPT1^BDGF1(DFN,DT),"@")         ;admit date
 D SET(LINE,.VALMCNT,BDGCNT,DFN)
 ;
 ; display diagnosis & M/M info
 S LINE=$$SP(5)_"Adx Dx: "_$E($$GET1^DIQ(405,+$G(^DPT(DFN,.105)),.1),1,23)
 S BDGCOV=0          ;used to find patients with no coverage
 S ADM=+$$GET1^DIQ(2,DFN,.105,"I")                  ;admit ien
 ;cmi/anch/maw 5/8/2008 PATCH 1009 next lines for new insurance display
 ;S X=$$MCR^BDGF2(DFN,IEN),Y=$$MCD^BDGF2(DFN,IEN)  ;cmi/anch/maw 5/2/2008 PATCH 1009 requirements 22,31 orig line
 ;D INS^BDGF2(DFN,IEN,.BDGRR)  ;cmi/anch/maw 5/2/2008 PATCH 1009 requirements 22,31 orig line
 N BDGW,BDGX,BDGY,BDGZ,BDGRR
 S BDGX=$$NEWINS^BDGF2(DFN,ADM,"MCR"),BDGY=$$NEWINS^BDGF2(DFN,ADM,"MCD")  ;cmi/anch/maw 5/2/2008 PATCH 1009 requirements 22,31
 S BDGW=$$NEWINS^BDGF2(DFN,ADM,"RR"),BDGZ=$$NEWINS^BDGF2(DFN,ADM,"PI")  ;cmi/anch/maw 5/2/2008 PATCH 1009 requirements 22,31 7/30/2009 PATCH 1010 reversed RR and PI calls
 ;I BDGCOV=0 D SET($$SP(10)_"**No Additional Coverage**",.VALMCNT) Q
 I (BDGW]"")!(BDGX]"")!(BDGY]"") S LINE=$$SP(5)_BDGX_$$SP(2)_BDGY_$$SP(2)_BDGW  ;cmi/anch/maw 5/2/2008 PATCH 1009 requirements 22,31
 ;I (X]"")!(Y]"") D SET($$PAD($$SP(10)_X,40)_Y,.VALMCNT)  ;cmi/anch/maw 5/2/2008 PATCH 1009 orig line
 ;S LINE=$$PAD(LINE,38)_$$MCD^BDGF2(DFN,ADM)         ;medicaid # if any
 ;S LINE=$$PAD(LINE,60)_$$MCR^BDGF2(DFN,ADM)         ;medicare # if any
 ;D INS^BDGF2(DFN,ADM,.BDGRR)                        ;check for pvt ins
 I BDGCOV=0 S LINE=$$PAD(LINE,38)_"No Additional Coverage"
 D SET(LINE,.VALMCNT,BDGCNT,DFN)
 ;
 ; display all current private insurance coverage
 S I=0 F  S I=$O(BDGRR(I)) Q:'I  D
 . D SET($$SP(5)_BDGRR(I),.VALMCNT,BDGCNT,DFN)
 ;
 D SET("",.VALMCNT,BDGCNT,"")
 ;
 ; increment counter
 S BDGCNT=BDGCNT+1
 Q
 ;
SET(LINE,NUM,COUNT,IEN) ; put display line into array
 D SET^BDGIPL1(LINE,.NUM,COUNT,IEN)
 Q
 ;
PRINT ; print report to paper
 NEW BDGX,BDGLN,BDGPG
 U IO D INIT^BDGF,HDG
 ;
 ; loop thru display array
 S BDGX=0 F  S BDGX=$O(^TMP("BDGIPL",$J,BDGX)) Q:'BDGX  D
 . S BDGLN=^TMP("BDGIPL",$J,BDGX,0)
 . ;
 . ;marker for form feed between wards
 . I $E(BDGLN,1,4)="@@@@" D HDG Q
 . ;
 . I $Y>(IOSL-4) D HDG
 . W !,BDGLN
 I '$G(BDGCOP) D ^%ZISC  ;cmi/anch/maw 2/22/2007 added for no close of device if multiple copies PATCH 1007 item 1007.39
 D PRTKL^BDGF,EXIT
 ;D ^%ZISC,PRTKL^BDGF,EXIT  cmi/anch/maw 2/22/2007 orig line
 Q  ;cmi/anch/maw 7/25/2007 quit missing patch 1007
 ;
HDG ; heading for paper report
 S BDGPG=$G(BDGPG)+1 I BDGPG>1 W @IOF
 W !,BDGUSR,?16,$$CONF^BDGF
 W !,BDGDATE,?20,"Insurance Coverage for Current Inpatients"
 W ?71,"Page: ",BDGPG
 S X=$S(BDGSRT="A":"For ALL Ward Locations",1:$P(BDGSRT,U,2))
 W !,BDGTIME,?(80-$L(X)\2),X
 W !,$$REPEAT^XLFSTR("-",80)
 W !?5,"Patient",?25,"Chart #",?35,"Room",?43,"Srv",?50,"Provider"
 W ?67,"Admit Date"
 W !,$$REPEAT^XLFSTR("=",80)
 Q
 ;
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BDGIPL",$J)
 ;K BDGSRT cmi/anch/maw 7/25/2007 is needed for multiple copies patch 1007
 Q
 ;
EXPND ; -- expand code
 Q
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
