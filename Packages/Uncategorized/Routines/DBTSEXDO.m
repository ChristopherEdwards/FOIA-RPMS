DBTSEXDE ;BAO/DMH  pull patient DENTAL exams [ 02/11/1999  11:37 AM ]
 ;
 ;
 ;
START ;
 ;
EXAM(DBTSRET,DBTSP)          ;dbtsret is return value, dbtsp input value of patient ien
 ;
 ;
TEST ;
 S ARRAY=0
 ;S DBTSP=13051
 ;
 D ^XBKVAR
 I DUZ(2)=4526 S DUZ(2)=2348
 S DBTS("LOC")=$P($G(^AUTTLOC(DUZ(2),0)),"^",10)
 I DBTS("LOC")="" S DBTSRET(1)="-1" Q
 S DBTS("FN")="9002007"
 S DBTS("IEN")=0
EX ;
 S DTCT=0   ;comment out when go with live data
 F I=1:1 S DBTS("IEN")=$O(^ADEPCD("B",DBTSP,DBTS("IEN"))) Q:+DBTS("IEN")=0  D
 .S REC=$G(^ADEPCD(DBTS("IEN"),0))
 .Q:REC=""
 .S DBTS("VDATE")=$P(REC,U,2)
 .Q:DBTS("VDATE")=""
 .S DBTS("V")=$P(DBTS("VDATE"),".",1)
 .Q:DBTS("V")=""
 .S DBTS("DT")=DBTS("V")
 .D DTCHK^DBTSUT
 .Q:$D(DBTS("BADDT"))
 .S DBTS("VDATE")=$E(DBTS("V"),4,5)_"/"_$E(DBTS("V"),6,7)_"/"_($E(DBTS("V"),1,3)+1700)
 .;
 .;
 .;
 .S DBTS("PAT")=DBTSP
 .S DBTS("CN")=$P($G(^AUPNPAT(DBTSP,41,DUZ(2),0)),"^",2)
 .S DBTS("ID")=DBTS("LOC")_"|"_DBTS("FN")_"|"_DBTS("IEN")
 .D MODCK
 .Q:DBTS("OK")="N"
 .S ARRAY=ARRAY+1
 .S DBTSRET(ARRAY)=DBTS("ID")_U_DBTS("LOC")_U_DBTS("AU")_U_DBTS("PAT")_U_"DENTAL EXAM"_U_99_U_DBTS("VDATE")
 .D LOG
 .Q
 I ARRAY=0 S DBTSRET(1)="-2"
 S $P(^DBTSPAT(DBTSP,"DEN"),"^",2)=DT
 Q
MODCK ;
 S DBTS("OK")="Y"
 S DBTS("AU")="A"
 Q:'$D(^DBTSPAT(DBTSP,"DEN"))
 I $P(^DBTSPAT(DBTSP,"DEN"),"^",2)="" Q
 S DBTS("VDFN")=$P($G(^ADEPCD(DBTS("IEN"),"PCC")),"^",1)
 I DBTS("VDFN")'="" D
 .S DBTS("MODDT")=$P($G(^AUPNVSIT(DBTS("VDFN"),0)),U,13)
 E  S DBTS("MODDT")="2990202"
 S DBTS("MREC")=$G(^DBTSPAT(DBTSP,"DEN"))
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
 I '$D(^DBTSPAT(DBTSP,"DEN")) S ^DBTSPAT(DBTSP,"DEN")=DBTS("IEN")_"^" Q
 I $G(DBTS("LDFN"))<DBTS("IEN") S $P(^DBTSPAT(DBTSP,"DEN"),"^",1)=DBTS("IEN")
 Q
