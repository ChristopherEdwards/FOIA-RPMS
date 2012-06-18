BLRDOSE ; IHS/OIT/MKK - EXECUTE CODE FOR DOSE ONLY ; [ 12/19/2005  12:35 PM ]
 ;;5.2;LR;**1021**;Jul 27, 2006
 ;;
 ;; Cloned from DOSE^LREXECU and modified for Dose ONLY.
EP ;
 W !!,$C(7),$C(7),$C(7),!
 W "Run from Label",!!
 Q
 ;;
DOSE ;EP - DOSE/DRAW TIMES
 S %DT("A")="Enter the last dose time: ",%DT="AT" D ^%DT S LRDOSE=Y
 I Y<1 W !,"Time unknown" S %=2 D YN^DICN S:%=1 LRDOSE="UNKNOWN" G:%'=1 DOSE
 I Y>1,Y'["." W !,"You must enter a time, e.g.  T@6AM" G DOSE
 I LRDOSE["." S Y=LRDOSE D DD^LRX S LRDOSE=Y
 S LRCCOM="~Last dose: "_LRDOSE
 W !,LRCCOM
 W !,"OK" S %=1 D YN^DICN G DOSE:%'=1
 K LRDOSE,%DT
 Q
