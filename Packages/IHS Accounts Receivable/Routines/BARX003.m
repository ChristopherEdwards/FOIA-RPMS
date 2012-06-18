BARX003 ; IHS/SD/LSL - X-REF FOR TRANS FILE ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;
SET(N) ; EP - set
 D SV
 I $G(BARX3("QUIT")) K BARX3 Q
 S ^BARTR(DUZ(2),"ACB",BARX3(14),BARX3(15),BARX3(101),DA)=""
 K BARX3
 Q
 ; *********************************************************************
 ;
KILL(N) ; EP - kill
 D SV
 I $G(BARX3("QUIT")) K BARX3 Q
 K ^BARTR(DUZ(2),"ACB",BARX3(14),BARX3(15),BARX3(101),DA)
 K BARX3
 Q
 ; *********************************************************************
 ;
SV ; SET VARIABLES
 K BARX3
 S BARX3(N)=X
 S:'$G(BARX3(14)) BARX3(14)=$P($G(^BARTR(DUZ(2),DA,0)),"^",14)
 I 'BARX3(14) S BARX3("QUIT")=1 Q
 S:'$G(BARX3(15)) BARX3(15)=$P($G(^BARTR(DUZ(2),DA,0)),"^",15)
 I 'BARX3(15) S BARX3("QUIT")=1 Q
 S:'$G(BARX3(101)) BARX3(101)=$P($G(^BARTR(DUZ(2),DA,1)),"^",1)
 I 'BARX3(101) S BARX3("QUIT")=1
 Q
