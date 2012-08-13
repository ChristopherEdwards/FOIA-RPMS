INHE1 ;JSH; 22 Oct 1999 15:25 ;Interface Error reporting/processing
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
LIST ;List errors
 N %DT,INSD,INED,DIC,DA,DR,IOP,INT,INLOC,%,INBRIEF
 S %DT("A")="Start DATE: ",%DT="ATE" D ^%DT Q:Y<0  S INSD=+Y
 S %DT("A")="Ending DATE: ",%DT="ATE",%DT("B")="TODAY" D ^%DT Q:Y<0  S INED=+Y S:INED\1=INED INED=INED+.9999
 S DIC("A")="Select LOCATION OF ERROR to print: ",DIC="^INTHERL(",DIC(0)="QAEM" D ^DIC Q:Y<0  S INLOC=+Y,INLOC(1)=$P(Y,U,2) S:INLOC(1)="ALL" INLOC=0
 W ! S INBRIEF=$$YN^UTSRD("Do you want to see the transaction messages? ;0","") Q:INBRIEF="0^0"  S INBRIEF='INBRIEF
 K IOP S %ZIS="NMQ" D ^%ZIS Q:POP
 I IO'=IO(0) D  Q
 . S ZTRTN="ZTSK^INHE1",ZTIO=ION_";"_IOST_";"_IOM_";"_IOSL
 . F I="INLOC*","INSD","INED","INBRIEF" S ZTSAVE(I)=""
 . D ^%ZTLOAD I $D(ZTSK) W !,"Request Queued." K ZTSK
 . D ^%ZISC
 S IOP=ION_";"_IOST_";"_IOM_";"_IOSL D ^%ZIS,ZTSK,^%ZISC
 Q
 ;
ZTSK ;Entry point to print
 ;INSD = FileMan format start date/time
 ;INED = FileMan format end date/time
 ;INLOC= location of error to print (internal #, 0 = ALL)
 ;INLOC(1) = name of error location
 W:$E(IOST)="C" @IOF
 N INPAGE,INLINE,INDT,DTOUT,DUOUT,DIOUT,INI,INJ,INK,INROU,D0,I,J
 S INROU=^DIPT($O(^DIPT("B","INH ERROR DISPLAY",0)),"ROU"),INDT=$$DATEFMT^UTDT("NOW","DD MMM YYYY@HH:II"),(INPAGE,INK)=0
 S $P(INLINE,$S($D(DWA("HL")):DWA("HL"),1:"-"),IOM+1)=""
 D HEAD
 S ^UTILITY($J,1)=$S($E(IOST)="C":"D TOP^INHE1",1:"W @IOF D HEAD^INHE1"),I(0)="^INTHER(",J(0)=4003
 S INI=INSD-.0000001,%=0 F  S INI=$O(^INTHER("B",INI)) Q:'INI!(INI>INED)!$G(DIOUT)!$G(DTOUT)  S INJ=0 D
 .  F  S INJ=$O(^INTHER("B",INI,INJ)) Q:'INJ  S D0=INJ D:$D(^INTHER(INJ,0))  Q:$G(DIOUT)!$G(DTOUT)
 ..   K DXS
 ..   I 'INLOC D @INROU S INK=1 Q
 ..   I INLOC<9 D:$P(^INTHER(INJ,0),U,5)=INLOC @INROU S INK=1 Q
 ..   I +$P(^INTHER(INJ,0),U,10)=(INLOC-9) D @INROU S INK=1 Q
 W:'INK !!,"  No entries found."
 W:$E(IOST)'="C" @IOF K DIOUT
 K ^UTILITY($J,1)
 Q
 ;
TOP ;End of a page
 Q:$G(DIOUT)  N X
 W *7 D ^UTSRD("",1) I $E(X)=U S DIOUT=1 Q
 W @IOF D HEAD
 Q
 ;
HEAD ;Header
 Q:$G(DIOUT)  S INPAGE=INPAGE+1 W !,?(IOM\2-11),"Interface Error Report",!?(IOM\2-9),INDT
 W !,"Error Location: "_INLOC(1),?(IOM-10),"Page: "_INPAGE
 W !,"DATE/TIME",?36,"RESOLUTION",!,"OF ERROR",?22,"MESSAGE ID",?36,"STATUS",?48,"DESTINATION"
 W !,INLINE Q
