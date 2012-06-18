BLRASP ;MTK/CR-ListMan program for Lab Results [ 11/18/2002  1:39 PM ]
 ;;5.2;LR;**1013,1015**;NOV 18, 2002
 ;; ;
EN ;EP
 ; -- main entry point for BLRASP
 D EN^VALM("BLRASP")
 Q
 ;
HDR ; -- header code
 D HDR^BLRALBA
 Q
 ;
INIT ; -- init variables and list array
 ;F LINE=1:1:30 D SET^VALM10(LINE,LINE_"     Line number "_LINE)
 ;S VALMCNT=30
 ;D CLEAN^VALM10    ;CLEARS SCREEN BEFORE DISPLAY
 ;S LINENUM=0
 ;F  S LINENUM=$O(^TMP($J,"BLRA",LINENUM)) Q:LINENUM=""  D
 ;. S LINEDATA=$G(^TMP($J,"BLRA",LINENUM,0))
 ;. D SET^VALM10(LINENUM,LINEDATA)
 ;S VALMCNT=LINENUM
 ;I LINENUM=0 S VALMSG="No Lab Results to be displayed at this time"
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
