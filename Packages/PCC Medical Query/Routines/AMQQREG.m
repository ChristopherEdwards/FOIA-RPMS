AMQQREG ; IHS/CMI/THL - QUERY CMS REGISTER INTERFACE ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;;UTILITY TO SELECT AND UTILIZE CMS REGISTER AS SUBJECT OF A QMAN
 ;;SEARCH
 ;-----
EN N Y,AMQQ
 D EN1
EXIT K AMQQQUIT
 Q
EN1 D REG
 Q:$D(AMQQQUIT)
 D ACTIVE
 Q:$D(AMQQQUIT)
 D DX:AMQQCNAM["DIABET"
 Q:$D(AMQQQUIT)
 D COHORT
 Q
REG ;EP;TO SELECT A REGISTER
 N Y
 K AMQQRDA
 S DIC="^ACM(41.1,"
 S DIC(0)="AEMQZ"
 S DIC("S")="I $D(^ACM(41.1,+Y,""AU"",""B"",DUZ))"
 S DIC("A")="Which CMS REGISTER: "
 W !
 D DIC
 Q:$D(AMQQQUIT)
 S AMQQRDA=+Y
 S AMQQCNAM=$P(Y,U,2)_" REGISTER"
 D DECEASED^ACMGTP(AMQQRDA)
 Q
ACTIVE ;EP;TO SELECT PATIENT STATUS
 K DIR
 W !!,"Select the Patient Status for this report"
 W !!?10,"1     Active"
 W !?10,"2     Inactive"
 W !?10,"3     Transient"
 W !?10,"4     Unreviewed"
 W !?10,"5     Deceased"
 W !?10,"6     Non-IHS"
 W !?10,"7     Lost to Follow-up"
 W !?10,"8     All Register Patients"
 S DIR(0)="LO^1:8"
 S DIR("A")="Which Status(es)"
 S DIR("B")="1"
 W !
 D ^DIR
 K DIR
 I 'Y S AMQQQUIT="" Q
 I Y[8 S AMQQ("CMS STATUS","Z")="" Q
 I Y D
 .N X,Z
 .F J=1:1 S X=$P(Y,",",J) Q:X=""  D
 ..S Z=$S(X=1:"A",X=2:"I",X=3:"T",X=4:"U",X=5:"D",X=6:"N",X=7:"L",X=8:"Z",1:"")
 ..Q:Z=""
 ..S AMQQ("CMS STATUS",Z)=""
 Q
COHORT ;CREATE SEARCH TEMPLATE COHORT WITH REGISTER PATIENTS
 N X,Y,Z,AMQQDA
 D C1
 Q:$D(AMQQQUIT)
 K ^DIBT(AMQQDA,1)
 S X=0
 S CTR=0
 F  S X=$O(^ACM(41,"B",AMQQRDA,X)) Q:'X  D
 .S Z=$E($G(^ACM(41,X,"DT")))
 .Q:Z=""
 .S Y=$P($G(^ACM(41,X,0)),U,2)
 .Q:'Y
 .I $G(AMQQ("DM DIAGNOSIS"))]"" D PATDX I $D(AMQQQUIT) K AMQQQUIT Q
 .I $D(AMQQ("CMS STATUS","Z"))!$D(AMQQ("CMS STATUS",Z)) D
 ..S ^DIBT(AMQQDA,1,Y)=""
 ..W "."
 ..S CTR=CTR+1
 W !!,"There are ",CTR," register patients for the combination selected.",!
 Q
C1 ;CREATE SEARCH TEMPLATE
 K DIE,DIC,DINUM,DR,DA,DD,DO,DIK,DLAYGO
 S X=$E(AMQQCNAM,1,25)_"-"_$J
 S AMQQCHRT=X
 S DIC="^DIBT("
 S DIC(0)="L"
 I $D(^DIBT("B",X)) S Y=$O(^DIBT("B",X,0)) I Y
 E  D FILE^DICN
 K DIE,DIC,DINUM,DR,DA,DD,DO,DIK,DLAYGO
 I +Y<1 S AMQQQUIT="" Q
 S AMQQDA=+Y
 S $P(^DIBT(+Y,0),U,2)=DT
 S $P(^DIBT(+Y,0),U,4)=2
 S $P(^DIBT(+Y,0),U,5)=DUZ
 S ^UTILITY("AMQQ",$J,"Q",1)="40^COHORT^C^1^238^1^IS A MEMBER OF^'=^"_+Y_"^^0.00^^^0^"_+Y_";;^0"
 S ^UTILITY("AMQQ",$J,"LIST",.1)="W ?3,@AMQQRV,""Subject of search: PATIENTS"",@AMQQNV"
 S ^UTILITY("AMQQ",$J,"LIST",2)="W ?6,""MEMBER OF '"_AMQQCHRT_"' COHORT"""
 S ^UTILITY("AMQQ",$J,"WEIGHT",-99,1)=""
 S AMQQILIN=2
 S AMQQNOET=""
 S AMQQUATN=2
 S AMQQUNB=1
 Q
NEWREG ;EP;TO CREATE REGISTER IN QMAN DICTIONARY OF TERMS
 Q:$O(^AMQQ(5,"B","REGISTER",0))
 I $D(^AMQQ(5,"B","CMS REGISTER")) D  Q
 .S DA=$O(^AMQQ(5,"B","CMS REGISTER",0))
 .Q:'DA
 .S DIE="^AMQQ(5,"
 .S DR=".01///^S X=""REGISTER"""
 .D ^DIE
 .S Y=DA
 .K ^AMQQ(5,DA,1)
 .K DA,DR,DIE
 .D NR1
 K DIE,DIC,DINUM,DR,DA,DD,DO,DIK,DLAYGO
 S X="REGISTER"
 S DIC="^AMQQ(5,"
 S DIC(0)="L"
 S DIC("DR")="3////52;4////40;10////P"
 D FILE^DICN
 K DIE,DIC,DINUM,DR,DA,DD,DO,DIK,DLAYGO
NR1 S X="CMS REGISTER"
 S DA(1)=+Y
 S DIC="^AMQQ(5,"_+Y_",1,"
 S DIC(0)="L"
 S $P(^AMQQ(5,+Y,1,0),U,2)="9009075.01"
 D FILE^DICN
 K DIC,DA,DD,DR,DINUM,D,DLAYGO
 Q
DIC ;FM DIC INTERFACE
 Q:$D(AMQQOUT)
 K DTOUT,DUOUT,AMQQQUIT,AMQQOUT
 D ^DIC
 I +Y<1 S AMQQQUIT=""
 S:$D(DUOUT) AMQQQUIT=""
 S:$D(DTOUT)!(X="^^") (AMQQQUIT,AMQQOUT)=""
 K DIC,DA,DD,DR,DINUM,D,DLAYGO
 Q
DX ;EP;TO SELECT DIABETES DIAGNOSIS
 I $G(AMQQCNAM)["PRE-DIAB" G PREDX
 W !!,"Select the Diabetes Register Diagnosis for this report"
 S DIR(0)="SO^1:Type 1;2:Type 2;3:Type 1 & Type 2;4:Gestational DM;5:Impaired Glucose Tolerance;6:All Diagnoses"
 S DIR("A")="Which Register Diagnosis"
 S DIR("B")="All Diagnoses"
 S DIR("?",1)="Enter the appropriate REGISTER DIAGNOSIS term. This is NOT a POV's ICD code."
 S DIR("?",2)="Qman will not find patients in which the REGISTER DIAGNOSIS field is null"
 S DIR("?",3)=""
 S DIR("?",4)="If Register Diagnoses have not been assigned to all patients"
 S DIR("?",5)="in the Register or to all patients with a specific categories,"
 S DIR("?")="use '6 - All Diagnoses' to avoid misleading results."
 D ^DIR
 K DIR
 I 'Y S AMQQQUIT="" Q
 S AMQQ("DM DIAGNOSIS")=$S(Y=1:"TYPE 1",Y=2:"TYPE 2",Y=3:"TYPE 1 & TYPE 2",Y=4:"GESTATIONAL DM",Y=5:"IMPAIRED GLUCOSE TOLERANCE",1:"")
 Q
PREDX  ;EP TO SELECT PREDIABETES REGISTER DIAGNOSIS
 W !!,"Select the Diabetes Register Diagnosis for this report"
 S DIR(0)="SO^1:IMP Fasting Glucose (IFG);2:IMP Glucose Tolerance (IGT);3:Metabolic Syndrome;4:Other Abnormal Glucose;5:All Diagnoses"
 S DIR("A")="Which Register Diagnosis"
 S DIR("B")="All Diagnoses"
 S DIR("?",1)="Enter the appropriate REGISTER DIAGNOSIS term. This is NOT a POV's ICD code."
 S DIR("?",2)="Qman will not find patients in which the REGISTER DIAGNOSIS field is null"
 S DIR("?",3)=""
 S DIR("?",4)="If Register Diagnoses have not been assigned to all patients"
 S DIR("?",5)="in the Register or to all patients with a specific categories,"
 S DIR("?")="use '5 - All Diagnoses' to avoid misleading results."
 D ^DIR
 K DIR
 I 'Y S AMQQQUIT="" Q
 S AMQQ("DM DIAGNOSIS")=$S(Y=1:"IMP FASTING GLUCOSE (IFG)",Y=2:"IMP GLUCOSE TOLERANCE (IGT)",Y=3:"METABOLIC SYNDROME",Y=4:"OTHER ABNORMAL GLUCOSE",1:"")
 Q
PATDX ;INCLUDE PATIENTS WITH SPECIFIC DIAGNOSIS
 S AMQQQUIT=""
 Q:'$D(^ACM(44,"D",X))
 N Y,Z
 S Y=0
 F  S Y=$O(^ACM(44,"D",X,Y)) Q:'Y  D
 .S Z=+$G(^ACM(44,Y,0))
 .I $P($G(^ACM(44.1,+Z,0)),U)]"",AMQQ("DM DIAGNOSIS")[$P(^(0),U) K AMQQQUIT
 Q
