DBTSLLIP ;BAO/DMH  pull patient LAB TESTS FOR LIPIDS  [ 01/12/1999  5:02 PM ]
 ;    (LDL, HDL, TOTAL CHOLESTORAL, AND TRIGLYCERIDE)
 ;
 ;
 ;
START ;
 ;
LIP(DBTSRET,DBTSP)          ;dbtsret is return value, dbtsp input value of patient ien
 ;
 ;
TEST ;
 S ARRAY=0
 S DBTSP=13052    ;uncomment if want to test with call to TEST directly
 ;
 D ^XBKVAR
 I DUZ(2)=4526 S DUZ(2)=2348
 S DBTS("LOC")=$P(^AUTTLOC(DUZ(2),0),"^",10)
 S DBTS("FN")="9000010.09L"
 S DBTS("IEN")=0
 ;
 ;
 I '$D(^DBTSLAB(DUZ(2))) S DBTSRET(1)="-1" Q
 I '$D(^DBTSLABI) S DBTSRET(1)="-1" Q
 ;
 F I=1:1 S DBTS("IEN")=$O(^AUPNVLAB("AC",DBTSP,DBTS("IEN"))) Q:+DBTS("IEN")=0  D
 .S REC=$G(^AUPNVLAB(DBTS("IEN"),0))
 .Q:REC=""
 .S DBTS("LAB")=$P(REC,U,1)
 .I DBTS("LAB")="" Q
 .S DBTS("RESULTS")=$P(REC,U,4)
 .Q:DBTS("RESULTS")=""
 .;S DBTS("LABTESTP")=$P(DBTS("LAB"),U,1)
 .D LABCK
 .Q:'$D(DBTS("LABID"))
 .S DBTS("V")=$P(REC,U,3)
 .S DBTS("VDATE")=$P($G(^AUPNVSIT(DBTS("V"),0)),U,1)
 .S DBTS("MODDT")=$P($G(^AUPNVSIT(DBTS("V"),0)),U,13)
 .Q:DBTS("VDATE")=""
 .S DBTS("VDATE")=$P(DBTS("VDATE"),".",1)
 .S DBTS("VD")=$E(DBTS("VDATE"),4,5)_"/"_$E(DBTS("VDATE"),6,7)_"/"_($E(DBTS("VDATE"),1,3)+1700)
 .S DBTS("RESULTS")=$P(REC,U,4)
 .D MODCK
 .Q:DBTS("OK")="N"
 .;
 .;
 .;
 .I '$D(DBTS("AU")) S DBTS("AU")="A"
 .S DBTS("PAT")=DBTSP
 .S DBTS("CN")=$P(^AUPNPAT(DBTSP,41,DUZ(2),0),"^",2)
 .S ARRAY=ARRAY+1
 .S DBTS("ID")=DBTS("LOC")_"|"_DBTS("FN")_"|"_DBTS("IEN")
 .S DBTSRET(ARRAY)=DBTS("ID")_U_DBTS("LOC")_U_DBTS("AU")_U_DBTS("PAT")_U_"LAB-LIPIDS"_U_DBTS("LABID")_U_DBTS("VD")_U_DBTS("RESULTS")
 .D LOG
 .Q
 I ARRAY=0 S DBTSRET(1)="-2"
 F NODE="LDL","HDL","TRI" S $P(^DBTSPAT(DBTSP,NODE),"^",2)=DT
 Q
LABCK ;
 K DBTS("LABID")
 I '$D(^DBTSLAB(DUZ(2),11,"B",DBTS("LAB"))) Q
 S DBTS("N")=$O(^DBTSLAB(DUZ(2),11,"B",DBTS("LAB"),0))
 Q:DBTS("N")=""
 ;
 ;    check to see if the lab test is coded to "L" type for Lipids
 ;
 S DBTS("LABREC")=$G(^DBTSLAB(DUZ(2),11,DBTS("N"),0))
 Q:DBTS("LABREC")=""
 I $P(DBTS("LABREC"),U,2)'="L" Q
 S NODE=$P(DBTS("LABREC"),U,4)
 ;
 ;
 S DBTS("LABID")=$P(DBTS("LABREC"),U,3)
 I DBTS("LABID")="" K DBTS("LABID")
 Q
MODCK ;
 S DBTS("OK")="Y"
 S DBTS("AU")="A"
 Q:'$D(^DBTSPAT(DBTSP,NODE))
 S DBTS("MREC")=$G(^DBTSPAT(DBTSP,NODE))
 Q:DBTS("MREC")=""
 S DBTS("LDFN")=$P(DBTS("MREC"),U,1)
 Q:+DBTS("LDFN")<DBTS("IEN")
 S DBTS("LDT")=$P(DBTS("MREC"),U,2)
 I (+DBTS("LDT")>DBTS("MODDT")),(DBTS("LDFN")>DBTS("IEN")) S DBTS("OK")="N" Q
 I (DBTS("LDT")<DBTS("MODDT")) S DBTS("AU")="U" Q
 S DBTS("OK")="N" Q
 Q
LOG ;  update the patient log for the type of lab test
 I '$D(DT) D ^XBKVAR 
 I '$D(^DBTSPAT(DBTSP,NODE)) S ^DBTSPAT(DBTSP,NODE)=DBTS("IEN")_"^" Q
 I $G(DBTS("LDFN"))<DBTS("IEN") S $P(^DBTSPAT(DBTSP,NODE),"^",1)=DBTS("IEN")
 Q
