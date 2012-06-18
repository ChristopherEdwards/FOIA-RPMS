BDGSYS3 ; IHS/ANMC/LJF - INPATIENT WARD SETUP ;  [ 04/09/2004  8:18 AM ]
 ;;5.3;PIMS;**1005**;MAY 28, 2004
 ;IHS/OIT/LJF 04/27/2006 PATCH 1005 changed ScreenMan form to use authorization dates
 ;
EN ; -- main entry point for BDG SYS WARD SETUP
 NEW VALMCNT
 D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BDG SYS WARD SETUP")
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
 D MSG^BDGF("Pleaes wait while I compile the list...",1,0)
 NEW IEN,DIV,INA,NAME
 S VALMCNT=0
 K ^TMP("BDGSYS3",$J),^TMP("BDGSYS31",$J)
 ;
 ; loop thru wards and sort by division, active/inactive, then name
 S NAME=0 F  S NAME=$O(^DIC(42,"B",NAME)) Q:NAME=""  D
 . S IEN=0 F  S IEN=$O(^DIC(42,"B",NAME,IEN)) Q:'IEN  D
 .. Q:'$D(^BDGWD(IEN))    ;not in IHS Ward file (old deleted ward?)
 .. S DIV=$$GET1^DIQ(42,IEN,.015) I DIV="" S DIV="??"
 .. S INA=$S($$GET1^DIQ(9009016.5,IEN,.03,"I")="I":"INACTIVE",1:"ACTIVE")
 .. S ^TMP("BDGSYS31",$J,DIV,INA,NAME,IEN)=""
 ;
 ; take sorted list and create display lines
 NEW A,B,C,D,COUNT
 S A=0 F  S A=$O(^TMP("BDGSYS31",$J,A)) Q:A=""  D
 . S B=0 F  S B=$O(^TMP("BDGSYS31",$J,A,B)) Q:B=""  D
 .. S C=0 F  S C=$O(^TMP("BDGSYS31",$J,A,B,C)) Q:C=""  D
 ... S D=0 F  S D=$O(^TMP("BDGSYS31",$J,A,B,C,D)) Q:'D  D
 .... D LINE(A,B,C,D,.COUNT)
 ;
 I '$D(^TMP("BDGSYS3",$J)) D
 . D SET("*** NO ENTRIES FOUND ***",0,0,.VALMCNT)
 K ^TMP("BDGSYS31",$J)
 Q
 ;
LINE(DIV,INA,NAME,IEN,COUNT) ; create display line
 NEW LINE
 S COUNT=$G(COUNT)+1
 S LINE=$J(COUNT,2)_". "_NAME                         ;ward name
 S LINE=$$PAD(LINE,32)_$$GET1^DIQ(9009016.5,IEN,.02)  ;abbrev
 S LINE=$$PAD(LINE,42)_$E(DIV,1,15)                   ;division  
 ;
 I $$GET1^DIQ(9009016.5,IEN,.03)="INACTIVE" D  Q      ;inactive
 . S LINE=$$PAD(LINE,60)_"** INACTIVE **"
 . D SET(LINE,COUNT,IEN,.VALMCNT)
 ;
 S LINE=$$PAD(LINE,60)
 I $$GET1^DIQ(9009016.5,IEN,101)="YES" S LINE=LINE_" ICU"
 I $$GET1^DIQ(9009016.5,IEN,105)="YES" S LINE=LINE_" PCU"
 I $$GET1^DIQ(42,IEN,.09,"I")=1 S LINE=LINE_" SI WARD"
 D SET(LINE,COUNT,IEN,.VALMCNT)
 Q
 ;
SET(DATA,NUM,N,LINE) ; put display line into array
 S LINE=LINE+1
 S ^TMP("BDGSYS3",$J,LINE,0)=DATA
 S ^TMP("BDGSYS3",$J,"IDX",LINE,NUM)=N
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BDGSYS3",$J)
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
ADD ;EP; called by Add Entry protocol
 NEW DIC,DLAYGO,Y,DDSFILE,DA,DR
 D FULL^VALM1
 ;
 NEW GNL F GNL=1:1 Q:'$D(^DIC(42,"AGL",GNL))
 S (DIC,DLAYGO)=42,DIC(0)="AEMQZL",DIC("DR")="44;.015;400///"_GNL
 ;
 D ^DIC K DIC I Y<1 D RESET Q
 S (DIC,DLAYGO)=9009016.5,DIC(0)="L",X=$P(Y,U,2),DINUM=+Y
 D ^DIC I Y<1 D RESET Q
 ;S DDSFILE=9009016.5,DA=+Y,DR="[BDG 9009016.5 SETUP]" D ^DDS
 S DDSFILE=9009016.5,DA=+Y,DR="[BDG 9009016.5 SETUP 2]" D ^DDS  ;IHS/OIT/LJF 04/27/2006 PATCH 1005
 D RESET
 Q
 ;
EDIT ;EP; called by Edit Entry protocol
 NEW X,Y,Z,BDGN,DDSFILE,DA,DR
 D FULL^VALM1
 D EN^VALM2(XQORNOD(0),"OS")
 I '$D(VALMY) Q
 S X=0 F  S X=$O(VALMY(X)) Q:X=""  D
 . S Y=0 F  S Y=$O(^TMP("BDGSYS3",$J,"IDX",Y)) Q:Y=""  D
 .. S Z=$O(^TMP("BDGSYS3",$J,"IDX",Y,0))
 .. Q:^TMP("BDGSYS3",$J,"IDX",Y,Z)=""
 .. I Z=X S BDGN=^TMP("BDGSYS3",$J,"IDX",Y,Z)
 ;
 I 'BDGN D RESET Q
 ;S DDSFILE=9009016.5,DA=BDGN,DR="[BDG 9009016.5 SETUP]" D ^DDS
 S DDSFILE=9009016.5,DA=BDGN,DR="[BDG 9009016.5 SETUP 2]" D ^DDS  ;IHS/OIT/LJF 04/27/2006 PATCH 1005
 D RESET
 Q
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
