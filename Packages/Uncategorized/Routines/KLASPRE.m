KLASPRE ;;DEC 18,1990@13:54:58 ;[ 01/27/92  8:42 AM ]
 ;;1.0
DOC W !,"The CLASSMAN software no longer uses its own device file."
 W !,"It uses the Kernel/Fileman Device file in the following manner:",!
 W !,?5,"1. Loopbacks: Ports that are to be used as Loopbacks are to be named as",!,"CLASS1, CLASS2, ect. and be given the same HUNT GROUP ""KLASMAN"".",!
 W !!,?5,"2. Communication Ports: Port lines communicating to IDCU, VADATS, modems,",!,"other CPUs, ect. may be given any name desired but must have a mneumonic",!,"name of ""KLASDEV"" entered to be available to the Classman software."
 W !!
 I '$D(^DIC(1200)) W !,"No previous files -- Preinit Completed",! Q
 S DIU=1200,DIU(0)="DET" W !!,"Deleting the Classman Classes file.",! D EN^DIU2 ; KILL OLD CLASSES FILE 
 W !,?5,"Deleting the old Classman Device file. No longer used.",! I $D(^DDIC(1200.2)) S DIU=1200.2,DIU(0)="DET" D EN^DIU2 ; DELETE OLD CLASSMAN DEVICES FILE
 W !,?5,"Deleting the old 1200.3 file. No longer used.",! I $D(^DIC(1200.3)) S DIU=1200.3,DIU(0)="DET" D EN^DIU2
 W !,?5,"Deleting the old 1200.5 file. No longer used.",! I $D(^DIC(1200.5)) S DIU=1200.5,DIU(0)="DET" D EN^DIU2 ; DELETE OLD CLASSMAN TRANSFERS FILE
 K DIU
 D ^KLASPREI
 W !,"Preinit Completed",!
 Q
