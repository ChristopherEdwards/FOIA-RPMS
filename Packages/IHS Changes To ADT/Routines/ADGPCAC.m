ADGPCAC ; IHS/ADC/PDW/ENM - ADT/PCC DATA ENTRY ; [ 03/25/1999  11:48 AM ]
 ;;5.3;ADMISSION/DISCHARGE/TRANSFER;**1008**;MAR 25, 1999
 ;
A ; -- main
 N I,ID,Y,J,N
 D SP I Y'>0 D Q Q
 D LV,SV I 'DGVI D Q Q
 D VR,Q1,^ADGPCAC0,VR1
 G A
 ;
SP ; -- select patient
 S DIC="^DPT(",DIC(0)="AQEMZ",DIC("A")="Select PATIENT NAME: "
 D ^DIC K DIC S DFN=+Y
 Q
LV ; -- admissions?
 S I=0 I '$O(^DGPM("APTT1",DFN,0)) W !?5,"No admissions on file." Q
 ; -- loop visits
 W !!,"Select from these UNEXPORTED ADMISSIONS: ",!
 S ID=0 F  S ID=$O(^AUPNVSIT("AA",DFN,ID)) Q:'ID  D
 . S DGVI=0 F  S DGVI=$O(^AUPNVSIT("AA",DFN,ID,DGVI)) Q:'DGVI  D VH
 Q
 ;
VH ; -- inpatient visit? ;ihs or 638? ;v hosp? 
 Q:'$D(^AUPNVSIT(DGVI,0))  S N=^(0)  ;Q:$P(N,U,3)'="I"&($P(N,U,3)'=6) ;IHS/ANMC/LJF 5/29/98
 Q:$P(N,U,6)'=DUZ(2)  ;IHS/ANMC/LJF 5/29/98 
 Q:$P(N,U,14)]""  ;exported already
 S X1=DT,X2=+N D ^%DTC Q:X>500
 Q:'$O(^AUPNVINP("AD",DGVI,0))  Q:'$O(^DGPM("APTT1",DFN,+N,0))
 ; -- list and number visit(s) w/ v hosp
 S Y=+N X ^DD("DD") S I=I+1,J(I)=DGVI W !?15,I,".  ",Y
 Q
 ;
SV ; -- select visit
 I 'I W !?5,"No visits" S DGVI=0 D PRTOPT^ADGVAR Q
 I I=1 S DGVI=J(I) Q
 K DIR S DIR("A")="Select One",DIR(0)="NO^1:"_I D ^DIR
 I $D(DIRUT)!(Y=-1) S DGVI=0 Q
 S DGVI=J(X)
 Q
 ;
VR ; -- pcc variables & mark visit as being edited
 D APCDEIN^ADGCALLS Q
 ;
VR1 ;
 S N=$G(^AUPNVSIT(+$G(DGVI),0)) Q:'N
 I '$D(^AUPNVSIT("APCIS",+$P(N,U,2),+DGVI)) D
 . L +^AUPNVSIT(+DGVI):3 I '$T Q
 . S DIE="^AUPNVSIT(",DA=DGVI,DR=".13///"_DT D ^DIE L -^AUPNVSIT(DGVI)
 Q
 ;
Q ; -- cleanup all
 D APCDEKL^ADGCALLS K DGVI,DFN
Q1 ; -- cleanup rtn
 K DIR,DIRUT,DIE,DIC,DR,DA Q
