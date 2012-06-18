ABMDRDBQ ; IHS/ASDST/DMJ - DOUBLE QUEING SHELL HANDLER ;  
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;03/25/96 11:32 AM
 ;;
 ;IHS/DSD/DMJ - 3/22/1999 - NOIS HQW-0399-100107 Patch 1
 ;            Modified check to IOT to allow 'virtual' terminals
 ;
 ; VARIABLES NEEDED BY PASSING PROGRAM
 ;(to change to your name space replace all 'ABM' with your 'NAME SPACE' ... be sure to watch how the variables map  with your existing routines)
 ; mandatories
 ;
 ; ABMQ("RC")-compute routine (required for double queuing. If not present ABMQ("RP") will still be queued with ABMQ("ION"))
 ; ABMQ("RP")-print routine
 ; ABMQ("RX")-exit routine that cleans variables
 ; ABMQ("NS")-name space of variables to auto load in ZTSAVE("NS*")=""
 ;
 ; optionals
 ;
 ; ABMQ("ION")-forced printer ION with _";"_ characteristics
 ; ABMQ("IOPAR") = IOPAR of preselected device
 ; ABMQ("FQ")=1 force queuing
 ; ABMQ("SL")=1 - if slave printing is allowed when queuing
 ; ABMQ("DTH")=FM date time of computing/printing .. or .. =$H
 ;
SET ;SET UP ABMQ VARIABLES
 S ABMQ("RC")=$G(ABMQ("RC")),ABMQ("NS")=$G(ABMQ("NS")),ABMQ("X")="ZTSAVE("""_ABMQ("NS")_"*"")"
 ;
DEV1 ;>Select Device
 W !! S %ZIS="NPQ",%ZIS("A")="Output DEVICE: " D ^%ZIS
 I $G(POP)!'$D(IO) S DUOUT="" W !,"REPORTING ABORTED",!,*7 G END ;--->
 S ABMQ("ION")=ION_";"_IOST_";"_$S($D(ABM(132)):132,1:80)_";"_IOSL
 I $D(IO("DOC")) S ABMQ("ION")=$P(ABMQ("ION"),";",1,2),$P(ABMQ("ION"),";",3)=IO("DOC")
 S ABMQ("IO")=IO,ABMQ("IOPAR")=$G(IOPAR),ABMQ("CPU")=$G(IOCPU),ABMQ("IOT")=IOT
 I $D(IO("Q")),IO=IO(0),'$G(ABMQ("SL")) W !,"Queing to slave printer not allowed ... Report Aborting" G END ;--->
 I $D(ABM(132)) D ^ABMDR16 Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 ;
QUE1 ;que
 I IO'=IO(0) D  K IO("Q"),ABMQ,ABM,ABMD Q
 .S ZTDESC="Double Que Computing  "_ABMQ("RC")_"  "_ABMQ("RP"),ZTRTN="DEQUE1^ABMDRDBQ"
 .S:$D(ABMQ("DTH")) ZTDTH=ABMQ("DTH") S:ABMQ("CPU")]"" ZTCPU=ABMQ("CPU") S ZTSAVE("ABM*")="" S:ABMQ("NS")]"" @ABMQ("X")=""
 .D ^%ZTLOAD
 .W:$G(ZTSK) !,"Task # ",ZTSK," queued.",!
 .W:'$G(ZTSK) !,*7,"REPORTING ABORTED"
 .D EOP^ABMDUTL(1)
 .D HOME^%ZIS
 ;
SLAVE ;OPEN SLAVE DEVICE
 I $D(IO("S")) S IOP=ION D ^%ZIS
 ;
DEQUE1 ;EP  ;> 1st deque | do computing routine
 ;
 D:ABMQ("RC")]"" @(ABMQ("RC"))
 D @(ABMQ("RP"))
 I $E(IOST)="C" D  I 1
 .Q:IOT'["TRM"
 .Q:$D(ZTQUEUED)
 .Q:$D(IO("S"))
 .Q:$D(DTOUT)!($D(DIROUT))!($D(DUOUT))
 .W ! S DIR(0)="FO",DIR("A")="(REPORT COMPLETE)" D ^DIR K DIR
 E  W !!,"E N D  O F  R E P O R T" W:$Y $$EN^ABMVDF("IOF")
 D 10^ABMDR16:$D(ABM("PRINT",16))
 I $D(IO("S")) D ^%ZISC ;> close slave printer
 ;
 ;--------
END ;EP  ;> cleanup
 ;
 D @(ABMQ("RX")) ;>perform cleanup
 I $D(ZTQUEUED) D KILL^%ZTLOAD
 K ABMQ,ZTSK
 Q
