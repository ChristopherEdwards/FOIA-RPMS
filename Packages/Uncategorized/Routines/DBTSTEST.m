DBTSTEST ;routine to test the speed of the line and updates [ 05/07/1999  10:28 AM ]
 ;replicating the cpt file
T ;
 S ZZ=""
TEST(DBTSRET,ZZ) ;
 S DBTSRET(1)="-1"
 S LAST=$P($G(^DBTSTMP("TEST",0)),"^",1)
 S LAST=+LAST
 S ARR=0
NEXT ;
 S LAST=$O(^ICPT(LAST))
 I +LAST=0 S DBTSRET(1)="-2" K ^DBTSTMP("TEST") Q
 I $E(LAST,1,2)="00" S DBTSRET(1)="-2" K ^DBTSTMP("TEST") Q
 S REC=$G(^ICPT(LAST,0))
 I REC="" S ^DBTSTEST(0)=LAST G NEXT
 S CODE=$P(REC,"^",1)
 S DESC=$P(REC,"^",2)
 S ARR=ARR+1
 S DBTSRET(ARR)=CODE_$C(9)_DESC
 S ^DBTSTMP("TEST",0)=LAST
 I ARR=200 Q
 G NEXT
