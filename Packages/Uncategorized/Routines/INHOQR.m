INHOQR ; FRW/JMB ; 24 Aug 95 14:10; Show GIS queue status
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
EN ;Main entry point
 ;NEW statements
 ;
 N %,%ZIS,Q,POP,INTASKED,INPAR
 N ZTDESC,ZTIO,ZTRTN,ZTSAVE
 ;
 ;Get report parameters
 Q:'$$PAR
 ;
 ;Background flag
 S INTASKED=0
 ;Get device
 W ! K IOP S %ZIS("A")="QUEUE ON DEVICE: ",%ZIS("B")="",%ZIS="NQ" D ^%ZIS G:POP EXIT^INHOQR1
 S IOP=ION_";"_IOST_";"_IOM_";"_IOSL
 ;User did not select their own device, force queue to taskman
 I IO=IO(0) S %ZIS="" D ^%ZIS I POP W *7,!,"Sorry, unable to find device..." G EXIT^INHOQR1
 I IO'=IO(0) D  G EXIT^INHOQR1
 .  S INTASKED=1,ZTDESC="GIS Queue Status",ZTIO=IOP,ZTRTN="ENZTSK^INHOQR1"
 .  F X="INPAR(","INTASKED" S ZTSAVE(X)=""
 .  D ^%ZTLOAD
 ;
 ;Go to compilation and display module
 G ENZTSK^INHOQR1
 ;
 Q
 ;
PAR() ;User parameters
 ;OUTPUT:
 ;  INPAR - array of report parameters
 ;  function - user did not abort ( 0 - no ; 1 - yes )
 ;
 K INPAR
 S INPAR("DETAIL")=1     ;detailed report
 S INPAR("REPAINT")=5    ;repaint frequency
 S INPAR("RUNTOEND")=0   ;always run to end of queues
 S INPAR("MAXREPTIME")=1800   ;max time to spend in one rpeort scan
 S INPAR("MAXQTIME")=INPAR("MAXREPTIME")   ;max time to spend scanning a queue
 S INPAR("ITER")=100    ;number of report scans to run (printer)
 S INPAR("FUTURE")=0    ;report future tasks
 ;S INPAR("GRAPH")=0     ;single graph output
 ;
 ;Quit if user accepts default paramters
 S %=$$RD^INHUTS1("Modify default paramters") Q:'% %'=U W !
 S INPAR("DETAIL")=$$RD^INHUTS1("Detailed report",INPAR("DETAIL")) Q:INPAR("DETAIL")=U 0
 S INPAR("REPAINT")=$$RD^INHUTS1("Repaint Frequency (sec)",INPAR("REPAINT"),"0,3600") Q:INPAR("REPAINT")=U 0
 S INPAR("FUTURE")=$$RD^INHUTS1("Include future tasks") Q:INPAR("FUTURE")=U 0
 S INPAR("RUNTOEND")=$$RD^INHUTS1("Always scan to end of queue") Q:INPAR("RUNTOEND")=U 0
 I 'INPAR("RUNTOEND") D  Q:INPAR("MAXREPTIME")=U 0
 .  S INPAR("MAXREPTIME")=$$RD^INHUTS1("Maximum time to spend compiling report (sec)",INPAR("MAXREPTIME"),"0,99999")
 S INPAR("MAXQTIME")=INPAR("MAXREPTIME")
 ;S INPAR("GRAPH")=$$RD^INHUTS1("Graph output") Q:INPAR("GRAPH")=U 0
 S INPAR("ITER")=$$RD^INHUTS1("Maximum number of iterations (printer only)",INPAR("ITER"),"0,9999") Q:INPAR("ITER")=U 0
 Q 1
 ;
INIARR ;Initialize data and queue arrays
 ;OUTPUT:
 ;  INDAT - array of data for each queue
 ;  INDEST - array of queues to check
 ;
 N INQ,BP
 K INDAT
 ;Detemine destinations queues to check
 D DES1^INHUTS1
 ;Intialize data arrays
 F INQ=1,2,400,700,750 D DATINIT(INQ)
 S BP=0 F  S BP=$O(INDEST(BP)) Q:'BP  D DATINIT(BP)
 ;
 Q
 ;
DATINIT(INQ) ;Initialize data array
 ;INPUT:
 ;  INQ - queue entry (ien in Back Proc Control file)
 ;OUTPUT:
 ;  INDAT - array of initialized data for a queue
 ;
 N X
 F X="COUNT","MIN","MAX","AVG","NAME","ITER","TOTC" S INDAT(INQ,X)=""
 Q
