BOPTBS ;IHS/ILC/ALG/CIA/PLS - troubleshooting ;13-Apr-2006 10:18;SM
 ;;1.0;AUTOMATED DISPENSING INTERFACE;**1**;Jul 26, 2005
 ;EP - Called by BOP FUTURE TASK LIST option
C S (BOPOXX,BOPOX)="BOP"
 ;
FUT ;Searching Future tasks.
 N DIR,DIRUT,DTOUT,DUOUT,X,ZT,ZT1,ZT2,ZT3,ZTC,ZTF,ZTH,ZTS
 K ^TMP($J)
 S ZTC=0,ZTF=1,ZTH="Scheduled and waiting tasks..."
 W !!,"Building sorted list of tasks..."
 ;
F1 S ZT1="" F  S ZT1=$O(^%ZTSCH("JOB",ZT1)) Q:ZT1=""  D
 .S ZT2="" F  S ZT2=$O(^%ZTSCH("JOB",ZT1,ZT2)) Q:'ZT2  D
 ..D SORT(ZT1,ZT2)
 ;
F2 S ZT1=$$H3^%ZTM($H) F  S ZT1=$O(^%ZTSCH(ZT1)) Q:'ZT1  D
 .S ZTS=0 F  S ZTS=$O(^%ZTSCH(ZT1,ZTS)) Q:'ZTS  D
 ..D SORT(ZT1,ZTS)
 ;
F3 S ZT1="" F  S ZT1=$O(^%ZTSCH("IO",ZT1)) Q:ZT1=""  D
 .S ZT2="" F  S ZT2=$O(^%ZTSCH("IO",ZT1,ZT2)) Q:'ZT2  D
 ..S ZT3=0 F  S ZT3=$O(^%ZTSCH("IO",ZT1,ZT2,ZT3)) Q:ZT3=""  D
 ...D SORT(ZT2,ZT3)
 ;
F4 S ZT1="" F  S ZT1=$O(^%ZTSCH("LINK",ZT1)) Q:'ZT1  D
 .S ZT2="" F  S ZT2=$O(^%ZTSCH("LINK",ZT1,ZT2)) Q:'ZT2  D
 ..S ZTS=0 F  S ZTS=$O(^%ZTSCH("LINK",ZT1,ZT2,ZTS)) Q:'ZTS  D
 ...D SORT(ZT2,ZTS)
 W "finished!"
F5 ;
 G:$O(^TMP($J,0))="" F6
 S BOPOERR=0
 S BOPOI=0 F  S BOPOI=$O(^TMP($J,BOPOI)) Q:BOPOI=""  S BOPOJ=0 F  S BOPOJ=$O(^TMP($J,BOPOI,BOPOJ)) Q:BOPOJ=""  D
 .S DATA=$G(^%ZTSK(BOPOJ,0)) I $P(DATA,"^",2)[BOPOX D
 ..S BOPOERR=1
 ..F I=1:1:10 S BOPOE(I)=$P(DATA,"^",I)
 ..F I=5,6 S BOPOF(I)=$$HTE^XLFDT(BOPOE(I),"2Z")
 ..W !,"Task No.          ",BOPOJ
 ..W !,"Routine:          ",BOPOE(2)
 ..W !,"Creation time:    ",BOPOF(5)
 ..W !,"Sched. Run Time:  ",BOPOF(6)
 ..W !,"Scheduled by:     ",BOPOE(10)
 ..W !
 I 'BOPOERR W !!,"No future task scheduled for "_BOPOX
 K ^TMP($J)
 Q
 ;
F6 I 'ZTC W !!,"There are no future tasks on this volume set."
 W ! S DIR(0)="E",DIR("A")="Press RETURN to continue" D
 .I ZTC S DIR("A")="End of listing.  "_DIR("A")
 D ^DIR K ^TMP($J) Q
 ;
SORT(ZTDTH,ZTSK) ;
 I ZTDTH["," S ZTDTH=$$H3^%ZTM(ZTDTH)
 S ^TMP($J,ZTDTH,ZTSK)=""
 Q
 ;
BOPOR ; EP - troubleshoot menu option
 ;Called by BOP RUN TASK LIST option
 S BOPOI=0,BOPOJ=0
 S BOPOII="Info from running task file: "
 F  S BOPOI=$O(^%ZTSCH("TASK",BOPOI)) Q:BOPOI<1  D
 .Q:'$D(^%ZTSK(BOPOI))
 .S DATA=^%ZTSK(BOPOI,0)
 .I $P(DATA,"^",2)["BOP" D BOPOP
 W !!
 I 'BOPOJ D
 .S BOPOII="Info from the Site Parameter file: "
 .S ZTSK=$P($G(^BOP(90355,1,4)),"^",3)
 .I 'ZTSK Q
 .D STAT^%ZTLOAD I $G(ZTSK(0)),$G(ZTSK(1))=1 S BOPOI=ZTSK,DATA=^%ZTSK(BOPOI,0) D BOPOP
 S BOPOII=""
 I 'BOPOJ W !!!,"There is no running task in ""BOP"" namespace."
 Q
BOPOP ;
 W !,BOPOII
 W !,"The running task is scheduled....",!
 S BOPOJ=1
 W !,"Task No.          ",BOPOI
 W !,"Routine:          ",$P(DATA,U,2)
 W !,"Creation time:    ",$$HTE^XLFDT($P(DATA,U,5),"2Z")
 W !,"Sched. Run Time:  ",$$HTE^XLFDT($P(DATA,U,6),"2Z")
 W !,"Scheduled by:     ",$P(DATA,U,10)
 W !
 Q
 ;
DONE ;EP - Look at the last entry that is done
 ;Called by BOP CHECK TRANSACTIONS option
 N BOPOI,ANS,BOPOX
 S BOPOX=0
 W !,"Print out the last entry in the log 10 times.  This number should change."
 W !,"If it doesn't, the interface isn't moving data."
 W !,"To stop before 10 cycles are done, enter any number."
 W !!,"IEN #",?11,"Patient",?38,"SSN",?44,"Log in date/time"
 W !,"-----",?11,"-------",?38,"---",?44,"----------------"
 F I=1:1:10 H 2 S BOPOI=^BOP(90355.1,0) S BOPOI=$O(^BOP(90355.1,"AS",0,0)) D  Q:'BOPOI  D:I=10 REMOVE Q:BOPOX
 .I 'BOPOI W !,"NO DATA TO TRANSFER" Q
 .W !,BOPOI,?11,$E($P(^BOP(90355.1,BOPOI,1),U,3),1,25),?38,$E($P(^(1),U,15),6,9),?44,$P(^(0),U)
 .W ! S DIR(0)="NO",DIR("T")=1 D ^DIR K DIR
 .I X?.N D REMOVE
 Q
 ;
REMOVE ;remove an "AS" record
 N BOPMGRP
 S BOPWHO=$$INTFACE^BOPTU(1) S BOPWHO=$S(BOPWHO="O":"OMNICELL",1:"PYXIS")
 N DIR,X,Y S DIR("A")="Do you want to remove this ""AS"" cross reference from this file"
 S DIR(0)="YO",DIR("B")="YES"
 S DIR("?")=" "
 S DIR("?",1)="Enter YES to remove crossreference"
 S DIR("?",2)="Enter NO to retain crossreference"
 S DIR("?",3)="Enter an '^' to exit."
 D ^DIR
 S:$G(DUOUT)!$G(DTOUT) BOPOX=1 I 'Y W !,"No changes made" Q
 I Y K ^BOP(90355.1,"AS",0,BOPOI) W !,"DONE. Sending a "_$G(BOPWHO)_" Alert notice" D
 .S BOPMGRP=$$GET1^DIQ(90355,1,.06)
 .I BOPMGRP="" D
 ..S XMY(DUZ)=""
 .E  D
 ..S XMY("G."_BOPMGRP)=""
 .;send mail message
 .N TEXT,XMTEXT,XMY,XMSUB,XMZ,TEXT
 .S XMDUZ="ADS INTERFACE"
 .S TEXT(1)="The ""AS"" cross-reference for the following BOP Queue file (90355.1)"
 .S TEXT(2)="has been deleted. Please examine the record data."
 .S TEXT(3)=BOPOI_"   "_$E($P(^BOP(90355.1,BOPOI,1),U,3),1,25)_"  "_$E($P(^(1),U,15),6,9)_"   "_$P(^(0),U)
 .S XMTEXT="TEXT(",XMSUB=$G(BOPWHO)_" Record Fault" D ^XMD
 Q
