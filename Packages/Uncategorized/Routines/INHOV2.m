INHOV2 ;JMB; 6 Jul 99 15:28;Verify Background Processes
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 Q
 ;
IN1(INI) ;Initialize Servers for process INI
 ;OUTPUT
 ;  Initialized INDAT array
 ;
 N INK
 S INK=0 F  S INK=$O(INDAT(INI,INK)) Q:'INK  D
 . S INDAT(INI,INK,"RUN")="N"
 Q
 ;
IN2(INI) ;Handle tasked/non-tasked stats
 ;OUTPUT
 ;  updated INDAT array for process INI
 ;
 N INK,INT
 Q:INTASKED
 S INK="" F  S INK=$O(INDAT(INI,INK)) Q:'$L(INK)  D
 .;main process - show process name and run status even if not running.
 .I INK=0 S INT=INDAT(INI,INK,"RUN") I INT="N" K INDAT(INI,INK) S INDAT(INI,INK,"RUN")="N"
 .;servers (INK>0), do not display them if not running.
 .E  K:INDAT(INI,INK,"RUN")="N" INDAT(INI,INK)
 Q
 ;
DIS ;Display Report
 D HD
 ;Display data
 S INQ="" F  S INQ=$O(INDAT(INQ)) Q:'INQ  D OV(INQ,0) S INK="" F  S INK=$O(INDAT(INQ,INK)) Q:'$L(INK)  D
 .W !,?1,INDAT(INQ,INK,"RUN")
 .W:'INK ?TAB(1),$E(INDEST(INQ),1,30)
 .W:INK>0 ?TAB(1)+2,"SERVER",INK
 .;Display Last Run Update Stats
 .D DIS1(0)
 .W:$L($G(INDAT(INQ,INK,"MES"))) !,?TAB(1)+2,$E(INDAT(INQ,INK,"MES"),1,30)
 .;Display Last Event Stats
 .D DIS1(1)
 .D:$L($O(INDAT(INQ,INK))) OV(INQ,1)
 D FTR
 Q
 ;
DIS1(DA) ;Display Stats
 ;INPUT:  DA = 0  - Last Run Update Stats
 ;             1  - Last Event Stats
 ;
 I DA=1,'$L($G(INDAT(INQ,INK,1,"ELS"))) Q
 I DA=1,'$L($G(INDAT(INQ,INK,"MES"))) W !
 W ?TAB(2),$J($$FT0^INHUTS($G(INDAT(INQ,INK,DA,"LRU"))),10)
 W ?TAB(3),$J($$FT1^INHUTS($G(INDAT(INQ,INK,DA,"ELS")),1),7)
 W ?TAB(4),$J($$FT1^INHUTS($G(INDAT(INQ,INK,DA,"MIN")),2),6)
 W ?TAB(5),$J($$FT1^INHUTS($G(INDAT(INQ,INK,DA,"MAX")),2),6)
 W ?TAB(6),$J($$FT1^INHUTS($G(INDAT(INQ,INK,DA,"AET")),2),6)
 Q
 ;
OV(INQ,IN1) ;Handle overflow
 ;INPUT
 ;  INQ - Process Id
 ;  IN1 - 1 Repeat process name
 ;      - 0 Do not repeat process name
 Q:$Y<(IOSL-4)
 W !!,"More..." F X=1:1:INPAR("REPAINT") Q:INTASKED  R *%:1 Q:$T
 D HD
 ;Repeat process name
 W:IN1 !,INDEST(INQ)," Cont."
 Q
 ;
HD ;Display header
 ;Clear screen
 N SEL
 W @IOF
 W "Verify Background Process",?55,INDAT("CT")
 D HD1
 W !,?5,"Start Time: ",INDAT("ST")
 W ?40,"  Number of Iterations: ",INITER
 W !,?5,"  Run Time: ",INDAT("RT"),?40,"Avg Time per Iteration: ",INDAT("AR")
 W !!
 S SEL=$S(INPAR("DETAIL"):"DET",1:"BRF") D @SEL
 W !,"---"
 W ?TAB(1),"------------------------------",?TAB(2),"----------"
 W ?TAB(3),"-------"
 F X=TAB(4),TAB(5),TAB(6) W ?X,"------"
 Q
DET ;Detail Report Header
 W "Run",?TAB(1),"Background Process/",?TAB(2),"Last Run/"
 W ?TAB(3)+6,"(defaults in seconds)"
 W !,?TAB(1)+2,"Message",?TAB(2)," Last Msg",?TAB(3),"Elapsed"
 W ?TAB(4),"  Min",?TAB(5),"  Max",?TAB(6),"  Avg"
 Q
BRF ;Brief Report Header
 W ?TAB(3)+6,"(defaults in seconds)",!
 W "Run",?TAB(1),"Background Process",?TAB(2),"Last Run"
 W ?TAB(3),"Elapsed"
 W ?TAB(4),"  Min",?TAB(5),"  Max",?TAB(6),"  Avg"
 Q
 ;
FTR ;Display footer
 ;
 ;Diplay legend if at least one process has RUN status equal to "Q".
 W:INSIG !!,"NOTE: RUN=Q Stands for ""Background Process Signaled to Quit"""
 Q:INTASKED
 W !!,"Press any key to exit: "
 Q
HD1 ;Display warning message
 Q:'INWARN
 W !,"WARNING: Report being run elsewhere. Results may not be accurate."
 Q
