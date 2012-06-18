DBTSPUPD ;BAO/DMH  pull patient list  [ 11/02/1999  6:23 PM ]
 ;
 ;   called from DBTS PATIENTS remote procedure
 ;
START ;
 ;
PAT(DBTSGBL,DBTSP)          ;dbtsret is return value, dbtsp input value of patient ien
 ;
 ;
TEST ;
 K ^DBTSTEMP(1)
 S DBTSGBL="^DBTSTEMP("_1_")"
 S ARRAY=0
 ;S DBTSP=9161    ;for testing
 ;
 D ^XBKVAR
 I DUZ(2)=4526 S DUZ(2)=2348
 S DBTS("LOC")=$P($G(^AUTTLOC(DUZ(2),0)),"^",10)
 I DBTS("LOC")="" S ^DBTSTEMP(1,1)="-1"_$C(13)_$C(10) Q
 S DBTS("IEN")=0
 F I=1:1 S DBTS("IEN")=$O(^DBTSPAT(DBTS("IEN"))) Q:+DBTS("IEN")=0  D  
 .Q:'$D(^DBTSPAT(DBTS("IEN"),0))
 .S REC=$G(^DBTSPAT(DBTS("IEN"),"A"))
 .Q:REC=""
 .I $P(REC,"^",2)'["1" Q
 .S ARRAY=ARRAY+1
 .S ^DBTSTEMP(1,ARRAY)=DBTS("IEN")_$C(13)_$C(10)
 .Q
 I ARRAY=0 S DBTSRET(1)="-2" S ^DBTSTEMP(1,1)="-2"_$C(13)_$C(10)
 Q
