ABMMUPH1 ;IHS/SD/SDR - MU Patient Volume Hospital Report ;
 ;;2.6;IHS 3P BILLING SYSTEM;**7,8**;NOV 12, 2009
 ;
MET ;EP
 W !!,"Patient Volume: ",+$P($G(^XTMP("ABM-PVH",$J,"LOC TOP",ABMVLOC)),U)_"%"
 W !!,"Patient Volume for the Qualification Year was calculated using the Medicaid"
 W !,"calculation method for the hospital and includes ER encounters"
 W !!,"Total Patient Encounters "_ABMLOC_": ",?54,$J(+$G(^XTMP("ABM-PVH",$J,"LOC-DENOM",ABMSDT,ABMVLOC)),8)
 W !,"Total Medicaid Encounters "_ABMLOC_": ",?54,$J(+$G(^XTMP("ABM-PVH",$J,"LOC ENC CNT",ABMSDT,ABMVLOC,"MCD")),8)
 W !,"Total Kidscare/Chip Encounters "_ABMLOC_": ",?54,$J(+$G(^XTMP("ABM-PVH",$J,"LOC ENC CNT",ABMSDT,ABMVLOC,"CHIP")),8)
 W !,"Total Other Encounters "_ABMLOC_": ",?54,$J(+$G(^XTMP("ABM-PVH",$J,"LOC ENC CNT",ABMSDT,ABMVLOC,"OTHR")),8)
 Q
NOTMET ;EP
 W !!,"The Patient Volume Threshold (10% for Hospitals) was not met for the MU"
 W !,"Qualification year.  Details for the volumes that were achieved are provided"
 W !,"for your information."
 W !!,"Highest Patient Volume Met: ",+$P($G(^XTMP("ABM-PVH",$J,"LOC TOP",ABMVLOC)),U)
 W !,"First Day Highest Patient Volume Achieved: ",$$SDT^ABMDUTL(ABMSDT)
 W !!,"Patient Volume for the Qualification Year was calculated using the Medicaid"
 W !,"calculation method for the hospital and includes ER encounters"
 S ABMTHPV=0
 S:ABMSDT ABMTHPV=+$G(^XTMP("ABM-PVH",$J,"LOC-DENOM",ABMSDT,ABMVLOC))
 S ABMMHPV=0
 S:ABMSDT ABMMHPV=+$G(^XTMP("ABM-PVH",$J,"LOC-NUM",ABMSDT,ABMVLOC))
 W !!,"Total Patient Encounters of First Highest Patient Volume Period: ",ABMTHPV
 W !,"Total Hospital"_$S(+$G(ABMER)=1:"/ER",1:"")_" Encounters of First Highest Patient Volume Period: ",ABMMHPV
 S ABMCNT=0
 K ABMLN
 ;
 I +$G(ABMY("TVDTS"))'=0 D
 .S ABMCNT=0
 .S ABMDT=0
 .F  S ABMDT=$O(^XTMP("ABM-PVH",$J,"LOC PERCENT",ABMDT)) Q:'ABMDT  D
 ..S ABMLOC=0
 ..F  S ABMLOC=$O(^XTMP("ABM-PVH",$J,"LOC PERCENT",ABMDT,ABMLOC)) Q:'ABMLOC  D
 ...S ABMCNT=ABMCNT+1
 ...S ABMPRC($G(^XTMP("ABM-PVH",$J,"LOC PERCENT",ABMDT,ABMLOC)),ABMCNT)=ABMDT
 ...S ABMP=""
 ...S ABMSAV=ABMCNT-ABMY("TVDTS")
 ...F  S ABMP=$O(ABMPRC(ABMP)) Q:ABMP=""  D
 ....S ABMCNT=0,ABMC=0
 ....F  S ABMCNT=$O(ABMPRC(ABMP,ABMCNT)) Q:'ABMCNT  D  Q:(ABMC=ABMSAV)
 .....K ^XTMP("ABM-PVH",$J,"LOC PERCENT",$G(ABMPRC(ABMP,ABMCNT)))
 .....S ABMC=ABMC+1
 ;
 D NMHDR
 S ABMSDT=0,ABMCNT=0
 F  S ABMSDT=$O(^XTMP("ABM-PVH",$J,"LOC-DENOM",ABMSDT)) Q:'ABMSDT  D
 .;
 .;start old code abm*2.6*8 NOHEAT
 .;S X1=ABMSDT
 .;S X2=89
 .;D C^%DTC
 .;S ABMEDT=X
 .;end old code start new code
 .I +$G(ABMY("EDT"))=0 D
 ..S X1=ABMSDT
 ..S X2=89
 ..D C^%DTC
 ..S ABMEDT=X
 .I +$G(ABMY("EDT"))'=0 S ABMEDT=ABMY("EDT")
 .;end new code
 .S ABMCNT=ABMCNT+1
 .S ABMLN(ABMCNT)=$TR($P($$MDT^ABMDUTL(ABMSDT),"-",1,2),"-"," ")_" - "_$TR($P($$MDT^ABMDUTL(ABMEDT),"-",1,2),"-"," ")  ;report period
 .S $P(ABMLN(ABMCNT),U,2)=$J($G(^XTMP("ABM-PVH",$J,"LOC PERCENT",ABMSDT)),3)_"%"  ;rate
 .S $P(ABMLN(ABMCNT),U,3)=$J(+$G(^XTMP("ABM-PVH",$J,"LOC-DENOM",ABMSDT)),6)  ;denominator
 .S $P(ABMLN(ABMCNT),U,4)=$J(+$G(^XTMP("ABM-PVH",$J,"LOC-NUM",ABMSDT)),6)  ;numerator
 S ABMCUTOF=$S(ABMCNT#2=1:(ABMCNT+1)\2,1:ABMCNT\2)
 S ABMMCNT=1
 F ABMCUTOF=(ABMCUTOF+1):1:ABMCNT D
 .S ABMLN(ABMMCNT)=ABMLN(ABMMCNT)_U_ABMLN(ABMCUTOF)
 .K ABMLN(ABMCUTOF)
 .S ABMMCNT=+$G(ABMMCNT)+1
 S ABMCNT=0
 F  S ABMCNT=$O(ABMLN(ABMCNT)) Q:'ABMCNT  D  Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 .I $Y+5>IOSL D HD^ABMMUPV3,NMHDR Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 .S ABMPD=$P(ABMLN(ABMCNT),U)
 .S ABMRT=$P(ABMLN(ABMCNT),U,2)
 .S ABMDEN=$P(ABMLN(ABMCNT),U,3)
 .S ABMNUM=$P(ABMLN(ABMCNT),U,4)
 .S ABMPD2=$P(ABMLN(ABMCNT),U,5)
 .S ABMRT2=$P(ABMLN(ABMCNT),U,6)
 .S ABMDEN2=$P(ABMLN(ABMCNT),U,7)
 .S ABMNUM2=$P(ABMLN(ABMCNT),U,8)
 .W !,ABMPD,?16,ABMRT,?21,ABMDEN,?29,ABMNUM,?40,ABMPD2,?56,ABMRT2,?63,ABMDEN2,?71,ABMNUM2
 Q
NMHDR ;EP
 W !
 F ABM=1:1:80 W "="
 W !,"HOSPITAL"_$S($G(ABMER)=1:"/ER",1:"")_" PATIENT VOLUME - QUALIFICATION YEAR ",ABMY("QYR")
 W !,"Report Period",?16,"Rate",?22,"Denom-",?31,"Numer-",?40,"Report Period",?56,"Rate",?63,"Denom-",?71,"Numer-"
 W !?22,"inator",?31,"ator",?63,"inator",?71,"ator"
 W !
 F ABM=1:1:80 W "="
 Q
PATIENT ;EP
 S ABM("PG")=1
 S ABMSDT=$P($G(^XTMP("ABM-PVH",$J,"LOC TOP",ABMVLOC)),U,2)
 D HDR^ABMMUPV3
 D PTHDR
 S ABMITYP=""
 F  S ABMITYP=$O(^XTMP("ABM-PVH",$J,"PT LST",ABMSDT,ABMVLOC,ABMITYP)) Q:ABMITYP=""  D  Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 .S ABMINS=""
 .F  S ABMINS=$O(^XTMP("ABM-PVH",$J,"PT LST",ABMSDT,ABMVLOC,ABMITYP,ABMINS)) Q:ABMINS=""  D  Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 ..S ABMPTL=""
 ..F  S ABMPTL=$O(^XTMP("ABM-PVH",$J,"PT LST",ABMSDT,ABMVLOC,ABMITYP,ABMINS,ABMPTL)) Q:ABMPTL=""  D  Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 ...S ABMPTF=""
 ...F  S ABMPTF=$O(^XTMP("ABM-PVH",$J,"PT LST",ABMSDT,ABMVLOC,ABMITYP,ABMINS,ABMPTL,ABMPTF)) Q:ABMPTF=""  D  Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 ....S ABMVDT=0
 ....F  S ABMVDT=$O(^XTMP("ABM-PVH",$J,"PT LST",ABMSDT,ABMVLOC,ABMITYP,ABMINS,ABMPTL,ABMPTF,ABMVDT)) Q:'ABMVDT  D  Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 .....S ABMVDFN=0
 .....F  S ABMVDFN=$O(^XTMP("ABM-PVH",$J,"PT LST",ABMSDT,ABMVLOC,ABMITYP,ABMINS,ABMPTL,ABMPTF,ABMVDT,ABMVDFN)) Q:'ABMVDFN  D  Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 ......S ABMPT=$P($G(^XTMP("ABM-PVH",$J,"PT LST",ABMSDT,ABMVLOC,ABMITYP,ABMINS,ABMPTL,ABMPTF,ABMVDT,ABMVDFN)),U,2)
 ......S ABMTRIEN=$P($G(^XTMP("ABM-PVH",$J,"PT LST",ABMSDT,ABMVLOC,ABMITYP,ABMINS,ABMPTL,ABMPTF,ABMVDT,ABMVDFN)),U,3)
 ......S IENS=ABMVLOC_","_ABMPT_","
 ......S ABMHRN=$$GET1^DIQ(9000001.41,IENS,.02)
 ......W !,$E(ABMPTL_", "_ABMPTF,1,16)  ;pt name
 ......W ?18,ABMHRN  ;HRN
 ......W ?25,$E($$GET1^DIQ(9000010,ABMVDFN,.07,"E"),1,3)  ;Category
 ......W ?29,$E($$GET1^DIQ(9000010,ABMVDFN,.08,"E"),1,8)  ;clinic
 ......W ?39,$S(ABMITYP="X":"",1:ABMITYP)  ;insurer type
 ......W ?42,$S(ABMINS="NO BILL":"",1:$E(ABMINS,1,10))  ;insurer
 ......W ?53,$$CDT^ABMDUTL(ABMVDT)  ;visit date
 ......W ?70,$S(+ABMTRIEN:$$SDTO^ABMDUTL(ABMTRIEN),1:"") ;dt paid
 ......I $P($G(^XTMP("ABM-PVH",$J,"PT LST",ABMSDT,ABMVLOC,ABMITYP,ABMINS,ABMPTL,ABMPTF,ABMVDT,ABMVDFN)),U,4)'="" W ?79,$P(^(ABMVDFN),U,4)
 ......I $Y+5>IOSL D HD^ABMMUPV3,PTHDR Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 Q
PTHDR ;
 W !,"VISIT LOCATION: ",$$GET1^DIQ(9999999.06,ABMVLOC,.02,"E"),!
 F ABM=1:1:80 W "="
 W !,?25,"Ser",?39,"I.",?42,"Billed",?53,"Date of",?70,"Date"
 W !,"PATIENT NAME",?18,"CHART#",?25,"Cat",?29,"Clinic",?39,"T.",?42,"To",?53,"Service",?70,"Paid",!
 F ABM=1:1:80 W "="
 Q
