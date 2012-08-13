INHOQT1 ; FRW/JMB ; 01 Oct 1999 14:49 ; Show top entries in queues, cont.
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 Q
EN ;Initialize report variables
 ;New statements
 N BP,BP0,INDAT,INDEST,INQ
 N BPC,DATA,GL,H,HT,INC,INCO,INEXIT,INIEN,INITER,INQUEUE,INRUN
 N INRUNASC,INRUNAVG,INTOTAL,INSIZE
 N T,TAB,M,P,SAR,SOP,TOP
 ;
 S INEXIT=0,INPAR("START")=$H,INITER=0
 ;Initialize Tabs
 S TAB(1)=7,TAB(2)=19,TAB(3)=28,TAB(4)=40,TAB(5)=51
 ;Intialize data array
 D INIARR^INHOQT
 ;
ENRPT ;Repeat entry point
 ;
 ;
 ;Init scan variables
 S INTOTAL=0,INQUEUE=0,INITER=INITER+1 D INIT
 ;Format controller
 G:'$$QUEUE("^INLHFTSK(""AH"")",2) EXIT
 ;Output Controller
 G:'$$QUEUE("^INLHSCH",1) EXIT
 ;Destination queues
 S BPC=2
 F  S BPC=$O(INDEST(BPC)) Q:'BPC!INEXIT  Q:'$$QUEUE(U_$P(INDEST(BPC),U,2),BPC)
 G:INEXIT EXIT
 ;
 ;display report
 D DISP
 ;
 ;hang until next iteration
 G:$$QUIT EXIT
 F X=1:1:INPAR("REPAINT") Q:$$QUIT!INEXIT  H 1
 G:INEXIT EXIT
 G ENRPT
 ;
 Q
 ;
QUEUE(GL,INQ) ;Store top entry in queue
 ;INPUT:
 ;  GL - location (global) of queue
 ;         queue in format -> @GL@( priority , time to process , ien )
 ;  INQ - subscript (usually ien) of queue in INDAT array
 ;OUTPUT:
 ;  function - complete processing ( 0 - no ; 1 - yes )
 ;  updated INDAT array with top queue entry
 ;
 N P
 S P=""
 F  S P=$O(@GL@(P)) Q:+P'=P&(P'="PEND")  D Q1(GL,INQ,P) Q:'INPAR("DETAIL")
 Q 'INEXIT
 ;
Q1(GL,INQ,P) ;Determine top entry (stat and/or non-stat) for priority P 
 ;
 I $G(P)="PEND" D PENDQ1(GL,INQ) Q
 N H,HT,INC,INZE,INIEN
 S H="",INC=0
 ;If stat and non-stat are present, first pass on L1
 ; finds top stat, second pass top non-stat.
L1 S HT=H
 S H=$O(@GL@(P,H)) Q:'$L(H)  ;No non-stat entry
 S TOP=$$TOP(GL,P,H),INIEN=+TOP
 ;if we need to repeat entry, reset H to previous value
 I $$CHK(INQ,INIEN,.INC) S H=HT G L1
 I INQ'=2 S INZE=$G(^INTHU(INIEN,0)),TOP=TOP_U_$P(INZE,U,11)_U_$P(INZE,U,5)
 I INQ=2 S INZE=$G(^INLHFTSK(INIEN,0)),TOP=TOP_U_$P(INZE,U)
 D STAT(INQ,P,H,TOP)
 Q:'INPAR("DETAIL")
 I 'H S INC=0 G L1 ; H: non-stat 'H: stat
 Q  ;non stat
 ;
PENDQ1(GL,INQ) ;Get the first entry for the pending queue
 ; Note: no concept of priority in the pending queues
 ;
 N H,INC,INZE,INIEN,INBPN,INSEQ
 S INC=0,(H,INBPN,INSEQ)=""
 S INBPN=$O(@GL@("PEND",INBPN)) Q:'$L(INBPN)
 S INSEQ=$O(@GL@("PEND",INBPN,INSEQ)) Q:'$L(INSEQ)
 S TOP="",TOP=$O(@GL@("PEND",INBPN,INSEQ,TOP))
 S INIEN=+TOP,H=$G(@GL@("PEND",INBPN,INSEQ,TOP)),H=$P(H,"^")
 I INQ'=2 S INZE=$G(^INTHU(INIEN,0)),TOP=TOP_U_$P(INZE,U,11)_U_$P(INZE,U,5)
 I INQ=2 S INZE=$G(^INLHFTSK(INIEN,0)),TOP=TOP_U_$P(INZE,U)
 D STAT(INQ,P,H,TOP)
 Q
 ;
CHK(INQ,INIEN,INCO) ;Recalculate top entry
 ;INPUT
 ;  INCO - Counter, passed by reference
 ;OUTPUT: function
 ;  1 - Recalculate top entry
 ;  0 - Do not recalculate top entry
 S INCO=INCO+1
 I INQ=2,INIEN Q 0
 I INQ'=2,INIEN,$D(^INTHU(INIEN,0)) Q 0
 I INCO>INPAR("ITERT") Q 0
 Q 1
 ;
TOP(GL,P,H) ;Get top entry from queue
 N M
 S M="",M=$O(@GL@(P,H,M))
 Q M
 ;
STAT(INQ,P,H,DATA) ;Build statistics
 ;  INQ - subscript (usually ien) of queue in INDAT array
 ;  NAME  - name of queue
 ;  DATA  - queue entry data
 ;             format: DATA = record# ^ transaction type# ^ message ID
 ;OUTPUT:
 ;  updated INDAT array
 N INH,INNOW
 Q:'$L(P)!('$L(H))
 ;Schedule
 I 'H S T="ST",INDAT(INQ,P,T)="STAT",INDAT(INQ,P,T,"DIFF")=""
 E  S T="STN",INDAT(INQ,P,T)=$$FT0^INHUTS(H) D
 .;Age
 .S INH=$$CDATH2F^%ZTFDT(H),INNOW=$$NOW^%ZTFDT()
 .I INH<INNOW S INDAT(INQ,P,T,"DIFF")=$$TDIF^INHUTS(INH,INNOW,0),INDAT(INQ,P,T,"DIFF")=$$FT1^INHUTS(INDAT(INQ,P,T,"DIFF"),1)
 .I INH'<INNOW S INDAT(INQ,P,T,"DIFF")=$$TDIF^INHUTS(INNOW,INH,0),INDAT(INQ,P,T,"DIFF")="+"_$$FT1^INHUTS(INDAT(INQ,P,T,"DIFF"),1)
 ;Message ID
 S INDAT(INQ,P,T,"MSGID")=$P(DATA,U,3)
 ;Record
 S INDAT(INQ,P,T,"DA")=$P(DATA,U)
 ;Transation type
 S INDAT(INQ,P,T,"TT")=$P($G(^INRHT(+$P(DATA,U,2),0)),U)
 Q
 ;
DISP ;Display Report
 N INQ,IN1
 ;Paint header
 D HDR
 ;Display data
 ;Work through INDAT array
 ; IN1 - Flag to display queue name only once
 S INQ=0 F  S INQ=$O(INDAT(INQ)) Q:'INQ  D OV(INQ,0) W !,INDAT(INQ,"NAME") D
 .S P="" F  S P=$O(INDAT(INQ,P)) Q:+P'=P&(P'="PEND")  D
 ..S T="" F  S T=$O(INDAT(INQ,P,T)) Q:'$L(T)  D
 ... W !,$J(P,3),?TAB(1),$J(INDAT(INQ,P,T),10)
 ... W ?TAB(2),$J(INDAT(INQ,P,T,"DIFF"),7)
 ... W ?TAB(3),$J($E(INDAT(INQ,P,T,"MSGID"),1,10),10)
 ... W ?TAB(4),$J(INDAT(INQ,P,T,"DA"),9)
 ... W ?TAB(5),$E(INDAT(INQ,P,T,"TT"),1,29)
 ... D:$L($O(INDAT(INQ,P,T)))!($O(INDAT(INQ,P))) OV(INQ,1)
 ;Paint footer
 D FTR
 Q
 ;
OV(INQ,IN1) ;Handle overflow
 ;INPUT
 ; INQ - Process Id
 ; IN1 - 1  Repeat process name
 ;     - 0  Do not repeat process name
 Q:$Y<(IOSL-4)
 W !!,"More..." F X=1:1:INPAR("REPAINT")  R *%:1 Q:$T
 D HDR
 ;Repeat process name
 W:IN1 !,INDAT(INQ,"NAME")," Cont."
 Q
 ;
INIT ;Initialize INDAT array for next scan
 ; Kill data, leave queue name intact (INDAT(INQ,"NAME")=Queue Name)
 N INQ,P
 S INQ=0 F  S INQ=$O(INDAT(INQ)) Q:'INQ  D
 . S P="" F  S P=$O(INDAT(INQ,P)) Q:+P'=P&(P'="PEND")  K INDAT(INQ,P)
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
 ;user presses <any key>
 S INEXIT=$$QUIT^INHUTS
 Q INEXIT
 ;
EXIT ;Primary exit point
 ;Close device
 D ^%ZISC
 Q
 ;
HDR ;Diplay header
 ;
 ;Calculate run time = now-start
 S INRUN=$$TDIF^INHUTS(INPAR("START"),$H),INRUNASC=$$FORMAT^INHUTS(INRUN)
 ;Calculate average run time per iteration
 S INRUNAVG=$$FORMAT^INHUTS(INRUN\INITER,2)
 ;Clear screen
 W @IOF
 W "Top Entries" W:INPAR("DETAIL") " by priority"
 W ?55,$$CDATASC^UTDT($$NOW^UTDT,1,1)
 W !,?5,"Start Time: ",$$CDATASC^UTDT(INPAR("START"),1,1),?40,"  Number of Iterations: ",INITER
 W !,?5,"  Run Time: ",INRUNASC,?40,"Avg Time per Iteration: ",INRUNAVG
 W !
 ;
 W !,"Background Process"
 W !," Prio",?TAB(1),"Scheduled",?TAB(2)," Age",?TAB(3),"Message Id"
 W ?TAB(4)," Record",?TAB(5),"Transaction Type"
 W !," ----",?TAB(1),"----------",?TAB(2),"-------",?TAB(3),"----------",?TAB(4),"---------",?TAB(5),"-----------------------------"
 Q
 ;
FTR ;Display footer
 ;
 W !!,"Press any key to exit: "
 Q
