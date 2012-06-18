DBTSLHAC ;BAO/DMH  pull patient LAB TESTS FOR HAC  [ 11/16/1999  9:24 PM ]
 ;    (HAC)
 ;
 ;
 ;
START ;
 ;
HAC(DBTSGBL,DBTSP)          ;dbtsret is return value, dbtsp input value of patient ien
 ;
 ;
 K DBTSRET
TEST ;
 K ^DBTSTEMP(1)
 S DBTSGBL="^DBTSTEMP("_1_")"
 S ARRAY=0
 ;S DBTSP=649    ;uncomment if want to test with call to TEST directly
 ;
 D ^XBKVAR
 I DUZ(2)=4526 S DUZ(2)=2348
 S DBTS("LOC")=$P($G(^AUTTLOC(DUZ(2),0)),"^",10)
 I DBTS("LOC")="" S DBTSRET(1)="-1" S ^DBTSTEMP(1,1)="-1"_$C(13)_$C(10) Q
 S DBTS("FN")="9000010.09H"
 S DBTS("IEN")=0
 ;
 ;
 I '$D(^DBTSLAB(DUZ(2))) S DBTSRET(1)="-1" S ^DBTSTEMP(1,1)="-1"_$C(13)_$C(10) Q
 ;I '$D(^DBTSLABI) S DBTSRET(1)="-1" Q
 ;
 ;
 S DBTS("LOG")=$G(^DBTSPAT(DBTSP,"HAC"))
 S DBTS("LASTV")=$P(DBTS("LOG"),"^",1)
 S DBTS("LASTDT")=$P(DBTS("LOG"),"^",2)
 ;
 B  
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
 .S DBTS("VDFN")=$P(REC,U,3)
 .S DBTS("VDATE")=$P($G(^AUPNVSIT(DBTS("VDFN"),0)),U,1)
 .S DBTS("MODDT")=$P($G(^AUPNVSIT(DBTS("VDFN"),0)),U,13)
 .Q:DBTS("VDATE")=""
 .S DBTS("V")=$P(DBTS("VDATE"),".",1)
 .Q:DBTS("V")=""
 .S DBTS("DT")=DBTS("V")
 .D DTCHK^DBTSUT
 .Q:$D(DBTS("BADDT"))
 .S DBTS("VD")=$E(DBTS("V"),4,5)_"/"_$E(DBTS("V"),6,7)_"/"_($E(DBTS("V"),1,3)+1700)
 .S DBTS("RESULTS")=$P(REC,U,4)
 .;Q:+DBTS("RESULTS")=0
 .D MODCK
 .Q:DBTS("OK")="N"
 .;
 .;
 .;
 .I '$D(DBTS("AU")) S DBTS("AU")="A"
 .;
 .;
 .I +DBTS("RESULTS")=0 S DBTS("RESULTS")=""  ;comment comes sometimes
 .I DBTS("RESULTS")="" Q
 .I '$D(ARR(DBTS("VD"))) S $P(ARR(DBTS("VD")),"^",10)=DBTS("AU")_"^"_DBTS("V")
 .S $P(ARR(DBTS("VD")),U,DBTS("LABID"))=DBTS("RESULTS")_"|"_DBTS("IEN")
 .Q
 S DBTS("PAT")=DBTSP
 S VD="" F  S VD=$O(ARR(VD)) Q:VD=""  S ARRAY=ARRAY+1 D  S DBTSRET(ARRAY)=DBTSRET(ARRAY)_U_DBTS("VID") S ^DBTSTEMP(1,ARRAY)=DBTSRET(ARRAY)_$C(13)_$C(10)
 .S AU=$P(ARR(VD),"^",10)
 .S DBTS("VISITDFN")=$P(ARR(VD),"^",11)
 .S DBTS("ID")=DBTS("LOC")_"|"_DBTS("PAT")_"|"_VD
 .S DBTS("VID")=DBTS("LOC")_"|9000010|"_DBTS("VDFN")  ;11-8-99 dmh
 .S DBTSRET(ARRAY)=DBTS("ID")_U_DBTS("LOC")_U_AU_U_DBTS("PAT")_U_"LAB-HAC"_U_VD
 .F I=6 S RR=$P(ARR(VD),"^",I) D  
 ..S R=$P(RR,"|",1)
 ..I R'="" S R=+R
 ..I R=0 S R=""
 ..S DBTS("VLABIEN")=$P(RR,"|",2)
 ..S DBTSRET(ARRAY)=DBTSRET(ARRAY)_U_I_U_R
 ..D LOG
 ..Q
 .Q
 I ARRAY=0 S DBTSRET(1)="-2" S ^DBTSTEMP(1,1)="-2"_$C(13)_$C(10)
 I $D(^DBTSPAT(DBTSP,"HAC")) S $P(^DBTSPAT(DBTSP,"HAC"),"^",2)=DT
 K ARR,DBTS
 Q
LABCK ;
 K DBTS("LABID")
 I '$D(^DBTSLAB(DUZ(2),11,"B",DBTS("LAB"))) Q
 S DBTS("N")=$O(^DBTSLAB(DUZ(2),11,"B",DBTS("LAB"),0))
 Q:DBTS("N")=""
 ;
 ;    check to see if the lab test is coded to "H" type for HAC
 ;
 S DBTS("LABREC")=$G(^DBTSLAB(DUZ(2),11,DBTS("N"),0))
 Q:DBTS("LABREC")=""
 I $P(DBTS("LABREC"),U,2)'="H" Q
 S NODE=$P(DBTS("LABREC"),U,4)
 ;
 ;
 S DBTS("LABID")=$P(DBTS("LABREC"),U,3)
 I DBTS("LABID")="" K DBTS("LABID")
 Q
MODCK ;
 S DBTS("OK")="Y"
 S DBTS("AU")="A"
 Q:'$D(^DBTSPAT(DBTSP,"HAC"))
 ;I $P(^DBTSPAT(DBTSP,"HAC"),"^",2)="" Q  ;11-16-99
 S DBTS("MREC")=$G(^DBTSPAT(DBTSP,"HAC"))
 Q:DBTS("MREC")=""
 S DBTS("LDFN")=$P(DBTS("MREC"),U,1)
 I $P(^DBTSPAT(DBTSP,"HAC"),"^",2)="" Q  ;11-16-99
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
 I '$D(^DBTSPAT(DBTSP,"HAC")) S ^DBTSPAT(DBTSP,"HAC")=DBTS("VLABIEN")_"^" Q
 S DBTS("LDFN")=$P(^DBTSPAT(DBTSP,"HAC"),"^",1)   ;2/9/99 ADDED
 I $G(DBTS("LDFN"))<DBTS("VLABIEN") S $P(^DBTSPAT(DBTSP,"HAC"),"^",1)=DBTS("VLABIEN")
 Q
