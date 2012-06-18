BDGIPL6 ; IHS/ANMC/LJF - CHAPLAIN'S LIST ; 
 ;;5.3;PIMS;**1007**;FEB 27, 2007
 ;
 ;
 ;cmi/anch/maw 2/22/2007 added code in PRINT to not close device if multiple copies PATCH 1007 item 1007.39
 ;
 ;
 I $E(IOST,1,2)="P-" D INIT,PRINT Q
 ;
EN ; -- main entry point for BDG IPL CHAPLAIN
 ; assumes BDGSRT is set
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BDG IPL CHAPLAIN")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 NEW X
 S VALMHDR(1)=$$SP(12)_"** "_$$CONF^BDGF_" **"
 S X=$S(BDGSRT="A":"For ALL Religions",1:$P(BDGSRT,U,2))
 S VALMHDR(2)=$$SP(75-$L(X)\2)_X
 Q
 ;
INIT ; -- init variables and list array
 NEW WD,DFN,BDGCNT,NAME,FIRST
 K ^TMP("BDGIPL",$J),^TMP("BDGIPL1",$J)
 S VALMCNT=0,BDGCNT=1,FIRST=1
 ;
 ; find current inpatients & sort by religion, ward then room
 S WD=0 F  S WD=$O(^DPT("CN",WD)) Q:WD=""  D
 . S DFN=0 F  S DFN=$O(^DPT("CN",WD,DFN)) Q:'DFN  D
 .. S REL=$$GET1^DIQ(2,DFN,.08) Q:REL=""   ;if no rel, don't display
 .. I BDGSRT,REL'=$P(BDGSRT,U,2) Q         ;not selected
 .. S RM=$G(^DPT(DFN,.101)) I RM="" S RM="UNK"
 .. S ^TMP("BDGIPL1",$J,REL,WD,RM,DFN)=""
 ;
 ; pull sorted list and create display array
 S REL=0 F  S REL=$O(^TMP("BDGIPL1",$J,REL)) Q:REL=""  D
 . ;
 . I BDGSRT="A" D  ;display religion subheading
 .. ; if printer, mark stop to add form feed
 .. I FIRST=0,$E(IOST,1,2)="P-" D SET("@@@@",.VALMCNT,BDGCNT,"")
 .. S FIRST=0
 .. ;
 .. D SET($G(IORVON)_REL_$G(IORVOFF),.VALMCNT,BDGCNT,"")
 .. ;
 . ;
 . S WD=0 F  S WD=$O(^TMP("BDGIPL1",$J,REL,WD)) Q:WD=""  D
 .. S RM=0 F  S RM=$O(^TMP("BDGIPL1",$J,REL,WD,RM)) Q:RM=""  D
 ... S DFN=0 F  S DFN=$O(^TMP("BDGIPL1",$J,REL,WD,RM,DFN)) Q:'DFN  D
 .... D LINE
 ;
 K ^TMP("BDGIPL1",$J)
 Q
 ;
LINE ; set up dislay line for patient
 NEW LINE,X
 S X=$O(^DIC(42,"B",WD,0)) I X S X=$$GET1^DIQ(9009016.5,X,.02)
 S LINE=$$PAD(X,7)_RM                                 ;ward abbrv & room
 S LINE=$$PAD(LINE,15)_$E($$GET1^DIQ(2,DFN,.01),1,18)      ;name
 S LINE=$$PAD(LINE,35)_$$AGE(DFN)                          ;age
 S LINE=$$PAD(LINE,45)_$E($$GET1^DIQ(9000001,DFN,1118),1,18)  ;community
 S LINE=$$PAD(LINE,65)_$P($$INPT1^BDGF1(DFN,DT),"@")       ;admit date
 D SET(LINE,.VALMCNT,BDGCNT,DFN)
 ;
 Q
 ;
SET(LINE,NUM,COUNT,IEN) ; put display line into array
 D SET^BDGIPL1(LINE,.NUM,COUNT,IEN)
 Q
 ;
PRINT ; print report to paper
 NEW BDGX,BDGLN,REL,BDGPG
 U IO D INIT^BDGF,HDG
 ;
 ; loop thru display array
 S BDGX=0 F  S BDGX=$O(^TMP("BDGIPL",$J,BDGX)) Q:'BDGX  D
 . S BDGLN=^TMP("BDGIPL",$J,BDGX,0)
 . ;
 . ;marker for form feed between religions
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
 W !,BDGDATE,?32,"Chaplain's List",?70,"Page: ",BDGPG
 S X=$S(BDGSRT="A":"For ALL Religions",1:$P(BDGSRT,U,2))
 W !,BDGTIME,?(80-$L(X)\2),X
 W !,$$REPEAT^XLFSTR("-",80)
 W !,"Ward",?7,"Room",?15,"Patient Name",?35,"Age",?45,"Community"
 W ?65,"Admit Date"
 W !,$$REPEAT^XLFSTR("=",80)
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BDGIPL",$J)
 ;K BDGSRT  cmi/anch/maw 7/25/2007 is needed for multiple copies patch 1007
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
