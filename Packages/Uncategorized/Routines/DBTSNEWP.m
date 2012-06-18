DBTSNEWP ;DMH\BAO routine to pull all the new patients that have DM [ 11/23/1999  3:54 PM ]
 ;3/17/99
 ;
 ;
PAT(DBTSRET,DBTSINPT)     ;
ST ;
 D ^XBKVAR
 ;
 I $D(DBTSINPT) I DBTSINPT="BEGIN" S $P(^DBTSPARM(DUZ(2),0),"^",3)=0 S DBTSRET(1)="OK" Q
 ;
 S DBTS=+$P($G(^DBTSPARM(DUZ(2),0)),U,3)
 I '$D(DBTS) S DBTSRET=-1 Q
 S CT=0
 F  S DBTS=$O(^DIA(9000010.07,DBTS)) Q:+DBTS=0  D
 .S $P(^DBTSPARM(DUZ(2),0),"^",3)=DBTS
 .  ;
 .  ;  above line logs the last DIA entry that was sent to SQL
 .  ;
 .I '$D(^DIA(9000010.07,DBTS,0)) Q
 .S DBTSREC=^DIA(9000010.07,DBTS,0)
 .S DBTS("NO")=$P(DBTSREC,U,1)
 .Q:$P($G(^DIA(9000010.07,DBTS,3)),U,1)'?1"250.".E
 .S DBTS("PAT")=$P($G(^AUPNVPOV(DBTS("NO"),0)),U,2)
 .Q:DBTS("PAT")=""
 .I $D(^DBTSPAT(DBTS("PAT"))) Q
 .S CT=CT+1
 .S DBTSRET(DBTS("PAT"))=DBTS("PAT")
 .     ;  changed from "CT" to DBTS("PAT") on set side -11/23/99 dmh
 .     ;  so duplicates in same day don't happen if pat. diag. with
 .     ;  a diabetes code twice in same day
 .Q
 I '$D(DBTSRET) S DBTSRET(1)=-2
END ;
 K CT,DBTS,DBTSREC
 Q
