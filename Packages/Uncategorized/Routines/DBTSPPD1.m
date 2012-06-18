DBTSPPD ;BAO/DMH  pull patient PPD SKIN TEST [ 11/16/1999  6:00 PM ]
 ;
 ;
 ;
START ;
 ;
PPD(DBTSRET,DBTSP)          ;dbtsret is return value, dbtsp input value of patient ien
 ;
 ;
TEST ;
 S ARRAY=0
 ;S DBTSP=12302
 ;
 D ^XBKVAR
 I DUZ(2)=4526 S DUZ(2)=2348
 S DBTS("LOC")=$P($G(^AUTTLOC(DUZ(2),0)),"^",10)
 I DBTS("LOC")="" S DBTSRET(1)="-1" Q
 S DBTS("FN")="9000010.12"
 S DBTS("IEN")=0
EX ;
 S DTCT=0   ;comment out when go with live data
 ;
 S PPD=$O(^AUTTSK("B","PPD",0))
 I +PPD=0 S DBTSRET(1)="-2" Q
 ;
 F I=1:1 S DBTS("IEN")=$O(^AUPNVSK("AC",DBTSP,DBTS("IEN"))) Q:+DBTS("IEN")=0  D
 .S REC=$G(^AUPNVSK(DBTS("IEN"),0))
 .Q:REC=""
 .S DBTS("PPD")=$P(REC,"^",1)
 .Q:DBTS("PPD")'=PPD
 .S DBTS("RESULT")=$P(REC,"^",4)
 .I DBTS("RESULT")'="" D RESULT
 .S DBTS("READING")=$P(REC,"^",5)
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
 .S DBTSRET(ARRAY)=DBTS("ID")_U_DBTS("LOC")_U_DBTS("AU")_U_DBTS("PAT")_U_"PPD"_U_DBTS("RESULT")_U_DBTS("READING")_U_DBTS("VDATE")_U_DBTS("PNAR")
 .D LOG
 .Q
 I ARRAY=0 S DBTSRET(1)="-2"
 S $P(^DBTSPAT(DBTSP,"PPD"),"^",2)=DT
 Q
RESULT ;
 I DBTS("RESULT")="P" S DBTS("RESULT")="POSITIVE" Q
 I DBTS("RESULT")="N" S DBTS("RESULT")="NEGATIVE" Q
 I DBTS("RESULT")="D" S DBTS("RESULT")="DOUBTFUL" Q
 I DBTS("RESULT")="O" S DBTS("RESULT")="NO TAKE" Q
 Q
MODCK ;
 S DBTS("OK")="Y"
 S DBTS("AU")="A"
 ;Q                           ;for testing
 Q:'$D(^DBTSPAT(DBTSP,"PPD"))
 I $P(^DBTSPAT(DBTSP,"PPD"),"^",2)="" Q
 S DBTS("MREC")=$G(^DBTSPAT(DBTSP,"PPD"))
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
 I '$D(^DBTSPAT(DBTSP,"PPD")) S ^DBTSPAT(DBTSP,"PPD")=DBTS("IEN")_"^" Q
 I $G(DBTS("LDFN"))<DBTS("IEN") S $P(^DBTSPAT(DBTSP,"PPD"),"^",1)=DBTS("IEN")
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
