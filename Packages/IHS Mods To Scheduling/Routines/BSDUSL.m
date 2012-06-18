BSDUSL ; IHS/ANMC/LJF - DISPLAY USER LIST TEMPLATE ;
 ;;5.3;PIMS;;APR 26, 2002
 ;
EN ; -- main entry point for list template 
 I IOST'["C-" D DISP^BSDUSR Q    ;to print on paper
 D EN^VALM("BSDSM USER DISPLAY")
 Q
 ;
HDR ; -- header code
 Q
 ;
INIT ; -- init variables and list array
 D DISP^BSDUSR
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
