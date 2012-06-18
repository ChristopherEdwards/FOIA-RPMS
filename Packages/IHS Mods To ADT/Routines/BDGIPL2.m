BDGIPL2 ; IHS/ANMC/LJF - CURR INPTS BY WARD/NAME ; 
 ;;5.3;PIMS;**1007**;FEB 27, 2007
 ;
 ;cmi/anch/maw 2/22/2007 added code in PRINT to not close device if multiple copies PATCH 1007 item 1007.39
 ;
 I $E(IOST,1,2)="P-" D INIT,PRINT Q
 ;
EN ; -- main entry point for BDG IPL BY WARD/NAME
 ; assumes BDGSRT and BDGSRT2 are set
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BDG IPL BY WARD/NAME")
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
 NEW WD,DFN,BDGCNT,NAME,ORDER,X
 K ^TMP("BDGIPL",$J),^TMP("BDGIPL1",$J)
 S VALMCNT=0,BDGCNT=1
 ;
 ; if only one ward chosen
 I BDGSRT D
 . S WD=$P(BDGSRT,U,2),DFN=0 F  S DFN=$O(^DPT("CN",WD,DFN)) Q:'DFN  D
 .. S ^TMP("BDGIPL1",$J,1,WD,$$GET1^DIQ(2,DFN,.01),DFN)=""
 ;
 ; OR for all wards, find current inpatients & sort by ward then name
 E  S WD=0 F  S WD=$O(^DPT("CN",WD)) Q:WD=""  D
 . S DFN=0 F  S DFN=$O(^DPT("CN",WD,DFN)) Q:'DFN  D
 .. ; print in print order
 .. S X=$O(^DIC(42,"B",WD,0)) S ORDER=$$GET1^DIQ(42,+X,400) Q:'ORDER
 .. S ^TMP("BDGIPL1",$J,ORDER,WD,$$GET1^DIQ(2,DFN,.01),DFN)=""
 ;
 ; pull sorted list and create display array
 S ORDER=0 F  S ORDER=$O(^TMP("BDGIPL1",$J,ORDER)) Q:'ORDER  D
 . S WD=0 F  S WD=$O(^TMP("BDGIPL1",$J,ORDER,WD)) Q:WD=""  D
 .. ;
 .. I BDGSRT="A" D  ;display ward subheading
 ... D SET($G(IORVON)_"WARD: "_WD_$G(IORVOFF),.VALMCNT,BDGCNT,"")
 .. ;
 .. S NAME=0
 .. F  S NAME=$O(^TMP("BDGIPL1",$J,ORDER,WD,NAME)) Q:NAME=""  D
 ... S DFN=0
 ... F  S DFN=$O(^TMP("BDGIPL1",$J,ORDER,WD,NAME,DFN)) Q:'DFN  D
 .... D LINE
 ;
 K ^TMP("BDGIPL1",$J)
 Q
 ;
LINE ; set up dislay line for patient
 NEW LINE
 S LINE=$S($E(IOST,1,2)="P-":$$SP(5),1:$J(BDGCNT,3)_") ")
 S LINE=$$PAD(LINE,5)_$E($$GET1^DIQ(2,DFN,.01),1,18)   ;name
 S LINE=$$PAD(LINE,25)_$$HRCND^BDGF2($$HRCN^BDGF2(DFN,DUZ(2)))
 S LINE=$$PAD(LINE,34)_$$AGE(DFN)                          ;age
 S LINE=$$PAD(LINE,42)_$P($$INPT1^BDGF1(DFN,DT),"@")       ;admit date
 S LINE=$$PAD(LINE,53)_$J($P($$CURLOS^BDGF1(DFN)," "),3)   ;los
 S LINE=$$PAD(LINE,58)_$G(^DPT(DFN,.101))                  ;room
 S LINE=$$PAD(LINE,65)_$E($$CURPRV^BDGF1(DFN),1,15)        ;atten prv
 D SET(LINE,.VALMCNT,BDGCNT,DFN)
 ;
 ; if user asked for double spacing
 I BDGSRT2 D SET("",.VALMCNT,BDGCNT,"")
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
 . I $Y>(IOSL-4) D HDG
 . S BDGLN=^TMP("BDGIPL",$J,BDGX,0)
 . W !,BDGLN
 I '$G(BDGCOP) D ^%ZISC  ;cmi/anch/maw 2/22/2007 added for no close of device if multiple copies PATCH 1007 item 1007.39
 D PRTKL^BDGF,EXIT
 ;D ^%ZISC,PRTKL^BDGF,EXIT  cmi/anch/maw 2/22/2007 orig line
 Q
 ;
HDG ; heading for paper report
 S BDGPG=$G(BDGPG)+1 I BDGPG>1 W @IOF
 W !,BDGUSR,?16,$$CONF^BDGF,?71,"Page: ",BDGPG
 W !,BDGDATE,?24,"Current Inpatients by Ward"
 S X=$S(BDGSRT="A":"For ALL Ward Locations",1:$P(BDGSRT,U,2))
 W !,BDGTIME,?(80-$L(X)\2),X
 W !,$$REPEAT^XLFSTR("-",80)
 W !?5,"Patient",?25,"Chart #",?34,"Age",?42,"Admitted",?53,"LOS"
 W ?58,"Room",?65,"Provider"
 W !,$$REPEAT^XLFSTR("=",80)
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BDGIPL",$J)
 ;K BDGSRT cmi/anch/maw 7/25/2007 is needed for multiple copies
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
 ;
AGE(P) ; return formatted age
 NEW X S X=$$GET1^DIQ(9000001,DFN,1102.98)
 S X=$J($P(X," "),3)_" "_$E($P(X," ",2),1,2)
 Q X
 ;
