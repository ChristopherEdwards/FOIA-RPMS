DBTSLAB ;BAO/DMH  pull patient LAB  [ 12/09/1998  1:45 PM ]
 ;
 ;
 ;
START ;
 ;
LAB(DBTSRET,DBTSP)          ;dbtsret is return value, dbtsp input value of patient ien
 ;
 ;
TEST ;
 S ARRAY=0
 ;S DBTSP=13052    ;uncomment if want to test with call to TEST directly
 ;
 D ^XBKVAR
 I DUZ(2)=4526 S DUZ(2)=2348
 S DBTS("LOC")=$P(^AUTTLOC(DUZ(2),0),"^",10)
 S DBTS("FN")="9000010.09"
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
 .Q:DBTS("VDATE")=""
 .S DBTS("VDATE")=$P(DBTS("VDATE"),".",1)
 .S DBTS("VDATE")=$E(DBTS("VDATE"),4,5)_"/"_$E(DBTS("VDATE"),6,7)_"/"_($E(DBTS("VDATE"),1,3)+1700)
 .S DBTS("RESULTS")=$P(REC,U,4)
 .;
 .;
 .;
 .S DBTS("PAT")=DBTSP
 .S DBTS("CN")=$P(^AUPNPAT(DBTSP,41,DUZ(2),0),"^",2)
 .S ARRAY=ARRAY+1
 .S DBTS("ID")=DBTS("LOC")_"|"_DBTS("FN")_"|"_DBTS("IEN")
 .S DBTSRET(ARRAY)=DBTS("ID")_U_DBTS("LOC")_U_"A"_U_DBTS("PAT")_U_"LAB"_U_DBTS("LABID")_U_DBTS("VDATE")_U_DBTS("RESULTS")
 .Q
 I ARRAY=0 S DBTSRET(1)="-2"
 Q
LABCK ;
 K DBTS("LABID")
 I '$D(^DBTSLAB(DUZ(2),11,"B",DBTS("LAB"))) Q
 S DBTS("N")=$O(^DBTSLAB(DUZ(2),11,"B",DBTS("LAB"),0))
 Q:DBTS("N")=""
 S DBTS("IDP")=$P(^DBTSLAB(DUZ(2),11,DBTS("N"),0),"^",2)
 S DBTS("LABID")=$P(^DBTSLABI(DBTS("IDP"),0),"^",1)
 Q
