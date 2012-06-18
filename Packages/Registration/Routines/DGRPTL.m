DGRPTL ;ALB/RMO - 10-10T Registration - List Manager Screen;24 DEC 1996 10:00 am
 ;;5.3;Registration;**108**;08/13/93
 ;
EN(DFN,DGRPTOUT) ; -- main entry point to invoke the DGRPT 10-10T REGISTRATION protocol
 ; Input --  DFN      Patient IEN
 ; Output -- DGRPTOUT User entered '^' or timeout
 D WAIT^DICD
 D EN^VALM("DGRPT 10-10T REGISTRATION")
 Q
 ;
HDR ; -- header code
 N X,VA
 D PID^VADPT
 S VALMHDR(1)=$P($G(^DPT(DFN,0)),U,1)_"; "_VA("PID")
 S X=$S('$D(^DPT(DFN,"TYPE")):"PATIENT TYPE UNKNOWN",$D(^DG(391,+^("TYPE"),0)):$P(^(0),U,1),1:"PATIENT TYPE UNKNOWN")
 S VALMHDR(1)=$$SETSTR^VALM1(X,VALMHDR(1),60,80)
 Q
 ;
INIT ; -- init variables and list array
 D BLD
 Q
 ;
BLD ; -- build 10-10T registration screen
 D CLEAN^VALM10
 D HDR
 D EN^DGRPTL1("DGRPT",DFN,.VALMCNT)
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 D CLEAN^VALM10,CLEAR^VALM1
 Q
 ;
EXPND ; -- expand code
 Q
 ;
