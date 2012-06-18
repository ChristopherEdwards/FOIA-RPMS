AVAP7 ;IHS/ORDC/LJF - PATCH 7 DATA DUPLICATION; [ 09/20/95  11:43 AM ]
 ;;93.2;VA SUPPORT FILES;**7**;JUL 01, 1993
 ;
 W !!?20,"AVA PATCH 7 DRIVER"
 W !! K DIR S DIR(0)="Y",DIR("B")="NO"
 S DIR("A")="Are you READY to proceed with this update"
 D ^DIR I Y'=1 K DIR,Y Q
 ;
 W !!,"We recommend capturing the output of this patch using a"
 W !,"slaved printer.  This is a cumulative patch.",!
 K DIR S DIR(0)="E",DIR("A")="Press ENTER when ready to proceed"
 D ^DIR
 ;
 ; -- run patch #2 update
 W !!,"Patch #2:",!
 D ^AVAP2
 ;
 ; -- run patch #3 update
 W !!,"Patch #3:",!
 D LOOP^AVAP3
 ;
 ; -- run patch #4 update
 W !!,"Patches #4 - #6:",!
 D ^AVAPINIT
 D CLASS^AVAP4
 ;
 ; -- patch 7 update: remove security from file 200 read access
 S ^DIC(200,0,"RD")=""
 ;
EXIT ;
 W !!,"PATCH #7 COMPLETE.",!
 Q
