BDGICR3 ; IHS/ANMC/LJF - IC REPORT ; 
 ;;5.3;PIMS;;APR 26, 2002
 ;; ;
 W !!,"Sorry, not written yet."
 W !,"Specs:  For a provider, count # of times has delinquent charts"
 W !,"over time. Count when Date Resolved > Date Delinquent or when"
 W !,"Date Resolved is blank and Date Deleted not entered.  Count each"
 W !,"admission once."
 D PAUSE^BDGF Q
 ;
EN ; -- main entry point for BDG IC INPT BY PATIENT
 D EN^VALM("BDG ??????????????????")
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)="This is a test header for BDG IC INPT BY PATIENT."
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
