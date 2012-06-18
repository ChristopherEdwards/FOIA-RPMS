DBTSCOMT ;BAO/DMH call from SQL that data was committed [ 02/04/1999  4:57 PM ]
 ;
 ;
 ;  this program is called from the DBTS ADD PATIENT COMMIT remote proc.
 ;     call sends patient id saying that load to SQL was complete.
 ;     so remove the temporary global on the patient log before 
 ;     the load started
 ;  
 ;
START ;
 ;
COM(DBTSRET,DBTSP)          ;dbtsret is return value, dbtsp input value of patient ien
 ;
 ;
TEST ;
 S ARRAY=0
 ;S DBTSP=13051  ;uncomment if want to test with call to TEST directly
 ;
 S DBTSRET(1)="-1"  ;set this just in case the program stops before k
 D ^XBKVAR
 I DUZ(2)=4526 S DUZ(2)=2348
 S DBTS("LOC")=$P($G(^AUTTLOC(DUZ(2),0)),"^",10)
 I DBTS("LOC")="" S DBTSRET(1)="-1" Q
 S DBTS("ID")=DBTS("LOC")_"|1419200COM|"_DBTSP
 K ^DBTS("TMP",DBTSP)
 S DBTSRET(1)=DBTS("ID")_U_DBTS("LOC")_U_DBTSP_U_"COMMIT"
 Q
