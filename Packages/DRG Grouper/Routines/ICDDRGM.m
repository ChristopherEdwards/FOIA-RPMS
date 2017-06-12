ICDDRGM ;ALB/GRR/EG/ADL - Grouper Driver ;04/21/2014
 ;;18.0;DRG Grouper;**7,36,57**;Oct 20, 2000;Build 7
 ;
 ; ADL  Add Date prompt and passing of effective date for DRG CSV project
 ; ADL  Update DIC("S") code to screen using new function calls
 ; ADL  Update to access DRG file using new API for CSV Project
 ; KER  Remove direct global reads, update for ICD-10
 ; 
 ; Global Variables
 ;    ^DPT(               ICR  10035
 ;               
 ; External References
 ;    ^%DTC               ICR  10000
 ;    ^DIC                ICR  10006
 ;    ^DIR                ICR  10026
 ;    $$DT^XLFDT          ICR  10103
 ;    H^XUS               ICR  10044
 ;    ^ICDDRG             ICR  N/A
 ;    $$DRG^ICDEX         ICR  N/A
 ;    $$DRGD^ICDEX        ICR  N/A
 ;    $$ROOT^ICDEX        ICR  N/A
 ;               
 ; Local Variables NEWed or KILLed Elsewhere
 ;     DIRUT,ICDDATE,QUIT,Y
 ; 
 S U="^",DT=$$DT^XLFDT W !!?11,"DRG Grouper    Version ",$P($T(+2),";",3),!!
PAT ; Patient
 D KILL
 S ICDQU=0 K ICDEXP,SEX,ICDDX,ICDSURG
 D EFFDATE G KILL:$D(DUOUT),OUT:$D(DTOUT)
 S DIR(0)="Y",DIR("A")="DRGs for Registered PATIENTS  (Y/N)",DIR("B")="YES"
 S DIR("?")="Enter 'Yes' if the patient has been previously registered, enter 'No' for other patient, or '^' to quit."
 D ^DIR K DIR S ICDPT=Y G KILL:$D(DUOUT),OUT:$D(DTOUT)
PAT0 ; Patient - Ask Again
 G:ICDPT=0 ASK
VA ; VA Patient File #2
 S DIC="^DPT(",DIC(0)="AEQMZ" D ^DIC G Q:X=""!(X[U)!(Y'>0),OUT:$D(DTOUT) S DFN=+Y,(DOB,AGE)=$P(Y(0),U,3),SEX=$P(Y(0),U,2)
 D TAC G:ICDQU PAT D DAM G:ICDQU PAT
EN1 ; Entry point - Patient is Known (DFN)
 I $D(^DPT(DFN,.35)),$L(^DPT(DFN,.35)) D ALIVE G:ICDQU PAT
 S ICDEXP=$S($D(ICDEXP):ICDEXP,1:0)
 I AGE]"" N %,X,X1,X2 S X1=DT,X2=AGE D ^%DTC S AGE=X\365.25 W "  AGE: ",AGE
CD ; Primary and Secondary DX
 K DIC S CC=0,DIC=$$ROOT^ICDEX(80),DIC(0)="AEQMZ",DIC("A")="Enter Primary diagnosis: " D  D ^DIC K DIC G Q:X=""!(X[U)!(Y'>0),OUT:$D(DTOUT) S ICDDX(1)=+Y
 . S DIC("S")="I '$P($$ICDDX^ICDEX(+Y,ICDDATE,,""I""),U,5),$$ISVALID^ICDEX(80,+Y,ICDDATE)"
 F ICDNSD=2:1 D  Q:X=""!(X[U)!(Y'>0)  G:$D(DTOUT) OUT S ICDDX(ICDNSD)=+Y
 . S DIC=$$ROOT^ICDEX(80),DIC(0)="AEQMZ"
 . S DIC("A")="Enter SECONDARY diagnosis: ",DIC("S")="I $$ISVALID^ICDEX(80,+Y,ICDDATE)"
 . D ^DIC K DIC
 G Q:X[U
OP ; Operation/Procedures
 S DIC("S")="I $$ISVALID^ICDEX(80.1,+Y,ICDDATE)" K ICDPRC
 W ! F ICDNOR=1:1 S DIC=$$ROOT^ICDEX(80.1),DIC(0)="AEQMZ",DIC("A")="Enter Operation/Procedure: " D ^DIC K DIC Q:X=""!(X[U)!(Y'>0)  G:$D(DTOUT) OUT S ICDPRC(ICDNOR)=+Y,ICDSURG(ICDNOR)=X
 K DIC G Q:X["^" D ^ICDDRG
 D WRT G PAT0
WRT ; Write Output
 S ICDDRG(0)=$$DRG^ICDEX(+ICDDRG,ICDDATE)
 W !!?9,"Effective Date: ","   ",ICDDSP
 W !,"Diagnosis Related Group: ",$J(ICDDRG,6),?40,"Avg len of stay: ",$J($P(ICDDRG(0),"^",8),6)
 W !?17,"Weight: ",$J($P(ICDDRG(0),"^",2),6),?40,"Local Breakeven: ",$J($P(ICDDRG(0),"^",12),6)
 W !?12," Low day(s): ",$J($P(ICDDRG(0),"^",3),6),?39,"Local low day(s): ",$J($P(ICDDRG(0),"^",9),6)
 W !?13," High days: ",$J($P(ICDDRG(0),"^",4),6),?40,"Local High days: ",$J($P(ICDDRG(0),"^",10),6)
 N ICDXD,ICDGDX,ICDGI S ICDXD=$$DRGD^ICDEX(ICDDRG,"ICDGDX",ICDDATE),ICDGI=0
 W !!,"DRG: ",ICDDRG,"-" F  S ICDGI=$O(ICDGDX(ICDGI)) Q:'+ICDGI  Q:ICDGDX(ICDGI)=" "  W ?10,ICDGDX(ICDGI),!
 Q
ERROR ; Write Errors
 D WRT I ICDRTC<5 W !!,"Invalid ",$S(ICDRTC=1:"Principal Diagnosis",ICDRTC=2:"Operation/Procedure",ICDRTC=3:"Age",ICDRTC=4:"Sex",1:"") G PAT0
 I ICDRTC=5 W !!,"Grouper needs to know if patient died during this episode!" G PAT0
 I ICDRTC=6 W !!,"Grouper needs to know if patient was transferred to an acute care facility!" G PAT0
 I ICDRTC=7 W !!,"Grouper needs to know if patient was discharged against medical advice!" G PAT0
 I ICDRTC=8 W !!,"Patient assigned newborn diagnosis code.  Check diagnosis!" G PAT0
 G PAT0
KILL ; Clean up Environment
 K DIC,DFN,DUOUT,DTOUT,ICDNOR,ICDDX,ICDPRC,ICDEXP,ICDTRS,ICDDMS,ICDDRG,ICDMDC,ICDO24,ICDP24,ICDP25,ICDRTC,ICDPT,ICDQU,ICDNSD,ICDNMDC
 K ICDMAJ,ICDS25,ICDSEX,AGE,DOB,CC,HICDRG,ICD,ICDCC3,ICDJ,ICDJJ,ICDL39,ICDFZ,ICDDT,ICDDSP,QUIT
 Q
Q ; Quit Current Patient
 G PAT
AGE ; Ask Patient Age
 S DIR(0)="NOA^0:124:0",DIR("A")="Patient's age: ",DIR("?")="Enter how old the patient is (0-124)." D ^DIR K DIR S AGE=Y G QQ:$D(DUOUT),OUT:$D(DTOUT)
 Q
ALIVE ; Ask if Patient died during this episode of care
 S DIR(0)="YO",DIR("A")="Did patient die during this episode" D ^DIR K DIR S ICDEXP=Y G QQ:$D(DUOUT),OUT:$D(DTOUT)
 Q
TAC ; Ask if Patient was Transferred to Acute Care
 S DIR(0)="YO",DIR("A")="Was patient transferred to an acute care facility" D ^DIR K DIR S ICDTRS=Y G QQ:$D(DUOUT),OUT:$D(DTOUT)
 Q
DAM ; Ask if Patient was Discharged against Medical Advice
 S DIR(0)="YO",DIR("A")="Was patient discharged against medical advice" D ^DIR K DIR S ICDDMS=Y G QQ:$D(DUOUT),OUT:$D(DTOUT)
 Q
SEX ; Ask for Patient's Sex
 S DIR(0)="SBO^M:MALE;F:FEMALE",DIR("?")="Enter M for Male and F for Female",DIR("A")="Patient's Sex" D ^DIR K DIR S SEX=Y G QQ:$D(DUOUT),OUT:$D(DTOUT)
 Q
QQ ; Quit All
 S ICDQU=1 Q
EFFDATE ; Prompts for effective date for DRG grouper?
 K DIR S DIR(0)="D^::AEX",DIR("B")="TODAY",DIR("A")="Effective Date"
 S DIR("?")="The effective to be used when calculating the DRG code for the patient."
 D ^DIR K DIR I $D(DIRUT) S QUIT=1 Q
 S ICDDATE=Y,ICDDSP=Y(0)
 Q
ASK ; Ask all
 K DTOUT,DUOUT D AGE G:ICDQU PAT D ALIVE G:ICDQU PAT D TAC G:ICDQU PAT D DAM G:ICDQU PAT D SEX G:ICDQU PAT G CD
OUT ; Exit Application
 G H^XUS
