DBTSPROB ;BAO/DMH  pull patient  PROBLEMS [ 11/09/1999  5:36 PM ]
 ;
 ;
 ;
START ;
 ;
PROB(DBTSGBL,DBTSP)          ;dbtsret is return value, dbtsp input value of patient ien
 ;
 ;
TEST ;
 K ^DBTSTEMP(1)
 S DBTSGBL="^DBTSTEMP("_1_")"
 S ARRAY=0
 ;S DBTSP=7884    ;for testing
 ;
 D ^XBKVAR
 I DUZ(2)=4526 S DUZ(2)=2348
 S DBTS("LOC")=$P($G(^AUTTLOC(DUZ(2),0)),"^",10)
 I DBTS("LOC")="" S DBTSRET(1)="-1" S ^DBTSTEMP(1,1)="-1"_$C(13)_$C(10) Q
 S DBTS("FN")="9000011"   
 ;                           ;   for all diag now 10-7-99  dmh
 S DBTS("IEN")=0
EX ;
 S DTCT=0   ;comment out when go with live data
 B  
 F I=1:1 S DBTS("IEN")=$O(^AUPNPROB("AC",DBTSP,DBTS("IEN"))) Q:+DBTS("IEN")=0  D  
 .S REC=$G(^AUPNPROB(DBTS("IEN"),0))
 .Q:REC=""
 .I $P(REC,"^",2)'=DBTSP Q        ;dmh added 10-27-99
 .S DBTS("POV")=$P(REC,"^",1)
 .Q:DBTS("POV")=""
 .S DBTS("ICD")=$P($G(^ICD9(DBTS("POV"),0)),"^",1)
 .Q:DBTS("ICD")=""
 .S DBTS("MODDT")=$P(REC,U,3)
 .S DBTS("DT")=DBTS("MODDT")
 .D DTCHK^DBTSUT
 .Q:$D(DBTS("BADDT"))
 .D MODCK
 .Q:DBTS("OK")="N"
 .S DBTS("MODDT")=$E(DBTS("MODDT"),4,5)_"/"_$E(DBTS("MODDT"),6,7)_"/"_($E(DBTS("MODDT"),1,3)+1700)
 .S DBTS("PAT")=DBTSP
 .S DBTS("CLS")=$P(REC,"^",4)
 .I DBTS("CLS")="" S DBTS("CLS")="U"
 .S DBTS("PNAR")=$P(REC,"^",5)
 .Q:DBTS("PNAR")=""
 .D NARR
 .Q:DBTS("PNAR")=""
 .S DBTS("FAC")=$P(REC,"^",6)
 .S DBTS("FAC")=$P($G(^AUTTLOC(+DBTS("FAC"),0)),"^",10)
 .Q:DBTS("FAC")'?6N
 .S DBTS("NMB")=$P(REC,"^",7)
 .Q:+DBTS("NMB")=0
 .S DBTS("DE")=$P(REC,"^",8)
 .S DBTS("DT")=DBTS("DE")
 .D DTCHK^DBTSUT
 .Q:$D(DBTS("BADDT"))
 .S DBTS("DE")=$E(DBTS("DE"),4,5)_"/"_$E(DBTS("DE"),6,7)_"/"_($E(DBTS("DE"),1,3)+1700)
 .S DBTS("S")=$P(REC,"^",12)
 .S DBTS("DO")=$P(REC,"^",13)
 .S DBTS("DT")=DBTS("DO")
 .D DTCHK^DBTSUT
 .I $D(DBTS("BADDT")) S DBTS("DO")=""
 .I '$D(DBTS("BADDT")) S DBTS("DO")=$E(DBTS("DO"),4,5)_"/"_$E(DBTS("DO"),6,7)_"/"_($E(DBTS("DO"),1,3)+1700)
 .S DBTS("ID")=DBTS("LOC")_"|"_DBTS("FN")_"|"_DBTS("IEN")
 .S ARRAY=ARRAY+1
 .S OUTREC=DBTS("ID")_U_DBTS("LOC")_U_DBTS("AU")_U_DBTS("PAT")_U_"PROBLEM"_U_DBTS("ICD")_U_DBTS("MODDT")_U_DBTS("CLS")_U
 .S OUTREC=OUTREC_DBTS("PNAR")_U_DBTS("FAC")_U_DBTS("NMB")_U_DBTS("DE")_U_DBTS("S")_U
 .S OUTREC=OUTREC_DBTS("DO")_$C(13)_$C(10)
 .S ^DBTSTEMP(1,ARRAY)=OUTREC
 .D LOG
 .Q
 I ARRAY=0 S ^DBTSTEMP(1,1)="-2"_$C(13)_$C(10)
 I $D(^DBTSPAT(DBTSP,"PROB")) S $P(^DBTSPAT(DBTSP,"PROB"),"^",2)=DT
 Q
MODCK ;
 S DBTS("OK")="A"
 S DBTS("AU")="A"
 ;Q                         ;for testing
 Q:'$D(^DBTSPAT(DBTSP,"PROB"))
 S DBTS("MREC")=$G(^DBTSPAT(DBTSP,"PROB"))
 Q:DBTS("MREC")=""
 S DBTS("LDFN")=$P(DBTS("MREC"),U,1)
 I $P(DBTS("MREC"),"^",2)="" Q
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
 I '$D(^DBTSPAT(DBTSP,"PROB")) S ^DBTSPAT(DBTSP,"PROB")=DBTS("IEN")_"^" Q
 I $G(DBTS("LDFN"))<DBTS("IEN") S $P(^DBTSPAT(DBTSP,"PROB"),"^",1)=DBTS("IEN")
 Q
NARR ;  loop thru all povs for the visit dfn and pull the prov. narr.
 ;   3/24/99
 S NARR=$P($G(^AUTNPOV(+DBTS("PNAR"),0)),"^",1)
 I NARR'="" D NARR^DBTSUT
 S DBTS("PNAR")=NARR
 Q
