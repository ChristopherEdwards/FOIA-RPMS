INHOQR2 ; FRW/JMB ; 01 Oct 1999 15:06 ; Show GIS queue status - cont.
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 Q
 ;
IND ;Initialize  INDAT array for next scan
 N INQ,P,T
 S INQ="" F  S INQ=$O(INDAT(INQ)) Q:'$L(INQ)  S INDAT(INQ,"COUNT")=0 D
 .  S P="" F  S P=$O(INDAT(INQ,P)) Q:+P'=P&(P'="PEND")  D  ;if P="COUNT",it will Q
 .. S T="" F  S T=$O(INDAT(INQ,P,T)) Q:'$L(T)  D
 ... S INDAT(INQ,P,T,"COUNT")=0
 Q
 ;
DISP ;Display Report
 ;
 N INQ,IN0,P,T
 ;Paint header
 D HDR
 ;Work through INDAT array
 ; IN0 - Flag to display queue name only once
 S INQ=0 F  S INQ=$O(INDAT(INQ)) Q:'INQ  D OV(INQ,0) S IN0=0 D
 . S P="" F  S P=$O(INDAT(INQ,P)) Q:((+P'=P)&(P'="PEND"))!('INPAR("DETAIL"))  S T="" F  S T=$O(INDAT(INQ,P,T)) Q:'$L(T)  D DPRI(INQ,P,T,.IN0)
 .;Display queues with 0 totals
 .;If there is only one priority level for queue INQ, do not
 .; display total by priority, since data is repeated
 .;Display overall totals
 .;Display Brief report
 .I ('INDAT(INQ,"COUNT"))&(IN0=0)!(IN0>1)!(INQ>300)!('INPAR("DETAIL")) D OV(INQ,0),DTOT(INQ,IN0)
 ;Paint footer
 D FTR
 Q
 ;
DPRI(INQ,P,T,IN0) ;Display queue size by priority level
 W ! W:'IN0 INDAT(INQ,"NAME") S IN0=IN0+1
 W ?TAB(0)+2,P W:T="ST" " STAT"
 W ?TAB(1),$J(INDAT(INQ,P,T,"COUNT"),7)
 W ?TAB(2),$J(INDAT(INQ,P,T,"MIN"),7)
 W ?TAB(3),$J(INDAT(INQ,P,T,"MAX"),7)
 W ?TAB(4),$J(INDAT(INQ,P,T,"AVG"),7)
 D:$L($O(INDAT(INQ,P,T)))!(+$O(INDAT(INQ,P))) OV(INQ,1)
 Q
 ;
DTOT(INQ,IN0) ;Display queue totals
 ;
 ; New line before displaying: "Total" string, Queue name,
 ;  Messages created per hr, transactions identified per hour.
 W:INQ'=400 !
 W:IN0>1 ?TAB(0),"Total:"
 ; One blank line before "Queue Total"
 W:INQ=400 !!
 ; Display Queue Name if there are not entries in the queue
 ; Display "Queue Total", "Messages created per hour" or
 ;  "Transactions identified per hour" strings
 W:'IN0 INDAT(INQ,"NAME")
 W ?TAB(1),$J(INDAT(INQ,"COUNT"),7),?TAB(2),$J(INDAT(INQ,"MIN"),7)
 W ?TAB(3),$J(INDAT(INQ,"MAX"),7),?TAB(4),$J(INDAT(INQ,"AVG"),7)
 ; Blank line after priority totals
 ;  One blank line before Queue Total
 W:(IN0>1)&($O(INDAT(INQ))'=400) !
 Q
 ;
OV(INQ,IN1) ;Handle overflow
 ;INPUT
 ; INQ - Process Id
 ; IN1 - 1  Repeat process Id
 ;     - 0  Do not repeat process Id
 Q:$Y<(IOSL-4)
 W !!,"More..." F X=1:1:INPAR("REPAINT") Q:INTASKED  R *%:1 Q:$T
 D HDR
 W:IN1 !,INDAT(INQ,"NAME"),"  Cont."
 Q
 ;
HDR ;Diplay header
 N T
 ;Calculate run time = now-start
 S INRUN=$$TDIF^INHUTS(INPAR("START"),$H),INRUNASC=$$FORMAT^INHUTS(INRUN)
 ;Calculate average run time per iteration
 S INRUNAVG=$$FORMAT^INHUTS(INRUN\INITER,2)
 ;Clear screen
 W @IOF
 W "GIS Queue Size",?55,$$CDATASC^UTDT($$NOW^UTDT,1,1)
 W !,?5,"Start Time: ",$$CDATASC^UTDT(INPAR("START"),1,1),?40,"  Number of Iterations: ",INITER
 W !,?5,"  Run Time: ",INRUNASC,?40,"Avg Time per Iteration: ",INRUNAVG
 W !
 ;
 W !,"Background Process"
 W:INPAR("DETAIL") ?TAB(0),"Prio"
 W ?TAB(1),"   Curr",?TAB(2),"   Min",?TAB(3),"   Max",?TAB(4),"   Avg"
 W !,"---------------------"
 W:INPAR("DETAIL") ?TAB(0),"-----"
 F T=1:1:4 W ?TAB(T),"  ------"
 Q
 ;
FTR ;Display footer
 ;
 I 'INTASKED W !!,"Press any key to exit: "
 Q
