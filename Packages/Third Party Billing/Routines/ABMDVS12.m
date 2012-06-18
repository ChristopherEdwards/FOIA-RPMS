ABMDVS12 ; IHS/ASDST/DMJ - PCC VISIT STUFF, PHYSICAL THERAPY ; 
 ;;2.6;IHS Third Party Billing System;**2**;NOV 12, 2009
 ;Original;RAM;03/26/96 10:50 AM
 ;This rtn may not be needed anymore.  13 may do it OK.
 ;As things stand this does not seem to do anything that is not done
 ;better by rtn 13.  If for some reason it is needed the source field 
 ;needs to be added.
 ;
 ; IHS/SD/SDR - v2.6 CSV
 ; IHS/SD/SDR - abm*2.6*2 - 3PMS10003A - Modified to call ABMFEAPI
 ;
 Q
 Q:ABMIDONE
START ;START HERE
 K AMB12
 S AMB12("DA")=0 F  S AMB12("DA")=$O(^AUPNVPT("AD",ABMVDFN,AMB12("DA"))) Q:'AMB12("DA")  D
 .S AMB12("CPT")=$$CPT(AMB12("DA")) Q:AMB12("CPT")=""
 .Q:'$D(^ICPT("B",AMB12("CPT")))
 .S AMB12("CPT",AMB12("CPT"))=""
 .;Q:(('$P($G(^ABMDFEE(+ABMP("FEE"),15,AMB12("CPT"),0)),"^",2))&($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U,14)'="Y"))  ;abm*2.6*2 3PMS10003A
 .Q:(('$P($$ONE^ABMFEAPI(+ABMP("FEE"),15,AMB12("CPT"),ABMP("VDT")),"^"))&($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U,14)'="Y"))  ;abm*2.6*2 3PMS10003A
 .;S AMB12("CHRG",AMB12("CPT"))=$P($G(^ABMDFEE(+ABMP("FEE"),15,AMB12("CPT"),0)),"^",2)  ;abm*2.6*2 3PMS10003A
 .S AMB12("CHRG",AMB12("CPT"))=$P($$ONE^ABMFEAPI(+ABMP("FEE"),15,AMB12("CPT"),ABMP("VDT")),"^")  ;abm*2.6*2 3PMS10003A
 .S AMB12("UNITS",AMB12("CPT"))=+$G(AMB12("UNITS",AMB12("CPT")))+1
 I '$D(^ABMDCLM(DUZ(2),ABMP("CDFN"),27,0)) S ^(0)="^9002274.3027P^^"
 S AMB12("CPT")=0 F  S AMB12("CPT")=$O(AMB12("CPT",AMB12("CPT"))) Q:'AMB12("CPT")  D
 .S X=AMB12("CPT"),DIC="^ABMDCLM("_DUZ(2)_","_ABMP("CDFN")_",27,",DIC(0)="LXE" D ^DIC Q:Y<0
 .S AMB12("RVN")=$P($$IHSCPT^ABMCVAPI(+AMB12("CPT"),ABMP("VDT")),U,3)  ;CSV-c
 .S DIE=DIC,DA(1)=ABMP("CDFN"),DA=AMB12("CPT"),DR=".02///"_AMB12("RVN")_";.03///"_AMB12("UNITS",AMB12("CPT"))_";.04///"_AMB12("CHRG",AMB12("CPT")) D ^DIE
 K AMB12 Q
 ;
CPT(X) ; -- cpt code
 Q $P($$CPT^ABMCVAPI(+$P($G(^AUTTPHTH(+$G(^AUPNVPT(+X,0)),0)),U,2),ABMP("VDT")),U,2)  ;CSV-c
