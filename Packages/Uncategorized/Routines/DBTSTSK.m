DBTSTSK ;BAO/DMH  QUEUED ROUTINE  [ 10/29/1999  5:24 PM ]
 ;
 ;  this is queued to go check the patient data and see if anything
 ;  needs to be sent to sql  
 ;
 ;  
 ;
ST ;
 ;
 ;
 S %DT="R",X="NOW" D ^%DT
 S $P(^DBTSPAT("CHK FOR DATA"),"^",1)=Y
 S DBTSP=0
 F  S DBTSP=$O(^DBTSPAT(DBTSP)) Q:+DBTSP=0  D START
 S %DT="R",X="NOW" D ^%DT
 S $P(^DBTSPAT("CHK FOR DATA"),"^",2)=Y
 K DBTS,DBTSP,ARRAY
 Q
 ;
START ;
 K DBTSNEW
 S ARRAY=0
 ;S DBTSP=13051  ;uncomment if want to test with call to TEST directly
 ;S DBTSP=17897   ;crow demo patient dfn for testing
 ;
 D ^XBKVAR
 I DUZ(2)=4526 S DUZ(2)=2348
 S DBTS("LOC")=$P($G(^AUTTLOC(DUZ(2),0)),"^",10)
 I DBTS("LOC")="" S DBTSRET(1)="-1" Q
 S DBTS("ID")=DBTS("LOC")_"|1419200BEG|"_DBTSP
 ;
 ;
 ;K DBTS("NEWPAT")
 ;I '$D(^DBTSPAT(DBTSP)) S DBTS("NEWPAT")="Y" D  G SET
 ;.K ^DBTSPAT("B",DBTSP)
 ;.S X=DBTSP,DINUM=X,DIC(0)="XNL",DIC="^DBTSPAT(" D FILE^DICN
 ;.S DBTSNEW="Y"
 ;.Q
 ;
 ;  put the patient log information to a temporary holding
 ;I '$D(^DBTSPAT(DBTSP)) S DBTSRET(1)="-1" Q
 ;S NODE=""
 ;F  S NODE=$O(^DBTSPAT(DBTSP,NODE)) Q:NODE=""  D
 ;.S ^DBTS("TMP",DBTSP,NODE)=^DBTSPAT(DBTSP,NODE)
 ;.Q
 ;S ^DBTS("TMP",DBTSP,"ZZSAVEDON")=DT
SET ;
 I '$D(^DBTSPAT(DBTSP)) S DBTSRET(1)="-1" Q
 E  S DBTSRET(1)=""
 ;E  S DBTSRET(1)=DBTS("ID")_U_DBTS("LOC")_U_DBTSP_U_"BEGIN"
 ;Q:$D(DBTSNEW)
 F ENT=1:1:6 K DBTSAU D ^DBTSB1 D APPEND
 F ENT=7:1:12 K DBTSAU D ^DBTSB2 D APPEND
 F ENT=13:1:17 K DBTSAU D ^DBTSB3 D APPEND
 S %DT="R",X="NOW" D ^%DT
 S DTTIME=Y
 S DBTSRET(1)=$TR(DBTSRET(1),"^","|")
 S $P(^DBTSPAT(DBTSP,"A"),"^",1)=DTTIME
 S $P(^DBTSPAT(DBTSP,"A"),"^",2)=DBTSRET(1)
 Q
1 ;    chk for demographic chgs or adds
 I $P($G(^DBTSPAT(DBTSP,0)),"^",2)="" S DBTSAU=1 D APPEND Q
 S DBTS("LM")=$P(^AUPNPAT(DBTSP,0),U,3)
 S DBTS("LDT")=$P($G(^DBTSPAT(DBTSP,0)),U,2)
 I (DBTS("LDT")>(DBTS("LM"))) S DBTSAU=0
 E  S DBTSAU=1 
 D APPEND
 Q
2 ;    chk for meas. chgs. or adds
 F X="BP","HT","WT" D 
 .S REC=$G(^DBTSPAT(DBTSP,X))
 .S LDFN=$P(REC,U,1),LDT=$P(REC,U,2)
 .I '$D(DBTS("LDFN")) S DBTS("LDFN")=LDFN
 .I '$D(DBTS("LDT")) S DBTS("LDT")=LDT
 .I LDT>(DBTS("LDT")) S DBTS("LDT")=LDT
 .I LDFN>(DBTS("LDFN")) S DBTS("LDFN")=LDFN
 S DBTSAU=0
 S N=0
 F  S N=$O(^AUPNVMSR("AC",DBTSP,N)) Q:+N=0  D  I DBTSAU=1 Q
 .I N>(DBTS("LDFN")) S DBTSAU=1 Q
 .S DV=$P($G(^AUPNVMSR(N,0)),U,3)
 .S DBTS("MODDT")=$P($G(^AUPNVSIT(DV,0)),U,13)
 .I DBTS("LDT")'>(DBTS("MODDT")) S DBTSAU=1
 .Q
 D APPEND
 Q
3 ;    chk for immunizations chgs or adds
 S REC=$G(^DBTSPAT(DBTSP,"IMM"))
 S DBTS("LDFN")=$P(REC,U,1),DBTS("LDT")=$P(REC,U,2)
 S DBTSAU=0
 S N=0
 F  S N=$O(^AUPNVIMM("AC",DBTSP,N)) Q:+N=0  D  I DBTSAU=1 Q
 .I N>(DBTS("LDFN")) S DBTSAU=1 Q
 .S DV=$P($G(^AUPNVIMM(N,0)),U,3)
 .S DBTS("MODDT")=$P($G(^AUPNVSIT(DV,0)),U,13)
 .I DBTS("LDT")'>(DBTS("MODDT")) S DBTSAU=1
 .Q
 D APPEND
 Q
4 ;    chk for ppd chgs or adds
 S DBTSAU=0
 S PPD=$O(^AUTTSK("B","PPD",0))
 I PPD="" D APPEND Q
 S REC=$G(^DBTSPAT(DBTSP,"PPD"))
 S DBTS("LDFN")=$P(REC,U,1),DBTS("LDT")=$P(REC,U,2)
 S N=0
 F  S N=$O(^AUPNVSK("AC",DBTSP,N)) Q:+N=0  D  I DBTSAU=1 Q
 .S SKIN=$G(^AUPNVSK(N,0))
 .S DBTS("PPD")=$P(SKIN,U,1)
 .Q:DBTS("PPD")'=PPD
 .I N>(DBTS("LDFN")) S DBTSAU=1 Q
 .S DV=$P($G(^AUPNVSK(N,0)),U,3)
 .S DBTS("MODDT")=$P($G(^AUPNVSIT(DV,0)),U,13)
 .I DBTS("LDT")'>(DBTS("MODDT")) S DBTSAU=1
 .Q
 D APPEND
 Q
5 ;    chk for breast exam chgs or adds
 S REC=$G(^DBTSPAT(DBTSP,"BRE"))
 S DBTS("LDFN")=$P(REC,U,1),DBTS("LDT")=$P(REC,U,2)
 S DBTSAU=0
 S N=0
 F  S N=$O(^AUPNVXAM("AC",DBTSP,N)) Q:+N=0  D  I DBTSAU=1 Q
 .S EXAM=$G(^AUPNVXAM(N,0))
 .S CODE=$P(EXAM,U,1)
 .I CODE="" Q
 .S CODE=$P($G(^AUTTEXAM(EXAM,0)),U,2)
 .Q:CODE'="06"
 .I N>(DBTS("LDFN")) S DBTSAU=1 Q
 .S DV=$P($G(^AUPNVXAM(N,0)),U,3)
 .S DBTS("MODDT")=$P($G(^AUPNVSIT(DV,0)),U,13)
 .I DBTS("LDT")'>(DBTS("MODDT")) S DBTSAU=1
 .Q
 D APPEND
 Q
6 ;    chk for dental chgs or adds
 Q
7 ;    patient education chgs or adds
 Q
8 ;    eye exam chgs or adds
 Q
9 ;    amputation chgs or adds
 Q
10 ;    foot check chgs or adds
 Q
11 ;    foot exam  chgs or adds
 Q
12 ;    pelvic exam chgs or adds
 Q
13 ;    rectal exam chgs or adds
 Q
14 ;    cardiac chgs or adds
 Q
15 ;    ekg chgs or adds
 Q
16 ;    medications chgs or adds
 Q
17 ;    labs chgs or adds
 Q
APPEND ;
 S DBTSRET(1)=DBTSRET(1)_DBTSAU_U
 Q
