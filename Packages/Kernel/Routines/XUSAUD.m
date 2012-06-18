XUSAUD ;DGH; 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;CHCS TLS_4603; GEN 1;
 ;COPYRIGHT 1992-1996 SAIC
 ;
 ;;CHCS Function audit. All tags replaced with Quits for IHS.
STRT(XFUNC) ;Start function level auditing
 Q:$S('$D(XQTIME):1,'$P($G(DUZ("AG")),"^",14):1,1:0)
 ;
STP(POP) ;Stop function level auditing
 Q:'$G(XQTIME)!'$G(XQTIM1)
 ;
TSTRT(ROU) ;TaskMan level auditing
 Q $S('($D(DUZ)#2):1,'$P($G(DUZ("AG")),"^",3):1,1:0)
 ;
TSTP ;TaskMan stop auditing, Input XQTIM2 = Start time of the audit
 Q:$S('$D(XQTIM2):1,'($D(DUZ)#2):1,'$P($G(DUZ("AG")),"^",3):1,1:0)
 ;
AUDCHK ;Check and initialize Interface Instrumentation
 Q
 ;
AUDSTP ;; clean up and stop GIS instrumentation
 Q
TTSTRT(TNAME,DNAME,PNAME,INHSRVR,EVENT) ;Start transaction type log,
 Q
 ;
TTSTP(ESTAT,TNAME) ;Stop log, interface instrumentation
 Q
 ;
ITIME(PNAME,INHSRVR,ESTAT) ;log timed interval
 Q
EXCEPT(X) ;Log exception
 Q
 ;
