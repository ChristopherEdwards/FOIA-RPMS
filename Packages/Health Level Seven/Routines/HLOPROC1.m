HLOPROC1 ;ALB/CJM- Process Manager - 10/4/94 1pm
 ;;1.6;HEALTH LEVEL SEVEN;**126**;Oct 13, 1995
 ;
 ;
GETWORK(PROCESS) ;
 ;finds a process that needs to be started
 ;
 N NAME,IEN,GOTWORK
 ;this is how  HL7 can be stopped via Taskman
 I $$S^%ZTLOAD D STOPHL7 Q 0
 S GOTWORK=0
 S IEN=+$G(PROCESS("IEN"))
 F  S IEN=$O(^HLD(779.3,"C",1,IEN)) Q:IEN=$G(PROCESS("IEN"))  I IEN D  Q:GOTWORK
 .N PROC,COUNT,QUEUED,RUNNING
 .Q:'$$GETPROC(IEN,.PROC)
 .Q:PROC("VMS SERVICE")
 .Q:PROC("NAME")="PROCESS MANAGER"
 .S PROCESS("COUNT")=1
 .S QUEUED=+$G(^HLC("HL7 PROCESS COUNTS","QUEUED",PROC("NAME")))
 .S:QUEUED<0 QUEUED=0
 .S RUNNING=+$G(^HLC("HL7 PROCESS COUNTS","RUNNING",PROC("NAME")))
 .S:RUNNING<0 RUNNING=0
 .S COUNT=QUEUED+RUNNING
 .I COUNT<PROC("MINIMUM") S GOTWORK=1,PROCESS("IEN")=IEN,PROCESS("NAME")=PROC("NAME"),PROCESS("COUNT")=(PROC("MINIMUM")-COUNT) Q
 .I COUNT<PROC("MAXIMUM"),$$FMDIFF^XLFDT($$NOW^XLFDT,PROC("LAST DT/TM"),2)>PROC("WAIT SECONDS"),'QUEUED S GOTWORK=1,PROCESS("IEN")=IEN,PROCESS("NAME")=PROC("NAME"),PROCESS("COUNT")=1 Q
 I 'GOTWORK K PROCESS
 Q GOTWORK
 ;
DOWORK(PROCESS) ;
 ;starts a process
 ;
 ;don't start a new task if stopped
 Q:$$CHKSTOP^HLOPROC
 ;
 N ZTRTN,ZTDESC,ZTSAVE,ZTIO,ZTSK,I,ZTDTH
 S:'$G(PROCESS("COUNT")) PROCESS("COUNT")=1
 F I=1:1:PROCESS("COUNT") D
 .S ZTRTN="PROCESS^HLOPROC"
 .S ZTDESC="HL7 - "_PROCESS("NAME")
 .S ZTIO=""
 .S ZTSAVE("PROCNAME")=PROCESS("NAME")
 .S ZTDTH=$H
 .D ^%ZTLOAD
 .I $D(ZTSK) D
 ..;lock before changing counts
 ..L +HL7("COUNTING PROCESSES"):20
 ..I $$INC^HLOSITE($NA(^HLC("HL7 PROCESS COUNTS","QUEUED",PROCESS("NAME"))))
 ..S $P(^HLD(779.3,PROCESS("IEN"),0),"^",6)=$$NOW^XLFDT,^HLTMP("HL7 QUEUED PROCESSES",ZTSK)=$H_"^"_PROCESS("NAME")
 ..L -HL7("COUNTING PROCESSES")
 Q
 ;
GETPROC(IEN,PROCESS) ;
 ;given the ien of the HL7 Process Registry entry, returns the entry as a subscripted array in .PROCESS
 ;
 ;Output: Function returns 0 on failure, 1 on success
 ;
 N NODE
 S NODE=$G(^HLD(779.3,IEN,0))
 Q:NODE="" 0
 S PROCESS("NAME")=$P(NODE,"^")
 S PROCESS("IEN")=IEN
 S PROCESS("MINIMUM")=+$P(NODE,"^",3)
 S PROCESS("MAXIMUM")=+$P(NODE,"^",4)
 S PROCESS("WAIT SECONDS")=+($P(NODE,"^",5))*60
 I 'PROCESS("WAIT SECONDS") S PROCESS("WAIT SECONDS")=1000
 S PROCESS("LAST DT/TM")=$P(NODE,"^",6)
 S PROCESS("VMS SERVICE")=$P(NODE,"^",15)
 Q 1
 ;
STOPHL7 ;shut down HLO HL7
 N ZTSK,DOLLARJ
 ;let other processes know that starting/stopping is underway
 S $P(^HLD(779.1,1,0),"^",9)=0
 S ZTSK=""
 F  S ZTSK=$O(^HLTMP("HL7 QUEUED PROCESSES",ZTSK)) Q:ZTSK=""  D DQ^%ZTLOAD
 S DOLLARJ=""
 F  S DOLLARJ=$O(^HLTMP("HL7 RUNNING PROCESSES",DOLLARJ)) Q:DOLLARJ=""  S ZTSK=$P($G(^HLTMP("HL7 RUNNING PROCESSES",DOLLARJ)),"^",2) I ZTSK]"" D PCLEAR^%ZTLOAD(ZTSK) I $$ASKSTOP^%ZTLOAD(ZTSK)
 D CHKQUED
 Q
 ;
STARTHL7 ;start HL7 system, but first do some cleanup
 ;
 D RECOUNT()
 ;
 ;set the system status flag to active
 S $P(^HLD(779.1,1,0),"^",9)=1
 ;
 ;don't start a process manager if already running
 L +^HLTMP("PROCESS MANAGER"):1
 Q:'$T
 ;
 ;start the HL7 Process Manager, which will start everything else
 N PROCESS
 S PROCESS("NAME")="PROCESS MANAGER"
 S PROCESS("IEN")=$O(^HLD(779.3,"B","PROCESS MANAGER",0))
 D DOWORK(.PROCESS)
 L -^HLTMP("PROCESS MANAGER")
 Q
 ;
QUIT1(COUNT) ;just returns 1 as function value first time around,then 0, insuring that the DO WORK function is called just once
 I '$G(COUNT) S COUNT=1 Q 1
 Q 0
 ;
CHKDEAD(WORK) ;
 ;did any process terminate without erasing itself?
 ;WORK (pass by reference, not required) by the Process Manager that is not used and not required
 N DOLLARJ S DOLLARJ=""
 L +HL7("COUNTING PROCESSES"):20
 Q:'$T
 F  S DOLLARJ=$O(^HLTMP("HL7 RUNNING PROCESSES",DOLLARJ)) Q:DOLLARJ=""  I DOLLARJ'=$J L +^HLTMP("HL7 RUNNING PROCESSES",DOLLARJ):0 D:$T
 .L -^HLTMP("HL7 RUNNING PROCESSES",DOLLARJ)
 .N PROC
 .S PROC=$P($G(^HLTMP("HL7 RUNNING PROCESSES",DOLLARJ)),"^",3)
 .K ^HLTMP("HL7 RUNNING PROCESSES",DOLLARJ)
 .Q:PROC=""
 .I $$INC^HLOSITE($NA(^HLC("HL7 PROCESS COUNTS","RUNNING",PROC)),-1)<0,$$INC^HLOSITE($NA(^HLC("HL7 PROCESS COUNTS","RUNNING",PROC)),1)
 L -HL7("COUNTING PROCESSES")
 Q
CHKQUED ;did any queued task get dequeued without being erased?
 N PROC,JOB
 L +HL7("COUNTING PROCESSES"):20
 Q:'$T
 S JOB=""
 F  S JOB=$O(^HLTMP("HL7 QUEUED PROCESSES",JOB)) Q:JOB=""  I '$$QUEUED(JOB) D
 .N PROC
 .S PROC=$P($G(^HLTMP("HL7 QUEUED PROCESSES",JOB)),"^",2)
 .I PROC]"",$$INC^HLOSITE($NA(^HLC("HL7 PROCESS COUNTS","QUEUED",PROC)),-1)<0,$$INC^HLOSITE($NA(^HLC("HL7 PROCESS COUNTS","QUEUED",PROC)),1)
 .K ^HLTMP("HL7 QUEUED PROCESSES",JOB)
 L -HL7("COUNTING PROCESSES")
 Q
 ;
QUEUED(TASK) ;
 ;function returns 0 if ZTSK is not queued to run, 1 if it is
 N ZTSK
 S ZTSK=TASK
 D ISQED^%ZTLOAD
 Q:ZTSK(0) 1
 Q 0
 ;
CNTLIVE ;count the running processes
 N JOB,COUNTS,PROC
 L +HL7("COUNTING PROCESSES"):20
 Q:'$T
 S JOB=""
 F  S JOB=$O(^HLTMP("HL7 RUNNING PROCESSES",JOB)) Q:JOB=""  S PROC=$P($G(^HLTMP("HL7 RUNNING PROCESSES",JOB)),"^",3) I PROC]"" S COUNTS(PROC)=$G(COUNTS(PROC))+1
 S PROC="" F  S PROC=$O(COUNTS(PROC)) Q:PROC=""  S ^HLC("HL7 PROCESS COUNTS","RUNNING",PROC)=COUNTS(PROC)
 S PROC="" F  S PROC=$O(^HLC("HL7 PROCESS COUNTS","RUNNING",PROC)) Q:PROC=""  S ^HLC("HL7 PROCESS COUNTS","RUNNING",PROC)=+$G(COUNTS(PROC))
 L -HL7("COUNTING PROCESSES")
 Q
 ;
CNTQUED ;count the queued tasks
 N JOB,COUNTS,PROC
 L +HL7("COUNTING PROCESSES"):20
 Q:'$T
 S JOB=""
 F  S JOB=$O(^HLTMP("HL7 QUEUED PROCESSES",JOB)) Q:JOB=""  S PROC=$P($G(^HLTMP("HL7 QUEUED PROCESSES",JOB)),"^",2) I PROC]"" S COUNTS(PROC)=$G(COUNTS(PROC))+1
 S PROC="" F  S PROC=$O(COUNTS(PROC)) Q:PROC=""  S ^HLC("HL7 PROCESS COUNTS","QUEUED",PROC)=COUNTS(PROC)
 S PROC="" F  S PROC=$O(^HLC("HL7 PROCESS COUNTS","QUEUED",PROC)) Q:PROC=""  S ^HLC("HL7 PROCESS COUNTS","QUEUED",PROC)=+$G(COUNTS(PROC))
 L -HL7("COUNTING PROCESSES")
 Q
 ;
RECOUNT(RECOUNT) ;check that the processes that are supposed to be running actually are, same for the queued processes
 ;Input:
 ;  RECOUNT (pass by reference, optional) not used, but passed in by the process manager
 ;
 ;
 ;check for processes that are supposed to be running or queued but aren't
 D CHKDEAD(),CHKQUED
 ;
 ;recount the processes
 D CNTLIVE,CNTQUED
 Q
