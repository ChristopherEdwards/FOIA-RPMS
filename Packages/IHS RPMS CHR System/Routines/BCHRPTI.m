BCHRPTI ; IHS/TUCSON/LAB - REPORT INFORMATION FOR USERS ;  [ 10/28/96  2:05 PM ]
 ;;1.0;IHS RPMS CHR SYSTEM;;OCT 28, 1996
 ;
BDRL ;EP - detailed or brief record listing
 D BDRL^BCHRPTI1
 Q
 ;
GENR ;
 D GENR^BCHRPTI1
 Q
 ;
 ;
INFORM3 ;EP; inform user for top ten reports
 I '$D(BCHRRPT) W !,$C(7),$C(7),"REPORT TYPE MISSING!!  NOTIFY PROGRAMMER",! Q
 D GETINFO Q:$D(BCHQUIT)
 W:$D(IOF) @IOF
 W !,"Frequency of ",BCHINF," Report.",!
 W !,"This report will generate a list of the top N ",BCHINF,!,"for visits that you select.",!
 Q
 ;
INFORM2 ;EP ; inform user on age/sex record reports
 W:$D(IOF) @IOF
 W !,"CHR Patient Visits by Age and Sex",!
 W !,"This report will tally the number of patients, who have had an encounter, ",!,"by age and sex.  You will choose the item you wish to tally.  For example, ",!,"you can tally problems treated , or activities by age and sex.",!
 W "You will also be able to define the age groups to be used.",!
 S BCHX="G;PRB;PRBC;PRBD;L;T;A;AC;C" D MENU
 W !?5,"<The item you pick will display down the left column of the report,",!," Age groups will be across the top.>",!
 S DIR(0)="N^1:"_$L(BCHX,";")_":0",DIR("A")="Choose an item to tally by age and sex" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) S BCHQUIT="" Q
 S BCHRRPT=$P(BCHX,";",Y)
 D GETINFO
 Q
 ;
INFORM ; EP ; information for activity record counts
 W:$D(IOF) @IOF
 W !,"***** ACTIVITY RECORD COUNTS*****",!
 W !,"This report will generate a count of activity records the item and",!,"date range that you specify.",!
 W "You will be given the opportunity to select which records will be",!,"included in the tabulation.  For example, you can choose to tally activity time",!,"by Problem Code for only those activities that took place in the HOME."
 S BCHX="P;G;D;PRB;PRBC;L;A;C" D MENU
 S DIR(0)="N^1:"_$L(BCHX,";")_":0",DIR("A")="Choose an item for calculating activity time and record counts" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) S BCHQUIT="" Q
 S BCHRRPT=$P(BCHX,";",Y)
 D GETINFO
 Q
 ;
 ;
MENU ;display menu to choose item
 W !
 Q:'$D(BCHX)
 F X=1:1:$L(BCHX,";") S Y=$P(BCHX,";",X) S Z=$T(@(Y)) W !?5,X,").  ",$P(Z,";;",3)
 Q
GETINFO ;ENTRY POINT
 I $T(@(BCHRRPT))="" W !!,$C(7),$C(7),"REPORT INFORMATION MISSING!! NOTIFY PROGRAMMER!",!! S BCHQUIT="" Q
 S BCHINFO=$T(@(BCHRRPT)),BCHSORT=$P(BCHINFO,";;",2),BCHRPROC=$P(BCHINFO,";;",4),BCHINF=$P(BCHINFO,";;",3),BCHTITL=$P(BCHINFO,";;",5),BCHHD1=$P(BCHINFO,";;",6),BCHHD2=$P(BCHINFO,";;",7)
 Q
 ;
P ;;BCHPROV;;CHR;;PROV;;COMMUNITY HEALTH REPRESENTATIVE;;CHR;;PROVIDER CODE
G ;;BCHPROG;;Program;;PROG;;CHR PROGRAM;;CHR PROGRAM;;PROGRAM CODE
D ;;BCHDATE;;Date of Encounter;;DATE;;DATE OF VISIT;;DATE OF VISIT;;DAY OF WEEK
PRB ;;BCHPROB;;POV/Problem (Problem Code);;PROB;;PRIMARY PROBLEM (CODE);;PROB CODE NARRATIVE;;PROBLEM (POV) CODE
PRBC ;;BCHPROB;;Problem/POV (Problem Category);;PROBCAT;;PROBLEM CATEGORY;;CATEGORY NARRATIVE;;CATEGORY CODE
L ;;BCHVLOC;;Activity Location;;LOS;;ACTIVITY LOCATION;;ACTIVITY LOCATION;;LOCATION CODE
A ;;BCHACT;;Activity Code;;ACT;;ACTIVITY CODE;;ACTIVITY TYPE;;ACTIVITY CODE
C ;;BCHCOMM;;Patient Community of Residence;;COMM;;COMMUNITY OF RESIDENCE;;COMMUNITY OF RESIDENCE;;STCTYCOM CODE
 Q
