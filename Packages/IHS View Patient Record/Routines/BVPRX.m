BVPRX ; IHS/ITSC/LJF - MEDICATION PROFILES ;
 ;;1.0;VIEW PATIENT RECORD;;NOV 17, 2004
 ; Called by BVP MED PROFILES (Medications) protocol
 ;
EN ;EP -- main entry point for list template BVP RX MENU
 S VALMCC=1 ;1=screen mode, 0=scrolling mode
 NEW VALMCNT D TERM^VALM0
 S ORVP=DFN
 D EN^VALM("BVP RX MENU")
 D CLEAR^VALM1,EXIT
 Q
 ;
HDR ;EP -- header code
 Q
 ;
INIT ;EP -- init variables and list array
 K ^TMP("BVPRX",$J)
 N BVPX D ENP^XBDIQ1(9000001,DFN,".01;1101.2;1102.98","BVPX(")
 S LINE=$$PAD($$SP(5)_"Patient: "_BVPX(.01),34)_"  "_$$HRCN^BVPU(DFN)
 S ^TMP("BVPRX",$J,1,0)=LINE
 S LINE=$$PAD($$SP(9)_"Age: "_BVPX(1102.98),40)_"Sex: "_BVPX(1101.2)
 S ^TMP("BVPRX",$J,2,0)=LINE
 S LINE=$$SP(6)_"Status: "_$$STATUS^BVPU(DFN)
 S ^TMP("BVPRX",$J,3,0)=LINE
 S VALMCNT=3
 Q
 ;
HELP ;EP -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ;EP -- exit code
 K ^TMP("BVPRX",$J)
 Q
 ;
EXPND ;EP -- expand code
 Q
 ;
RESET ;EP -- update partition for return to list manager
 I $D(VALMQUIT) S VALMBCK="Q" Q
 S DFN=BVPSAV D SETPT^BVPMAIN(DFN)   ;make sure patient is still set
 D TERM^VALM0 S VALMBCK="R"
 D INIT,HDR Q
 ;
RESET2 ;EP -- update partition without recreating display array
 I $D(VALMQUIT) S VALMBCK="Q" Q
 D TERM^VALM0 S VALMBCK="R" D HDR Q
 ;
MP ;EP; -- view medication profile
 ; Called by BVP RX MP (Med Profile: Outpatient) protocol
 D FULL^VALM1
 I '$D(^PS(55,DFN,"P")) D  Q
 . D MSG^BVPU("NO PHARMACY INFORMATION ON FILE",2,1,1)
 . D PAUSE^BVPU
 ;
 NEW PLS,PSRT,APSPDPT,APSPBD,APSPED,APSPAGE
 K ^UTILITY($J) D FULL^VALM1
 S APSPDPT(DFN)="",PSRT="DATE",APSPAGE=0,PLS="S"
 S APSPBD=$$READ^BVPU("D^::EXP","Select Earliest Date","T-12M")
 S APSPED=$$READ^BVPU("D^::EXP","Select Latest Date","TODAY")
 S X="APSPMED" X ^%ZOSF("TEST") I $T U IO D P^APSPMED
 D RSETPT
 D PAUSE^BVPU
 Q
 ;
IV ;EP -- calls IV profile
 ; Called by BVP RX IV (Med Profile: IV/Unit Dose) protocol
 D FULL^VALM1
 I '$D(^PS(55,DFN,"P")) D  Q
 . D MSG^BVPU("NO PHARMACY INFORMATION ON FILE",2,1,1)
 . D PAUSE^BVPU
 I $$VERSION^XPDUTL("PSJ")>4.5 D ENOR^PSJPR(DFN),RSETPT Q
 S ORVP=DFN D ENOR^PSJPR,RSETPT
 Q
 ;
PATINFO ;EP  - drug info sheet for a patient
 K PPL,PSOSD,PSODFN,PSORX,PSONUM
 S PSODFN=+DFN,PSORX("NAME")=$$GET1^DIQ(2,DFN,.01)
 S PSOQFLG=0 D ^PSOPTPST I PSOQFLG D PAUSE^BVPU Q  ; Post patient selection routine
 S PSONUM="LIST"
 D EN^APSPNUM I '$D(PSOLIST) D PAUSE^BVPU Q
 S PPL=PSOLIST(1)
 D EN^APSEPPIM
 D PAUSE^BVPU
 Q
 ;
 ;
RSETPT ;EP -- resets patient variables
 S DFN=BVPSAV,ORVP=DFN_";DPT(",DIC=9000001,DIC(0)="M",X="`"_DFN
 D ^DIC Q
 ;
PAD(D,L) ; -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
 ;
