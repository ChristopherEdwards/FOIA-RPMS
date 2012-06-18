BDGEPI ; IHS/ANMC/LJF - EXTENDED PATIENT INQUIRY ; 
 ;;5.3;PIMS;**1007,1008,1010**;APR 26, 2002
 ;
 ;cmi/anch/maw 9/7/2007 mods in ASK PATCH 1007
 ;cmi/flag/maw 8/31/2009 PATCH 1010 change reference of UB92 to UB04
 ;
ASK ;EP; when admission ien not known but patient is known
 NEW DIC,X,Y,DGPMCA
 ;S DIC=405,DIC(0)="EMQ",X=$$HRCN^BDGF2(DFN,DUZ(2))  ;cmi/anch/maw 9/7/2007 orig line PATCH 1007
 ;S DIC=405,DIC(0)="EQ",D="C",X=$$HRCN^BDGF2(DFN,DUZ(2))  ;cmi/anch/maw 9/7/2007 per linda fels PATCH 1007
 S DIC=405,DIC(0)="EQ",D="C",X=DFN  ;cmi/anch/maw 10/23/2007 i believe x should be DFN since we are looking up on that index only
 S DIC("S")="I $P(^DGPM(+Y,0),U,2)=1",DIC("W")=""
 ;D ^DIC Q:Y<1  ;cmi/anch/maw 9/7/2007 orig line
 D IX^DIC Q:Y<1  K D  ;cmi/anch/maw 9/7/2007 per linda fels PATCH 1007
 S DGPMCA=+Y D EN
 Q
 ;
EN ;EP; -- main entry point for BDG EXTENDED PI
 ; assumes DGPMCA is set to corresponding admission
 ; and DFN is set to patient internal entry number
 NEW VALMCNT
 D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BDG EXTENDED PI")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 NEW X
 S VALMHDR(1)=$$SP(15)_$$CONF^BDGF
 S X=$$NAMEPRT^BDGF2(DFN)_" (#"_$$HRCN^BDGF2(DFN,DUZ(2))_")"
 S VALMHDR(2)=$$SP(75-$L(X)\2)_X
 S X=$$STATUS^BDGF2(DFN),VALMHDR(3)=$$SP(75-$L(X)\2)_X
 Q
 ;
INIT ; -- init variables and list array
 NEW IEN,BDG,LINE,BDGX,IEN2,BDG2,DATE,X,FIRST
 K ^TMP("BDGEPI",$J) S VALMCNT=0
 ;
 ; loop through all entries for this admission
 S IEN=0 F  S IEN=$O(^DGPM("CA",DGPMCA,IEN)) Q:'IEN  D
 . ;
 . ; build array by date/time
 . S DATE=+$G(^DGPM(IEN,0))
 . I '$D(BDGX(DATE)) S BDGX(DATE,IEN)=""
 . ; add service transfer to cooresponding physical movement
 . I $D(BDGX(DATE)),'$D(BDGX(DATE,IEN)) S X=$O(BDGX(DATE,0)) I X S BDGX(DATE,X)=IEN
 ;
 ; loop by date to build display array
 S DATE=0 F  S DATE=$O(BDGX(DATE)) Q:DATE=""  D
 . S IEN=$O(BDGX(DATE,0)) Q:'IEN
 . S IEN2=BDGX(DATE,IEN)
 . ;
 . ; gather data on this admission
 . K BDG D ENP^XBDIQ1(405,IEN,".01:9999999.99","BDG(")
 . K BDG2 D ENP^XBDIQ1(405,+IEN2,".01:9999999.99","BDG2(")
 . S ARRAY=$S(IEN2:"BDG2",1:"BDG")
 . ;
 . ; build display line
 . S LINE=$$PAD(BDG(.01),23)_$$MOVEMT(BDG(.02),BDG(.04))
 . S LINE=$$PAD(LINE,50)_BDG(.06)_$$ROOM(BDG(.07))         ;room-bed
 . S LINE=$$PAD(LINE,64)_$G(@ARRAY@(.09))                  ;service
 . S LINE=$$PAD(LINE,85)_$E($G(@ARRAY@(9999999.02)),1,18)  ;admt prov
 . S LINE=$$PAD(LINE,105)_$E($G(@ARRAY@(.19)),1,18)        ;atten prov
 . D SET(LINE,.VALMCNT)
 . ;
 . ; show transfer facility if appropriate
 . I $G(BDG(.05))]"" D
 .. S LINE=$$SP(25)_"("_$S(BDG(.02)="ADMISSION":"from ",1:"to ")
 .. S LINE=LINE_BDG(.05)_")"
 .. D SET(LINE,.VALMCNT)
 . ;
 . ; display optional UB92 fields
 . I (BDG(9999999.05)]"")!(BDG(9999999.06)]"") D
 .. S LINE=$$SP(25)_"Admit type/source (UB04): "_BDG(9999999.05)  ;cmi/maw 08/31/2009 PATCH 1010 change reference to UB04
 .. S LINE=LINE_"/"_BDG(9999999.06)
 .. D SET(LINE,.VALMCNT)
 . I BDG(9999999.07)]"" D SET($$SP(25)_"UB04 disposition: "_BDG(9999999.07),.VALMCNT)  ;cmi/maw 08/31/2009 PATCH 1010 change reference to UB04
 . ;
 . ; display short diagnosis and/or referral provider
 . I BDG(.1)]"" D SET($$SP(25)_"Adm Dx: "_BDG(.1),.VALMCNT)
 . I BDG(9999999.03)]"" D SET($$SP(25)_"Referred by "_BDG(9999999.03),.VALMCNT)
 . ;
 . ; display comment wp field
 . I IEN2 S X=0,FIRST=1 F  S X=$O(^DGPM(IEN2,"DX",X)) Q:'X  D
 .. S LINE=$S(FIRST:$$SP(25)_"Comments: ",1:$$SP(35)),FIRST=0
 .. S LINE=LINE_^DGPM(IEN2,"DX",X,0)
 .. D SET(LINE,.VALMCNT)
 . ;
 . D SET("",.VALMCNT)    ;blank line between events
 ;
 Q
 ;
MOVEMT(X1,X2) ; return type of movement phrase
 I (X1="ADMISSION")!(X1="DISCHARGE") Q X1_"-"_X2
 Q X2
 ;
ROOM(RBED) ; return room and bed-display mode
 I RBED="" Q RBED
 Q " ["_RBED_"]"
 ;
SET(LINE,NUMBER) ; put display line into array
 S NUMBER=NUMBER+1
 S ^TMP("BDGEPI",$J,NUMBER,0)=LINE
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BDGEPI",$J)
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
