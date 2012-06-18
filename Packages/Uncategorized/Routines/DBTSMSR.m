DBTSMSR ;BAO/DMH  pull patient MEASUREMENTS  [ 11/16/1999  9:52 PM ]
 ;
 ;    pulls the HT, WT and BP from V MEASUREMENT file
 ;
 ;
START ;
 ;
MSR(DBTSGBL,DBTSP)          ;dbtsret is return value, dbtsp input value of patient ien
 ;
 ;
TEST ;
 K ^DBTSTEMP(1)
 S DBTSGBL="^DBTSTEMP("_1_")"
 S ARRAY=0
 ;S DBTSP=12897
 ;
 D ^XBKVAR
 I DUZ(2)=4526 S DUZ(2)=2348
 S DBTS("LOC")=$P($G(^AUTTLOC(DUZ(2),0)),"^",10)
 I DBTS("LOC")="" S DBTSRET(1)="-1" S ^DBTSTEMP(1,1)="-1"_$C(13)_$C(10) Q
 S DBTS("FN")="9000010.01"
 S DBTS("IEN")=0
MEAS ;
 K ^DBTS("TMPMSR",DBTSP)
 F I=1:1 S DBTS("IEN")=$O(^AUPNVMSR("AC",DBTSP,DBTS("IEN"))) Q:+DBTS("IEN")=0  D
 .S REC=$G(^AUPNVMSR(DBTS("IEN"),0))
 .Q:REC=""
 .S DBTS("TY")=$P(REC,U,1)
 .I DBTS("TY")="" Q
 .S DBTS("TY")=$P($G(^AUTTMSR(DBTS("TY"),0)),U,1)
 .I (DBTS("TY")'="BP"),(DBTS("TY")'="HT"),(DBTS("TY")'="WT") Q
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
 .Q:$D(^DBTS("TMPMSR",DBTSP,DBTS("TY"),DBTS("VDATE")))
 .S DBTS("VAL")=$P(REC,U,4)
 .Q:+DBTS("VAL")=0     ;2/10/99 fixed HT was null
 .;
 .I (DBTS("TY")="BP"),(DBTS("VAL")'?.N1"/".N) Q   ;2/10/99 dmh added
 .;
 .;
 .S DBTS("PAT")=DBTSP
 .S DBTS("CN")=$P($G(^AUPNPAT(DBTSP,41,DUZ(2),0)),"^",2)
 .S DBTS("ID")=DBTS("LOC")_"|"_DBTS("FN")_"|"_DBTS("IEN")
 .S DBTS("VID")=DBTS("LOC")_"|9000010|"_DBTS("VDFN")  ;added 11-8-99 dmh
 .D MODCK
 .Q:DBTS("OK")="N"
 .S ^DBTS("TMPMSR",DBTSP,DBTS("TY"),DBTS("VDATE"))=""
 .S ARRAY=ARRAY+1
 .S DBTSRET(ARRAY)=DBTS("ID")_U_DBTS("LOC")_U_DBTS("AU")_U_DBTS("PAT")_U_DBTS("TY")_U_DBTS("VDATE")_U_DBTS("VAL")_U_DBTS("VID")
 .S ^DBTSTEMP(1,ARRAY)=DBTSRET(ARRAY)_$C(13)_$C(10)
 .D LOG 
 .Q
 I ARRAY=0 S DBTSRET(1)="-2" S ^DBTSTEMP(1,1)="-2"_$C(13)_$C(10)
 F ZZ="HT","WT","BP" I $D(^DBTSPAT(DBTSP,ZZ)) S $P(^DBTSPAT(DBTSP,ZZ),"^",2)=DT
 K ^DBTS("TMPMSR",DBTSP)
 Q
DOS ;
 S MO=$E(DOS,4,5)
 I MO>12 S MO=12
 S DA=$E(DOS,6,7)
 I DA>31 S DA=15
 S YR=$E(DOS,1,3) S YR=1700+YR
 S DBTS("DOS")=MO_"/"_DA_"/"_YR
 Q
MODCK ;
 S DBTS("OK")="Y"
 S DBTS("AU")="A"
 Q:'$D(^DBTSPAT(DBTSP,DBTS("TY")))
 ;I $P(^DBTSPAT(DBTSP,DBTS("TY")),"^",2)="" Q  ;11-16-99
 S DBTS("MREC")=$G(^DBTSPAT(DBTSP,DBTS("TY")))
 Q:DBTS("MREC")=""
 S DBTS("LDFN")=$P(DBTS("MREC"),U,1)
 I $P(^DBTSPAT(DBTSP,DBTS("TY")),"^",2)="" Q  ;11-16-99
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
 I '$D(^DBTSPAT(DBTSP,DBTS("TY"))) S ^DBTSPAT(DBTSP,DBTS("TY"))=DBTS("IEN")_"^" Q
 I $G(DBTS("LDFN"))<DBTS("IEN") S $P(^DBTSPAT(DBTSP,DBTS("TY")),"^",1)=DBTS("IEN")
 Q
