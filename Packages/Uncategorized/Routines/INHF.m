INHF(INTT,INDA,INDIPA,INTIME,INPRIOR,INDIV,INQUE) ; cmi/flag/maw - DGH,JSH 6 Apr 97 13:06 Formatter front-end for application calls ;
 ;;3.01;BHL IHS Interfaces with GIS;**1**;JUN 01, 2002
 ;COPYRIGHT 1991-2000 SAIC
 ;
 ;INTT = Textual form of the transaction type (not an entry #) [REQD]
 ;INDA = Entry # in base file (file mentioned in script) [REQD]
 ;         If passed by reference (opt), subscripts may hold entry
 ;         numbers in subfiles in the format:
 ;            INDA(subfile #,DA)=""
 ;INDIPA = An array passed by reference whose subscripts will become
 ;             '@' variables in the script [OPT]
 ;INTIME = When to run [OPT]
 ;             time in $H, FileMan, or %DT format
 ;INPRIOR = Priority [OPT], a number 0 - 10 (Parameter added for ver 4.4)
 ;INDIV = Division. If supplied, it will be stored in UIF field .21
 ;INQUE = 1 to suppress queuing in "AH" cross reference. Use this
 ;   to create entries in task file for Unit Test Utilities 
 ;OUTPUT:  INHF = INTSK if accepted
 ;              = 0 if rejected for any reason (including system inactive)
 ;N X,Y,INTSK,TIME,DIC,DLAYGO,DO,DS,PRIOR,%DT S INHF=0
 S INHF=0
 D EN^XBNEW("MAIN^INHF","IN*")  ;cmi/maw added for RPMS
 Q
 ;
MAIN ;EP - this is the start of the routine
 Q:'$G(^INRHSITE(1,"ACT"))  ;Quit if interface system is inactive
 Q:'$L($G(INTT))!'$D(INDA)!'$G(DUZ)
 S X=INTT,INTT=$O(^INRHT("B",INTT,"")) I 'INTT D ERROR("^INHF call made with unknown transaction type '"_X_"'") Q
 S INTT(0)=^INRHT(INTT,0) Q:'$P(INTT(0),U,5)  ;Quit if this transaction type is inactive
 Q:$P(INTT(0),U,6)  ;Quit if this transaction type is not a parent
 K:$G(INTIME)="" INTIME
 I '$D(INTIME),$P(INTT(0),U,13)]"" S INTIME=$P(INTT(0),U,13)
 I $G(INTIME)="STAT" S INTIME="00000,00000" G PRIOR
 I $D(INTIME) S TIME=INTIME D
 .Q:TIME?1.N1","1.N
 .I TIME?7N.1".".N S INTIME=$$CDATF2H^UTDT(TIME) S:INTIME=+INTIME INTIME=INTIME_",1" Q
 .S X=TIME,%DT="RTS" D ^%DT I Y<0 D  Q
 ..D ERROR("Time specified in ^INHF call is invalid '"_TIME_"'"_".  Processing transaction NOW instead.") S INTIME=$H
 .S INTIME=$$CDATF2H^UTDT(Y)
 S:'$G(INTIME) INTIME=$H S X=$P(INTIME,",",2) I $L(X)<5 S X=$E("00000",1,5-$L(X))_X,$P(INTIME,",",2)=X
PRIOR S PRIOR=$S($L($G(INPRIOR)):+INPRIOR,1:+$P(INTT(0),U,14))
 S DIC="^INLHFTSK(",DLAYGO=4000.1,DIC(0)="LF",X=INTT
 ;Branch if system is IHS
 I $$SC^INHUTIL1 D EN^DICN
 I '$$SC^INHUTIL1 D NEW^DICN
 I Y<0 D ERROR("Unable to add entry into Interface Formatter Task file") Q
 S INTSK=+Y
 L +^INLHFTSK(INTSK)
 M ^INLHFTSK(INTSK,2)=INDIPA
 I $D(INDA)>9 M ^INLHFTSK(INTSK,1)=INDA
 S ^INLHFTSK(INTSK,0)=INTT_U_INDA_U_DUZ_U_INTIME_U_$P($G(DUZ(2)),U,1)_U_PRIOR_U_$S($D(INDIV):INDIV,1:$P($G(DUZ(2)),U))
 S:'$G(INQUE) ^INLHFTSK("AH",PRIOR,INTIME,INTSK)=""
 L -^INLHFTSK(INTSK)
 S INHF=INTSK
 Q
ACK(INTT,INQUE) ;Entry point to send Acknowledge message
 ;Ack Transaction Types do not have the Parent/Child structure
 ;INTT = transaction type entry #
 ;INQUE (OPT) = If set to 1, will pass parameter into script signalling
 ;that ack is not to be queued into output controller, INLHSCH
 N SCR,DEST,Z
 S SCR=$P(^INRHT(INTT,0),U,3),DEST=+$P(^INRHT(INTT,0),U,2)
 Q:'SCR!'DEST  Q:'$D(^INRHS(SCR))!'$D(^INRHD(DEST))
 S Z="S ER=$$^IS"_$E(SCR#100000+100000,2,6)_"("_INTT_",-1,.INA,"_DEST_","_$G(INQUE)_")"
 X Z
 Q
ERROR(MESS) ;Log an error message
 D ENF^INHE($G(INTT),$G(INDA),$G(DUZ),.INDIPA,MESS)
 Q
ERR ;MUMPS error
 D ERROR($$ERRMSG^INHU1)
 X $G(^INTHOS(1,3))
 K ^INLHFTSK(INTSK),^INLHFTSK("B",INTT,INTSK)
 Q
