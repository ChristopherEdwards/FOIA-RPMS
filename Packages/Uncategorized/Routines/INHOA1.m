INHOA1 ; JMB; 6 Jul 99 15:30; Background Process Monitor cont.
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 Q
 ;
 ;                  PART 1: VERIFY STATUS
 ;
DISV ;Display Verify Status
 N INQ,INK
 ;
 ;Display Main header, verify status header
 D HD,HDV
 ;
 S INQ="" F  S INQ=$O(INDAT(INQ)) Q:'INQ  S INK="" F  S INK=$O(INDAT(INQ,INK)) Q:'$L(INK)  D
 .D:$$OVF HDV
 .W !
 .I '$L(INDAT(INQ,INK,"RUN")) W " Y"
 .E  W ?1,INDAT(INQ,INK,"RUN")
 .W:'INK ?TAB(1),"MAIN"
 .W:INK>0 ?TAB(1),"SERVER ",INK
 .;Display Last Run Update Stats
 .D DISV1(0)
 .W:$L($G(INDAT(INQ,INK,"MES"))) !,?TAB(1)+2,$E(INDAT(INQ,INK,"MES"),1,28)
 .;Display Last Event Stats
 .D:$L($G(INDAT(INQ,INK,1,"ELS"))) DISV1(1)
 D MSG
 Q
 ;
DISV1(DA) ;Display Stats
 ;INPUT:  DA = 0  - Last Run Update Stats
 ;             1  - Last Event Stats
 ;
 I DA=1,'$L($G(INDAT(INQ,INK,"MES"))) W !
 W ?TAB(2),$J($$FT0^INHUTS($G(INDAT(INQ,INK,DA,"LRU"))),10)
 W ?TAB(3),$J($$FT1^INHUTS($G(INDAT(INQ,INK,DA,"ELS")),1),7)
 W ?TAB(4),$J($$FT1^INHUTS($G(INDAT(INQ,INK,DA,"MIN")),2),6)
 W ?TAB(5),$J($$FT1^INHUTS($G(INDAT(INQ,INK,DA,"MAX")),2),6)
 W ?TAB(6),$J($$FT1^INHUTS($G(INDAT(INQ,INK,DA,"AET")),2),6)
 Q
 ;
HDV ;Verify Status Header
 W !!,"**RUN STATUS**  $JOB: ",$P(^INTHPC(BPC,0),U,4)
 D HD1
 S SEL=$S(INPAR("DETAIL"):"DET",1:"BRF") D @SEL
 W !,"---"
 W ?TAB(1),"------------------------------",?TAB(2),"----------"
 W ?TAB(3),"-------"
 F X=TAB(4),TAB(5),TAB(6) W ?X,"------"
 Q
DET ;Verify Status, Detail Report Header
 W !,"Run",?TAB(1),"Server/",?TAB(2),"Last Run/"
 W ?TAB(3)+6,"(defaults in seconds)"
 W !,?TAB(1)+2,"Message",?TAB(2)," Last Msg",?TAB(3),"Elapsed"
 W ?TAB(4),"  Min",?TAB(5),"  Max",?TAB(6),"  Avg"
 Q
BRF ;Verify Status, Brief Report Header
 W !,?TAB(3)+6,"(defaults in seconds)",!
 W "Run",?TAB(1),"Server",?TAB(2),"Last Run"
 W ?TAB(3),"Elapsed"
 W ?TAB(4),"  Min",?TAB(5),"  Max",?TAB(6),"  Avg"
 Q
 ;
MSG ;Verify Status, special message
 ; Diplay legend if at least one process has RUN status equal to "Q".
 W:INSIG !!,"NOTE: RUN=Q Stands for ""Background Process Signaled to Quit"""
 Q
 ;
HD1 ;Verify Status, Display warning message
 Q:'INWARN
 W !,"  WARNING: Report being run elsewhere. Results may not be accurate."
 Q
 ;
 ;                  PART 2: QUEUE SIZE
 ;
DISQ ;Display Queue Size
 N INQ,IN0,P,T
 I $$OVF
 D HDQ
 ;Work through INDAT array
 ; IN0 - Flag 
 S INQ=0 F  S INQ=$O(INDAT(INQ)) Q:'INQ  S IN0=0 D
 . S P="" F  S P=$O(INDAT(INQ,P)) Q:(+P'=P)!('INPAR("DETAIL"))  S T="" F  S T=$O(INDAT(INQ,P,T)) Q:'$L(T)  D DPRI(INQ,P,T,.IN0)
 .;Display queues with 0 totals
 .;If there is only one priority level for queue INQ, do not
 .; display total by priority, since data is repeated
 .;Display overall totals
 .;Display Brief report
 .I ('INDAT(INQ,"COUNT"))&(IN0=0)!(IN0>1)!(INQ>300)!('INPAR("DETAIL")) D DTOT(INQ,IN0)
 ;
 D FTR
 Q
 ;
DPRI(INQ,P,T,IN0) ;Display queue size by priority level
 W !
 S IN0=IN0+1
 W ?TAB(2)+5,P W:T="ST" " STAT"
 W ?TAB(3)+1,$J(INDAT(INQ,P,T,"COUNT"),6)
 W ?TAB(4),$J(INDAT(INQ,P,T,"MIN"),6)
 W ?TAB(5),$J(INDAT(INQ,P,T,"MAX"),6)
 W ?TAB(6),$J(INDAT(INQ,P,T,"AVG"),6)
 D:$$OVF HDQ
 Q
 ;
DTOT(INQ,IN0) ;Display queue totals
 ;
 ; New line before displaying "Total" string, "Transactions
 ;    identified per hour"
 W:INQ'=700 !
 ; multiple priority totals
 W:IN0>1 ?TAB(2),"   Total:"
 ; One blank line before "Messages created per hour"
 W:INQ=700 !!
 ; If there is overflow display Messages created per hour and
 ;  Transactions identified per hour in the same page.
 I INQ=700,$$OVF D HDQ W !
 W:INQ>200 $J(INDAT(INQ,"NAME"),45)_":"
 W ?TAB(3)+1,$J(INDAT(INQ,"COUNT"),6),?TAB(4),$J(INDAT(INQ,"MIN"),6)
 W ?TAB(5),$J(INDAT(INQ,"MAX"),6),?TAB(6),$J(INDAT(INQ,"AVG"),6)
 Q
 ;
HDQ ;Queue Size Header
 N T
 W !!,"**QUEUE SIZE (#entries)**"
 W:INPAR("DETAIL") ?TAB(2)+2,"Priority"
 W ?TAB(3),"  Curr",?TAB(4),"  Min",?TAB(5),"  Max",?TAB(6),"  Avg"
 W !
 W:INPAR("DETAIL") ?TAB(2)+2,"--------"
 W ?TAB(3)+1,"------"
 F T=4:1:6 W ?TAB(T),"------"
 Q
 ;
 ;             PART 3:  TOP ENTRIES
 ;
DIST ;Display TOP Entries
 N INQ,IN1,P,T,TAB
 S TAB(1)=7,TAB(2)=19,TAB(3)=28,TAB(4)=40,TAB(5)=51
 I $$OVF
 ;Paint header
 D HDT(.TAB)
 ;Display data
 ;Work through INDAT array
 ; IN1 - Flag to display queue name only once
 S INQ=0 F  S INQ=$O(INDAT(INQ)) Q:'INQ  S P="" F  S P=$O(INDAT(INQ,P)) Q:+P'=P  D
 .S T="" F  S T=$O(INDAT(INQ,P,T)) Q:'$L(T)  D
 .. W !,$J(P,3),?TAB(1),$J(INDAT(INQ,P,T),10)
 .. W ?TAB(2),$J(INDAT(INQ,P,T,"DIFF"),7)
 .. W ?TAB(3),$J($E(INDAT(INQ,P,T,"MSGID"),1,10),10)
 .. W ?TAB(4),$J(INDAT(INQ,P,T,"DA"),9)
 .. W ?TAB(5),$E(INDAT(INQ,P,T,"TT"),1,29)
 I $$OVF D HDT(.TAB)
 Q
 ;
HDT(TAB) ;TOP entries header
 W !!,"**TOP ENTRIES**"
 W !,"Prio",?TAB(1),"Scheduled",?TAB(2)," Age",?TAB(3),"Message Id"
 W ?TAB(4)," Record",?TAB(5),"Transaction Type"
 W !,"-----",?TAB(1),"----------",?TAB(2),"-------",?TAB(3),"----------",?TAB(4),"---------",?TAB(5),"-----------------------------"
 Q
 ;
 ;                  COMMON SUBROUTINES:            
 ;
HD ;Display main header
 ;
 ;Calculate run time = now-start
 S INRUN=$$TDIF^INHUTS(INPAR("START"),$H),INRUNASC=$$FORMAT^INHUTS(INRUN)
 ;Calculate average run time per iteration
 S INRUNAVG=$$FORMAT^INHUTS(INRUN\INITER,2)
 W @IOF
 W $P(INPAR("PROCESS"),U,2),?55,$$CDATASC^UTDT($$NOW^UTDT,1,1)
 W !,?5,"Start Time: ",$$CDATASC^UTDT(INPAR("START"),1,1)
 W ?40,"  Number of Iterations: ",INITER
 W !,?5,"  Run Time: ",INRUNASC,?40,"Avg Time per Iteration: ",INRUNAVG
 Q
 ;
FTR ;Display footer
 I INTASKED W !!!,"End of Report." Q
 W !!,"Press any key to exit: "
 Q
 ;
OVF() ;Handle overflow
 Q:$Y<(IOSL-4) 0
 W !,"More..." F X=1:1:INPAR("REPAINT") Q:INTASKED  R *%:1 Q:$T
 D HD
 Q 1
