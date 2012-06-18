AZZMJOB ; MURDERJOB; Kills jobs in mumps and unix ;[ 09/20/89  3:12 PM ]
 ; UPDATES ^XUTL AND ^XMB(3.7) GLOBALS, THEN GIVES OPPORTUNITY
 ; TO KILL JOBS.  RECOMMEND PLACING UNDER THE "KJOB" OPTION.
 ; THIS HELPS TO CLEAR UP PROBLEM OF PEOPLE BEING UNABLE TO LOG IN
 ; WHEN THE SYSTEM THINKS THEY'RE ALREADY LOGGED IN.  ALSO, KILLS
 ; JOB AT THE UNIX LEVEL IF JOB WILL NOT TERMINATE IN MUMPS.
 ; NOTE: THE USER RUNNING THIS ROUTINE MUST HAVE UNIX ROOT PRIVILEGES,
 ; OTHERWISER FUSER WILL MERELY LIST THE PIDS RATHER THAN KILLING THEM.
 ; Mike Remillard, DDS, ISC/BAO
START ;
 K AZZMJ
 D ^AUKVAR
 ;-----> CLEAN UP ^XUTL GLOBAL (REMOVE NODES OF NONEXISTENT JOBS).
 S N=0 F  S N=$O(^XUTL("XQ",N)) Q:'N  S X=N X ^%ZOSF("JOBPARAM") S AZZMJ("HOLD")=$P(Y,U,1) X ^%ZOSF("UCI") K:(Y'=AZZMJ("HOLD"))&(AZZMJ("HOLD")'="UNKNOWN") ^XUTL("XQ",N)
 ;
SET ;-----> SET UP AZZMJ("XUTL") ARRAY EQUALS: DUZ;IO#^JOB#
 S N=0 F I=1:1 S N=$O(^XUTL("XQ",N)) Q:'N  S AZZMJ("XUTL",I)=^XUTL("XQ",N,"DUZ")_";"_^("IO")_U_N
 ;
 ;-----> SET UP AZZMJ("XMB") ARRAY EQUALS: DUZ;IO#^NAME
 S AZZMJ("NODE")=0,AZZMJ("PREV")="",X=""
 S N=0 F  S N=$O(^XMB(3.7,N)) Q:'N  D:$D(^XMB(3.7,N,100))
 .S AZZMJ("DUZ")=N,X=$P(^DIC(3,AZZMJ("DUZ"),0),U)
 .S AZZMJ("NAME")=$P(X,",",2)_" "_$P(X,",")
 .S M=0 F  S M=$O(^XMB(3.7,N,100,M)) Q:'M  D
 ..S AZZMJ("NODE")=AZZMJ("NODE")+1
 ..S AZZMJ("XMB",AZZMJ("NODE"))=AZZMJ("DUZ")_";"_M_U_AZZMJ("NAME")
 ;
COMPARE ;
 ;-----> COMPARE AZZMJ("XMB") ARRAY TO AZZMJ("XUTL") ARRAY,
 ;-----> SCANNING FOR NODES WITH NO ACTIVE JOBS.
 S N=0 F  S N=$O(AZZMJ("XMB",N)) Q:'N  D
 .S M=0,$P(AZZMJ("XMB",N),U,3)="NO ACTIVE JOB"
 .F  S M=$O(AZZMJ("XUTL",M)) Q:'M  I $P(AZZMJ("XMB",N),U)=$P(AZZMJ("XUTL",M),U) S $P(AZZMJ("XMB",N),U,3)=$P(AZZMJ("XUTL",M),U,2) 
 ;-----> NOW THE AZZMJ("XMB") ARRAY EQUALS: DUZ;IO#^NAME^JOB#
 ;
DISPLAY ;
 D HEADER
 S N=0 K NN
 F  S N=$O(AZZMJ("XMB",N)) Q:'N  D:$Y>17 PROMPT Q:X="^"  D:$Y>17 HEADER D
 .S NN=N,AZZMJ("NAME")=$P(AZZMJ("XMB",N),U,2)
 .W:AZZMJ("NAME")'=AZZMJ("PREV") !
 .S AZZMJ("PREV")=AZZMJ("NAME")
 .W !?4,AZZMJ("NAME"),?27,"DEVICE ",$P($P(AZZMJ("XMB",N),U),";",2)
 .W ?42,$J($P(AZZMJ("XMB",N),U,3),7)
 .I '+$P(AZZMJ("XMB",N),U,3) D REMOVE W ?62,"REMOVED"
 I '$D(NN) G NONE
 D:X'=U&('$D(AZZMJ("KILL"))) PROMPT
 I $D(AZZMJ("KILL")) G START
 W !!!?5,"Type ""D"" to Display this table again, or press <return> to quit. " R X:DTIME
 I X?1"D".E!(X?1"d".E) G START
EXIT ;
 D ^AUCLS
 K AZZMJ,I,M,N,NN,X
 Q
PROMPT ;
 F  W ! Q:$Y>19
 R !!?10,"Type ""K"" to kill a job, or press <return> to continue. ",X:DTIME
 I X=""!(X="^") Q
 I "Kk"[X W !! D KILLJOB,^%AUCLS,^%SS R !!!?23,"Press <return> to continue. ",X:DTIME Q
 W !!?5,"Typing ""K"" will give you an opportunity to kill a particular job."
 W !?5,"You will be given an option to view the System Status first."
 G PROMPT
 ;
REMOVE ;
 K ^XMB(3.7,$P(AZZMJ("XMB",N),";"),100,$P($P(AZZMJ("XMB",N),U),";",2))
 Q
HEADER ;
 D ^AUCLS
 W ?9,"* * *  CLEAR SIGN-ON ERRORS / KILL JOBS FOR "_$ZU(0)_"  * * *"
 W !!!?10,"User",?28,"Device",?46,"Job#",?62,"Action"
 W !?3,"------------------",?25,"------------",?41,"---------------"
 W ?60,"----------"
 Q
KILLJOB ;
 R !?10,"Do you wish to see the System Status first? N// ",X:DTIME
 I X?1"Y".E!(X?1"y".E)!(X?1"?".E) D ^AUCLS,^%SS
 I X="^" Q
 D ^AZZMJOB1 S X="^",AZZMJ("KILL")=""
 Q
NONE ;
 W !!!!?32,"*   *   *"
 W !!!?5,"The IHS Kernel is not aware of any user on the system at this time."
 W !!?19,"(There may be users in programmer mode.)",!!!?32,"*   *   *"
 D PROMPT
 ;R !!!!?23,"Press <return> to continue. ",X:DTIME
 G EXIT
