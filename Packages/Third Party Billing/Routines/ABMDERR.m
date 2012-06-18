ABMDERR ; IHS/ASDST/DMJ - ERROR PROCESSOR ;  
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; IHS/DID/DMJ - 5/6/1999 - NOIS QAA-0599-130004 Patch 1
 ;               not setting zero node under site 
 ;               multiple fixed at line EDIT+5
 ;
 Q:$D(ABMP("WORKSHEET"))
 S ABME("L")="",$P(ABME("L"),"-",80)=""
 I '$D(ABME("CHK")) W !,ABME("L")
 I $D(ABME("CHK")),$D(ABME("TITL")) W !?(80-$L(ABME("TITL"))\2),ABME("TITL"),!
 S ABME="" F ABME("I")=1:1 S ABME=$O(ABME(ABME)) Q:'ABME  D:$Y>(IOSL-5) EOP Q:$D(DUOUT)!$D(DIROUT)!$D(DQOUT)  D WRT
 I ABME("I")>1 W !,ABME("L")
 G XIT:$D(DUOUT)!$D(DIROUT)!$D(DQOUT),XIT2:$D(ABME("CONT"))
 I '$D(ABME("CHK")) D HLP
 G XIT
 ;
WRT Q:'$D(^ABMDERR(ABME,0))!'$G(ABMP("INS"))
 S ABME("COND")=$P($G(^ABMDERR(ABME,31,DUZ(2),0)),"^",3)
 I ABME("COND")="",$D(^ABMDERR(ABME,11,ABMP("INS"))) S ABME("COND")="E"
 I ABME("COND")="",'$G(ABMP("EXP")) S ABME("COND")="W"
 I ABME("COND")="",$D(^ABMDERR(ABME,21,+$G(ABMP("EXP")),0)) S ABME("COND")="E"
 S:ABME("COND")="" ABME("COND")=$P(^ABMDERR(ABME,0),"^",3)
 S:ABME("COND")="" ABME("COND")="W"
 I ABME("COND")="W",$P($G(^ABMDERR(ABME,31,DUZ(2),0)),U,4) S ABME("I")=ABME("I")-1 Q
 W !,$S(ABME("COND")="E":"  ERROR:",1:"WARNING:")
 W $E(ABME+1000,2,4)," - ",$P(^ABMDERR(ABME,0),U)
 W:$P(ABME(ABME),U)]"" " (",$P(ABME(ABME),U),")"
 I $G(ABMP("INS"))]"",$D(ABMC("CTR")) D
 .Q:ABME("COND")'="E"
 .S ABMC("CTR")=ABMC("CTR")+1
 Q
 ;
EOP D PAUSE^ABMDE1
 Q
 ;
QUE ;EP for Errors when Queued
 S ABME="" F ABME("I")=1:1 S ABME=$O(ABME(ABME)) Q:'ABME  I $P($G(^ABMDERR(ABME,31,DUZ(2),0)),U,3)="E" S ABMC("CTR")=ABMC("CTR")+1 Q
 ;
XIT K ABME
XIT2 K DIRUT,DIROUT,DUOUT Q
 ;
CNT ;EP for counting errors
 S ABME="" F ABME("I")=1:1 S ABME=$O(ABME(ABME)) Q:'ABME
 S ABM("ERR")=ABME("I")-1
 G XIT2
 ;
HLP ;EP for Correctivce Action Prompt
 K DIR W ! S DIR("A")=" Enter ERROR/WARNING NUMBER for CORRECTIVE ACTION (if Desired)",DIR(0)="FO^1:3",DIR("?")="RETURN to continue or ERROR NUMBER to display the Corrective Action"
 D ^DIR K DIR
 I $D(DIROUT)!$D(DIRUT) G XIT2
 I '$D(^ABMDERR(+Y,0)) W *7,!,"INVALID ENTRY: ",X," is not Defined in the Error File!" G HLP
 D SHOW G HLP
 ;
SHOW W !! S ABME("HD")="("_$S($P($G(^ABMDERR(+Y,31,DUZ(2),0)),U,3)="E":"ERROR:",1:"WARNING:")_X_" "_$P(^ABMDERR(+Y,0),U,1)_")" W ?(80-$L(ABME("HD"))\2),ABME("HD")
 S ABME("L")="",$P(ABME("L"),"-",80)=""
 W !,ABME("L")
 W !,"Corrective Action:"
 S ABMU("LM")=20,ABMU("RM")=79
 S ABMU("TXT")=$P(^ABMDERR(+Y,0),U,2)
 D ^ABMDWRAP
 W !,ABME("L")
 Q
 ;
LIST S ABMP("EOP")=$Y+16,Y=0 F  S Y=$O(^ABMDERR(Y)) Q:'Y  S X=Y D SHOW,EOP I $D(DUOUT)!$D(DTOUT)!$D(DIROUT) Q
 Q
EDIT ;EP - EDIT ENTRIES
 W !
 S DIC="^ABMDERR(",DIC(0)="AEMQ",DIC("S")="I '$P(^(0),""^"",5)" D ^DIC K DIC Q:Y<0  D
 .S DA(1)=+Y
 .S DIE="^ABMDERR("_DA(1)_",31,",DA=DUZ(2),DR=".03;.04"
 .S:'$D(^ABMDERR(DA(1),31,DA,0)) ^(0)=DA,^ABMDERR(DA(1),31,"B",DA,DA)=""
 .D ^DIE
 .S DA=DA(1),DR="11;21",DIE="^ABMDERR(" D ^DIE
 Q
