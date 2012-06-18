DBTSVIMM ;BAO/DMH  pull patient IMMUNIZTIONS  [ 04/11/1999  10:43 PM ]
 ;
 ;
 ;
START ;
 ;
IMM(DBTSRET,DBTSP)          ;dbtsret is return value, dbtsp input value of patient ien
 ;
 ;
TEST ;
 S ARRAY=0
 ;S DBTSP=299     ;uncomment if want to test with call to TEST directly
 S DBTSRET(1)="-1"
 ;
 D ^XBKVAR
 I DUZ(2)=4526 S DUZ(2)=2348
 S DBTS("LOC")=$P($G(^AUTTLOC(DUZ(2),0)),"^",10)
 I DBTS("LOC")="" S DBTSRET(1)="-1" Q
 S DBTS("FN")="9000010.11"
 S DBTS("IEN")=0
MEAS ;
 F I=1:1 S DBTS("IEN")=$O(^AUPNVIMM("AC",DBTSP,DBTS("IEN"))) Q:+DBTS("IEN")=0  D
 .S REC=$G(^AUPNVIMM(DBTS("IEN"),0))
 .Q:REC=""
 .S DBTS("IMM")=$P(REC,U,1)
 .I DBTS("IMM")="" Q
 .S DBTS("TY")=$P($G(^AUTTIMM(DBTS("IMM"),0)),U,1)
 .Q:DBTS("TY")=""
 .S DBTS("CODE")=$P($G(^AUTTIMM(DBTS("IMM"),0)),U,3)
 .Q:DBTS("CODE")=""
 .S DBTS("VDFN")=$P(REC,U,3)
 .S DBTS("MODDT")=$P($G(^AUPNVSIT(DBTS("VDFN"),0)),U,13)
 .S DBTS("VDATE")=$P($G(^AUPNVSIT(DBTS("VDFN"),0)),U,1)
 .Q:DBTS("VDATE")=""
 .S DBTS("VDATE")=$P(DBTS("VDATE"),".",1)
 .S DBTS("VDATE")=$E(DBTS("VDATE"),4,5)_"/"_$E(DBTS("VDATE"),6,7)_"/"_($E(DBTS("VDATE"),1,3)+1700)
 .S DBTS("SRS")=$P(REC,U,4)
 .S DBTS("LOT")=$P(REC,U,5)
 .I DBTS("LOT")'="" S DBTS("LOT")=$P($G(^AUTTIML(DBTS("LOT"),0)),U,1)
 .;
 .;
 .;
 .S DBTS("PAT")=DBTSP
 .S DBTS("CN")=$P($G(^AUPNPAT(DBTSP,41,DUZ(2),0)),"^",2)
 .S DBTS("ID")=DBTS("LOC")_"|"_DBTS("FN")_"|"_DBTS("IEN")
 .D MODCK
 .Q:DBTS("OK")="N"
 .D NARR
 .I '$D(DBTS("PNAR")) S DBTS("PNAR")=""
 .S ARRAY=ARRAY+1
 .S DBTSRET(ARRAY)=DBTS("ID")_U_DBTS("LOC")_U_DBTS("AU")_U_DBTS("PAT")_U_DBTS("TY")_U_DBTS("CODE")_U_DBTS("VDATE")_U_DBTS("SRS")_U_DBTS("LOT")_U_DBTS("PNAR")
 .D LOG
 .Q
 I ARRAY=0 S DBTSRET(1)="-2"
 S $P(^DBTSPAT(DBTSP,"IMM"),"^",2)=DT
 Q
MODCK ;
 S DBTS("OK")="Y"
 S DBTS("AU")="A"
 ;Q        ;for testing only---comment out when no testing
 Q:'$D(^DBTSPAT(DBTSP,"IMM"))
 I $P(^DBTSPAT(DBTSP,"IMM"),"^",2)="" Q
 S DBTS("MREC")=$G(^DBTSPAT(DBTSP,"IMM"))
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
 I '$D(^DBTSPAT(DBTSP,"IMM")) S ^DBTSPAT(DBTSP,"IMM")=DBTS("IEN")_"^" Q
 I $G(DBTS("LDFN"))<DBTS("IEN") S $P(^DBTSPAT(DBTSP,"IMM"),"^",1)=DBTS("IEN")
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
