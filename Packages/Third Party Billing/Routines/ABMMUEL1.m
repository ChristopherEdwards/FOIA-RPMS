ABMMUEL1 ;IHS/SD/SDR - Meaningful Use Report - count patients/eligibility ;
 ;;2.6;IHS 3P BILLING SYSTEM;**12**;NOV 12, 2009;Build 187
 ;
WRTPTS ;^TMP($J,"ABM-MURPT","PTS",ABMP("PDFN"))
 W !!!,"PATIENTS PATIENTS PATIENTS PATIENTS PATIENTS"
 W !?3,"PDFN",?15,"NAME",?50,"HRN",?60,"DATE INACTIVE"
 S ABMP("PDFN")=0
 F  S ABMP("PDFN")=$O(^TMP($J,"ABM-MURPT","PTS",ABMP("PDFN"))) Q:'ABMP("PDFN")  D
 .W !?3,ABMP("PDFN"),?15,$P($G(^DPT(ABMP("PDFN"),0)),U),?50,$P($G(^AUPNPAT(ABMP("PDFN"),41,DUZ(2),0)),U,2),?60,$$SDT^ABMDUTL($P($G(^AUPNPAT(ABMP("PDFN"),41,DUZ(2),0)),U,3))
 ;
 ;^TMP($J,"ABM-MURPT","UNQ",ABMPT)
 W !!!,"UNIQUE PATIENTS UNIQUE PATIENTS UNIQUE PATIENTS UNIQUE PATIENTS UNIQUE PATIENTS"
 W !?3,"PDFN",?15,"NAME",?50,"HRN"
 S ABMP("PDFN")=0
 F  S ABMP("PDFN")=$O(^TMP($J,"ABM-MURPT","UNQ",ABMP("PDFN"))) Q:'ABMP("PDFN")  D
 .W !?3,ABMP("PDFN"),?15,$P($G(^DPT(ABMP("PDFN"),0)),U),?50,$P($G(^AUPNPAT(ABMP("PDFN"),41,DUZ(2),0)),U,2)
 Q
 ;
WRTELIG ;
 ;^TMP($J,"ABM-MURPT","MCD",ABMP("PDFN"),ABMP("MDFN"))
 W !!!,"MEDICAID MEDICAID MEDICAID MEDICAID MEDICAID MEDICAID MEDICAID "
 W !?3,"PDFN",?15,"NAME",?50,"MCD#",?62,"PLAN"
 S ABMP("PDFN")=0
 F  S ABMP("PDFN")=$O(^TMP($J,"ABM-MURPT","MCD",ABMP("PDFN"))) Q:'ABMP("PDFN")  D
 .S ABMP("MDFN")=0
 .F  S ABMP("MDFN")=$O(^TMP($J,"ABM-MURPT","MCD",ABMP("PDFN"),ABMP("MDFN"))) Q:'ABMP("MDFN")  D
 ..W !?3,ABMP("PDFN"),?15,$P($G(^DPT(ABMP("PDFN"),0)),U),?50,$P($G(^AUPNMCD(ABMP("MDFN"),0)),U,3),?62,$P($G(^AUPNMCD(ABMP("MDFN"),0)),U,10)
 ;
 ;^TMP($J,"ABM-MURPT","MCR",ABMP("PDFN"),ABMP("MDFN"))
 W !!!,"MEDICARE MEDICARE MEDICARE MEDICARE MEDICARE MEDICARE MEDICARE MEDICARE "
 W !?3,"PDFN",?15,"NAME",?50,"MCR#"
 S ABMP("PDFN")=0
 F  S ABMP("PDFN")=$O(^TMP($J,"ABM-MURPT","MCR",ABMP("PDFN"))) Q:'ABMP("PDFN")  D
 .S ABMP("MDFN")=0
 .F  S ABMP("MDFN")=$O(^TMP($J,"ABM-MURPT","MCR",ABMP("PDFN"),ABMP("MDFN"))) Q:'ABMP("MDFN")  D
 ..W !?3,ABMP("PDFN"),?15,$P($G(^DPT(ABMP("PDFN"),0)),U),?50,$P($G(^AUPNMCR(ABMP("PDFN"),0)),U,3)
 ;
 ;^TMP($J,"ABM-MURPT","RR",ABMP("PDFN"),ABMP("MDFN"))
 W !!!,"RAILROAD RAILROAD RAILROAD RAILROAD RAILROAD RAILROAD RAILROAD RAILROAD "
 W !?3,"PDFN",?15,"NAME",?50,"RR#"
 S ABMP("PDFN")=0
 F  S ABMP("PDFN")=$O(^TMP($J,"ABM-MURPT","RR",ABMP("PDFN"))) Q:'ABMP("PDFN")  D
 .S ABMP("MDFN")=0
 .F  S ABMP("MDFN")=$O(^TMP($J,"ABM-MURPT","RR",ABMP("PDFN"),ABMP("MDFN"))) Q:'ABMP("MDFN")  D
 ..;W !?3,ABMP("PDFN"),?15,$P($G(^DPT(ABMP("PDFN"),0)),U),?50,$P($G(^AUPNRRE(ABMP("PDFN"),0)),U,3)  ;abm*2.6*12 HEAT120278
 ..W !?3,ABMP("PDFN"),?15,$P($G(^DPT(ABMP("PDFN"),0)),U),?50,$P($G(^AUTTRRP($P($G(^AUPNRRE(ABMP("PDFN"),0)),U,3),0)),U)_$P($G(^AUPNRRE(ABMP("PDFN"),0)),U,4)  ;abm*2.6*12 HEAT120278
 ;
 ;start new abm*2.6*11 VMBP#9 RQMT_103
 ;^TMP($J,"ABM-MURPT","VMBP",ABMP("PDFN"),ABMP("MDFN"))
 W !!!,"VMBP VMBP VMBP VMBP VMBP VMBP VMBP VMBP VMBP VMBP VMBP VMBP VMBP VMBP "
 W !?3,"PDFN",?15,"NAME",?50,"VA#"
 S ABMP("PDFN")=0
 F  S ABMP("PDFN")=$O(^TMP($J,"ABM-MURPT","VAMB",ABMP("PDFN"))) Q:'ABMP("PDFN")  D
 .S ABMP("MDFN")=0
 .F  S ABMP("MDFN")=$O(^TMP($J,"ABM-MURPT","VAMB",ABMP("PDFN"),ABMP("MDFN"))) Q:'ABMP("MDFN")  D
 ..W !?3,ABMP("PDFN"),?15,$P($G(^DPT(ABMP("PDFN"),0)),U),?50,$P($G(^AUPNVAMB(ABMP("PDFN"),0)),U,6)
 ;end new VMBP#9 RQMT_103
 ;
 ;^TMP($J,"ABM-MURPT","PI",ABMP("PDFN"),ABMP("MDFN"))
 W !!!,"PRIVATE PRIVATE PRIVATE PRIVATE PRIVATE PRIVATE PRIVATE PRIVATE PRIVATE "
 W !?3,"PDFN",?15,"NAME",?50,"INS",?62,"MEM#"
 S ABMP("PDFN")=0
 F  S ABMP("PDFN")=$O(^TMP($J,"ABM-MURPT","PI",ABMP("PDFN"))) Q:'ABMP("PDFN")  D
 .S ABMP("MDFN")=0
 .F  S ABMP("MDFN")=$O(^TMP($J,"ABM-MURPT","PI",ABMP("PDFN"),ABMP("MDFN"))) Q:'ABMP("MDFN")  D
 ..W !?3,ABMP("PDFN"),?15,$P($G(^DPT(ABMP("PDFN"),0)),U),?50,$P($G(^AUPNPRVT(ABMP("PDFN"),11,ABMP("MDFN"),0)),U),?62,$P($G(^AUPNPRVT(ABMP("PDFN"),11,ABMP("MDFN"),2)),U)
 ;
 ;^TMP($J,"ABM-MURPT","NO",ABMP("PDFN"))
 W !!!,"NOT INSURED NOT INSURED NOT INSURED NOT INSURED NOT INSURED NOT INSURED "
 W !?3,"PDFN",?15,"NAME"
 S ABMP("PDFN")=0
 F  S ABMP("PDFN")=$O(^TMP($J,"ABM-MURPT","NO",ABMP("PDFN"))) Q:'ABMP("PDFN")  D
 .W !?3,ABMP("PDFN"),?15,$P($G(^DPT(ABMP("PDFN"),0)),U)
 Q
 ;
WRTVSTS ;^TMP($J,"ABM-MURPT","ENC",ABMP("VDFN"))
 W !!!,"VISITS VISITS VISITS VISITS VISITS VISITS VISITS VISITS VISITS "
 W !?3,"VDFN",?13,"VISIT",?30,"PDFN",?40,"PATIENT"
 S ABMP("VDFN")=0
 F  S ABMP("VDFN")=$O(^TMP($J,"ABM-MURPT","ENC",ABMP("VDFN"))) Q:'ABMP("VDFN")  D
 .W !?3,ABMP("VDFN"),?13,$P($G(^AUPNVSIT(ABMP("VDFN"),0)),U),?30,$P($G(^AUPNVSIT(ABMP("VDFN"),0)),U,5),?40,$P($G(^DPT($P($G(^AUPNVSIT(ABMP("VDFN"),0)),U,5),0)),U)
 Q