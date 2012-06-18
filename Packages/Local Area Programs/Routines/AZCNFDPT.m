AZCNFDPT ;RPMS/GTH;** CONVERT NAME FORMAT IN ^DPT ** ; 8/23/88  9:24 AM [ 09/06/88  5:04 PM ]
 ;1;AUG 11, 1988
START W !?5,$P($T(AZCNFDPT),";",3),! K MODE R !,"[R]eport  or  [C]hange?  R//",MODE:$S($D(DTIME):DTIME,1:60) Q:MODE="^"!('$T)  G HELPP:MODE="??",HELP:MODE="?" S MODE=$E(MODE_"R") G:"RrCc"'[MODE START S MODE=$S("Cc"[MODE:1,1:0),PRINT=0 G:MODE QSTART
DEVICE W ! K IOP,%ZIS("B") S %ZIS="FQN" D ^%ZIS K %ZIS I IO="" W !,*7,"No device specified." Q
 I IO=$I,$D(IO("Q"))#2 R !,"Do you really mean queue to this device? NO//",X:360 I "Nn"[$E(X,1) W !!,"Ok, tell me again ..." K IO("Q") G DEVICE
 I $D(IO("Q")) K IO("Q") S PRINT=1,ZTRTN="QSTART^AZCNFDPT",ZTDESC="Name Format in VA PATIENT file." F G="MODE","PRINT" S ZTSAVE(G)=""
 I  D ^%ZTLOAD G ENDQ
 I IO=$I G QSTART
 S IOP=IO D ^%ZIS I 'POP S PRINT=1 G QSTART
 W !,*7,"Device ",IO," busy." G DEVICE
ENDQ K MODE,PRINT,Y,X,DTOUT,DQOUT,DLOUT,DUOUT,DFOUT Q
QSTART ; ENTRY POINT - TaskMan.
 U IO D:'PRINT WAIT^DICD S X="",PG=0 D:PRINT HDR F I=0:0 S X=$O(^DPT("B",X)) Q:X=""  W:'PRINT "." I $F($P(X,",",1)," ") D PROCESS
 W:PRINT @IOF X ^%ZIS("C") K DA,DIE,DFN,DR,ENTRY,I,MODE,PG,PRINT,X,XNEW
 Q
PROCESS S XNEW=$E(X,1,$F(X," ")-2)_","_$P(X,",",2)_","_$E(X,$F(X," "),$F(X,",")-2),DFN=$O(^(X,"")),ENTRY=$O(^(DFN,""))
 W !,"Node # ",DFN,?20,"old : '",X,"'",!?20,"new : '",XNEW,"'",! I PRINT,$Y>59 D HDR
 Q:'MODE!PRINT  R !,"Confirm change <N> ",YN:$S($D(DTIME):DTIME,1:60) S YN=$E(YN_"N") Q:YN="N"
 S DIE="^DPT(",DA=DFN,DR=".01///"_XNEW I ENTRY]"" S DIE=DIE_DFN_",.01,",DA=ENTRY,DA(1)=DFN
 D ^DIE W ?($X+5),"CHANGE COMPLETE.",!
 Q
HDR S PG=PG+1 W @IOF,!!!,"*** ERRORS IN NAME FORMAT IN VA PATIENT FILE ***",?72,"page ",PG,!! W:'MODE "NOTE: This is a report only.  Corrections have not been made.",!
 Q
HELP W !!,"Type 'R' to report the name format errors in '^DPT'",!,"'C' to report them and to correct them,",!,"'??' for more help.",!
 G START
HELPP W !!,"This utility reads through the 'B' index of the VA PATIENT file (^DPT),",!,"looking for names that are in an incorrect format, i.e., 'LNAME II,FNAME M',"
 W !,"  (teknonym out of place)   and corrects their format to 'LNAME,FNAME M,II'.",!!,"Correction of a name requires user confirmation.",!
 G START
ERRORS S DIE="^DPT(277,.01,",DA(1)=277,DA=5,DR=".01///LNAME III,FNAME M" D ^DIE S DIE="^DPT(277,.01,",DA(1)=277,DA=3,DR=".01///JOHNSTON IV,JAMES" D ^DIE S DIE="^DPT(",DA=330,DR=".01///FRI II,BICI" D ^DIE
 Q
