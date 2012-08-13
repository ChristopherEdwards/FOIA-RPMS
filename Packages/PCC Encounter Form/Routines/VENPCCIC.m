VENPCCIC ; IHS/OIT/GIS - INSTALLATION TOOLS: ADD A NEW TEMPLATE FOR VER 2.5 ENTER/EDIT PCC+ CLINICS ;
 ;;2.6;PCC+;;NOV 12, 2007
 ;
 ; 
 ;
 N DIVFLAG,DIC,DIE,DA,DR,X,Y,Z,%,FLD,CNM,DIK,%Y,CIEN,NEWPG
OLD K DIR,Y
 S DIR(0)="S^1:Add a new clinic;2:Edit an existing clinic;3:Delete an existing clinic;4:Exit",DIR("A")="Your choice"
 D ^DIR K DIR
 I 'Y!(Y=4) D ^XBFMK Q
 I Y'=1 S CIEN=$$LKUP Q:CIEN=""  S CNM=$P($G(^VEN(7.95,CIEN,0)),U)
 I Y=3 D DC(CIEN) G OLD  ; DELETE A CLINIC
 I Y=2 G CSTOP  ; EDIT A CLINIC
 S DIVFLAG=0
DIV W !!,"Is the new clinic outside of your local facility and/or in a",!,"different RPMS 'division'"
 S %=2 D YN^DICN
 I %Y?1."^" G FIN
 I %=1 S DIVFLAG=1 ; MULTI-DIVISIONAL SET UP
 I 'DIVFLAG S X=0 F  S X=$O(^VEN(7.95,X)) Q:'X  S %=$P($G(^VEN(7.95,X,2)),U,4) I %,%'=$G(DUZ(2)) S DIVFLAG=2 Q
NAME ; ENTER CLINIC NAME
 W !!,"The first step is to name the clinic.",!?3
 I DIVFLAG W "Use the format '<LOCATION> - <CLINIC>'; e.g 'ANMC - PODIATRY'"
 E  W "Use a descriptive name for the clinic like 'PEDIATRICS EAST' or 'PODIATRY'"
NAME1 ; GET PCC+ CLINIC NAME
 K DIR
 S DIR("?")="Must be 3-30 uppercase letters.  Numbers, hyphen, and spaces OK also"
 S DIR(0)="FO^3:30",DIR("A")="PCC+ clinic name"
 W ! D ^DIR
 I Y?1."^"!(Y="") G FIN
 S X=$TR(Y," ","") S X=$TR(X,"-","") I X'?3.30UN W "  ??",!,DIR("?") G NAME1 ; NAME FAILED VALIDATION
 S CNM=Y
 S Z=$O(^VEN(7.95,"B",CNM,0))
 I Z W !,"This clinic already exits.  Try another name...",!!! G NAME1
 S CIEN=Z
QT ; DESTINATION QUEUE TYPE
 S DIC="^VEN(7.22,",DIC(0)="L",DLAYGO=19707.22,X=CNM
 D ^DIC I Y=-1 W !,"Session terminated..." G FIN
 S FLD(1.01)=+Y
CSTOP ; GET CLINIC STOP
 K DIC
 S DIC="^DIC(40.7,",DIC(0)="AEQM"
 S DIC("A")="Enter the RPMS 'CLINIC STOP' associated with this clinic: "
 S Z=$P($G(^VEN(7.95,+$G(CIEN),0)),U,4) I Z S DIC("B")=$P($G(^DIC(40.7,Z,0)),U)
 W ! D ^DIC I Y=-1 W !,"Session terminated..." G FIN
 S FLD(.04)=+Y
 I $G(DIVFLAG)'=1 G PG ; THE CLINIC IS IN THE LOCAL DIVISION: DUZ(2)
MRD ; MEDICAL RECORD DIVISION
 K DIC
 S DIC="^DIC(4,",DIC(0)="AEQ"
 S DIC("A")="Enter the 'MEDICAL RECORD DIVISION' of this clinic: "
 S Z=$P($G(^VEN(7.95,+$G(CIEN),2)),U,4) I Z S DIC("B")=$P($G(^DIC(4,Z,0)),U)
 W ! D ^DIC I Y=-1 W !,"Session terminated..." G FIN
 S FLD(2.04)=+Y
PG ; PRINT GROUP
 W !!,"Select the print group associated with this clinic.",!,"You may add a new one if necessary..."
 W !,"Naming convention: '<FACILITY>_<LOCATION>'; e.g., 'PIMC_PODIATRY'"
 S DIC="^VEN(7.4,",DIC(0)="AEQL",DLAYGO=19707.4
 S DIC("A")="Print group: "
 S Z=$P($G(^VEN(7.95,+$G(CIEN),2)),U) I Z S DIC("B")=$P($G(^VEN(7.4,Z,0)),U)
 W ! D ^DIC I Y=-1 W !,"Session terminated..." G FIN
 S NEWPG=$P(Y,U,3) S FLD(2.01)=+Y
 ; **********  AT THIS POINT ALL THE ESSENTIAL DATA HAS BEEN COLLECTED  *********
 I $G(CIEN) G ADD1
ADD K DIC S DIC="^VEN(7.95,",X=CNM,DIC(0)="L",DLAYGO=19707.95 ; ADD THE NEW CLINIC TO THE FILE
 D ^DIC I Y=-1 W !,"PCC+ clinic not added..." G FIN
 S CIEN=+Y
ADD1 D DIE(CIEN) ; FLUSH THE REQD FIELDS
PRV ; DEFAULT PROVIDER
 K DIC
 S %=$G(FLD(2.02)) I % S DIC("B")=$P($G(^VA(200,%,0)),U) G PRV1
 S %=$P($G(^VEN(7.95,CIEN,2)),U,2) I % S DIC("B")=$P($G(^VA(200,%,0)),U) G PRV1
 W !!,"Next, enter the default provider for this clinic."
 W !?3,"1. Create a new 'virtual provider'"
 W !?3,"2. Use an existing provider or virtual provider"
 W !?3,"3. Don't assign a default provider at this time"
 S DIR(0)="N^1:3:0",DIR("A")="Your choice",DIR("B")="2" D ^DIR
 I Y?2."^" G FIN ; PATCHED BY GIS/OIT 10/15/05 ; PCC+ 2.5 PATCH 1
 I 'Y G DTMPL
 I Y=3 G DTMPL ; SKIP PROVIDER
 I Y=2 D  G DTMPL ; USE EXISTING PROVIDER
 . S DIC="^VA(200,",DIC(0)="AEQ"
 . S %=$P($G(^VEN(7.95,CIEN,2)),U,2)
 . I $G(FLD(2.02)) S %=FLD(2.02)
 . I % S DIC("B")=$P($G(^VA(200,%,0)),U)
 . D ^DIC I Y=-1 Q
 . S FLD(2.02)=+Y ; PROVIDER
 . Q
 ; ADD A VIRTUAL PROVIDER
 W !!?3,"Naming convention for a virtual provider: <LASTNAME,FIRSTNAME>"
 W !?3,"where the lastname = facility abbreviation, and firstname = specialty."
 W !?3,"Examples: 'PIMC,PREDIATRICIAN' or 'ANMC,PODIATRIST'"
PRV1 S DIC="^VA(200,",DIC(0)="AEQL",DLAYGO=200,DIC("DR")="",DIC("A")="Default provider: "
 D ^DIC I $D(DTOUT)!(X?2."^") G FIN
 I X?1."^" G PG
 I Y=-1 W !,"No default provider identified.  Please do this later" G HS
 S FLD(2.02)=+Y
DTMPL ; DEFAULT TEMPLATE
 K DIC W !
 S DIC("A")="Default PCC+ TEMPLATE for this clinic: "
 S %=$P($G(^VEN(7.95,+$G(CIEN),2)),U,5)
 I $G(FLD(2.05)) S %=FLD(2.05)
 I % S DIC("B")=$P($G(^VEN(7.41,%,0)),U)
 S DIC="^VEN(7.41," S DIC(0)="AEQM"
 D ^DIC
 I X?2."^" G FIN
 I X=U G PRV
 I Y>0 S FLD(2.05)=+Y
HS ; HEALTH SUMMARY
 K DIC
 W !!,"Should a PCC+ health summary be printed for this clinic"
 S %=2
 S Z=$P($G(^VEN(7.95,CIEN,2)),U,13) I Z=0 S %=1
 S Z=$G(FLD(2.13)) I $L(Z),'Z S %=1
 D YN^DICN
 I %Y?2"^" G FIN
 I %Y=U G DTMPL
 S FLD(2.13)=$S(%=1:0,1:1) ; BLOCK HS PRINTING?
 I %=2 G OG
DHS K DIC
 S DIC="^APCHSCTL(",DIC(0)="AEQM" ; DEFAULT HEALTH SUMMARY
 S DIC("A")="Default health summary for this clinic: "
 S %=$P($G(^VEN(7.95,CIEN,2)),U,6)
 I $G(FLD(2.06)) S %=FLD(2.06)
 I % S DIC("B")=$P($G(^APCHSCTL(%,0)),U)
 I '$L(%),$D(^APCHSCTL("B","ADULT REGULAR")) S %="ADULT REGULAR"
 S DIC("B")=%
 D ^DIC
 I X?2."^" G FIN
 I X=U G DTMPL
 I Y>0 S FLD(2.06)=+Y
HS1 K DIC
 S DIC="^VEN(7.4,",DIC("A")="Health summary print group: ",DIC(0)="AEQ"
 S %=$P($G(^VEN(7.95,CIEN,2)),U,9)
 I $G(FLD(2.09)) S %=FLD(2.09)
 I % S DIC("B")=$P($G(^VEN(7.4,%,0)),U)
 D ^DIC
 I X?2."^" G FIN
 I X=U G HS
 I Y>0 S FLD(2.09)=+Y
OG ; PRINT OUTGUIDE?
 K DIC
 W !!,"Should an outguide be printed for this clinic"
 S %=2
 S Z=$P($G(^VEN(7.95,CIEN,2)),U,10) I Z=0 S %=1
 S Z=$G(FLD(2.1)) I $L(Z),'Z S %=1
 D YN^DICN
 I %Y?2"^" G FIN
 I %Y=U G HS1
 S FLD(2.1)=$S(%=1:0,1:1) ; BLOCK OG PRINTING?
NCI ; NURSE CHECK IN
 W !!,"Will the nurse check in module be used in this clinic"
 S %=2
 S Z=$P($G(^VEN(7.95,CIEN,4)),U) I Z=1 S %=1
 S Z=$G(FLD(4.01)) I $L(Z),Z S %=1
 D YN^DICN
 I %Y?2"^" G FIN
 I %Y=U G OG
 S FLD(4.01)=$S(%=1:1,1:0) ; USE NURSE CHECK IN MODULE?
 I %'=1 G SET
CC ; CHIEF COMPLAINT
 K DIR
 S DIR(0)="NO^1:240:0",DIR("A")="Maximum length of chief complaint"
 S DIR("B")="240"
 S Z=$G(FLD(4.02))
 I 'Z S Z=$P($G(^VEN(7.95,CIEN,4)),U,2)
 I Z S DIR("B")=Z
 S %=$NA(^VEN(7.95,CIEN)),$P(@%@(4),U)=$S(Z:0,1:1) ; PATCHED BY GIS/OIT 10/15/05 ; PCC+ 2.5 PATCH 1
 D ^DIR
 I Y?2."^" G FIN
 I Y=U G NCI
 S FLD(4.01)=$S(Y:0,1:1) ; PATCHED BY GIS/OIT 10/15/05 ; PCC+ 2.5 PATCH 1
 I Y S FLD(4.02)=Y ; CC MAX
SET D DIE(CIEN) ; FLUSH THE REST OF THE FIELDS
 W !!,?20,"!!!Congratulations!!!",!,"You have successfully defined the properties of ",CNM,"..."
 I '$G(NEWPG) G FIN
 W !,"Since you have entered a new print group, please run the PGS"
 W !,"option on the PCC+ install menu to insure synchronization"
FIN D ^XBFMK
 G OLD ; LOOP
 ;
DIE(DA) ; EP - UPDATE FILEMAN FIELDS
 N DR,DIE
 S DIE="^VEN(7.95,"
 S DR="",FLD=0
 F  S FLD=$O(FLD(FLD)) Q:'FLD  D
 . I $L(DR) S DR=DR_";"
 . S DR=DR_FLD_"////^S X=FLD("_FLD_")"
 . Q
 L +^VEN(7.95,DA):0 I  D ^DIE L -^VEN(7.95,DA)
 K FLD
 Q
 ; 
LKUP() ; EP - LOOK UP A PCC+ CLINIC
 N DIC,X,Y,CIEN
 S DIC="^VEN(7.95,"
 S DIC(0)="AEQM"
 W "PCC+ Clinic: "
 D ^DIC
 I Y=-1 S CIEN=""
 E  S CIEN=+Y
 D ^XBFMK
 Q CIEN
 ; 
DC(CIEN)  ; EP - DELETE AN EXISTING TEMPLATE
 N DA,CLNAME,%
 W !,"Are you sure you want to completely delete this PCC+ clinic"
 S %=0
 S CLNAME=$P($G(^VEN(7.95,+$G(CIEN),0)),U)
 D YN^DICN
 I %'=1 W !,"Nothing deleted..." D ^XBFMK Q
 S DA=CIEN,DIK="^VEN(7.95,"
 D ^DIK
 S DA=$O(^VEN(7.22,"B",CLNAME,0))
 I DA S DIK="^VEN(7.22," D ^DIK
 W !,"PCC+ clinic deleted..."
 D ^XBFMK
 Q
 ; 
