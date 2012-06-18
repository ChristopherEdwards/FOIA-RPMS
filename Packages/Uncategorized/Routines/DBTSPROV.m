DBTSPROV ;DMH\BAO routine used to AUDIT PROVIDER table to send to Diabetes Tracker Database!!! [ 10/04/1999  10:40 AM ]
 ; dmh  -- 9/27/1999
 ;
 ;
PROV(DBTSRET,DBTSINPT)       ; 
 ;
ST ;
 D ^XBKVAR
 ;
 I $D(DBTSINPT) I DBTSINPT="BEGIN" S $P(^DBTSPARM(DUZ(2),0),"^",4)=0 S DBTSRET(1)="OK" Q
 ;
 S DBTS=+$P($G(^DBTSPARM(DUZ(2),0)),"^",4)
TEST ;
 ;S DBTS=900
 I '$D(DBTS) S DBTSRET(1)=-1 Q
 S LOC=$P($G(^AUTTLOC(DUZ(2),0)),"^",10)
 I LOC="" S DBTSRET(1)="-1" Q
 S CT=0
 F  S DBTS=$O(^DIA(200,DBTS)) Q:+DBTS=0  D
 .S $P(^DBTSPARM(DUZ(2),0),"^",4)=DBTS
 .  ;
 .  ;   above line logs the last DIA entry that was sent to SQL
 .  ;
 .I '$D(^DIA(200,DBTS,0)) Q 
 .S DBTSNO=$P(^DIA(200,DBTS,0),"^",1)
 .S DBTSREC=^VA(200,DBTSNO,0)
 .S NAME=$P(DBTSREC,U,1)
 .S SSN=$P($G(^VA(200,DBTSNO,1)),"^",9)
 .Q:SSN=""
 .Q:'$D(^VA(200,DBTSNO,9999999))
 .Q:'$D(^VA(200,DBTSNO,"PS"))
 .S AFF=$P($G(^VA(200,DBTSNO,9999999)),"^",1)
 .Q:AFF=""
 .S PSREC=$G(^VA(200,DBTSNO,"PS"))
 .S ID=$P(PSREC,"^",4)
 .I ID'="" S ID=$E(ID,4,5)_"/"_$E(ID,6,7)_"/"_(1700+$E(ID,1,3))
 .S DISC=$P(PSREC,"^",5)
 .Q:DISC=""
 .S DISC=$P(^DIC(7,DISC,9999999),"^",1)
 .S CT=CT+1
 .S DBTSRET(CT)=DBTSNO_U_LOC_U_NAME_U_DISC_U_AFF_U_ID
 .Q
 I '$D(DBTSRET) S DBTSRET(1)=-2
END ;
 K CT,DBTSREC,DBTSNO,DBTS,NAME,LOC,ID,DISC,AFF
 Q
