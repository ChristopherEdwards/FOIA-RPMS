BARDBQ01 ; IHS/SD/TMM - DOUBLE QUEING SHELL HANDLER - MULTI COPIES ; 07/16/2010
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**3,19**;OCT 26, 2005
 ;
 ; 1. 07/16/2010 TMM Create new routine from BARDBQUE to prompt for and print 
 ;                     multiple report copies
 ;
 ; ==========================================================================
 ; ----------------
 ; R E Q U I R E D
 ; ----------------
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
 ; ----------------
 ; O P T I O N A L 
 ; ----------------
 ; BARQ("ION")         - forced printer ION with _";"_ characteristics
 ; BARQ("IOPAR")=IOPAR - of preselected device
 ; BARQ("FQ")=1        - force queuing
 ; BARQ("SL")=1        - if slave printing is allowed when queuing
 ; BARQ("DTH")=FM      - date time of computing/printing .. or .. =$H
 ; BARQ("QUE")=Q       - to allow queuing to a device (adds "Q" to %ZIS)
 ; BAR("MARGIN")=M     - to prompt for for right margin (adds "M" to %ZIS)
 ; BAR("MULTI")=1       - Prompt for and print multiple report copies
 ; *********************************************************************
 ;
EN ; new entry point
 ; 
 ;
SET ;
 ; Set up BARQ variables
 S BARQ("RC")=$G(BARQ("RC"))
 S BARQ("NS")=$G(BARQ("NS"))
 S BARQ("X")="ZTSAVE("""_BARQ("NS")_"*"")"
 ; -------------------------------
 ;
DEV1 ;
 W !!
 K IO("Q")
 ;remove Queuing for Receipts, parameter can be passed by calling routine using BARQ("QUE")
 ;M819*DEL*TMM*20100723  D SETZIS         ;sets %ZIS
 S %ZIS="NP"_$G(BARQ("QUE"))_$G(BARQ("MARGIN"))
 S BARZIS=%ZIS    ;%ZIS is killed off in ^%ZIS
 S %ZIS("A")="Output DEVICE: "
 D ^%ZIS
 I $G(POP)!'$D(IO) S DUOUT="" W !,"REPORTING ABORTED",!,*7 G END
 I $D(IO("Q")),IO=IO(0),'$G(BARQ("SL")) W !,"Queing to slave printer not allowed ... Report Aborting" G END
 ;
 S BARCOPY=0
 I +$G(BAR("MULTI")) S BARCOPY=$$ASKCOPY()
 I $D(DUOUT)!$D(DUOUT)=1 Q
 I $D(DIROUT) S BARSTOP=1 Q
 ; -------------------------------
 ; If report should be queued, Queue it and Quit
 I BARZIS["Q" D QUE1 Q
 ; -------------------------------
SLAVE ;
 ; Open slave device
 S IOP=$G(ION)_";"_$G(IOST)_";"_$G(IOM)_";"_$G(IOSL)
 I $D(IO("S")) D ^%ZIS     ;open slave device
 I '$D(IO("S")) D ^%ZIS    ;open device        ;M819*ADD*TMM*20100723
 I POP W !!,"REPORTING ABORTED" G END
 ; -------------------------------
 ;
DEQUE1 ;EP  Entry point for queued reports
 ; 1st deque | do computing routine
MULT ;   Print report
 N BARCNT
 S BARCNT=0
 F BARCNT=1:1 D  Q:BARCNT=BARCOPY
 . I BARCNT=1,BARQ("RC")]"" D @(BARQ("RC"))      ;compute data
 . D @(BARQ("RP"))
 . I '$D(IOF) S IOF="#"
 . W @IOF
 I $D(IO("S")) D ^%ZISC          ; close slave printer
 I '$D(IO("S")) D ^%ZISC         ; close printer  ;M819*ADD*TMM*20100723
 ; -------------------------------
 ;
END ; EP  ;> cleanup
 ;
 D @(BARQ("RX"))                    ;>perform cleanup
 I $D(ZTQUEUED) D KILL^%ZTLOAD
 K BAR,BARD,BARQ,BARSAVE,BARZIS,IO("Q"),ZTSK
 Q
 ; -------------------------------
 ;
ASKCOPY() ;EP  Propmt for # of copies to print
 K DIR,DTOUT,DUOUT,DIROUT,DIRUT
 S DIR(0)="NA^1:10:0"
 S DIR("B")=1
 S DIR("A")="Number of copies:  "
 K DA
 D ^DIR
 I $D(DIROUT)!$D(DTOUT)!$D(DUOUT) Q 0
 Q X
 ; -------------------------------
 ;
QUE1 ;
 ; queue if selected device not = home device
 I IO=IO(0) Q
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
 . D HOME^%ZIS             ;resets required IO variables
 Q
