AGNDX2 ; IHS/ASDS/EFG - PRINT ALL PATIENT'S INDEX CARDS ;  
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
SURE W !!!,"Are you sure you want to print index cards for ALL patients?  (Y/N) Y// " D READ^AG S Y=$E(Y_"Y") I $D(DQOUT) W !!,"This routine will print an index card for EVERY patient on your data base!!!" G SURE
 G END:("N"=Y)!$D(DTOUT)!$D(DFOUT)!$D(DUOUT) I "Y"'=Y D YN^AG G SURE
 D ALIAS^AGNDXP
 G END:$D(DTOUT)!$D(DFOUT)!$D(DUOUT)
DEV S %ZIS="OPQ" D ^%ZIS I POP S IOP=ION D ^%ZIS Q
 G:'$D(IO("Q")) START K IO("Q") I $D(IO("S"))!($E(IOST)'="P") W *7,!,"Please queue to system printers." D ^%ZISC G DEV
 X ^%ZOSF("UCI") S ZTRTN="START^AGNDX2",ZTUCI=Y,ZTDESC="Print Index Cards, All Patients, for "_$P(^AUTTLOC(DUZ(2),0),U,2)_".",ZTSAVE="" S:$D(AGALIAS) ZTSAVE("AGALIAS")=""
 D ^%ZTLOAD G:'$D(ZTSK) DEV K AG,AGALIAS,ZTDESC,ZTRTN,ZTSAVE,ZTSK,ZTUCI D ^%ZISC
 Q
START ;EP - From TaskMan.
 U IO S AGNAME=0 F I=0:0 S AGNAME=$O(^DPT("B",AGNAME)) Q:AGNAME=""  F IEN=0:0 S IEN=$O(^DPT("B",AGNAME,IEN)) Q:IEN=""  I $D(^(IEN))=1 S DFN=IEN D ^AGNDXP
 D ^%ZISC
END K AG,AGALIAS,DFN,IEN,I,J,AGLINE,IEN,IOP,AGNAME,AGTOT,X,Y D:$D(ZTQUEUED) KILL^%ZTLOAD
 Q
