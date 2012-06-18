AZHZCLAG ;DSD/PDW - SET AGPATCH NODES FROM EDITS AND PCC/APC ; AUGUST 14, 1992
 ;;1.0;AZHZ;;AUG 14, 1992
 ;
S ;
 S:'$D(DUOUT) DUOUT=0 S:'$D(DFOUT) DFOUT=0
 Q:(DFOUT!DUOUT)
 I '$D(^AZHZTEMP) W *7,!,"< Compiled Edits Global not Present >",! Q
 I ^AZHZTEMP'="",^AZHZTEMP'="AGPATCH" W *7,!,"< Sorry ",^AZHZTEMP," needs to be completed first >",!,*7 G EXIT ;-----
 I '$D(^AZHZTEMP("A",3)) W !,*7,"< Perform Edits must be completed first >",! G EXIT^AZHZCL ;----
 I $D(^AZHZTEMP("A",4,"TRANS COMPLETED")) W !,*7,"<TRANSMISSION sets have already been completed >",! G EXIT ;-----
CON S AZHZHDR="Setting AGPATCH nodes",AZHZRTN="DQTRAN^AZHZCLAG"
 D INIT Q:(DFOUT!DUOUT)  ;-----
DQTRAN ;ENTRY POINT FOR TASKING
 S ^AZHZTEMP="AGPATCH"
 W !,"Listed here are Patients that do not have a HRN at a Facility",!,"compatible with this Site's Area-Service Unit Number",!
 S AZHZSITE=+^AUTTSITE(1,0),AZHZASN=$E($P(^AUTTLOC(AZHZSITE,0),U,10),1,4) D DT^DICRW
 ; set AGPATCH from the Compiled Edits Global
 W !,"Scanning the Compiled Edit Global",!,"EACH DOT = 100 of ",^AZHZTEMP(0),!
 S AZHZCC=0,AZHZPN="" F AZHZXC=0:1 W:'(AZHZXC#100) "." S AZHZPN=$O(^AZHZTEMP("B",AZHZPN)) Q:(DUOUT!DFOUT)  Q:AZHZPN=""  S DFN=0 F  S DFN=$O(^AZHZTEMP("B",AZHZPN,DFN)) Q:(DFOUT!DUOUT)  Q:'DFN  D SET
 W !,?10,AZHZCC," nodes set from the Compiled Edit Global" W ! D ^%T
 I 'DFOUT,'DUOUT S ^AZHZTEMP="",^AZHZTEMP("A",4,"TRANS COMPLETED")=""
 D EXIT^AZHZCL
 Q  ;-----
 ;---------------------------------------------------------------------
SET ;set AGPATCH with Patient site that matches Area/Service number
 D ACTIVE Q:'AZHZAAP  ; do not send inactive patients
 Q:(DFOUT!DUOUT)  Q:$D(^AZHZTEMP("AG",DFN))  Q:$D(^AGPATCH(DT,AZHZSITE,DFN))
TEST I '$D(^AZHZTEMP(DFN,"V")),$O(^AZHZTEMP(DFN,"I",0))=1109,$O(^AZHZTEMP(DFN,"I",1109))="" Q  ;do not set AGPATCH if only tribe quantum was edited 
 I $D(^AUPNPAT(DFN,41,AZHZSITE,0)) S ^AGPATCH(DT,AZHZSITE,DFN)="",AZHZCC=AZHZCC+1 Q  ;-----
 S AZHZS=0 F  S AZHZS=$O(^AUPNPAT(DFN,41,AZHZS)) Q:(DFOUT!DUOUT)  Q:'AZHZS  S AZHZSASN=$E($P(^AUTTLOC(AZHZS,0),U,10),1,4) Q:(DFOUT!DUOUT)  Q:AZHZSASN=AZHZASN  ;matched Area Service Number
T I AZHZS Q:$D(^AGPATCH(DT,AZHZS,DFN))  S ^AGPATCH(DT,AZHZS,DFN)="",AZHZCC=AZHZCC+1 Q  ;----
 E  U IO D AZHZPG W !,DFN,?10,$P(^DPT(DFN,0),U)
E Q  ;-----
 ;---------------------------------------------------------------------
ACTIVE ;ENTRY POINT for testing to see if patient is active
 ;SETS AZHZAAP=1 if patient has active HRN records
 S AZHZAAP=0 I $D(^AUPNPAT(DFN,41,0)),+$O(^(0)) S AZHZAS=0 F  S AZHZAS=$O(^AUPNPAT(DFN,41,AZHZAS)) Q:'+AZHZAS  S:$P(^(AZHZAS,0),U,3)="" AZHZAAP=1
EACT K AZHZAS Q  ;----
 ;---------------------------------------------------------------------
AZHZPG ; page controller
 S:'$D(DUOUT) DUOUT=0 S:'$D(DFOUT) DFOUT=0
 Q:($Y<(IOSL-4))!(DUOUT!DFOUT)  S:'$D(AZHZPG) AZHZPG=0 S AZHZPG=AZHZPG+1 I $E(IOST)="C" R !,"^ to quit ",AZHZX:DTIME I $E(AZHZX)="^" S DUOUT=1,DFOUT=1 Q
AZHZHDR ; Header controller
 W !,@IOF Q:'$D(AZHZHDR)  S:'$D(AZHZLINE) $P(AZHZLINE,"-",IOM-2)="" S:'$D(AZHZPG) AZHZPG=1 I '$D(AZHZDT) D DT^DICRW S Y=DT D DD^%DT S AZHZDT=Y
 U IO W ?(IOM-20-$L(AZHZHDR)/2),AZHZHDR,?(IOM-25),AZHZDT,?(IOM-10),"PAGE: ",AZHZPG,!,AZHZLINE,!
EAZHZPG Q  ;-----
 ;---------------------------------------------------------------------
INIT D INIT^AZHZCL Q  ;-----
 ;---------------------------------------------------------------------
EXIT G EXIT^AZHZCL1 ;-----
 ;---------------------------------------------------------------------
