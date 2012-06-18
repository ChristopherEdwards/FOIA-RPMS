DBTSEXAM ;BAO/DMH  pull patient exams [ 02/04/1999  5:04 PM ]
 ;
 ;
 ;
START ;
 ;
EXAM(DBTSRET,DBTSP)          ;dbtsret is return value, dbtsp input value of patient ien
 ;
 ;
TEST ;
 S ARRAY=0
 ;S DBTSP=6
 ;
 D ^XBKVAR
 I DUZ(2)=4526 S DUZ(2)=2348
 S DBTS("LOC")=$P($G(^AUTTLOC(DUZ(2),0)),"^",10)
 I DBTS("LOC")="" S DBTSRET(1)="-1" Q
 S DBTS("FN")="9000010.13"
 S DBTS("IEN")=0
EX ;
 F I=1:1 S DBTS("IEN")=$O(^AUPNVXAM("AC",DBTSP,DBTS("IEN"))) Q:+DBTS("IEN")=0  D
 .S REC=$G(^AUPNVXAM(DBTS("IEN"),0))
 .Q:REC=""
 .S DBTS("EXAM")=$P(REC,U,1)
 .I DBTS("EXAM")="" Q
 .S DBTS("EXNAME")=$P(^AUTTEXAM(DBTS("EXAM"),0),U,1)
 .S DBTS("CODE")=$P(^AUTTEXAM(DBTS("EXAM"),0),U,2)
 .S DBTS("V")=$P(REC,U,3)
 .S DBTS("VDATE")=$P($G(^AUPNVSIT(DBTS("V"),0)),U,1)
 .I DBTS("VDATE")="" S DBTS("VDATE")=2931001
 .    ;
 .    ;     dmh  comment out the above when go live with exam data
 .    ;
 .Q:DBTS("VDATE")=""
 .S DBTS("VDATE")=$P(DBTS("VDATE"),".",1)
 .S DBTS("VDATE")=$E(DBTS("VDATE"),4,5)_"/"_$E(DBTS("VDATE"),6,7)_"/"_($E(DBTS("VDATE"),1,3)+1700)
 .;
 .;
 .;
 .S DBTS("PAT")=DBTSP
 .S DBTS("CN")=$P(^AUPNPAT(DBTSP,41,DUZ(2),0),"^",2)
 .S ARRAY=ARRAY+1
 .S DBTS("ID")=DBTS("LOC")_"|"_DBTS("FN")_"|"_DBTS("IEN")
 .S DBTSRET(ARRAY)=DBTS("ID")_U_DBTS("LOC")_U_"A"_U_DBTS("PAT")_U_DBTS("EXNAME")_U_DBTS("CODE")_U_DBTS("VDATE")
 .Q
 I ARRAY=0 S DBTSRET(1)="-2"
 Q
