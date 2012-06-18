DBTSFH ;BAO/DMH  pull patient FAMILY HISTORY  [ 02/11/1999  11:45 AM ]
 ;
 ;
 ;
START ;
 ;
FH(DBTSRET,DBTSP)          ;dbtsret is return value, dbtsp input value of patient ien
 ;
 ;
TEST ;
 S ARRAY=0
 ;S DBTSP=13051     ;uncomment if want to test with call to TEST directly
 ;
 D ^XBKVAR
 I DUZ(2)=4526 S DUZ(2)=2348
 S DBTS("LOC")=$P($G(^AUTTLOC(DUZ(2),0)),"^",10)
 I DBTS("LOC")="" S DBTSRET(1)="-1" Q
 S DBTS("FN")="9000014"
 S DBTS("IEN")=0
MEAS ;
 F I=1:1 S DBTS("IEN")=$O(^AUPNFH("AC",DBTSP,DBTS("IEN"))) Q:+DBTS("IEN")=0  D
 .S REC=$G(^AUPNFH(DBTS("IEN"),0))
 .Q:REC=""
 .S DBTS("ICDPT")=$P(REC,U,1)
 .I DBTS("ICDPT")="" Q
 .S DBTS("CODE")=$P($G(^ICD9(DBTS("ICDPT"),0)),U,1)
 .S DBTS("DESC")=$P($G(^ICD9(DBTS("ICDPT"),0)),U,3)
 .S DBTS("DT")=$P(REC,U,3)
 .I DBTS("DT")'="" D
 ..D DTCHK^DBTSUT 
 .I $D(DBTS("BADDT")) Q
 .I DBTS("DT")'="" S DBTS("DT")=$E(DBTS("DT"),4,5)_"/"_$E(DBTS("DT"),6,7)_"/"_($E(DBTS("DT"),1,3)+1700)
 .S DBTS("PRVN")=$P(REC,U,4)
 .I DBTS("PRVN")'="" S DBTS("PRVN")=$P($G(^AUTNPOV(DBTS("PRVN"),0)),"^",1)
 .;
 .;
 .;
 .S DBTS("PAT")=DBTSP
 .S DBTS("CN")=$P($G(^AUPNPAT(DBTSP,41,DUZ(2),0)),"^",2)
 .S DBTS("ID")=DBTS("LOC")_"|"_DBTS("FN")_"|"_DBTS("IEN")
 .D MODCK
 .Q:DBTS("OK")="N"
 .S ARRAY=ARRAY+1
 .S DBTSRET(ARRAY)=DBTS("ID")_U_DBTS("LOC")_U_DBTS("AU")_U_DBTS("PAT")_U_"FAMILY HISTORY"_U_DBTS("CODE")_U_DBTS("DESC")_U_DBTS("DT")_U_DBTS("PRVN")
 .D LOG
 .Q
 I ARRAY=0 S DBTSRET(1)="-2"
 S $P(^DBTSPAT(DBTSP,"FAM"),"^",2)=DT
 Q
MODCK ;
 S DBTS("OK")="Y"
 S DBTS("AU")="A"
 Q:'$D(^DBTSPAT(DBTSP,"FAM"))
 I $P(^DBTSPAT(DBTSP,"FAM"),"^",2)="" Q
 S DBTS("MREC")=$G(^DBTSPAT(DBTSP,"FAM"))
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
 I '$D(^DBTSPAT(DBTSP,"FAM")) S ^DBTSPAT(DBTSP,"FAM")=DBTS("IEN")_"^" Q
 I $G(DBTS("LDFN"))<DBTS("IEN") S $P(^DBTSPAT(DBTSP,"FAM"),"^",1)=DBTS("IEN")
 Q
