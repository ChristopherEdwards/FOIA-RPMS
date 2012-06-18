PSOLMPO ;ISC-BHAM/LC - pending orders ; 13-MAR-1995
 ;;7.0;OUTPATIENT PHARMACY;**46**;DEC 1997
EN ; -- main entry point for PSO LM PENDING ORDER
 S PSOLMC=0 D EN^VALM("PSO LM PENDING ORDER") K PSOLMC
 Q
 ;
HDR ; -- header code
 D HDR^PSOLMUTL
 Q
 ;
INIT ; -- init variables and list array
 ;F LINE=1:1:30 D SET^VALM10(LINE,LINE_"     Line number "_LINE)
 S VALMCNT=IEN,VALM("TITLE")="Pending OP Orders ("_$S($P(OR0,"^",14)="S":"STAT",$P(OR0,"^",14)="E":"EMERGENCY",1:"ROUTINE")_")"
 D RV^PSONFI Q
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
