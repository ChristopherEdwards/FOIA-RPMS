DBTSPED ;BAO/DMH  pull patient PATIENT EDUTCATION  [ 11/16/1999  9:02 PM ]
 ;
 ;
 ;
START ;
 ;
PED(DBTSGBL,DBTSP)          ;dbtsret is return value, dbtsp input value of patient ien
 ;
 ;
TEST ;
 K ^DBTSTEMP(1)
 S DBTSGBL="^DBTSTEMP("_1_")"
 S ARRAY=0
 ;S DBTSP=13051     ;uncomment if want to test with call to TEST directly
 ;
 D ^XBKVAR
 I DUZ(2)=4526 S DUZ(2)=2348
 S DBTS("LOC")=$P($G(^AUTTLOC(DUZ(2),0)),"^",10)
 I DBTS("LOC")="" S DBTSRET(1)="-1" S ^DBTSTEMP(1,1)="-1"_$C(13)_$C(10) Q
 S DBTS("FN")="9000010.16"
 S DBTS("IEN")=0
MEAS ;
 F I=1:1 S DBTS("IEN")=$O(^AUPNVPED("AC",DBTSP,DBTS("IEN"))) Q:+DBTS("IEN")=0  D
 .S REC=$G(^AUPNVPED(DBTS("IEN"),0))
 .Q:REC=""
 .S DBTS("EDTPTR")=$P(REC,U,1)
 .I DBTS("EDTPTR")="" Q
 .S DBTS("EDNAME")=$P($G(^AUTTEDT(DBTS("EDTPTR"),0)),U,1)
 .S DBTS("EDMN")=$P($G(^AUTTEDT(DBTS("EDTPTR"),0)),U,2)
 .Q:DBTS("EDMN")'["DM-"
 .S DBTS("VDFN")=$P(REC,U,3)
 .S DBTS("MODDT")=$P($G(^AUPNVSIT(DBTS("VDFN"),0)),U,13)
 .S DBTS("VDATE")=$P($G(^AUPNVSIT(DBTS("VDFN"),0)),U,1)
 .Q:DBTS("VDATE")=""
 .S DBTS("V")=$P(DBTS("VDATE"),".",1)
 .Q:DBTS("V")=""
 .S DBTS("DT")=DBTS("V")
 .D DTCHK^DBTSUT
 .Q:$D(DBTS("BADDT"))
 .S DBTS("VDATE")=$E(DBTS("V"),4,5)_"/"_$E(DBTS("V"),6,7)_"/"_($E(DBTS("V"),1,3)+1700)
 .S DBTS("LEV")=$P(REC,U,6)
 .I DBTS("LEV")="" S DBTS("LEV")=4
 .;
 .;
 .;
 .S DBTS("PAT")=DBTSP
 .S DBTS("CN")=$P($G(^AUPNPAT(DBTSP,41,DUZ(2),0)),"^",2)
 .S DBTS("ID")=DBTS("LOC")_"|"_DBTS("FN")_"|"_DBTS("IEN")
 .S DBTS("VID")=DBTS("LOC")_"|9000010|"_DBTS("VDFN")  ;dmh 11-10-99
 .D MODCK
 .Q:DBTS("OK")="N"
 .S ARRAY=ARRAY+1
 .S ^DBTSTEMP(1,ARRAY)=DBTS("ID")_U_DBTS("LOC")_U_DBTS("AU")_U_DBTS("PAT")_U_"EDUCATION"_U_DBTS("EDMN")_U_DBTS("EDNAME")_U_DBTS("VDATE")_U_DBTS("LEV")_U_DBTS("VID")_$C(13)_$C(10)
 .D LOG
 .Q
 I ARRAY=0 S DBTSRET(1)="-2" S ^DBTSTEMP(1,1)="-2"_$C(13)_$C(10)
 I $D(^DBTSPAT(DBTSP,"EDU")) S $P(^DBTSPAT(DBTSP,"EDU"),"^",2)=DT
 Q
MODCK ;
 S DBTS("OK")="Y"
 S DBTS("AU")="A"
 Q:'$D(^DBTSPAT(DBTSP,"EDU"))
 ;I $P(^DBTSPAT(DBTSP,"EDU"),"^",2)="" Q   ;11-16-99
 S DBTS("MREC")=$G(^DBTSPAT(DBTSP,"EDU"))
 Q:DBTS("MREC")=""
 S DBTS("LDFN")=$P(DBTS("MREC"),U,1)
 I $P(^DBTSPAT(DBTSP,"EDU"),"^",2)="" Q  ;11-16-99
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
 I '$D(^DBTSPAT(DBTSP,"EDU")) S ^DBTSPAT(DBTSP,"EDU")=DBTS("IEN")_"^" Q
 I $G(DBTS("LDFN"))<DBTS("IEN") S $P(^DBTSPAT(DBTSP,"EDU"),"^",1)=DBTS("IEN")
 Q
