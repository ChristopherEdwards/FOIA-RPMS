DBTSUPCH ;BAO/DMH call from SQL to change date on log [ 02/04/1999  2:19 PM ]
 ;        for Keith to test update mode of data coming to him
 ;
 ;
 ;  this program is called from the DBTS CHANGE LOG remote proc.
 ;     call sends patient id saying that load to SQL was complete.
 ;     so remove the temporary global on the patient log before 
 ;     the load started
 ;  
 ;
START ;
 ;
CHG(DBTSRET,DBTSP)          ;dbtsret is return value, dbtsp input value of patient ien
 ;
 ;
TEST ;
 S ARRAY=0
 S OK="N"
 ;S DBTSP=13052  ;uncomment if want to test with call to TEST directly
 ;
 S DBTSRET(1)="-1"  ;  -1 if no data in file
 Q:'$D(^DBTSPAT(DBTSP))
 D ^XBKVAR
 I DUZ(2)=4526 S DUZ(2)=2348
 S DBTS("LOC")=$P($G(^AUTTLOC(DUZ(2),0)),"^",10)
 I DBTS("LOC")="" S DBTSRET(1)="-1" Q
 S DBTS("ID")=DBTS("LOC")_"|1419200CHG|"_DBTSP
 F NODE="ALB","AMP","BP","BRE","CHO","CRE","DEN","EDU","EKG","EYE" D SET
 F NODE="FAM","FTC","FTE","HAC","HDL","HT","IMM","LDL","MED","PEL" D SET
 F NODE="PPD","REC","TRI","WT","LIP","REN" D SET
 I OK="N" S DBTSRET(1)=-2 Q     ;no changes to data log
 S DBTSRET(1)=DBTS("ID")_U_DBTS("LOC")_U_DBTSP_U_"CHANGED"
 Q
SET ;
 I $D(^DBTSPAT(DBTSP,NODE)) S $P(^DBTSPAT(DBTSP,NODE),"^",2)=2980301 S OK="Y"
 Q
