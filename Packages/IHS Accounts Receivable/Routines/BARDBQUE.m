BARDBQUE ; IHS/SD/LSL - DOUBLE QUEING SHELL HANDLER ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**3,19**;OCT 26, 2005
 ;
 ; *********************************************************************
 ; VARIABLES NEEDED BY PASSING PROGRAM
 ; (to change to your name space replace all 'BAR' with your
 ; 'NAME SPACE' ... be sure to watch how the variables map with your
 ; existing routines) mandatories
 ;
 ; BARQ("RC") - compute routine (required for double queuing. If not
 ;              present BARQ("RP") will still be queued w/ BARQ("ION"))
 ; BARQ("RP") - print routine
 ; BARQ("RX") - exit routine that cleans variables
 ; BARQ("NS") - name space of variables to auto load in ZTSAVE("NS*")=""
 ;
 ; optionals
 ;
 ; BARQ("ION")         - forced printer ION with _";"_ characteristics
 ; BARQ("IOPAR")=IOPAR - of preselected device
 ; BARQ("FQ")=1        - force queuing
 ; BARQ("SL")=1        - if slave printing is allowed when queuing
 ; BARQ("DTH")=FM      - date time of computing/printing .. or .. =$H
 ; *********************************************************************
 ;
SET ;
 ; Set up BARQ variables
 S BARQ("RC")=$G(BARQ("RC"))
 S BARQ("NS")=$G(BARQ("NS"))
 S BARQ("X")="ZTSAVE("""_BARQ("NS")_"*"")"
 ; -------------------------------
 ;
DEV1 ;
 ; Select Device
 W !!
 K IO("Q")
 S %ZIS="NPQ"
 ; IHS/SD/PKD - 05/25/10 - V1.8*19
 I $G(BAR("OPT"))="TDN" S %ZIS="QM"  ; ask width
 S %ZIS("A")="Output DEVICE: "
 D ^%ZIS
 I $G(POP)!'$D(IO) S DUOUT="" W !,"REPORTING ABORTED",!,*7 G END
 S BARQ("ION")=ION_";"_IOST_";"_IOM_";"_IOSL
 I $D(IO("DOC")) D
 . S BARQ("ION")=$P(BARQ("ION"),";",1,2)
 . S $P(BARQ("ION"),";",3)=IO("DOC")
 S BARQ("IO")=IO
 S BARQ("IOPAR")=$G(IOPAR)
 S BARQ("CPU")=$G(IOCPU)
 S BARQ("IOT")=IOT
 I $D(IO("Q")),IO=IO(0),'$G(BARQ("SL")) W !,"Queing to slave printer not allowed ... Report Aborting" G END
 ; -------------------------------
 ;
QUE1 ;
 ; que
 I IO'=IO(0) D  K IO("Q"),BARQ,BAR,BARD Q
 . S ZTDESC="Double Que Computing  "_BARQ("RC")_"  "_BARQ("RP")
 . S ZTRTN="DEQUE1^BARDBQUE"
 . S:$D(BARQ("DTH")) ZTDTH=BARQ("DTH")
 . S:BARQ("CPU")]"" ZTCPU=BARQ("CPU")
 . S ZTSAVE("BAR*")=""
 . S:BARQ("NS")]"" @BARQ("X")=""
 . I $G(ION)="HFS" S ZTIO("H")=IO  ;IHS/SD/TPF 7/6/2007 IM25238 DOUBLE QUEUER WOULD NOT USE FILE NAME ENTERED BY USER
 . D ^%ZTLOAD
 . W:$G(ZTSK) !,"Task # ",ZTSK," queued.",!
 . W:'$G(ZTSK) !,*7,"REPORTING ABORTED"
 . D EOP^BARUTL(1)
 . D HOME^%ZIS
 ; -------------------------------
 ;
SLAVE ;
 ; Open slave device
 I $D(IO("S")) S IOP=ION D ^%ZIS
 ; -------------------------------
 ;
DEQUE1 ; EP 
 ; 1st deque | do computing routine
 ;
 D:BARQ("RC")]"" @(BARQ("RC"))
 D @(BARQ("RP"))
 I $D(IO("S")) D ^%ZISC        ; close slave printer
 ; -------------------------------
 ;
END ; EP  ;> cleanup
 ;
 D @(BARQ("RX")) ;>perform cleanup
 I $D(ZTQUEUED) D KILL^%ZTLOAD
 K BARQ,ZTSK,IO("Q"),BARD,BAR
 Q
