AGTXPERK ; IHS/ASDS/EFG - SCAN AND KILL PAST TX ERRORS ; 
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;Past Error Killer
S ;SELECT DATES
 W !,"You will be able to select",!?5,"a range of dates",!?5,"a range of errors",!,"to be deleted.",!!
DT1 S %DT="AEX",%DT(0)="-NOW",%DT("A")="START Date (or ^) " D ^%DT
 I Y'>0 G EXIT
 S AGSDT=Y
DT2 S %DT="AEX",%DT(0)=AGSDT,%DT("A")="END Date  (or ^) " D ^%DT
 I Y'>0 G DT1
 S AGEDT=Y
 K %DT(0)
 D DDISP
 K AG D VAR^AGBADATA
 W !,"Select Records-Errors to be deleted.",!,"Records with the errors selected will be removed from transmissions.",!!
 F AGI=1:1 Q:'$D(AG(AGI))  W !,AGI,?5,AG(AGI)
 S AGI=AGI-1
 W !
 K DIR S DIR(0)="L^1:"_AGI,DIR("A")="Select Errors to be deleted: " D ^DIR
 S AGER=Y I '+AGER W !,"NO ERRORS SELECTED - quiting",! H 3 G EXIT
 F AGI=1:1 S AGERSUB=$P(AGER,",",AGI) Q:'AGERSUB  S AGER(AGERSUB)=""
 D DDISP
 D ERDISP
 K DIR S DIR(0)="Y",DIR("A")="Are the above selections correct ? ",DIR("B")="Y" D ^DIR
 I Y'=1 G S
 S XBRC="SCAN^AGTXPERK",XBRP="PRINT^AGTXPERK",XBNS="AG",XBRX="EXIT^AGTXPERK" D ^XBDBQUE
 Q
 ;--------------------------- SUB ROUTINES ------------------
DDISP ;display selection
 W !!,"Start Date :",?15 S Y=AGSDT D DD^%DT W Y
 W !,"End Date :",?15 S Y=AGEDT D DD^%DT W Y
 Q
 ;--------------------------- SUB ROUTINES ------------------
ERDISP ;display errors selected
 K AG D VAR^AGBADATA
 F AGI=1:1 S AGE=$P(AGER,",",AGI) Q:'AGE  W !?5,AGE,?10,AG(AGE)
 W !
 Q
 ;--------------------------- SUB ROUTINES ------------------
SCAN ;scan all past errors
 S AGDTS=AGSDT,AGEDT=AGEDT+1,AGCNT=0
 F  S AGDTS=$O(^AGPATCH("ER",AGDTS)) Q:((AGDTS>AGEDT)!(AGDTS=""))  S AGSITE="" F  S AGSITE=$O(^AGPATCH("ER",AGDTS,AGSITE)) Q:AGSITE=""  S AGDFN="" F  S AGDFN=$O(^AGPATCH("ER",AGDTS,AGSITE,AGDFN)) Q:AGDFN=""  D
 .I $P(^DPT(AGDFN,0),"^",19)>0 K ^AGPATCH("ER",AGDTS,AGSITE,AGDFN) Q  ;merged patient
 .S DFN=AGDFN K AG D ^AGDATCK
 .S AGI="",AGK=0 F  S AGI=$O(AGER(AGI)) Q:AGI=""  I $D(AG("ER",AGI)) D  Q
 ..S AGCNT=AGCNT+1
 ..K ^AGPATCH("ER",AGDTS,AGSITE,AGDFN)
 Q
 ;--------------------------- SUB ROUTINES ------------------
PRINT ;Print Completion
 W !,"PAST ERRORS REMOVED REPORT",!
 D DDISP,ERDISP
 W !,AGCNT,?10,"Transmission sends deleted",!!
 I IO=IO(0),'$D(ZTQUEUED) K DIR S DIR(0)="E" D ^DIR
 W $$S^AGVDF("IOF")
 Q
 ;--------------------------- SUB ROUTINES ------------------
EXIT ;CLEAN UP
 S AG="AG" F  S AG=$O(@AG) Q:$E(AG,1,2)'="AG"  K @AG
 K AG
 Q
