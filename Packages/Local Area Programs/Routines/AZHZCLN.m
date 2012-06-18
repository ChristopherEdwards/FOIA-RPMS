AZHZCLN ;DSD/PDW - MASTER ROUTINE TO CLEAN THE VA/IHS PATIENT BASE ; AUGUST 14, 1992
 ;;1.0;AZHZ;;AUG 14, 1992
 ;;
S ;       
 D DT^DICRW S IOP="HOME" D ^%ZIS
 K AZHZIOP
DUZ I '$G(DUZ) W !,"You must identify yourself first .. Please ?",! D ^XUP I '$G(DUZ) Q
 S DIR(0)="S^1:Scan & Compile Edits to Perform;2:Print Edits to Perform;3:Perform Edits;4:Set Trans' Nodes;5:Print ()&/ Edits;6:Kill Edits Global;7:EXIT;8:Restore Compiled Edits Global;9:Restore Data Base;10:VIEW;11:FACE;12:STEPS 1-5"
 S DIR("B")=0 I $D(^AZHZTEMP("A")) S X=0 F  S X=$O(^AZHZTEMP("A",X)) Q:'X  S DIR("B")=X
 S DIR("B")=DIR("B")+1
 D ^DIR S AZHZMEN=X Q:("^"[$E(X))
 I $D(DTOUT),DTOUT Q
 I +X'=X W !,*7,"Please use the Numbers",! G S
 G:X=12 ALL
 S (DUOUT,DFOUT)=0
 D @($P("^AZHZCL;;PRT^AZHZCL;;SET^AZHZCL;;^AZHZCLAG;;PUNC;;KILL^AZHZCL;;EXIT^AZHZCL;;RES^AZHZCLN;;PULL^AZHZCL;;VIEW;;FAC;;ALL",";;",X))
 G:AZHZMEN'=7 S
 D ^%ZISC D EXIT K AZHZMEN,AZHZIOP Q  ;-----
 ;----------------------------------------------------------------------
SAV ;ENTRY POINT save Compiled Edits Global
 I '$D(^AZHZSAV) W !,"SAVING IMAGE",! S %X="^AZHZTEMP(",%Y="^AZHZSAV(" D %XY^%RCR Q  ;-----
 Q
 ;----------------------------------------------------------------------
RES ;ENTRY POINT restore Compiled Edits Global
 I '$D(^AZHZSAV) W *7,"<< ERROR .. ^AZHZSAV does not exist ! >>",! Q  ;-----
 K ^AZHZTEMP ;kill temp global prior to restore
 S %X="^AZHZSAV(",%Y="^AZHZTEMP(" D %XY^%RCR S ^AZHZTEMP=""
 Q  ;-----
 ;----------------------------------------------------------------------
VIEW ; VIEW ANY PATIENT
 S AUPNLK("ALL")="" D ^AGSEENLY
 K AUPNLK("ALL") Q  ;-----
FAC ; FACE SHEET PRINT
 S X="AGFACE",AUPNLK("ALL")="" D HDR^AG,^AGVAR:'$D(AGOPT),^AGFACE
 K AUPNLK("ALL") Q  ;-----
 ;----------------------------------------------------------------------
PUNC ;EP
PUNPRT ;ENTRY POINT to print names that had punctuation "()&/" removed
 S:'$D(DUOUT) DUOUT=0 S:'$D(DFOUT) DFOUT=0
 Q:(DUOUT!DFOUT)  ;-----
 I '$D(^AZHZTEMP) W *7,!,"<NO Compiled Edits Global Present>",! Q
 I ^AZHZTEMP'="" W *7,!,"< Sorry ",^AZHZTEMP," needs to be completed first >",!,*7 G EXIT ;----
 I '$D(^AZHZTEMP("A",1)) W !,*7,"< SCAN must be completed first > ",! G EXIT ;-----
 S AZHZHIT=0,AZHZSET="O",AZHZHDR="IHS/VA PATIENT ( ) & / REPORT",AZHZRTN="DQPPRT^AZHZCLN"
 D INIT Q:(DFOUT!DUOUT)
DQPPRT ;ENTRY POINT FOR TASKING   
 Q:(DUOUT!DFOUT)  ;-----
 S DFN=0 F AZHZCC=0:1 S DFN=$O(^AZHZTEMP("P",DFN)) Q:'+DFN
 S ^AZHZTEMP("P",0)=AZHZCC,DFN=0
 W !,"THERE ARE ",^AZHZTEMP("P",0)," PATIENTS TO PRINT",!,"STARTING AT " D ^%T W !
 W !," Patient Name     : DFN",!,"     Old Data to be Corrected     : New Data Corrections ",!!
23 F  S DFN=$O(^AZHZTEMP("P",DFN)) Q:'+DFN  D
 .U IO D AZHZPG W:'AZHZHIT !,^AZHZTEMP(DFN),?35,DFN
 .F AZHZN="I","V" D DOIT2^AZHZCL1
 .D OTH^AZHZCL1
EPUN G EXIT ;----
 ;----------------------------------------------------------------------
ALL ; perform steps 1-5 
 W !,"This will automatically process steps 1-5 and then exit"
 W !,"It is advised that a printer type device be selected",!
 K AZHZIOP,ZTSK S AZHZRTN="DQALL^AZHZCLN"
 D INIT^AZHZCL S AZHZIOP=ION_";"_IOST_";"_IOM_";"_IOSL
 I (DUOUT!DFOUT!POP) K AZHZIOP,AZHZMEN D EXIT Q  ;-----
 I $D(ZTSK) K AZHZIOP,AZHZMEN D EXIT Q  ;-----
 ;
DQALL ;ENTRY POINT FOR TASKING
 D ^AZHZCL,PRT^AZHZCL,SET^AZHZCL,^AZHZCLAG,PUNC^AZHZCLN
 D ^%ZISC K AZHZIOP,AZHZMEN
 Q
 ;----------------------------------------------------------------------
QUE ;ENTRY POINT from the INIT^AZHZCL1
 ;the routine entry for tasking is held in the variable AZHZRTN
 S ZTRTN="DEQUE^AZHZCLN",ZTDESC="QUE OF AZHZCLEAN "_AZHZRTN,ZTSAVE("AZHZ*")=""
 S AZHZIOP=ION_";"_IOST_";"_IOM_";"_IOSL
 I ION["HOST" S AZHZ("IOPAR")=IOPAR
 D ^%ZTLOAD,^%ZISC I $G(ZTSK) W !,"Tasked with number : ",ZTSK,!
 Q
 ;----------------------------------------------------------------------
DEQUE ;ENTRY POINT FOR DEQUE
 ;the routine entry for tasking is held in the variable AZHZRTN
 I ION["HOST",$D(AZHZ("IOPAR")) S IOP=ION,%ZIS("IOPAR")=AZHZ("IOPAR") D ^%ZIS
 D INIT^AZHZCL1,@AZHZRTN D EXIT^AZHZCL1
 Q
 ;----------------------------------------------------------------------
EXIT D EXIT^AZHZCL1 Q
 ;----------------------------------------------------------------------
INIT D INIT^AZHZCL1 Q
 ;----------------------------------------------------------------------
AZHZPG D AZHZPG^AZHZCL Q
 ;----------------------------------------------------------------------
