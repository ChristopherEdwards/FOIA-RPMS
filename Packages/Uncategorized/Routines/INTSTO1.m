INTSTO1 ;DGH; 22 May 97 11:25;Unit test Ouput Controller, part II
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 ;  Called from INTSTO, this processes outgoing transactions,
 ;  including replicated transactions.
 ;
OUT(UIF,INEXPND,DEST) ;process outgoing message
 ;INPUT:
 ;  UIF = Entry in Universal Interface file to process
 ;  INEXPND = 1 to expand, 0 to not
 ;  DEST = Pointer to Interface Destination File
 N ROU,ACT,ER,ERR,INEDIT,REP,STAT,INENVSDB,INHERR,INTT,Z,REPDST,INPOP
 S INPOP=1
 ;;FOLLOWING COPIED FROM D ^INHOT(IEN,1,DEV)
 S ROU=$P(^INRHD(DEST,0),U,3) I ROU="" S INMSG="Destination: "_$P(^INRHD(DEST,0),U)_" is missing a routine name." D DISPLAY^INTSUT1(INMSG,0) Q
 S INMSG="Processing outgoing message to destination "_$P(^INRHD(DEST,0),U)_" with routine "_ROU D DISPLAY^INTSUT1(INMSG,0)
 I $P(^INRHD(DEST,0),U)["REPLICATOR" D
 .;Activity log multiple should have been killed. But be sure.
 .K ^INTHU(UIF,1)
 .;Replicator won't process "complete" transactions
 .S $P(^INTHU(UIF,0),U,3)=""
 .;Set debug flag, INENVSDB "on". The replicator will then store
 .;selective routing results in Activity Log Multiple.
 .;S INENVSDB=$P($G(^INRHSITE(1,0)),U,16),$P(^INRHSITE(1,0),U,16)=1
 .S INENVSDB=1
 Q:'INPOP
 S:ROU'["^" ROU="^"_ROU
 K INHERR S Z="N MODE,DEST S ER=$$"_ROU_"("_UIF_",.INHERR)" X Z
 K INTT D:ER>-1 DONE^INHOS
 ;
 ;--If destination was not the replicator, probably was a queue move.
 ;--Queue move won't create new entries in activity log multiple, but
 ;--other transceiver operations might. Display if there are any.
 I $P(^INRHD(DEST,0),U)'["REPLICATOR" D
 .D DISPLAY^INTSUT1("Output controller processing completed",0)
 .S STAT=$$CVTCODE^INHUTC3($P(^INTHU(UIF,0),U,3),4001,.03)
 .S INMSG="Status of message is: "_STAT D DISPLAY^INTSUT1(INMSG,0,UIF)
 .D ACTLOG^INTSTO(UIF)
 ;
 ;--If destination was the replicator
 I $P(^INRHD(DEST,0),U)["REPLICATOR" D
 .;Restore original debug value
 .;;;S $P(^INRHSITE(1,0),U,16)=INENVSDB
 .D DISPLAY^INTSUT1("Processing through replicator completed",0)
 .;S STAT=$P(^INTHU(UIF,0),U,3),STAT=$S(STAT="C":"Complete",STAT="E":"Error",1:"Other")
 .S STAT=$$CVTCODE^INHUTC3($P(^INTHU(UIF,0),U,3),4001,.03)
 .S INMSG="Status of base message is: "_STAT D DISPLAY^INTSUT1(INMSG,0)
 .;Loop through activity log. Display replicants and screened messages.
 .S ACT=0 F  S ACT=$O(^INTHU(UIF,1,ACT)) Q:'ACT  D
 ..S LOG=^INTHU(UIF,1,ACT,0)
 ..I $P(LOG,U,2)="R" D
 ...S REP=$P(LOG,U,3) Q:'REP
 ...S REPDST=$P($G(^INRHD($P(^INTHU(REP,0),U,2),0)),U)
 ...S INMSG="Replicated message "_$P(^INTHU(REP,0),U,5)_" created for destination "_REPDST D DISPLAY^INTSUT1(INMSG,0)
 ...I REPDST["HL REPLICATOR" D DISPLAY^INTSUT1("!!! WARNING - Potential run away message. Check replicator definiton.",0)
 ...;In expanded mode, display text of replicated messages
 ...D:INEXPND EXPNDIS^INTSUT1(UIF)
 ..Q:'INPOP
 ..;If activity log shows replicant was screened
 ..I $P(LOG,U,2)="X" D
 ...D DISPLAY^INTSUT1("Replication suppressed",0)
 ...;if debugging is on, there will be subnodes
 ...Q:'$D(^INTHU(UIF,1,ACT,1))
 ...S L1=0 F  S L1=$O(^INTHU(UIF,1,ACT,1,L1)) Q:'L1  D
 ....S INMSG=$G(^INTHU(UIF,1,ACT,1,L1,0)) D DISPLAY^INTSUT1(INMSG,0)
 ;display errors
 D:$D(INHERR) ERRS^INTSTO(.INHERR)
 Q
 ;
