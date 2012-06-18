DBTSPATU ;BUILD TXT FILE TO UPDATE PATIENT FILES [ 04/30/1999  5:42 PM ]
PATUP ;
 D ^XBKVAR
 S CT=0
 S LOC=$P(^AUTTLOC(DUZ(2),0),"^",10)
 O 51:("/usr/spool/uucppublic/dbtspatup"_LOC_".txt":"W")
 S PAT=0
 F  S PAT=$O(^DBTSPAT(PAT)) Q:+PAT=0  D
 .S DBTS("PH")=$P($G(^DPT(PAT,.13)),"^",1)
 .D PHONE
 .S ID=LOC_"|2|"_PAT
 .S OUTREC=ID_$C(9)_DBTS("PH")
 .U 51 W OUTREC,!
 .S CT=CT+1
 .Q
 C 51
 U 0 W "TOTAL: ",CT
 K CT
 Q
PHONE ;
 Q:DBTS("PH")=""
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
