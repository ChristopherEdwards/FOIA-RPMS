BDGICE3 ;cmi/anch/maw - NEW INCOMPLETE CHART EDIT OPTION 5/12/2008 1:47:45 PM
 ;;5.3;PIMS;**1004,1006,1009**;MAY 28, 2004
 ;
 ;
EDITPRV ;EP - edit the provider but keep track of deficiency - called by BDG IC EDIT PROVIDER protocol
 ; EP; add chart deficiences - called by BDG ICE ADD DEF protocol
 NEW PROV,BDGDEF,COUNT,ACTION,CHOICES,Y,DIE,DR,DA,I,SCREEN,DATE,NEWPRV,BDGNN
 D FULL^VALM1
 L +^BDGIC(BDGN):1 I '$T D MSG^BDGF("Someone Else is editing this record currently",1,1),PAUSE^BDGF Q
 S PROMPT="Select PROVIDER",SCREEN="I $D(^XUSEC(""PROVIDER"",+Y))&($P($G(^VA(200,+Y,""PS"")),U,4)="""")"
 F  D  Q:PROV<1
 . D MSG^BDGF("",1,0)
 . S PROV=+$$READ^BDGF("PO^200:EMQZ",PROMPT,"","",SCREEN)
 . Q:PROV<1
 . ;
 . ; stay in this provider until told to quit
 . S QUIT=0 F  D  Q:QUIT
 . . K BDGDEF D FINDDEF^BDGICE2(BDGN,PROV)                                          ;build array of deficiencies for provider
 . . I '$D(BDGDEF)  D MSG^BDGF($$SP^BDGICE2(5)_"There are no deficiencies for this Provider",2,0) S QUIT=1 Q
 . . ;
 . . D MSG^BDGF($$SP^BDGICE2(5)_"*** "_$$GET1^DIQ(200,PROV,.01)_" Deficiencies ***",2,0)
 . . F COUNT=1:1 Q:'$D(BDGDEF(COUNT))  D MSG^BDGF($P(BDGDEF(COUNT),U),1,0)  ;display deficiencies
 . . ;
 . . D MSG^BDGF("",1,0)
 . . S CHOICES=$$READ^BDGF("LO^1:"_(COUNT-1),"Select Which Deficiency to change Provider for")
 . . D MSG^BDGF("",1,0)
 . . I +CHOICES<1 S QUIT=1 Q
 . . S NEWPRV=+$$READ^BDGF("PO^200:EMQZ","Change to which Provider","","",SCREEN)
 . . I NEWPRV<1 S QUIT=1 Q
 . . I PROV=NEWPRV D MSG^BDGF($$SP^BDGICE2(5)_"You cannot select the same provider",2,0) S QUIT=1 Q
 . . S BDGNN=$$ADDNEW(BDGN,NEWPRV)
 . . I 'BDGNN D MSG^BDGF($$SP^BDGICE2(5)_"Error copying deficiency information from old provider to new",2,0) S QUIT=1 Q
 . . D STUFFNEW(BDGN,BDGNN,$TR(CHOICES,",",""))
 . . D CLOSEOUT(BDGN,PROV,$TR(CHOICES,",",""))
 . . ;
 L -^BDGIC(BDGN)
 D REBUILD^BDGICE2
 Q
 ;
ADDNEW(N,NPRV) ;-- add a new entry for new provider
 K DIC,DA,DD,DO
 S DA(1)=N
 S DIC(0)="L",DIC="^BDGIC("_N_",1,"
 S DIC("P")=$P(^DD(9009016.1,1,0),U,2),DLAYGO=9009016.11
 S X=NPRV
 D FILE^DICN
 Q +Y
 ;
CLOSEOUT(N,P,C) ;-- closeout the previous provider
 K DR,DIE
 S DIE="^BDGIC("_BDGN_",1,",DR=".04////"_DT_";.05///Provider Change;.06///Auto changed BDG IC EDIT PROVIDER protocol action"
 S DA(1)=N,DA=C
 D ^DIE
 K DIE
 Q
 ;
STUFFNEW(N,NN,CH) ;-- now add the new entry
 K DR,DIE
 N DATA,A,B,C,D,E
 S DATA=$G(^BDGIC(N,1,CH,0))
 S A=$P(DATA,U,2)
 S B=$P(DATA,U,3)
 S C=$P(DATA,U,4)
 S D=$P(DATA,U,5)
 S E=$P(DATA,U,6)
 S DIE="^BDGIC("_N_",1,",DA(1)=N,DA=NN
 S DR=".02////"_A_";.03////"_B_";.04////"_C_";.05////"_D_";.06////"_E
 D ^DIE
 K DIE
 Q
 ;
