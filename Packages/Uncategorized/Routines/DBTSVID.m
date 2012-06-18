DBTSVID ;routine to send the visit id SQL for diabetes [ 11/16/1999  6:34 PM ]
 ;  when the rpmsid is sent to me
 ;
 ;
VID(DBTSGBL,DBTSRID) ;
TEST ;
 K ^DBTSTEMP(1)
 S DBTSGBL="^DBTSTEMP("_1_")"
 S ARRAY=0
 ;S DBTSRID="404510|9000010.08|36309"   ;uncomment if want to test with call to TEST directly
 ;
 D ^XBKVAR
 I DUZ(2)=4526 S DUZ(2)=2348
 S DBTS("LOC")=$P($G(^AUTTLOC(DUZ(2),0)),"^",10)
 ;I DBTS("LOC")="" S DBTSRET(1)="-1" S ^DBTSTEMP(1,1)="-1"_$C(13)_$C(10) Q
 ;  dmh take of cr/lf  per keith 11-16-99
 ;
 I DBTS("LOC")="" S DBTSRET(1)="-1" S ^DBTSTEMP(1,1)="-1"
 S DBTS("FILE")=$P(DBTSRID,"|",2)
 S DBTS("DFN")=$P(DBTSRID,"|",3)
 S GLOBAL=$G(^DIC(DBTS("FILE"),0,"GL")) 
 I GLOBAL="" S ^DBTSTEMP(1,1)="-1" Q
 S GLOB=GLOBAL_DBTS("DFN")_",0)"
 S DBTS("VDFN")=$P(@GLOB,"^",3)
 I DBTS("VDFN")="" S ^DBTSTEMP(1,1)="-2" Q
 S VID=DBTS("LOC")_"|9000010|"_DBTS("VDFN")
 S ^DBTSTEMP(1,1)=VID
 Q
