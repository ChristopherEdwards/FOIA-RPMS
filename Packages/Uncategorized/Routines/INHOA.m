INHOA ;JMB; 15 Sep 95 08:27; Background Process Monitor
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 Q
EN ;Called from INHOP
 ;NEW statements
 N BP0,BPC,INDAT,INQUEUE,INTOTAL,INDV,INDQ,X,OC
 N DA,INDEST,DTOUT,GL,H,M,S,TAB,CUR
 N INEXIT,IN0,INH,INI,INL,INRUN,INITER,INK,INQ,INWARN,INSIG,INT
 N INRUNASC,INRUNAVG,P,SEL,T,TOP,STAT
 ;
 ;Initialize report variables
 S INITER=0,INEXIT=0,INPAR("START")=$H
 S BPC=$P(INPAR("PROCESS"),U)
 ;Initialize TABs 
 S TAB(1)=5,TAB(2)=37,TAB(3)=49,TAB(4)=58,TAB(5)=66,TAB(6)=74
 ;
 ;Queue size parameter
 S INPAR("MSGSTART")=$P(^INTHU(0),U,3),INPAR("TSKSTART")=$P(^INLHFTSK(0),U,3)
 ;Init INDAT array, save INDAT
 D INIARR(BPC),SQ
 ;
ENRPT ;Repeat entry point
 ;
 ;Init scan variables
 S INITER=INITER+1,(INPAR("QSTART"),INPAR("REPSTART"))=$H
 S (INWARN,INSIG,INTOTAL,INQUEUE)=0
 D P1(BPC) G:INEXIT EXIT ;Verify status
 D P3(BPC) G:INEXIT EXIT ;Top entries
 D P2(BPC) G:INEXIT EXIT ;Queue size
 ;
 G:$$QUIT^INHUTS EXIT ;handles INPAR("REPAINT")=0
 ;hang until next recalculation
 F X=1:1:INPAR("REPAINT") S:'INTASKED INEXIT=$$QUIT^INHUTS Q:INEXIT  H 1
 G:INEXIT EXIT
 G ENRPT
 ;
EXIT ;End of program
 ;Close device
 D ^%ZISC
 Q
 ;
P1(BPC) ;Part 1: Verify status of background process
 ;
 ;Restore INDAT stats
 D RV
 ;Set warning flag INWARN to 1 if another user is running this report.
 L +^INTHPC("AVERIFY"):1 E  S INWARN=1
 D VERIFY^INHOV1(BPC)
 L:'INWARN -^INTHPC("AVERIFY")
 ;
 Q:INEXIT
 ;Repeat display for terminals 1 time for printers
 I 'INTASKED D DISV^INHOA1
 ;Check for end of tasked report
 I INTASKED,INITER'<INPAR("ITER") D DISV^INHOA1 D SV Q
 ;
 ;Save INDAT stats
 D SV
 Q
 ;
P2(BPC) ;Part 2: Queue size sorted by priority
 ;  Notice that: INDAT(1) - Format Controller  (BPC=2)
 ;               INDAT(2) - Output Controller  (BPC=1)
 ;
 ;Restore INDAT
 D RQ
 ;init INDAT by priority for next scan
 D IND^INHOQR2
 ;Format controller, Notice that when $$QUEUE=1 => INEXIT=1
 I BPC=2 Q:'$$QUEUE^INHOQR1("^INLHFTSK(""AH"")",$P(^INTHPC(2,0),U),1)
 ;Output Controller
 I BPC=1 Q:'$$QUEUE^INHOQR1("^INLHSCH",$P(^INTHPC(1,0),U),2)
 ;Destination queue
 I ";1;2;"'[BPC Q:'$$QUEUE^INHOQR1(U_$P(INDEST(BPC),U,2),$P(INDEST(BPC),U),BPC)
 ;
 ;Provide support for message creation rates
 Q:'$$ENTRIES^INHOQR1("^INTHU","Messages created per hour",700,"MSGSTART")
 ;
 ;Provide support for transaction identification rates
 Q:'$$ENTRIES^INHOQR1("^INLHFTSK","Transactions identified per hour",750,"TSKSTART")
 ;
 ;Repeat display for terminals, one time for printers
 I 'INTASKED D DISQ^INHOA1
 ;Check for end of tasked report
 ; NOTICE: INEXIT=1 to exit (completed last part of report)
 I INTASKED,INITER'<INPAR("ITER") D DISQ^INHOA1 S INEXIT=1 Q
 ;
 ;save INDAT
 D SQ
 Q
 ;
P3(BPC) ;Part 3: Show top entries in queue
 ;
 ;Init INDAT
 K INDAT
 ;Format controller
 I BPC=2 I '$$QUEUE^INHOQT1("^INLHFTSK(""AH"")",2) S INEXIT=1 Q
 ;Output Controller
 I BPC=1 I '$$QUEUE^INHOQT1("^INLHSCH",1) S INEXIT=1 Q
 ;Destination queues
 I ";1;2;"'[BPC I '$$QUEUE^INHOQT1(U_$P(INDEST(BPC),U,2),BPC) S INEXIT=1 Q
 ;
 Q:INEXIT
 ;display report
 D:'INTASKED DIST^INHOA1
 ;Check for end of tasked report
 I INTASKED,INITER'<INPAR("ITER") D DIST^INHOA1 K INDAT Q
 ;
 ;Delete INDAT 
 K INDAT
 ;
 Q
 ;
INIARR(BP) ;Init INDAT,INDEST for Queue size report
 ;OUTPUT:
 ;  INDAT - array of data for each queue
 ;
 ;Determine destination to check
 D INITQ(BP)
 ; 
 ;Intialize data arrays
 S BP=$S(BP=1:2,BP=2:1,1:BP)
 D DATINIT(BP)
 ;
 F BP=700,750 D DATINIT(BP)
 Q
 ;
DATINIT(INQ) ;Initialize data array
 ;INPUT:
 ;  INQ - queue entry (usually ien in Back Proc Control file)
 ;OUTPUT:
 ;  INDAT - array of initialized data for a queue
 ;
 F X="COUNT","MIN","MAX","AVG","NAME","ITER","TOTC" S INDAT(INQ,X)=""
 Q
 ;
INITQ(BPC) ;Init
 N BP0,D
 S BP0=$G(^INTHPC(BPC,0))
 S D=$P(BP0,U,7) Q:'D
 ;Check if process is NOT active and no messages in queue
 Q:'$P(BP0,U,2)&'$D(^INLHDEST(D))
 S INDEST(BP)=$P(BP0,U)_U_"INLHDEST("_D_")"
 Q
 ;
RV M INDAT=INDV K INDV Q
SV M INDV=INDAT K INDAT Q
RQ M INDAT=INDQ K INDQ Q
SQ M INDQ=INDAT K INDAT Q
