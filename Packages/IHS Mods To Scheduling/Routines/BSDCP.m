BSDCP ; IHS/ANMC/LJF - CLINIC PROFILE ;  
 ;;5.3;PIMS;**1007,1010**;FEB 27, 2007
 ; 
 ;11/1/02 WAR - changed 2 lines in DATA, external doc LJF29,P36
 ;cmi/anch/maw 11/22/2006 PATCH 1007 added code in INIT for item 1007.30
 ;cmi/anch/maw 2/15/2007 PATCH 1007 modified code in INIT for item 1007.29
 ;cmi/anch/maw 05/15/2009 PATCH 1010 modified code in init for item 1010.42
 ;
ASK ; -- ask user questions
 NEW VAUTD,VAUTC,POP,BSDQ
 D CLINIC^BSDU(1,"") Q:$D(BSDQ)   ;IHS/ITSC/LJF 4/21/2004
 ;D CLINIC^BSDU(1,1) Q:$D(BSDQ)     ;IHS/ITSC/LJF 4/21/2004
 D CHKPC(.VAUTC)  ;cmi/anch/maw 2/15/2007 check to see if an inactive principal clinic and then get all grouped clinics PATCH 1007 item 1007.29
 S Y=$$BROWSE^BDGF Q:"PB"'[Y  I Y="B" D EN Q
 D ZIS^BDGF("PQ","START^BSDCP","CLINIC PROFILE","VAUTD*;VAUTC*")
 Q
 ;
CHKPC(PC) ;-- check to see if there are principal clinics and if so expand them
 N CHK
 S CHK=0 F  S CHK=$O(PC(CHK)) Q:CHK=""  D
 . N PCI
 . S PCI=$G(PC(CHK))
 . I $D(^SC("AIHSPC",PCI)) D EXPNDPC^BSDU(1,.VAUTC)
 Q
 ;
START ;EP; entry point when printing to paper
 D INIT,PRINT Q
 ;
EN ; -- main entry point for BSDRM CLINIC PROFILE
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BSDRM CLINIC PROFILE")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 Q
 ;
INIT ; -- init variables and list array
 K ^TMP("BSDCP",$J) S VALMCNT=0
 ;NEW ARRAY S ARRAY=$S(VAUTC:"^SC(""B"",",1:"VAUTC")  ;cmi/maw 5/15/2009 orig line PATCH 1010 RQMT 42
 NEW ARRAY S ARRAY=$S(VAUTC:"^SC(""B"")",1:"VAUTC")  ;cmi/maw 5/15/2009 PATCH 1010 RQMT 42
 ;
 ; -- loop by clinic
 NEW NAME,CLN,COL1,COL2,I,LINE
 S NAME=0 F  S NAME=$O(@ARRAY@(NAME)) Q:NAME=""  D
 . S CLN=$S(ARRAY="VAUTC":VAUTC(NAME),1:$O(^SC("B",NAME,0)))
 . Q:'CLN  Q:$$GET1^DIQ(44,CLN,2)'="CLINIC"
 . ;
 . ;I '$$ACTV^BSDU(CLN,DT) D  Q               ;inactive clinic cmi/anch/maw 2/15/2007 orig line
 . I '$$ACTV^BSDU(CLN,DT) D               ;inactive clinic cmi/anch/maw 2/15/2007 mod line PATCH 1107 item 1007.29
 .. S LINE=$$PAD($$SP(15)_NAME,40)
 .. S LINE=LINE_"*** Inactivated on "_$$INACTVDT^BSDU(CLN)
 .. D SET(LINE,.VALMCNT),SET("",.VALMCNT)
 . ;
 . S COL1=15,COL2=18                         ;used to line up columns
 . ;I $D(^SC("AIHSPC",CLN)) D PRINC(CLN) Q    ;principal clinic cmi/anch/maw 2/15/2006 orig line
 . I $D(^SC("AIHSPC",CLN)) D PRINC(CLN)    ;principal clinic cmi/anch/maw 2/15/2006 mod line PATCH 1007 item 1007.29
 . ;
 . F I=1:2:24 D DISPLAY(I)                   ;first set of data items
 . ;
 . D SET("",.VALMCNT),SET("Appointment List Statement: "_$$GET1^DIQ(9009017.2,CLN,.02),.VALMCNT)
 . D SET("",.VALMCNT),MULT("Special Instructions: ",44.03,.01,CLN)
 . ;
 . D SET("",.VALMCNT),SET("Clinic's Letters -",.VALMCNT)
 . F I=25:2:28 D DISPLAY(I)
 . ;
 . D SET("",.VALMCNT),SET("Documents Printed with Routing Slips-",.VALMCNT)
 . F I=29:2:32 D DISPLAY(I)
 . ;
 . S X=$$GET1^DIQ(9009017.2,CLN,.09)    ;create vist at checkin?
 . S X="*** TURNED "_$S(X="YES":"ON",1:"OFF")_" ***"
 . D SET("",.VALMCNT),SET("PCC Visit Link: "_X,.VALMCNT)
 . I X["ON" F I=33:2:38 D DISPLAY(I)
 . ;
 . D SET("",.VALMCNT),PROV(CLN)     ;clinic's providers
 . ;
 . D SET("",.VALMCNT),MULT("Clinic Owners: ",9009017.22,".01",CLN)
 . ;
 . ;cmi/anch/maw 11/22/06 added following lines for item 1007.30 patch 1007
 . D SET("",.VALMCNT),MULT("Overbook Users: ",9009017.21,".01",CLN)
 . ;cmi/anch/maw 11/22/06 end of added lines item 1007.30 patch 1007
 . D SET("",.VALMCNT)
 . S X=$$GET1^DIQ(44,CLN,2500),X=$S(X="YES":X_" - Access Restricted to:",1:"NO")
 . D SET("Prohibit Access to Make Appts: "_X,.VALMCNT)
 . I X'="NO" D USERS(CLN)           ;list users with access
 . ;
 . D SET("",.VALMCNT),SET("",.VALMCNT)
 Q
 ;
DISPLAY(I) ; for value of I, find captions & data & put into display array
 NEW CAP1,CAP2,DATA1,DATA2,LINE
 S CAP1=$P($T(DATA+I),";;",2),DATA1=$P($T(DATA+I),";;",3)
 S CAP2=$P($T(DATA+I+1),";;",2),DATA2=$P($T(DATA+I+1),";;",3)
 ;
 X DATA1 S LINE=$$PAD($$SP(COL1-$L(CAP1))_CAP1_X,40)
 X DATA2 S LINE=LINE_$$SP(COL2-$L(CAP2))_CAP2_X
 D SET(LINE,.VALMCNT)
 Q
 ;
MULT(CAPTION,FILE,FIELD,IEN) ; find multiple data and put into display array
 NEW BSDX,LINE,X
 D ENPM^XBDIQ1(FILE,IEN_",0",FIELD,"BSDX(")
 S LINE=CAPTION
 I '$D(BSDX) D SET(LINE_"None",.VALMCNT) Q
 ;
 S X=0 F  S X=$O(BSDX(X)) Q:'X  D
 . S LINE=LINE_BSDX(X,FIELD) D SET(LINE,.VALMCNT)
 . S LINE=$$SP($L(CAPTION))    ;reset beginning of line
 Q
 ;
PRINC(CLN) ; -- display data for principal clinics
 D SET($$SP(20)_"**** PRINCIPAL CLINIC ****",.VALMCNT)
 F I=1:2:4 D DISPLAY(I)
 ;
 D SET("",.VALMCNT),SET("Documents Printed with Routing Slips-",.VALMCNT)
 F I=29:2:32 D DISPLAY(I)
 ;
 D SET("",.VALMCNT),MULT("Clinic Owners: ",9009017.22,".01",CLN)
 ;
 D SET("",.VALMCNT)
 S X=$$GET1^DIQ(44,CLN,2500),X=$S(X="YES":X_" - Access Restricted to:",1:"NO")
 D SET("Prohibit Access to Make Appts: "_X,.VALMCNT)
 I X'="NO" D USERS(CLN)           ;list users with access
 ;
 D SET("",.VALMCNT)
 D SET("Clinics Grouped under this Principal Clinic:",.VALMCNT)
 D CLINICS(CLN)
 ;
 D SET("",.VALMCNT),SET("",.VALMCNT)
 Q
 ;
CLINICS(PRINC) ; list clinics under this principal clinic
 NEW CLN,NAME,BSDY,X
 ;
 ; find clinics and put in alphabetical order
 S CLN=0 F  S CLN=$O(^SC("AIHSPC",PRINC,CLN)) Q:'CLN  D
 . S NAME=$$GET1^DIQ(44,CLN,.01)
 . S BSDY(NAME)=$$PAD(NAME,35)_$S('$$ACTV^BSDU(CLN,DT):"Inactivated on "_$$INACTVDT^BSDU(CLN),1:"")
 ;
 ; put sorted list into display array
 S X=0 F  S X=$O(BSDY(X)) Q:X=""  D SET(BSDY(X),.VALMCNT)
 Q
 ;
PROV(IEN) ; display clinic's providers
 NEW BSDX,LINE,X,Y
 D ENPM^XBDIQ1(44.1,IEN_",0",".01;.02","BSDX(")
 S LINE="Clinic's Provider(s): "
 I '$D(BSDX) D SET(LINE_"None Defined",.VALMCNT) Q
 ;
 S X=0 F  S X=$O(BSDX(X)) Q:'X  D
 . S LINE=LINE_BSDX(X,.01)_$S(BSDX(X,.02)="YES":" (Default)",1:"")
 . D SET(LINE,.VALMCNT)
 . S LINE=$$SP(22)             ;reset beginning of line
 Q
 ;
USERS(IEN) ; list users with access to clinic
 NEW BSDX,X,BSDY,Y,NAME,USER
 D ENPM^XBDIQ1(44.04,IEN_",0",".01","BSDX(","1I") I '$O(BSDX(0)) Q
 ;
 ; put users found in alphabetical order
 S X=0 F  S X=$O(BSDX(X)) Q:'X  D
 . S NAME=BSDX(X,.01),USER=BSDX(X,.01,"I")
 . S BSDY(NAME)=$$PAD($E(NAME,1,28),30)             ;user name
 . S BSDY(NAME)=$$PAD(BSDY(NAME)_$$GET1^DIQ(200,USER,29),50)  ;service
 . S Y=$$GET1^DIQ(200,USER,9.2) I Y>DT S Y=""       ;termination date
 . S BSDY(NAME)=BSDY(NAME)_$S(Y="":"",1:"Inactivated on "_Y)
 ;
 ; put sorted list into display array
 S X=0 F  S X=$O(BSDY(X)) Q:X=""  D SET(BSDY(X),.VALMCNT)
 Q
 ;
SET(LINE,NUM) ; set display line into array
 S NUM=NUM+1
 S ^TMP("BSDCP",$J,NUM,0)=LINE
 Q
 ;
PRINT ; print to paper
 NEW X,VALMHDR,BSDPG
 U IO D HDG
 S X=0 F  S X=$O(^TMP("BSDCP",$J,X)) Q:'X  D
 . I $Y>(IOSL-4) D HDG
 . W !,^TMP("BSDCP",$J,X,0)
 D ^%ZISC,EXIT
 Q
 ;
 ;
HDG ; -- heading
 W @IOF S BSDPG=$G(BSDPG)+1
 W !?20,"CLINIC PROFILE",?55,"Printed ",$$FMTE^XLFDT(DT)
 W !,$$REPEAT^XLFSTR("=",80)
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
 ;
 ;
DATA ;;
 ;;Clinic: ;;S X=NAME
 ;;Abbrv: ;;S X=$$GET1^DIQ(44,CLN,1)
 ;;Facility: ;;S X=$$GET1^DIQ(44,CLN,3)
 ;;Service: ;;S X=$$GET1^DIQ(9009017.2,CLN,.11)
 ;;Location: ;;S X=$$GET1^DIQ(44,CLN,10)
 ;;Clinic Code: ;;S X=$$CLNCODE^BSDU(CLN)
 ;;Telephone: ;;S X=$$GET1^DIQ(44,CLN,99)
 ;;Principal Clinic: ;;S X=$$PRIN^BSDU(CLN)
 ;;Non-Count: ;;S X=$$NONCOUNT^BSDU(CLN),X=$S(X="":"NO",1:"YES")
 ;;File Room List: ;;S X=$$NONCOUNT^BSDU(CLN),X=$S($P(X,",",2)["NOT":"NO",1:"YES")
 ;;Clinic Meets: ;;S X=$$DOW^BSDU(CLN)
 ;;Sched Holidays: ;;S X=$$GET1^DIQ(44,CLN,1918.5)
 ;;Appt. Display: ;;S X=$$GET1^DIQ(44,CLN,1914),X="Begins at "_$S(X="":"8 AM",X<13:X_" AM",1:(X-12)_" PM")
 ;;Appt. Length: ;;S X=$$GET1^DIQ(44,CLN,1912),X=$S(X="":"",1:X_" min.")
 ;;Increments: ;;S X=$$GET1^DIQ(44,CLN,1917)
 ;;Variable Length: ;;S X=$$GET1^DIQ(44,CLN,1913),X=$S(X="":"NO",1:X)
 ;;Overbooks/Day: ;;S X=$$GET1^DIQ(44,CLN,1918)
 ;;Future Booking: ;;S X=$$GET1^DIQ(44,CLN,2002)_" days max."
 ;;Auto-Rebook: ;;S X=$$GET1^DIQ(44,CLN,2003),X="Start at "_$S(X="":"earliest time",X<12:X_" AM",1:(X-12)_" PM")
 ;;Max. Auto-Rebook: ;;S X=$$GET1^DIQ(44,CLN,2005)_" days"
 ;;No-Shows: ;;S X=$$GET1^DIQ(44,CLN,2001)_" allowed"
 ;;Wait Period: ;;S X=$$GET1^DIQ(9009017.2,CLN,.03)
 ;;;;S X=""
 ;;Pull Prev X-rays: ;;S X=$$GET1^DIQ(44,CLN,2000) S:X="" X="NO"
 ;;Pre-Appt: ;;S X=$$GET1^DIQ(44,CLN,2509)
 ;;Clinic Cancel: ;;S X=$$GET1^DIQ(44,CLN,2510)
 ;;Appt. Cancel: ;;S X=$$GET1^DIQ(44,CLN,2511)
 ;;No-show: ;;S X=$$GET1^DIQ(44,CLN,2508)
 ;;Health Summary: ;;S X=$$HSPRINT^BSDU(CLN)
 ;;AIU Form: ;;S X=$$GET1^DIQ(90009017.2,CLN,.07) S:X="" X="NO"
 ;;    Rx Profile: ;;S X=$$GET1^DIQ(9009017.2,CLN,.06) S:X="" X="NO"
 ;;;;S X=""
 ;;  Checkin Time: ;;S X=$$GET1^DIQ(44,CLN,24,"I"),X=$S(X=1:"ASK USER",1:"USE CURRENT DATE/TIME")
 ;;Visit Category: ;;S X=$$GET1^DIQ(9009017.2,CLN,.12) S:X="" X="AMBULATORY"
 ;;Multiple Codes: ;;S X=$$GET1^DIQ(9009017.2,CLN,.13) S:X="" X="NO"
 ;;PYXIS Location: ;;S X=$$GET1^DIQ(9009017.2,CLN,,08) S:X="" X="NOT USED"
 ;;;;S X=""
 ;;Require Provider: ;;S X=$$GET1^DIQ(9009017.2,CLN,.14) S:X="" X="NO"
