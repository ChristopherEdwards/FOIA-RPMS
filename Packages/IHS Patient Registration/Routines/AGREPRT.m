AGREPRT ; IHS/ASDS/EFG - QUE DAILY REGISTRATION ACTIVITY REPORT ;   
 ;;7.1;PATIENT REGISTRATION;**5**;AUG 25,2005
 I '$D(DT) S %DT="",X="T" D ^%DT S DT=Y
 K %DT S AG("FD")="W !!,*7,""Do not use future dates."""
A2 W !!,"Enter the BEGINNING DATE for this report: " D READ^AG Q:$D(DUOUT)!$D(DFOUT)!$D(DTOUT)!$D(DLOUT)  S:$D(DQOUT) Y="?" S DTIME=300,X=Y,%DT="XEP" D ^%DT G A2:Y<1 S AG("B")=Y I Y>DT X AG("FD") G A2
A3 W !!,"Enter the ENDING DATE for this report: " D READ^AG Q:$D(DFOUT)!$D(DTOUT)!$D(DLOUT)  G A2:$D(DUOUT) S:$D(DQOUT) Y="?" S DTIME=300,X=Y,%DT="XEP" D ^%DT G A3:Y<1 S AG("E")=Y I Y>DT X AG("FD") G A3
 G A44:AG("B")'>AG("E") W !!,*7,"INVALID ENTRY - The END is before the BEGINNING." G A2
A44 ;
 S AGB=$$FMTE^XLFDT(AG("B"),5),AGE=$$FMTE^XLFDT(AG("E"),5)
A5 W !!!,"Which type of report do you wish? (1,2 ,3 or 4)",!!
 W "   1... `NEW, EDITED, REMOVED` Statistics only",!!
 W "   2... `NEW, EDITED, REMOVED` Statistics and patient names",!!
 W "   3... `NEW / REGISTERED` Statistics from ",AGB," To ",AGE,!!
 W "   4... `NEW / REGISTERED` Statistics and Patients from ",AGB," To ",AGE,!!,"Enter: "
 D READ^AG G A3:$D(DUOUT) Q:$D(DTOUT)!$D(DFOUT)!$D(DLOUT)  I Y<1!(Y>4) W !!,*7,"Please Enter only ""1"" ,""2"",""3"" or ""4""." G A5
 S AG("TYPE")=Y S AGIO=IO,AG("HAT")=""
DEV S %ZIS="OPQ" D ^%ZIS I POP S IOP=ION D ^%ZIS Q
 G:'$D(IO("Q")) ^AGREPRT1 K IO("Q") I $D(IO("S"))!($E(IOST)'="P") W *7,!,"Please queue to system printers." D ^%ZISC G DEV
 X ^%ZOSF("UCI") S ZTRTN="^AGREPRT1",ZTUCI=Y,ZTDESC="REGISTRATION ACTIVITY REPORT for "_$P(^AUTTLOC(DUZ(2),0),U,2)_", "_AGB_" to "_AGE_"." F G="AG(""TYPE"")","AG(""B"")","AG(""E"")" S ZTSAVE(G)=""
 S ZTSAVE("AGB")="",ZTSAVE("AGE")=""  ;AG*7.1*5 H4512
 D ^%ZTLOAD G:'$D(ZTSK) DEV K AG,AGB,AGE,AGIO,G,ZTDESC,ZTRTN,ZTSAVE,ZTSK,ZTUCI D ^%ZISC
 Q
