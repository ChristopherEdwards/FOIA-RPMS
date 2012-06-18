INHVAM(UIF,ERROR) ;JSH-DGH; 8 Jul 94 11:22;Transceiver for MDIS messages
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 ;INPUT:
 ;  UIF   - ien in Universal Interface file (#4001)
 ;  ERROR - array to contain any error message(s)
 ;OUPTUT:
 ;  ERROR - array of error message(s)
 ;  function value - status of transmission
 ;     [  0 - successful ;  1 - failure ]
 ;
 ;First, set an entry in the MDIS MESSAGE EXCHANGE FILE
 N DIC,DLAYGO,%,LCT,INZ,LINE,DIK,DA
 S X=$$NOW^UTDT("S"),DIC="^INVAM(",DIC(0)="L",DLAYGO=4095 D ^DICN
 I Y<0 S ERROR(1)="Unable to create entry in MDIS MESSAGE FILE" Q 1
 S INZ=+Y L +^INVAM(INZ)
 S (%,LCT)=0 F  D GETLINE^INHOU(UIF,.LCT,.LINE) Q:'$D(LINE)  D
 . ;copy main line
 . S %=%+1,^INVAM(INZ,1,%,0)=LINE
 . ;Copy overflow nodes
 . F I=1:1 Q:'$D(LINE(I))  S ^INVAM(INZ,1,%+I,0)=LINE(I)
 . S %=%+I-1,^INVAM(INZ,1,%,0)=^INVAM(INZ,1,%,0)_$C(13)
 ;set message terminator
 S %=%+1,^INVAM(INZ,1,%,0)=$C(28)_$C(13)
 S ^INVAM(INZ,1,0)=U_U_%_U_%
 S $P(^INVAM(INZ,0),U,4)=0
 ;Cross-reference the entry
 S DA=INZ,DIK="^INVAM(" D IX1^DIK
 ;Unlock and quit
 L -^INVAM(INZ) Q 0
 ;
AUTOP ;Autopurge of messages
 ;Default retention period is 14 DAYS
 S INDAYS=14 G ZTPUR
 Q
 ;
PURGE ;Purge entries in ^INVAM
 N INDAYS,X,ZTIO,ZTRTN,ZTSAVE,ZTDESC,ZTSK
 W !,"Purge messages from the MDIS/CHCS MESSAGE EXCHANGE file (^INVAM)",!
 W ! D ^UTSRD("Number of days to keep transactions: ;;;;14;7,60")
 Q:X=""!(X[U)  S INDAYS=+X
 S ZTIO="",ZTRTN="ZTPUR^INHVAM",ZTSAVE("INDAYS")="",ZTDESC="Purge MDIS messages"
 D ^%ZTLOAD W !,"Request",$S($G(ZTSK):" ",1:" NOT "),"queued"
 Q
 ;
ZTPUR ;Taskman entry point
 Q:$G(INDAYS)<3
 S X1=DT,X2=-INDAYS D C^%DTC S INDAYS=+X
 S DIK="^INVAM(",INX=0,INCOUNT=0
 F  S INX=$O(^INVAM(INX)) Q:'INX  I +$G(^INVAM(INX,0))<INDAYS S DA=INX D ^DIK,HANG
 Q
 ;
HANG ;Limit entries deleted to 11,000 per hour
 S INCOUNT=INCOUNT+1 Q:INCOUNT<3  S INCOUNT=0 H 1
 Q
 ;
