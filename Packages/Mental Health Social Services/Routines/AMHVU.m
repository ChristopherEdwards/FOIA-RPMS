AMHVU ; IHS/CMI/LAB - VIEW RECORD UTILITY CALLS ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
 ;
INTRO ;EP; displays intro text to view reocrd
 D ^XBCLS
 D MSG($$SP(20)_"VIEW PATIENT'S RECORD",2,2,0)
 Q
 ;
CONFID(X) ;EP; -- SUBRTN to return confidential message
 Q "*****Confidential "_X_" Data Covered by Privacy Act*****"
 ;
RETURN ;EP; -- ask user to press ENTER
 Q:IOST'["C-"
 NEW Y S Y=$$READ("E","Press ENTER to continue") D ^XBCLS Q
 ;
VALMSG() ;EP; called to reset message line
 Q "- Previous Screen    QU Quit    ?? for More Actions"
 ;
VALMSG2() ;EP; called to reset message line
 Q "V=View Record   Q=Quit   ?? for More Actions"
 ;
VALMSG3() ;EP; called to reset message line
 Q "> Shift to Right  V View Record  ?? More Actions"
 ;
VALMSG4() ;EP; called to reset message line
 Q ">  Shift to Right  Q  Quit   ?? More Actions"
 ;
MSG(DATA,PRE,POST,BEEP) ;EP; -- writes line to device
 NEW I
 I PRE>0 F I=1:1:PRE W !
 W DATA
 I POST>0 F I=1:1:POST W !
 I $G(BEEP)>0 F I=1:1:BEEP W $C(7)
 Q
 ;
READ(TYPE,PROMPT,DEFAULT,HELP,SCREEN,DIRA) ;EP; calls reader, returns response
 NEW DIR,X,Y
 S DIR(0)=TYPE
 I $D(SCREEN) S DIR("S")=SCREEN
 I $G(PROMPT)]"" S DIR("A")=PROMPT
 I $G(DEFAULT)]"" S DIR("B")=DEFAULT
 I $D(HELP) S DIR("?")=HELP
 I $D(DIRA(1)) S Y=0 F  S Y=$O(DIRA(Y)) Q:Y=""  S DIR("A",Y)=DIRA(Y)
 D ^DIR
 Q Y
 ;
PKGCK(RTN,MSG) ;EP; -- called to check if rtn and package are installed
 NEW X
 S X=RTN X ^%ZOSF("TEST") I '$T D  Q 0
 . Q:$G(MSG)=""
 . D MSG("Sorry, you do not have "_MSG_" software installed",1,1,1)
 . D RETURN
 Q 1
 ;
KEYCK(KEY,USER,MSG) ;EP; -- called to check is user has key
 I '$D(^XUSEC(KEY,USER)) D  Q 0
 . D MSG("Sorry, you do not have access to "_MSG,1,1,1)
 . D RETURN
 Q 1
 ;
LMKILL ;EP; -- kills IO and VALM variables used by List Manager
 D KILL^%ZISS
 K VALMIOXY,VALMWD,VALMHDR,VALMCC,VALMBCK,VALMSGR
 Q
PAD(D,L) ; -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
