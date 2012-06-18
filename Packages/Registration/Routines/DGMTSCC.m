DGMTSCC ;ALB/RMO,CAW,LBD - Means Test Screen Completion ; 7/11/02 3:02pm
 ;;5.3;Registration;**33,45,130,438,332,433,462,456**;Aug 13, 1993
 ;
 ; Input  -- DFN      Patient IEN
 ;           DGMTACT  Means Test Action
 ;           DGMTDT   Date of Test
 ;           DGMTYPT  Type of Test 1=MT 2=COPAY
 ;           DGMTPAR  Annual Means Test Parameters
 ;           DGVINI   Veteran Individual Annual Income IEN
 ;           DGVIRI   Veteran Income Relation IEN
 ;           DGVPRI   Veteran Patient Relation IEN
 ;           DGMTNWC  Net Worth Calculation flag
 ; Output -- DGERR    1=INCOMPLETE and 0=COMPLETE
 ;
EN N DGCAT,DGCOMF,DGDC,DGDET,DGIN0,DGIN1,DGIN2,DGINT,DGINTF,DGMTS,DGNC,DGND,DGNWT,DGNWTF,DGREF1,DGSP,DGTYC,DGTHA,DGTHB,DGVIR0,DGCOPS,DGCOST,DGTHG
 S DGERR=0
 I DGMTACT="ADD" D COM I 'Y!($D(DTOUT))!($D(DUOUT)) G Q
 S DGCOMF=1 D DEP^DGMTSCU2,INC^DGMTSCU3
 I 'DGINTF,'DGNWTF S DGREF1="" D REF G Q:$D(DTOUT)!($D(DUOUT))
 D CAT^DGMTSCU2,STA^DGMTSCU2
 D CHK I DGERR W !?3,*7,$S(DGMTYPT=1:"Means",1:"Copay")_" test cannot be completed." G Q
 I DGMTYPT=1,DGTYC="M",(DGNWT-DGDET)+$S(DGMTNWC:0,1:DGINT)'<$P(DGMTPAR,"^",8) D ADJ G Q:$D(DTOUT)!($D(DUOUT))
 I DGMTYPT=2,DGCAT="P" D ADJ G Q:$D(DTOUT)!($D(DUOUT))
 S DA=DGMTI,DIE="^DGMT(408.31,",DIE("NO^")="",DR="[DGMT ENTER/EDIT COMPLETION]" D ^DIE K DA,DIE,DR I '$D(DGFIN) S DGERR=1 G Q
 I DGMTACT="EDT",DGMTDT>DT D
 .N DATA S (DATA(.01),DATA(.07))=DT,DATA(2)=1 I $$UPD^DGENDBS(408.31,DGMTI,.DATA)
 W:DGMTYPT=1 !?3,"...means test status is ",$P($$MTS^DGMTU(DFN,DGMTS),"^"),"..."
 W:DGMTYPT=2 !?3,"...copay test status is ",$S(DGCAT="E":"EXEMPT",DGCAT="M":"NON-EXEMPT",DGCAT="P":"PENDING ADJUDICATION",1:"INCOMPLETE"),"..."
 D PRT
 ;
Q K DGFIN,DGREF,DTOUT,DUOUT,Y
 Q
 ;
COM ;Check if user wants to complete the means test
 N DIR
 S DIR("A")="Do you wish to complete the "_$S(DGMTYPT=1:"means",1:"copay exemption")_" test"
 S DIR("B")="YES",DIR(0)="Y" D ^DIR
 ; The following was added for LTC Copay Phase II (DG*5.3*433)
 I DGMTYPT=4,'Y D
 .W !,"NOTE: If you do not complete the LTC copay exemption test, the incomplete test",!?6,"will be deleted."
 .S DIR("A")="Do you wish to complete the copay exemption test"
 .S DIR("B")="YES",DIR(0)="Y" D ^DIR
 Q
 ;
REF ;Check if patient declines to provide income information
 N DIR,Y
 S DIR("A")="DECLINES TO GIVE INCOME INFORMATION"
 I $P($G(^DGMT(408.31,DGMTI,0)),"^",14)]"" S DIR("B")=$$YN^DGMTSCU1($P(^(0),"^",14))
 S DIR(0)="408.31,.14" D ^DIR K DIR G REFQ:$D(DTOUT)!($D(DUOUT))
 S:Y DGREF="" Q:'$D(DGREF)!($D(DGREF1))!(DGMTYPT'=1)  S DGCAT="C" D STA^DGMTSCU2
REFQ Q
 ;
CHK ;Check if means test can be completed
 N DGA,DGD,DGDEP,DGREL,DGL,DGM,I
 D GETREL^DGMTU11(DFN,"CS",$$LYR^DGMTSCU1(DGMTDT),$S($G(DGMTI):DGMTI,1:""))
 S DGM=$P(DGVIR0,"^",5),DGL=$P(DGVIR0,"^",6),DGA=$P(DGVIR0,"^",7),DGD=$P(DGVIR0,"^",8)
 I DGM']""!(DGM&(DGL']""))!(DGM&('DGL)&(DGA']"")) W !?3,"Marital section must be completed." S DGERR=1
 I DGM,'$D(DGREL("S")),'$D(DGREF) W !?3,"Married is 'YES'.  An active spouse for this means test does not exist." S DGERR=1
 I 'DGM,$D(DGREL("S")) W !?3,"An active spouse exists for this means test. Married should be 'YES'." S DGERR=1
 I DGD']"" W !?3,"Dependent Children section must be completed." S DGERR=1
 I DGD,'$D(DGREL("C")) W !?3,"Dependent Children is 'YES'.  No active children exist." S DGERR=1
 I 'DGD,$D(DGREL("C")) W !?3,"Active children exist.  Dependent Children should be 'YES'." S DGERR=1
 I DGMTYPT=1,'$D(DGREF),DGTYC="M",'DGNWTF W !?3,"A status of ",$$GETNAME^DGMTH(DGMTS)," requires property information." S DGERR=1
 I DGMTYPT=2,'DGNWTF,DGCAT="E",$$ASKNW^DGMTCOU W !?3,"Patient is in an 'EXEMPT' status and requires property information." S DGERR=1
 I DGDET>DGINT W !?3,"Patient's deductible expenses cannot exceed income." S DGERR=1
 Q:$G(DGERR)
 N CNT,ACT,DGDEP,FLAG,DGINCP
 D INIT^DGDEP S CNT=0 D
 .F  S CNT=$O(DGDEP(CNT)) Q:'CNT  I $P(DGDEP(CNT),U,2)="SPOUSE" D  Q:$G(DGERR)
 ..D GETIENS^DGMTU2(DFN,$P(DGDEP(CNT),U,20),DGMTDT)
 ..S DGINCP=$G(^DGMT(408.22,+DGIRI,"MT")) S:DGINCP FLAG=$G(FLAG)+1
 ..I $G(FLAG)>1 W !?3,"Patient has more than one spouse for this means test." S DGERR=1
 Q
 ;
ADJ ;Adjudicate the means test
 N DIR,Y
 S DIR("?",1)="Since assets exceed the threshold, the "_$S(DGMTYPT=1:"means",1:"copay")_" test can"
 S DIR("?",2)="be sent to adjudication.  If the "_$S(DGMTYPT=1:"means",1:"copay")_" test is not"
 S DIR("?")="adjudicated, the patient will be placed in "_$S(DGMTYPT=1&(DGTHG>DGTHA):"GMT Copay Required",DGMTYPT=1:"MT Copay Required",1:"Non-exempt")_" status."
 S DIR("A")="Do you wish to send this case to adjudication"
 S DIR("B")="YES",DIR(0)="Y" D ^DIR G ADJQ:$D(DTOUT)!($D(DUOUT))
 S DGCAT=$S(Y:"P",DGMTYPT=1&(DGTHG>DGTHA):"G",DGMTYPT=1:"C",1:"N") D STA^DGMTSCU2
ADJQ Q
 ;
PRT ;Print the means test 10-10F
 N DIR,Y
 S DIR("A")="PRINT 10-10F"
 S DIR("B")="YES",DIR(0)="Y" D ^DIR G PRTQ:'Y!($D(DTOUT))!($D(DUOUT))
 D QUE
PRTQ Q
 ;
QUE ;Ask device and queue output
 I '$D(DGIO(10)) W !!,*7,"THIS OUTPUT REQUIRES 132 COLUMN OUTPUT TO THE PRINTER.",! S %ZIS="QM",%ZIS("B")="",IOP="Q" D ^%ZIS G Q:POP I IO=IO(0),$E(IOST,1,2)="C-" W !,*7,"CANNOT QUEUE TO HOME DEVICE!",! G QUE
 K:$D(IO("Q")) IO("Q")
 S ZTRTN="START^DGMTP",ZTDTH=$H,ZTDESC="Print 10-10F"
 F I="DFN","DGMTI","DGMTDT","DGMTYPT" S ZTSAVE(I)=""
 S ZTIO=$S($D(DGIO(10)):DGIO(10),1:ION) D ^%ZTLOAD
 W !,$S($D(ZTSK):"REQUEST QUEUED!",1:"REQUEST CANCELLED!")
 K ZTDTH,ZTIO,ZTRTN,ZTSAVE,ZTSK
 Q
