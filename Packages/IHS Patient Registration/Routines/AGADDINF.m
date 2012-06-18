AGADDINF ; IHS/ASDS/EFG - PRINT ADDITIONAL REG. INFORMATION ;  
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 D PTLK^AG
 Q:'$D(DFN)  I '$D(^AUPNPAT(DFN,13,1,0)) W !!,*7,"This patient has no entry in the ""ADDITIONAL INFO."" file.",!,"Press RETURN..." R Y:DTIME Q
DEV S AGIO=IO,%ZIS="OPQ" D ^%ZIS I POP S IOP=ION D ^%ZIS Q
 G:'$D(IO("Q")) START K IO("Q")
 I $D(IO("S"))!($E(IOST)'="P") W *7,!,"Please queue to system printers." D ^%ZISC G DEV
 X ^%ZOSF("UCI") S ZTRTN="START^AGADDINF",ZTUCI=Y,ZTDESC="Additional Reg Info for "_$P(^DPT(DFN,0),U)_"." F G="DFN" S ZTSAVE(G)=""
 D ^%ZTLOAD G:'$D(ZTSK) DEV K AG,AGIO,DFN,ZTDESC,ZTRTN,ZTSK,ZTUCI D ^%ZISC
 Q
START ;EP - From TaskMan.
 D LINES^AG U IO W $$S^AGVDF("IOF"),"Additional registration information....",!!,"PATIENT: ",$P(^DPT(DFN,0),U),!,"CHART #: ",$P(^AUPNPAT(DFN,41,DUZ(2),0),U,2),"   (",$P(^DIC(4,DUZ(2),0),U),")",!!,"DATE: " S Y=DT D DD^%DT W Y,!,AG("="),!!!!
 F AG=0:0 S AG=$O(^AUPNPAT(DFN,13,AG)) Q:'AG  W ^AUPNPAT(DFN,13,AG,0),!
 D RTRN^AG W $$S^AGVDF("IOF") D ^%ZISC K AG,AGIO,DFN D:$D(ZTQUEUED) KILL^%ZTLOAD
 Q
