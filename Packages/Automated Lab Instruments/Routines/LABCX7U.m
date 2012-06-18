LABCX7U ; IHS/DIR/FJE - ; [ 05/27/2003  6:53 AM ]
 ;;5.2;LA;**1016**;MAY 27, 2003
DOC ;utility routine, performs various functions to maintain CX7s.
STAT ;check instrument status
 S A=0 F I=1:1 S A=$O(^LAB(62.4,"D","CX7",A)) Q:'A  S VAR="DEV"_I,@VAR=A ;JPW removed label 0 (duplicate);10/27/94
 I I=1 W *7,*7,!!,"YOU HAVE NO DEVICES DEFINED IN THE AUTO INSTRUMENT FILE AS A CX7!!",!! K A,I,VAR Q
 W ! I $D(OPT) D MON G EXIT
 I I=2 S T=DEV1 D SEND G EXIT
 S D=I-1 F J=1:1:D S VAR="DEV"_J,T=@VAR D REQ
EXIT K A,I,D,DEV1,DEV2,VAR,T,CNT,S1,S2,S3,OUT,CX3,CX4,CX3T,CX4T,POP,J,ANS
 K OPT,MDEV,NAME,CK,CKSUM Q
REQ ;Request instrument state
 W !,"Device ",T,", ",$P(^LAB(62.4,T,0),U),"? Y// " R ANS:30
 I '$T!(ANS["^")!(ANS["N") W "   No action taken" Q
SEND D ZIS(0,.ANS) Q:ANS=1  ;CHECK IF LINE UP, NO ERROR IF IT IS
 L ^LA(T,"O") S CNT=$G(^LA(T,"O")),^LA(T,"O")=CNT+3 L  ;***JPC $GET***
 S S1=CNT+1,S2=CNT+2,S3=CNT+3 K ^LAZ("ZZZ",T)
 S (OUT,^LA(T,"O",S1))=$C(1)
 S OUT="["_T_",703,03]" S CK=0 F I=1:1:$L(OUT) S CK=CK+$A($E(OUT,I))
 S CK=CK#256,CKSUM=256-CK D HEX^LABCX7R
 S (OUT,^LA(T,"O",S2))=OUT_CKSUM
 S (OUT,^LA(T,"O",S3))=$C(4)
REC ;Receive 703,04 from CX7
 W !,"Waiting for response from device ",T,"..."
 ;The following FOR loop will determine how long the host will wait for
 ;a response from the CX7.  You may adjust depending on response time.
 F I=1:1:60 Q:$D(^LAZ("ZZZ",T))  H 1 ;JPC CHANGE TIME 30 TO 60
 I '$D(^LAZ("ZZZ",T)) D ZIS(1) Q
 S CX3=+$P(^LAZ("ZZZ",T),",",7) I CX3=0 S CX3=$E($P(^(T),",",7),2)
 S CX4=+$P(^LAZ("ZZZ",T),",",8) I CX4=0 S CX4=$E($P(^(T),",",8),2)
 S CX3T=$P($T(@CX3),";",2),CX4T=$P($T(@CX4),";",3)
 W !!,"DEVICE ",T,": CX3 is in the ",CX3T," state."
 W !,?11,"CX4 is in the ",CX4T," state.",!!,*7
 K ^LAZ("ZZZ",T)
 Q
ZIS(MES,ANS) ;check to see if CX7 is off-line, or interface went down
 S ANS=0,IOP=$P(^LAB(62.4,T,0),U,2) D ^%ZIS ;JPC-CHECK POP AFTER %ZIS, NOT %ZISC
 I MES,POP K IOP W !!,?19,"The interface IS operating properly!",!,?5,*7,*7,"The CX7 is NOT in Bi-Directional mode.  Put the CX7 back On-Line.",!! ;JPC
 I 'POP D ^%ZISC K IOP W !!,?5,*7,*7,"The interface is down, Please Restart the interface",!! S ANS=1 ;JPC - CLOSE DEVICE
 Q
STATUS ;CX3 STATUS CODES ; CX4 STATUS CODES ;
0 ;NO STATE;NO STATE;
1 ;STOPPED;STOPPED;
2 ;STANDBY;PAUSE INITIATED;
3 ;SYSTEM HOME;;
4 ;REAGENT LOAD;EXTINCTION-COEFFICIENT;
5 ;PRIME;RUNNING;
6 ;CALIBRATION;IDLE, SHUTDOWN IN PROGRESS;
7 ;RUNNING;IDLE;
8 ;MAINTENANCE;INITIALIZING;
9 ;AUTOPRIME;REAGENT LOAD;
10 ;CALIBRATION REQUEST;HOMING;
11 ;NO STATE;PRIMING;
12 ;BOOTING;;
13 ;PAUSE INITIATED;SAVING TO DISK;
14 ;WAITING;READING FROM DISK;
15 ;SYSTEM IDLE;STANDBY;
16 ;;CHECKING LEVELS;
17 ;;;
18 ;;PROCEDURE IN PROGRESS;
19 ;;PROCEDURE TERMINATION IN PROGRESS;
20 ;;PROCEDURE COMPLETE;
21 ;;WAITING;
MON ;monitor CX7 interface - for programmers only
 I I=2 S T=DEV1,NAME=$P(^LAB(62.4,T,0),U) D @OPT Q  ;ADDED SET OF NAME ** JPC**
 S D=I-1 F J=1:1:D S VAR="DEV"_J,T=@VAR,NAME=$P(^LAB(62.4,T,0),U) D @OPT
 Q
START W !,"Do you want to monitor device ",T,", ",NAME,"?  N// " R ANS:30
 I ANS["Y" S MDEV="D"_T K ^LA(MDEV) S ^LA(MDEV,0)=0 W *7,"   Monitoring in progress" Q
 W "    No action taken" Q
STOP S MDEV="D"_T I '$D(^LA(MDEV,0)) W !,"Device ",T,", ",NAME,", ","is not being monitored. No action needed." Q
 W !,"Do you want to stop monitoring device ",T,", ",NAME,"?  Y// " R ANS:30
 I ANS["N"!(ANS["^") W "    No action taken" Q
 K ^LA(MDEV) W *7,"   Monitoring is stopped" Q
