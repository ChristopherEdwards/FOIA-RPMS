DBTSDEL ;BAO/DMH delete patient from file   [ 02/04/1999  4:58 PM ]
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
 ;S DBTSP=13052     ;uncomm if want to test with call to TEST directly
 ;
 D ^XBKVAR
 I DUZ(2)=4526 S DUZ(2)=2348
 S DBTS("LOC")=$P($G(^AUTTLOC(DUZ(2),0)),"^",10)
 I DBTS("LOC")="" S DBTSRET(1)="-1" Q
 S DBTS("ID")=DBTS("LOC")_"|1490000|"_DBTSP
 S DA=DBTSP,DIK="^DBTSPAT(" D ^DIK
 S X=DBTSP,DIC(0)="XN" D ^DIC
 I +Y>0 S DBTSRET(1)="-1"
 E  S DBTSRET(1)="DELETED"
 K ^DBTS("TMP",DBTSP)
 Q
