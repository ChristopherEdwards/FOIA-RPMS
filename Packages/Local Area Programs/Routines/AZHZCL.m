AZHZCL ;DSD/PDW - CLEAN PATIENT DATA BASE ; AUGUST 14, 1992
 ;;1.0;AZHZ;;AUG 14, 1992
 ;;
S ;
 S:'$D(DUOUT) DUOUT=0 S:'$D(DFOUT) DFOUT=0
 Q:(DUOUT!DFOUT)  ;----
 Q:'$D(^AUTTSITE(1,0))  S AZHZSITE=+^(0),U="^"
 I $P(^AUTTLOC(+^AUTTSITE(1,0),0),U,10)]"" S AZHZ("LOC")=$E($P(^(0),U,10),1,4),AZHZ("L")=0
 I '$D(AZHZ("LOC")) W !,"Site and Area not specified for facility <Fatal Error>",! S (DUOUT,DFOUT)=1 Q
 I $D(^AZHZTEMP("A",1)) W !,*7,"< SCAN has already been Completed >",! G EXIT ;-----
 S AZHZHIT=0,AZHZHDR=" IHS/VA DATA BASE PATIENT CLEAN",AZHZRTN="DQSCAN^AZHZCL"
 D INIT Q:(DFOUT!DUOUT)
DQSCAN ;ENTRY POINT FOR TASKING
 S ^AZHZTEMP="SCAN"
 W "Each dot =100 patients:",!,"Running for ",AZHZSITE,":",$P(^AUTTLOC(AZHZSITE,0),"^",2)," Area and Service : ",AZHZ("LOC"),!
 S AZHZ("B")="" S:$D(^AZHZTEMP("LDFN")) AZHZ("B")=^("LDFN"),AZHZ("B")=$E(AZHZ("B"),1,($L(AZHZ("B"))-1)) ; pick up at last completed patient
IEN F AZHZZ("I")=1:1 S AZHZ("B")=$O(^DPT("B",AZHZ("B"))) Q:(DFOUT!DUOUT)  Q:AZHZ("B")=""  S DFN=0 F  S DFN=$O(^DPT("B",AZHZ("B"),DFN)) Q:(DFOUT!DUOUT)  Q:'DFN  D SCDFN S ^AZHZTEMP("LDFN")=AZHZ("B") W:'(AZHZZ("I")#100) "."
 ;
BINDEX S DFN=0 K ^AZHZTEMP("B") F AZHZCC=0:1 S DFN=$O(^AZHZTEMP(DFN)) Q:'DFN  S ^AZHZTEMP("B",^(DFN),DFN)=""
 S ^AZHZTEMP(0)=AZHZCC W !!,AZHZZ("I")," Patient Names Scanned with ",AZHZCC," set for error corrections"
 I '(DFOUT!DUOUT) S ^AZHZTEMP="",^AZHZTEMP("A",1,"SCAN COMPLETE")="" K ^AZHZTEMP("LDFN") D SAV^AZHZCLN
 G EXIT ;----
 ;
 ;-------------------------------
SCDFN ;ENTRY POINT scan DFN for data errors, VA and IHS checks
 I '$D(^DPT(DFN,0)) K ^DPT("B",AZHZ("B"),DFN) Q
 Q:($P(^DPT(DFN,0),U,19))  ;quit if Merge Patient has TO DFN in 19th peice
 D ^AZHZCLV ;perform VA DPT edits 
 I $D(^AUPNPAT(DFN,0)) D ^AZHZCLI ;perform IHS patient edits
 S:$D(^AZHZTEMP(DFN)) ^AZHZTEMP(DFN)=$P(^DPT(DFN,0),U)
ESCDFN Q  ;-----
 ;-------------------------------
SET ; ENTRY POINT: perform sets
 S:'$D(DUOUT) DUOUT=0 S:'$D(DFOUT) DFOUT=0
 Q:(DFOUT!DUOUT)  ;----
 Q:'$D(^AUTTSITE(1,0))  S AZHZSITE=+^(0),U="^"
 I '$D(^AZHZTEMP) W *7,!,"<NO Compiled Edits Global Present>",! Q
 I ^AZHZTEMP]"",^AZHZTEMP'="SET" W !,"SORRY ... ",^AZHZTEMP," NEEDS TO BE COMPLETED FIRST",! G EXIT ;----
 I $D(^AZHZTEMP("A",3)) W !,"< EDITS have already been Completed >",!,*7 G EXIT ;-----
 W !,"There are only dots printed for this option",!
 S AZHZHIT=1,AZHZSET="N",AZHZHDR="IHS/VA PATIENT DATA BASE EDITS",AZHZRTN="DQSET^AZHZCL"
 D INIT Q:(DFOUT!DUOUT)
DQSET ;ENTRY POINT FOR TASKING
 S ^AZHZTEMP="SET",DFN=0 K ^AZHZTEMP("P")
 W !,"EACH DOT =100 PATIENTS SET. THERE ARE ",^AZHZTEMP(0)," PATIENTS TO PROCESS",!,"STARTING AT " D ^%T W ! D DOIT
 I '(DFOUT!DUOUT) S ^AZHZTEMP="",^AZHZTEMP("A",3,"EDITS COMPLETED")="" K ^AZHZTEMP("LDFN")
 ;K ^AZHZSAV S %X="AZHZTEMP(",%Y="^AZHZSAV(" D %XY^%RCR
 G EXIT ;----
 ;-------------------------------
PULL ;ENTRY POINT: set data back to previous state
 I '$D(^AZHZTEMP) W *7,!,"<NO Compiled Edits Global Present>",! Q
 I ^AZHZTEMP]"",^AZHZTEMP'="PULL" W !,"SORRY ... ",^AZHZTEMP," NEEDS TO BE COMPLETED FIRST",! G EXIT ;----
Q W !,"This will put data fields back to their incorrect forms.",!,"Are you sure you want to proceed ? " S %=2 D YN^DICN
 I (%=2)!(%=-1) S DUOUT=1 G EXIT ;----- 
 G:%<1 Q
 S AZHZHIT=1,AZHZSET="O",AZHZHDR="IHS/VA PATIENT DATA BASE RESTORE",AZHZRTN="DQPULL^AZHZCL" D INIT Q:(DFOUT!DUOUT)
DQPULL ;ENTRY POINT FOR TASKING
 S ^AZHZTEMP="PULL",DFN=0
 W !,"EACH DOT =100 PATIENTS SET. THERE ARE ",^AZHZTEMP(0)," PATIENTS TO PROCESS",!,"STARTING AT " D ^%T W ! D DOIT
 S ^AZHZTEMP="" K ^AZHZTEMP G EXIT ;----kills old temp global prior to restore
 ;-------------------------------
PRT ;ENTRY POINT: print report of edits to be performed
 S:'$D(DUOUT) DUOUT=0 S:'$D(DFOUT) DFOUT=0
 Q:(DUOUT!DFOUT)  ;-----
 I '$D(^AZHZTEMP) W *7,!,"<NO Compiled Edits Global Present>",! Q
 I ^AZHZTEMP'="" W *7,!,"< Sorry ",^AZHZTEMP," needs to be completed first >",!,*7 G EXIT ;----
 I '$D(^AZHZTEMP("A",1)) W !,*7,"< SCAN must be completed First > ",! G EXIT ;-----
 S AZHZHIT=0,AZHZSET="O",AZHZHDR="IHS/VA PATIENT DATA BASE EDIT REPORT",AZHZRTN="DQPRT^AZHZCL"
 D INIT Q:(DFOUT!DUOUT)
DQPRT ;ENTRY POINT FOR TASKING   
 S DFN=0
 W !,"THERE ARE ",^AZHZTEMP(0)," PATIENTS TO PRINT",!,"STARTING AT " D ^%T W !
 W !," Patient Name     : DFN",!,"     Old Data to be Corrected     : New Data Corrections ",!!
 D DOIT S ^AZHZTEMP("A",2,"PRINTS PERFORMED")=""
EPRT G EXIT ;----
 ;-------------------------------
KILL ;ENTRY POINT  kill ^AZHZTEMP
 I '$D(^AZHZTEMP) W *7,!,"<NO Compiled Edits Global Present>",! Q
 I '$D(^AZHZTEMP("A",4)) W !,*7,"<AGPATCH HAS NOT BEEN SET YET>",!,*7 Q
 K ^AZHZTEMP ;kill temp global
 Q  ;----
 ;-------------------------------
AZHZPG ;EP
 D AZHZPG^AZHZCL1 Q
 ;-------------------------------
DOIT D ^AZHZCL1 Q
 ;-------------------------------
INIT ;EP
 D INIT^AZHZCL1 Q
 ;-------------------------------
EXIT ;EP
 D EXIT^AZHZCL1 Q
 ;-------------------------------
