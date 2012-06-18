ABPACLG1 ;CHECK LOG UTILITY FUNCTIONS; [ 08/10/91  12:31 PM ]
 ;;1.4;AO PVT-INS TRACKING;*1*;IHS-OKC/KJR;AUGUST 10, 1991
 ;;PATCH 1: GETCHK+2 MODIFIED TO SCREEN FOR "N";IHS-OKC/KJR;10AUG91
 Q  ;;NOT AN ENTRY POINT
 ;---------------------------------------------------------------------
CLEAR ;PROCEDURE TO KILL ALL TEMPORARY LOCAL VARIABLES
 K X,Y,ABPA("HD"),DIC,DIE,DA,DR,ABPADFN,ABPAC,NOINS,NOCHECK,ABPAINS
 K ACCTPT,ACTPTR,INSPTR,ABPAINS
 Q
 ;---------------------------------------------------------------------
HEAD ;PROCEDURE TO DRAW SCREEN HEADING
 K ABPA("HD") S ABPA("HD",1)=ABPATLE,ABPA("HD",2)=$P(XQO,"^",2)
 D ^ABPAHD
 W !!,"Accounting Point",?18,"Payor",?44,"Check Number",?63,"Amount"
 W ?72,"Balance"
 W !,"----------------",?18,"------------------------",?44
 W "---------------",?61,"--------",?71,"--------",!
 W:$D(ACCTPT)=1 $E(ACCTPT,1,16) W ?18 W:$D(ABPAINS)=1 $E(ABPAINS,1,24)
 W ?44 W:$D(ABPACHK("NUM"))=1 ABPACHK("NUM") W ?61
 W:$D(ABPACHK("AMT"))=1 $J(ABPACHK("AMT"),8,2) W ?71
 W:$D(ABPACHK("RAMT"))=1 $J(ABPACHK("RAMT"),8,2)
 W ! F I=1:1:79 W "="
 W !
 Q
 ;--------------------------------------------------------------------
GETCHK ;PROCEDURE TO SELECT CHECK
 F KK=0:0 D  Q:(GOTCHECK)!(('GOTCHECK)&((Y="")!(Y["^")))  W *7,"  ??"
 .S RESTRICT=1,ABPASCR="I $P(^ABPACHKS(AP,""I"",RR,""C"",RRR,0),""^"",9)'>0!($P(^ABPACHKS(AP,""I"",RR,""C"",RRR,0),""^"",12)=""N"") S QFLG="""""
 .D MAIN^ABPACKLK
 Q:'GOTCHECK
 S ABPADFN(1)=$O(ABPACHK("")),ABPADFN(2)=$O(ABPACHK(ABPADFN(1),""))
 S ABPADFN(3)=$O(ABPACHK(ABPADFN(1),ABPADFN(2),""))
 S ACTPTR=+^ABPACHKS(ABPADFN(1),0),ACCTPT=$P(^DIC(4,ACTPTR,0),"^")
 S INSPTR=+^ABPACHKS(ABPADFN(1),"I",ABPADFN(2),0)
 S ABPAINS=ABPACHK("PAYOR")
 D HEAD G START^ABPACLG2
 ;--------------------------------------------------------------------
MAIN ;MAIN ROUTINE DRIVER PROCEDURE
 D CLEAR,HEAD,GETCHK
 D CLEAR K J,GOTCHECK,RESTRICT,ABPACHK
 Q
