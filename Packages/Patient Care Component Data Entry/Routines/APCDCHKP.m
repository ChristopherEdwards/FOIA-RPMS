APCDCHKP ; IHS/CMI/LAB - I-LINK REPORT ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;IHS/ANMC/LJF 8/4/97 modified for ANMC use
 ;
 U IO
 S APCDPG=0,%DT="",X="T" D ^%DT X ^DD("DD") S APCDDT=Y
HIT ; Write report of In-hospital visits that were linked
 S APCDT="HIT"
 D HEAD I '$D(^XTMP("ILINK",$J,"HIT")) W !!,"NO In-Hospital Visits were linked to Hospitalizations during this run." G NO
 S APCDH="" F  S APCDH=$O(^XTMP("ILINK",$J,"HIT",APCDH)) Q:APCDH'=+APCDH  D:$Y>(IOSL-8) HEAD W !!,"HOSPITAL:" D PRNH,HIT2
NO ;
 S APCDT="NO"
 G:'$D(^XTMP("ILINK",$J,"NOHIT")) OLD
 D HEAD S APCDI="" F  S APCDI=$O(^XTMP("ILINK",$J,"NOHIT",APCDI)) Q:APCDI'=+APCDI  D:$Y>(IOSL-6) HEAD W ! D PRNI
OLD ;
 S APCDT="OLD"
 G:'$D(^XTMP("ILINK",$J,"ONEYR")) MULT
 D HEAD S APCDI="" F  S APCDI=$O(^XTMP("ILINK",$J,"ONEYR",APCDI)) Q:APCDI'=+APCDI  D:$Y>(IOSL-6) HEAD W ! D PRNI
MULT ;
 S APCDT="MULT"
 D HEAD S APCDI=0 F  S APCDI=$O(^XTMP("ILINK",$J,"TWOHITS",APCDI)) Q:APCDI'=+APCDI  D:$Y>(IOSL-8) HEAD W ! D PRNI,GETHOSP
 I '$D(^XTMP("ILINK",$J,"TWOHITS")) W !,"NO PROBLEMS",!
PROC ; print deleted procedures
 S APCDT="PROC"
 Q:'$D(^XTMP("ILINK",$J,"PROC ERROR"))
 D HEAD^APCDCHKP S APCDI="" F  S APCDI=$O(^XTMP("ILINK",$J,"PROC ERROR",APCDI)) Q:APCDI=""  S APCDPDFN=^XTMP("ILINK",$J,"PROC ERROR",APCDI) D:$Y>(IOSL-6) HEAD^APCDCHKP D PRNP
EOJ ;
 W:$D(IOF) @IOF
 K APCDIV,APCDRD,APCDHV,APCDH,APCDV,APCDI,APCDDCD,APCDHV,APCDRD
 K X,Y,APCDPG,APCDT
 Q
PRNP ;
 S APCDIV=^AUPNVSIT($P(APCDPDFN,U,3),0) S:'$P(APCDIV,U,6) $P(APCDIV,U,6)=0
 S Y=+APCDIV X ^DD("DD") S APCDRD=Y
 W !,"IN-HOSP:  DATE: [",APCDRD,"] NAME: [",$P(^DPT($P(APCDIV,U,5),0),U),"]  TYPE: [",$P(APCDIV,U,3),"]"
 W !,"          LOCATION: [",$S($D(^DIC(4,$P(APCDIV,U,6),0)):$P(^(0),U),1:"UNKNOWN"),"] DEPENDENT ENTRY CNT: [",$P(APCDIV,U,9),"]"
 ;W !?10,"Procedure: ",$P(^ICD0($P(APCDPDFN,U),0),U),?30,"Provider Narr: ",$P(^AUTNPOV($P(APCDPDFN,U,4),0),U)
 W !?10,"Procedure: ",$P($$ICDOP^ICDCODE($P(APCDPDFN,U),$$VD^APCLV($P(APCDPDFN,U,3))),U,2),?30,"Provider Narr: ",$P(^AUTNPOV($P(APCDPDFN,U,4),0),U)
 Q
PRNH ;
 S APCDHV=^AUPNVSIT(APCDH,0) S:'$P(APCDHV,U,6) $P(APCDHV,U,6)=0 S APCDTYPE=$P(APCDHV,U,3)
 S APCDINPD=0
 I APCDTYPE="C" S APCDINPD=$O(^AUPNVCHS("AD",APCDH,APCDINPD)) I APCDINPD]"" S APCDDCD=$P(^AUPNVCHS(APCDINPD,0),U,7)
 I APCDTYPE'="C" S APCDINPD=$O(^AUPNVINP("AD",APCDH,APCDINPD)) I APCDINPD]"" S APCDDCD=$P(^AUPNVINP(APCDINPD,0),U)
 S:APCDDCD]"" Y=APCDDCD X ^DD("DD") S APCDDCD=Y
 S Y=+APCDHV X ^DD("DD") S APCDRD=Y
 W " DATE: [",APCDRD,"] NAME: [",$P(^DPT($P(APCDHV,U,5),0),U),"]  TYPE: [",$P(APCDHV,U,3),"]"
 W !,"          LOCATION: [",$S($D(^DIC(4,$P(APCDHV,U,6),0)):$P(^(0),U),1:"UNKNOWN"),"] DISCH DATE: [",APCDDCD,"]"
 Q
PRNI ;
 S APCDIV=^AUPNVSIT(APCDI,0) S:'$P(APCDIV,U,6) $P(APCDIV,U,6)=0
 S Y=+APCDIV X ^DD("DD") S APCDRD=Y
 W !,"IN-HOSP:  DATE: [",APCDRD,"] NAME: [",$P(^DPT($P(APCDIV,U,5),0),U),"]  TYPE: [",$P(APCDIV,U,3),"]"
 W !,"          LOCATION: [",$S($D(^DIC(4,$P(APCDIV,U,6),0)):$P(^(0),U),1:"UNKNOWN"),"] DEPENDENT ENTRY CNT: [",$P(APCDIV,U,9),"]"
 Q
HIT2 S APCDI="" F  S APCDI=$O(^XTMP("ILINK",$J,"HIT",APCDH,APCDI)) Q:APCDI'=+APCDI  D:$Y>(IOSL-4) HEAD D PRNI
 Q
MULTSUB ;
 W !,"The following In-Hospital Visits could be linked to two or more ",!,"Hospitalizations.  They must be linked manually."
 Q
GETHOSP ;
 S APCDH=0 F  S APCDH=$O(^XTMP("ILINK",$J,"TWOHITS",APCDI,APCDH)) Q:APCDH'=+APCDH  W !,"HOSPITALIZATION:" D PRNH
 Q
HEAD ;EP;HEADER
 I 'APCDPG G HEAD1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!($D(DTOUT)) S APCDQUIT="" Q
HEAD1 ;
 W:$D(IOF) @IOF S APCDPG=APCDPG+1
 W !,APCDDT,?70,"Page: ",APCDPG
 W !?29,"PCC Data Entry Module"
 W !?9,"*************************************************************"
 W !?9,"*  REPORT OF IN-HOSPITAL VISITS LINKED TO HOSPITALIZATIONS  *"
 W !?9,"*************************************************************"
 S X="",$P(X,"-",80)="" W !!,X
 D @(APCDT_"SUB")
 W !,X
 Q
NOSUB ;
 W !,"In-Hospital Visits that remain NOT linked to a Hospitalization"
 Q
OLDSUB ;
 W !,"The following List of IN-HOSPITAL Visits are over one year old and are",!,"not linked to a Hospitalization.  These visits will not be displayed on",!,"future reports."
 Q
HITSUB ; Sub heading for Linked visit report
 W !,"The following In-Hospital Visits were linked to the Hospitalization listed"
 Q
 ;
PROCSUB ;
 W !,"Because they were duplicates, the following V Procedure Records were deleted",!,"from the IN-HOSPITAL record displayed."
 Q
