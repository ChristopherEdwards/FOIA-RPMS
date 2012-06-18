BAREDP ; IHS/SD/LSL - NO DESCRIPTION PROVIDED ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;; ;
EN ; -- main entry point for BAR ERA Claim Report
 D EN^VALM("BAR ERA Claim Report")
 Q
 ; *********************************************************************
 ;
HDR ; -- header code
 S VALMHDR(1)="This is a test header for BAR ERA Claim Report."
 S VALMHDR(2)="This is the second line"
 Q
 ; *********************************************************************
 ;
INIT ; -- init variables and list array
 F LINE=1:1:30 D SET^VALM10(LINE,LINE_"     Line number "_LINE)
 S VALMCNT=30
 Q
 ; *********************************************************************
 ;
HELP ; -- help code
 S X="?"
 D DISP^XQORM1
 W !!
 Q
 ; *********************************************************************
 ;
EXIT ; -- exit code
 Q
 ; *********************************************************************
 ;
EXPND ; -- expand code
 Q
