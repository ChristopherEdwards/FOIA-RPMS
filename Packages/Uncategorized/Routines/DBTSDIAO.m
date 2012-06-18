DBTSDIAG ;BAO/DMH  pull patient  DIAGNOSIS [ 10/09/1999  9:03 PM ]
 ;
 ;
 ;
START ;
 ;
DIAG(DBTSRET,DBTSP)          ;dbtsret is return value, dbtsp input value of patient ien
 ;
 ;
TEST ;
 S ARRAY=0
 ;S DBTSP=5128    ;for testing
 ;
 D ^XBKVAR
 I DUZ(2)=4526 S DUZ(2)=2348
 S DBTS("LOC")=$P($G(^AUTTLOC(DUZ(2),0)),"^",10)
 I DBTS("LOC")="" S DBTSRET(1)="-1" Q
 S DBTS("FN")="9000010.07"   ;put C on end for cardiac only--took off
 ;                           ;   for all diag now 10-7-99  dmh
 S DBTS("IEN")=0
EX ;
 S DTCT=0   ;comment out when go with live data
 B  
 F I=1:1 S DBTS("IEN")=$O(^AUPNVPOV("AC",DBTSP,DBTS("IEN"))) Q:+DBTS("IEN")=0  D  I ARRAY>200 Q
 .S REC=$G(^AUPNVPOV(DBTS("IEN"),0))
 .Q:REC=""
 .S DBTS("POV")=$P(REC,"^",1)
 .Q:DBTS("POV")=""
 .S DBTS("ICD")=$P($G(^ICD9(DBTS("POV"),0)),"^",1)
 .Q:DBTS("ICD")=""
 .;D CARDCK Q:DBTS("CFL")="N"
 .S DBTS("ICDNAME")=$P($G(^ICD9(DBTS("POV"),0)),"^",3)
 .S DBTS("VDFN")=$P(REC,U,3)
 .Q:DBTS("VDFN")=""
 .S DBTS("MODDT")=$P($G(^AUPNVSIT(DBTS("VDFN"),0)),U,13)
 .S DBTS("V")=$P($G(^AUPNVSIT(DBTS("VDFN"),0)),"^",1)
 .Q:DBTS("V")=""
 .S DBTS("V")=$P(DBTS("V"),".",1)
 .Q:DBTS("V")=""
 .S DBTS("DT")=DBTS("V")
 .D DTCHK^DBTSUT
 .Q:$D(DBTS("BADDT"))
 .S DBTS("VDATE")=$E(DBTS("V"),4,5)_"/"_$E(DBTS("V"),6,7)_"/"_($E(DBTS("V"),1,3)+1700)
 .S DBTS("PAT")=DBTSP
 .S DBTS("CN")=$P($G(^AUPNPAT(DBTSP,41,DUZ(2),0)),"^",2)
 .S DBTS("ID")=DBTS("LOC")_"|"_DBTS("FN")_"|"_DBTS("IEN")
 .S DBTS("VID")=DBTS("LOC")_"|9000010|"_DBTS("VDFN")
 .D MODCK
 .Q:DBTS("OK")="N"
 .D NARR
 .I '$D(DBTS("PNAR")) S DBTS("PNAR")=""
 .S ARRAY=ARRAY+1
 .Q:ARRAY>200
 .S DBTSRET(ARRAY)=DBTS("ID")_U_DBTS("LOC")_U_DBTS("AU")_U_DBTS("PAT")_U_"DIAGNOSIS"_U_DBTS("ICD")_U_DBTS("ICDNAME")_U_DBTS("VDATE")_U_DBTS("PNAR")_U_DBTS("VID")
 .D LOG
 .Q
 I ARRAY=0 S DBTSRET(1)="-2"
 S $P(^DBTSPAT(DBTSP,"ICD"),"^",2)=DT
 Q
CARDCK ;
 Q
 S DBTS("CFL")="N"
 S DBTS("CARD")=$O(^DBTSEXDI("B","CARDIAC",0))
 S DBTS=0
 F  S DBTS=$O(^DBTSEXDI(DBTS("CARD"),1,DBTS)) Q:+DBTS=0  D  Q:DBTS("CFL")="Y"
 .S RANGE=^DBTSEXDI(DBTS("CARD"),1,DBTS,0)
 .S ST=$P(RANGE,"^",1)
 .S END=$P(RANGE,"^",2)
 .I (DBTS("ICD")'<ST)&(DBTS("ICD")'>END) S DBTS("CFL")="Y"
 .Q
 Q
MODCK ;
 S DBTS("OK")="Y"
 S DBTS("AU")="A"
 ;Q                         ;for testing
 Q:'$D(^DBTSPAT(DBTSP,"ICD"))
 I $P(^DBTSPAT(DBTSP,"ICD"),"^",2)="" Q
 S DBTS("MREC")=$G(^DBTSPAT(DBTSP,"ICD"))
 Q:DBTS("MREC")=""
 S DBTS("LDFN")=$P(DBTS("MREC"),U,1)
 Q:+DBTS("LDFN")<DBTS("IEN")
 S DBTS("LDT")=$P(DBTS("MREC"),U,2)
 I (+DBTS("LDT")>DBTS("MODDT")),(DBTS("LDFN")>DBTS("IEN")) S DBTS("OK")="N" Q
 I (DBTS("LDT")'>DBTS("MODDT")) S DBTS("AU")="U" Q 
 S DBTS("OK")="N" Q
 Q
LOG ;  update the patient log for the type of lab test
 I '$D(DT) D ^XBKVAR 
 I '$D(^DBTSPAT(DBTSP)) D
 .K ^DBTSPAT("B",DBTSP)
 .S X=DBTSP,DINUM=X,DIC(0)="XNL",DIC="^DBTSPAT(" D FILE^DICN
 I '$D(^DBTSPAT(DBTSP,"ICD")) S ^DBTSPAT(DBTSP,"ICD")=DBTS("IEN")_"^" Q
 I $G(DBTS("LDFN"))<DBTS("IEN") S $P(^DBTSPAT(DBTSP,"ICD"),"^",1)=DBTS("IEN")
 Q
NARR ;  loop thru all povs for the visit dfn and pull the prov. narr.
 ;   3/24/99
 S DBTS("PNAR")=""
 S POV=0
 F  S POV=$O(^AUPNVPOV("AD",DBTS("VDFN"),POV)) Q:POV=""  D
 .I '$D(^AUPNVPOV(POV,0)) Q
 .S DBTS("PN")=$P(^AUPNVPOV(POV,0),U,4)
 .Q:+DBTS("PN")=0
 .Q:'$D(^AUTNPOV(DBTS("PN"),0))
 .S NARR=$P(^AUTNPOV(DBTS("PN"),0),U,1)
 .I NARR'="" D NARR^DBTSUT
 .I DBTS("PNAR")="" S DBTS("PNAR")=NARR
 .E  S DBTS("PNAR")=DBTS("PNAR")_"  "_NARR
 .Q
 ;S NARR=DBTS("PNAR") D NARR2^DBTSUT S DBTS("PNAR")=NARR
 Q
