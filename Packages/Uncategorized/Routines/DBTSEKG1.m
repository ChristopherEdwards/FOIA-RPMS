DBTSEKG ;BAO/DMH  pull patient EKG dates [ 11/16/1999  5:51 PM ]
 ;
 ;
 ;
START ;
 ;
EKG(DBTSRET,DBTSP)          ;dbtsret is return value, dbtsp input value of patient ien
 ;
 ;
TEST ;
 S ARRAY=0
 ;S DBTSP=29
 ;
 D ^XBKVAR
 I DUZ(2)=4526 S DUZ(2)=2348
 S DBTS("LOC")=$P($G(^AUTTLOC(DUZ(2),0)),"^",10)
 I DBTS("LOC")="" S DBTSRET(1)="-1" Q
 S DBTS("FN")="9000010.08"
 S DBTS("IEN")=0
 I '$D(^DBTSEXDI("B","EKG")) S DBTSRET(1)="-2"   ;may want to chg.
EX ;
 S DTCT=0   ;comment out when go with live data
 B  
 F I=1:1 S DBTS("IEN")=$O(^AUPNVPRC("AC",DBTSP,DBTS("IEN"))) Q:+DBTS("IEN")=0  D
 .S REC=$G(^AUPNVPRC(DBTS("IEN"),0))
 .Q:REC=""
 .S DBTS("PRC")=$P(REC,"^",1)
 .D EKGCK Q:DBTS("CFL")="N"
 .S DBTS("PROC")=$P($G(^ICD0(DBTS("PRC"),0)),"^",1)
 .Q:DBTS("PROC")=""
 .S DBTS("PROCNAME")=$P($G(^ICD0(DBTS("PRC"),0)),"^",4)
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
 .D MODCK
 .Q:DBTS("OK")="N"
 .D NARR
 .I '$D(DBTS("PNAR")) S DBTS("PNAR")=""
 .S ARRAY=ARRAY+1
 .S DBTSRET(ARRAY)=DBTS("ID")_U_DBTS("LOC")_U_DBTS("AU")_U_DBTS("PAT")_U_"EKG"_U_DBTS("PROC")_U_DBTS("PROCNAME")_U_DBTS("VDATE")_U_DBTS("PNAR")
 .D LOG
 .Q
 I ARRAY=0 S DBTSRET(1)="-2"
 S $P(^DBTSPAT(DBTSP,"EKG"),"^",2)=DT
 Q
EKGCK ;
 S DBTS("CFL")="N"
 S DBTS("EKG")=$O(^DBTSEXDI("B","EKG",0))
 I $D(^DBTSEXDI(DBTS("EKG"),21,"B",DBTS("PRC"))) S DBTS("CFL")="Y"
 Q
MODCK ;
 S DBTS("OK")="Y"
 S DBTS("AU")="A"
 ;Q         ;for testing
 Q:'$D(^DBTSPAT(DBTSP,"EKG"))
 I $P(^DBTSPAT(DBTSP,"EKG"),"^",2)="" Q
 S DBTS("MREC")=$G(^DBTSPAT(DBTSP,"EKG"))
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
 I '$D(^DBTSPAT(DBTSP,"EKG")) S ^DBTSPAT(DBTSP,"EKG")=DBTS("IEN")_"^" Q
 I $G(DBTS("LDFN"))<DBTS("IEN") S $P(^DBTSPAT(DBTSP,"EKG"),"^",1)=DBTS("IEN")
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
