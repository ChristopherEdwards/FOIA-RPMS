AGHOME ; IHS/ASDS/EFG - PRINT DIRECTIONS TO PATIENT'S HOME ;  
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 D PTLK^AG
 Q:'$D(DFN)  I '$D(^AUPNPAT(DFN,12,1,0)) W !!,*7,"This patient has no entry in the ""DIRECTIONS"" file.",!,"Press RETURN..." R Y:DTIME Q
 S AGIO=IO
DEV S %ZIS="OPQ" D ^%ZIS I POP S IOP=ION D ^%ZIS Q
 G:'$D(IO("Q")) START K IO("Q") I $D(IO("S"))!($E(IOST)'="P") W *7,!,"Please queue to system printers." D ^%ZISC G DEV
 X ^%ZOSF("UCI") S ZTRTN="START^AGHOME",ZTUCI=Y,ZTDESC="Directions to "_$P(^DPT(DFN,0),U)_"'s House." F G="DFN" S ZTSAVE(G)=""
 D ^%ZTLOAD G:'$D(ZTSK) DEV K AG,AGIO,G,ZTDESC,ZTRTN,ZTSK,ZTUCI D ^%ZISC
 Q
START ;EP - From TaskMan.
 U IO W $$S^AGVDF("IOF"),"Directions to patient's home.",!!,"PATIENT: ",$P(^DPT(DFN,0),U),!,"CHART #: ",$P(^AUPNPAT(DFN,41,DUZ(2),0),U,2),"   (",$P(^DIC(4,DUZ(2),0),U),")",!!
 W "DATE: " S Y=DT D DD^%DT W Y S AG("LINE")="=" D LINE^AG W !!!
 F AG=0:0 S AG=$O(^AUPNPAT(DFN,12,AG)) Q:'AG  W ^AUPNPAT(DFN,12,AG,0),!
END D RTRN^AG W $$S^AGVDF("IOF") D ^%ZISC
 K AG,AGIO,X,Y D:$D(ZTQUEUED) KILL^%ZTLOAD
 Q
