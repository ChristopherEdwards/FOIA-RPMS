BVPRP ; IHS/ITSC/LJF - RESULTS & PROFILES SUBMENU ;
 ;;1.0;VIEW PATIENT RECORD;;NOV 17, 2004
 ; Called by  BVP RESULTS protocol
 ;
EN ;EP -- main entry point for list template BVP OERR
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BVP RESULTS")
 D CLEAR^VALM1,EXIT
 Q
 ;
HDR ;EP -- header code
 Q
 ;
INIT ;EP -- init variables and list array
 NEW LINE,BVPX
 K ^TMP("BVPRP",$J),^TMP("BVPRP1",$J)
 S LINE=$$PAD($$SP(6)_$$CONFID^BVPU("Patient"),62)_$$USER^BVPU
 S ^TMP("BVPRP",$J,1,0)=LINE
 D ENP^XBDIQ1(9000001,DFN,".01;1101.2;1102.98","BVPX(")
 S LINE=$$PAD($$SP(5)_"Patient: "_BVPX(.01),34)_"  "_$$HRCN^BVPU(DFN)
 S ^TMP("BVPRP",$J,2,0)=LINE
 S LINE=$$PAD($$SP(9)_"Age: "_BVPX(1102.98),40)_"Sex: "_BVPX(1101.2)
 S ^TMP("BVPRP",$J,3,0)=LINE
 S LINE=$$SP(6)_"Status: "_$$STATUS^BVPU(DFN)
 S ^TMP("BVPRP",$J,4,0)=LINE
 S ^TMP("BVPRP",$J,5,0)=""
 S VALMCNT=5
 Q
 ;
HELP ;EP -- help code
 S X="?" D DISP^XQORM1,MSG^BVPU("",2,0,0)
 Q
 ;
EXIT ;EP -- exit code
 K ^TMP("BVPRP",$J),^TMP("BVPRP1",$J)
 Q
 ;
EXPND ;EP -- expand code
 Q
 ;
RESET ;EP -- update display array
 I $D(VALMQUIT) S VALMBCK="Q" Q
 S DFN=BVPSAV D SETPT^BVPMAIN(DFN)   ;make sure patient is still set
 D TERM^VALM0 S VALMBCK="R" D HDR Q
 ;
LABEL ;EP; called by Chart Labels protocol
 I '$G(DFN) S DFN=BVPSAV D SETPT^BVPMAIN(DFN)
 K ^AGCHLB(DUZ),AGTOT
 S ^AGCHLB(DUZ,DFN)="",^AGCHLB(DUZ,"TOT")="",AGTOT=0
 D D^AGCHLB,PAUSE^BVPU
 Q
 ;
ERINQ ;EP called by ER Visit Summary protocol
 I '$G(DFN) S DFN=BVPSAV D SETPT^BVPMAIN(DFN)
 D FULL^VALM1
 I '$D(^AMERVSIT("AC",DFN)) W !!,"No Emergency Room visits on file for patient" D PAUSE^BVPU Q
 W !! S DIC="^AMERVSIT(",DIC(0)="EQ",D="AC",X=DFN
 D IX^DIC K DIC
 S DIC="^AMERVSIT(",BY="NUMBER",(FR,TO)=+Y,FLDS="[CAP"
 D EN1^DIP,PAUSE^BVPU
 Q
 ;
PATINQ ;EP; called by Patient Inquiry protocol
 I '$G(DFN) S DFN=BVPSAV D SETPT^BVPMAIN(DFN)
 D EN^BDGPI
 Q
 ;
SURG ;EP; called by Surgical Pathology Report protocol
 NEW BVPN,ORVP
 D FULL^VALM1,V^LRU,SET^LRAPS3
 S DFN=BVPSAV,ORVP=DFN_";DPT(" D OERR^LRAPS3
 S PNM=$$GET1^DIQ(2,DFN,.01)
 D DT^LRX K DIC,LRTP S LRTP=0,LRDPF=+$P(@("^"_$P(ORVP,";",2)_"0)"),"^",2)_"^"_$P(ORVP,";",2) D END^LRDPA Q:LRDFN<1
 S (LRAA(1),X)="SURGICAL PATHOLOGY",LRSS="SP",LRAA=+$O(^LRO(68,"B",X,0))
 D R^LRAPCUM,V^LRU,PAUSE^BVPU
 Q
 ;
CYTO ;EP; called by Cytology Report protocol
 NEW BVPN,ORVP
 D FULL^VALM1,V^LRU,SET^LRAPS3
 S DFN=BVPSAV,ORVP=DFN_";DPT(" D OERR^LRAPS3
 S PNM=$$GET1^DIQ(2,DFN,.01)
 D DT^LRX K DIC,LRTP S LRTP=0,LRDPF=+$P(@("^"_$P(ORVP,";",2)_"0)"),"^",2)_"^"_$P(ORVP,";",2) D END^LRDPA Q:LRDFN<1
 S (LRAA(1),X)="CYTOPATHOLOGY",LRSS="CY",LRAA=+$O(^LRO(68,"B",X,0))
 D R^LRAPCUM,V^LRU,PAUSE^BVPU
 Q
 ;
BBANK ;EP; called by Blood Back Report protocol
 NEW BVPN,ORVP,HRCN
 D FULL^VALM1,V^LRU
 S DFN=BVPSAV,ORVP=DFN_";DPT(",PNM=$$GET1^DIQ(2,DFN,.01)
 D PID^VADPT,SETPT^BVPMAIN(DFN)
 D DT^LRX K DIC,LRTP S LRTP=0,LRDPF=+$P(@("^"_$P(ORVP,";",2)_"0)"),"^",2)_"^"_$P(ORVP,";",2) D END^LRDPA Q:LRDFN<1
 I '$D(^LR(LRDFN,"BB")) W $C(7),!?3,"No blood bank data for ",PNM D PAUSE^BVPU Q
 S LRLLOC="???",(LRSAV,LR("S"))=1
 D DEV^LRBLPBR,V^LRU,PAUSE^BVPU
 Q
 ;
RAREQ ;EP; called by Radiology Request Details protocol
 NEW ORPK
 S ORPK=$G(DFN) Q:'ORPK
 I '$D(^RAO(75.1,ORPK,0)) W !?3,"No Radiology Requests on file" D PAUSE^BVPU Q
 D ENDIS^RAORD2,PAUSE^BVPU
 Q
 ;
RAPROF ;EP; called by Radiology Profile protocol
 NEW ORVP
 S (ORVP,RADFN)=+DFN,RAHEAD="**** RAD/NUC MED PATIENT EXAMS ****" S (RAF1,RAREPORT)=1
 D ^RAPTLU
 I X["^"!'$D(RADUP) D PAUSE^BVPU Q
 D OERR^RAORDQ,PAUSE^BVPU
 K RAF1,RAREPORT
 Q
 ;
PAD(D,L) ; -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
 ;
