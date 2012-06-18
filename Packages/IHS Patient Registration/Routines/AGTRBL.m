AGTRBL ; IHS/ASDS/EFG - TRIBAL BLOOD QUANTUM STATISTICS REPORT ;  
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
 S DIC="^AUTTTRI(",DIC(0)="QAZEM" D ^DIC K DIC Q:+Y<1  S AGTRIBE=+Y,AGIO=IO
DEV S %ZIS="OPQ" D ^%ZIS I POP S IOP=ION D ^%ZIS Q
 G:'$D(IO("Q")) START K IO("Q") I $D(IO("S"))!($E(IOST)'="P") W *7,!,"Please queue to system printers." D ^%ZISC G DEV
 X ^%ZOSF("UCI") S ZTRTN="START^AGTRBL",ZTUCI=Y,ZTIO="",ZTDESC="Tribe Bld Q rpt for "_$P(^AUTTTRI(AGTRIBE,0),U)_".",AGQIO=IO F G="AGTRIBE","AGQIO" S ZTSAVE(G)=""
 D ^%ZTLOAD G:'$D(ZTSK) DEV K AG,AGIO,AGQIO,G,AGTRIBE,ZTDESC,ZTIO,ZTRTN,ZTSAVE,ZTSK,ZTUCI D ^%ZISC
 Q
START ;EP - From TaskMan.
 S (DFN,AGTOT)=0 F I=1:1:9 S AG(I)=0
L S DFN=$O(^AUPNPAT(DFN)) G PRINT:+DFN=0,L:'$D(^AUPNPAT(DFN,41,DUZ(2)))!'$D(^AUPNPAT(DFN,11)),L:$P(^AUPNPAT(DFN,41,DUZ(2),0),U,3)]""!'$D(^DPT(DFN,0)),L:+$P(^AUPNPAT(DFN,11),U,8)'=AGTRIBE
 S AGTRIBEQ=$P(^AUPNPAT(DFN,11),U,9) G L:AGTRIBEQ=""
 S AGT("TR")=1,Y=$S(AGTRIBEQ="FULL":1,AGTRIBEQ="NONE":5,AGTRIBEQ="UNKNOWN":6,AGTRIBEQ="UNSPECIFIED":7,1:0) I Y S AG(Y)=AG(Y)+1 S:Y=5 AGT("TR")=0 G L9
 S AGNUM=$P(AGTRIBEQ,"/",1),AGDEN=$P(AGTRIBEQ,"/",2)
 G L:+AGDEN=0
 S AGTRIBEQ=AGNUM/AGDEN,AG=AGTRIBEQ
 I AG'<1 S AG(1)=AG(1)+1 G L9
 I AG'<.5 S AG(2)=AG(2)+1 G L9
 I AG'<.25 S AG(3)=AG(3)+1 G L9
 S AGT("TR")=0
 I AG>0 S AG(4)=AG(4)+1 G L9
 S AG(5)=AG(5)+1
L9 G L:'$D(^AUPNMCD("B",DFN))!(AGT("TR")=1)
 S AG(9)=AG(9)+1
 G L
PRINT S AGTRIBE=$P(^AUTTTRI(AGTRIBE,0),U),AG("LOC")=$P(^DIC(4,DUZ(2),0),U),AG("USR")=$P(^VA(200,DUZ,0),U)
 F AG=1:1:7 S AGTOT=AGTOT+AG(AG)
 I $D(AGQIO) F AGZ("I")=1:1 S IOP=AGQIO D ^%ZIS Q:'POP  H 30
 U IO D LINES^AG,NOW^AG
 W $$S^AGVDF("IOF"),!,AG("*"),!
 W !,AG("USR"),?80-$L(AG("LOC"))\2,AG("LOC")
 W !!?20,"TRIBAL BLOOD QUANTUM STATISTICAL SUMMARY",!?19,"PERCENTAGE OF REGISTERED TRIBAL POPULATION",!!?80-$L("TRIBE: "_AGTRIBE)\2,"TRIBE: "_AGTRIBE
 W !!?80-$L("Report date: "_AGTIME)\2,"Report date: ",AGTIME,!
 W !,AG("*"),!
 W !,"""POPULATION"" represents those patients who.....",!!?5,"1)  are on file in the local computer,",!?5,"2)  are registered at the above facility,"
 W !?5,"3)  have valid data in the tribal quantum field,",!?5,"4)  are not designated as inactive patients,",!?5,"5)  are members of the ",AGTRIBE," tribe."
 W !!!,"TRIBAL QUANTUM....    (POPULATION: ",AGTOT,")" G END:AGTOT<1
 W ! F I=1:1:5,7,6 W !?5,$J($P("FULL^LESS THAN FULL^LESS THAN 1/2^LESS THAN 1/4^NONE^UNKNOWN^UNSPECIFIED",U,I),15),":",?25,$J(AG(I)/AGTOT*100,6,1),"%"
 D RTRN^AG
MCD W !!!!!,"Total LESS-THAN-1/4 WITH MEDICAID:",?25,$J(AG(9)/AGTOT*100,6,1),"%",?50,"(Number of patients:  ",AG(9),")"
 W !!,"     Based on a population of ",AGTOT," and representing those patients having.....",!,"     1)  ""less than 1/4"" or ""none"" for Tribal quantum, and",!,"     2)  membership in the ",AGTRIBE," tribe."
END D RTRN^AG W $$S^AGVDF("IOF") D ^%ZISC
 K AG,AGIO,AGT,AGTIME,AGQIO,DA,AGDEN,DFN,DIC,DR,I,AG("LOC"),AGNUM,AGTOT,AGTRIBE,AGTRIBEQ,AGTXT,AG("USR"),X,Y
 D:$D(ZTQUEUED) KILL^%ZTLOAD
 Q
