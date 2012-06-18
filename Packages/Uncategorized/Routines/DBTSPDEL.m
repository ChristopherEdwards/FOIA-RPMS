DBTSPDEL ;BAO/DMH delete patient from file   [ 02/04/1999  2:10 PM ]
 ;
 ;
 ;
START ;
 ;
DEL(DBTSRET,DBTSP)          ;dbtsret is return value, dbtsp input value of patient ien
 ;
 ;
TEST ;
 S ARRAY=0
 ;S DBTSP=13052  ;uncomment if want to test with call to TEST directly
 ;
 D ^XBKVAR
 I DUZ(2)=4526 S DUZ(2)=2348
 S DBTS("LOC")=$P($G(^AUTTLOC(DUZ(2),0)),"^",10)
 I DBTS("LOC")="" S DBTSRET(1)="-1" Q
 S DBTS("ID")=DBTS("LOC")_"|1419200DEL|"_DBTSP
 ;
 I '$D(^DBTSPAT(DBTSP,0)) K ^DBTSPAT(DBTSP) G OK
 ;
 S DA=DBTSP,DIK="^DBTSPAT(" D ^DIK
 S X=DBTSP,DIC(0)="XN" D ^DIC
 I +Y>0 S DBTSRET(1)="-1"  Q
 K ^DBTS("TMP",DBTSP)
OK ;
 S DBTSRET(1)=DBTS("ID")_U_DBTS("LOC")_U_DBTSP_U_"DELETED"
 Q
