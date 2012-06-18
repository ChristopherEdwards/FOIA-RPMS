AUPNLKID ; IHS/CMI/LAB - IHS IDENTIFIERS FOR FILE 2 ; [ 05/09/2003  8:01 AM ]
 ;;99.1;IHS DICTIONARIES (PATIENT);**5,9,10,17,18**;JUN 13, 2003
 ;IHS/OIT/LJF 07/21/2006 PATCH 17 hide DOB and SSN if patient is marked as sensitive
 ;
START ; EXTERNAL ENTRY POINT - 
 ;W:$X>45 !
 ;beginning Y2K - display 4 digit year identifier
 ;D:$X>45 EN^DDIOL("","","!") ;Y2000 commented out for 4 digit display of DOB
 D:$X>43 EN^DDIOL("","","!") ;Y2000
 ; VALUE OF THE NAKED INDICATOR TO BE PROVIDED BY CALLING ROUTINE
 ;I $D(DIQUIET) S ^TMP("DILIST",$J,"IHS",DICOUNT)=$P(^(0),U,2)_" "_$E($P(^(0),U,3),4,5)_"-"_$E($P(^(0),U,3),6,7)_"-"_$E($P(^(0),U,3),2,3)_" "_$J($P(^(0),U,9),9) ;IHS/ANMC/LJF 8/7/97 added for Kernel Broker calls-see ^XWBFM ;Y2000
 ;
 ;IHS/OIT/LJF 07/21/2006 hide DOB and SSN if sensitive patient PATCH 17
 ;I $D(DIQUIET) S ^TMP("DILIST",$J,"IHS",DICOUNT)=$P(^(0),U,2)_" "_$E($P(^(0),U,3),4,5)_"-"_$E($P(^(0),U,3),6,7)_"-"_(1700+$E($P(^(0),U,3),1,3))_" "_$J($P(^(0),U,9),9) ;Y2000
 ;IHS/CMI/LAB 10/03/2007, only display last 4 of SSN
 ;I $D(DIQUIET),$L($T(SCREEN^DPTLK1)) S ^TMP("DILIST",$J,"IHS",DICOUNT)=$P(^(0),U,2)_" "_$S($$SCREEN^DPTLK1(Y):" ** SENSITIVE **    ",1:$E($P(^DPT(Y,0),U,3),4,5)_"-"_$E($P(^(0),U,3),6,7)_"-"_(1700+$E($P(^(0),U,3),1,3))_" "_$J($P(^(0),U,9),9))
 ;E  I $D(DIQUIET) S ^TMP("DILIST",$J,"IHS",DICOUNT)=$P(^(0),U,2)_" "_$E($P(^(0),U,3),4,5)_"-"_$E($P(^(0),U,3),6,7)_"-"_(1700+$E($P(^(0),U,3),1,3))_" "_$J($P(^(0),U,9),9) ;Y2000
 I $D(DIQUIET),$L($T(SCREEN^DPTLK1)) D  I 1
 .S ^TMP("DILIST",$J,"IHS",DICOUNT)=$P(^(0),U,2)_" "_$S($$SCREEN^DPTLK1(Y):" ** SENSITIVE **    ",1:$E($P(^DPT(Y,0),U,3),4,5)_"-"_$E($P(^(0),U,3),6,7)_"-"_(1700+$E($P(^(0),U,3),1,3))_" "_$$SSN())
 E  I $D(DIQUIET) D
 .S ^TMP("DILIST",$J,"IHS",DICOUNT)=$P(^(0),U,2)_" "_$E($P(^(0),U,3),4,5)_"-"_$E($P(^(0),U,3),6,7)_"-"_(1700+$E($P(^(0),U,3),1,3))_" "_$$SSN ;Y2000
 ;K AUPNA I '$D(DIQUIET) NEW % S %=$P(^(0),U,2)_" "_$E($P(^(0),U,3),4,5)_"-"_$E($P(^(0),U,3),6,7)_"-"_$E($P(^(0),U,3),2,3)_" "_$J($P(^(0),U,9),9) S AUPNA(1)=%,AUPNA(1,"F")="?45" ;Y2000 commented out and replaced with line below
 ;K AUPNA I '$D(DIQUIET) NEW % S %=$P(^(0),U,2)_" "_$E($P(^(0),U,3),4,5)_"-"_$E($P(^(0),U,3),6,7)_"-"_(1700+$E($P(^(0),U,3),1,3))_" "_$J($P(^(0),U,9),9) S AUPNA(1)=%,AUPNA(1,"F")="?43" ;Y2000 - display 4 digit year
 K AUPNA
 I '$D(DIQUIET),$L($T(SCREEN^DPTLK1)) D
 . ;IHS/CMI/LAB 10/03/2007 display only last 4 of SSN
 . ;NEW % S %=$P(^(0),U,2)_" "_$S($$SCREEN^DPTLK1(Y):" ** SENSITIVE **    ",1:$E($P(^DPT(Y,0),U,3),4,5)_"-"_$E($P(^(0),U,3),6,7)_"-"_(1700+$E($P(^(0),U,3),1,3))_" "_$J($P(^(0),U,9),9)) S AUPNA(1)=%,AUPNA(1,"F")="?43"
 . NEW % S %=$P(^(0),U,2)_" "_$S($$SCREEN^DPTLK1(Y):" ** SENSITIVE **    ",1:$E($P(^DPT(Y,0),U,3),4,5)_"-"_$E($P(^(0),U,3),6,7)_"-"_(1700+$E($P(^(0),U,3),1,3))_" "_$$SSN) S AUPNA(1)=%,AUPNA(1,"F")="?43"
 ;E  K AUPNA I '$D(DIQUIET) NEW % S %=$P(^(0),U,2)_" "_$E($P(^(0),U,3),4,5)_"-"_$E($P(^(0),U,3),6,7)_"-"_(1700+$E($P(^(0),U,3),1,3))_" "_$J($E($P(^(0),U,9),6,9),9) S AUPNA(1)=%,AUPNA(1,"F")="?43" ;Y2000 - display 4 digit year
 E  K AUPNA I '$D(DIQUIET) NEW % S %=$P(^(0),U,2)_" "_$E($P(^(0),U,3),4,5)_"-"_$E($P(^(0),U,3),6,7)_"-"_(1700+$E($P(^(0),U,3),1,3))_" "_$$SSN S AUPNA(1)=%,AUPNA(1,"F")="?43" ;Y2000 - display 4 digit year
 ;IHS/OIT/LJF 07/21/2006 end of PATCH 17 mod
 ;
 ;end Y2K for display of  4 digit DOB
 I '$D(DIQUIET) S AUPNA(1)=$$CWAD(Y)_AUPNA(1),AUPNA(1,"F")="?37"
 I $D(DUZ(2))#2,DUZ(2),'$D(DIQUIET) I $D(^AUPNPAT(Y,41,DUZ(2),0)) NEW % S %=" "_$J($P(^AUTTLOC(DUZ(2),0),U,7),4)_" "_$P(^AUPNPAT(Y,41,DUZ(2),0),U,2) S AUPNA(1)=AUPNA(1)_" "_%
 I $D(DUZ(2))#2,'DUZ(2),$D(^AUPNPAT(Y,41)) D CHARTS
 S:$D(DDS) DDSID=1 D EN^DDIOL(.AUPNA) K AUPNA,DDSID
 W @("$E("_DIC_"Y,0),0)") ; reset the naked
 Q
 ;
CHARTS ;
 S AUPNLKF=0
 NEW C S C=1 F AUPNLKI=0:1 S AUPNLKF=$O(^AUPNPAT(Y,41,AUPNLKF)) Q:AUPNLKF'=+AUPNLKF  D
 .I AUPNLKI S C=C+1
 .;beginning Y2K display 4 digit DOB spacing
 .;NEW % S %=" "_$J($P(^AUTTLOC(AUPNLKF,0),U,7),4)_" "_$P(^AUPNPAT(Y,41,AUPNLKF,0),U,2)_$S($P(^(0),U,3)="":"",1:"("_$P(^(0),U,5)_")");Y2000 commented out for 4 digit year display
 .NEW % S %=$J($P(^AUTTLOC(AUPNLKF,0),U,7),4)_" "_$P(^AUPNPAT(Y,41,AUPNLKF,0),U,2)_$S($P(^(0),U,3)="":"",1:"("_$P(^(0),U,5)_")") ;Y2000 
 .;end Y2K
 .S:'$D(AUPNA(C)) AUPNA(C)=""
 .S AUPNA(C)=AUPNA(C)_" "_% S:'$D(AUPNA(C,"F")) AUPNA(C,"F")="!?65"
 K AUPNLKF,AUPNLKI
 Q
 ;
IHSDUPE ; EXTERNAL ENTRY PONT - FOLLOW MERGE CHAIN
 ; VALUE OF THE NAKED INDICATOR TO BE PROVIDED BY CALLING ROUTINE
 F AUPLKL=0:0 Q:'$P(^(0),U,19)  S AUPMAP=$P(^(0),U,19) D EN^DDIOL("<Merged to "_$P(^DPT(AUPMAP,0),U,1)_">","","!?10") ; Will abort if no ^DPT entry
 K AUPLKL
 I $D(AUPMAP) S AUPMAPY=Y,Y=AUPMAP K AUPMAP
 W @("$E("_DIC_"Y,0),0)") ; reset the naked
 Q
 ;
CWAD(Y) ; -- returns cwad initials;IHS/ANMC/LJF 5/26/98
 NEW X,DFN,GMRPCWAD
 S X="GMRPNOR1" X ^%ZOSF("TEST") I '$T Q "   "
 S X=$$CWAD^GMRPNOR1(+Y) I '$L(X) Q "   "
 S X="<"_X_">",X=$E(X_"   ",1,7)
 Q X
SSN() ;
 Q $S($L($P(^(0),U,9))=9:$J("XXX-XX-"_$E($P(^(0),U,9),6,9),11),1:$J($P(^(0),U,9),11))
 ;
