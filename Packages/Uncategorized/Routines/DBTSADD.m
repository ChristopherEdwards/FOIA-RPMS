DBTSADD ;BAO/DMH begin load of patient to sql call   [ 10/29/1999  5:56 PM ]
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
 K DBTSNEW
 S ARRAY=0
 ;S DBTSP=71  ;uncomment if want to test with call to TEST directly
 ;S DBTSP=17897   ;crow demo patient dfn for testing
 ;
 D ^XBKVAR
 I DUZ(2)=4526 S DUZ(2)=2348
 S DBTS("LOC")=$P($G(^AUTTLOC(DUZ(2),0)),"^",10)
 I DBTS("LOC")="" S DBTSRET(1)="-1" Q
 S DBTS("ID")=DBTS("LOC")_"|1419200BEG|"_DBTSP
 ;
 ;
 K DBTS("NEWPAT")
 I '$D(^DBTSPAT(DBTSP)) S DBTS("NEWPAT")="Y" D  Q
 .K ^DBTSPAT("B",DBTSP)
 .S X=DBTSP,DINUM=X,DIC(0)="XNL",DIC="^DBTSPAT(" D FILE^DICN
 .S DBTSNEW="Y"
 .S DBTSRET(1)="1^1^1^1^1^1^1^1^1^1^1^1^1^1^1^1^1^1^1^"
 .Q
 ;
 ;  put the patient log information to a temporary holding
 I '$D(^DBTSPAT(DBTSP,"A")) S DBTSRET(1)="-1" Q
 S NODE=""
 F  S NODE=$O(^DBTSPAT(DBTSP,NODE)) Q:NODE=""  D
 .S ^DBTS("TMP",DBTSP,NODE)=^DBTSPAT(DBTSP,NODE)
 .Q
 S ^DBTS("TMP",DBTSP,"ZZSAVEDON")=DT
SET ;
 S DBTSRET(1)=$P(^DBTSPAT(DBTSP,"A"),"^",2)
 S DBTSRET(1)=$TR(DBTSRET(1),"|","^")
 Q
