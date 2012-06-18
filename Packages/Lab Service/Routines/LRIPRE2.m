LRIPRE2 ;DALISC/J0 - PURGE OBSOLETE WORKLOAD DATA
 ;;5.2;LR;;NOV 01, 1997
 ;
 ;;5.2;LAB SERVICE;;Sep 27, 1994
 ;
EN ;
 Q:'$D(DIFQ)
 N LREND
 D INIT
 D:'LREND PURGE
 D WRAPUP
 Q
INIT ;
 S LREND=0
 W !!,"This task is optional.  It is intended for test sites who have workload ",!
 W "code entries in a format which is now obsolete.  If you select this task, ",!
 W "files 64.03, 64.1, 64.2 and 67.9 will be erased.  In addition the workload ",!
 W "code entries for the following files will also be erased:  Execute Code ",!
 W "(62.07), Etiology (61.2) & Collection Sample (62).",!
 W !!
 K DIR,X,Y S DIR(0)="S^Y:YES;N:NO",DIR("B")="NO"
 S DIR("A")="Are you sure you want to do this??"
 S DIR("?")="Enter 'NO' or '^' or RETURN to skip this optional task."
 S DIR("?",1)="Enter 'YES' to purge existing workload code entries."
 S DIR("?",2)=""
 D ^DIR
 I (Y="N")!($D(DTOUT))!($D(DUOUT)) S LREND=1 Q
 W !!,"I think I heard you wrong, wouldn't you rather skip this and go for a",!
 W "soda or something?",!
 K DIR,X,Y S DIR(0)="S^Y:YES;N:NO",DIR("B")="YES"
 S DIR("A")="Skip task?"
 S DIR("?")="Enter 'YES' or '^' or RETURN to skip this optional task."
 S DIR("?",1)="Enter 'No' to proceed with purge."
 S DIR("?",2)=""
 D ^DIR
 I (Y="Y")!($D(DTOUT))!($D(DUOUT)) S LREND=1 Q
 W !!,"OK, OK, but remember, you asked for this...(twice even)",!
 Q
PURGE ;
 W !,"Deleting file 67.9, LAB Monthly Workloads.....",!
 K ^LRO(67.9) S ^LRO(67.9,0)="LAB MONTHLY WORKLOADS^67.9P^^"
 ;
 W !,"Deleting file 64.1, Workload [WKLD] Data.....",!
 K ^LRO(64.1) S ^LRO(64.1,0)="WORKLOAD [WKLD] DATA^64.1P^^"
 ;
 W !,"Deleting file 64.2, WKLD Suffix Codes.....",!
 K ^LAB(64.2) S ^LAB(64.2,0)="WKLD SUFFIX CODES^64.2I^^"
 ;
 W !,"Deleting file 64.03, WKLD LOG FILE.....",!
 K ^LRO(64.03) S ^LRO(64.03,0)="WKLD LOG FILE^64.03^"
 ;
 W !,"Cleaning file 62.07, Execute Code.....",!
 D CLNEX
 W !,"Cleaning file 61.2, Etiology.....",!
 D CLNET
 W !,"Cleaning file 62, Collection Sample.....",!
 D CLNCS
 W !,"Workload data cleaning task completed.",!
 ;
 Q
CLNEX ;
 N J
 F J=0:0 S J=$O(^LAB(62.07,J)) Q:'J  K ^LAB(62.07,J,9) W:'J#100 "."
 W !
 Q
CLNET ;
 N J
 F J=0:0 S J=$O(^LAB(61.2,J)) Q:'J  K ^LAB(61.2,J,9) W:'J#100 "."
 W !
 Q
CLNCS ;
 N J,K
 F J=0:0 S J=$O(^LAB(62,J)) Q:'J  W:'J#100 "." D
 . F K=0:0 S K=$O(^LAB(62,J,1,K)) Q:'K  D
 . . F L=0:0 S L=$O(^LAB(62,J,1,K,1,L)) Q:'L  K ^LAB(62,J,1,K,1,L,1)
 W !
 Q
WRAPUP ;
 K DIR,X,Y
