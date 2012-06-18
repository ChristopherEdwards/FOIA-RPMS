BSDOAS ; cmi/anch/maw - Original Clinic Availability Setup ;  [ 01/02/2004  10:48 AM ]
 ;;5.3;PIMS;**1007**;FEB 27, 2007
 ;
 ;cmi/anch/maw 2/23/2007 added option for PATCH 1007 item 1007.32
 ;
ASK ; ask clinic and set variables
 S BSDD=$$READ^BDGF("D^::EX","Select Date") Q:'BSDD
 ;
 ; get clinic arrays based on subtotal category
 D CLINIC^BSDU(2) Q:$D(BSDQ)
 ;
 S Y=$$BROWSE^BDGF Q:"PB"'[Y  I Y="B" D EN Q  ;browse in list mgr mode
 D ZIS^BDGF("PQ","START^BSDOAS","ORIGINAL AVAILABILITY SETUP","BSDD;VAUTC*;VAUTD*")
 Q
 ;
START ;EP; -- re-entry for printing to paper
 D INIT,PRINT Q
 ;
EN ;EP; -- main entry point for month-at-a-glance list templates
 NEW VALMCNT,DIR,DIC
 ;BSDANS = answer to date to start display
 S VALMCC=1    ;1=screen mode, 0=scrolling mode
 D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BSDAM ORIGINAL CLINIC DISPLAY")
 Q
 ;
HDR ;EP; -- header code
 S VALMHDR(1)=$$SP(23)_"Original Availability Setup Display"
 S VALMHDR(2)=$$SP(30)_"For date: "_$$FMTE^XLFDT(BSDD)
 Q
 ;
INIT ;EP; -- init variables and list array
 S VALMCNT=0 K ^TMP("BSDM",$J),^TMP("BSD",$J)
 NEW BSDAR S BSDAR=$S(VAUTC:"^SC",1:"VAUTC")
 S BSDIOM=150,BSDTOT=BSDIOM-15  ;used in place of 80 & 65 below
 ;
 ; -- loop by clinic
 NEW CLN,NAME,BSDS,BSDSCD,BSDPC,BSDH,BSDCS
 S CLN=0 F  S CLN=$O(@BSDAR@(CLN)) Q:'CLN  D
 . Q:'$$GET1^DIQ(44,CLN,3.5,"I")  ;No Div entered for this clinic
 . I $D(VAUTD) Q:(VAUTD'=1&('$D(VAUTD($$GET1^DIQ(44,CLN,3.5,"I")))))  ;this Div notd
 . S NAME=$$GET1^DIQ(44,CLN,.01)         ;set clinic's name
 . I $D(^SC("AIHSPC",CLN)) D  Q               ;quit if principal clinic
 .. D SET("PRINCIPAL CLINIC: "_NAME_" - "_$$FMTE^XLFDT(BSDD),.VALMCNT)
 . S BSDSCD=$$GET1^DIQ(44,CLN,8)         ;clinic code
 . S BSDPC=$$GET1^DIQ(44,CLN,1916)       ;principal clinic
 . S BSDCS=$P($G(^SC(CLN,"SL")),U,3)
 . N BSDPTR
 . I $D(^SC(CLN,"OST",BSDD,1)) D
 .. S BSDPTR=$G(^SC(CLN,"OST",BSDD,1))
 . I '$D(^SC(CLN,"OST",BSDD,1)) D
 .. S BSDPTR=$$UP^XLFSTR($E($$DOW(BSDD,""),1,2))_" "_$E(BSDD,6,7)_"  "_$G(^SC(CLN,$$DOWN(BSDD),9999999,1))
 . D SET(NAME_" - "_$$FMTE^XLFDT(BSDD),.VALMCNT)
 . S LINE=" TIME  " F Y=BSDCS:1:BSDTOT\16+BSDCS S LINE=LINE_$E("|"_$S('Y:0,1:(Y-1#12+1))_"                 ",1,8)
 . D SET(LINE,.VALMCNT)
 . S LINE=" DATE  |"
 . D SET(LINE,.VALMCNT)
 . D SET(BSDPTR,.VALMCNT)
 . D SET("",.VALMCNT)
 ;
 ; add legend to display to explain 1s, 0s, As, Bs, *s, etc.
 S VALMCNT=VALMCNT+1,^TMP("BSDM",$J,VALMCNT,0)=""  ;extra line
 NEW BSDX D LEGEND^BSDU(.BSDX)
 S X=0 F  S X=$O(BSDX(X)) Q:'X  D
 . D SET(BSDX(X),.VALMCNT)
 ;
 K ^TMP("BSD",$J)
 Q
 ;
WMH ;Write month heading lines
 W !!," TIME",?7 F Y=BSDCS:1:BSDTOT\16+BSDCS W $E("|"_$S('BSDD:0,1:(BSDD-1#12+1))_"                 ",1,8)
 W !," DATE",?7,"|"
 F Y=1:1:BSDTOT\(8) W $J("|",8)
 S BSDCNT=0   ;reset count after printing time headings
 Q
 ;
SET(LINE,NUM) ; -- sets display line into array
 S NUM=NUM+1
 S ^TMP("BSDM",$J,NUM,0)=LINE
 Q
 ;
HELP ;EP; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ;EP; -- exit code
 D CLEAR^VALM1
 K ^TMP("BSDM",$J)
 S VALMNOFF=1  ;suppress form feed before next question
 Q
 ;
EXPND ;EP; -- expand code
 Q
 ;
PAUSE ; -- end of action pause
 D PAUSE^BDGF Q
 ;
DT W $$FMTE^XLFDT(Y) Q
 ;
DOW(X,F) Q $$DOW^XLFDT(X,F)
 ;
DOWN(DOW) ;-- get the node to display for Day of Week
 S DOW=$$DOW^XLFDT(DOW,1)
 Q "T"_DOW
 ;
HELP1 ;EP; help for print individual dates question
 D MSG^BDGF("The report will display the Original,",2,0)
 D MSG^BDGF("Availability Setup based on the date.",1,0)
 D MSG^BDGF("passed in.",1,1)
 Q
 ;
PRINT ; print report to paper
 U IO D HDG
 NEW X S X=0 F  S X=$O(^TMP("BSDM",$J,X)) Q:'X  D
 . I $Y>(IOSL-4) D HDG
 . W !,^TMP("BSDM",$J,X,0)
 D ^%ZISC,EXIT
 Q
 ;
HDG ; heading for paper report
 D HDR W @IOF,?30,"Original Availability Setup"
 F I=1:1 Q:'$D(VALMHDR(I))  W !,VALMHDR(I)
 W !,$$REPEAT^XLFSTR("-",80)
 W !,"Clinic Pattern"
 W !,$$REPEAT^XLFSTR("=",80)
 Q
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
 ;
END D KVAR^VADPT K SDAPTYP,SDSC,%,%DT,ASKC,COV,DA,DIC,DIE,DP,DR
 K HEY,HSI,HY,J,SB,SC,SDDIF,SDJ,SDLN,SD17,SDMAX,SDU,SDYC,SI,SL
 K SSC,STARTDAY,STR,SDZPR,WY,X,XX,Y,S,SD,SDAP16,SDEDT,SDTY,SM
 K SS,ST,ARG,CCX,CCXN,HX,I,PXR,SDINA,SDW,COLLAT,SDDIS,SDMM,SDMLT1
 K SDAV,SDHX,SDSOH,SDT
 Q
