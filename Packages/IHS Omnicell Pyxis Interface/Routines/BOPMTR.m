BOPMTR ;IHS/ILC/ALG/CIA/PLS - ILC Job Monitor;16-Aug-2005 10:56;SM
 ;;1.0;AUTOMATED DISPENSING INTERFACE;**1**;Jul 26, 2005
 ;This routine should be started immediately when MUMPs is started
 ;Consider it to run in the Automatic partition startup at reboot.
 N V,X,Y,QFLG
 D INIT
 S BOPWHO=$$INTFACE^BOPTU(1)
 S BOPWHO=$S(BOPWHO="O":"Omnicell",1:"Pyxis")
 ;
 ;Stop the Monitor running / Schedule Monitor Task
START G ENQUE2:'$P($G(^BOP(90355,1,4)),U) D ENQUE2
 ;
CHECK ;Start a Listener/Sender pair for each Facility
 ;
 ;Make sure another monitor is not running and hold lock if not
 K BOPTOP L ^BOP(90355,"L","MONITOR"):1 E  S BOPTOP=1 Q
 ;
 S BOPI=0 F  S BOPI=$O(^BOP(90355,1,3,BOPI)) Q:BOPI<1  D
 .S BOPD0=$G(^BOP(90355,1,3,BOPI,0)) Q:'BOPD0  Q:'$P(BOPD0,U,2)
 .S (V,BOPDIV)=$P(BOPD0,U),BOPIP=$P(BOPD0,U,3)
 .S BOPOCK=$P(BOPD0,U,4),BOPLSOC=$P(BOPD0,U,5)
 .S BOPPCPU=$P(BOPD0,U,7)
 .L +^BOP(90355,"S",V):1 D QUESEND:$T L -^BOP(90355,"S",V)
 .;
 .L +^BOP(90355,"L",V):1 D QUEREC:$T L -^BOP(90355,"L",V)
 ;
 ;Check to see if HL-7 messages are being processed.
 L +^BOP(90355.1,"FILER"):1 E  G CHQ
 ;
 ;Check queue for records that require processing - Start Task?
 ;Must be a "Filable" Transaction. $P(^BOP(90355.1,X,99),U)=1
 ;Transaction ready to process. $P(^BOP(90355.1,X,99),U,2)=0
 S (QFLG,X)=0 F  S X=$O(^BOP(90355.1,"AC",0,X)) Q:'X!QFLG  D
 .S Y=$G(^BOP(90355.1,X,99))
 .I Y,$P(Y,U)=1,'$P(Y,U,2) D QUEFILE S QFLG=1
FQ ;
 L -^BOP(90355.1,"FILER")
 ;
 ;Start the BOP interface
 ;
 ;   Quit if the STOP flag is set
 G CHQ:'$P($G(^BOP(90355,1,"IP-MCK")),U,2)
 ;
 ;   Quit if not active
 G CHQ:$L($P($G(^BOP(90355,1,"IP-MCK")),U))=0
 ;
 ;   Quit if the interface is already running -- Lock lock
 L +^BOP(90355,"IP-MCK"):3 E  G CHQ
 ;
 ;   Schedule the interface
 D QUEMCK
 ;
 ;   Unlock the lock
 L -^BOP(90355,"IP-MCK")
 Q
 ;
CHQ ;Set the Monitor Stop flag and quit
 S BOPTOP=+$G(^BOP(90355,1,12))
 I '$G(ZTQUEUED) W !!,"Background Monitor Queued."
 Q
QUEFILE ;Schedule Transaction Filer
 S ZTRTN="GO^BOPRNEW1",ZTDESC=$G(BOPWHO)_" Interface Filer"
 G QUE
QUESEND ;Schedule Transmit Tasks
 I 'BOPIP!'BOPOCK!'BOPIP G ERROR
 S ZTRTN="GO^BOPT1",ZTDESC=$G(BOPWHO)_" Queue Transmitter"
 F I="BOPDIV","BOPOCK","BOPIP" S ZTSAVE(I)=""
 G QUE
QUEREC ;Schedule Standard Receiver
 I 'BOPLSOC!'BOPIP G ERROR
 S ZTRTN="GO^BOPRNEW",ZTDESC=$G(BOPWHO)_" TCP/IP HL-7 Receiver"
 S ZTSAVE("BOPDIV")="",ZTSAVE("BOPLSOC")="",ZTSAVE("BOPIP")=""
 G QUE
QUEMCK ;Schedule the Interface
 S ZTRTN="GO^BOPRMC",ZTDESC=$G(BOPWHO)_" / BOP Interface Receiver"
 G QUE
CHK(X) ;Do not schedule another task if one is already running
 N ZTSK S ZTSK=$P($G(^BOP(90355,1,4)),U,3)
 I 'ZTSK Q 0
 D STAT^%ZTLOAD I $G(ZTSK(0)),$G(ZTSK(1))=1 Q 1
 Q 0
ENQUE ;BOP Start Monitor option (BOP MONITOR)
 Q:$$CHK()  S $P(^BOP(90355,1,12),U,1)=0 D MON,QUE,DIE
 Q
DIE Q:'$G(ZTSK)  N DA,DIE,DR S DA=1,DIE=90355,DR="4.2///"_ZTSK D ^DIE
 Q
QUE S ZTDTH=$$NOW^XLFDT
QUEA S ZTIO="" D ^%ZTLOAD
 Q
TASK ;For Monitor option
 D ENQUE
 W !!,"Task #"_$S($G(ZTSK):ZTSK,1:$P($G(^BOP(90355,1,4)),U,3))
 W " has been scheduled to start the Monitor."
 Q
ENQUE2 ;Schedule task to run Monitor according to field 4.1, "Monitor
 ;Rescheduling Frequency", in file 90355, "BOP Site Parameters".
 Q:$$CHK()  S X=$P($G(^BOP(90355,1,4)),U,2) ;Reschedule frequency in seconds
 S ZTDTH=$$FMADD^XLFDT($$NOW^XLFDT(),,,,X)
 S $P(^BOP(90355,1,12),U,1)=0 D MON,QUEA,DIE
 Q
MON S ZTRTN="BOPMTR",ZTDESC="Start "_$G(BOPWHO)_" Monitor"
 Q
ERROR ;Send message on error
 S XMSUB=$G(BOPWHO)_" Site Parameters Problem",XMY(.5)=""
 I $G(DUZ) S XMY(DUZ)=""
 S XMTEXT="X(",X(1)="Review BOP Site Parameters."
 S X(2)="The socket or IP address may be missing."
 S X(3)="There may not be a Division defined."
 D ^XMD
 Q
JOBGO D INIT
 F  D CHECK H 120 Q:'$P($G(^BOP(90355,1,4)),U)!$G(BOPTOP)
 Q
 ;The following tag is to be "jobbed" out manually if
 ;a site desires to start a monitor that runs all of the time.
JOB N ZTIO,ZTDESC,ZTDTH,ZTRTN,ZTSAVE,ZTSK
 S ZTIO="",ZTDTH=$H,ZTRTN="JOBGO^BOPMTR",ZTDESC="BOP MONITOR"
 D ^%ZTLOAD
 Q
INIT ;Initialize an environment
 D GETENV^%ZOSV S DIQUIET=1 D DT^DICRW
 Q
