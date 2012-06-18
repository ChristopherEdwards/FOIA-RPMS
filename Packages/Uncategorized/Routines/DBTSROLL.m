DBTSROLL ;BAO/DMH roll back the patient log to where it   [ 02/05/1999  11:13 AM ]
 ;        was prior to the beginning of the load
 ;
 ;
 ;     is called from the DBTS ADD PATIENT ROLLBACK remote proc.
 ;     if error was encountered in the middle of the SQL load this 
 ;     procedure is called to reset the log to where is was before
 ;     the load was started
 ;  
 ;
START ;
 ;
ROL(DBTSRET,DBTSP)          ;dbtsret is return value, dbtsp input value of patient ien
 ;
 ;
TEST ;
 S ARRAY=0
 ;S DBTSP=12016  ;uncomment if want to test with call to TEST directly
 ;
 S DBTSRET(1)="-1"  ;just incase stops prematurely
 D ^XBKVAR
 I DUZ(2)=4526 S DUZ(2)=2348
 S DBTS("LOC")=$P($G(^AUTTLOC(DUZ(2),0)),"^",10)
 I DBTS("LOC")="" S DBTSRET(1)="-1" Q
 S DBTS("ID")=DBTS("LOC")_"|1419200ROL|"_DBTSP
 ;
 ;                      if nothing in tmp returns -1
 ;
 ;I '$D(^DBTS("TMP",DBTSP)) S DBTSRET(1)="-1" Q
 ;  put the temp patient log information back to dbts patient file
 S DA=DBTSP,DIK="^DBTSPAT(" D ^DIK
 S NODE=""
 F  S NODE=$O(^DBTS("TMP",DBTSP,NODE)) Q:NODE=""  D
 .S ^DBTSPAT(DBTSP,NODE)=^DBTS("TMP",DBTSP,NODE)
 .Q
 S DBTSRET(1)=DBTS("ID")_U_DBTS("LOC")_U_DBTSP_U_"ROLLBACK"
 K ^DBTS("TMP",DBTSP)
 Q
