LRZLOCK ;IHS/ANMC/CLS; LOCKS LAB RESULT AND LAB MENUS [ 09/07/90  4:20 PM ]
 ;IHS/ANMC/CLS 09/07/90
 ;
 W !!,"THIS ROUTINE IS TO BE RUN USING CALLS TO AN ENTRY POINT!"
 W !! Q
 ;
NAVAIL ;sets an out of order message into options that access LAB RESULT AND LAB MENU
 ;
 W !!,"TURNS OFF ACCESS TO LAB RESULTS AND THE LAB!!",!!
 R "Are you sure you want to continue?  NO// ",X:DTIME
 Q:X'?1"Y".E
 F I="LRZMENU","LRZANMC" W !,I,"..." D N1
 Q
N1 S DA=$O(^DIC(19,"B",I,0)) Q:DA=""
 G N1:'$D(^DIC(19,DA,0))
 S $P(^DIC(19,DA,0),"^",3)="OPTION NOT AVAILABLE"
 D REDO^XQ7 Q
 ;
AVAIL ;make patient registration options available again
 ;
 W !!,"RESTORES ACCESS TO LAB RESULTS AND THE LAB!",!!
 R "Are you sure you want to continue? NO// ",X:DTIME
 Q:X'?1"Y".E
 F I="LRZMENU","LRZANMC" W !,I,"..." D A1
 Q
A1 S DA=$O(^DIC(19,"B",I,0)) Q:DA=""
 G A1:'$D(^DIC(19,DA,0))
 S $P(^DIC(19,DA,0),"^",3)=""
 D REDO^XQ7 Q
