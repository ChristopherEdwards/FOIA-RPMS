APCDBMSR ; IHS/CMI/LAB - ENTER BIRTH MEASUREMENT
 ;;2.0;IHS PCC SUITE;**7**;MAY 14, 2009
 ;
 ;
BM ;EP - called from d/e input template APCD BM (BM)
 S APCDREPI=DA
 D EN^XBNEW("BM1^APCDBMSR","APCDREPI;APCDDATE")
 K Y
 Q
BM1 ;EP - called from XBNEW call
 S APCDRFS="",APCDPARS=""
 I '$D(^AUPNBMSR(APCDREPI)) S X=$$BMADD(APCDREPI) I 'X W $P(X,U,2) Q
BM11 ;
 S DIE="^AUPNBMSR(",DA=APCDREPI,DR="[APCD BM EDIT]" D ^DIE
 K DIE,DA,DR
BM12 ;
 ;D FM1
 K Y
 Q
 ;
PAUSE ;EP
 S DIR(0)="EO",DIR("A")="Press enter to continue...." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
BMADD(P) ;PEP - called to add a patient to the BIRTH MEASUREMENTs file
 ;output:  DFN (ien of entry, file is dinum)
 ;         0^error message if add failed
 I '$G(P) Q 0_"^patient DFN invalid"
 I '$D(^DPT(P)) Q 0_"^patient DFN invalid"
 I $D(^AUPNBMSR(P,0)) Q P
 NEW X,DIC,DD,D0,DO,Y
 S X=P,DIC="^AUPNBMSR(",DIC(0)="L"
 K DD,D0,DO,DINUM
 S DINUM=X
 D FILE^DICN
 I Y=-1 Q 0_"^fileman failed adding patient"
 Q 1
 ;
