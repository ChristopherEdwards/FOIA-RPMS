ABMRMCRD ;IHS/SD/SDR - MEDICARE PART D REPORT ;    
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;;
 ;; ABMILIST(insurer IEN)=insurer type--list of insurers for report
 ;; ABMINAME(insurer name,insurer IEN)=""--by name for display alphabetically
 ;; ABMICNT(SU,insurer name,insurer IEN)=count--count by insurer
 ;; ABMITOT(SU,"TOTAL")=total by service unit
 ;; ABMISU=(SU)=city, state of SU
 ;; ABMITOT("TOTAL")=total for report
 ;; ^TMP($J,"ABM-MCRD",Service Unit,patient IEN)--what patients have been counted
 ;; ABMIDUP=count--if patient is counted under more than one SU
 ;;
 S $P(ABMLINE,"-",79)="-"
 D MESSAGE  ;message about report
 D GETINS  ;get list of insurers we're looking for
 D DISP  ;display list
 D GETMORE  ;do they want to add others to list?
 Q:$D(DUOUT)!$D(DIROUT)!$D(DIRUT)!$D(DTOUT)
 I $G(ABMDFLG)=1 D DISP  ;display list if more added
 D ELIGDT  ;get list for what date?
 Q:$D(DUOUT)!$D(DIROUT)!$D(DIRUT)!$D(DTOUT)
 D INACT  ;include inactive/deceased pts?
 D DETAILQ  ;detail?
 Q:$D(DUOUT)!$D(DIROUT)!$D(DIRUT)!$D(DTOUT)
 D ^%ZIS Q:POP
 U IO
 D COUNTIT  ;go count data
 D OUTPUT  ;display results
 D ^%ZISC
 Q
 ;
MESSAGE ;
 W !?2,"This option will print a list of Patients who are registered at the"
 W !?2,"facility you select who are currently enrolled in a Medicare Part D"
 W !?2,"plan."
 W !!?2,"You will be asked to enter an ""As of"" date to be used in determining"
 W !?2,"those patients who are ""actively"" enrolled in a plan."
 W !!?2,"The report will be sorted alphabetically by Plan Name."
 Q
 ;
GETINS ;loop thru insurers and get ones with MD
 ;insurer type
 ;
 K ABMILIST,ABMINAME,ABMDFLG,ABMIDUP,^TMP($J,"ABM-MCRD"),ABMITOT
 K ^TMP($J,"ABM-MCRAB")
 S ABMINS=0
 F  S ABMINS=$O(^AUTNINS(ABMINS)) Q:+ABMINS=0  D
 .I $E($P($G(^AUTNINS(ABMINS,0)),U),1,2)="D-" D
 ..S ABMILIST(ABMINS)=$P($G(^AUTNINS(ABMINS,2)),U)
 ..S ABMINAME($P($G(^AUTNINS(ABMINS,0)),U),ABMINS)=""
 .I $P($G(^AUTNINS(ABMINS,2)),U)="MD" D
 ..S ABMILIST(ABMINS)=$P($G(^AUTNINS(ABMINS,2)),U)
 ..S ABMINAME($P($G(^AUTNINS(ABMINS,0)),U),ABMINS)=""
 Q
 ;
DISP ;display list of insurers
 K ABMIFLG
 W !!?2
 I +$G(ABMDFLG)=0 D
 .W "The following insurers contain the Insurer Type code of ""MD"" or contain "
 .W !?2,"""D-"" in the name of the plan:"
 W:+$G(ABMDFLG)=1 "The following insurers will be included on this report:"
 W !!
 S ABMNAME=""
 F  S ABMNAME=$O(ABMINAME(ABMNAME)) Q:ABMNAME=""  D
 .W ?10,ABMNAME
 .S ABMINS=$O(ABMINAME(ABMNAME,0))
 .S IT=$P($G(ABMILIST(ABMINS)),U)
 .W ?45,$S(IT="P":"PRIVATE",IT="MD":"MCR PART D",1:IT)
 .W !
 .S ABMIFLG=1
 I +$G(ABMIFLG)=0 D
 .W !?10,"THERE ARE NO INSURERS THAT CURRENTLY HAVE 'MD' AS THE INSURER TYPE"
 Q
 ;
GETMORE ;do they want more PI insurers?
 S DIR(0)="Y"
 S DIR("A")="Do you wish to include any other insurers?"
 S DIR("B")="N"
 D ^DIR
 K DIR
 Q:$D(DUOUT)!$D(DIROUT)!$D(DIRUT)!$D(DTOUT)
 I Y=1 D
 .S ABMDFLG=1
 .F  D  Q:($G(Y)="")!($G(X)=""&(Y<0))
 ..W !
 ..K X,Y,DIC,DR
 ..S DIC="^AUTNINS("
 ..S DIC(0)="AEMQ"
 ..S DIC("S")="I $P(^AUTNINS(Y,2),U)=""P"""  ;PIs only!
 ..D ^DIC
 ..I Y>0 D
 ...W $P(Y,U,2)
 ...S ABMILIST(+Y)=$P($G(^AUTNINS(+Y,2)),U)
 ...S ABMINAME($P(Y,U,2),+Y)=""
 Q
 ;
ELIGDT ;get list for what date-default to today
 W !
 K DIR,DIC,DIE,X,Y,DR
 S DIR(0)="D"
 S DIR("A")="Display eligibility as of what date?"
 S DIR("B")="Today"
 D ^DIR
 K DIR
 Q:$D(DUOUT)!$D(DIROUT)!$D(DIRUT)!$D(DTOUT)
 S ABMODT=+Y
 W "  ("_Y(0)_")"  ;display date selected
 Q
 ;
INACT ;include inactive/deceased pts?
 W !
 K DIR,DIC,DIE,X,Y,DR
 S DIR(0)="Y"
 S DIR("A")="Do you wish to EXCLUDE inactive and deceased patients"
 S DIR("B")="YES"
 D ^DIR
 K DIR
 Q:$D(DUOUT)!$D(DIROUT)!$D(DIRUT)!$D(DTOUT)
 I Y=1 S ABMALL=0  ;exclude
 E  S ABMALL=1  ;include all patients
 Q
DETAILQ ;
 W !
 K DIR,DIC,DIE,X,Y,DR
 S DIR(0)="Y"
 S DIR("A")="Do you wish to view detail (patients)"
 S DIR("B")="NO"
 D ^DIR
 K DIR
 Q:$D(DUOUT)!$D(DIROUT)!$D(DIRUT)!$D(DTOUT)
 I Y=1 S ABMDTAIL=1  ;detail
 E  S ABMDTAIL=0  ;summary
 Q
 ;
COUNTIT ;do counts for selected insurers
 D RAILROAD
 D MEDICARE
 D PRIVATE
 Q
 ;
RAILROAD ;
 S ABMIEN=0
 F  S ABMIEN=$O(^AUPNRRE(ABMIEN)) Q:+ABMIEN=0  D
 .S ABMEIEN=0
 .F  S ABMEIEN=$O(^AUPNRRE(ABMIEN,11,ABMEIEN)) Q:+ABMEIEN=0  D
 ..S ABMCOV=$P($G(^AUPNRRE(ABMIEN,11,ABMEIEN,0)),U,3)
 ..I ABMCOV="D" S ABMPIEN=$P($G(^AUPNRRE(ABMIEN,11,ABMEIEN,0)),U,4)
 ..I ABMCOV="D",($G(ABMPIEN)="") Q
 ..I ABMCOV="D",($G(ABMILIST(ABMPIEN))="") Q  ;no entry for insurer on requested list
 ..I ABMALL=0,($P($G(^DPT(ABMIEN,.35)),U)'="") Q  ;check exclude flag and DOD
 ..K ABMSDT,ABMEDT
 ..S ABMSDT=$P($G(^AUPNRRE(ABMIEN,11,ABMEIEN,0)),U)
 ..S ABMEDT=$P($G(^AUPNRRE(ABMIEN,11,ABMEIEN,0)),U,2)
 ..I ((ABMSDT<ABMODT)!(ABMSDT=ABMODT)),((ABMEDT>ABMODT)!(ABMEDT="")) D
 ...S ABMHRN=0
 ...F  S ABMHRN=$O(^AUPNPAT(ABMIEN,41,ABMHRN)) Q:+ABMHRN=0  D
 ....S ABMHRNS=$P($G(^AUPNPAT(ABMIEN,41,ABMHRN,0)),U,5)  ;inactive?
 ....I ABMALL=0,ABMHRN="I" Q  ;check exclude inactive flag and status
 ....S ABMSU=$S($P($G(^AUTTLOC(ABMHRN,0)),U,5)'="":$P($G(^AUTTSU($P($G(^AUTTLOC(ABMHRN,0)),U,5),0)),U),1:"NO SERVICE UNIT")  ;SU name
 ....S ABMISU(ABMSU)=$P($G(^AUTTLOC(ABMHRN,0)),U,13)_", "_$S($P($G(^AUTTLOC(ABMHRN,0)),U,14)'="":$P($G(^DIC(5,$P($G(^AUTTLOC(ABMHRN,0)),U,14),0)),U,2),1:"")
 ....S:ABMCOV="D" ABMINAME=$P($G(^AUTNINS(ABMPIEN,0)),U)  ;insurer name
 ....I ABMCOV="D",($G(^TMP($J,"ABM-MCRD",ABMSU,ABMPIEN,ABMIEN))="") D
 .....S ABMPN=$P($G(^AUPNRRE(ABMIEN,11,ABMEIEN,0)),U,6)  ;ID
 .....S ABMHRNN=$P($G(^AUPNPAT(ABMIEN,41,ABMHRN,0)),U,2)  ;HRN
 .....S ^TMP($J,"ABM-MCRD",ABMSU,ABMPIEN,ABMIEN)=ABMHRNN_U_ABMSDT_U_ABMEDT_U_ABMPN
 .....S ABMICNT(ABMSU,ABMINAME,ABMPIEN)=+$G(ABMICNT(ABMSU,ABMINAME,ABMPIEN))+1
 .....S ABMITOT(ABMSU,"TOTAL")=+$G(ABMITOT(ABMSU,"TOTAL"))+1
 .....S ABMITOT("TOTAL")=+$G(ABMITOT("TOTAL"))+1
 .....S ABMBTHCT(ABMSU,"TOTAL")=$G(ABMBTHCT(ABMSU,"TOTAL"))+1
 ....I ABMCOV="D",($G(^TMP($J,"ABM-MCRD",ABMSU,ABMPIEN,ABMIEN))'="") S ABMIDUP=+$G(ABMIDUP)+1
 ....I ABMCOV="A"!(ABMCOV="B") D  ;count patients with active A and/or B
 .....Q:$G(^TMP($J,"ABM-MCRAB",ABMSU,ABMIEN))'=""
 .....S ^TMP($J,"ABM-MCRAB",ABMSU,ABMIEN)=ABMIEN
 .....S ^TMP($J,"ABM-MCRAB",ABMSU,"TOTAL")=+$G(^TMP($J,"ABM-MCRAB",ABMSU,"TOTAL"))+1
 Q
 ;
MEDICARE ;
 S ABMIEN=0
 F  S ABMIEN=$O(^AUPNMCR(ABMIEN)) Q:+ABMIEN=0  D
 .S ABMEIEN=0
 .F  S ABMEIEN=$O(^AUPNMCR(ABMIEN,11,ABMEIEN)) Q:+ABMEIEN=0  D
 ..S ABMCOV=$P($G(^AUPNMCR(ABMIEN,11,ABMEIEN,0)),U,3)
 ..I ABMCOV="D" S ABMPIEN=$P($G(^AUPNMCR(ABMIEN,11,ABMEIEN,0)),U,4)
 ..I ABMCOV="D",($G(ABMPIEN)="") Q
 ..I ABMCOV="D",($G(ABMILIST(ABMPIEN))="") Q  ;no entry for insurer on requested list
 ..I ABMALL=0,($P($G(^DPT(ABMIEN,.35)),U)'="") Q  ;check exclude flag and DOD
 ..K ABMSDT,ABMEDT
 ..S ABMSDT=$P($G(^AUPNMCR(ABMIEN,11,ABMEIEN,0)),U)
 ..S ABMEDT=$P($G(^AUPNMCR(ABMIEN,11,ABMEIEN,0)),U,2)
 ..I ((ABMSDT<ABMODT)!(ABMSDT=ABMODT)),((ABMEDT>ABMODT)!(ABMEDT="")) D
 ...S ABMHRN=0
 ...F  S ABMHRN=$O(^AUPNPAT(ABMIEN,41,ABMHRN)) Q:+ABMHRN=0  D
 ....S ABMHRNS=$P($G(^AUPNPAT(ABMIEN,41,ABMHRN,0)),U,5)  ;inactive?
 ....I ABMALL=0,ABMHRN="I" Q  ;check exclude inactive flag and status
 ....S ABMSU=$S($P($G(^AUTTLOC(ABMHRN,0)),U,5)'="":$P($G(^AUTTSU($P($G(^AUTTLOC(ABMHRN,0)),U,5),0)),U),1:"NO SERVICE UNIT")  ;SU name
 ....S ABMSUC=$P($G(^AUTTLOC(ABMHRN,0)),U,13)
 ....S ABMSUS=$P($G(^AUTTLOC(ABMHRN,0)),U,14)
 ....S ABMISU(ABMSU)=ABMSUC_", "_$S(ABMSUS'="":$P($G(^DIC(5,ABMSUS,0)),U,2),1:"")
 ....S:ABMCOV="D" ABMINAME=$P($G(^AUTNINS(ABMPIEN,0)),U)  ;insurer name
 ....I ABMCOV="D",($G(^TMP($J,"ABM-MCRD",ABMSU,ABMPIEN,ABMIEN))="") D  ;part D and not on list already
 .....S ABMPN=$P($G(^AUPNMCR(ABMIEN,11,ABMEIEN,0)),U,6)  ;ID
 .....S ABMHRNN=$P($G(^AUPNPAT(ABMIEN,41,ABMHRN,0)),U,2)  ;HRN
 .....S ^TMP($J,"ABM-MCRD",ABMSU,ABMPIEN,ABMIEN)=ABMHRNN_U_ABMSDT_U_ABMEDT_U_ABMPN
 .....S ABMICNT(ABMSU,ABMINAME,ABMPIEN)=+$G(ABMICNT(ABMSU,ABMINAME,ABMPIEN))+1
 .....S ABMITOT(ABMSU,"TOTAL")=+$G(ABMITOT(ABMSU,"TOTAL"))+1
 .....S ABMITOT("TOTAL")=+$G(ABMITOT("TOTAL"))+1
 ....I ABMCOV="D",($G(^TMP($J,"ABM-MCRD",ABMSU,ABMPIEN,ABMIEN))'="") S ABMIDUP=+$G(ABMIDUP)+1  ;part D dup pt
 ....I ABMCOV="A"!(ABMCOV="B") D  ;count patients with active A and/or B
 .....Q:$G(^TMP($J,"ABM-MCRAB",ABMSU,ABMIEN))'=""
 .....S ^TMP($J,"ABM-MCRAB",ABMSU,ABMIEN)=ABMIEN
 .....S ^TMP($J,"ABM-MCRAB",ABMSU,"TOTAL")=+$G(^TMP($J,"ABM-MCRAB",ABMSU,"TOTAL"))+1
 Q
 ;
PRIVATE ;
 S ABMPTIEN=0
 F  S ABMPTIEN=$O(^AUPNPRVT(ABMPTIEN)) Q:+ABMPTIEN=0  D
 .S ABMIEN=0
 .F  S ABMIEN=$O(^AUPNPRVT(ABMPTIEN,11,ABMIEN)) Q:+ABMIEN=0  D
 ..S ABMINS=$P($G(^AUPNPRVT(ABMPTIEN,11,ABMIEN,0)),U)
 ..Q:$G(ABMILIST(ABMINS))=""  ;not on list
 ..S ABMSDT=$P($G(^AUPNPRVT(ABMPTIEN,11,ABMIEN,0)),U,6)
 ..S ABMEDT=$P($G(^AUPNPRVT(ABMPTIEN,11,ABMIEN,0)),U,7)
 ..I ((ABMSDT=ABMODT)!(ABMSDT<ABMODT)),((ABMEDT>ABMODT)!(ABMEDT="")) D  ;inside date range
 ...S ABMHRN=0
 ...F  S ABMHRN=$O(^AUPNPAT(ABMPTIEN,41,ABMHRN)) Q:+ABMHRN=0  D
 ....S ABMHRNS=$P($G(^AUPNPAT(ABMPTIEN,41,ABMHRN,0)),U,5)  ;inactive?
 ....I ABMALL=0,ABMHRNS="I" Q  ;check exclude inactive flag and status
 ....S ABMSU=$S($P($G(^AUTTLOC(ABMHRN,0)),U,5)'="":$P($G(^AUTTSU($P($G(^AUTTLOC(ABMHRN,0)),U,5),0)),U),1:"NO SERVICE UNIT")  ;SU name
 ....S ABMISU(ABMSU)=$P($G(^AUTTLOC(ABMHRN,0)),U,13)_", "_$S($P($G(^AUTTLOC(ABMHRN,0)),U,14)'="":$P($G(^DIC(5,$P($G(^AUTTLOC(ABMHRN,0)),U,14),0)),U,2),1:"")
 ....S ABMINAME=$P($G(^AUTNINS(ABMINS,0)),U)  ;insurer name
 ....I $G(^TMP($J,"ABM-MCRD",ABMSU,ABMINS,ABMPTIEN))="" D
 .....S:$P($G(^AUPNPRVT(ABMPTIEN,11,ABMIEN,0)),U,8)'="" ABMPN=$P($G(^AUPN3PPH($P($G(^AUPNPRVT(ABMPTIEN,11,ABMIEN,0)),U,8),0)),U,4)
 .....S ABMHRNN=$P($G(^AUPNPAT(ABMPTIEN,41,ABMHRN,0)),U,2)  ;HRN
 .....S ^TMP($J,"ABM-MCRD",ABMSU,ABMINS,ABMPTIEN)=ABMHRNN_U_ABMSDT_U_ABMEDT_U_ABMPN
 .....S ABMICNT(ABMSU,ABMINAME,ABMINS)=+$G(ABMICNT(ABMSU,ABMINAME,ABMINS))+1
 .....S ABMITOT(ABMSU,"TOTAL")=+$G(ABMITOT(ABMSU,"TOTAL"))+1
 .....S ABMITOT("TOTAL")=+$G(ABMITOT("TOTAL"))+1
 ....I $G(^TMP($J,"ABM-MCRD",ABMSU,ABMINS,ABMPTIEN))'="" S ABMIDUP=+$G(ABMIDUP)+1
 Q
 ;
OUTPUT ;
 ;make sure at minimum 0 will print for each insurer selected
 S ESCAPE=0
 S ABMSU=""
 F  S ABMSU=$O(^TMP($J,"ABM-MCRAB",ABMSU)) Q:ABMSU=""  D
 .S ABMNAME=""
 .F  S ABMNAME=$O(ABMINAME(ABMNAME)) Q:ABMNAME=""  D
 ..S ABMINS=$O(ABMINAME(ABMNAME,0))
 ..I '$D(ABMICNT(ABMSU,ABMNAME)) S ABMICNT(ABMSU,ABMNAME,ABMINS)=0
 ;
 S ABMPG=0
 S ABMSU=""
 S ABMSUOLD=""
 D HDR
 F  S ABMSU=$O(ABMICNT(ABMSU)) Q:ABMSU=""  D
 .S ABMNAME=""
 .F  S ABMNAME=$O(ABMICNT(ABMSU,ABMNAME)) Q:ABMNAME=""  D
 ..S ABMINS=0
 ..F  S ABMINS=$O(ABMICNT(ABMSU,ABMNAME,ABMINS)) Q:+ABMINS=0  D
 ...I ABMSUOLD=""!(ABMSUOLD'=ABMSU) D:ABMPG'=1 HDR D SUHDR S ABMSUOLD=ABMSU
 ...W !?2,ABMNAME
 ...S IT=$G(ABMILIST(ABMINS))
 ...W ?40,$S(IT="P":"PRIVATE",IT="MD":"MCR PART D",1:IT)
 ...W ?63,+$G(ABMICNT(ABMSU,ABMNAME,ABMINS))
 ...I $G(ABMDTAIL)=1 D DETAIL
 .W !!,?10,"TOTAL PART D FOR "_ABMSU_" SERVICE UNIT:",?63,+$G(ABMITOT(ABMSU,"TOTAL"))
 .W !,?10,"TOTAL NUMBER OF MEDICARE/RAILROAD ELIG ENROLLEES:",?63,+$G(^TMP($J,"ABM-MCRAB",ABMSU,"TOTAL"))
 ;total
 W !!,?2,"TOTAL NUMBER OF ACTIVE MEDICARE PART D ENROLLEES: "
 W ?63,+$G(ABMITOT("TOTAL")),!
 W !,"(REPORT COMPLETE)",!
 I (IOST[("C-")) Q:ESCAPE  Q:$D(IO("S"))  K DIR S DIR(0)="E" D ^DIR S ESCAPE=X=U
 ;cleanup
 K ABMICNT,ABMINAME,ABMILIST
 K ABMLINE,IT,ABMIEN,ABMEIEN,ABMPIEN,ABMNAME,ABMINAME
 K ABMIDUP
 K ABMITOT
 K ^TMP($J,"ABM-MCRD")
 K ^TMP($J,"ABM-MCRAB")
 Q
 ;
HDR ;
 W @IOF
 S ABMPG=ABMPG+1
 S Y=DT X ^DD("DD")
 W !,Y,?68,"Page ",ABMPG
 W !
 D CENTER("REGISTERED PATIENTS - ACTIVE MEDICARE PART D ENROLLEES")
 W !
 S Y=ABMODT X ^DD("DD")
 D CENTER("Actively enrolled as of "_Y)
 Q
SUHDR W !!?2,"Service Unit: ",ABMSU,"  "_$G(ABMISU(ABMSU)),!
 W !?2,"PLAN NAME",?40,"INS TYPE",?60,"COUNT"
 I $G(ABMDTAIL)=1 D
 .W !,?3,"HRN",?15,"SUBSCRIBER NAME",?45,"EFF.DT",?57,"END.DT",?69,"SUBSCR.ID"
 W !,ABMLINE,!
 Q
CENTER(X) ;EP -
 S CENTER=IOM/2
 W ?CENTER-($L(X)/2),X
 Q
DETAIL ;
 S ABMPT=0
 F  S ABMPT=$O(^TMP($J,"ABM-MCRD",ABMSU,ABMINS,ABMPT)) Q:+ABMPT=0  D
 .W !?3,$P($G(^TMP($J,"ABM-MCRD",ABMSU,ABMINS,ABMPT)),U)
 .W ?15,$P($G(^DPT(ABMPT,0)),U)
 .W ?45,$$SDT^ABMDUTL($P($G(^TMP($J,"ABM-MCRD",ABMSU,ABMINS,ABMPT)),U,2))
 .W ?57,$$SDT^ABMDUTL($P($G(^TMP($J,"ABM-MCRD",ABMSU,ABMINS,ABMPT)),U,3))
 .W ?69,$P($G(^TMP($J,"ABM-MCRD",ABMSU,ABMINS,ABMPT)),U,4)
 .I (IOST[("C-")),(($Y>IOSL)!($Y=IOSL)) Q:ESCAPE  Q:$D(IO("S"))  K DIR S DIR(0)="E" D ^DIR S ESCAPE=X=U D HDR,SUHDR
 Q
