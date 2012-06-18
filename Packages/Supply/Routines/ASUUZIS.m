ASUUZIS ; IHS/ITSC/LMH -INTERFACE WITH %ZIS ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;This is a utility routine which provides a front end to ^%ZIS.
 ;It uses a local variable array to save information about the
 ;files opened by involking ^%ZIS. Entry points are provided for
 ;Opening (O), Closing (C), Selecting (S) and Using (U) devices as well
 ;as for Killing the array (K) and Double Queueing (Q).
 D S0 Q:$G(POP)
 S ASUK("PTRSEL")=""
 Q
S ;EP; SELECT AND CHECK FOR BOTH QUEUED
 D S0 Q:$G(POP)
 I ASUK("PTR")="IRPT",ASUK("SRPT","Q")=1,'$D(IO("Q")) W !,"Standard Reports are Queued, Invoice reports must also be Queued" G S
 S ASUK("PTRSEL")=1
 Q
S0 ;
 S:'$D(ASUK("PTR")) ASUK("PTR")="PRINTER"
 I $D(%ZIS("A")) S %ZIS("B")=$S(%ZIS("A")["Stand":$G(ASUP("STD")),%ZIS("A")["Invo":$G(ASUP("IVD")),1:"") S ASUK(ASUK("PTR"),"IOP")=%ZIS("B")
 S %ZIS=$G(%ZIS) ;S:%ZIS'["Q" %ZIS=%ZIS_"Q"
 S ASUK(ASUK("PTR"),"ZIS")=%ZIS
 I $G(ASUK(ASUK("PTR"),"IOP"))="HFS" D
 .I $G(ASUG("MEDIUM"))']"" D
 ..N DIR
 ..W !!,"HFS file "_$S($G(ASUK(ASUK("PTR"),"IOPAR"))']"":"NOT DEFINED",1:$P($P(ASUK(ASUK("PTR"),"IOPAR"),"(",2),":"))_" is the default for the prompt",!,$G(%ZIS("A"))
 ..S DIR(0)="Y",DIR("B")="Y"
 ..S DIR("A")="Is that OK" D ^DIR
 .E  S Y=1
 .I Y D ASUUZIS1
 .E  K %ZIS("B") D ^%ZIS
 E  D
 .D ^%ZIS
 I $G(POP) S ASURX="W !,""Unable to Select Device""" D ^ASUUPLOG Q
 D V
 I ASUK(ASUK("PTR"),"ZIS")'["O" D ^%ZISC
 K ASUK(ASUK("PTR"),"ZIS")
 Q
U ;EP; USE PRINTER DEVICE
 I $D(ASUK("PTR")) D
 .S IO(0)=$G(ASUK(ASUK("PTR"),0))
 .S IO("S")=$G(ASUK(ASUK("PTR"),"S"))
 .S IO=$G(ASUK(ASUK("PTR"),"IO"))
 .S IOM=$G(ASUK(ASUK("PTR"),"IOM"))
 .S IOF=$G(ASUK(ASUK("PTR"),"IOF"))
 .S ION=$G(ASUK(ASUK("PTR"),"ION"))
 .S IOST=$G(ASUK(ASUK("PTR"),"IOST"))
 .S IOSL=$G(ASUK(ASUK("PTR"),"IOSL"))
 .S IOPAR=$G(ASUK(ASUK("PTR"),"IOPAR"))
 I IO']"" D HOME^%ZIS
 U IO
 Q
O ;EP; OPEN DEVICE ENTRY POINT.
 U IO(0) S %ZIS("A")="Select Printer : ",%ZIS="OQM" ; JDH added M to ask for right margin
 S:'$D(ASUK("PTR")) ASUK("PTR")="PRINTER"
 I $D(ASUK(ASUK("PTR"),"IOP")) D
 .S IOP=ASUK(ASUK("PTR"),"IOP")
 .S:IOP["HFS" IOP=ASUK(ASUK("PTR"),"IO")
 I $D(ASUK(ASUK("PTR"),"IOPAR")) D
 .S %ZIS("IOPAR")=ASUK(ASUK("PTR"),"IOPAR")
 .S IOPAR=%ZIS("IOPAR")
 D ^%ZIS
 I $G(POP) S ASURX="W !,""Unable to Select and Open Printer"",!" D ^ASUUPLOG Q
 D V
 S ASUK(ASUK("PTR"),"O")=1
 I ASUK(ASUK("PTR"),"Q") D T Q
 Q
C ;EP; CLOSE DEVICE ENTRY POINT.
 I ASUK(ASUK("PTR"),0)=ASUK(ASUK("PTR"),"IO"),ASUK(ASUK("PTR"),"S")']"" W @IOF D K U IO(0) Q
 I $D(ASUK("PTR-Q")),ASUK("PTR-Q") S IO=ASUK(ASUK("PTR"),"IO") D ^%ZISC D K U IO(0) Q
 D U W @(ASUK(ASUK("PTR"),"IOF")) D ^%ZISC U IO(0) D K
 Q
K ;
 K ASUK("PTR-Q")
K2 ;
 K ASUK(ASUK("PTR")),ASUK("PTRSEL")
 K ASUK("PTR")
 Q
Q ;EP; DOUBLE QUEUE
 S XBFQ=1,XBION=ASUK(ASUK("PTR"),"ION"),IOP=ASUK(ASUK("PTR"),"IOP")
 S XBNS="ASU" D ^XBDBQUE
 Q
V ;
 S:'$D(ASUK("PTR")) ASUK("PTR")="PRINTER"
 S ASUK(ASUK("PTR"),0)=IO(0)
 S ASUK(ASUK("PTR"),"S")=$G(IO("S"))
 S ASUK(ASUK("PTR"),"IO")=IO
 S ASUK(ASUK("PTR"),"IOM")=IOM
 S ASUK(ASUK("PTR"),"IOF")=IOF
 S ASUK(ASUK("PTR"),"ION")=ION
 S ASUK(ASUK("PTR"),"IOST")=IOST
 S ASUK(ASUK("PTR"),"IOSL")=IOSL
 S ASUK(ASUK("PTR"),"IOPAR")=IOPAR
 S ASUK(ASUK("PTR"),"IOP")=ION_";"_IOST_";"_$S($D(IOM):IOM,ASUK("PTR")="IRPT":80,1:132)_";"_$S($D(IOSL):IOSL,1:66)
 S ASUK(ASUK("PTR"),"Q")=$S($D(IO("Q")):1,1:0)
 S ASUK("PTR-Q")=$S($D(IO("Q")):1,1:0)
 Q
T ;
 S ZTSAVE("ZTDESC")=$G(ZTSAVE("ZTDESC"))
 S ZTIO=ASUK(ASUK("PTR"),"IOP")
 S ZTSAVE("ASU*")=""
 D ^%ZTLOAD
 K ASURZX
 W !!,$S($D(ZTQUEUED):"Request Queued!",1:"Request Cancelled!")
 D ^%ZISC
 S DIR(0)="E" D ^DIR K DIR
 Q
ASUUZIS1 ;HOST FILE SERVER OPEN
 F X=0:0 S X=$O(^%ZIS(1,X)) Q:'X  I ^%ZIS(1,X,"TYPE")="HFS" D  Q:'$G(POP)
 .S (ASUK(ASUK("PTR"),"IOP"),IOP)=$P(^%ZIS(1,X,0),U)
 .S ASUK(ASUK("PTR"),"IO")=$P(^%ZIS(1,X,0),U,2)
 .S:$G(ASUK(ASUK("PTR"),"IOPAR"))]"" %ZIS("IOPAR")=ASUK(ASUK("PTR"),"IOPAR")
 .D ^%ZIS
 Q
