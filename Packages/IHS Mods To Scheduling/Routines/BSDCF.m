BSDCF ; IHS/ANMC/LJF - CHART FINDER ;  [ 06/19/2002  11:29 AM ]
 ;;5.3;PIMS;**1005,1007**;MAY 28, 2004
 ;IHS/OIT/LJF 01/19/2006 PATCH 1005 added ability to call with patient defined
 ;cmi/anch/maw added line in ACTIONS for delivery date on chart finder patch 1007 item 1007.20
 ;cmi/anch/maw added line in ACTIONS for listing of provider if there patch 1007 item 1007.21
 ;
ASK ; ask user questions
 ;NEW DFN,BSDBD
 NEW DFN     ;IHS/OIT/LJF 01/19/2006 PATCH 1005 moved BSDBD to PAT+1
 S DFN=+$$READ^BDGF("PO^2:EMQ","Select Patient") Q:DFN<1
 ;
PAT ;EP; called if DFN already set (such as Other Reports under AM);IHS/OIT/LJF 01/19/2006 PATCH 1005
 NEW BSDBD   ;IHS/OIT/LJF 01/19/2006 PATCH 1005 moved new from ASK+1
 S BSDBD=$$READ^BDGF("DO^::EX","Select Beginning Date for Search")
 Q:BSDBD<1
 ;
EN ; -- main entry point for BSDRM CHART FINDER
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BSDRM CHART FINDER")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 NEW X
 S VALMHDR(1)=$$SP(15)_$$CONF^BDGF
 S X=$G(IORVON)_$$GET1^DIQ(2,DFN,.01)_$G(IORVOFF)
 S X=$$PAD(X,32)_"#"_$$HRCN^BDGF2(DFN,+$G(DUZ(2)))
 S X=$$PAD(X,48)_"DOB: "_$$GET1^DIQ(2,DFN,.03)
 S VALMHDR(2)=$$PAD(X,68)_"Sex: "_$$GET1^DIQ(2,DFN,.02)
 I $$DEAD^BDGF2(DFN) S VALMHDR(3)=$$SP(25)_$G(IORVON)_"** Patient Died on "_$$DOD^BDGF2(DFN)_" **"_$G(IORVOFF)
 E  S VALMHDR(3)=$$PCLINE^SDPPTEM(DFN,DT)
 S VALMHDR(4)=$$SP(15)_"Includes actions for "_$$RANGE^BDGF(BSDBD,DT)
 Q
 ;
INIT ; -- init variables and list array
 S VALMCNT=0 K ^TMP("BSDCF",$J),^TMP("BSDCF1",$J)
 ;
 ; display patient's current status
 D SET("Current Status: "_$$STATUS^BDGF2(DFN),.VALMCNT),SET("",.VALMCNT)
 ;
 ; build list of actions by date and type
 D ACTIONS(DFN)
 ;
 ; put actions in display array by date
 NEW DATE,TYP
 S DATE=0 F  S DATE=$O(^TMP("BSDCF1",$J,DATE))  Q:'DATE  D
 . S TYP=0 F  S TYP=$O(^TMP("BSDCF1",$J,DATE,TYP)) Q:TYP=""  D
 .. D SET(^TMP("BSDCF1",$J,DATE,TYP),.VALMCNT)
 K ^TMP("BSDCF1",$J)
 Q
 ;
ACTIONS(DFN) ; build list of chart actions for date range
 ;
 ; find all appts within date range
 NEW D,NODE,STATUS,LINE,TYPE
 S D=BSDBD-.0001 F  S D=$O(^DPT(DFN,"S",D)) Q:'D  Q:D>(DT+.2400)  D
 . S NODE=$G(^DPT(DFN,"S",D,0)),TYPE=$$APPTYP^BSDU2(DFN,D)
 . S STATUS=$$STATUS^SDAM1(DFN,D,+NODE,NODE,$$SCIEN^BSDU2(DFN,+NODE,D))
 . S LINE=$$PAD($$FMTE^XLFDT(D),20)_$E($$GET1^DIQ(44,+NODE,.01),1,15)
 . S LINE=$$PAD(LINE,38)_TYPE_" Appt"
 . S LINE=$$PAD(LINE,53)_"("_$P(STATUS,";",3)_")"
 . S ^TMP("BSDCF1",$J,D,TYPE)=LINE
 ;
 ; find all chart requests within date range
 NEW C,D,N,LINE
 NEW D1
 S C=0 F  S C=$O(^SC("AIHSCR",DFN,C)) Q:'C  D
 . S D=BSDBD-.0001
 . F  S D=$O(^SC("AIHSCR",DFN,C,D)) Q:'D  Q:D>(DT+.24)  D
 .. S N=0 F  S N=$O(^SC("AIHSCR",DFN,C,D,N)) Q:'N  D
 ... S D1=$E(+$G(^SC(C,"C",D,1,N,9999999)),1,12)   ;date/time requested
 ... S LINE=$$PAD($$FMTE^XLFDT(D1),20)_$E($$GET1^DIQ(44,C,.01),1,15)
 ... S LINE=$$PAD(LINE,38)_"Chart Request"
 ... S LINE=$$PAD(LINE,53)_"("_$P($G(^SC(C,"C",D,1,N,9999999)),U,3)_")"
 ... S LINE=$$PAD(LINE,100)_"Requested by "_$$GET1^DIQ(200,+$P($G(^SC(C,"C",D,1,N,9999999)),U,2),.01)
 ... S ^TMP("BSDCF1",$J,D1,"CR")=LINE
 ... S LINE=$$PAD("     Date Delivered "_$S($G(^SC(C,"C",D,0)):"("_$$FMTE^XLFDT($G(^SC(C,"C",D,0)))_")",1:""),40)  ;cmi/anch/maw 1/21/2007 added for delivery date patch 1007 item 1007.20
 ... S ^TMP("BSDCF1",$J,D1,"CR1")=LINE  ;cmi/anch/maw 1/21/2007 added for date delivered patch 1007 item 1007.20
 ;
 ; find any active incomplete chart entries
 NEW IEN,X,TYPE,DATE
 S IEN=0 F  S IEN=$O(^BDGIC("B",DFN,IEN)) Q:'IEN  D
 . S X=$$GET1^DIQ(9009020.1,$$DIV^BSDU,.13)        ;bill prep tracked?
 . I X="NO",$$GET1^DIQ(9009016.1,IEN,.14)]""  Q    ;chart completed
 . Q:$$GET1^DIQ(9009016.1,IEN,.15)]""              ;bill prep done
 . ;
 . S TYPE=$$GET1^DIQ(9009016.1,IEN,.0392)          ;visit type
 . S X=$$GET1^DIQ(9009016.1,IEN,$S(TYPE["DAY":.05,1:.02))         ;date
 . S DATE=$$GET1^DIQ(9009016.1,IEN,$S(TYPE["DAY":.05,1:.02),"I")  ;date
 . I DATE="" S DATE="??"
 . ;cmi/anch/maw 2/21/2007 added the following code for incomplete charts PATCH 1007 item 1007.21
 . I '$D(^BDGIC(IEN,1)) D  Q
 .. S LINE=$$PAD($$PAD(X,20)_TYPE_" Incomplete Chart",55)
 .. S LINE=LINE_$$GET1^DIQ(9009016.1,IEN,$S(TYPE["DAY":.06,1:.04))  ;srv
 .. S ^TMP("BSDCF1",$J,DATE,"IC")=LINE
 . N BSDPRV
 . S BSDPRV=0 F  S BSDPRV=$O(^BDGIC(IEN,1,BSDPRV)) Q:'BSDPRV  D
 .. N IENS,BSDDSP,BSDPRVE
 .. S IENS=BSDPRV_","_IEN
 .. S BSDDSP=$$GET1^DIQ(9009016.11,IENS,.0393)
 .. Q:BSDDSP'="Pending"
 .. S BSDPRVE=$$GET1^DIQ(9009016.11,IENS,.01)
 .. S LINE=$$PAD($$PAD(X,20)_TYPE_" Incomplete Chart",55)
 .. S LINE=LINE_$$GET1^DIQ(9009016.1,IEN,$S(TYPE["DAY":.06,1:.04))  ;srv
 .. S LINE=LINE_$$PAD(BSDPRVE,20)
 .. ;S ^TMP("BSDCF1",$J,DATE,"IC")=LINE
 .. S ^TMP("BSDCF1",$J,BSDPRV,"IC")=LINE
 ;cmi/anch/maw 2/21/2007 end of mods PATCH 1007 item 1007.21
 ;
 Q
 ;
SET(DATA,NUM) ; put data line into display array
 S NUM=NUM+1
 S ^TMP("BSDCF",$J,NUM,0)=DATA
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
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
