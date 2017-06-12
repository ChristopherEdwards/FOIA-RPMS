APCDCAF6 ;IHS/OIT/LJF - NEW INCOMPLETE CHART EDIT OPTION ; 23 Mar 2015  12:30 PM
 ;;2.0;IHS PCC SUITE;**11**;MAY 14, 2009;Build 58
 ;
 ;
MSG(DATA,PRE,POST) ;EP; -- writes line to device;IHS/ITSC/LJF PATCH 1003
 NEW I,FORMAT
 S FORMAT="" I $G(PRE)>0 F I=1:1:PRE S FORMAT=FORMAT_"!"
 D EN^DDIOL(DATA,"",FORMAT)
 I $G(POST)>0 F I=1:1:POST D EN^DDIOL("","","!")
 Q
CDE ;EP
 K DIR
 S DIR(0)="NO^1:"_APCDRCNT,DIR("A")="Which Visit"
 D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No VISIT selected." D EOP^APCDCAF G CDEX
 I $D(DIRUT) W !,"No VISIT selected." D EOP^APCDCAF G CDEX
 S APCDVSIT=^TMP("APCDCAF",$J,"IDX",Y,Y)
 K VALMBCK
 S APCDCAFV=APCDVSIT,APCDPAT=$P(^AUPNVSIT(APCDVSIT,0),U,5) D EN(APCDVSIT)
 ;
CDEX ;
 K DIR,DIRUT,DUOUT,Y,APCDVSIT,APCDCAF,APCDCAFV
 D KILL^AUPNPAT
 D BACK^APCDCAF
 Q
HRCN(PAT,SITE) ;EP; return chart number for patient at this site
 ;
 I $G(PAT)="" Q ""
 Q $P($G(^AUPNPAT(PAT,41,SITE,0)),U,2)
 ;
EN(APCDVSIT) ;EP; -- main entry point for OUTPT CHART DEFICIENY
 ; called with APCDVSIT set
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 NEW APCDDALL S APCDDALL=1
 D EN^VALM("APCDCAF CDE EDIT")
 D CLEAR^VALM1
 Q
 ;
HDR ;EP; -- header code
 NEW X
 S X=$$PAD($G(IORVON)_$$GET1^DIQ(2,+$G(APCDPAT),.01)_$G(IORVOFF),35)_"#"_$$HRCN(+$G(APCDPAT),DUZ(2))
 S VALMHDR(1)=X
 ;
 S X=$$PAD("Visit Date: "_$$GET1^DIQ(9000010,APCDVSIT,.01),40)_"Service Category: "_$$GET1^DIQ(9000010,APCDVSIT,.07)
 S VALMHDR(2)=X
 S X=$$PAD("Hospital Location: "_$$GET1^DIQ(9000010,APCDVSIT,.22),40)_"Clinic: "_$$GET1^DIQ(9000010,APCDVSIT,.08)
 S VALMHDR(3)=X
 S X="Primary Provider: "_$$PRIMPROV^APCLV(APCDVSIT,"N")
 S VALMHDR(4)=X
 Q
 ;
INIT ;EP; -- init variables and list array
 D INIT^APCDCAF7
 Q
 ;
SET(DATA,COUNT) ; stuff data into display lie
 S COUNT=COUNT+1
 S APCDCDEV(COUNT,0)=DATA
 Q
 ;
HELP ;EP; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ;EP; -- exit code
 K APCDDALL,APCDVSIT
 Q
 ;
EXPND ; -- expand code
 Q
 ;
REBUILD ; EP; rebuild display
 ; 
 D TERM^VALM0
 D HDR,INIT
 S VALMBCK="R"
 Q
 ;
EDITTD ; EP; edit tracking dates - called by APCD ICE DATES
 D FULL^VALM1 NEW ITEM,FIELD,DIE,DA,DR,Y
 I '$D(^AUPNCANT(APCDVSIT,0)) D ADDCANT^APCDCAF1
 S DIE="^AUPNCANT(",DA=APCDVSIT
 L +^AUPNCANT(APCDVSIT):1 I '$T D MSG("Another person is editing this entry!",2,0) D PAUSE^APCDALV1,REBUILD Q
 NEW APCDX
 S APCDX=$O(^AUPNCANT(APCDVSIT,12,"AC",0))
 S DR=".03//"_$$FMTE^XLFDT(APCDX)
 D ^DIE
 K DA,DR,DIE
 L -^AUPNCANT(APCDVSIT)
 W !,"Reviewed/Complete: ",$$DMRC(APCDVSIT)
 D PAUSE^APCDALV1
 D REBUILD
 Q
 ;
CAN ; EP; CHART AUDIT NOTE EDIT
 NEW DIE,DA,DR
 D FULL^VALM1
 I '$D(^AUPNCANT(APCDVSIT)) D ADDCANT^APCDCAF1
 I '$D(^AUPNCANT(APCDVSIT)) W !!,"adding entry to chart audit notes failed." H 3 G CANX
 W ! S DA=APCDVSIT,DIE="^AUPNCANT(",DR=1100 D ^DIE K DIE,DA,DR
 ;
CANX ;
 D PAUSE^APCDALV1,REBUILD
 Q
 ;
READ(TYPE,PROMPT,DEFAULT,HELP,SCREEN,DIRA) ;EP; calls reader, returns response
 NEW DIR,Y,DIRUT
 S DIR(0)=TYPE
 I $E(TYPE,1)="P",$P(TYPE,":",2)["L" S DLAYGO=+$P(TYPE,U,2)
 I $D(SCREEN),SCREEN]"" S DIR("S")=SCREEN
 I $G(PROMPT)]"" S DIR("A")=PROMPT
 I $G(DEFAULT)]"" S DIR("B")=DEFAULT
 I $D(HELP) S DIR("?")=HELP
 I $D(DIRA(1)) S Y=0 F  S Y=$O(DIRA(Y)) Q:Y=""  S DIR("A",Y)=DIRA(Y)
 D ^DIR
 Q Y
 ;
ADDDEF ; EP; add chart deficiences - called by APCD ICE ADD DEF protocol
 NEW PROV,APCDDEF,COUNT,ACTION,CHOICES,Y,DIE,DR,DA,I,SCREEN,DATE
 D FULL^VALM1
 L +^AUPNCANT(APCDVSIT):1 I '$T D MSG("Someone Else is editing this record currently",1,1),PAUSE^APCDALV1 Q
 S PROMPT="Select PROVIDER",SCREEN="" ;,SCREEN="I $D(^XUSEC(""PROVIDER"",+Y))&($P($G(^VA(200,+Y,""PS"")),U,4)="""")"
 F  D  Q:PROV<1
 . D MSG("",1,0)
 . S PROV=+$$READ("PO^200:EMQZ",PROMPT,"","",SCREEN)
 . Q:PROV<1
 . ;
 . ; stay in this provider until told to quit
 . S QUIT=0 F  D  Q:QUIT
 . . K APCDDEF D FINDDEF(APCDVSIT,PROV)                                          ;build array of deficiencies for provider
 . . I '$D(APCDDEF) D ADDMORE(APCDVSIT,PROV) S QUIT=1 Q                          ;if none yet, go to add mode
 . . ;
 . . D MSG($$SP(5)_"*** "_$$GET1^DIQ(200,PROV,.01)_" Deficiencies ***",2,0)
 . . F COUNT=1:1 Q:'$D(APCDDEF(COUNT))  D MSG($P(APCDDEF(COUNT),U),1,0)  ;display deficiencies
 . . ;
 . . D MSG("",1,0)
 . . S ACTION(1)=" 1. ADD New Deficiencies"
 . . S ACTION(2)=" 2. EDIT Selected Deficiencies"
 . . S ACTION(3)=" 3. RESOLVE Selected Deficiencies"
 . . S ACTION(4)=" 4. DELETE Selected Deficiencies"
 . . S ACTION(5)=" 5. QUIT"
 . . S Y=$$READ("NO^1:5","Select Action",5,"","",.ACTION) Q:Y<1
 . . I Y=5 S QUIT=1 Q
 . . I Y=1 D ADDMORE(APCDVSIT,PROV) Q
 . . S ACTION=Y
 . . ;
 . . S CHOICES=$$READ("LO^1:"_(COUNT-1),"Select Which Deficiencies to "_$S(ACTION=2:"EDIT",ACTION=4:"DELETE",1:"RESOLVE"))
 . . Q:CHOICES<1
 . . ;
 . . ; close multiple deficiencies
 . . I ACTION=3 D  Q
 . . . S DATE=$$READ("D^::EX","Enter DATE RESOLVED") Q:'DATE
 . . . S DIE="^AUPNCANT("_APCDVSIT_",12,",DR=".03///"_DATE_";.11///R;.06////"_DT_";.07////"_DUZ,DA(1)=APCDVSIT
 . . . F I=1:1 S J=$P(CHOICES,",",I) Q:J=""  W !?3,"Closing "_$E($P(APCDDEF(J),U),5,40) S DA=$P(APCDDEF(J),U,2) D ^DIE
 . . . K DA,DR,DIE  ;
 . . I ACTION=4 D  Q  ;DELETE SELECTED DEFICIENCIES
 . . . S DATE=$$READ("DO^::EX","Enter DATE DELETED") Q:'DATE
 . . . S DIE="^AUPNCANT("_APCDVSIT_",12,",DR=".08///"_DATE_";.11///D;.06////"_DT_";.07////"_DUZ_";.09",DA(1)=APCDVSIT
 . . . F I=1:1 S J=$P(CHOICES,",",I) Q:J=""  W !?3,"Deleting "_$E($P(APCDDEF(J),U),5,40) S DA=$P(APCDDEF(J),U,2) D ^DIE
 . . . K DA,DR,DIE  ;
 . . ; else edit selected deficiencies
 . . S DIE="^AUPNCANT("_APCDVSIT_",12,",DR=".06////"_DT_";.07////"_DUZ_";.02;.1",DA(1)=APCDVSIT
 . . F I=1:1 S J=$P(CHOICES,",",I) Q:J=""  D
 . . . D MSG($P(APCDDEF(J),U),2,0)
 . . . S DA=$P(APCDDEF(J),U,2)
 . . . D ^DIE
 L -^AUPNCANT(APCDVSIT)
 D VCAUPD
 D REBUILD
 Q
 ;
FINDDEF(APCDVSIT,PRV) ; return APCDDEF array with current deficiencies for provider PRV  -pending ONLY
 NEW COUNT,IEN,LINE,IENS
 S (IEN,COUNT)=0
 F  S IEN=$O(^AUPNCANT(APCDVSIT,12,"B",PROV,IEN)) Q:'IEN  D
 . S IENS=IEN_","_APCDVSIT
 . Q:$$GET1^DIQ(9000095.12,IENS,.11,"I")'="P"
 . S COUNT=COUNT+1
 . S LINE=$$PAD($J(COUNT,3),5)_$$GET1^DIQ(9000095.12,IENS,.02)        ;def name
 . S LINE=$$PAD(LINE,40)_$$GET1^DIQ(9000095.12,IENS,.11)            ;status
 . S APCDDEF(COUNT)=LINE_U_IEN
 Q
FINDPEND(V) ;EP - are there any pending deficiencies
 I '$G(V) Q ""
 NEW COUNT,IEN,J
 S (IEN,COUNT)=0
 F  S IEN=$O(^AUPNCANT(V,12,IEN)) Q:IEN'=+IEN!(COUNT)  D
 . S IENS=IEN_","_V
 . Q:$$GET1^DIQ(9000095.12,IENS,.11,"I")'="P"
 . S COUNT=COUNT+1
 Q COUNT
 ;
ADDMORE(APCDVSIT,PRV) ; add new deficiencies for provider
 NEW DIE,DR,DA,QUIT,DIC,DEF,DLAYGO,Y,IENS
 D MSG(" Add Mode for Deficiencies. . .",2,0)
 I '$D(^AUPNCANT(APCDVSIT,0)) D ADDCANT^APCDCAF1
 S QUIT=0 F  D  Q:QUIT
 . K DIC S DIC="^AUTTCDR(",DIC(0)="AEMQZ"
 . D ^DIC S DEF=+Y I Y<1 S QUIT=1 Q
 . ; 
 . I $$HAVEDEF(APCDVSIT,PRV,DEF) Q:'$$READ("Y","This deficiency already defined for this provider.  Do you really want to add it again","NO")
 . ;
 . Q:'$$READ("Y","Okay to add "_Y(0,0)_" for this provider","YES")
 . K DIC,DA,DD,DO
 . S DIC="^AUPNCANT("_APCDVSIT_",12,",DA(1)=APCDVSIT,X=PRV,DIC(0)="L"
 . S DIC("P")=$P(^DD(9000095,1200,0),U,2),DLAYGO=9000095.12
 . S DIC("DR")=".02///"_DEF_";.04////"_DT_";.05////"_DUZ_";.06////"_DT_";.07////"_DUZ_";.11///P"
 . D FILE^DICN Q:Y=-1
 . ;
 . S DIE="^AUPNCANT("_APCDVSIT_",12,",DA(1)=APCDVSIT,DA=+Y,DR=".03;.1" D ^DIE
 . S IENS=DA_","_APCDVSIT
 . I $$GET1^DIQ(9000095.12,IENS,.03,"I")]"" S DR=".11///R" D ^DIE
 . K DIE,DA,DR
 Q
 ;
HAVEDEF(APCDVSIT,PRV,DEF)  ;returns 1 if this record & this provider already have this deficincy defined
  NEW IEN,FOUND
  S (IEN,FOUND)=0 F  S IEN=$O(^AUPNCANT(APCDVSIT,12,"B",PRV,IEN)) Q:'IEN  Q:FOUND  D
  . I $P(^AUPNCANT(APCDVSIT,12,IEN,0),U,11)'="P"
  . I $P(^AUPNCANT(APCDVSIT,12,IEN,0),U,2)=DEF S FOUND=1
  Q FOUND
  ;
UPDATE ;EP
 D FULL^VALM1
 S APCDERR=$$ERRORCHK^APCDCAF(APCDVSIT)
 I APCDERR]"" W !!,"This visit has the following error: ",APCDERR,!,"You cannot mark a visit as Reviewed/Completed if there is an error." D PAUSE^APCDALV1 G UPDATEX
 S AUPNVSIT=APCDVSIT D MOD^AUPNVSIT K AUPNVSIT
UPD0 ;
 K DIC,DD,D0,DO
 S X=$$NOW^XLFDT,DIC="^AUPNVCA(",DIC(0)="L",DIADD=1,DLAYGO=9000010.45
 S DIC("DR")=".02////"_$P(^AUPNVSIT(APCDVSIT,0),U,5)_";.03////"_APCDVSIT_";.04///R;.05////"_DUZ_";1216////"_$$NOW^XLFDT D FILE^DICN
 I Y=-1 W !!,"updating status failed" D PAUSE^APCDALV1 G UPDATEX
 K DIC,DD,D0,DIADD,DLAYGO
 S (APCDVCA,DA)=+Y
UPD1 ;
 ;
 S DIE="^AUPNVSIT(",DA=APCDVSIT,DR=".13////"_DT_";1111///R" D ^DIE K DIE,DA,DR
 D RNU^APCDCAF4
UPDATEX ;
 K DIADD,DLAYGO
 D ^XBFMK
 K APCDCAR,APCDCVA
 D REBUILD
 Q
 ;
VCAUPD ;
 NEW APCDVCA
 K DIC,DD,D0,DO
 S X=$$NOW^XLFDT,DIC="^AUPNVCA(",DIC(0)="L",DIADD=1,DLAYGO=9000010.45
 S DIC("DR")=".02////"_$P(^AUPNVSIT(APCDVSIT,0),U,5)_";.03////"_APCDVSIT_";.05////"_DUZ_";1216////"_$$NOW^XLFDT D FILE^DICN
 I Y=-1 W !!,"updating status failed" D PAUSE^APCDALV1 Q
 K DIC,DD,D0,DIADD,DLAYGO
 S (APCDVCA,DA)=+Y
VCAUPD1 ;
 D ^XBFMK
 S S=0
 I $$ERRORCHK^APCDCAF(APCDVSIT)]"" S S=1
 I $$FINDPEND(APCDVSIT) S S=1
 I S S APCDCAR="I",DA=APCDVCA,DIE="^AUPNVCA(",DR=".04///I" D ^DIE K DA,DIE,DR G VCAUPD2
 I 'S S DA=APCDVCA,DIE="^AUPNVCA(",DR=".04" D ^DIE K DA,DIE,DR
 D ^XBFMK
 S APCDCAR=$P(^AUPNVCA(APCDVCA,0),U,4)
 I APCDCAR="" W !!,"You must enter a status" G VCAUPD1
 S APCDERR=$$ERRORCHK^APCDCAF(APCDVSIT)
 I APCDERR]"",APCDCAR="R" W !!,"This visit has the following error: ",APCDERR,!,"You cannot mark a visit as Reviewed/Completed if there is an error." S DA=APCDVCA,DIE="^AUPNVCA(",DR=".04///I" D ^DIE G VCAUPD1
VCAUPD2 ;
 S DIE="^AUPNVSIT(",DA=APCDVSIT,DR=".13////"_DT_";1111////"_APCDCAR D ^DIE K DIE,DA,DR
 Q
 ;
 ;
PAD(D,L) ;EP pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; pad N number of spaces
 Q $$PAD(" ",N)
 ;
DSOKAY() ; EP; does site use day surgery?
 Q $$GET1^DIQ(9009020.1,$$DIV^BSDU,201,"I")
 ;
LABEL(FIELD) ; returns field's title or label
 NEW X
 S X=$$GET1^DID(9000095,FIELD,"","TITLE")
 I X="" S X=$$GET1^DID(9000095,FIELD,"","LABEL")
 Q X
 ;
PENDING(IEN) ; return 1 if chart has at least one pending deficiency
 NEW IEN2,FOUND,IENS
 S (IEN2,FOUND)=0 F  S IEN2=$O(^AUPNCANT(IEN,1,IEN2)) Q:'IEN2  Q:FOUND  D
 . S IENS=IEN2_","_IEN
 . Q:$$GET1^DIQ(9000095.12,IENS,.11)'="P"
 . S FOUND=1
 Q FOUND
DELQDT(IEN,PVN) ;EP called by computed code for DATE DELINQUENT
 ; IEN = internal entry in file
 ; PVN = internal entry for provider multiple
 I ('$G(IEN))!('$G(PVN)) Q "??"
 NEW VD,DAYS
 S VD=$$VD^APCLV(IEN)               ;VISIT date
 I 'VD Q "??"
 S DAYS=$$GET1^DIQ(9001001.2,DUZ(2),.38)  ;Days to delinquency
 I 'DAYS Q "??"
 Q $$FMADD^XLFDT(VD,DAYS)
 ;
ICTIME(IEN,PVN) ;EP; called by computed code for Completion Time
 ; IEN = internal entry in file
 ; PVN = internal entry for provider multiple
 I ('$G(IEN))!('$G(PVN)) Q "??"
 NEW DONE,DSCH
 S DONE=$$GET1^DIQ(9000095.12,PVN_","_IEN,.03,"I")   ;date resolved
 I 'DONE Q ""
 S DSCH=$$GET1^DIQ(900095.12,PVN_","_IEN,.04,"I")            ;date added
 I 'DSCH Q "??"
 Q $$FMDIFF^XLFDT(DONE,DSCH)
DISPV ;EP
 NEW APCDCAFV
 S APCDCAFV=APCDVSIT D ^APCDVD S APCDVSIT=APCDCAFV
DISPX ;
 K DIR,DIRUT,DUOUT,Y
 D REBUILD
 Q
 ;
DMRC(V) ;EP - date marked reviewed/complete
 I '$G(V) Q ""
 NEW X,Y
 I '$D(^AUPNVSIT(V,11)) Q "NOT YET COMPLETE"
 I $P(^AUPNVSIT(V,11),U,11)'="R" Q "NOT YET COMPLETE"
 S X=0,Y="" F  S X=$O(^AUPNVCA("AD",V,X)) Q:X'=+X  I $P($G(^AUPNVCA(X,0)),U,4)="R" S Y=X
 I 'Y Q "NOT YET COMPLETE"
 Q $$GET1^DIQ(9000010.45,Y,.01)
 ;
ICSTAT(IEN,PVN) ;EP; called by computed code for Resolution Status
 ; IEN = internal entry in file
 ; PVN = internal entry for provider multiple
 I ('$G(IEN))!('$G(PVN)) Q "??"
 I $$GET1^DIQ(9000095.12,PVN_","_IEN,.03)]"" Q "Resolved"
 I $$GET1^DIQ(9000095.12,PVN_","_IEN,.08)]"" Q "Deleted"
 Q "Pending"
EDITPRV ;EP - edit the provider but keep track of deficiency 
 NEW PROV,APCDDEF,COUNT,ACTION,CHOICES,Y,DIE,DR,DA,I,SCREEN,DATE,NEWPRV,APCDNN,APCDALL
 D FULL^VALM1
 L +^AUPNCANT(APCDVSIT):1 I '$T D MSG("Someone Else is editing this record currently",1,1),PAUSE^APCDALV1 Q
 S PROMPT="Select PROVIDER",SCREEN=""  ;"I $D(^XUSEC(""PROVIDER"",+Y))&($P($G(^VA(200,+Y,""PS"")),U,4)="""")"
 F  D  Q:PROV<1
 . D MSG("",1,0)
 . S PROV=+$$READ("PO^200:EMQZ",PROMPT,"","",SCREEN)
 . Q:PROV<1
 . ;
 . ; stay in this provider until told to quit
 . S QUIT=0 F  D  Q:QUIT
 . . K APCDDEF D FINDDEF(APCDVSIT,PROV)                                          ;build array of deficiencies for provider
 . . I '$D(APCDDEF) D MSG($$SP(5)_"There are no Pending deficiencies for this Provider",2,0) S QUIT=1 Q
 . . ;
 . . D MSG($$SP(5)_"*** "_$$GET1^DIQ(200,PROV,.01)_" Deficiencies ***",2,0)
 . . F COUNT=1:1 Q:'$D(APCDDEF(COUNT))  D MSG($P(APCDDEF(COUNT),U),1,0)  ;display deficiencies
 . . ;
 . . D MSG("",1,0)
 . . S CHOICES=$$READ("LO^1:"_(COUNT-1),"Select Which Deficiency to change Provider for")
 . . D MSG("",1,0)
 . . I +CHOICES<1 S QUIT=1 Q
 . . S NEWPRV=+$$READ("PO^200:EMQZ","Change to which Provider","","",SCREEN)
 . . I NEWPRV<1 S QUIT=1 Q
 . . I PROV=NEWPRV D MSG($$SP(5)_"You cannot select the same provider",2,0) S QUIT=1 Q
 . . S APCDNN=$$ADDNEW(APCDVSIT,NEWPRV)
 . . I 'APCDNN D MSG($$SP(5)_"Error copying deficiency information from old provider to new",2,0) S QUIT=1 Q
 . . D STUFFNEW(APCDVSIT,APCDNN,$TR(CHOICES,",",""))
 . . D CLOSEOUT(APCDVSIT,PROV,$TR(CHOICES,",",""))
 . . W !!,"Provider changed from ",$$VAL^XBDIQ1(200,PROV,.01)," to ",$$VAL^XBDIQ1(200,NEWPRV,.01)
 . . ;
 L -^AUPNCANT(APCDVSIT)
 D REBUILD
 Q
ADDNEW(N,NPRV) ;-- add a new entry for new provider
 K DIC,DA,DD,DO
 S DA(1)=N
 S DIC(0)="L",DIC="^AUPNCANT("_N_",12,"
 S DIC("P")=$P(^DD(9000095,1200,0),U,2),DLAYGO=9000095.12
 S X=NPRV
 S DIC("DR")=";.06////"_DT_";.07////"_DUZ
 D FILE^DICN
 Q +Y
 ;
CLOSEOUT(N,P,C) ;-- closeout the previous provider
 K DR,DIE
 S DIE="^AUPNCANT("_N_",12,",DR=".11///D;.08////"_DT_";.09///Provider Change;.1///Auto changed Change PROVIDER protocol action"
 S DA(1)=N,DA=$P(APCDDEF(C),U,2)
 D ^DIE
 K DIE
 Q
 ;
STUFFNEW(N,NN,CH) ;-- now add the new entry
 K DR,DIE
 N DATA,A,B,C,D,E,J
 S J=$P(APCDDEF(CH),U,2)
 S DATA=$G(^AUPNCANT(N,12,J,0))
 S A=$P(DATA,U,2)
 S B=$P(DATA,U,3)
 S C=$P(DATA,U,4)
 S D=$P(DATA,U,5)
 S E=$P(DATA,U,10)
 S DIE="^AUPNCANT("_N_",12,",DA(1)=N,DA=NN
 S DR=".02////"_A_";.03////"_B_";.04////"_C_";.05////"_D_";.1////"_E_";.11///P"
 D ^DIE
 K DIE
 Q
 ;
