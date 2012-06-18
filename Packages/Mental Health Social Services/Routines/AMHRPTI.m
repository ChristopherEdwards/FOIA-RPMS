AMHRPTI ; IHS/CMI/LAB - REPORT INFORMATION FOR USERS ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
BDRL ;EP - detailed or brief record listing
 D BDRL^AMHRPTI1
 Q
 ;
GENR ;
 D GENR^AMHRPTI1
 Q
 ;
 ;
INFORM3 ;EP; inform user for top ten reports
 I '$D(AMHRRPT) W !,$C(7),$C(7),"REPORT TYPE MISSING!!  NOTIFY PROGRAMMER",! Q
 D GETINFO Q:$D(AMHQUIT)
 W:$D(IOF) @IOF
 W !,"Frequency of ",AMHINF," Report.",!
 W !,"This report will generate a ",$S($D(AMHCHRT):"Bar Chart",1:"list")," of the top N "
 W !,AMHINF," for visits that you select.",!
 D DBHUSR^AMHUTIL
 Q
 ;
INFORM2 ;EP ; inform user on age/sex record reports
 W:$D(IOF) @IOF
 W !,"BH Patient Visits by Age and Sex",!
 W !,"This report will tally the number of patients, who have had an encounter, ",!,"by age and sex.  You will choose the item you wish to tally.  For example, ",!,"you can tally problems treated , or activities by age and sex.",!
 W "NOTE: Any tally by PROBLEM only includes PRIMARY PROBLEM",!
 W "You will also be able to define the age groups to be used.",!
 D DBHUSR^AMHUTIL,DBHUSR^AMHUTIL,PAUSE^AMHLEA
 S AMHX="G;PRB;PRBC;PRBD;L;T;A;AC;C" D MENU
 W !?5,"<The item you pick will display down the left column of the report,",!," Age groups will be across the top.>",!
 S DIR(0)="N^1:"_$L(AMHX,";")_":0",DIR("A")="Choose an item to tally by age and sex" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) S AMHQUIT="" Q
 S AMHRRPT=$P(AMHX,";",Y)
 D GETINFO
 Q
 ;
INFORM1 ;EP ; user information for program activity reports
 W:$D(IOF) @IOF
 W !,"* PROGRAM ACTIVITY TIME, PATIENT AND RECORD COUNTS *"
 W !,"This report will generate a count of activity records, total activity time and",!,"number of patient visits by Program and by an item you select",!,"for a date range that you specify."
 W !,"You will be given the opportunity to select which visits will be included",!,"in the report.  For example, you may wish to only report on those records",!,"on which the type of visit was Field."
 W !,"NOTE: If you choose to report on Problems, ONLY THE PRIMARY PROBLEM is included."
 D DBHUSR^AMHUTIL,PAUSE^AMHLEA
 S AMHX="P;DI;G;D;PRB;PRBC;PRBD;L;SU;T;A;AC;C" D MENU
 S DIR(0)="N^1:"_$L(AMHX,";")_":0",DIR("A")="Choose an item for calculating program activity time/record counts" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) S AMHQUIT="" Q
 S AMHRRPT=$P(AMHX,";",Y)
 D GETINFO
 Q
 ;
INFORM ; EP ; information for activity record counts
 W:$D(IOF) @IOF
 W !,"***** ACTIVITY RECORD COUNTS*****",!
 W !,"This report will generate a count of activity records for an item you select",!,"for a date range that you specify.",!
 W "You will be given the opportunity to select which visits will be",!,"included in the tabulation.  For example, you can choose to tally activity time",!,"by Problem Code for only those with a discipline of Psychiatrist."
 D DBHUSR^AMHUTIL,PAUSE^AMHLEA
 S AMHX="P;APWI;INT;DI;G;D;PRB;PRBC;PRBD;L;SU;T;A;AC;C;LSS;AGE;GEN;CLN" D MENU
 S DIR(0)="N^1:"_$L(AMHX,";")_":0",DIR("A")="Choose an item for calculating activity time and record counts" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) S AMHQUIT="" Q
 S AMHRRPT=$P(AMHX,";",Y)
 D GETINFO
 Q
 ;
MENU ;display menu to choose item
 Q:'$D(AMHX)
 F X=1:1:$L(AMHX,";") S Y=$P(AMHX,";",X) S Z=$T(@(Y)) W !?5,X,").  ",$P(Z,";;",3)
 Q
GETINFO ;ENTRY POINT
 I $T(@(AMHRRPT))="" W !!,$C(7),$C(7),"REPORT INFORMATION MISSING!! NOTIFY PROGRAMMER!",!! S AMHQUIT="" Q
 S AMHINFO=$T(@(AMHRRPT)),AMHSORT=$P(AMHINFO,";;",2),AMHRPROC=$P(AMHINFO,";;",4),AMHINF=$P(AMHINFO,";;",3),AMHTITL=$P(AMHINFO,";;",5),AMHHD1=$P(AMHINFO,";;",6),AMHHD2=$P(AMHINFO,";;",7)
 Q
 ;
P ;;AMHPROV;;Provider of Service;;PROV;;PROVIDER OF SERVICE;;PROVIDER;;PROVIDER DISCIPLINE
APWI ;;AMHAPWI;;Appointment/Walk-In;;APWI;;APPT/WALK-IN;;APPT/WALK-IN;;CODE
INT ;;AMHINTR;;Interpretor Utilized;;INT;;INTERPRETOR UTILIZED;;INTERPRETOR;;CODE
DI ;;AMHDISC;;Discipline of Provider;;DISC;;DISCIPLINE OF PROVIDER;;DISCIPLINE;;DISCPLINE CODE
G ;;AMHPROG;;Program Type;;PROG;;PROGRAM TYPE;;TYPE OF PROGRAM;;PROGRAM CODE
D ;;AMHDATE;;Date of Visit;;DATE;;DATE OF VISIT;;DATE OF VISIT;;DAY OF WEEK
PRB ;;AMHPROB;;POV/Problem (Problem Code);;PROB;;PRIMARY PROBLEM (CODE);;PROB CODE NARRATIVE;;PROBLEM (POV) CODE
PRBC ;;AMHPROB;;Problem/POV (Problem Category);;PROBCAT;;PROBLEM CATEGORY;;CATEGORY NARRATIVE;;CATEGORY CODE
PRBD ;;AMHPROB;;Problem/POV;;PROBD;;PROBLEM DSM IV TR/CODE;;PROB DSM/CODE NARRATIVE;;CODE
L ;;AMHVLOC;;Location of Service;;LOS;;LOCATION OF SERVICE;;LOCATION OF SERVICE;;LOCATION CODE
SU ;;AMHSU;;Service Unit of Service;;SU;;SERVICE UNIT;;SERVICE UNIT;;SU CODE
T ;;AMHCAT;;Type of Contact of Visit;;TOC;;TYPE OF CONTACT;;TYPE OF CONTACT;;CODE
A ;;AMHACT;;Activity Code;;ACT;;ACTIVITY CODE;;ACTIVITY TYPE;;ACTIVITY CODE
AC ;;AMHACTC;;Activity Category;;ACTC;;ACTIVITY CATEGORY;;ACTIVITY CATEGORY;;CATEGORY CODE
C ;;AMHCOMM;;Community of Service;;COMM;;COMMUNITY OF SERVICE;;COMMUNITY OF SERVICE;;STCTYCOM CODE
LSS ;;AMHLSS;;Local Service Site;;LSS;;LOCAL SERVICE SITE;;LOCAL SERVICE SITE;;---
AGE ;;AMHAGE;;Age;;AGE;;AGE;;AGE;;---
GEN ;;AMHSEX;;Gender;;GENDER;;GENDER;;GENDER;;GENDER
CLN ;;AMHCLN;;Clinic Type;;CLN;;CLINIC;;CLINIC;;CLINIC;;CLINIC CODE
 Q
