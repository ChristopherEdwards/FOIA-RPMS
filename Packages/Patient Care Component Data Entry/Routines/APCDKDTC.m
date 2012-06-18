APCDKDTC ; IHS/CMI/LAB - LINK DIF DAY LAB VISITS ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
EP ;EP nightly re-linker for DTC
 ;go through all visits from 60 days ago and find visits
 ;with a DTC (V Tran with an ordering prov and ordering date)
 ;and NO Billing Link and attempt to do the billing link
 NEW APCDKDTC
 S X1=DT,X2=-61 D C^%DTC S APCDKDTC("DATE")=X_.999999
 F  S APCDKDTC("DATE")=$O(^AUPNVSIT("B",APCDKDTC("DATE"))) Q:APCDKDTC("DATE")=""  D
 .S APCDKDTC("V")=0 F  S APCDKDTC("V")=$O(^AUPNVSIT("B",APCDKDTC("DATE"),APCDKDTC("V"))) Q:APCDKDTC("V")'=+APCDKDTC("V")  D
 ..S APCDKDTC("VR")=^AUPNVSIT(APCDKDTC("V"),0)
 ..Q:$P(APCDKDTC("VR"),U,11)  ;deleted visit
 ..Q:'$P(APCDKDTC("VR"),U,9)  ;no dep entries
 ..Q:$P(APCDKDTC("VR"),U,28)]""  ;already has billing link
 ..Q:'$$DTC(APCDKDTC("V"))  ;no DTC's
 ..D LINK(APCDKDTC("V"))
 ..Q
 .Q
 K APCDKDTC
 Q
 ;
START(APCDV) ;EP - FIND ORDERING VISIT OF dtc
 Q:'$G(APCDV)
 Q:'$D(^AUPNVSIT(APCDV))
 Q:$P(^AUPNVSIT(APCDV,0),U,11)
 Q:'$P(^AUPNVSIT(APCDV,0),U,9)
 Q:'$$DTC(APCDV)
 D LINK(APCDV) ;link to original visit
 Q
 ;
 ;
DTC(V) ;EP if have 1 v tc with an ordering date/prov
 NEW T,F
 S (T,F)=0 F  S T=$O(^AUPNVTC("AD",V,T)) Q:T'=+T!(F)  I $P($G(^AUPNVTC(T,12)),U,2)]"",$P($G(^AUPNVTC(T,12)),U,11)]"" S F=1
 Q F
LINK(APCDVST) ; -- find orig visit and set link
 NEW APCDX,APCDTC,ORDT,ORDPRV,DFN,DATE,PRV,ORDV,LINK
 ;
 ; -- get first v tran code with an ordering date and prov
 NEW F S (F,APCDTC)=0 F  S APCDTC=$O(^AUPNVTC("AD",APCDVST,APCDTC)) Q:APCDTC'=+APCDTC!(F)  D
 . S DFN=$P($G(^AUPNVTC(APCDTC,0)),U,2) Q:DFN=""           ;patient
 . S ORDT=$P($P($G(^AUPNVTC(APCDTC,12)),U,11),".") Q:ORDT=""        ;order date
 . S ORDPRV=$P($G(^AUPNVTC(APCDTC,12)),U,2) Q:ORDPRV=""    ;ordering provider
 . S ORDPRV=$S($P(^DD(9000010.06,.01,0),U,2)[6:$P($G(^DIC(3,ORDPRV,0)),U,16),1:ORDPRV) Q:ORDPRV=""
 . S F=1
 . Q
 Q:'F
 ;
 ; -- look for orig visit based on order date for patient and provider
 K LINK S DATE=$$RVDT(ORDT)-.0001,END=$$RVDT(ORDT)+.9999999
 F  S DATE=$O(^AUPNVSIT("AA",DFN,DATE)) Q:'DATE!(DATE>END)!($D(LINK))  D
 . ; -- find all visits for patient on order date
 . S ORDV=0 F  S ORDV=$O(^AUPNVSIT("AA",DFN,DATE,ORDV)) Q:'ORDV  D
 .. Q:ORDV=APCDVST  ;don't link to itself
 .. ; -- find if ordering provider linked to this visit
 .. S PRV=0 F  S PRV=$O(^AUPNVPRV("AD",ORDV,PRV)) Q:'PRV!($D(LINK))  D
 ... I +^AUPNVPRV(PRV,0)=ORDPRV S LINK=ORDV ;orig visit found
 ;
 ; -- if orig visit found, set link
 I $G(LINK) S DIE=9000010,DA=APCDVST,DR=".28////"_LINK D ^DIE
 Q
 ;
 ;
RVDT(X) ; -- returns reverse date 
 Q 9999999-X
 ;
