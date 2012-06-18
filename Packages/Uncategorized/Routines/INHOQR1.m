INHOQR1 ; FRW/JMB ; 24 Aug 95 14:18; Show GIS queue status - cont.
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
EN ;Main entry point
 G EN^INHOQR
 Q
 ;
ENZTSK ;Taskman entry point
 ;New Statements
 N BP,BPC,BP0,COUNT,CUR,D,DATA,DATE,DTOUT,DTSAR,DTSOP,EXIT,FMT,GL,H,HDR
 N INDEST,INEXIT,INITER,INQ,INQUEUE,INRUN,INRUNASC
 N IN0,INDAT,INRUNAVG,INTOTAL,LOOP,M,NAME,NODE,OC,P,PAGE,S,X
 N SAR,SEC,SEOV,SESAR,SESARTOT,SESOP,SESOPTOT,SOP,STAT,T,TAB,TOT
 ;
 ;Initialize report variables
 S INEXIT=0,INPAR("START")=$H,INITER=0 H 1
 S INPAR("MSGSTART")=$P(^INTHU(0),U,3),INPAR("TSKSTART")=$P(^INLHFTSK(0),U,3)
 ;Initialize TABs
 S TAB(0)=34,TAB(1)=44,TAB(2)=52,TAB(3)=60,TAB(4)=68
 ;Intialize data array
 D INIARR^INHOQR
 ;Display message
 W:'INTASKED !!,"Compiling ..."
 ;
ENRPT ;Repeat entry point
 ;
 ;Init scan variables
 S INTOTAL=0,INQUEUE=0,INITER=INITER+1
 S (INPAR("REPSTART"),INPAR("QSTART"))=$H
 ;Init queue count by priority for next scan
 D IND^INHOQR2
 ;Format controller
 G:'$$QUEUE("^INLHFTSK(""AH"")",$P(^INTHPC(2,0),U),1) EXIT
 ;Output Controller
 G:'$$QUEUE("^INLHSCH",$P(^INTHPC(1,0),U),2) EXIT
 ;Destination queues
 S BPC=0
 F  S BPC=$O(INDEST(BPC)) Q:'BPC!INEXIT  Q:'$$QUEUE(U_$P(INDEST(BPC),U,2),$P(INDEST(BPC),U),BPC)
 G:INEXIT EXIT
 ;
 ;Provide support for totals
 D ST1(400,INTOTAL,"Queue Total")
 ;
 ;Provide support for message creation rates
 Q:'$$ENTRIES("^INTHU","Messages created per hour",700,"MSGSTART")
 ;
 ;Provide support for transaction identification rates
 Q:'$$ENTRIES("^INLHFTSK","Transactions identified per hour",750,"TSKSTART")
 ;
 ;Repeat display for terminals, one time for printers
 D:'INTASKED DISP^INHOQR2
 ;Check for end of tasked report
 I INTASKED,INITER'<INPAR("ITER") D DISP^INHOQR2 G EXIT
 ;
 ;hang until next recalc
 G:$$QUIT EXIT
 F X=1:1:INPAR("REPAINT") Q:$$QUIT!INEXIT  H 1
 G:INEXIT EXIT
 G ENRPT
 Q
 ;
QUEUE(GL,Q,INQUEUE) ;Determine entries in queue
 ;INPUT:
 ;  GL - location (global) of queue
 ;         queue in format -> @GL@( priority , time to process , ien )
 ;  Q  - name of queue
 ;  INQUEUE - subscript (usually ien) of queue in INDAT array
 ;OUTPUT:
 ;  function - complete processing ( 0 - no ; 1 - yes )
 ;  updated INDAT array with latest queue size data
 ;  updated INTOTAL with total number of entries in all queues
 ;
 ;Intialize variables
 S INPAR("QSTART")=$H,OC=0,P=999,STAT=1
 F  S P=$O(@GL@(P),-1) Q:+P'=P!INEXIT  S H="~" F  S H=$O(@GL@(P,H),-1) Q:'$L(H)!INEXIT  D
 .  ;Check wether to report tasks in the future
 .  I +H>+$H,'INPAR("FUTURE") Q
 .  ;Check wether to report tasks in the future
 .  I $P(H,",",2)>$P($H,",",2),+H=+$H,'INPAR("FUTURE") Q
 .  S M=" " F  S M=$O(@GL@(P,H,M),-1) Q:'M  D  I '(OC#1000),$$QUIT S STAT=0
 ..  S OC=OC+1
 ..  Q:'INPAR("DETAIL")
 ..  ;count entries by priority (P) and Time (NST=Non stat or ST=Stat)
 ..  I H S INDAT(INQUEUE,P,"STN","COUNT")=$G(INDAT(INQUEUE,P,"STN","COUNT"))+1 Q
 ..  S:'H INDAT(INQUEUE,P,"ST","COUNT")=$G(INDAT(INQUEUE,P,"ST","COUNT"))+1
 ;Stats with priorities
 D:INPAR("DETAIL") ST0(INQUEUE)
 ;Stats totals
 D ST1(INQUEUE,OC,Q)
 ;Update total queue entries
 S INTOTAL=INTOTAL+INDAT(INQUEUE,"COUNT")
 Q STAT
 ;
ENTRIES(GL,NAME,INQ,NODE) ;Get entries created in file / hour
 ;INPUT:
 ;  GL - location (global) of file
 ;         file in format -> @GL@( ien )
 ;  NAME  - name of queue
 ;  INQ - subscript of queue in INDAT array
 ;  NODE - node in INPAR that contains the last entry in the file
 ;         when the report was started
 ;OUTPUT:
 ;  function - complete processing ( 0 - no ; 1 - yes )
 ;  updated INDAT array with latest queue size data
 ;
 S CUR=$P(@GL@(0),U,3) S:'INPAR(NODE) INPAR(NODE)=CUR
 S OC=CUR-INPAR(NODE)/($$TDIF^INHUTS(INPAR("START"))+.00001)*3600\1
 D ST1(INQ,OC,NAME)
 Q 1
 ;
ST0(INQ) ;Build Stats - Priority levels
 ;INPUT:
 ;  INQ   = Process Id#
 ;OUTPUT:
 ;  updated INDAT array with latest queue size sorted by priority
 ;
 N P,T,COUNT
 S P=""
 F  S P=$O(INDAT(INQ,P)) Q:+P'=P  S T="" F  S T=$O(INDAT(INQ,P,T))  Q:'$L(T)  D
 .S COUNT=INDAT(INQ,P,T,"COUNT")
 .;Minimum
 .S:COUNT<$G(INDAT(INQ,P,T,"MIN"))!($G(INDAT(INQ,P,T,"MIN"))="") INDAT(INQ,P,T,"MIN")=COUNT
 .;Maximum
 .S:COUNT>$G(INDAT(INQ,P,T,"MAX"))!($G(INDAT(INQ,P,T,"MAX"))="") INDAT(INQ,P,T,"MAX")=COUNT
 .;Total entries sorted by priority-time (T is either "ST"
 .; for STAT or"STN" for Non Stat entries)
 .S INDAT(INQ,P,T,"TOTC")=$G(INDAT(INQ,P,T,"TOTC"))+COUNT
 .;Current average number of entries  by priority-time
 .S INDAT(INQ,P,T,"AVG")=INDAT(INQ,P,T,"TOTC")\INITER
 Q
 ;
ST1(INQ,COUNT,NAME) ;Stats - Queue Totals
 ;INPUT
 ;  INQ
 ;  COUNT
 ;  NAME
 ;OUTPUT
 ;  INDAT array with total stats
 ;
 ;Negative numbers not allowed
 S:+$G(COUNT)<0 COUNT=0
 ;Current count
 S INDAT(INQ,"COUNT")=COUNT
 ;Queue name
 S:$L($G(NAME)) INDAT(INQ,"NAME")=NAME
 ;Minimum
 S:INDAT(INQ,"MIN")="" INDAT(INQ,"MIN")=COUNT
 S:COUNT<INDAT(INQ,"MIN") INDAT(INQ,"MIN")=COUNT
 ;Maximum
 S:INDAT(INQ,"MAX")="" INDAT(INQ,"MAX")=COUNT
 S:COUNT>INDAT(INQ,"MAX") INDAT(INQ,"MAX")=COUNT
 ;Total entries found in all scans
 S INDAT(INQ,"TOTC")=INDAT(INQ,"TOTC")+COUNT
 ;Current average number of entries of all scans
 S INDAT(INQ,"AVG")=INDAT(INQ,"TOTC")\INITER
 ;
 ;PROVIDE Support for data array to be used in graphing
 Q
 ;
QUIT() ;Determine if program should quit
 ;INPUT:
 ;  INEXIT - quit flag
 ;OUTPUT:
 ;  INEXIT - quit flag
 ;  function -  1 - time to exit ; 0 - continue
 ;
 ;Quit If:
 ;report time calculation takes too long
 I 'INPAR("RUNTOEND"),$$TDIF^INHUTS(INPAR("REPSTART"))>INPAR("MAXREPTIME") S INEXIT=1 Q INEXIT
 ;queue time calculation takes too long
 I 'INPAR("RUNTOEND"),$$TDIF^INHUTS(INPAR("QSTART"))>INPAR("MAXQTIME") S INEXIT=1 Q INEXIT
 ;user presses <any key>
 I 'INTASKED S INEXIT=$$QUIT^INHUTS
 Q INEXIT
 ;
EXIT ;Primary exit point
 ;Close device
 D ^%ZISC
 Q
