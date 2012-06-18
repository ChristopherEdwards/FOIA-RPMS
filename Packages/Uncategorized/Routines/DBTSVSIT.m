DBTSVSIT ;routine to replicate the visit to SQL for diabetes [ 10/27/1999  5:56 PM ]
 ;
 ;
VSIT(DBTSGBL,DBTSP) ;
TEST ;
 K ^DBTSTEMP(1)
 S DBTSGBL="^DBTSTEMP("_1_")"
 S ARRAY=0
 ;S DBTSP=7082     ;uncomment if want to test with call to TEST directly
 ;
 D ^XBKVAR
 I DUZ(2)=4526 S DUZ(2)=2348
 S DBTS("LOC")=$P($G(^AUTTLOC(DUZ(2),0)),"^",10)
 I DBTS("LOC")="" S DBTSRET(1)="-1" S ^DBTSTEMP(1,1)="-1"_$C(13)_$C(10) Q
 S DBTS("FN")="9000010"
 S DBTS("IEN")=0
MEAS ;
 B
 F I=1:1 S DBTS("IEN")=$O(^AUPNVSIT("AC",DBTSP,DBTS("IEN"))) Q:+DBTS("IEN")=0  D  ;Q:ARRAY>500     
 .;
 .;added the >500 to stop and not fill up partition
 .;
 .S REC=$G(^AUPNVSIT(DBTS("IEN"),0))
 .Q:REC=""
 .I $P(REC,"^",5)'=DBTSP Q    ;dmh added 10-27-99
 .S DBTS("VDFN")=DBTS("IEN")
 .S DBTS("MODDT")=$P(REC,U,13)
 .S DBTS("VDATE")=$P(REC,U,1)
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
 .S DBTS("FAC")=$P(REC,U,6) S DBTS("FAC")=$P($G(^AUTTLOC(DBTS("FAC"),0)),U,10)
 .S DBTS("SC")=$P(REC,U,7)
 .Q:DBTS("SC")=""
 .S DBTS("CLI")=$P(REC,U,8) 
 .I DBTS("CLI")'="" S DBTS("CLI")=$P($G(^DIC(40.7,DBTS("CLI"),0)),U,2)
 .Q:DBTS("CLI")=""
 .S DBTS("PAT")=DBTSP
 .S DBTS("CN")=$P($G(^AUPNPAT(DBTSP,41,DUZ(2),0)),"^",2)
 .S DBTS("ID")=DBTS("LOC")_"|"_DBTS("FN")_"|"_DBTS("IEN")
 .D MODCK
 .Q:DBTS("OK")="N"
 .D PROV
 .D NARR       ;dmh added this line 10-26-99
 .I '$D(DBTS("PNAR")) S DBTS("PNAR")=""   ;dmh added this line 10-26-99
 .S ARRAY=ARRAY+1
 .   ;
 .;Q:ARRAY>500   ; added so no pgmov errors on space 10-5-99
 .   ;
 .S ^DBTSTEMP(1,ARRAY)=DBTS("ID")_U_DBTS("AU")_U_DBTS("VDATE")_U_DBTS("LOC")_U_DBTS("FAC")_U_DBTS("PROV")_U_DBTS("CLI")_U_DBTS("SC")_U_DBTS("PNAR")_$C(13)_$C(10)
 .      ;dmh added the pnar to end of record 10-26-99
 .D LOG
 .Q
 I ARRAY=0 S DBTSRET(1)="-2" S ^DBTSTEMP(1,1)="-2"_$C(13)_$C(10)
 I $D(^DBTSPAT(DBTSP,"V")) S $P(^DBTSPAT(DBTSP,"V"),"^",2)=DT
 Q
MODCK ;
 ;
 S DBTS("OK")="Y"
 S DBTS("AU")="A"
 Q:'$D(^DBTSPAT(DBTSP,"V"))
 S DBTS("MREC")=$G(^DBTSPAT(DBTSP,"V"))
 Q:DBTS("MREC")=""
 S DBTS("LDFN")=$P(DBTS("MREC"),U,1)
 I $P(DBTS("MREC"),"^",2)="" Q
 Q:+DBTS("LDFN")<DBTS("IEN")
 S DBTS("LDT")=$P(DBTS("MREC"),U,2)
 I (+DBTS("LDT")>DBTS("MODDT")),(DBTS("LDFN")>DBTS("IEN")) S DBTS("OK")="N" Q
 I (DBTS("LDT")'>DBTS("MODDT")) S DBTS("AU")="U" Q
 S DBTS("OK")="N" Q
 Q
LOG ;  update the patient log for the type of VISIT
 I '$D(DT) D ^XBKVAR 
 I '$D(^DBTSPAT(DBTSP)) D
 .K ^DBTSPAT("B",DBTSP)
 .S X=DBTSP,DINUM=X,DIC(0)="XNL",DIC="^DBTSPAT(" D FILE^DICN
 I '$D(^DBTSPAT(DBTSP,"V")) S ^DBTSPAT(DBTSP,"V")=DBTS("IEN")_"^" Q
 I $G(DBTS("LDFN"))<DBTS("IEN") S $P(^DBTSPAT(DBTSP,"V"),"^",1)=DBTS("IEN")
 Q
PROV ;
 S PROVFL=0
 S DBTS("PROV")=""
 S PROV=0
 F  S PROV=$O(^AUPNVPRV("AD",DBTS("IEN"),PROV)) Q:PROV=""  D  I PROVFL=1 Q
 .I $P($G(^AUPNVPRV(PROV,0)),U,4)="P" D
 ..S PROVFL=1
 ..S DBTS("PROV")=$P($G(^AUPNVPRV(PROV,0)),U,1)
 ..S DBTS("PROV")=$P($G(^DIC(6,DBTS("PROV"),0)),U,1)
 ..S DBTS("PROV")=$P($G(^DIC(16,DBTS("PROV"),"A3")),U,1)
 ..I DBTS("PROV")="" S PROVFL=0
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
