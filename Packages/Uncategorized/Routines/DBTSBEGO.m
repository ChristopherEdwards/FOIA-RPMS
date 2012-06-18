DBTSBEG ;BAO/DMH begin load of patient to sql call   [ 02/04/1999  4:52 PM ]
 ;
 ;
 ;  this program is called from the DBTS ADD PATIENT BEGIN remote proc.
 ;     if it is not already in the 
 ;  
 ;
START ;
 ;
BEG(DBTSRET,DBTSP)          ;dbtsret is return value, dbtsp input value of patient ien
 ;
 ;
TEST ;
 S ARRAY=0
 ;S DBTSP=13051  ;uncomment if want to test with call to TEST directly
 ;
 D ^XBKVAR
 I DUZ(2)=4526 S DUZ(2)=2348
 S DBTS("LOC")=$P($G(^AUTTLOC(DUZ(2),0)),"^",10)
 I DBTS("LOC")="" S DBTSRET(1)="-1" Q
 S DBTS("ID")=DBTS("LOC")_"|1419200BEG|"_DBTSP
 I '$D(^DBTSPAT(DBTSP)) D  G SET
 .K ^DBTSPAT("B",DBTSP)
 .S X=DBTSP,DINUM=X,DIC(0)="XNL",DIC="^DBTSPAT(" D FILE^DICN
 ;  put the patient log information to a temporary holding
 I '$D(^DBTSPAT(DBTSP)) S DBTSRET(1)="-1" Q
 S NODE=""
 F  S NODE=$O(^DBTSPAT(DBTSP,NODE)) Q:NODE=""  D
 .S ^DBTS("TMP",DBTSP,NODE)=^DBTSPAT(DBTSP,NODE)
 .Q
 S ^DBTS("TMP",DBTSP,"ZZSAVEDON")=DT
SET ;
 I '$D(^DBTSPAT(DBTSP)) S DBTSRET(1)="-1" Q
 E  S DBTSRET(1)=DBTS("ID")_U_DBTS("LOC")_U_DBTSP_U_"BEGIN"
 Q
