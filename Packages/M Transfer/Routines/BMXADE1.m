BMXADE1 ; IHS/OIT/HMW - BMXNet ADO.NET PROVIDER ;
 ;;4.0;BMX;;JUN 28, 2010
 ;
 ;
 ;Dental Excel report demo
 ;
BMXADE(BMXGBL,BMXBEG,BMXEND)    ;EP
 ;Returns recordset containing services and minutes by reporting facility, patient's community and service unit
 ;
 N BMXBEGDT,BMXENDDT,BMXTMP,BMXDT,BMXRD,BMXIEN,BMXNOD,BMXPAT,BMXCOM,BMXFAC,BMXSU,BMXCOMP,BMXSUP,BMXFACP,BMXSVC,BMXMIN,BMXFEE
 S U="^",BMXRD=$C(30)
 K ^BMXTEMP($J),^BMXTMP($J)
 S BMXGBL="^BMXTEMP("_$J_")"
 S ^BMXTEMP($J,0)="T00030FACILITY^T00030PT_COMMUNITY^T00030PT_SERVICE_UNIT^I00030SERVICES^I00030MINUTES^I00030FEE"_BMXRD
 S X=BMXBEG,%DT="P" D ^%DT S BMXBEGDT=Y
 S X=BMXEND,%DT="P" D ^%DT S BMXENDDT=Y
 I BMXENDDT<BMXBEGDT S BMXTMP=BMXENDDT,BMXENDDT=BMXBEGDT,BMXBEGDT=BMXTMP
 S BMXBEGDT=$P(BMXBEGDT,".")
 S BMXENDDT=$P(BMXENDDT,"."),$P(BMXENDDT,".",2)=99999
 ;
 ;$O Thru ADEPCD("AC" DATE X-REF
 ;Temp global is (FAC,COMM)=SVCS^MINS
 ;
 S BMXDT=BMXBEGDT F  S BMXDT=$O(^ADEPCD("AC",BMXDT)) Q:'+BMXDT  Q:BMXDT>BMXENDDT  D
 . S BMXIEN=0 F  S BMXIEN=$O(^ADEPCD("AC",BMXDT,BMXIEN)) Q:'+BMXIEN  D
 . . Q:'$D(^ADEPCD(BMXIEN,0))
 . . S BMXNOD=^ADEPCD(BMXIEN,0)
 . . S BMXPAT=$P(BMXNOD,U)
 . . S BMXFACP=+$P(BMXNOD,U,3)
 . . S BMXCOMP=$$GETCOMP(BMXPAT)
 . . D CALCMIN(BMXIEN,.BMXSVC,.BMXMIN,.BMXFEE)
 . . Q:BMXSVC=0
 . . S:'$D(^BMXTMP($J,BMXFACP,BMXCOMP)) ^BMXTMP($J,BMXFACP,BMXCOMP)="0^0^0"
 . . S $P(^BMXTMP($J,BMXFACP,BMXCOMP),U)=$P(^(BMXCOMP),U)+BMXSVC
 . . S $P(^BMXTMP($J,BMXFACP,BMXCOMP),U,2)=$P(^(BMXCOMP),U,2)+BMXMIN
 . . S $P(^BMXTMP($J,BMXFACP,BMXCOMP),U,3)=$P(^(BMXCOMP),U,3)+BMXFEE
 . . Q
 . Q
 ;
 ;Traverse ^BMXTMP and fill in ^BMXTEMP
 S BMXI=0
 S BMXFACP=-1 F  S BMXFACP=$O(^BMXTMP($J,BMXFACP)) Q:BMXFACP=""  D
 . I BMXFACP=0 S BMXFAC="UNKNOWN"
 . E  S BMXFAC=$P($G(^DIC(4,BMXFACP,0)),U) S:BMXFAC="" BMXFAC="UNKNOWN"
 . S BMXCOMP=-1 F  S BMXCOMP=$O(^BMXTMP($J,BMXFACP,BMXCOMP)) Q:BMXCOMP=""  D
 . . I BMXCOMP=0 S BMXCOM="UNKNOWN"
 . . E  S BMXCOM=$P($G(^AUTTCOM(BMXCOMP,0)),U) S:BMXCOM="" BMXCOM="UNKNOWN"
 . . S BMXSU=+$P($G(^AUTTCOM(BMXCOMP,0)),U,5)
 . . I BMXSU=0 S BMXSU="UNKNOWN"
 . . E  S BMXSU=$P($G(^AUTTSU(BMXSU,0)),U)
 . . S BMXI=BMXI+1
 . . S BMXSVC=$P(^BMXTMP($J,BMXFACP,BMXCOMP),U)
 . . S BMXMIN=$P(^BMXTMP($J,BMXFACP,BMXCOMP),U,2)
 . . S BMXFEE=$P(^BMXTMP($J,BMXFACP,BMXCOMP),U,3)
 . . S ^BMXTEMP($J,BMXI)=BMXFAC_U_BMXCOM_U_BMXSU_U_BMXSVC_U_BMXMIN_U_BMXFEE_BMXRD
 . . Q
 . Q
 S BMXI=BMXI+1
 S ^BMXTEMP($J,BMXI)=$C(31)
 Q
 ;
GETCOMP(BMXPAT)  ;
 ;Returns Patient Community Pointer
 I '$D(^AUPNPAT(BMXPAT,11)) Q 0
 Q +$P(^AUPNPAT(BMXPAT,11),U,17)
 ;
CALCMIN(BMXIEN,BMXSVC,BMXMIN,BMXFEE)          ;
 ;Returns count of lvl 1 - 6 services and minutes for entry BMXIEN
 ;Uses ANMC rogue FEE field in AUTTADA to calculate FEE data
 N BMXA,BMXCOD,BMXALVL
 S BMXSVC=0,BMXMIN=0,BMXFEE=0
 Q:'$D(^ADEPCD(BMXIEN,"ADA"))
 S BMXA=0 F  S BMXA=$O(^ADEPCD(BMXIEN,"ADA",BMXA)) Q:'+BMXA  D
 . S BMXCOD=+^ADEPCD(BMXIEN,"ADA",BMXA,0)
 . Q:'$D(^AUTTADA(BMXCOD,0))
 . S BMXANOD=^AUTTADA(BMXCOD,0)
 . S BMXALVL=$P(BMXANOD,U,5)
 . Q:BMXALVL=0
 . Q:BMXALVL>6
 . S BMXSVC=BMXSVC+1
 . S BMXMIN=BMXMIN+$P(BMXANOD,U,4)
 . S BMXFEE=BMXFEE+$P(BMXANOD,U,12)
 Q