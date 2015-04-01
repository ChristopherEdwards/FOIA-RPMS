BDMPL ; IHS/CMI/LAB - PROBLEM LIST UPDATE ;
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**3,8**;JUN 14, 2007;Build 53
 ;
 ;
EOJ ;cleanup
 D:$D(VALMWD) CLEAR^VALM1 ;clears out all list man stuff
 K ^TMP($J,"BDMPL"),^TMP($J,"APCDPL")
 D EN^XBVK("APCD")
 K XQORNEST,VALMKEY,VALM,VALMAR,VALMBCK,VALMBG,VALMCAP,VALMCNT,VALMOFF,VALMMCON,VALMDN,VALMEVL,VALMIOXY,VALMKEY,VALMLFT,VALMLST,VALMMENU,VALMSGR,VALMUP,VALMWD,VALMY,XQORS,XQORSPEW
 K DFN,BDMLOC,BDMPAT,BDMDATE,BDMPIEN,BDMAF,BDMPRB,APCDOVRR,BDMLOOK,BDMPDFN,APCDPLPT
 Q
EN1 ;EP
EN ;EP  main entry point for BDM PL PROBLEM LIST
 S VALMCC=1 ;1 means screen mode, 0 means scrolling mode
 D EN^VALM("BDM PCC PROBLEM LIST DISPLAY")
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
 K ^TMP($J,"BDMPL")
 S APCDPLPT=DFN
 D GATHER^APCDPL ;gather up all problems FROM PCC
 S VALMCNT=APCDLINE
 S BDMRCNT=APCDRCNT
 M ^TMP($J,"BDMPL")=^TMP($J,"APCDPL")
 ;S VALMCNT=BDMLINE ;this variable must be the total number of lines in list
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
 K ^TMP($J,"BDMPL")
 K BDMRCNT,BDMPL,BDMLINE,BDMX,BDMP0,BDMC,BDML,BDMLR,BDMPIEN,BDMAF,BDMPRB,APCDOVRR,BDMLOOK,BDMPDFN,BDMLOC,BDMDATE,APCDPLPT
 K X,Y
 K VALMHDR
 Q
 ;
EXPND ; -- expand code
 Q
GETPROB ;get record
 S BDMPIEN=0
 I 'BDMRCNT W !,"No problems to select." Q
 S DIR(0)="N^1:"_BDMRCNT_":0",DIR("A")="Select Problem" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) W !!,"No Problem Selected" D PAUSE,EXIT Q
 S BDMP=Y
 S (X,Y)=0 F  S X=$O(^TMP($J,"BDMPL","IDX",X)) Q:X'=+X!(BDMPIEN)  I $O(^TMP($J,"BDMPL","IDX",X,0))=BDMP S Y=$O(^TMP($J,"BDMPL","IDX",X,0)),BDMPIEN=^TMP($J,"BDMPL","IDX",X,Y)
 I '$D(^AUPNPROB(BDMPIEN,0)) W !,"Not a valid PCC PROBLEM." K BDMP S BDMPIEN=0 Q
 D FULL^VALM1 ;give me full control of screen
 Q
 ;
DD ;EP - called from protocol to display (DIQ) a problem in detail
 NEW BDMPIEN
 D GETPROB
 I 'BDMPIEN D PAUSE,XIT Q
 D DIQ^XBLM(9000011,BDMPIEN)
 D XIT
 Q
PAUSE ;EP
 S DIR(0)="EO",DIR("A")="Press return to continue...." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
GETNUM(P) ;EP - get problem number given ien of problem entry
 NEW N,F
 S N=""
 I 'P Q N
 I '$D(^AUPNPROB(P,0)) Q N
 S F=$P(^AUPNPROB(P,0),U,6)
 S N=$S($P(^AUTTLOC(F,0),U,7)]"":$J($P(^(0),U,7),4),1:"??")_$P(^AUPNPROB(P,0),U,7)
 Q N
XIT ;
 K APCDOVRR
 K DLAYGO
 K APCDPIEN
 D TERM^VALM0
 S VALMBCK="R"
 ;D INIT^BDMPL
 ;S VALMCNT=BDMLINE
 ;D HDR^BDMPL
 K BDMTEMP,BDMPRMT,BDMP,BDMPIEN,BDMAF,BDMF,BDMP0,BDMPRB,APCDLOOK,BDMPPTR
 ;D KDIE
 Q
