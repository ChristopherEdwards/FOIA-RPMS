BVPU ; IHS/ITSC/LJF - VPR UTILITY CALLS ;
 ;;1.0;VIEW PATIENT RECORD;;NOV 17, 2004
 ;Called by many BVP routines
 ;
CONFID(X) ;EP; -- SUBRTN to return confidential message
 Q "***Confidential "_X_" Data Covered by Privacy Act***"
 ;
USER() ;EP -- returns user's initials
 Q IORVON_"User: "_$$GET1^DIQ(200,DUZ,1)_IORVOFF
 ;
HRCN(X) ;EP; -- returns patient's chart #
 Q "Chart #: "_$P($G(^AUPNPAT(X,41,+$G(DUZ(2)),0)),U,2)
 ;
STATUS(PAT) ;EP; -- returns current patient status
 NEW LINE,BVPX,X
 I $D(^DPT(PAT,.1)) D  Q LINE
 . K BVPX D ENP^XBDIQ1(2,PAT,".1;.101;.103","BVPX(")
 . S LINE="Inpatient on "_$$PAD(BVPX(.1),5)_" Rm "_BVPX(.101)
 . S LINE=$$PAD(LINE,30)_BVPX(.103)
 ;
 S LINE="Outpatient "
 Q LINE
 ;
PAUSE ;EP; -- ask user to press return - no form feed
 NEW DIR Q:IOST'["C-"
 S DIR(0)="E",DIR("A")="Press ENTER to continue" D ^DIR
 Q
 ;
VALMSG() ;EP; called to reset message line - OK
 Q "- Previous Screen    Q Quit    ?? for More Actions"
 ;
MSG(DATA,PRE,POST,BEEP) ;EP; -- writes line to device - OK
 NEW I
 I PRE>0 F I=1:1:PRE W !
 W DATA
 I POST>0 F I=1:1:POST W !
 I $G(BEEP)>0 F I=1:1:BEEP W $C(7)
 Q
 ;
READ(TYPE,PROMPT,DEFAULT,HELP,SCREEN,DIRA) ;EP; calls reader, returns response
 NEW DIR,Y
 S DIR(0)=TYPE
 I $D(SCREEN) S DIR("S")=SCREEN
 I $G(PROMPT)]"" S DIR("A")=PROMPT
 I $G(DEFAULT)]"" S DIR("B")=DEFAULT
 I $D(HELP) S DIR("?")=HELP
 I $D(DIRA(1)) S Y=0 F  S Y=$O(DIRA(Y)) Q:Y=""  S DIR("A",Y)=DIRA(Y)
 D ^DIR
 Q Y
 ;
PKGCK(RTN,MSG) ;EP; -- called to check if rtn and package are installed - OK
 NEW X
 S X=RTN X ^%ZOSF("TEST") I '$T D  Q 0
 . Q:$G(MSG)=""
 . D MSG("Sorry, you do not have "_MSG_" software installed",1,1,1)
 . D PAUSE
 Q 1
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
