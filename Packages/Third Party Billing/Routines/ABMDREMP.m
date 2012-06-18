ABMDREMP ; IHS/ASDST/DMJ - Employer File Report ; 
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;03/25/96 11:32 AM
 ;
 K ABM,ABMY S ABM("SYN")=0
 W !!,"This program generates a listing of the Employees for each Employer, sorted",!,"in alphabetic order."
 W ! K DIR S DIR(0)="Y",DIR("A")="Do you wish the Run the Program",DIR("B")="Y" D ^DIR K DIR G XIT:'Y
 S ABM("HD",0)="" D HD^ABMDRHD
 D ZIS^ABMDRUTL G XIT:'$D(IO)!$G(POP)!$D(DTOUT)!$D(DUOUT)
 S ABM("HD",0)="EMPLOYEE LISTING for All EMPLOYERS"
 S ABM("SUBR")="ABM-EMP"
 G:$D(IO("Q")) QUE
 ;
PRQUE ;EP - Entry Point for Taskman
 S IOP=ABM("IOP") D ^%ZIS Q:$G(POP)  U IO S ABM("PG")=0 D HDB
 S ABM="" F  S ABM=$O(^AUPNPAT("AF",ABM)) Q:ABM=""  S ABM("D")=0 D
 .F  S ABM("D")=$O(^AUPNPAT("AF",ABM,ABM("D"))) Q:'ABM("D")  D
 ..Q:'$D(^AUTNEMPL(ABM,0))!'$D(^AUPNPAT(ABM("D"),0))
 ..S ^TMP("ABM-EMP",$J,$P(^AUTNEMPL(ABM,0),U),$P(^DPT(ABM("D"),0),U),$S('$D(DUZ(2)):0,1:+$P($G(^AUPNPAT(ABM("D"),41,DUZ(2),0)),U,2)))=""
 ;
 S ABM("E")=""
 S ABM("Z")="TMP(""ABM-EMP"","_$J,ABM="^"_ABM("Z")_")" I '$D(@ABM) G XIT
 F  S ABM=$Q(@ABM) Q:ABM'[ABM("Z")  D  G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 .S ABM("T")=$P(ABM,"ABM-E",2),ABM("EMP")=$P($P(ABM("T"),",",3,99),"""",2)
 .S ABM("PAT")=$P($P(ABM("T"),",",4,99),"""",2)
 .S ABM("HRN")=$P($P($P($P(ABM("T"),",",5,99),"""",2),")"),",",2)
 .I $Y>(IOSL-5) D HD Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 .I ABM("E")'=ABM("EMP") W !!,$P(ABM("EMP"),U) S ABM("E")=ABM("EMP")
 .E  W !
 .W ?32,ABM("PAT"),?64,ABM("HRN")
 G XIT
HD D PAZ^ABMDRUTL Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)  S ABM("E")=""
HDB W $$EN^ABMVDF("IOF") S ABM("PG")=ABM("PG")+1 D WHD^ABMDRHD
 W !,"Employer",?32,"Employee",?65,"HRN"
 W !,"-------------------------------------------------------------------------------"
 Q
 ;
XIT D POUT^ABMDRUTL,^%ZISC
 Q
 ;
QUE S ZTRTN="PRQUE^ABMDREMP",ZTDESC="EMPLOYEE LISTING"
 D QUE^ABMDRUTL
 G XIT
