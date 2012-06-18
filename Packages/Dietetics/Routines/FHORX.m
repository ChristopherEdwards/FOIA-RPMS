FHORX ; HISC/REL - File Dietetic Event ;2/26/96  09:54
 ;;5.0;Dietetics;**2**;Mar 25, 1996
FIL ; File event
 L +^FH(119.8,0) S DA=$P(^FH(119.8,0),"^",3)+1,$P(^FH(119.8,0),"^",3,4)=DA_"^"_DA L -^FH(119.8,0)
 I $D(^FH(119.8,DA)) G FIL
 D NOW^%DTC
 S ^FH(119.8,DA,0)=DA_"^"_%_"^"_DFN_"^"_ADM_"^"_EVT S $P(^(0),"^",9)=DUZ
 S ^FH(119.8,"B",DA,DA)="",^FH(119.8,"AP",DFN,%,DA)="",^FH(119.8,"AD",%,DA)=""
 K %,DA,EVT Q
