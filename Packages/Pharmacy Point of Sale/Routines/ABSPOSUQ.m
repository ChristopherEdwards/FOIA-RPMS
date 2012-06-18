ABSPOSUQ ; IHS/OIT/CNI/SCR - DOUBLE QUEING SHELL HANDLER ;  
 ;;1.0;PHARMACY POINT OF SALE;**39**;JUN 21, 2001
 ;Taken from ABMDRDBQ
 ;;
 ;
 ; VARIABLES NEEDED BY PASSING PROGRAM
 ;(to change to your name space replace all 'ABSP' with your 'NAME SPACE' ... be sure to watch how the variables map  with your existing routines)
 ; mandatories
 ;
 ; ABSPQ("RC")-compute routine (required for double queuing. If not present ABSPQ("RP") will still be queued with ABSPQ("ION"))
 ; ABSPQ("RP")-print routine
 ; ABSPQ("RX")-exit routine that cleans variables
 ; ABSPQ("NS")-name space of variables to auto load in ZTSAVE("NS*")=""
 ;
 ; optionals
 ;
 ; ABSPQ("ION")-forced printer ION with _";"_ characteristics
 ; ABSPQ("IOPAR") = IOPAR of preselected device
 ; ABSPQ("FQ")=1 force queuing
 ; ABSPQ("SL")=1 - if slave printing is allowed when queuing
 ; ABSPQ("DTH")=FM date time of computing/printing .. or .. =$H
 ;
SET(ABSPQ) ;SET UP ABSPQ VARIABLES
 S ABSPQ("RC")=$G(ABSPQ("RC")),ABSPQ("NS")=$G(ABSPQ("NS")),ABSPQ("X")="ZTSAVE("""_ABSPQ("NS")_"*"")"
 ;
DEV1 ;>Select Device
 W !! S %ZIS="NPQ",%ZIS("A")="Output DEVICE: " D ^%ZIS
 I $G(POP)!'$D(IO) S DUOUT="" W !,"REPORTING ABORTED",!,*7 G END ;--->
 S ABSPQ("ION")=ION_";"_IOST_";"_$S($D(ABSP(132)):132,1:80)_";"_IOSL
 I $D(IO("DOC")) S ABSPQ("ION")=$P(ABSPQ("ION"),";",1,2),$P(ABSPQ("ION"),";",3)=IO("DOC")
 S ABSPQ("IO")=IO,ABSPQ("IOPAR")=$G(IOPAR),ABSPQ("CPU")=$G(IOCPU),ABSPQ("IOT")=IOT
 I $D(IO("Q")),IO=IO(0),'$G(ABSPQ("SL")) W !,"Queing to slave printer not allowed ... Report Aborting" G END ;--->
 ;I $D(ABSP(132)) D ^ABSPDR16 Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 ;
QUE1 ;que
 I IO'=IO(0) D  K IO("Q"),ABSPQ,ABSP,ABSPD Q
 .S ZTDESC="Double Que Computing  "_ABSPQ("RC")_"  "_ABSPQ("RP"),ZTRTN="DEQUE1^ABSPOSUQ"
 .S:$D(ABSPQ("DTH")) ZTDTH=ABSPQ("DTH") S:ABSPQ("CPU")]"" ZTCPU=ABSPQ("CPU") S ZTSAVE("ABSP*")="" S:ABSPQ("NS")]"" @ABSPQ("X")=""
 .D ^%ZTLOAD
 .W:$G(ZTSK) !,"Task # ",ZTSK," queued.",!
 .W:'$G(ZTSK) !,*7,"REPORTING ABORTED"
 .D EOP
 .D HOME^%ZIS
 ;
SLAVE ;OPEN SLAVE DEVICE
 I $D(IO("S")) S IOP=ION D ^%ZIS
 ;
DEQUE1 ;EP  ;> 1st deque | do computing routine
 ;
 D:ABSPQ("RC")]"" @(ABSPQ("RC"))
 D @(ABSPQ("RP"))
 I $E(IOST)="C" D  I 1
 .Q:IOT'["TRM"
 .Q:$D(ZTQUEUED)
 .Q:$D(IO("S"))
 .Q:$D(DTOUT)!($D(DIROUT))!($D(DUOUT))
 .W ! S DIR(0)="FO",DIR("A")="(REPORT COMPLETE)" D ^DIR K DIR
 E  W !!,"E N D  O F  R E P O R T" W:$Y $$EN^ABMVDF("IOF")
 ;D 10^ABMDR16:$D(ABSP("PRINT",16))
 I $D(IO("S")) D ^%ZISC ;> close slave printer
 ;
 ;--------
END ;EP  ;> cleanup
 ;
 ;D @(ABSPQ("RX")) ;>perform cleanup
 I $D(ZTQUEUED) D KILL^%ZTLOAD
 K ABSPQ,ZTSK
 Q
EOP(X) ;EP - end of page
 ;X=0, 1, or 2
 Q:$G(IOT)'["TRM"
 Q:$E($G(IOST))'="C"
 Q:$D(IO("S"))
 Q:$D(ZTQUEUED)
 F  W ! Q:$Y+4>IOSL
 Q:X=2
 S DIR(0)="E"
 S:X=1 DIR("A")="Enter RETURN to continue"
 D ^DIR
 K DIR
 Q
