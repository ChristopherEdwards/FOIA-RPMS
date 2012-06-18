SROUTL ;BIR/ADM - Utility Routine ; [ 05/04/00  8:32 AM ]
 ;;3.0; Surgery ;**58,62,69,77,50,88,94**;24 Jun 93
 ;
 ; Reference to $P(^SC(SRLOC,0),"^",17) supported by DBIA #964
 ;
 Q
HDR ; display menu header
 Q:'$D(SRSITE)
 N DFN,SRCNT,SRNUM,SRSDATE,SRX,Y S (SRCNT,SRX)=0 F  S SRX=$O(^SRO(133,SRX)) Q:'SRX  I '$P($G(^SRO(133,SRX,0)),"^",21) S SRCNT=SRCNT+1
 I SRCNT>1 S SRNUM=$$GET1^DIQ(4,SRSITE("DIV"),99) S Y="Division: "_SRSITE("SITE")_"  ("_SRNUM_")" W @IOF,!,?(80-$L(Y)\2),Y
 I $G(SRTN) D
 .S DFN=$P(^SRF(SRTN,0),"^") D DEM^VADPT S Y=$E($P(^SRF(SRTN,0),"^",9),1,7) X ^DD("DD") S SRSDATE=Y
 .W:SRCNT'>1 @IOF W:SRCNT>1 !! W " "_VADM(1)_" ("_VA("PID")_")   Case #"_SRTN_" - "_SRSDATE
 Q
CLINIC(SRLOC,SRCASE)         ; active count clinic screen for cases
 N SRCLIN,SRX,SRY,SRZ S SRZ=$S(SRCASE:$P(^SRF(SRCASE,0),U,9),1:DT) D SC I 'SRCLIN Q 0
 Q 1
ACTCLIN(SRLOC)     ; active count clinic screen
 N SRCLIN,SRX,SRY,SRZ S SRZ=DT D SC I 'SRCLIN Q 0
 Q 1
SC N SRKL S SRCLIN=1 S SRKL=$$GET1^DIQ(44,SRLOC,2.1) I SRKL'="CLINIC"!($P(^SC(SRLOC,0),"^",17)="Y") S SRCLIN=0 Q
 S SRX=$P($G(^SC(SRLOC,"I")),"^") I 'SRX Q
 S SRY=$P($G(^SC(SRLOC,"I")),U,2) I SRZ'<SRX,((SRY="")!(SRZ<SRY)) S SRCLIN=0
 Q
INOUT ; select in/out-patient status choice for report
 K DIR S DIR("A",1)="Print "_$S($D(SRRPT):SRRPT,1:"report")_" for",DIR("A",2)="",DIR("A",5)="  I - Inpatient cases only",DIR("A",4)="  O - Outpatient cases only",DIR("A",3)="  A - All cases"
 S DIR("A",6)="",DIR("A")="Select Letter (I, O or A): ",DIR("B")=$S($D(SRB):SRB,1:"A")
 S DIR(0)="SAM^A:All Cases;O:Outpatient Cases Only;I:Inpatient Cases Only" D ^DIR K DIR I $D(DTOUT)!$D(DUOUT) S SRSOUT=1 Q
 S SRIO=Y
 Q
DATE(SRSD,SRED,SRQ)  ; starting and ending date utility (pass by reference)
 ; The following variables are returned
 ;  SRSD - starting date
 ;  SRED - ending date
 ;  SRQ  - user interrupt
 S (SRSD,SRED,SRQ)=0 W ! F  D  Q:SRED'<SRSD!SRQ
 .K %DT S %DT="AEPX",%DT("A")="Start with Date: " D ^%DT I Y<1 S SRQ=1 Q
 .S SRSD=Y
 .K %DT S %DT="AEPX",%DT("A")="End with Date: " D ^%DT I Y<1 S SRQ=1 Q
 .I Y<SRSD W !!,"The ending date must be later than the starting date.",!
 .S SRED=Y
 Q
SPEC ; select surgical specialty
 W @IOF,! S DIR("?",1)="Enter YES if you would like the report printed for all Surgical Specialties",DIR("?")="or enter NO to select a specific specialty."
 S DIR("A")="Do you want the report for all Surgical Specialties ? ",DIR("B")="YES",DIR(0)="YA" D ^DIR K DIR I $D(DTOUT)!$D(DUOUT) S SRSOUT=1 Q
 I 'Y W ! K DIC S DIC=137.45,DIC(0)="QEAMZ",DIC("A")="Select Surgical Specialty: ",DIC("S")="I '$P(^(0),""^"",3)" D ^DIC K DIC S:Y<0 SRSOUT=1 Q:Y<0  S SRSPEC=+Y,SRSPECN=$P(Y(0),"^")
 Q
PROC ; put procedures and CPT code in array for display
 N SRDA,X,Y K SRPROC S K=1,Y=$P(^SRF(SRTN,"OP"),"^",2),Y=$S(Y:$P($$CPT^ICPTCOD(Y),"^",2),1:"???") I Y'="???" D SSPRIN^SROCPT
 S X=$P(^SRF(SRTN,"OP"),"^")_" (CPT Code: "_Y_")" I $L(X)<(SRL+1) S SRPROC(K)=X,K=K+1 G OTH
 D FORMAT
OTH S SRDA=0 F  S SRDA=$O(^SRF(SRTN,13,SRDA)) Q:'SRDA  D
 .S Y=$P($G(^SRF(SRTN,13,SRDA,2)),"^"),Y=$S(Y:$P($$CPT^ICPTCOD(Y),"^",2),1:"???")
 .I Y'="???" D SSOTH^SROCPT
 .S X=$P(^SRF(SRTN,13,SRDA,0),"^")_" (CPT Code: "_Y_")"
 .I $L(X)<(SRL+1) S SRPROC(K)=X,K=K+1 Q
 .D FORMAT
 Q
FORMAT I $L(X)>SRL F  D  I $L(X)<(SRL+1) S SRPROC(K)=X,K=K+1 Q
 .F I=0:1:(SRL-1) S J=SRL-I,Y=$E(X,J) I Y=" " S SRPROC(K)=$E(X,1,J-1),X=$E(X,J+1,$L(X)) S K=K+1 Q
 Q
DIAG ; check diagnosis input for required space in every 31 characters
 Q:$L(X)<31  N SRC,SRBL,SRDIAG,SRFLG
 S SRDIAG=X,SRFLG=0 F  D  Q:SRFLG!($L(SRDIAG)'>30)
 .S SRBL=$F(SRDIAG," ") I SRBL>32!('SRBL) S SRFLG=1 K X Q
 .S SRDIAG=$E(SRDIAG,SRBL,$L(SRDIAG))
 I '$D(X) D
 .S SRC(1)="Answer must contain at least one space in every 31 characters of length.",SRC(1,"F")="!!?5",SRC(2)="If you are using a comma (,) to separate information, leave a space after",SRC(2,"F")="!?5"
 .S SRC(3)="it.  Please re-enter the diagnosis.",SRC(3,"F")="!?5" D EN^DDIOL(.SRC)
 Q
PRE94 ; pre-install process for patch SR*3*94
 K DA,DIK S DIK="^DD(130.17,",DA=.01,DA(1)=130.17 D ^DIK K DA,DIK
 S DIK="^DD(130.18,",DA=.01,DA(1)=130.18 D ^DIK K DA,DIK
 Q
