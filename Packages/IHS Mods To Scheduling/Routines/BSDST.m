BSDST ; IHS/ANMC/LJF - SCHEDULING TEMPLATES ;
 ;;5.3;PIMS;;APR 26, 2002
 ;
ASK ; ask user for action
 S Y=$$READ^BDGF("SO^1:Add/Edit Templates;2:List Defined Templates","Select Action")
 Q:Y<1  D @Y,ASK Q
 ;
1 ; call FM to edit templates
 S (DIC,DLAYGO)=9009017.3,DIC(0)="AEMQZL" D ^DIC Q:Y<1
 S DIE=DIC,DA=+Y,DR="1:9999" D ^DIE,1 Q
 ;
2 ; call LM to present already defined templates
EN ; -- main entry point for BSDSM SCHED TEMPLATES
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BSDSM SCHED TEMPLATES")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 Q
 ;
INIT ; -- init variables and list array
 NEW NAME,IEN,IEN1,LINE,X
 S VALMCNT=0 K ^TMP("BSDST",$J)
 ; loop in alphabetical order
 S NAME=0 F  S NAME=$O(^BSDST("B",NAME)) Q:NAME=""  D
 . S IEN=$O(^BSDST("B",NAME,0)) Q:'IEN
 . ;  display name of template
 . I VALMCNT>0 D SET("",.VALMCNT)
 . D SET(" "_NAME,.VALMCNT)
 . ;
 . ; loop thru times and display
 . S IEN1=0 F  S IEN1=$O(^BSDST(IEN,1,IEN1)) Q:'IEN1  D
 .. S X=$G(^BSDST(IEN,1,IEN1,0)) Q:X=""
 .. S LINE=$$PAD($$SP(35)_$P(X,U),55)_$P(X,U,2)
 .. D SET(LINE,.VALMCNT)
 Q
 ;
SET(DATA,NUM) ; set data line into display array
 S NUM=NUM+1
 S ^TMP("BSDST",$J,NUM,0)=DATA
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BSDST",$J)
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
