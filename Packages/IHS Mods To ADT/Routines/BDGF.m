BDGF ; IHS/ANMC/LJF - GENERAL PIMS FUNCTION CALLS ;  [ 01/09/2004  8:07 AM ]
 ;;5.3;PIMS;**1003,1005,1007,1008**;MAY 28, 2004
 ;IHS/ITSC/LJF 05/13/2005 PATCH 1003 added EP; to MSG subroutine
 ;IHS/OIT/LJF  12/30/2005 PATCH 1005 added WRAP subroutine
 ;             01/20/2006 PATCH 1005 added READRVD subroutine
 ;cmi/anch/maw 2/22/2007 PATCH 1007 item 1007.39 modified ZIS to accept copies
 ;
WRAP(STRING,COL,ARRAY) ;EP return string formatted by colum width;IHS/OIT/LJF 12/30/2005 PATCH 1005
 ; returns multiple lines in ARRAY; COL=column width
 K ^UTILITY($J,"W")
 NEW X,DIWL,DIWR,DIWF,I
 S X=STRING,DIWL=0,DIWR=COL,DIWF="C"_COL
 D ^DIWP
 F I=1:1 Q:'$D(^UTILITY($J,"W",DIWL,I))  S ARRAY(I)=^UTILITY($J,"W",DIWL,I,0)
 K ^UTILITY($J,"W")
 Q
 ;
IHS() ;EP; returns 1 if agency of user is IHS   
 Q $S($G(DUZ("AG"))="I":1,1:0)
 ;
MSG(DATA,PRE,POST) ;EP; -- writes line to device;IHS/ITSC/LJF PATCH 1003
 NEW I,FORMAT
 S FORMAT="" I $G(PRE)>0 F I=1:1:PRE S FORMAT=FORMAT_"!"
 D EN^DDIOL(DATA,"",FORMAT)
 I $G(POST)>0 F I=1:1:POST D EN^DDIOL("","","!")
 Q
 ;
PAUSE ;EP; -- ask user to press return - no form feed
 NEW DIR Q:IOST'["C-"
 S DIR(0)="E",DIR("A")="Press ENTER to continue" D ^DIR
 Q
 ;
ZIS(X,BDGRTN,BDGDESC,BDGVAR,BDGDEV) ;EP
 ; -- called to select device and send print
 K %ZIS,IOP,ZTIO   ;IHS/ITSC/LJF 1/9/2004 added ZTIO
 I X="F" D     ;forced queuing; no user interaction
 . S ZTIO=BDGDEV,ZTDTH=$H
 ;cmi/anch/maw 2/22/2007 modified print logic to accept copies PATCH 1007 item 1007.39
 I X'="F" D  Q:'$D(IO("Q"))
 . S %ZIS=X
 . I $G(BDGDEV)]"" S %ZIS("B")=BDGDEV
 . D ^%ZIS
 . Q:POP
 . Q:$D(IO("Q"))
 . I $G(BDGCOP)>1 D  Q
 .. N J  ;cmi/anch/maw 7/10/2007 modified new to kill patch 1007
 .. F J=1:1:BDGCOP D @BDGRTN
 . D @BDGRTN
 ;cmi/anch/maw 2/22/2007 end of mods
 ;cmi/anch/maw 2/22/2007 next 3 lines are original lines
 ;E  D   Q:POP  I '$D(IO("Q")) D @BDGRTN Q
 ;. S %ZIS=X I $G(BDGDEV)]"" S %ZIS("B")=BDGDEV
 ;. D ^%ZIS
 ;cmi/anch/maw 2/22/2007 end of orig lines
 ;
 ;cmi/anch/maw 2/22/2007 added flag for copies if passed in PATCH 1007 item 1007.39
 I $G(BDGCOP)>1 D  Q
 . N K  ;cmi/maw 10/3/2007 changed to k from j
 . F K=1:1:BDGCOP D  ;cmi/maw 10/3/2007 changed from k to j
 .. K IO("Q") S ZTRTN=BDGRTN,ZTDESC=BDGDESC
 .. I $G(BDGDTH)]"" S ZTDTH=BDGDTH  ;if time is already put in then set to that cmi/maw 10/3/2007
 .. F I=1:1 S J=$P(BDGVAR,";",I) Q:J=""  S ZTSAVE(J)=""
 .. D ^%ZTLOAD
 .. S BDGDTH=$G(ZTSK("D"))  ;set time equal to what they put in the first time  cmi/maw 10/3/2007
 .. K ZTSK
 . D ^%ZISC
 . K BDGDTH  ;cmi/maw 10/3/2007
 ;cmi/anch/maw 2/22/2007 end of mods PATCH 1007 item 1007.39
 K IO("Q") S ZTRTN=BDGRTN,ZTDESC=BDGDESC
 F I=1:1 S J=$P(BDGVAR,";",I) Q:J=""  S ZTSAVE(J)=""
 D ^%ZTLOAD K ZTSK D ^%ZISC
 Q
 ;
READ(TYPE,PROMPT,DEFAULT,HELP,SCREEN,DIRA) ;EP; calls reader, returns response
 NEW DIR,Y,DIRUT
 S DIR(0)=TYPE
 I $E(TYPE,1)="P",$P(TYPE,":",2)["L" S DLAYGO=+$P(TYPE,U,2)
 I $D(SCREEN) S DIR("S")=SCREEN
 I $G(PROMPT)]"" S DIR("A")=PROMPT
 I $G(DEFAULT)]"" S DIR("B")=DEFAULT
 I $D(HELP) S DIR("?")=HELP
 I $D(DIRA(1)) S Y=0 F  S Y=$O(DIRA(Y)) Q:Y=""  S DIR("A",Y)=DIRA(Y)
 D ^DIR
 Q Y
 ;
TIME(DATE) ;EP returns time in 12:00 PM format for date send
 Q $$UP^XLFSTR($E($$FMTE^XLFDT($E(DATE,1,12),"P"),14,21))
 ;
NUMDATE(D,YR) ;EP; returns external number date with leading zeros
 ; D=date and optionally time
 ; YR=1 for 2 digit year, =0 for 4 digit year
 NEW X
 I 'D Q ""
 I $G(YR) S X=$E(D,4,5)_"/"_$E(D,6,7)_"/"_$E(D,2,3)
 E  S X=$E(D,4,5)_"/"_$E(D,6,7)_"/"_(1700+$E(D,1,3))
 I $L(D)>7 S X=X_"@"_$E($P(D,".",2)_"000",1,4)
 Q X
 ;
READRVD(DATE) ;EP; returns a readable date from a FM reverse date
 NEW Y S Y=9999999.9999-DATE D DD^%DT
 Q Y
 ;
BROWSE() ;EP; -- calls DIR to ask if want to browse or print
 Q $$READ("SO^B:BROWSE ON SCREEN;P:PRINT ON PAPER","PRINT MODE","BROWSE")
 ;
RANGE(DATE1,DATE2) ;EP; -- returns printable date range
 Q $$FMTE^XLFDT(DATE1)_" to "_$$FMTE^XLFDT(DATE2)
 ;
INIT ;EP; initialize report header variables
 S BDGUSR=$$GET1^DIQ(200,DUZ,1)       ;user's initials
 S BDGFAC=$$GET1^DIQ(4,DUZ(2),.01)       ;facility name
 S BDGTIME=$$TIME^BDGF($$NOW^XLFDT)   ;print time
 S BDGDATE=$$FMTE^XLFDT(DT)           ;print date
 Q
 ;
PRTKL ;EP; kill report header variables
 K BDGUSR,BDGFAC,BDGTIME,BDGDATE Q
 ;
HELP(BDGHF,BDGN) ;EP; Called by various on-line help options
 ;
 ;This entry point gives the user a choice to display a help frame
 ;or print it to a printer.  The entry point brings in the
 ;parameter BDGHF which is the name of the help frame for the
 ;option calling this routine.  The parameter BDGN is the number
 ;of pages it takes if you print the help frame.
 ;
 D ^XBCLS,MSG($$SP(20)_"PIMS ON-LINE HELP UTILITY",2,2)
 NEW BDGA,Y
 S BDGA(1)="   How do you want me to present this help?"
 S BDGA(2)=" "
 S BDGA(3)="     1.  DISPLAY help to your screen"
 S BDGA(4)="     2.  PRINT help to your printer ("_BDGN_" pages)"
 S BDGA(5)=" "
 S Y=$$READ("NO^1:2","   Choose One","","","",.BDGA)
 ;
 I Y=1 S XQH=BDGHF D EN^XQH Q
 ;
 I Y=2 S XQHFY=BDGHF,XQFMT="R" D ACTION^XQH4 Q
 Q
 ;
SETPT(DFN) ;EP; -- sets AUPN variables when DFN is set
 NEW X,DIC,Y S X="`"_DFN,DIC=2,DIC(0)="" D ^DIC Q
 ;
KILLVAR ;EP; -- kills patient variables  
 D KVA^VADPT,KILL^AUPNPAT Q
 ;
CONF() ;EP; -- returns confidential warning
 Q "Confidential Patient Data Covered by Privacy Act"
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ;EP -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
