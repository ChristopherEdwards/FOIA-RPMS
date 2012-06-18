PSJPRE44 ; B'ham ISC/CML3 - PRINT OUT INPATIENT SITE FILE ;3/23/92  18:42
 ;;3.2;;**28**
 ;
 W @IOF,!?30,"INPATIENT SITE PRINT"
 W !!?2,"This option will print all of the information contained in each of the entries",!,"in your Inpatient Site file, to assist you in your decisions in moving data",!,"from the Inpatient Site file to the Inpatient Ward Parameter file and "
 W !,"the Ward Group file.",!!?2,"Although this can be printed to your screen, it is highly recommended that",!,"you send this print to a printer so that you can have a hard copy readily",!,"available when using the data move options.",!
 ;
 K %ZIS,IO("Q"),IOP S %ZIS="Q",%ZIS("A")="Select PRINTER FOR INPATIENT SITE LIST: ",%ZIS("B")="" D ^%ZIS I POP D HOME^%ZIS G DONE
 I $D(IO("Q")) K ZTSAVE S ZTDTH=$H,PSGTIR="ENQ^PSJPRE44",ZTRTN="DQ^PSGTI",ZTSAVE("PSGTIR")="" D ENTSK^PSGTI W !?3,"...print ",$S($D(ZTSK):"",1:"NOT "),"sent..." G DONE
 ;
ENQ ;
 D NOW^%DTC S CNT=0,PG=1,PDT=$E(%,4,5)_"/"_$E(%,6,7)_"/"_$E(%,2,3),CML=IO'=IO(0)!($E(IOST)'="C"),ND="" U IO W @IOF,!!,PDT,?28,"INPATIENT SITE FILE PRINT",?71,"Page: 1"
 F Q=0:0 S Q=$O(^PS(59.4,Q)) Q:'Q  I $S($D(^(Q,0)):1,1:$D(^(5))) D PRT Q:ND="^"
 S X="*** INPATIENT SITE PRINT "_$S(ND="^":"ABORTED",1:"COMPLETED") S:'CNT X=X_" - NO ENTRIES FOUND" S X=X_" ***" W !!?80-$L(X)/2,X W:CML @IOF D ^%ZISC
 ;
DONE ;
 D ENKV^PSGSETU K CML,CNT,ND,PDT,PG,PL,PSGTIR Q
 ;
PRT ;
 S CNT=CNT+1,ND=$G(^PS(59.4,Q,0)),PL=$G(^(5))
 D:$Y+5>IOSL&CML NP W !!,"-------------------------------------------------------------------------------",!,"Site: ",$S($P(ND,"^")]"":$P(ND,"^"),1:Q)
 D:$Y+3>IOSL&CML NP W !?4,"Days until stop date/time: ",$P(ND,"^",3),?47,"Order entry process: ",$S($P(ND,"^",21)="1":"WARD",$P(ND,"^",21)="1":"ABBREVIATED",1:"REGULAR")
 D:$Y+3>IOSL&CML NP W !?1,"Same stop date on all orders: ",$S($P(ND,"^",4):"YES",1:"NO"),?41,"'SELF MED' in order entry: ",$S($P(ND,"^",24):"YES",1:"NO")
 D:$Y+3>IOSL&CML NP W !?1,"Time of day that orders stop: ",$P(ND,"^",7),?49,"Auto nurse verify: ",$S($P(ND,"^",15):"YES",1:"NO")
 D:$Y+3>IOSL&CML NP W !?3,"Start time for 24 hour MAR: ",$P(ND,"^",8),?44,"Auto pharmacist verify: ",$S($P(ND,"^",17):"YES",1:"NO")
 D:$Y+3>IOSL&CML NP W !?9,"Days new labels last: ",$P(ND,"^",11),?44,"Pre-exchange envelopes: ",$S($P(ND,"^",27):"YES",1:"NO")
 D:$Y+3>IOSL&CML NP W !?1,"Print profile in order entry: ",$S($P(ND,"^",30):"YES",1:"NO")
 D:$Y+3>IOSL&CML NP W !,"PICK LIST:",!?6,"Room/bed sort: ",$S($P(PL,"^"):"BED-ROOM",1:"ROOM-BED"),?55,"Form feed/patient: ",$S($P(PL,"^",4):"YES",1:"NO")
 D:$Y+3>IOSL&CML NP W !?5,"Omit ward sort: ",$S($P(PL,"^",2):"YES - DO NOT SORT BY WARD",1:"NO - SORT BY WARD"),?58,"Form feed/ward: ",$S($P(PL,"^",5):"YES",1:"NO")
 D:$Y+3>IOSL&CML NP W !?1,"Omit room-bed sort: ",$S($P(PL,"^",3):"YES - DO NOT SORT BY ROOM-BED",1:"NO - SORT BY ROOM-BED"),?54,"Lines on form feed: ",$S($P(PL,"^",6):"YES",1:"NO")
 S ND="" I 'CML K DIR S DIR(0)="E" W ! D ^DIR S:X="^"!$D(DIRUT) ND="^"
 Q
 ;
NP ;
 S PG=PG+1 W @IOF,!,PDT,?30,"INPATIENT SITE FILE PRINT",?72-$L(PG),"Page: ",PG,! Q
