ADGPCAC0 ; IHS/ADC/PDW/ENM - ADT/PCC DATA ENTRY ;  [ 03/25/1999  11:48 AM ]
 ;;5.3;ADMISSION/DISCHARGE/TRANSFER;**1008**;MAR 25, 1999
 ;
 D ^ADGPCAC1
 S APCDCAT="H",APCDVSIT=DGVI,APCDPAT=DFN,APCDTYPE="I"
 S APCDVLK=DGVI,APCDLOC=DUZ(2)
SF ; -- select function
 W !! K DIR S DIR(0)="NO^1:8",DIR("A")="Select One (by number)"
 S DIR("A",1)="  (1) ADMISSION DATA           (3) PROCEDURE(S)"
 S DIR("A",2)="  (2) POV (DIAGNOSIS)          (4) PROVIDER(S)"
 S DIR("A",3)="  (5) IMMUNIZATIONS            (6) PROBLEM LIST"
 S DIR("A",4)="  (7) OTHER MNEMONICS          (8) review clinical data"
 D ^DIR G:$D(DIRUT) VC G SF:Y=-1 S DGF=Y
FUN ; -- function
 I DGF=1 D  G SF
 . I '$D(^DGPM("APTT1",DFN)) W !,"No admissions on file",! Q
 . L +^AUPNVINP($$VH):3 I '$T D  G SF
 .. W !,*7,"SOMEONE ELSE IS UPDATING THIS HOSPITALIZATION"
 .. W "; TRY AGAIN LATER"
 . K DIC,DIE S DIE="^AUPNVINP(",DA=$$VH,DR=".08;.12" D ^DIE  ;consults
 . L -^AUPNVINP($$VH)
 . N DGPMCA,DGPMEX,DGPMAN S DGPMCA=$$CA,DGPMAN=$G(^DGPM(+DGPMCA,0))
 . S DGZDFN=APCDPAT
 . S ^DISV(DUZ,"DGPMEX",DFN)=DGPMCA D ENEX^DGPMV20,ASK^DGPMEX S (DFN,APCDPAT)=DGZDFN K DGZDFN
 I DGF=8 W @IOF D ^ADGPCAC1 G SF
 W !! K DIR S DIR(0)="SO^A:ADD;M:MODIFY",DIR("A")="Select MODE"
 I DGF'=7 D  S DIR("A")=" "
 . S DIR("A",1)="Enter 'A' to add a new "_$$MOD_" OR"
 . S DIR("A",2)="Enter 'M' to modify an existing "_$$MOD
 D ^DIR S APCDMODE=$S(Y["A":"A",Y["M":"M",1:"")
 G:APCDMODE="" SF
PCC ; -- set mnemonic and call PCC data entry rtn
 S DIC="^APCDTKW(",DIC(0)=""
 I DGF=7 S DIC(0)="AEMQ",DIC("A")="MNEMONIC: "
 S X=$S(DGF=2:"PV",DGF=3:"OP",DGF=4:"PRV",DGF=5:"IM",DGF=6:"PO",1:"")
 S DIC("S")="I $L($P(^(0),U,1))<4" D ^DIC K DIC I Y<0 G FUN
 S APCDMNE=+Y,APCDMNE("NAME")=$P(Y,U,2) D APCDEA3^ADGCALLS
 G FUN
VC ; -- visit check
 S APCDVSIT=DGVI D APCDCHK^ADGCALLS  ;to check pcc inpatient edits
Q ; -- cleanup
 K DGF,DIC,X,Y Q
 ;
VH() ; -- v hospitalization ien
 Q $O(^AUPNVINP("AD",DGVI,0))
 ;
CA() ; -- corresponding admission
 Q $O(^DGPM("AMV1",+^AUPNVSIT(DGVI,0),DFN,0))
 ;
MOD() ;
 Q $S(DGF=2:"diagnosis",DGF=3:"procedure",DGF=4:"provider",DGF=5:"immunization",DGF=6:"problem",1:"")
 ;
LOCKOUT(DATE) ;EP -- called to check lock out date
 ; -- returns 1 if admission is locked
 ; -- called by DGPMEX,DGPMV21
 NEW X,X1,X2
 S X1=DT,X2=DATE D ^%DTC
 Q $S(X>$P($G(^DG(43,1,9999999)),U,6):1,1:0)
