AGLSSN2 ; IHS/ASDS/EFG - LISTING OF PATIENTS W/O SSN ;   
 ;;7.1;PATIENT REGISTRATION;**4**;AUG 25,2005
 ;
 ;This routine will go through VA Patient file, looking for people with
 ;SSN
 ;
PTS ;
 S DIR(0)="Y"
 S DIR("A",1)="Unless specified, ONLY ACTIVE PATIENTS will be included."
 S DIR("A")="Do you want to include inactive/deceased patients?"
 S DIR("B")="N"
 D ^DIR K DIR
 S AGPTS=Y
 Q:$D(DUOUT)!$D(DTOUT)!$D(DFOUT)
W1 W !!! S %ZIS="Q",%ZIS("B")="" D ^%ZIS G:'$D(IO)!(POP) QUIT
 S AG("ION")=ION G:$D(IO("Q")) QUE G PROC
PRQUE ;ENTER FROM TASK MANAGER
PROC ;
 K ^TMP($J)
 S AGBM=IOSL-10
 D NOW^%DTC
 S Y=X
 D DD^%DT
 S AGDATE=Y
 S D0=0
 F  S D0=$O(^DPT(D0)) Q:D0=""  D
 .;check active/inactive/deleted
 .S AGNONACT=$P($G(^AUPNPAT(D0,41,DUZ(2),0)),U,3)
 .S AGDEC=$P($G(^DPT(D0,.35)),U)
 .I AGPTS="0",$G(AGNONACT)'=""!($G(AGDEC)'="") Q
 .;check for ssn
 .S AGSSN=+$P($G(^DPT(D0,0)),U,9)
 .I $G(AGSSN)'=0 D
 ..S AGREASON=$P($G(^AUPNPAT(D0,0)),U,23)
 ..S AGNAME=$P($G(^DPT(D0,0)),U)
 ..S AGDOB=$P($G(^DPT(D0,0)),U,3)
 ..S AGHRN=$P($G(^AUPNPAT(D0,41,DUZ(2),0)),U,2)
 ..Q:AGHRN=""
 ..S:AGDOB="" AGDOB="NONE"
 ..S:AGREASON="" AGREASON="NONE"
 ..Q:AGNAME=""
 ..S ^TMP($J,AGREASON,AGNAME,AGHRN,AGDOB)=AGSSN
WRITE ;
 K AGRECS
 S AGPAGE=1
 S AGRECS=0
 S AGFLAG=0
 D HDR
 S (AGREASON,AGNAME,AGHRN,AGDOB,AGEND)=""
 F  S AGREASON=$O(^TMP($J,AGREASON)) Q:AGREASON=""  D  Q:AGEND
 .F  S AGNAME=$O(^TMP($J,AGREASON,AGNAME))  Q:AGNAME=""  D  Q:AGEND
 ..F  S AGHRN=$O(^TMP($J,AGREASON,AGNAME,AGHRN))  Q:AGHRN=""  D  Q:AGEND
 ...F  S AGDOB=$O(^TMP($J,AGREASON,AGNAME,AGHRN,AGDOB))  Q:AGDOB=""  D  Q:AGEND
 ....S AGSSN=$G(^TMP($J,AGREASON,AGNAME,AGHRN,AGDOB))
 ....I AGREASON'="NONE" S AGR=$P($G(^AUTTSSN(AGREASON,0)),U,2)
 ....I AGREASON="NONE" S AGR="Not yet verified by SSA"
 ....S:AGR="" AGR="NONE"  ;IHS/SD/TPF AG*7.1*4 NO SERVICE CALL
 ....S Y=AGDOB
 ....D DD^%DT
 ....S AGD=Y
 ....W !,AGSSN,?10,$E(AGR,1,24),?36,$E(AGNAME,1,23),?60,AGHRN,?68,AGD
 ....S AGRECS(AGR)=$G(AGRECS(AGR))+1
 ....S AGRECS=AGRECS+1
 ....I $Y>AGBM D
 .....D RTRN^AG
 .....I $D(DUOUT)!$D(DTOUT)!$D(DTOUT) S AGEND=1 G QUIT
 .....D HDR
 I 'AGEND D END
 Q
HDR U IO I IOST["C" W $$S^AGVDF("IOF")
 D CPI^AG  ;Conf. patient info thing
 W !,?64,AGDATE
 W !,?5,$P(^AUTTLOC(DUZ(2),0),U,2),?27,"LISTING OF PATIENTS WITH SSN",?70,"PAGE ",AGPAGE
 W !,"SSN",?10,"REASON CODE FOR SSN",?35,"NAME",?60,"HRN",?68,"DOB",!
 F X=1:1:80 W "="
 S AGPAGE=AGPAGE+1
 Q
END ;
 S AGR=""
 W !,"TOTAL PATIENTS WITH SSN:  ",AGRECS
 W !,"TOTALS FOR EACH REASON CODE:"
 F  S AGR=$O(AGRECS(AGR)) Q:AGR=""  D
 .W !,?5,AGR_":  ",$G(AGRECS(AGR))
 K ^TMP($J)
 K AGREASON,AGNAME,AGHRN,AGDOB
 K AGSSN,D0,AGPTS,AGBM,AGD,AGDATE,AGDEC,AGFLAG,AGIEN,AGMVDF
 K AGNONACT,AGPAGE,AGR,AGRECS
QUIT D ^%ZISC K AG
 Q
QUE K IO("Q") S ZTRTN="PRQUE^AGLSSN2",ZTDESC="LISTING OF PATIENTS WITH SSN" F AG="AG(""ION"")" S ZTSAVE("AG*")=""
 D ^%ZTLOAD W:$D(ZTSK) !,"REQUEST QUEUED!",!,"#",ZTSK G QUIT