APCLER21 ; IHS/CMI/LAB - ADMITS FROM ER ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
START ;
 S APCLBT=$H
 K ^XTMP("APCLER2",APCLJOB,APCLBTH)
 D XTMP^APCLOSUT("APCLER2","PCC - ER REPORT 2")
 ;
V ; Run by visit date
 S APCLODAT=APCLSD_".9999" F  S APCLODAT=$O(^AUPNVSIT("B",APCLODAT)) Q:APCLODAT=""!((APCLODAT\1)>APCLED)  D V1
 ;
END ;
 S APCLET=$H
 D EOJ
 Q
V1 ;
 S APCLVDFN="" F  S APCLVDFN=$O(^AUPNVSIT("B",APCLODAT,APCLVDFN)) Q:APCLVDFN'=+APCLVDFN  I $D(^AUPNVSIT(APCLVDFN,0)),$P(^(0),U,9),'$P(^(0),U,11),$$CLINIC^APCLV(APCLVDFN,"C")=30 S APCLVREC=^AUPNVSIT(APCLVDFN,0) D PROC
 Q
PROC ;
 Q:$$DEMO^APCLUTL($P(APCLVREC,U,5),$G(APCLDEMO))
 ; ==> go through all of this patients visits on this visit date
 ; ==> and find an Hospitalization
 ; ==> APCLIVD=inverse date of vd
 ; ==> APCLFVD=inverse date of 3 days from then
 ;
 ; => subtract 1 day from current visit date
 S X1=$P($P(APCLVREC,U),"."),X2=1 D C^%DTC S APCL1D=X
 ; => calculate starting point for $O
 S APCLFVD=(9999999-APCL1D)_".9999"
 S APCLIVD=9999999-$P($P(APCLVREC,U),".")
 F  S APCLFVD=$O(^AUPNVSIT("AA",$P(APCLVREC,U,5),APCLFVD)) Q:APCLFVD=""!($P(APCLFVD,".")>APCLIVD)  D
 .S APCLV=0 F  S APCLV=$O(^AUPNVSIT("AA",$P(APCLVREC,U,5),APCLFVD,APCLV)) Q:APCLV'=+APCLV  D
 ..Q:$$SC^APCLV(APCLV,"I")'="H"
 ..Q:APCLV=APCLVDFN  ;quit if same visit
 ..S Y=$P(APCLVREC,U) D DD^%DT S APCLT1=$P(Y,"@",2),APCLT1=$TR(APCLT1,":","")
 ..S Y=$P(^AUPNVSIT(APCLV,0),U) D DD^%DT S APCLT2=$P(Y,"@",2),APCLT2=$TR(APCLT2,":","")
 ..;I $P($P(^AUPNVSIT(APCLV,0),U),".")=$P($P(APCLVREC,U),"."),APCLT1>APCLT2 Q  ;should we check time of 1 visit versus adm time?  -  nah
 ..S ^XTMP("APCLER2",APCLJOB,APCLBTH,APCLV)=APCLVDFN
 Q
EOJ ;
 K APCLVREC,APCLVDFN,APCLV,APCLODAT
 Q
 ;
