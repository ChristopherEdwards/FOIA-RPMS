DBTSPROC ;BAO/DMH  pull patient PROCEDURE dates [ 10/27/1999  5:59 PM ]
 ;
 ;
 ;
START ;
 ;
PROC(DBTSGBL,DBTSP)          ;dbtsret is return value, dbtsp input value of patient ien
 ;
 ;
TEST ;
 K ^DBTSTEMP(1)
 S DBTSGBL="^DBTSTEMP("_1_")"
 S ARRAY=0
 ;S DBTSP=9161
 ;
 D ^XBKVAR
 I DUZ(2)=4526 S DUZ(2)=2348
 S DBTS("LOC")=$P($G(^AUTTLOC(DUZ(2),0)),"^",10)
 I DBTS("LOC")="" S DBTSRET(1)="-1" S ^DBTSTMPE(1,1)="-1"_$C(13)_$C(10) Q
 S DBTS("FN")="9000010.08"
 S DBTS("IEN")=0
EX ;
 S DTCT=0   ;comment out when go with live data
 B  
 F I=1:1 S DBTS("IEN")=$O(^AUPNVPRC("AC",DBTSP,DBTS("IEN"))) Q:+DBTS("IEN")=0  D  ;I ARRAY>200 Q
 .S REC=$G(^AUPNVPRC(DBTS("IEN"),0))
 .Q:REC=""
 .I $P(REC,"^",2)'=DBTSP Q      ;dmh added 10-27-99
 .S DBTS("PRC")=$P(REC,"^",1)
 .D EKGCK Q:DBTS("CFL")="Y"
 .D AMPCK Q:DBTS("CFL")="Y"
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
 .S DBTS("VID")=DBTS("LOC")_"|9000010|"_DBTS("VDFN")
 .D MODCK
 .Q:DBTS("OK")="N"
 .;D NARR       ;dmh commented 10-26-99
 .;I '$D(DBTS("PNAR")) S DBTS("PNAR")=""  ;dmh commented out 10-26-99
 .S ARRAY=ARRAY+1
 .;Q:ARRAY>200
 .;S ^DBTSTEMP(1,ARRAY)=DBTS("ID")_U_DBTS("LOC")_U_DBTS("AU")_U_DBTS("PAT")_U_"PRC"_U_DBTS("PROC")_U_DBTS("PROCNAME")_U_DBTS("VDATE")_U_DBTS("PNAR")_U_DBTS("VID")_$C(13)_$C(10)
 .S ^DBTSTEMP(1,ARRAY)=DBTS("ID")_U_DBTS("LOC")_U_DBTS("AU")_U_DBTS("PAT")_U_"PRC"_U_DBTS("PROC")_U_DBTS("PROCNAME")_U_DBTS("VDATE")_U_DBTS("VID")_$C(13)_$C(10)
 .D LOG
 .Q
 I ARRAY=0 S DBTSRET(1)="-2" S ^DBTSTEMP(1,1)="-2"_$C(13)_$C(10)
 I $D(^DBTSPAT(DBTSP,"PRC")) S $P(^DBTSPAT(DBTSP,"PRC"),"^",2)=DT
 Q
EKGCK ;
 S DBTS("CFL")="N"
 S DBTS("EKG")=$O(^DBTSEXDI("B","EKG",0))
 I $D(^DBTSEXDI(DBTS("EKG"),21,"B",DBTS("PRC"))) S DBTS("CFL")="Y"
 Q
AMPCK ;
 S DBTS("CFL")="N"
 S DBTS("AMP")=$O(^DBTSEXDI("B","AMPUTATIONS",0))
 I $D(^DBTSEXDI(DBTS("AMP"),21,"B",DBTS("PRC"))) S DBTS("CFL")="Y"
 Q
MODCK ;
 S DBTS("OK")="Y"
 S DBTS("AU")="A"
 ;Q         ;for testing
 Q:'$D(^DBTSPAT(DBTSP,"PRC"))
 S DBTS("MREC")=$G(^DBTSPAT(DBTSP,"PRC"))
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
 I '$D(^DBTSPAT(DBTSP,"PRC")) S ^DBTSPAT(DBTSP,"PRC")=DBTS("IEN")_"^" Q
 I $G(DBTS("LDFN"))<DBTS("IEN") S $P(^DBTSPAT(DBTSP,"PRC"),"^",1)=DBTS("IEN")
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
