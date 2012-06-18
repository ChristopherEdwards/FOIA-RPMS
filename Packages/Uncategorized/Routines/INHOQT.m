INHOQT ; FRW/JMB ; 24 Aug 95 13:29; Show top entries in queues
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
EN ;Main entry point
 ;NEW statements
 N %,INPAR,PROMPT,DEF,RANGE,INTASKED
 ;
 S INTASKED=0 ;report only to be displayed
 ;Get report parameters
 Q:'$$PAR
 ;
 G EN^INHOQT1
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
 S INPAR("ITERT")=5     ;number of times to try and get an entry
 ;
 ;Quit if user accepts default parameters
 S %=$$RD("Modify default parameters") Q:'% %'=U W !
 S INPAR("DETAIL")=$$RD("Detailed report",INPAR("DETAIL")) Q:INPAR("DETAIL")=U 0
 S INPAR("REPAINT")=$$RD("Repaint Frequency (sec)",INPAR("REPAINT"),"0,3600") Q:INPAR("REPAINT")=U 0
 S INPAR("ITERT")=$$RD("Maximum number of times to try for an entry",INPAR("ITERT"),"0,9999") Q:INPAR("ITERT")=U 0
 Q 1
 ;
RD(PROMPT,DEF,RANGE) ;Read a parameter
 Q $$RD^INHUTS1($G(PROMPT),$G(DEF),$G(RANGE))
 ;
INIARR ;Initialize data and queue arrays
 ;OUTPUT:
 ;  INDEST - array destination queues to check
 ;  INDAT 
 ;
 N INQ
 K INDAT
 ;Determine INDEST
 D DES1^INHUTS1
 ;Write queue names in INDAT
 F BP=1,2 D DATINIT(BP)
 S BP=0 F  S BP=$O(INDEST(BP)) Q:'BP  D DATINIT(BP)
 Q
 ;
DATINIT(INQ) ;Initialize INDAT
 ;INPUT 
 ;  INQ - Process Id number
 ;OUTPUT
 ;  INDAT
 ;
 S INDAT(INQ,"NAME")=$P($G(^INTHPC(INQ,0)),U)
 Q
