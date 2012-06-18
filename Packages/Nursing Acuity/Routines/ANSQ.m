ANSQ ;IHS/OIRM/DSD/CSC - TASK QUEUEING MAINLINE; [ 02/25/98  10:32 AM ]
 ;;3.0;NURSING PATIENT ACUITY;;APR 01, 1996
ZIS D ^ANSCZIS:'$D(DUOUT),^ANSEXIT
 Q
EN D EN1
EXIT K ANSTSK,ANSF,ANST,ANSPLK,ANSCOUNT
 Q
EN1 S DIR(0)="SO^1:Print for ALL Patients in a Unit;2:Print for Individual Patients"
 S DIR("?",1)="You May Print The Report For Individual Patients",DIR("?")="Or For All Patients On A Specific Unit."
 W !
 D DIR^ANSDIC
 I $D(DTOUT)!$D(DUOUT)!($G(Y)<1) S DUOUT="" Q
 I Y=1 D B1 S Y=1
 I Y=2 D A1 S Y=2
 Q
A1 S ANSJOB=$J_($P($H,",")_$P($H,",",2))
 F  D A11 Q:'$D(ANSDFN)
 Q
A11 K ANSDFN
 D ^ANSUPT
 Q:$D(DTOUT)!$D(DUOUT)
 I '$G(ANSDFN) S:'$D(^TMP("ANS",+$G(ANSJOB),"P")) DUOUT="" Q
 S ANSADM=$O(^ANSR("PT",ANSDFN,0))
 I 'ANSADM W *7,!!,"NOT Currently An Inpatient." Q
 S ^TMP("ANS",ANSJOB,"P",$E($P(^DPT(ANSDFN,0),U),1,30),ANSDFN)=ANSADM
 Q
B1 ;EP;SELECT NURSING UNIT FOR REPORT
 K ANSUNIT
 S ANSJOB=$J_($P($H,",")_$P($H,",",2))
 S Y=$P(ANSPAR,U,3),DIC="^ANSD(59.1,",DIC(0)="AQZEM",DIC("A")="Which Unit: " S:Y DIC("B")=$P(^ANSD(59.1,Y,0),U)
 W !
 D DIC^ANSDIC
 I $G(Y)<1 S DUOUT="" Q
 S ANSUNIT=+Y
 Q
ACUITY ;EP;PATIENT ACUITY REPORT
 S ANSRTN="^ANSQPS"
 S ANSZ="Patient Acuity Report"
 D HEAD
 I '$D(ANSHEAD) D EN,ZIS
 Q
HISTORY ;EP;QUEUE PATIENT ASSESSMENT HISTORY REPORT
 S ANSRTN="^ANSQPAS"
 S ANSZ="Patient Assessment History"
 D HEAD
 I '$D(ANSHEAD) D EN,ZIS
 Q
ROSTER ;EP;QUEUE NURSING UNIT ROSTER
 S ANSRTN="^ANSQRS"
 S ANSZ="Ward Roster"
 I '$D(ANSHEAD) D B1,ZIS
 Q
STAFSTAT ;EP;QUEUE NURSE STAFFING STATS
 S ANSZ="Staffing Statistics"
 I $D(ANSHEAD) D HEAD Q
 S DIR(0)="DO^:"_DT,DIR("A")="Starting Date"
 W !
 D DIR^ANSDIC
 Q:$D(DTOUT)!$D(DUOUT)!($G(Y)="")
 S ANSBDT=Y W " "_Y(0)  ;CSC 10-97
 S DIR(0)="DO^:"_DT,DIR("A")="Ending Date.."
 W !
 D DIR^ANSDIC
 Q:$D(DTOUT)!$D(DUOUT)!($G(Y)="")
 S ANSEDT=Y W " "_Y(0)  ;CSC 10-97
 S DIR(0)="YO",DIR("A")="Print For Each Shift",DIR("B")="YES"
 S DIR("?",1)="You May Print This Report For Individual Shifts or",DIR("?")="For The Whole Day.   Enter 'YES' or 'NO'"
 W !
 D DIR^ANSDIC
 Q:$D(DTOUT)!$D(DUOUT)
 S ANSPO=$S(Y=1:"S",1:"D"),ANSRTN="^ANSQSS"
 D B1,ZIS
 Q
HEAD ;EP;
 ;D ^ANSMENU
 D HEAD^ANSMENU  ;CSC 10-97
 W:$G(ANSZ)]"" !!,?80-$L(ANSZ)/2,ANSZ
 Q
