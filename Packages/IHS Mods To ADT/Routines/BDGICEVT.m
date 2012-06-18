BDGICEVT ; IHS/ANMC/LJF - CREATE IC ENTRY AT DISCHARGE ;  [ 01/06/2005  11:36 AM ]
 ;;5.3;PIMS;**1001,1004**;MAY 28, 2004
 ;IHS/ITSC/LJF 08/09/2004 PATCH 1001 user discharge date field, not surgery date for observations
 ;IHS/OIT/LJF  09/09/2005 PATCH 1004 fixed code so observations send discharge date to IC file
 ;
ADD ;EP; called by ADT Event driver to create incomplete chart entries
 ;
 ; Input Variables:
 ;    DGPMT   = type of event (1-admit, 3-discharge, etc.)
 ;    DGPMDA  = event ien
 ;    DGPMCA  = admission ien
 ;    DGPMP   = zero node of 405 entry Prior to event
 ;    DGPMA   = zero node of 405 entry After event
 ;    DFN     = patient ien
 ;    DGQUIET = if $G(DGQUIET), no user interaction
 ;
 Q:DGPMT'=3            ;only done at discharge time
 Q:DGPMA=""            ;discharge deleted, no action
 Q:$$GET1^DIQ(9009020.1,$$DIV^BDGPAR(DUZ(2)),.08)'="YES"  ;parameter
 ;
 NEW VST,DD,DO,DIC,X,DLAYGO,Y
 S VST=$$GET1^DIQ(405,DGPMCA,.27,"I") Q:'VST     ;visit for admission
 Q:$D(^BDGIC("AV",VST))                          ;already in file
 ;
 ;I $$TYPE(DGPMCA,DFN)="O" D OBSERV Q  ;IHS/OIT/LJF 09/09/2005 PATCH 1004 treat observations the same
 ;
 L +^BDGIC(0):3  Q:'$T
 K DD,DO S DIC="^BDGIC(",DIC(0)="L",DLAYGO=9009016.1,X=DFN
 ;used //// to bypass visit screen if visit has zero dep entries
 S DIC("DR")=".02///"_$E(+DGPMA,1,12)_";.03////"_VST_";.04///`"_$P($$LASTTXN^BDGF1(DGPMCA,DFN),U,2)
 D FILE^DICN K DLAYGO,DIC L -^BDGIC(0)
 Q
 ;
TYPE(ADM,PAT) ;returns type of admission (Inpatient or Observation)
 I $$LASTSRVN^BDGF1(ADM,PAT)["OBSERVATION" Q "O"
 Q "I"
 ;
OBSERV ; stuff observation data in IC file
 NEW SRDATE,DIC,DIE,DR,DA,X,SERV
 ; get admission date, assume is surgery date
 S SRDATE=$$GET1^DIQ(405,+$G(DGPMCA),.01,"I") I 'SRDATE Q
 I $D(^BDGIC("ASRG",SRDATE,DFN)) Q  ;already in file
 ;
 I '$G(DGQUIET) D
 . D MSG^BDGF(" "),MSG^BDGF("Creating entry in Incomplete Chart file....")
 ;
 ; get discharge service
 S SERV=$P($$LASTTXN^BDGF1(DGPMCA,DFN),U,2) I 'SERV Q
 ;
 ; make FM call to stuff data
 S X=DFN,DIC="^BDGIC(",DLAYGO=9009016.1,DIC(0)="L"
 ; 4 slash visit to bypass file screen
 ;S DIC("DR")=".03////"_VST_";.04///`"_SERV_";.05///"_(SRDATE\1)
 S DIC("DR")=".03////"_VST_";.04///`"_SERV_";.02///"_SRDATE   ;IHS/ITSC/LJF 8/9/2004 PATCH #1001
 L +^BDGIC(0):3 I '$T D  Q
 . Q:$D(DGQUIET)
 . W !,*7,"CANNOT ADD TO INCOMPLETE CHART FILE;"
 . W "BEING UPDATED BY SOMEONE ELSE"
 K DD,DO D FILE^DICN L -^BDGIC(0)
 Q
