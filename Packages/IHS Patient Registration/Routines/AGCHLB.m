AGCHLB ; IHS/ASDS/EFG - SELECT PATIENTS & PRINT CHART LABELS ;  
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 S AGTOT=0 K IOP,AG,DFN
OPT G A:'$O(^AGCHLB(DUZ,0)) W !!,"Do you wish to re-print the previous list? (Y/N;  ""S"" = see the list) " D READ^AG
 Q:$D(DFOUT)!$D(DUOUT)!$D(DTOUT)!$D(DLOUT)  G OLD:Y?1"Y".E,NEW:Y?1"N",SEE:Y?1"S".E D YN^AG G OPT
NEW K ^AGCHLB(DUZ) S ^AGCHLB(DUZ,0)="" G A ; Kill of un-subscripted work global.
OLD S AGTOT=^AGCHLB(DUZ,"TOT") W !!,"Start with which patient? (RETURN = beginning) " D PTLK^AG G AGCHLB:$D(DUOUT)!$D(DFOUT)!$D(DTOUT),A1:'$D(DFN) I '$D(^AGCHLB(DUZ,DFN)) W !!,"This patient is not on the list - try again." G OPT
 S:DFN>0 AGDFN=DFN-1 G A1
SEE W $$S^AGVDF("IOF"),"Previous list of chart labels.....",! S DFN=0
 F AG=1:1 S DFN=$O(^AGCHLB(DUZ,DFN)) G OPT:DFN="TOT" W:$D(^DPT(DFN)) !,$P(^DPT(DFN,0),U) I AG#20=0 W !!,"Press RETURN to continue; ""^"" to stop." D READ^AG W ! G AGCHLB:$D(DUOUT)
A F AG=0:0 D PTLK^AG Q:'$D(DFN)  S AGTOT=AGTOT+1,^AGCHLB(DUZ,DFN)="" W !,$P(^DPT(DFN,0),U)," is on the list."
A1 G END:AGTOT=0 S ^AGCHLB(DUZ,"TOT")=AGTOT D:AGTOT>50 WAIT^DICD S DFN=0 F AG=1:1 S DFN=$O(^AGCHLB(DUZ,DFN)) G B:DFN="TOT" S ^AGCHLB(DUZ,DFN)=AG
B S:$D(AGDFN) AGTOT=1+^AGCHLB(DUZ,"TOT")-^AGCHLB(DUZ,AGDFN+1) W !!!,"Number of names on the list: ",AGTOT,!!,"DO YOU WANT TO PRINT A TEST LABEL?  (Y/N) Y// " D READ^AG S Y=$E(Y_"Y")
 I $D(DQOUT) W !!,"A sample label will be printed so that you",!,"may allign your labels on the printer." G B
 G END:$D(DTOUT)!$D(DFOUT)!$D(DUOUT),C:$D(DLOUT)!(Y="Y"),D:Y="N" D YN^AG G B
C ;Print Test Label.
 D ^%ZIS Q:POP  U IO F AG=1,2 W "IHSIHSIHSIHSIHSIHSIHSIHSIHSIHSIHS",!
 W !!!! D ^%ZISC
 G B
D W !!,"How many copies of each label? (1 - 5) 1// " D READ^AG G B:$D(DTOUT)!$D(DFOUT)!$D(DUOUT) S:$D(DLOUT) Y=1 I $D(DQOUT)!(+Y>5)!(+Y<1) W !!,"You may make from 1 to 5 copies of each label.",!! G D
 S AGCOPY=+Y
DEV S %ZIS="OPQ" D ^%ZIS I POP S IOP=ION D ^%ZIS Q
 G:'$D(IO("Q")) START K IO("Q") I $D(IO("S"))!($E(IOST)'="P") W *7,!,"Please queue to system printers." D ^%ZISC G DEV
 X ^%ZOSF("UCI") S ZTRTN="START^AGCHLB",ZTUCI=Y,ZTDESC="Print Chart Lablels for "_$P(^AUTTLOC(DUZ(2),0),U,2)_"." S:'$D(AGDFN) AGDFN=0 F G="AGDFN","AGCOPY" S ZTSAVE(G)=""
 D ^%ZTLOAD G:'$D(ZTSK) DEV K AG,AGDFN,AGCOPY,G,ZTDESC,ZTIO,ZTRTN,ZTSAVE,ZTSK,ZTUCI D ^%ZISC
 Q
START ;EP - From TaskMan.
 S DFN=$S($D(AGDFN):AGDFN,1:0) U IO
S1 S DFN=$O(^AGCHLB(DUZ,DFN)) G END:DFN="TOT"
 S (AGNAME,AGDOB,AGCHART)="",DA=DFN,DR=.01,DIC=2 D ^AGDICLK S:$D(AG("LKPRINT")) AGNAME=AG("LKPRINT") S AGCHART=$P(^AUPNPAT(DFN,41,DUZ(2),0),U,2),DR=.03 D ^AGDICLK S:$D(AG("LKPRINT")) AGDOB=AG("LKPRINT")
 S:$L(AGCHART)>3 AGCHART=$E(AGCHART,1,$L(AGCHART)-3)_"-"_$E(AGCHART,$L(AGCHART)-2,$L(AGCHART))
 F AG=1:1:AGCOPY W AGNAME,!,AGDOB,?27,$J(AGCHART,6),!!!!!
 G S1
END D ^%ZISC K AG,AGCHART,AGDFN,AGDOB,AGNAME,DA,DFN,DIC,DR,AG("LKDATA"),AG("LKPRINT"),X,Y,Z D:$D(ZTQUEUED) KILL^%ZTLOAD
 Q
