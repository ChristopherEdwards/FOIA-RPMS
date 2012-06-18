BSDL ; ; 13-DEC-2001
 ;; ;
EN ; -- main entry point for BSDRM CREATE VISIT STATUS
 D EN^VALM("BSDRM CREATE VISIT STATUS")
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)="This is a test header for BSDRM CREATE VISIT STATUS."
 S VALMHDR(2)="This is the second line"
 Q
 ;
INIT ; -- init variables and list array
 F LINE=1:1:30 D SET^VALM10(LINE,LINE_"     Line number "_LINE)
 S VALMCNT=30
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
