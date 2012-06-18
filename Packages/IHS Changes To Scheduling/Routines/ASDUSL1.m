ASDUSL1 ; IHS/ADC/PDW/ENM - DISPLAY USER SETUP ; [ 03/25/1999  11:48 AM ]
 ;;5.0;IHS SCHEDULING;;MAR 25, 1999
 ;
EN ; -- main entry point for SD IHS USER DISPLAY
 D EN^VALM("SD IHS USER DISPLAY")
 Q
 ;
HDR ; -- header code
 Q
 ;
INIT ; -- init variables and list array
 D DISP^ASDUSR1
 S VALMCNT=ASDLN
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
