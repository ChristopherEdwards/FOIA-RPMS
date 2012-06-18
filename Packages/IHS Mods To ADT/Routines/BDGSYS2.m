BDGSYS2 ; IHS/ANMC/LJF - TREATING SPECIALTY SETUP ; 
 ;;5.3;PIMS;;APR 26, 2002
 ;
EN ; -- main entry point for BDG SYS TREAT SPEC SETUP
 NEW VALMCNT
 D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BDG SYS TREAT SPEC SETUP")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 NEW X
 S X=$$GET1^DIQ(40.8,BDGDIV,.01)
 S VALMHDR(1)=$$SP(79-$L(X)\2)_X
 Q
 ;
INIT ; -- init variables and list array
 D MSG^BDGF("Please wait while I compile the list...",1,0)
 NEW CODE,IEN,COUNT,LINE,Y
 S VALMCNT=0
 K ^TMP("BDGSYS2",$J)
 S NAME=0
 F  S NAME=$O(^DIC(45.7,"B",NAME)) Q:NAME=""  D
 . S IEN=0
 . F  S IEN=$O(^DIC(45.7,"B",NAME,IEN)) Q:'IEN  D
 .. S CODE=$$GET1^DIQ(45.7,IEN,9999999.01) Q:CODE="00"  ;bad entry
 .. ;
 .. S COUNT=$G(COUNT)+1
 .. S LINE=$J(COUNT,2)_". "_NAME                          ;service name
 .. S LINE=$$PAD(LINE,32)_$$GET1^DIQ(45.7,IEN,99)         ;abbreviation
 .. S LINE=$$PAD(LINE,39)_CODE
 .. S LINE=$$PAD(LINE,45)_$$SRV(IEN)                      ;hos service
 .. S LINE=$$PAD(LINE,61)_$$LASTDATE(IEN)                 ;active date
 .. D SET(LINE,COUNT,IEN,.VALMCNT)
 ;
 I '$D(^TMP("BDGSYS2",$J)) D
 . D SET("*** NO ENTRIES FOUND WITH IHS CODES!! ***",0,0,.VALMCNT)
 Q
 ;
LASTDATE(N) ; find latest effective date and active status
 NEW X,Y
 I $$GET1^DIQ(45.7,N,9999999.03)'="YES" Q ""       ;admitting service?
 S X=$O(^DIC(45.7,N,"E","ADATE","")) I X="" Q "No effective date"
 S Y=$O(^DIC(45.7,N,"E","ADATE",X,0)) I 'Y Q "Bad entry"
 I $$GET1^DIQ(45.702,Y_","_N,.02)'="YES" Q "Inactive"      ;active?
 Q "YES - "_$$PAD($$FMTE^XLFDT(-X),14)
 ;
SRV(N) ; returns hospital service for entry
 Q $E($P($$GET1^DIQ(45.7,IEN,2)," SERVICE"),1,15)
 ;
SET(DATA,NUM,N,LINE) ; put display line into array
 S LINE=LINE+1
 S ^TMP("BDGSYS2",$J,LINE,0)=DATA
 S ^TMP("BDGSYS2",$J,"IDX",LINE,NUM)=N
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BDGSYS2",$J)
 Q
 ;
EXPND ; -- expand code
 Q
 ;
RESET ; -- update partition for return to list manager
 I $D(VALMQUIT) S VALMBCK="Q" Q
 D TERM^VALM0 S VALMBCK="R"
 D INIT,HDR
 Q
 ;
EDIT ;EP; called by Edit Entry protocol
 NEW X,Y,Z,BDGN,DDSFILE,DA,DR
 D FULL^VALM1
 D EN^VALM2(XQORNOD(0),"OS")
 I '$D(VALMY) Q
 S X=0 F  S X=$O(VALMY(X)) Q:X=""  D
 . S Y=0 F  S Y=$O(^TMP("BDGSYS2",$J,"IDX",Y)) Q:Y=""  D
 .. S Z=$O(^TMP("BDGSYS2",$J,"IDX",Y,0))
 .. Q:^TMP("BDGSYS2",$J,"IDX",Y,Z)=""
 .. I Z=X S BDGN=^TMP("BDGSYS2",$J,"IDX",Y,Z)
 ;
 I 'BDGN D RESET Q
 S DDSFILE=45.7,DA=BDGN,DR="[BDG 45.7 SETUP]" D ^DDS
 D RESET
 Q
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
