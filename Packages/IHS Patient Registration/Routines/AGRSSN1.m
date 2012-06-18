AGRSSN1 ; IHS/ASDS/EFG - SSN COMPLIANCE REPORT FEB 6,1995 ;  
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
 K AG
 W $$S^AGVDF("IOF"),!!?13,"==================================================="
 W !?28,"SSN COMPLIANCE REPORT",!?13,"==================================================="
 W !!,"NOTE: This report might take considerable time to run, putting a large demand",!,"on the computer processor, which could adversely impact the response time on"
 W !,"other users. Thus, it is recommended that this report be queued to run at a time",!,"of limited activity. Contact your Site Manager for assistance with queueing."
 ;
 W !!!?10,"This REPORT can be limited to ACTIVE PATIENTS whom have",!?10,"had either a PCC or APC VISIT within the PAST 3 YEARS."
 W ! K DIR S DIR(0)="Y",DIR("A")="Do you wish to EXCLUDE report to ACTIVE PATIENTS ONLY",DIR("B")="Y" D ^DIR K DIR G XIT:$D(DTOUT)!$D(DUOUT),SLOC:'Y
 S AG("ACTIVE")=""
SLOC W !!!?10,"Also, the REPORT can be restricted to a SPECIFIC LOCATION."
 W ! K DIR S DIR(0)="Y",DIR("A")="Do you wish to RESTRICT report to SPECIFIC LOCATION",DIR("B")="Y" D ^DIR K DIR G XIT:$D(DTOUT)!$D(DUOUT),ZIS:'Y
 W ! S DIC(0)="QEAM",DIC="^DIC(4,",DIC("A")="Restrict Report to Select LOCATION: ",DIC("B")=DUZ(2) D ^DIC G XIT:'+Y S AG("SLOC")=+Y
 ;
ZIS W !!! S %ZIS="NQ",%ZIS("B")="",%ZIS("A")="Output DEVICE: " D ^%ZIS G:'$D(IO)!(POP) XIT
 S AG("IOP")=ION
 G:$D(IO("Q")) QUE
PRQUE ;ENTER FROM TASK MANAGER
 K ^TMP("AG-SSN1",$J)
 S AG("HD",1)="",AG("HD")="SSN COMPLIANCE REPORT by Age Distribution"
 I $D(AG("ACTIVE")) S AG("HD",1)="for PATIENTS with VISITS in the PAST 3 YEARS "
 I $D(AG("SLOC")) S AG("HD",1)=AG("HD",1)_"at "_$E($P(^DIC(4,AG("SLOC"),0),U),1,30)
 K:AG("HD",1)="" AG("HD",1) S X1=DT,X2=-(365*3) D C^%DTC S AG("CUTOFF")=X G SLOOP:$D(AG("SLOC"))
 S AG=0 F AGZ("I")=1:1 S AG=$O(^DPT(AG)) Q:'+AG  S AG("LOC")=0 F AGZ("I")=1:1 S AG("LOC")=$O(^AUPNPAT(AG,41,AG("LOC"))) Q:'+AG("LOC")  S AG("HIT")=0 D DATA
 D WRT^AGRSSN1A G XIT
SLOOP S AG=0,AG("LOC")=AG("SLOC") F AGZ("I")=1:1 S AG=$O(^DPT(AG)) Q:'+AG  S AG("HIT")=0 D DATA
 D WRT^AGRSSN1A G XIT
DATA I $D(AG("SLOC")) Q:'$D(^AUPNPAT(AG,41,AG("SLOC"),0))
 I $D(AG("ACTIVE")) D APC:'$D(^AUTTSITE(1,0)),PCC:$P(^(0),U,8)="Y",APC:'AG("HIT") Q:'AG("HIT")
 S AG("L")=$P($G(^DIC(4,AG("LOC"),0),"*** "_AG("LOC")_" ***"),U)
 S AG(0)=^DPT(AG,0),X1=DT,X2=$P(AG(0),U,3) D ^%DTC S X=X\365,X=$S(X<10:1,X<20:2,X<30:3,X<40:4,X<50:5,X<60:6,1:7),AG(1)=$S($P(AG(0),U,9)]"":1,1:0)
 I '$D(^TMP("AG-SSN1",$J,AG("L"),0)) S ^TMP("AG-SSN1",$J,AG("L"),0)=""
 S $P(^TMP("AG-SSN1",$J,AG("L"),0),U,X+7)=$P(^TMP("AG-SSN1",$J,AG("L"),0),U,X+7)+1 I AG(1) S $P(^(0),U,X)=$P(^(0),U,X)+1
 I '$D(^TMP("AG-SSN1",$J,0,0)) S ^TMP("AG-SSN1",$J,0,0)=0
 S $P(^TMP("AG-SSN1",$J,0,0),U,X+7)=$P(^TMP("AG-SSN1",$J,0,0),U,X+7)+1 I AG(1) S $P(^(0),U,X)=$P(^(0),U,X)+1
 Q
PCC S AG("P")="" F AGZ("I")=1:1 S AG("P")=$O(^AUPNVSIT("AC",AG,AG("P"))) Q:'+AG("P")  D  Q:AG("HIT")
 .I $D(^AUPNVSIT(AG("P"),0)),$P(^(0),U,6)=AG("LOC"),+^(0)>AG("CUTOFF") S AG("HIT")=1
 Q
APC S AG("P")="" F AGZ("I")=1:1 S AG("P")=$O(^AAPCRCDS("B",AG,AG("P"))) Q:'+AG("P")  D  Q:AG("HIT")
 .I $D(^AAPCRCDS(AG("P"),0)),$P(^(0),U,2)=AG("LOC"),$P(^(0),U,3)>AG("CUTOFF") S AG("HIT")=1
 Q
XIT K AG,^TMP("AG-SSN1",$J)
 I '$D(DTOUT)!'$D(DTOUT)!'$D(DIROUT),IO=IO(0),$E(IOST)="C",'$D(IO("S")) W !! S DIR(0)="FO",DIR("A")="(REPORT COMPLETE)" D ^DIR K DIR
 D ^%ZISC
 I $D(ZTQUEUED) D KILL^%ZTLOAD
 Q
QUE K IO("Q") S ZTRTN="PRQUE^AGRSSN1",ZTDESC="SSN STATS REPORT" F AG="DUZ(2)","DUZ(0)","AG(" S ZTSAVE(AG)=""
 D ^%ZTLOAD W:$D(ZTSK) !,"REQUEST QUEUED! (Task Number:",ZTSK,")",!
 K ZTSK G XIT
