INHOV ; JMB; 24 Aug 95 14:05; Verify Background Processes
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 Q
 ;
EN ;Main entry point
 ; NEW statements
 N %,%ZIS,ANS,DEF,PROMPT,RANGE,POP,INTASKED,INPAR
 N ZTDESC,ZTIO,ZTRTN,ZTSAVE
 ;
 D:'$G(DUZ) ENV^UTIL
 ;
 ;Get report parameters
 Q:'$$PAR
 ;
 ;IF Device selected is not the user own device, run this routine
 ; in the background.
 ;
 S INTASKED=0 ;Background flag
 ;Get device
 W ! K IOP S %ZIS("A")="QUEUE ON DEVICE: ",%ZIS("B")="",%ZIS="NQ" D ^%ZIS G:POP EXIT^INHOV1
 S IOP=ION_";"_IOST_";"_IOM_";"_IOSL
 ;User did not select their own device, force queue to taskman
 I IO=IO(0) S %ZIS="" D ^%ZIS I POP W *7,!,"Sorry, unable to find device..." G EXIT^INHOV1
 I IO'=IO(0) D  G EXIT^INHOV1
 . S INTASKED=1,ZTDESC="GIS Verify Background Process",ZTIO=IOP,ZTRTN="EN^INHOV1"
 . F X="INPAR(","INTASKED" S ZTSAVE(X)=""
 . D ^%ZTLOAD
 ;
 ;Go to compilation and display module
 G EN^INHOV1
 Q
 ;
PAR() ;User parameters
 ;OUTPUT:
 ;  INPAR - array of report parameters
 ;  function - user did not abort ( 0 - no ; 1 - yes )
 ;
 K INPAR
 S INPAR("DETAIL")=1    ;detail report
 S INPAR("REPAINT")=5   ;repaint frequency
 S INPAR("ITER")=100    ;number of report scans to run (printer)  
 ;
 ;Quit if user accepts default parameters
 S %=$$RD^INHUTS1("Modify default parameters") Q:'% %'=U W !
 S INPAR("DETAIL")=$$RD^INHUTS1("Detailed Report",INPAR("DETAIL")) Q:INPAR("DETAIL")=U 0
 S INPAR("REPAINT")=$$RD^INHUTS1("Repaint Frequency (sec)",INPAR("REPAINT"),"0,3600") Q:INPAR("REPAINT")=U 0
 S INPAR("ITER")=$$RD^INHUTS1("Maximum number of iterations (printer only)",INPAR("ITER"),"0,999") Q:INPAR("ITER")=U 0
 Q 1
