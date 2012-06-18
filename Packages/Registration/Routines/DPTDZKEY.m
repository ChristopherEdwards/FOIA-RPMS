DPTDZKEY ; IHS/ANMC/LJF - LIST MERGE USERS ; [ 03/16/2000  6:50 AM ]
 ;
EN ;EP -- main entry point for DPTD USER LIST
 S VALMCC=1
 D EN^VALM("DPTD IHS MERGE USERS")
 D CLEAR^VALM1,FULL^VALM1,EXIT
 Q
 ;
HDR ;EP -- header code
 NEW X S X=$$SPACE(20)
 S VALMHDR(1)=" "
 S VALMHDR(2)=X_IORVON_"ACCESS TO PATIENT MERGE SYSTEM"_IORVOFF
 S VALMCC=1
 Q
 ;
INIT ;EP -- init variables and list array
 D GATHER
 S VALMCNT=DPTDLN
 S VALMSG="- Previous Screen    Q Quit    ?? for More Actions"
 Q
 ;
HELP ;EP -- help code
 S X="?" D DISP^XQORM1,MSG^DPTDUT("",2,0,0)
 Q
 ;
EXIT ;EP -- exit code
 K ^TMP("DPTDZKEY",$J),^TMP("DPTDZKEY1",$J) K DPTDLN
 D TERM^VALM0 S VALMBCK="R"
 D CLEAR^VALM1
 Q
 ;
EXPND ;EP -- expand code
 Q
 ;
PAUSE ;EP -- end of action pause
 D PAUSE^DPTDZFIX Q
 ;
RESET ;EP -- update partition for return to list manager
 I $D(VALMQUIT) S VALMBCK="Q" Q
 D TERM^VALM0 S VALMBCK="R"
 D INIT,HDR
 Q
 ;
GATHER ; -- find all users with ob keys
 NEW DPTDNUM,KEYNM,KEY,KEYDES,LINE,USR,DPTD,SRV,IEN
 K ^TMP("DPTDZKEY",$J),^TMP("DPTDZKEY1",$J)
 S DPTDLN=0
 S KEYNM="XDQZ"
 F  S KEYNM=$O(^DIC(19.1,"B",KEYNM)) Q:KEYNM'["XDR"  D
 . S KEY=$O(^DIC(19.1,"B",KEYNM,0)) Q:KEY=""
 . S KEYDES=$$VAL^XBDIQ1(19.1,KEY,.02)
 . S LINE=$$SPACE(5)_"Access to "_KEYDES
 . S ^TMP("DPTDZKEY1",$J,KEYNM,0)=LINE
 . S USR=0
 . F  S USR=$O(^XUSEC(KEYNM,USR)) Q:USR=""  D
 .. ;Q:$D(^XUSEC("XUPROG",USR))
 .. K DPTD
 .. D ENP^XBDIQ1(200,USR,".01;8;29","DPTD(","I")
 .. S SRV=$S(DPTD(29)="":"??",1:$$VAL^XBDIQ1(49,DPTD(29,"I"),1))
 .. S LINE=" "_$$PAD(DPTD(.01),20)_$$SPACE(3)_$$PAD(SRV,10)
 .. S LINE=$$PAD(LINE,34)_$$PAD(DPTD(8),25)
 .. S ^TMP("DPTDZKEY1",$J,KEYNM,DPTD(.01),USR)=LINE
 ;
 S KEYNM=0
 F  S KEYNM=$O(^TMP("DPTDZKEY1",$J,KEYNM)) Q:KEYNM=""  D
 . D SET(""),SET(^TMP("DPTDZKEY1",$J,KEYNM,0)),SET("")
 . S USR=0
 . F  S USR=$O(^TMP("DPTDZKEY1",$J,KEYNM,USR)) Q:USR=""  D
 .. S IEN=0
 .. F  S IEN=$O(^TMP("DPTDZKEY1",$J,KEYNM,USR,IEN)) Q:IEN=""  D
 ... D SET(^TMP("DPTDZKEY1",$J,KEYNM,USR,IEN))
 Q
 ;
 ;
PAD(D,L) ; -- SUBRTN to pad length of data
 ; -- D=data, L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SPACE(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
 ;
SET(LINE) ; -- SUBRTN to set data line into ^tmp
 S DPTDLN=DPTDLN+1
 S ^TMP("DPTDZKEY",$J,DPTDLN,0)=LINE
 S ^TMP("DPTDZKEY",$J,"IDX",DPTDLN,DPTDLN)=""
 Q
