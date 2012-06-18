BDGSYS6 ; IHS/ANMC/LJF - MAIL GROUPS ON BULLETINS ; 
 ;;5.3;PIMS;;APR 26, 2002
 ;
EN ; -- main entry point for BDG SYS BULLETIN
 NEW VALMCNT
 D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BDG SYS BULLETIN")
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
 NEW NAME,IEN,COUNT,LINE,IEN2
 S VALMCNT=0
 K ^TMP("BDGSYS6",$J)
 S NAME="BDG"
 F  S NAME=$O(^XMB(3.6,"B",NAME)) Q:NAME=""  Q:$E(NAME,1,3)'="BDG"  D
 . S IEN=0
 . F  S IEN=$O(^XMB(3.6,"B",NAME,IEN)) Q:'IEN  D
 .. S COUNT=$G(COUNT)+1
 .. S LINE=$J(COUNT,2)_". "_$$GET1^DIQ(3.6,IEN,.01)      ;bulletin name
 .. S IEN2=$O(^XMB(3.6,IEN,2,0)) I IEN2 D
 ... S LINE=$$PAD(LINE,32)_$$GET1^DIQ(3.62,IEN2_","_IEN,.01)  ;mail grp
 .. D SET(LINE,COUNT,IEN,.VALMCNT)
 .. ;
 .. ; print more lines if >1 mail group on bulletin
 .. Q:'IEN2  F  S IEN2=$O(^XMB(3.6,IEN,2,IEN2)) Q:'IEN2  D
 ... S LINE=$$SP(32)_$$GET1^DIQ(3.62,IEN2_","_IEN,.01)
 ... D SET(LINE,COUNT,IEN,.VALMCNT)
 ;
 I '$D(^TMP("BDGSYS6",$J)) D
 . D SET("*** NO ADT BULLETINS FOUND!! ***",0,0,.VALMCNT)
 Q
 ;
SET(DATA,NUM,N,LINE) ; put display line into array
 S LINE=LINE+1
 S ^TMP("BDGSYS6",$J,LINE,0)=DATA
 S ^TMP("BDGSYS6",$J,"IDX",LINE,NUM)=N
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BDGSYS6",$J)
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
 NEW X,Y,Z,BDGN,DIE,DA,DR,DLAYGO
 D FULL^VALM1
 D EN^VALM2(XQORNOD(0),"OS")
 I '$D(VALMY) Q
 S X=0 F  S X=$O(VALMY(X)) Q:X=""  D
 . S Y=0 F  S Y=$O(^TMP("BDGSYS6",$J,"IDX",Y)) Q:Y=""  D
 .. S Z=$O(^TMP("BDGSYS6",$J,"IDX",Y,0))
 .. Q:^TMP("BDGSYS6",$J,"IDX",Y,Z)=""
 .. I Z=X S BDGN=^TMP("BDGSYS6",$J,"IDX",Y,Z)
 ;
 I 'BDGN D RESET Q
 W !,"BULLETIN: ",$$GET1^DIQ(3.6,BDGN,.01),!
 S DIE=3.6,DA=BDGN,DR=4 D ^DIE
 D RESET
 Q
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
 ;
