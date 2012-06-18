ABPACKLK ;LOOK UP UNPROCESSED CHECKS; [ 08/17/91  1:29 PM ]
 ;;1.4;AO PVT-INS TRACKING;*1*;IHS-OKC/KJR;AUG 17, 1991
 ;;PATCH #1: INIT+3 MODIFIED TO SCREEN FOR 'N';IHS-OKC/KJR;17AUG91
 W !!,"<<< NOT AN ACCESS POINT - ACCESS DENIED >>>",!!,Q
 ;--------------------------------------------------------------------
CLEAR ;PROCEDURE TO KILL TEMPORARY LOCAL VARIABLES
 K DIR,R,RR,J,K,CNT,M,IPTR,TEMP,RRR,INSNAME,L,ACCTPT,ACTPTR,AP
 Q
 ;--------------------------------------------------------------------
INIT ;PROCEDURE TO INITIALIZE TEMPORARY LOCAL VARIABLES
 S GOTCHECK=0 S:$D(RESTRICT)'=1 RESTRICT=1
 S:$D(ABPA("LOG"))'=1 ABPA("LOG")=0
 S:$D(ABPASCR)'=1 ABPASCR="I $P(^ABPACHKS(AP,""I"",RR,""C"",RRR,0),""^"",9)'>0!($P(^ABPACHKS(AP,""I"",RR,""C"",RRR,0),""^"",12)=""N"") S QFLG="""""
 Q
 ;--------------------------------------------------------------------
GETCHK ;PROCEDURE TO GET CHECK NUMBER TO LOOK UP
 K DIR,ABPACHK S DIR(0)="FO",DIR("A")="Select CHECK NUMBER" D ^DIR
 S ABPACHK=Y
 Q
 ;--------------------------------------------------------------------
LOOK ;PROCEDURE TO LOOK-UP AND DISPLAY CHECK DATA
 D INIT  Q:$D(^ABPACHKS("AB",ABPACHK))'=10
 S CNT=0,R=ABPACHK,AP=0 F M=0:0 D  Q:+AP=0
 .S AP=$O(^ABPACHKS("AB",R,AP)) Q:+AP=0
 .S RR=0 F K=0:0 D  Q:+RR=0
 ..S RR=$O(^ABPACHKS("AB",R,AP,RR)) Q:+RR=0
 ..S RRR=0 F L=0:0 D  Q:+RRR=0
 ...S RRR=$O(^ABPACHKS("AB",R,AP,RR,RRR)) Q:+RRR=0
 ...Q:$D(^ABPACHKS(AP,"I",RR,"C",RRR,0))'=1
 ...I RESTRICT K QFLG X ABPASCR Q:$D(QFLG)=1
 ...S CNT=CNT+1,TEMP(CNT,AP,RR,RRR)=^ABPACHKS(AP,"I",RR,"C",RRR,0)
 I +CNT>0 D
 .W !!?3,"Acct",?10,"Check Number",?24,"Payor",?63,"Amount"
 .W ?72,"Balance" F J=1:1:CNT D
 ..Q:$D(TEMP(J))'=10
 ..S AP=$O(TEMP(J,"")),ACCTPT="??"
 ..I $D(^ABPACHKS(AP,0))=1 S ACTPTR=+^(0) Q:+ACTPTR'>0
 ..I $D(^AUTTLOC(ACTPTR,0))=1 S ACCTPT=$P(^(0),"^",17)
 ..S RR=$O(TEMP(J,AP,"")),INSNAME="*** UNKNOWN ***"
 ..I $D(^ABPACHKS(AP,"I",RR,0))=1 S IPTR=+^(0) Q:+IPTR'>0
 ..I $D(^AUTNINS(IPTR,0))=1 S INSNAME=$E($P(^(0),"^"),1,35)
 ..S RRR=$O(TEMP(J,AP,RR,"")) Q:+RRR'>0
 ..W !,J,?3,ACCTPT,?7,$J($P(TEMP(J,AP,RR,RRR),"^"),15),?24,INSNAME
 ..W ?61,$J($P(TEMP(J,AP,RR,RRR),"^",4),8,2)
 ..W ?71,$J($P(TEMP(J,AP,RR,RRR),"^",9),8,2)
 .I +CNT>1 F J=0:0 D  Q:+Y>0!(Y']"")!(Y["^")
 ..K DIR S DIR(0)="NO^1:"_CNT,DIR("A")="CHOOSE" W ! D ^DIR
 .I +CNT=1 F J=0:0 D  Q:"01"[Y
 ..K DIR S DIR(0)="Y",DIR("A")="IS THIS THE CORRECT CHECK"
 ..S DIR("B")="YES" W ! D ^DIR
 .Q:+Y'>0  Q:$D(TEMP(+Y))'=10
 .K ABPACHK S AP=$O(TEMP(+Y,"")) Q:AP=""  Q:$D(TEMP(+Y,AP))'=10
 .S R=$O(TEMP(+Y,AP,"")) Q:+R'>0  Q:$D(TEMP(+Y,AP,R))'=10
 .S RR=$O(TEMP(+Y,AP,R,"")) Q:+RR'>0  Q:$D(TEMP(+Y,AP,R,RR))'=1
 .S ABPACHK(AP,R,RR)=TEMP(+Y,AP,R,RR),GOTCHECK=1
 .S ABPACHK("NUM")=$P(ABPACHK(AP,R,RR),"^")
 .S ABPACHK("AMT")=$P(ABPACHK(AP,R,RR),"^",4)
 .S ABPACHK("RAMT")=$P(ABPACHK(AP,R,RR),"^",9)
 .S ABPACHK("PAYOR")=$P(^AUTNINS(+^ABPACHKS(AP,"I",R,0),0),"^")
 .S ABPACHK("XMIT")=$P(ABPACHK(AP,R,RR),"^",2)
 .S ABPACHK("LUSR")=$P(ABPACHK(AP,R,RR),"^",10) I ABPACHK("LUSR")]"" D
 ..S ABPACHK("LUSR")=$P(^DIC(3,ABPACHK("LUSR"),0),"^",2)
 ..S ABPA("DTIN")=$P($P(ABPACHK(AP,R,RR),"^",11),".")
 ..D DTCVT^ABPAMAIN
 ..S ABPACHK("LUSR")=ABPACHK("LUSR")_" ON "_ABPA("DTOUT")
 .S AP=$P(^ABPACHKS(AP,0),"^"),ABPACHK("AP")=$P(^AUTTLOC(AP,0),"^",4)
 .S ABPACHK("APNAM")=$P(^DIC(4,AP,0),"^")
 I ('GOTCHECK&('RESTRICT))!(ABPA("LOG")) Q
 I 'GOTCHECK D  I Y]"" I $E(Y,1)'=" " I Y'["^" G LOOK
 .W *7,"  ??",! D GETCHK
 Q
 ;--------------------------------------------------------------------
MAIN ;ENTRY POINT - THE PRIMARY ROUTINE DRIVER
 D CLEAR,INIT,GETCHK I Y']""!(Y']" ")!(Y["^") D CLEAR Q
 D LOOK,CLEAR K RESTRICT,ABPASCR
 Q
