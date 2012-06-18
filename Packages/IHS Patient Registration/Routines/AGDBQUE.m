AGDBQUE ; IHS/ASDS/EFG - DOUBLE QUEING SHELL HANDLER ;    
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
 ;Thanks to Linda Lehman for the code
 ;
 ;****************************************************************
 ;VARIABLES NEEDED BY PASSING PROGRAM
 ;(to change to your name space replace all 'BAR' with your
 ;'NAME SPACE' ... be sure to watch how the variables map with
 ;your existing routines) mandatories
 ;
 ;AGQ("RC") - compute routine (required for double queuing. If not
 ;            present AGQ("RP") will still be queued w/ AGQ("ION"))
 ;AGQ("RP") - print routine
 ;AGQ("RX") - exit routine that cleans variables
 ;AGQ("NS") - name space of variables to auto load in
 ;            ZTSAVE("NS*")=""
 ;
 ;optionals
 ;
 ;AGQ("ION")         - forced printer ION with _";"_ characteristics
 ;AGQ("IOPAR")=IOPAR - of preselected device
 ;AGQ("FQ")=1        - force queuing
 ;AGQ("SL")=1        - if slave printing is allowed when queuing
 ;AGQ("DTH")=FM      - date time of computing/printing . or . =$H
 ;****************************************************************
 ;
SET ;Set up AGQ variables
 S AGQ("RC")=$G(AGQ("RC"))
 S AGQ("NS")=$G(AGQ("NS"))
 S AGQ("X")="ZTSAVE("""_AGQ("NS")_"*"")"
 ;-------------------------------
DEV1 ;Select Device
 W !!
 K IO("Q")
 S %ZIS="NPQ"
 S %ZIS("A")="Output DEVICE: "
 D ^%ZIS
 I $G(POP)!'$D(IO) S DUOUT="" W !,"REPORTING ABORTED",!,*7 G END
 S AGQ("ION")=ION_";"_IOST_";"_IOM_";"_IOSL
 I $D(IO("DOC")) D
 . S AGQ("ION")=$P(AGQ("ION"),";",1,2)
 . S $P(AGQ("ION"),";",3)=IO("DOC")
 S AGQ("IO")=IO
 S AGQ("IOPAR")=$G(IOPAR)
 S AGQ("CPU")=$G(IOCPU)
 S AGQ("IOT")=IOT
 I $D(IO("Q")),IO=IO(0),'$G(AGQ("SL")) W !,"Queing to slave printer not allowed  ... Report Aborting" G END
 ;-------------------------------
QUE1 ;que
 I IO'=IO(0) D  K IO("Q"),AGQ,AG,AGD Q
 . S ZTDESC="Double Que Computing  "_AGQ("RC")_"  "_AGQ("RP")
 . S ZTRTN="DEQUE1^AGDBQUE"
 . S:$D(AGQ("DTH")) ZTDTH=AGQ("DTH")
 . S:AGQ("CPU")]"" ZTCPU=AGQ("CPU")
 . S ZTSAVE("AG*")=""
 . S:AGQ("NS")]"" @AGQ("X")=""
 . D ^%ZTLOAD
 . W:$G(ZTSK) !,"Task # ",ZTSK," queued.",!
 . W:'$G(ZTSK) !,*7,"REPORTING ABORTED"
 . S X=1 D EOP
 . D HOME^%ZIS
 ;-------------------------------
SLAVE ;Open slave device
 I $D(IO("S")) S IOP=ION D ^%ZIS
 ;-------------------------------
DEQUE1 ;EP - 1st deque | do computing routine
 D:AGQ("RC")]"" @(AGQ("RC"))
 D @(AGQ("RP"))
 I $D(IO("S")) D ^%ZISC        ;close slave printer
 ;-------------------------------
END ;EP  ;> cleanup
 D @(AGQ("RX"))  ;>perform cleanup
 I $D(ZTQUEUED) D KILL^%ZTLOAD
 K AGQ,ZTSK,IO("Q"),AGD,AG
 Q
EOP ;END OF PAGE (Original code from EOP^AGUTL)
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
