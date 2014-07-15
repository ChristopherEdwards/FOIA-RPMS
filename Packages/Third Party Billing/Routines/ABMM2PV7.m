ABMM2PV7 ;IHS/SD/SDR - MU Patient Volume EP Report ;
 ;;2.6;IHS 3P BILLING SYSTEM;**11**;NOV 12, 2009;Build 133
 ;
ZEROPD ;EP
 K ABMTRAMT
 I ABMY("RTYP")="GRP" D  Q
 .D CALCDTS^ABMM2PV1
 .S ABMDTFLG=0
 .S ABMP("BDT")=ABMP("BSDT")
 .F  D  Q:ABMDTFLG=1
 ..I ABMITYP="D"!(ABMITYP="K")!(ABMITYP="P"&($D(ABMI("INS",ABMINS)))) D
 ...S ^XTMP("ABM-PVP2",$J,"PRV-NUM ZEROPD BILLS",ABMP("BDT"),ABMGRP,ABMVDFN,ABMP("BDFN"))=""
 ...S ^XTMP("ABM-PVP2",$J,"PRV-NUM ZEROPD DET",ABMP("BDT"),ABMGRP,ABMVDFN,ABMP("BDFN"))=""
 ..S ^XTMP("ABM-PVP2",$J,"PRV-VST",ABMP("BDT"),ABMVDFN)=""
 ..S ^XTMP("ABM-PVP2",$J,"VISITS",ABMVDFN)=1
 ..I ABMY("RTYP")="GRP" D GPTDATA
 ..I ABMY("RTYP")="SEL" D PTDATA
 ..S X1=ABMP("BDT")
 ..S X2=1
 ..D C^%DTC
 ..I X>ABMP("BEDT") S ABMDTFLG=1 Q
 ..S ABMP("BDT")=X
 ;
 S ABMPIEN=0
 K ABMPRVC
 F  S ABMPIEN=$O(^AUPNVPRV("AD",ABMVDFN,ABMPIEN)) Q:'ABMPIEN  D
 .S ABMPRV=$$GET1^DIQ(9000010.06,ABMPIEN,".01","I")
 .Q:'$D(ABMPRVDR(ABMPRV))
 .;skip provider if on visit more than once
 .Q:$D(ABMPRVC(ABMPRV))
 .S ABMPRVC(ABMPRV)=1
 .D CALCDTS^ABMM2PV1
 .S ABMDTFLG=0
 .S ABMP("BDT")=ABMP("BSDT")
 .F  D  Q:ABMDTFLG=1
 ..I ABMITYP="D"!((ABMITYP="K")&$D(^ABMMUPRM(1,1,"B",ABMVLOC)))!(ABMITYP="P"&($D(ABMI("INS",ABMINS)))) D
 ...S ^XTMP("ABM-PVP2",$J,"PRV-NUM ZEROPD BILLS",ABMP("BDT"),ABMPRV,ABMGRP,ABMVDFN,ABMP("BDFN"))=""
 ...S ^XTMP("ABM-PVP2",$J,"PRV-NUM ZEROPD DET",ABMP("BDT"),ABMGRP,ABMVDFN,ABMP("BDFN"))=""
 ..S ^XTMP("ABM-PVP2",$J,"PRV-VST",ABMP("BDT"),ABMVDFN,ABMPRV)=""
 ..S ^XTMP("ABM-PVP2",$J,"VISITS",ABMVDFN)=1
 ..I ABMY("RTYP")="GRP" D GPTDATA
 ..I ABMY("RTYP")="SEL" D PTDATA
 ..S X1=ABMP("BDT")
 ..S X2=1
 ..D C^%DTC
 ..I X>ABMP("BEDT") S ABMDTFLG=1 Q
 ..S ABMP("BDT")=X
 Q
GRPBILL ;EP
 S ABMBILLF=1
 D CALCDTS^ABMM2PV1
 S ABMDTFLG=0
 S ABMP("BDT")=ABMP("BSDT")
 F  D  Q:ABMDTFLG=1
 .I ABMITYP="D"!((ABMITYP="K")&$D(^ABMMUPRM(1,1,"B",ABMVLOC))) D
 ..S ^XTMP("ABM-PVP2",$J,"PRV-NUM PD BILLS",ABMP("BDT"),ABMGRP,ABMVDFN,ABMP("BDFN"))=""
 ..S ^XTMP("ABM-PVP2",$J,"PRV-NUM PD DET",ABMP("BDT"),ABMGRP,ABMVDFN,ABMP("BDFN"))=ABMTRAMT
 ..S ABMBILLF=1
 .S ^XTMP("ABM-PVP2",$J,"PRV ENC CNT",ABMP("BDT"),ABMVLOC,ABMGRP)=+$G(^XTMP("ABM-PVP2",$J,"PRV ENC CNT",ABMP("BDT"),ABMVLOC,ABMGRP))+1
 .S ^XTMP("ABM-PVP2",$J,"PRV ENC CNT",ABMP("BDT"),ABMGRP)=+$G(^XTMP("ABM-PVP2",$J,"PRV ENC CNT",ABMP("BDT"),ABMGRP))+1
 .S ^XTMP("ABM-PVP2",$J,"PRV-VST",ABMP("BDT"),ABMVDFN)="",^XTMP("ABM-PVP2",$J,"VISITS",ABMVDFN)=1
 .S ^XTMP("ABM-PVP2",$J,"PRV-VST",ABMP("BDT"),ABMVDFN)="",^XTMP("ABM-PVP2",$J,"VISITS",ABMVDFN)=1
 .I (ABMCNT#1000&(IOST["C")) W "."
 .S ABMCNT=+$G(ABMCNT)+1
 .D GPTDATA
 .S X1=ABMP("BDT")
 .S X2=1
 .D C^%DTC
 .I X>ABMP("BEDT") S ABMDTFLG=1 Q
 .S ABMP("BDT")=X
 S DUZ(2)=ABMHOLD
 I +$G(ABMFOUND)=1 D GRPOTHVS  ;check for other visits on DOS to mark as paid
 Q
GRPOTHVS ;EP
 S ABMPT=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U,5)
 S (ABMDOS,ABMDOSSV)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),7)),U)
 F  S ABMDOS=$O(^XTMP("ABM-PVP2",$J,"PT VSTS",ABMPT,ABMDOS)) Q:'ABMDOS!($P(ABMDOS,".")>$P(ABMDOSSV,"."))  D
 .S ABMVCHK=0
 .F  S ABMVCHK=$O(^XTMP("ABM-PVP2",$J,"PT VSTS",ABMPT,ABMDOS,ABMVCHK)) Q:'ABMVCHK  D
 ..Q:^XTMP("ABM-PVP2",$J,"VISITS",ABMVCHK)=1  ;already counted this visit
 ..S ^XTMP("ABM-PVP2",$J,"PRV-NUM PD",ABMP("BDT"))=+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM PD",ABMP("BDT")))+1
 ..S ^XTMP("ABM-PVP2",$J,"PRV-NUM PD",ABMP("BDT"),ABMVLOC)=+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM PD",ABMP("BDT"),ABMVLOC))+1
 ..S ^XTMP("ABM-PVP2",$J,"PRV-NUM PD",ABMP("BDT"),ABMGRP)=+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM PD",ABMP("BDT"),ABMGRP))+1
 ..S ^XTMP("ABM-PVP2",$J,"VISITS",ABMVCHK)=1
 Q
OTHERVST ;EP
 S ABMPT=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U,5)
 S (ABMDOS,ABMDOSSV)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),7)),U)
 F  S ABMDOS=$O(^XTMP("ABM-PVP2",$J,"PT VSTS",ABMPT,ABMDOS)) Q:'ABMDOS!($P(ABMDOS,".")>$P(ABMDOSSV,"."))  D
 .S ABMVCHK=0
 .F  S ABMVCHK=$O(^XTMP("ABM-PVP2",$J,"PT VSTS",ABMPT,ABMDOS,ABMVCHK)) Q:'ABMVCHK  D
 ..Q:^XTMP("ABM-PVP2",$J,"VISITS",ABMVCHK)=1  ;already counted this visit
 ..S ABMPIEN=0
 ..K ABMPRVC
 ..F  S ABMPIEN=$O(^AUPNVPRV("AD",ABMVCHK,ABMPIEN)) Q:'ABMPIEN  D
 ...S ABMPRV=$$GET1^DIQ(9000010.06,ABMPIEN,.01,"I")
 ...Q:'$D(ABMPRVDR(ABMPRV))
 ...;skip provider if on visit more than once
 ...Q:$D(ABMPRVC(ABMPRV))
 ...S ABMPRVC(ABMPRV)=1
 ...D CALCDTS^ABMM2PV1
 ...S ABMDTFLG=0
 ...S ABMP("BDT")=ABMP("BSDT")
 ...F  D  Q:ABMDTFLG=1
 ....Q:$D(^XTMP("ABM-PVP2",$J,"PRV-VST",ABMP("BDT"),ABMVCHK,ABMPRV))
 ....S ^XTMP("ABM-PVP2",$J,"PRV-NUM PD",ABMP("BDT"),ABMPRV)=+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM PD",ABMP("BDT"),ABMPRV))+1
 ....S ^XTMP("ABM-PVP2",$J,"PRV-NUM PD",ABMP("BDT"),ABMPRV,ABMVLOC)=+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM PD",ABMP("BDT"),ABMPRV,ABMVLOC))+1
 ....S ^XTMP("ABM-PVP2",$J,"VISITS",ABMVCHK)=1
 ....S ^XTMP("ABM-PVP2",$J,"PRV-NUM PD",ABMP("BDT"),ABMGRP)=+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM PD",ABMP("BDT"),ABMGRP))+1
 ....S X1=ABMP("BDT")
 ....S X2=1
 ....D C^%DTC
 ....I X>ABMDOS S ABMDTFLG=1 Q
 ....S ABMP("BDT")=X
 Q
GPTDATA ;EP
 S ABMPNM=$$GET1^DIQ(2,ABMPT,.01,"E")
 I +$G(ABMINS)&(+$G(ABMEFLG)'=1) S ABMOINS=$$GET1^DIQ(9999999.18,ABMINS,.01,"E")
 E  S ABMOINS="NO BILL"
 I +$G(ABMARACT) S ABMARACT=$$GET1^DIQ(90050.01,ABMARIEN_",",3,"E")
 S:$G(ABMITYP)="" ABMITYP="X"
 I +$G(ABMTRIEN)'=0 D
 .I (+$G(ABMTRTYP)'=40)&("^113^114^121^132^137^138^139^"'[("^"_+$G(ABMADJT)_"^")) S ABMRECPD="" Q
 .I ((ABMITYP="D"!(ABMITYP="K"))&(+$G(ABMEFLG)=0)&('$D(^ABMMUPRM(1,1,"B",ABMVLOC)))!(ABMITYP="P"&($D(ABMI("INS",ABMINS)))))	S ABMRECPD="*"
 .E  S ABMRECPD=""
 I +$G(ABMTRIEN)=0 S ABMTRIEN="NOT PAID",ABMRECPD=""
 S ABMREC=ABMVDFN_U_ABMPT_U_$S(+$G(ABMTRIEN)'=0:$P($G(ABMTRIEN),"."),1:"")_U_ABMRECPD
 S ABMREC=ABMREC_U_$G(ABMBILLN)_U_$G(ABMTRAMT)_U_$G(ABMDX)
 S ^XTMP("ABM-PVP2",$J,"PT LST",ABMP("BDT"),ABMVLOC,ABMITYP,$S($G(ABMARACT)'="":ABMARACT,1:ABMOINS),$P(ABMPNM,","),$P(ABMPNM,",",2),$P($G(^AUPNVSIT(ABMVDFN,0)),U),ABMVDFN)=ABMREC
 I ($G(ABMTRIEN)'="NOT PAID")!(+$G(ABMEFLG)=1),$D(^XTMP("ABM-PVP2",$J,"PT LST",ABMP("BDT"),ABMVLOC,"X","NO BILL",$P(ABMPNM,","),$P(ABMPNM,",",2),$P($G(^AUPNVSIT(ABMVDFN,0)),U),ABMVDFN)) D
 .K ^XTMP("ABM-PVP2",$J,"PT LST",ABMP("BDT"),ABMVLOC,"X","NO BILL",$P(ABMPNM,","),$P(ABMPNM,",",2),$P($G(^AUPNVSIT(ABMVDFN,0)),U),ABMVDFN)
 Q
PTDATA ;EP
 S ABMPNM=$$GET1^DIQ(2,ABMPT,.01,"E")
 I +$G(ABMINS)&(+$G(ABMEFLG)'=1) S ABMOINS=$$GET1^DIQ(9999999.18,ABMINS,.01,"E")
 E  S ABMOINS="NO BILL"
 I +$G(ABMARACT) S ABMARACT=$$GET1^DIQ(90050.01,ABMARIEN_",",3,"E")
 S:$G(ABMITYP)="" ABMITYP="X"
 I +$G(ABMTRIEN)'=0 D
 .S ABMRECPD=""
 .I (+$G(ABMTRTYP)'=40)&("^113^114^121^132^137^138^139^"'[("^"_+$G(ABMADJT)_"^")) S ABMRECPD="" Q
 .I ((ABMITYP="D"!(ABMITYP="K"))&(+$G(ABMEFLG)=0)&('$D(^ABMMUPRM(1,1,"B",ABMVLOC)))!(ABMITYP="P"&($D(ABMI("INS",ABMINS))))) S ABMRECPD="*"
 I +$G(ABMTRIEN)=0 S ABMTRIEN="NOT PAID",ABMRECPD=""
 S ABMREC=ABMVDFN_U_ABMPT_U_$S(+$G(ABMTRIEN)'=0:$P($G(ABMTRIEN),"."),1:"")_U_ABMRECPD
 S ABMREC=ABMREC_U_$G(ABMBILLN)_U_$S($G(ABMBILLN):+$G(ABMTRAMT),1:$G(ABMTRAMT))_U_$G(ABMDX)
 S ^XTMP("ABM-PVP2",$J,"PT LST",ABMP("BDT"),ABMPRV,ABMVLOC,ABMITYP,$S($G(ABMARACT)'="":ABMARACT,1:ABMOINS),$P(ABMPNM,","),$P(ABMPNM,",",2),$P($G(^AUPNVSIT(ABMVDFN,0)),U),ABMVDFN)=ABMREC
 ;I (($G(ABMTRIEN)'="NOT PAID")&(ABMRECPD=""))!(+$G(ABMEFLG)=1),$D(^XTMP("ABM-PVP2",$J,"PT LST",ABMP("BDT"),ABMPRV,ABMVLOC,"X","NO BILL",$P(ABMPNM,","),$P(ABMPNM,",",2),$P($G(^AUPNVSIT(ABMVDFN,0)),U),ABMVDFN)) D
 I (+$G(ABMBILLN)'=0)&$D(^XTMP("ABM-PVP2",$J,"PT LST",ABMP("BDT"),ABMPRV,ABMVLOC,"X","NO BILL",$P(ABMPNM,","),$P(ABMPNM,",",2),$P($G(^AUPNVSIT(ABMVDFN,0)),U),ABMVDFN)) D
 .K ^XTMP("ABM-PVP2",$J,"PT LST",ABMP("BDT"),ABMPRV,ABMVLOC,"X","NO BILL",$P(ABMPNM,","),$P(ABMPNM,",",2),$P($G(^AUPNVSIT(ABMVDFN,0)),U),ABMVDFN)
 Q
ENROLL ;EP
 K ABMBILLN,ABMTRAMT,ABMTRIEN,ABMDX,ABMITYP
 S ABMEFLG=1
 S ABMVDFN=0
 F  S ABMVDFN=$O(^XTMP("ABM-PVP2",$J,"VISITS",ABMVDFN)) Q:'ABMVDFN  D
 .Q:(+$G(^XTMP("ABM-PVP2",$J,"VISITS",ABMVDFN))=1)  ;bill was found for visit
 .S ABMPT=$$GET1^DIQ(9000010,ABMVDFN,".05","I")
 .S (ABMP("VDT"),ABMVDT,ABMSDT)=$P($$GET1^DIQ(9000010,ABMVDFN,".01","I"),".")
 .S ABMVLOC=$$GET1^DIQ(9000010,ABMVDFN,".06","I")
 .S ABML=""
 .D ELG^ABMDLCK(ABMVDFN,.ABML,ABMPT,ABMVDT)
 .K ABMINS,ABMOINS,ABMARACT,ABMARIEN
 .S ABMPRI=0
 .S ABMVSTF=0
 .F  S ABMPRI=$O(ABML(ABMPRI)) Q:'ABMPRI  D  Q:ABMVSTF
 ..S ABMIEN=0
 ..F  S ABMIEN=$O(ABML(ABMPRI,ABMIEN)) Q:'ABMIEN  D  Q:ABMVSTF
 ...S ABMP("MDFN")=+$P(ABML(ABMPRI,ABMIEN),U)
 ...I (ABMP("MDFN")=0) Q
 ...S ABMIT=$$GET1^DIQ(9999999.181,$$GET1^DIQ(9999999.18,+ABMIEN,".211","I"),1,"I")
 ...I +$P($G(^AUPNMCD(ABMP("MDFN"),0)),U,10)'=0 S ABMIT=$$GET1^DIQ(9999999.181,$$GET1^DIQ(9999999.18,+$P($G(^AUPNMCD(ABMP("MDFN"),0)),U,10),".211","I"),1,"I")
 ...I ABMIT'="D"&(ABMIT'="K")!(ABMIT="P"&('$D(ABMI("INS",ABMIEN)))) Q  ;only Medicaid and Kidscare and Private (on the list) insurer types
 ...S ABMGRP=$S(ABMIT="D":"MCD",ABMIT="K":"CHIP",(ABMI="P"&($D(ABMI("INS",ABMIEN)))):"K",1:"OTHR")
 ...S ABMESDT=$P(ABML(ABMPRI,ABMIEN),U,2)
 ...Q:ABMESDT=""
 ...S ABMEEDT=$P($G(^AUPNMCD(ABMP("MDFN"),11,ABMESDT,0)),U,2)
 ...I ABMVDT<ABMESDT!(ABMEEDT'=""&(ABMVDT>ABMEEDT)) Q
 ...S ABMVSTF=1
 ..Q:'ABMVSTF
 ..S ABMPIEN=0
 ..K ABMPRVC
 ..F  S ABMPIEN=$O(^AUPNVPRV("AD",ABMVDFN,ABMPIEN)) Q:'ABMPIEN  D
 ...S ABMPRV=$$GET1^DIQ(9000010.06,ABMPIEN,.01,"I")
 ...Q:'$D(ABMPRVDR(ABMPRV))
 ...Q:$D(ABMPRVC(ABMPRV))
 ...S ABMPRVC(ABMPRV)=1
 ...D CALCDTS^ABMM2PV1
 ...S ABMDTFLG=0
 ...S ABMP("BDT")=ABMP("BSDT")
 ...F  D  Q:ABMDTFLG=1
 ....I ABMP("VDT")<ABMP("BSDT") Q  ;visit is before 90-day window
 ....S ^XTMP("ABM-PVP2",$J,"PRV ENC CNT",ABMP("BDT"),ABMPRV,ABMVLOC,ABMGRP)=+$G(^XTMP("ABM-PVP2",$J,"PRV ENC CNT",ABMP("BDT"),ABMPRV,ABMVLOC,ABMGRP))+1
 ....S ^XTMP("ABM-PVP2",$J,"PRV ENC CNT",ABMP("BDT"),ABMPRV,ABMGRP)=+$G(^XTMP("ABM-PVP2",$J,"PRV ENC CNT",ABMP("BDT"),ABMPRV,ABMGRP))+1
 ....S ^XTMP("ABM-PVP2",$J,"PRV-NUM ENR",ABMP("BDT"),ABMPRV,ABMGRP)=+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM ENR",ABMP("BDT"),ABMPRV,ABMGRP))+1
 ....S ^XTMP("ABM-PVP2",$J,"PRV ENC CNT",ABMP("BDT"),ABMPRV,ABMGRP)=+$G(^XTMP("ABM-PVP2",$J,"PRV ENC CNT",ABMP("BDT"),ABMPRV,ABMGRP))+1
 ....S ^XTMP("ABM-PVP2",$J,"PRV-NUM ENR",ABMP("BDT"),ABMPRV,ABMVLOC,ABMGRP)=+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM ENR",ABMP("BDT"),ABMPRV,ABMVLOC,ABMGRP))+1
 ....S ^XTMP("ABM-PVP2",$J,"PRV-NUM ENR",ABMP("BDT"),ABMGRP,ABMVLOC)=+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM ENR",ABMP("BDT"),ABMGRP,ABMVLOC))+1
 ....S ^XTMP("ABM-PVP2",$J,"PRV-NUM ENR",ABMP("BDT"),ABMGRP)=+$G(^XTMP("ABM-PVP2",$J,"PRV-NUM ENR",ABMP("BDT"),ABMGRP))+1
 ....S ^XTMP("ABM-PVP2",$J,"VISITS",ABMVDFN)=1
 ....D PTDATA
 ....S X1=ABMP("BDT")
 ....S X2=1
 ....D C^%DTC
 ....I X>ABMP("BEDT") S ABMDTFLG=1 Q
 ....S ABMP("BDT")=X
 Q
PRIMPOV ;
 S ABMDXPRI=+$O(^ABMDBILL(ABMDUZ2,ABMP("BDFN"),17,"C",0))
 S:ABMDXPRI'=0 ABMDXIEN=+$O(^ABMDBILL(ABMDUZ2,ABMP("BDFN"),17,"C",ABMDXPRI,0))
 Q:ABMDXIEN=0
 S ABMDX=$P($$DX^ABMCVAPI($P($G(^ABMDBILL(ABMDUZ2,ABMP("BDFN"),17,ABMDXIEN,0)),U),ABMSDT),U,2)
 Q