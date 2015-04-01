AMHPL ; IHS/CMI/LAB - PROBLEM LIST UPDATE ;
 ;;4.0;IHS BEHAVIORAL HEALTH;**2,4**;JUN 18, 2010;Build 28
 ;; ;
 ;
EOJ ;cleanup
 D:$D(VALMWD) CLEAR^VALM1 ;clears out all list man stuff
 K ^TMP($J,"AMHPL"),^TMP($J,"APCDPL")
 D EN^XBVK("APCD")
 K XQORNEST,VALMKEY,VALM,VALMAR,VALMBCK,VALMBG,VALMCAP,VALMCNT,VALMOFF,VALMMCON,VALMDN,VALMEVL,VALMIOXY,VALMKEY,VALMLFT,VALMLST,VALMMENU,VALMSGR,VALMUP,VALMWD,VALMY,XQORS,XQORSPEW
 K DFN,AMHLOC,AMHPAT,AMHDATE,AMHPIEN,AMHAF,AMHPRB,APCDOVRR,AMHLOOK,AMHPDFN,APCDPLPT
 Q
EN1 ;
EN ;EP  main entry point for AMH PL PROBLEM LIST
 S VALMCC=1 ;1 means screen mode, 0 means scrolling mode
 D EN^VALM("AMH PCC PROBLEM LIST")
 D CLEAR^VALM1
 Q
 ;
HDR ;EP -- header code
 S VALMHDR(1)=$TR($J(" ",80)," ","-")
 S VALMHDR(2)="Patient Name: "_IORVON_$P(^DPT(DFN,0),U)_IOINORM_"   DOB: "_$$FTIME^VALM1(AUPNDOB)_"   Sex: "_$P(^DPT(DFN,0),U,2)_"   HRN: "_$S($D(^AUPNPAT(DFN,41,DUZ(2),0)):$P(^AUPNPAT(DFN,41,DUZ(2),0),U,2),1:"????")
 S VALMHDR(3)=$TR($J(" ",80)," ","-")
 Q
 ;
INIT ; -- init variables and list array
 K ^TMP($J,"AMHPL")
 S APCDPLPT=DFN
 D GATHER^APCDPL ;gather up all problems FROM PCC
 S VALMCNT=APCDLINE
 S AMHRCNT=APCDRCNT
 M ^TMP($J,"AMHPL")=^TMP($J,"APCDPL")
 ;S VALMCNT=AMHLINE ;this variable must be the total number of lines in list
 S APCDOVRR="" ;for provider narrative lookup
 Q
 ;
TEXT ;
 ;;Patient Care Component (PCC)
 ;;
 ;;***********************************
 ;;*  View PCC Patient Problem List  *
 ;;***********************************
 ;;
 Q
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP($J,"AMHPL")
 K AMHRCNT,AMHPL,AMHLINE,AMHX,AMHP0,AMHC,AMHL,AMHLR,AMHPIEN,AMHAF,AMHPRB,APCDOVRR,AMHLOOK,AMHPDFN,AMHLOC,AMHDATE,APCDPLPT
 K X,Y
 K VALMHDR
 Q
 ;
EXPND ; -- expand code
 Q
 ;
