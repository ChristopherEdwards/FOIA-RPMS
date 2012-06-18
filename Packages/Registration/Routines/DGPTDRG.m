DGPTDRG ;ALB/ABS - DRG Information Report User Prompts ; 3/12/02 4:44pm
 ;;5.3;Registration;**60,441**;Aug 13, 1993
 S U="^" D Q,DT^DICRW
PAT W !!,"Choose Patient from PATIENT file" S %=1 D YN^DICN G Q:%=-1
 I %Y["?"!('%) W !?3,"Enter <RET> for YES if you want DRGs for a patient from your PATIENT File",!?3,"Answer 'N' for NO if you want DRGs for a hypothetical patient" G PAT
 S DGPTHOW=% I %=2 S NAME="" G AGE
 N DOB S DIC="^DPT(",DIC(0)="AEQMZ" W ! D ^DIC G Q:Y'>0 S DFN=+Y,NAME=$P(Y(0),"^"),(DOB,AGE)=$P(Y(0),U,3),SEX=$P(Y(0),U,2),X1=DT,X2=AGE D ^%DTC S AGE=X\365.25 W "  AGE:",AGE
 ;I AGE<0!(AGE>124) W !,"Unacceptable AGE",!,"Grouper accepts age values from 0-124 years.",!,"Verify patient's age in PATIENT File before continuing." G Q
 S DGEXP=$S($D(^DPT(DFN,.35))#2:1,1:0) I DGEXP,'$P(^(.35),"^") S DGEXP=0
 G EXP:DGEXP,TRS
AGE R !!,"Patient's AGE: ",AGE:DTIME G Q:AGE["^"!('$T) S:AGE<0!(AGE="")!(AGE>124)!(AGE'?.N) AGE="?" I AGE["?" W !,"Enter a number for patient's age in years (0-124)" G AGE
SEX R !!,"Patient's SEX: MALE// ",X:DTIME G Q:X["^"!('$T) S Z="^MALE^FEMALE" I X="" S X="M" W X
 D IN^DGHELP I %=-1 W !?3,"Enter <RET> for MALE if hypothetical patient is male",!?3,"Enter 'F' for Female" G SEX
 S SEX=$E(X)
EXP W !!,"Did patient die during this episode" S %=2 D YN^DICN G Q:%=-1 I %Y["?"!('%) W !?3,"Enter <RET> for NO if patient did not die during the hospital",!?15,"stay for which this DRG is to be calculated",!?3,"Enter 'Y' for YES" G EXP
 S DGEXP=$S(%=1:1,1:0) I DGEXP S (DGTRS,DGDMS)=0 G DX
TRS W !!,"Transfer to an acute care facility" S %=2 D YN^DICN G Q:%=-1 I %Y["?"!('%) W !?3,"Enter <RET> for NO if patient not transfered to an acute care facility",!?3,"Enter 'Y' for YES if patient was transfered to acute care facility" G TRS
 S DGTRS=$S(%=1:1,1:0)
DMS W !!,"Discharged against medical advice" S %=2 D YN^DICN G Q:%=-1 I %Y["?"!('%) W !?3,"Enter <RET> for NO if patient did not leave against medical advice",!?3,"Enter 'Y' for YES if patient did leave against medical advice",!,*7 G DMS
 S DGDMS=$S(%=1:1,1:0)
DX S (DGDX,DGSURG)="",DIC="^ICD9(",DIC(0)="AEQMZ",DIC("A")="Enter DXLS: ",DIC("S")="I '$P(^ICD9(+Y,0),U,4)" W ! D ^DIC G Q:X["^"!(Y'>0) S:'$P(Y(0),U,9) DGDX=+Y,DGDX(1)=$P(Y(0),"^")_"^"_$P(Y(0),"^",3) I $P(Y(0),U,9) D INAC G DX
 S DIC("A")="Enter SECONDARY diagnosis: " K DIC("S") W !
 F DGI=2:1:5 D ^DIC Q:X["^"!(X="")  I +Y>0 S:'$P(Y(0),U,9) DGDX=DGDX_"^"_+Y,DGDX(DGI)=$P(Y(0),"^")_"^"_$P(Y(0),"^",3) I $P(Y(0),U,9) D INAC S DGI=DGI-1
 G Q:X["^" S DIC("S")="I '$P(^ICD0(+Y,0),U,9)",DIC="^ICD0(",DIC("A")="Enter Operation/Procedure: " W ! F DGI=1:1:4 D ^DIC Q:X["^"!(X="")  I +Y>0 S DGSURG=+Y_"^"_DGSURG,DGSURG(DGI)=$P(Y(0),"^")_"^"_$P(Y(0),"^",4)
 ; added next line for DG*5.3*441
 S DGSURG=U_DGSURG
 G Q:X["^" I $D(DGPTODR) S DGVAR="AGE^NAME^SEX^DGDMS^DGEXP^DGTRS^DGDX#^DGSURG#",DGPGM="^DGPTODR" W ! D ZIS^DGUTQ G:POP Q U IO D ^DGPTODR,CLOSE^DGUTQ,Q S DGPTODR=1 G PAT
 S DGDRGPRT=1 D ^DGPTICD,Q G PAT
Q K DFN,DGI,DGPGM,AGE,NAME,DGDMS,DGDX,DGEXP,DGPTHOW,DGSURG,DGTRS,DGVAR,DGDRGPRT,DRG,DIC,SEX,POP,X,Y,Z,X1,X2,%,%Y Q
 ;
INAC ;
 W !,*7,">>> You have selected an INACTIVE diagnosis code."
 W !,"    This code is not used by the grouper and may cause"
 W !,"    the case to be grouped into DRG 470 - UNGROUPABLE.",!
 W !,"    Therefore, this diagnosis code will NOT be passed"
 W !,"    to the grouper. Please enter another code."
