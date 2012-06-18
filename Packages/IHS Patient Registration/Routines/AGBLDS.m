AGBLDS ; IHS/ASDS/EFG - BLOOD QUANTUM: % OF REGISTERED POPULATION ;  
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 S AGIO=IO
DEV S %ZIS="OPQ" D ^%ZIS I POP S IOP=ION D ^%ZIS Q
 G:'$D(IO("Q")) START K IO("Q") I $D(IO("S"))!($E(IOST)'="P") W *7,!,"Please queue to system printers." D ^%ZISC G DEV
 X ^%ZOSF("UCI") S ZTRTN="START^AGBLDS",ZTUCI=Y,ZTIO="",ZTDESC="BLOOD QUANTUM STATISTICAL SUMMARY.",AGQIO=IO F G="AGQIO" S ZTSAVE(G)=""
 D ^%ZTLOAD G:'$D(ZTSK) DEV K AG,AGIO,AGQIO,G,ZTDESC,ZTIO,ZTRTN,ZTSK,ZTUCI D ^%ZISC
 Q
START ;EP - From TaskMan.
 S (DFN,AGTOT,AGTTOT,AGGTOT)=0 F AG=1:1:8 S (AG(AG),AGT(AG))=0
L S DFN=$O(^AUPNPAT(DFN)) G PRINT:+DFN=0,L:'$D(^AUPNPAT(DFN,41,DUZ(2)))!'$D(^AUPNPAT(DFN,11)),L:$P(^AUPNPAT(DFN,41,DUZ(2),0),U,3)]""!'$D(^DPT(DFN,0)) S (AGT("TR"),AGT("IN"))=1
 S AGTQ=$P(^AUPNPAT(DFN,11),U,9),AGIQ=$P(^(11),U,10) I AGTQ="" S AGTQ="INV" G L5
 S Y=$S(AGTQ="FULL":1,AGTQ="NONE":5,AGTQ="UNKNOWN":6,AGTQ="UNSPECIFIED":7,1:0) I Y S AG(Y)=AG(Y)+1 S:Y=5 AGT("TR")=0 G L5
 S AGNUM=$P(AGTQ,"/",1),AGDEN=$P(AGTQ,"/",2) I +AGDEN=0 S AGTQ="INV" G L5
 S AGTQ=AGNUM/AGDEN,AG=AGTQ
 I AG'<1 S AG(1)=AG(1)+1 G L5
 I AG'<.5 S AG(2)=AG(2)+1 G L5
 I AG'<.25 S AG(3)=AG(3)+1 G L5
 S AGT("TR")=0
 I AG>0 S AG(4)=AG(4)+1 G L5
 S AG(5)=AG(5)+1
L5 I AGIQ="" S AGIQ="INV" G L9
 S Y=$S(AGIQ="FULL":1,AGIQ="NONE":5,AGIQ="UNKNOWN":6,AGIQ="UNSPECIFIED":7,1:0) I Y S AGT(Y)=AGT(Y)+1 S:Y=5 AGT("IN")=0 G L9
 S AGNUM=$P(AGIQ,"/",1),AGDEN=$P(AGIQ,"/",2) I +AGDEN=0 S AGIQ="INV" G L9
 S AGIQ=AGNUM/AGDEN,AG=AGIQ
 I AG'<1 S AGT(1)=AGT(1)+1 G L9
 I AG'<.5 S AGT(2)=AGT(2)+1 G L9
 S AGT("IN")=0
 I AG'<.25 S AGT(3)=AGT(3)+1 G L9
 I AG>0 S AGT(4)=AGT(4)+1 G L9
 S AGT(5)=AGT(5)+1
L9 I AGTQ_AGIQ'["INV" S AGGTOT=AGGTOT+1 S:AGT("TR")+AGT("IN")=0 AG(8)=AG(8)+1
 G L
PRINT S AG("LOC")=$P(^DIC(4,DUZ(2),0),U),AG("USR")=$P(^VA(200,DUZ,0),U) F AG=1:1:7 S AGTOT=AG(AG)+AGTOT,AGTTOT=AGT(AG)+AGTTOT
 S AGTXT="FULL^LESS THAN FULL^LESS THAN 1/2^LESS THAN 1/4^NONE^UNKNOWN^UNSPECIFIED"
 I $D(AGQIO) F AGZ("I")=1:1 S IOP=AGQIO D ^%ZIS Q:'POP  H 30
 U IO D LINES^AG,NOW^AG
 W $$S^AGVDF("IOF"),!,AG("*"),!!,AG("USR"),?80-$L(AG("LOC"))\2,AG("LOC"),!!?24,"BLOOD QUANTUM STATISTICAL SUMMARY",!?23,"PERCENTAGE OF REGISTERED POPULATION",!!?80-$L("Report date: "_AGTIME)\2,"Report date: ",AGTIME,!
 W !,AG("*"),!
 W !,"""POPULATION"" represents those patients who.....",!!?5,"1)  are on file in the local computer,",!?5,"2)  are registered at the above facility,",!?5,"3)  have valid data in the respective quantum fields,"
 W !?5,"3)  are not designated as inactive patients",!!!,"TRIBAL QUANTUM....    (POPULATION: ",AGTOT,")" G FULL:AGTOT<1
 W ! F I=1:1:5,7,6 W !?5,$J($P(AGTXT,U,I),15),":",?25,$J(AG(I)/AGTOT*100,6,1),"%"
 D RTRN^AG
FULL W !!!!!,"INDIAN QUANTUM....    (POPULATION: ",AGTTOT,")" G END:AGTTOT<1
 W ! F I=1:1:5,7,6 W !?5,$J($P(AGTXT,U,I),15),":",?25,$S(AGTTOT>0:$J(AGT(I)/AGTTOT*100,6,1),1:0),"%"
 W !!!!!,"Total ""UNQUALIFIED"":",?25,$S(AGGTOT>0:$J(AG(8)/AGGTOT*100,6,1),1:0),"%",?40,"(Number of patients:  ",AG(8),")"
 W !!,"     Based on a population of ",AGGTOT," and representing those patients having.....",!,"     1)  ""less than 1/4"" or ""none"" for Tribal quant., and",!,"     2)  ""less than 1/2"" or ""less than 1/4"" or ""none"" for Indian quant."
 W !,"     3)  and, valid data in both quantum fields."
END D RTRN^AG W $$S^AGVDF("IOF") D ^%ZISC
 K AG,AGIO,AGQIO,AGIQ,AGT,AGTQ,AGTIME,AGDEN,DFN,DLOUT,AGTOT,I,AG("LOC"),AGNUM,AGGTOT,AGTTOT,AGTXT,AG("USR"),ZTUCI D:$D(ZTQUEUED) KILL^%ZTLOAD
 Q
