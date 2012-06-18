DBTSACC ;remote procedure call to send back the security type of a user [ 02/05/1999  10:55 AM ]
 ;logging in to use the diabetes register on the client
 ;the call will send me the DUZ of the user
 ;this will check the security keys of the user and send back
 ;the type of access if any for the user
 ;
 ;  codes sending back to the client
 ;      -1  = error   probably no keys est. on the RISC box yet
 ;       0  = top level of security (DBTSEDIT key) is held by user
 ;       1  = (DBTSADD key) user hold add privledges
 ;       2  = (DBTSREAD key) user holds read only key
 ;       3  = unknown  no privledges to access the diabetes register
 ;
 ;
START(RET,DUZ)  ;
 K RET
 S ^DBTSTMP("TEST")=DUZ
 I '$D(DUZ) S RET(1)="-1" Q
 I DUZ'?.N S RET(1)="-1" Q
 D KEYS I $D(RET(1)),(RET(1)="-1") Q
 I '$D(DBTS) S RET(1)="-1" Q
 F I=0,1,2 S KEY=DBTS(I) I KEY'="",$D(^VA(200,DUZ,51,KEY)) S RET(1)=I Q
 ;I RET(1)="" S RET(1)="3" Q
 I '$D(RET) S RET(1)="3" Q
 Q
 ;
KEYS ;
 I '$D(^DIC(19.1,"B","DBTSEDIT")),'$D(^DIC(19.1,"B","DBTSADD")),'$D(^DIC(19.1,"B","DBTSREAD")) S RET(1)="-1" Q
 F DBTSKEY="DBTSEDIT","DBTSADD","DBTSREAD" D
 .S DBTSKDFN=$O(^DIC(19.1,"B",DBTSKEY,0))
 .I DBTSKEY="DBTSEDIT" S DBTS(0)=DBTSKDFN
 .I DBTSKEY="DBTSADD" S DBTS(1)=DBTSKDFN
 .I DBTSKEY="DBTSREAD" S DBTS(2)=DBTSKDFN
 Q
