DBTSDEMO ;BAO/DMH  pull patient demo [ 04/30/1999  5:29 PM ]
 ;
 ;
DEMO(DBTSRET,DBTSP)          ;dbtsret is return value, dbtsp input value of patient ien
 ;
 ;
TEST ;
 ;S DBTSP=299
 ;
 D ^XBKVAR
 I DUZ(2)=4526 S DUZ(2)=2348
 S DBTS("LOC")=$P($G(^AUTTLOC(DUZ(2),0)),"^",10)
 I DBTS("LOC")="" S DBTSRET(1)="-1" Q
 S DBTS("FN")=2
 S DBTS("IEN")=DBTSP
 S DBTS("ID")=DBTS("LOC")_"|"_DBTS("FN")_"|"_DBTS("IEN")
 S DBTS("CN")=$P($G(^AUPNPAT(DBTSP,41,DUZ(2),0)),"^",2)
 S DPT=^DPT(DBTSP,0)
 S DBTS("SSN")=$P(DPT,"^",9) I DBTS("SSN")'="" S DBTS("SSN")=$E(DBTS("SSN"),1,3)_"-"_$E(DBTS("SSN"),4,5)_"-"_$E(DBTS("SSN"),6,9)
 S NAME=$P(DPT,"^",1)
 S DBTS("LN")=$P(NAME,",",1)
 S DBTS("FN")=$P(NAME,",",2) S DBTS("FN")=$P(DBTS("FN")," ",1)
 S DBTS("IN")=$P(NAME," ",2) I DBTS("IN")'="" S DBTS("IN")=$E(DBTS("IN"),1,1)
 S DBTS("DT")=$P(DPT,"^",3) D DT S DBTS("DOB")=DBTS("DT")
 I $D(^DPT(DBTSP,.35)) S DBTS("DT")=$P(^(.35),"^",1) D:DBTS("DT")'="" DT S DBTS("DOD")=DBTS("DT")
 E  S DBTS("DOD")=""
 D ONAME
 ;S DBTS("DOB")=$E(DOB,4,5)_"/"_$E(DOB,6,7)_"/"_(1700+$E(DOB,1,3))
 S SEX=$P(DPT,"^",2) S DBTS("SEX")=$S(SEX="M":1,SEX="F":2,1:"")
 S DPT(.11)=$G(^DPT(DBTSP,.11))
 S DBTS("ADD1")=$P(DPT(.11),"^",1)
 S DBTS("ADD2")=$P(DPT(.11),"^",2)
 S DBTS("CITY")=$P(DPT(.11),"^",4)
 S DBTS("ST")=$P(DPT(.11),"^",5) I DBTS("ST")'="" S DBTS("ST")=$P(^DIC(5,DBTS("ST"),0),"^",2)
 S DBTS("ZIP")=$P(DPT(.11),"^",6)
 S DBTS("PH")=$P($G(^DPT(DBTSP,.13)),"^",1) ;I DBTS("PH")?.E1A.E S DBTS("PH")=""
 I DBTS("PH")'="" D PHONE I DBTS("PH")'?3N1"-"3N1"-"4N S DBTS("PH")=""
 ;
 D MODCK    ;check to see if add or update
 I DBTS("OK")="N" S DBTSRET(1)="-2" Q
 ;
 S DBTSRET(1)=DBTS("ID")_U_DBTS("LOC")_U_DBTS("AU")_U_DBTS("CN")_U_DBTS("SSN")_U_DBTS("FN")_U_DBTS("LN")_U_DBTS("IN")_U_DBTS("ADD1")_U
 S DBTSRET(1)=DBTSRET(1)_DBTS("ADD2")_U_DBTS("CITY")_U_DBTS("ST")_U_DBTS("ZIP")_U_DBTS("PH")_U_DBTS("DOB")_U_DBTS("SEX")_U_DBTS("ONAME")_U_DBTS("DOD")
 D LOG
 Q
DT ;
 I DBTS("DT")="" S DBTS("DT")="01/01/9999" Q
 S MO=$E(DBTS("DT"),4,5)
 I MO>12 S MO=12
 I +MO<1 S MO="01"
 S DA=$E(DBTS("DT"),6,7)
 I DA>31 S DA=15
 I +DA<1 S DA="01"
 S YR=$E(DBTS("DT"),1,3)
 I +YR<100 S YR=100
 S YR=1700+YR
 S DBTS("DT")=MO_"/"_DA_"/"_YR
 Q
ONAME ;other name check
 S DBTS("ONAME")=""
 Q:'$D(^DPT(DBTSP,.01))
 S ONAME=0
 F  S ONAME=$O(^DPT(DBTSP,.01,ONAME)) Q:+ONAME=0  D
 .S DBTS("ONAME")=$P($G(^DPT(DBTSP,.01,ONAME,0)),"^",1)
 .Q
 Q
LOG ;  update the patient log for the type of lab test
 I '$D(DT) D ^XBKVAR 
 I '$D(^DBTSPAT(DBTSP)) D
 .K ^DBTSPAT("B",DBTSP)   ;just in case still exists from testing
 .S X=DBTSP,DINUM=X,DIC(0)="XNL",DIC="^DBTSPAT(" D FILE^DICN
 S $P(^DBTSPAT(DBTSP,0),"^",2)=DT 
 Q
MODCK ;
 S DBTS("OK")="Y"
 S DBTS("AU")="A"
 I $P($G(^DBTSPAT(DBTSP,0)),"^",2)="" Q
 S DBTS("PATLM")=$P($G(^AUPNPAT(DBTSP,0)),"^",3)
 S DBTS("LDT")=$P($G(^DBTSPAT(DBTSP,0)),"^",2)
 I (DBTS("LDT")'>DBTS("PATLM")) S DBTS("AU")="U" Q
 S DBTS("OK")="N"
 Q
PHONE ;
 I DBTS("PH")["(" S DBTS("PH")=$TR(DBTS("PH"),"(","")
 I DBTS("PH")[")" S DBTS("PH")=$TR(DBTS("PH"),")","")
 I DUZ(2)=2336 S AREA=307
 E  S AREA=406
 I DBTS("PH")?3N1"-"4N S DBTS("PH")=AREA_"-"_DBTS("PH") Q
 I DBTS("PH")?7N S DBTS("PH")=AREA_"-"_$E(DBTS("PH"),1,3)_"-"_$E(DBTS("PH"),4,7) Q
 I DBTS("PH")?10N S DBTS("PH")=$E(DBTS("PH"),1,3)_"-"_$E(DBTS("PH"),4,6)_"-"_$E(DBTS("PH"),7,10) Q
 I DBTS("PH")?6N1"-"4N S DBTS("PH")=$E(DBTS("PH"),1,3)_"-"_$E(DBTS("PH"),4,6)_"-"_$P(DBTS("PH"),"-",2) Q
 I DBTS("PH")?3N1"-"3N1"-"4N Q
 S DBTS("PH")=""
 Q
 
