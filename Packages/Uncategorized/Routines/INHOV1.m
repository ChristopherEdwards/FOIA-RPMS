INHOV1 ;JMB; 24 Aug 95 14:23; Verify Background Processes
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 Q
EN ;Called from INHOP
 ;New Statements
 N DB,BPC,DC,INDEST,DTOUT,GL,S,TAB,X
 N INDAT,INEXIT,IN0,INH,INI,INL,INRUN,INITER,INK,INQ,INWARN,INSIG,INT
 ;
 ;Initialize report variables
 S INITER=0,INEXIT=0,INPAR("START")=$H
 ;Initialize TABs 
 S TAB(1)=5,TAB(2)=37,TAB(3)=49,TAB(4)=58,TAB(5)=66,TAB(6)=74
 ;Load array (INDEST) of queues to check
 D DES0^INHUTS1
 ;Report start time
 S INDAT("ST")=$$CDATASC^UTDT(INPAR("START"),1,1)
 ;
ENRPT ;Repeat entry point
 ;
 ;Init scan variables
 S INITER=INITER+1,INPAR("QSTART")=$H
 ;Initialize flags
 S INWARN=0,INSIG=0
 ;
 ;Set warning flag INWARN to 1 if another user is running this report.
 L +^INTHPC("AVERIFY"):1 E  S INWARN=1
 S BPC=0
 F  S BPC=$O(INDEST(BPC)) Q:'BPC  D VERIFY(BPC)
 L:'INWARN -^INTHPC("AVERIFY")
 ;
 ;Repeat display for terminals, one time for printers
 I 'INTASKED D DIS^INHOV2 S INEXIT=$$QUIT^INHUTS G:INEXIT EXIT
 ;Check for end of tasked report
 I INTASKED,INITER'<INPAR("ITER") D DIS^INHOV2 G EXIT
 ;
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
VERIFY(INI) ;Verify if all active processes are running
 ;This is the program main loop.  It loops through all active
 ; background processes.
 ;Where:
 ; INI -  Process Id
 ;
 N IN0
 S IN0=$G(^INRHB("RUN",INI))
 D STAT(INI,0,IN0)
 D:INPAR("DETAIL") VFY2(INI)
 D IN2^INHOV2(INI)
 Q
 ;
STAT(INQ,INK,IN0) ;Build Statistics
 ; INQ - Background process Id
 ; INK - Server Id (INK=0 if process is not a server)
 ; IN0 - Data string from ^INRHB
 ;OUTPUT:
 ;  Updated INDAT(sub1,sub2,sub3,sub4) array with latest information:
 ;  Where:
 ;  sub1 - Process Id number (ex. 1 for the Output Controller)
 ;       - "CT": Current Time formatted      (no sub2,sub3,sub4)
 ;       - "RT": Run Time                    (no sub2,sub3,sub4)
 ;       - "AR": Avg Run Time per Iteration  (no sub2,sub3,sub4)
 ;  sub2 - 0: Not a server; >0: Server Id number
 ;  sub3 - 0: Last Run Time Stats       (there is sub4)
 ;       - 1: Last Event Time Stats     (there is sub4)
 ;       - "RUN","ITR","MES"            (no sub4)
 ;  sub4 - "ETS","ETF","LRU","MIN","MAX" or "AET"  (i.e. Stats)
 ;
 ;  MIN - Minimum elapsed time in sec
 ;  MAX - Maximum elapsed time in sec
 ;  AET - Average elapsed time in sec
 ;  LRU - Last Run Time/Last Event Time in sec
 ;  ITR - Current Background Process iteration
 ;  RUN - Running status
 ;  MES - Message
 ;  ETS - Elapsed time in sec
 ;
 N S,INH,INL,INRUN
 ;
 ;Current time formatted
 S INDAT("CT")=$$CDATASC^UTDT($$NOW^UTDT,1,1)
 ;Calculate run time = now-start
 S INRUN=$$TDIF^INHUTS(INPAR("START"),$H)
 S INDAT("RT")=$$FORMAT^INHUTS(INRUN)
 ;Calculate average run time per iteration
 S INDAT("AR")=$$FORMAT^INHUTS(INRUN\INITER,2)
 ;
 ;Is background process running?
 S:'INK S=$$VER("^INRHB(""RUN"")",INQ)
 S:INK S=$$VER("^INRHB(""RUN"",""SRVR"",INQ)",INK)
 S INDAT(INQ,INK,"RUN")=$S(S=1:"",'S:"N",S=2:"N",S=3:"Q")
 ;Set flag to display message to user on the meaning of "Q"
 S:INDAT(INQ,INK,"RUN")="Q" INSIG=1
 ;
 ;Message
 S:INPAR("DETAIL") INDAT(INQ,INK,"MES")=$P(IN0,U,2)
 ;
 ;Number of iterations for each process:
 ;If the process is deactivated while running this report the count
 ;will not increase. The count will resume if the process is reactivated.
 S:INDAT(INQ,INK,"RUN")="" INDAT(INQ,INK,"ITR")=$G(INDAT(INQ,INK,"ITR"))+1
 ;
 S INH=$H
 ;Last Run Stats
 S INL=$P(IN0,U) D:INL STA1(0,INH,INL)
 ;Last Event Stats
 S INL=$P(IN0,U,3) D:INL&INPAR("DETAIL") STA1(1,INH,INL)
 Q
 ;
STA1(DA,DB,DC) ;Caculates Stats
 ;INPUT:
 ;   DA - 0 : Last Run Update Stats
 ;        1 : Last Event Stats
 ;   DB - Current Time in $H format
 ;   DC - Last Update in $H format
 ;OUTPUT:
 ;   Updated INDAT array
 ;
 ;Elapsed Time
 S INDAT(INQ,INK,DA,"ELS")=$$TDIF^INHUTS(DC,DB) ;in sec
 ;
 ;Total Elapsed 
 S:INDAT(INQ,INK,"RUN")="" INDAT(INQ,INK,DA,"ELT")=$G(INDAT(INQ,INK,DA,"ELT"))+INDAT(INQ,INK,DA,"ELS")
 ;
 ;Last Run Update/Last Message
 S INDAT(INQ,INK,DA,"LRU")=DC
 ;
 ;Do not compute Stats if process is not running
 I INDAT(INQ,INK,"RUN")'="" Q
 ;
 ;Average Elapsed Time:
 S INDAT(INQ,INK,DA,"AET")=INDAT(INQ,INK,DA,"ELT")/INDAT(INQ,INK,"ITR")
 ;
 ;Minimum Elapsed Time
 S:INDAT(INQ,INK,DA,"ELS")<$G(INDAT(INQ,INK,DA,"MIN"))!($G(INDAT(INQ,INK,DA,"MIN"))="") INDAT(INQ,INK,DA,"MIN")=INDAT(INQ,INK,DA,"ELS")
 ;
 ;Maximum Elapsed Time
 S:INDAT(INQ,INK,DA,"ELS")>$G(INDAT(INQ,INK,DA,"MAX"))!($G(INDAT(INQ,INK,DA,"MAX"))="") INDAT(INQ,INK,DA,"MAX")=INDAT(INQ,INK,DA,"ELS")
 Q
 ;
VER(GL,DA) ;Verify if Background Process (or Server) DA is running
 ;Possible Outputs:
 ;   Acquired Lock   D/T Present  Value return  Meaning
 ;        Y              Y               2      Not running
 ;        Y              N               0      Not running
 ;        N              Y               1      Running
 ;        N              N               3      Signaled to quit
 L +@GL@(DA):0 I  L -@GL@(DA) Q:$D(@GL@(DA)) 2 Q 0
 Q:'$D(@GL@(DA)) 3
 Q 1
 ;
VFY2(INI)       ;Verify running servers for Background Process INI
 ;Called from tag VERIFY, which contains the main loop.
 ; INI - Background process Id
 ;OUTPUT:
 ; INDAT - Array with server information
 ;
 N INK
 ;Initialize servers of process INI
 D IN1^INHOV2(INI)
 S INK="" F  S INK=$O(^INRHB("RUN","SRVR",INI,INK)) Q:'INK  D
 .S IN0=$G(^INRHB("RUN","SRVR",INI,INK))
 .D STAT(INI,INK,IN0)
 Q
