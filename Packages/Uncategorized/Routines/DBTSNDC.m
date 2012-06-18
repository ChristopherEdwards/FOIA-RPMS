DBTSNDC ;DMH\BAO routine used to AUDIT NDC OF DRUG table to send to Diabetes Tracker Database!!! [ 03/18/1999  9:05 AM ]
 ; dmh  -- 3/12/1999
 ;
 ;
NDC(DBTSRET,DBTSINPT)       ; 
 ;
ST ;
 D ^XBKVAR
 ;
 I $D(DBTSINPT) I DBTSINPT="BEGIN" S $P(^DBTSPARM(DUZ(2),0),"^",2)=0 S DBTSRET(1)="OK" Q
 ;
 S DBTS=+$P($G(^DBTSPARM(DUZ(2),0)),"^",2)
 I '$D(DBTS) S DBTSRET=-1 Q
 S CT=0
 F  S DBTS=$O(^DIA(50,DBTS)) Q:+DBTS=0  D
 .S $P(^DBTSPARM(DUZ(2),0),"^",2)=DBTS
 .  ;
 .  ;   above line logs the last DIA entry that was sent to SQL
 .  ;
 .I '$D(^DIA(50,DBTS,0)) Q 
 .S DBTSREC=^DIA(50,DBTS,0)
 .S DBTSNO=$P(DBTSREC,U,1)
 .Q:'$D(^PSDRUG(DBTSNO,0))
 .S NAME=$P(^PSDRUG(DBTSNO,0),"^",1)
 .S NDC=$P($G(^PSDRUG(DBTSNO,2)),"^",4)
 .Q:NDC=""
 .S CLASS=$P($G(^PSDRUG(DBTSNO,"ND")),"^",6)
 .I CLASS'="" S CLASS=$P($G(^PS(50.605,CLASS,0)),"^",1)
 .S CT=CT+1
 .S DBTSRET(CT)=NDC_"^"_NAME_"^"_CLASS
 .Q
 I '$D(DBTSRET) S DBTSRET(1)=-2
END ;
 K CT,CLASS,NDC,DBTSREC,DBTSNO,DBTS,NAME
 Q
