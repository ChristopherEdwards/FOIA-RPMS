ABMDVCK ; IHS/ASDST/DMJ - PCC Visit Edits ;  
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;08/19/96 4:49 PM
 ;Note special input variable ABMDFN
 ;It is optional
 ;If it is defined claims will be generated only for the one patient
 ;whose ien is the value of ABMDFN.
 ;If it is undefined claims will be generated for all patient with new
 ;PCC visits.
 ;
 ; IHS/SD/SDR - v2.5 p8
 ;    Check for uncoded Dxs on visit
 ;
 ; IHS/SD/SDR - v2.5 p8
 ;    Check PCC EHR/Chart Audit Start Date; if populated, the Chart Audit
 ;    Status will need to be checked for ea visit with a service cat or
 ;    A/O/S.  If DOS is equal or after the Audit Start Date and the status
 ;    is anything but REVIEWED the claim will not generate.
 ;
 ; IHS/SD/SDR - v2.5 p8
 ;    When inpatient, check if coding complete field is null; if so,
 ;    generate claim.
 ;
 ; IHS/SD/SDR - v2.5 p9 - IM19304
 ;    Fix supplied by Jim Gray, checking to see if variable ABMP("INS") is set
 ;
 ; IHS/SD/SDR - v2.5 p9 - Fix to Uncoded Dxs to check lag time
 ;
 ; IHS/SD/SDR - v2.5 p10 - IM21846
 ;   Made change to stop error <UNDEF>EXP+1^ABMDE2X5
 ;
 ; *********************************************************************
START ;START HERE
 I DUZ(2)="" S DUZ(2)=1
 S X="APCDCHKJ"
 X ^%ZOSF("TEST")                   ;See if rtn exists.
 I  D ^APCDCHKJ                     ;PCC linker - INPAT
 I '$D(ABMDFN) D ^APCDK             ;PCC relinker
 N ABMVDFN,ABMCPTTB,ABMDT
 S X1=DT
 S X2=-180
 D C^%DTC
 S ABM("C")=X
 ;The ^ABMDTMP("KCLM" nodes are still being set in ver 2.0 as of 8/27/96
 S ABM=0
 F  S ABM=$O(^ABMDTMP("KCLM",ABM)) Q:'ABM  Q:ABM>ABM("C")  D
 .S ABM("D")=0
 .F  S ABM("D")=$O(^ABMDTMP("KCLM",ABM,ABM("D"))) Q:'ABM("D")  D
 ..K ^ABMDTMP("KCLM",ABM,ABM("D"))
 ;These ^ABMDTMP("KBILL" nodes are not being set in version 2.0
 ;These nodes are the audit trail from ver 1.6
 ;This checking must continue for 6 months after conversion from 1.6
 S ABM=0
 F  S ABM=$O(^ABMDTMP("KBILL",ABM)) Q:'ABM  Q:ABM>ABM("C")  D
 .S ABM("D")=0
 .F  S ABM("D")=$O(^ABMDTMP("KBILL",ABM,ABM("D"))) Q:'ABM("D")  D
 ..K ^ABMDTMP("KBILL",ABM,ABM("D"))
 S U="^"
 K ABM,ABMP,ABML
 I $D(^ABMDTMP("VCK",DT)),^(DT)'=$J,'$D(ABMDFN) Q
 S:'$D(ABMDFN) ^ABMDTMP("VCK",DT)=$J
 ;Set up ABILL X-ref for parent of all added or changed I & D visits
 N V,V0,P,P0
 S ABMDT=""
 F  S ABMDT=$O(^AUPNVSIT("ABILL",ABMDT)) Q:'ABMDT  D
 .S V=""
 .F  S V=$O(^AUPNVSIT("ABILL",ABMDT,V)) Q:'V  D
 ..S V0=$G(^AUPNVSIT(V,0))
 ..S SERVCAT=$P(V0,U,7)
 ..Q:"ID"'[SERVCAT                    ;SERVCAT needs to be either I or D
 ..I $D(ABMDFN),ABMDFN'=$P(V0,U,5) Q  ;For a set patient
 ..S P=$P(V0,U,12)
 ..Q:'P
 ..S P0=$G(^AUPNVSIT(P,0))
 ..Q:"HOS"'[$P(P0,U,7)
 ..S ^AUPNVSIT("ABILL",+P0,P)=""
 I $D(ABMDFN) D SITE Q                ;For real time billing
 ;
LOOP ;LOOP THROUGH SITES
 ;Only loop through sites that are in the parameters file
 S DUZ(2)=0
 F  S DUZ(2)=$O(^ABMDPARM(DUZ(2))) Q:+DUZ(2)=0  D  Q:$G(ZTSTOP)
 .Q:$D(^ABMDPARM(DUZ(2),1))'=10
 .D SITE
 .D ^ABMDACK
 .S DIE="^ABMDPARM(DUZ(2),"
 .S DA=1
 .S DR=".21////"_DT
 .D ^ABMDDIE
 K ^ABMDTMP("VCK")
 K ABMP,ABMACTVI,ABMCOVD,ABMD,ABMPCAT,ABMPINS,ABMSRC,ABMV,DIE,DA,DR
 K SERVCAT,X,X1,X2,Y0
 Q
 ;
 ; *********************************************************************
SITE ;ONE SITE
 I '$D(ABMDFN),$P(^ABMDPARM(DUZ(2),1,0),U,19) D ^ABMDBACK
 ;
AP ;AUTO PURGE CLAIMS
 S ABM("DIF")=$S($P($G(^ABMDPARM(DUZ(2),1,2)),U,8):$P(^(2),U,8),1:180)
 S X1=DT
 S X2=-ABM("DIF")
 D C^%DTC
 S ABM("DIF")=X
 ;X-ref AC on date last edited
 I '$D(ABMDFN) D
 .F ABM("C")=0:0 S ABM("C")=$O(^ABMDCLM(DUZ(2),"AC",ABM("C"))) Q:'ABM("C")  Q:ABM("C")>ABM("DIF")  D
 ..S ABMP("CDFN")=0
 ..F  S ABMP("CDFN")=$O(^ABMDCLM(DUZ(2),"AC",ABM("C"),ABMP("CDFN"))) Q:'ABMP("CDFN")  D
 ...Q:$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),0)),"^",4)="U"
 ...Q:$D(^ABMDBILL(DUZ(2),"AS",ABMP("CDFN")))
 ...;Kill claim
 ...S DR=".04///2"
 ...D KCLM^ABMDECAN
 ;
VLP ;LOOP THROUGH VISITS IN VISIT FILE
 ;ABILL X-REF set in ABMDBACK. On date visit created
 ;ENDT is the entry date, not the end date
 S ABMP("ENDT")=""
 F  S ABMP("ENDT")=$O(^AUPNVSIT("ABILL",ABMP("ENDT"))) Q:ABMP("ENDT")=""  D  Q:$G(ZTSTOP)
 .S ABMVDFN=0
 .F  S ABMVDFN=$O(^AUPNVSIT("ABILL",ABMP("ENDT"),ABMVDFN)) Q:'ABMVDFN  D  Q:$G(ZTSTOP)
 ..S ABMODFN=ABMVDFN
 ..I $$S^%ZTLOAD S ZTSTOP=1 Q
 ..I $D(ABMDFN),'$D(^AUPNVSIT("AC",ABMDFN,ABMVDFN)) Q   ;Real time claim
 ..D V2
 ..D:$G(ABMNFLG) ^ABMEAUTO
 ..K ABMNFLG
 ..I ABMVDFN="" S ABMVDFN=ABMODFN
 ..D RESET
 K ^TMP($J,"PROC")
 K ABMDFN
 Q
 ;
 ; ********************************************************************
V2 ;CHECK VISIT (NEEDS ABMVDFN DEFINED)
 ;This entry point can be called from the debugger
 ;ABMP("V0") is the zero node of the visit file rec
 ;ABMDA is the ien of the V file source.
 N SERVCAT,ABMHIEN,ABMDISDT,ABMPARNT,ABMDA
 ;ABMP("ENDT") is the entry date or the visit date
 ;ABMP("VDT") is the visit date (.01) with the time stripped off
 Q:'$D(^AUPNVSIT(ABMVDFN,0))
 S ABMP("V0")=^AUPNVSIT(ABMVDFN,0)
 S ABMP("VDT")=$P(ABMP("V0"),U)\1
 S SERVCAT=$P(ABMP("V0"),U,7)
 ; I is an offspring of an H category.  O is more like an admission.
 ; It is not expected to be the offspring of H.
 ; ABMHIEN is the ien for the corresponding V HOSPITALIZATION entry
 S ABMHIEN=$O(^AUPNVINP("AD",ABMVDFN,0))
 S ABMDISDT=$S(ABMHIEN]"":$P(^AUPNVINP(ABMHIEN,0),U,1),1:0)
 S ABMPARNT=$P(ABMP("V0"),U,12)
 S ABMP("PRIMVSIT")=ABMVDFN
 ; I will also check the parent links to make sure these visits
 ; are being attached right.
 S ABMIFLG=$$ICDCHK^ABMDVCK3(ABMVDFN)  ;check for uncoded ICDs (.9999)
 I $G(ABMIFLG)=1 D
 .S ABMILAG=$P($G(^ABMDPARM(DUZ(2),1,5)),U,2)
 .S X1=DT
 .S X2=ABMP("VDT")
 .D ^%DTC
 .I X>ABMILAG K ABMIFLG  ;past lag time
 I $G(ABMIFLG)=1 D PCFL(59) Q  ;error for uncoded Dx
 I "ASO"[SERVCAT,($P($G(^APCCCTRL(DUZ(2),0)),U,12)'=""),($P(^APCCCTRL(DUZ(2),0),U,12)'>ABMP("VDT")),($P($G(^AUPNVSIT(ABMVDFN,11)),U,11)'="R") D PCFL(60) Q  ;EHR/Chart Audit Start Date
 I "AS"[SERVCAT D  Q
 .;If the visit has a parent and
 .;the visit is in the date range I will treat it like an I type.
 .I ABMPARNT]"",ABMP("VDT")'>ABMDISDT,ABMP("VDT")'<^AUPNVSIT(ABMPARNT,0) Q
 .Q:$D(^TMP($J,"PROC",ABMVDFN))
 .D VCHX^ABMDVCK0(ABMVDFN)
 .; Assume children of S cat visit belong to the S visit
 .Q:SERVCAT="A"
 .S ABMV=""
 .F  S ABMV=$O(^AUPNVSIT("AD",ABMVDFN,ABMV)) Q:'ABMV  D
 ..Q:$D(^TMP($J,"PROC",ABMV))
 ..I '$G(ABMP("CDFN")) D  Q
 ...;No claim created for parent visit
 ...D PCFL(30)
 ...S ^TMP($J,"PROC",ABMV)=""
 ...D KABILL(ABMV,$P(^AUPNVSIT(ABMV,0),U,2))
 ..D VCHX^ABMDVCK0(ABMV)
 ..D KABILL(ABMV,$P(^AUPNVSIT(ABMV,0),U,2))
 I "O"=SERVCAT,$P(ABMP("V0"),U,12)="" D  Q
 .Q:$D(^TMP($J,"PROC",ABMVDFN))
 .D VCHX^ABMDVCK0(ABMVDFN)
 .S ABMV=""
 .F  S ABMV=$O(^AUPNVSIT("AD",ABMVDFN,ABMV)) Q:'ABMV  D
 ..Q:$D(^TMP($J,"PROC",ABMV))
 ..I '$G(ABMP("CDFN")) D  Q
 ...;No claim created for parent visit
 ...D PCFL(30)
 ...S ^TMP($J,"PROC",ABMV)=""
 ...D KABILL(ABMV,$P(^AUPNVSIT(ABMV,0),U,2))
 ..S Y0=^AUPNVSIT(ABMV,0)
 ..I ABMP("VDT")>((+Y0)\1) D  Q
 ...Q:$P(Y0,U,7)=""!("ID"'[$P(Y0,U,7))
 ...;I visit linked to an O visit on a different date.
 ...D PCFL(26)
 ...S ^TMP($J,"PROC",ABMV)=""
 ...D KABILL(ABMV,$P(^AUPNVSIT(ABMV,0),U,2))
 ..D VCHX^ABMDVCK0(ABMV)
 ..D KABILL(ABMV,$P(^AUPNVSIT(ABMV,0),U,2))
 I "ID"[SERVCAT,ABMPARNT="" D VCHX^ABMDVCK0(ABMVDFN) Q
 I "ID"[SERVCAT S ABMP("FLAG1")=1 Q
 I "H"=SERVCAT D  Q
 .I $G(ABMHIEN)'="",($P($G(^AUPNVINP(ABMHIEN,0)),U,15)'="") D PCFL(61) Q  ;inpt coding complete?
 .N ABMF,ABMACTVI
 .I $D(^TMP($J,"PROC",ABMVDFN)) D  Q:ABMF
 ..I $P(ABMP("V0"),U,4)>23 S ABMF=0 Q
 ..I $P(ABMP("V0"),U,12)="" S ABMF=0 Q
 ..S ABMF=1
 ..;Hospitalization with a parent link.
 ..S DIE="^AUPNVSIT("
 ..S DA=ABMVDFN
 ..S DR=".04////27"
 ..D ^DIE
 .D VCHX^ABMDVCK0(ABMVDFN)
 .S ABMV=""
 .F  S ABMV=$O(^AUPNVSIT("AD",ABMVDFN,ABMV)) Q:'ABMV  D
 ..I '$G(ABMP("CDFN")) D  Q
 ...;No claim created for parent visit
 ...S DIE="^AUPNVSIT("
 ...S DA=ABMV
 ...S DR=".04////30"
 ...D ^DIE
 ...S ^TMP($J,"PROC",ABMV)=""
 ...D KABILL(ABMV,$P(^AUPNVSIT(ABMV,0),U,2))
 ..D VCHX^ABMDVCK0(ABMV)
 ..N ABMEDT,ABMD,ABMF
 ..S ABMEDT=$P(^AUPNVSIT(ABMV,0),U,2)
 ..I '$D(^AUPNVSIT("ABILL",ABMEDT,ABMV)),$D(ABMP("ENDT")) D
 ...S ABMD=+^AUPNVSIT(ABMV,0)-.3
 ...S ABMF=0
 ...S ABMDL=$S($G(ABMP("DDT"))>ABMP("ENDT"):ABMP("DDT")+.25,ABMP("ENDT")>ABMEDT:ABMP("ENDT")+.25,1:ABMEDT+10000)
 ...F  S ABMD=$O(^AUPNVSIT("ABILL",ABMD)) Q:'ABMD!(ABMD>ABMDL)  D  Q:ABMF
 ....Q:'$D(^AUPNVSIT("ABILL",ABMD,ABMV))
 ....S ABMF=1
 ....S ABMEDT=ABMD
 ..D KABILL(ABMV,ABMEDT)
 .;I need code here to check if ABMP("DDT") exists and if so
 .;ABMP("HDATE") is equal to it.  If not I need a way to redo
 .;ABMDVST4.
 .I $D(ABMP("DDT")),ABMP("HDATE")<ABMP("DDT") D
 ..N ABMCHVDT,P,I
 ..;Vars need to be set up for use by ABMDVST4
 ..S ABMCHVDT=ABMP("DDT")
 ..S P=0
 ..F  S P=$O(ABML(P)) Q:'P  D  Q:ABMP("PRI")=P
 ...S I=0
 ...F  S I=$O(ABML(P,I)) Q:'I  D  Q:ABMP("INS")=I
 ....Q:I'=ABMACTVI
 ....S ABMP("PRI")=P
 ....S ABMP("INS")=I
 ..Q:ABMP("INS")=""
 ..D DISCHRG^ABMDVSTH
 .S ABMV=""
 .F  S ABMV=$O(^AUPNVSIT("ABP",ABMVDFN,ABMV)) Q:'ABMV  D
 ..;ABMVDFN is the H visit, ABMV may be an OP visit in 3 days.
 ..S V0=^AUPNVSIT(ABMV,0)           ;Check for OP vis on admit day
 ..Q:$P(V0,U,11)                 ;Deleted visit
 ..Q:"AS"'[$P(V0,U,7)
 ..S X1=ABMP("VDT")
 ..S X2=-3
 ..D C^%DTC
 ..Q:$P(+V0,".")<X
 ..Q:$P(+V0,".")>ABMP("VDT")
 ..I '$D(ABMP("CDFN")) D  Q
 ...;No claim created for parent visit
 ...S DIE="^AUPNVSIT("
 ...S DA=ABMV
 ...S DR=".04////30"
 ...D ^DIE
 ...S ^TMP($J,"PROC",ABMV)=""
 ...D KABILL(ABMV,$P(^AUPNVSIT(ABMV,0),U,2))
 ..D VCHX^ABMDVCK0(ABMV),KABILL(ABMV,$P(^AUPNVSIT(ABMV,0),U,2))
 Q:$D(^TMP($J,"PROC",ABMVDFN))
 D VCHX^ABMDVCK0(ABMVDFN)
 Q
 ;
 ; ********************************************************************
KABILL(V,ENTDT)          ;
 I '$D(ENTDT) S ENTDT=$G(ABMP("ENDT"))
 Q:'$D(^TMP($J,"PROC",V))
 Q:$D(ABMP("LOCKFAIL"))
 Q:$G(ABMP("NOKILLABILL"))
 I $G(ENTDT),$G(ABMP("FLAG1")) K ^AUPNVSIT("ABILL",ENTDT,V)
 Q
 ;
 ; *********************************************************************
RESET ;
 D KABILL(ABMVDFN,ABMP("ENDT"))
 S ABM("ENDT")=$G(ABMP("ENDT"))
 K ABMP
 S ABMP("ENDT")=ABM("ENDT")
 K ABM,ABML,ABMI,ABMR,DA
 Q
 ;
 ; *********************************************************************
PCFL(X) ;EP-file VISIT file field .04
 S DIE="^AUPNVSIT("
 S DA=ABMVDFN
 S DR=".04////"_X
 D ^DIE
 Q
