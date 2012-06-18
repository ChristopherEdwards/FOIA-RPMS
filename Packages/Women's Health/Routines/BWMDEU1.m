BWMDEU1 ;IHS/ANMC/MWR - MDE FUNCTIONS.;29-Oct-2003 21:38;PLS
 ;;2.0;WOMEN'S HEALTH;**8,9**;MAY 16, 1996
 ; CDC Utility functions to extract building.
 ;
HFS ; EP - Save data from ^BWTMP( to host file server.
 ;
 I '$D(^BWTMP($J)) D  Q
 . D ^%ZISC
 . Q:$D(BWSILENT)
 . W !!?5,"NO RECORDS TO BE EXPORTED." D DIRZ^BWUTL3
 ;
 ; If this is an extract then offer to write file out to screen.
 S BWCAPT="h"
 I 'BWXPORT D  Q:BWPOP
 . N DIR U IO(0)
 . W !!?3,"Do you wish to save this to the Host File ",BWPATH,BWFLNM,","
 . W !?3,"or write it to your screen for capture by a PC?",!
 . S DIR("A")="   Select HOST or SCREEN: ",DIR("B")="HOST"
 . S DIR(0)="SAM^h:HOST;s:SCREEN" D HELP1^BWMDE4
 . D ^DIR
 . I $D(DIRUT) S BWPOP=1 Q
 . S BWCAPT=Y
 . I Y="s" D  Q
 . . U IO(0)
 . . W !!?5,"Screen print of the file will follow immediately."
 . . D DIRZ^BWUTL3
 . . U IO
 I BWXPORT D  Q:BWPOP
 . S BWPATH=$P(^BWSITE(DUZ(2),0),U,14)  ;K IO(1)
 . S BWFLNM=$P(^BWSITE(DUZ(2),0),U,13)_$E(DT,4,5)_$E(DT,2,3)_$S($G(BWXPORT):"",1:"LC")_BWCDCV
 . S BWPOP=$$OPEN^%ZISH(BWPATH,BWFLNM,"W")
 . I BWPOP D ^%ZISC,ERROR S BWPOP=1
 U IO W ""
 N N,M S N=0,BWCOUNT=0
 F  S N=$O(^BWTMP($J,N)) Q:'N  D
 . S M=0
 . F  S M=$O(^BWTMP($J,N,M)) Q:'M  D
 . . U IO W ^BWTMP($J,N,M),! S BWCOUNT=BWCOUNT+1
 . . I '$D(BWSILENT) U 0 W "/" ;IHS/CMI/THL PATCH 7 ;PATCH 8
 D ^%ZISC
 I '$D(BWSILENT),BWCAPT="s" D DIRZ^BWUTL3 Q
 I '$D(BWSILENT) D  ;IHS/CIM/THL PATCH 8
 . W !!?5,"File ",BWPATH_BWFLNM
 . W " successfully saved to Host File Server."
 . W !!?5,"Records exported...........................................: "
 . W $J(BWCOUNT,6)
 . D NOFAC,DIRZ^BWUTL3
 ; Quit if this was only an exrtact (BWXPORT=0).
 I 'BWXPORT Q
 E  D SAVELOG^BWMDE4
 Q
 ;
 ;
ERROR ;EP
 I $D(BWSILENT)!($D(ZTQUEUED)) Q
 W !!?5,"* Save to Host File Server FAILED.  Contact your sitemanager."
 D DIRZ^BWUTL3
 Q
 ;
 ;
NOFAC ;EP
 W !?5,"Total Procedures rejected: "
 W ?33,"Not done at a selected facility: ",$J(BWOFAC,6)
 W !?33,"No facility entered............: ",$J(BWNOFAC,6)
 Q
