BOPRNEW1 ;IHS/ILC/ALG/CIA/PLS - ILC Queue Processor;06-Feb-2006 22:12;SM
 ;;1.0;AUTOMATED DISPENSING INTERFACE;**1**;Jul 26, 2005
 Q
 ;This routine should be queued to run or set up as in the automatic
 ;partition startup process.  It should always be running.
 ;
 ;Get Lock / Only one process should be running at a time
GO ;TaskMan Entry
 L +^BOP(90355.1,"FILER"):1 E  Q
 ;
 S X="ERR^BOPRNEW",@^%ZOSF("TRAP")
 ;Just in case it is started without TaskMan, initialize an environment
 S DIQUIET=1 D DT^DICRW
 ;
 ;Loop on Queue, looking for transactions that have been received
 ;
 N BOPC,BOPX,BOPXX,BOPDA,BOPSTOP,BOPNONU
 S (BOPXX,BOPC)=0
LOOP S BOPXX=$O(^BOP(90355.1,"AC",0,BOPXX))
 I +$G(^BOP(90355,1,12))=1 Q  ; all interfaces stopped
 Q:'$P($G(^BOP(90355,1,"SITE")),U,8)  ; Default Clerk must be defined
 I 'BOPXX S BOPC=BOPC+1 G HANG
 ;
 ;Only process "Ready" & "Fillable" Transactions
 S I=$G(^BOP(90355.1,BOPXX,99))
 G LOOP:$P(I,U)'=1,LOOP:$P(I,U,2)
 ;
 ;Put data into local array
 K BOPIN S J=0,I=0
 F  S I=$O(^BOP(90355.1,BOPXX,"DATA",I)) Q:'I  S J=J+1,BOPIN(J)=^(I,0)
 ;
 S BOPDA=BOPXX,BOPSTOP=0,BOPNONU=1
 D ACTION
 ;
 ;Mark the Transaction processed
 S DIE=90355.1,DA=BOPDA,DR="99.1///9" D ^DIE
 K ^BOP(90355.1,"AC",0,BOPDA)
 ;
 ;Continue to run if Run flag is set.
LOOPQ I +$G(^BOP(90355,1,4)) S BOPC=0 G LOOP
 Q
 ;
HANG ;Loop control if nothing to process
 ;If nothing ready to work on wait a bit, then try again.
 ;This process will quit if no transactions are received for an hour.
 ;If it quits, it will be restarted automatically by the Monitor.
 ;
 H 36 G LOOPQ:BOPC<99
 Q
 ;
ACTION ;Entry from BOPOR to send Acknowledgement
 ;Initialize
 N BOPX
 S BOPN="",I=0
 F  S I=$O(BOPIN(I)) Q:'I  D
 .S X=$P(BOPIN(I),"|") I X'="" S BOPX(X)=BOPIN(I)
 ;
 ;BOPN=MSH Segment
 ;
 F  S BOPN=$O(BOPIN(BOPN)) Q:BOPN<1  I $P(BOPIN(BOPN),"|")="MSH" D
 .S BOPII=$O(BOPIN(BOPN)) Q:'BOPII
 .S BOPQRD=BOPIN(BOPII),ACTION=$P($P(BOPIN(BOPN),"|",9),U)
 .I ACTION'["DFT" Q:BOPQRD'["QRD|"
 .S X=BOPIN(BOPN),RECAPP=$P(X,"|",3),SNDAPP=$P(X,"|",5)
 .S FLD="|",HLFS="|",ENCD="^~\&",HLECH="^~\&",SITE=""
 .S COM=$E(ENCD,1),REP=$E(ENCD,2),ESC=$E(ENCD,3),SCOM=$E(ENCD,4)
 .S X=^BOP(90355,1,0),PROCID=$P(X,U,12),VERID=$P(X,U,13)
 .S MCID=$$NOW^XLFDT(),TIME=$$HLDATE^HLFNC(MCID),TIME=$P(TIME,"-",1)
 .;If processing from TCP/IP Listener transmit ACK and Quit
 .I ACTION="DFT" D  Q
 ..D DFT^BOPROC(BOPDA)
 .I ACTION="ETO" D  Q
 ..D INIT^BOPCAP Q:$D(BOPQ)
 ..S BOP(.02)="Q03",BOP(.04)="QRY",X=$P($G(BOPX("ZPM")),"|",25)
 ..S BOPYR=$E(X,1,4),BOPMD=$E(X,5,8),BOPT=$E(X,9,12)
 ..S BOP(.03)=BOPYR-1700_BOPMD_+("."_BOPT)
 ..S BOP1="",BOP10=""
 ..K BOPQ D MSH^BOPCAP Q:$G(BOPQ)  D FLAG^BOPCAP
 ..D DFT^BOPROC(BOPDA)
 .I ACTION="EPQ" D  Q
 ..S X=$P(BOPQRD,"|",9) Q:'X
 ..S X=$O(^DPT("SSN",X,0)) Q:'X
 ..S (BOPDFN,DFN)=X
 ..D INIT^BOPCAP Q:$D(BOPQ)
 ..D PID^BOPCP,PV1^BOPCP
 ..S BOP(.02)="A01",BOP(.04)="ADT"
 ..S BOP(10.2)=$G(^DPT(DFN,.1))
 ..S BOP(10.3)=$P($G(^DPT(DFN,.101)),U)
 ..S X=$P($G(^DPT(DFN,.1041)),U)
 ..S BOP(10.4)=$P($G(^VA(200,+X,0)),U)
 ..S X=$P($G(^DPT(DFN,.105)),U),BOP(10.6)=$P($G(^DGPM(+X,0)),U)
 ..S BOP(.03)=BOP(10.6)
 ..S BOP10=U_BOP(10.2)_U_BOP(10.3)_U_BOP(10.4)_U_U_BOP(10.6)
 ..K BOPQ D MSH^BOPCAP Q:$G(BOPQ)  D FLAG^BOPCAP
 .I ACTION="EOQ" D  Q
 ..S X=$P(BOPQRD,"|",9) Q:'X  S X=$O(^DPT("SSN",X,0)) Q:'X
 ..S (DFN,PSGP)=X
 ..F BOPO=0:0 S BOPO=$O(^PS(55,DFN,5,BOPO)) Q:BOPO<1  D
 ...S BOPN0=$G(^PS(55,DFN,5,BOPO,0)) Q:'BOPN0
 ...S PSGORD=BOPO ;Order Number
 ...Q:$P(BOPN0,U,9)'="A"  ;Status
 ...Q:'$P($G(^PS(55,DFN,5,BOPO,4)),U,9)  ;Verified
 ...D NEW^BOPCAP
 Q
ERR ;S ^TMP($J,"BOPO","NEW1",$S($G(ZTSK):ZTSK,1:$J))=$$EC^%ZOSV() Q
 Q
