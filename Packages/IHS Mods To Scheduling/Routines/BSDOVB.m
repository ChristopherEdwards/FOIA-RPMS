BSDOVB ; IHS/ANMC/LJF - LIST OVERBOOK KEY HOLDERS ;  [ 06/26/2003  4:13 PM ]
 ;;5.3;PIMS;;APR 26, 2002
 ;
EN ; -- main entry point for BSDSM OVERBOOK ALL
 D MSG^BDGF("Please wait while I build the list...",2,0)
 NEW VALMCNT
 D TERM^VALM0
 D EN^VALM("BSDSM OVERBOOK ALL")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)=$$SP(10)_"USERS WITH KEYS THAT GIVE THEM OVERBOOK IN ALL CLINICS"
 Q
 ;
INIT ; -- find all users with SDOB and SDMOB keys
 NEW BSDLN,KEY,LINE,USER
 S BSDLN=0 K ^TMP("BSDOVB",$J)
 F KEY="SDOB","SDMOB" D
 . I KEY="SDMOB" D SET("",.BSDLN)
 . S LINE=KEY_":  "_$S(KEY="SDMOB":"MASTER ",1:"")_"OVERBOOK ACCESS"
 . D SET(LINE,.BSDLN)
 . ;
 . I '$O(^XUSEC(KEY,0)) D SET($$SP(3)_"*** NO ONE HAS THIS KEY ***",.BSDLN) Q
 . S USER=0 F  S USER=$O(^XUSEC(KEY,USER)) Q:'USER  D
 .. S LINE=$$SP(3)_$$PAD($$GET1^DIQ(200,USER,.01),36)
 ..;IHS/ITSC/WAR 6/26/03 ADDED
 .. S LINE=LINE_$$PAD($$GET1^DIQ(200,USER,8),31)          ;TITLE
 .. S LINE=LINE_$$PAD($$GET1^DIQ(200,USER,29),31)         ;SVC CNTR
 .. I $$INACT(USER)]"" D
 ... S LINE=$E(LINE,1,35)_$$INACT(USER)   ;Purposely truncated prev data
 .. D SET(LINE,.BSDLN)
 S VALMCNT=BSDLN
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
INACT(USER) ; -- returns inactivated date if any
 NEW X
 S X=$$GET1^DIQ(200,+USER,9.2)
 Q $S(X="":"",1:"Inactivated on "_X)
 ;
SET(DATA,LINENUM) ; -- sets display data into array
 S LINENUM=LINENUM+1
 S ^TMP("BSDOVB",$J,LINENUM,0)=DATA
 Q
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
