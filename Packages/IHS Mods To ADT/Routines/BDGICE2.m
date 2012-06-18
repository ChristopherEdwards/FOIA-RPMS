BDGICE2 ;IHS/OIT/LJF - NEW INCOMPLETE CHART EDIT OPTION
 ;;5.3;PIMS;**1004,1006**;MAY 28, 2004
 ;IHS/OIT/LJF 09/08/2005 PATCH 1004 New routine
 ;            07/05/2006 PATCH 1006 add back ability to edit discharge/surgery dates
 ;
PAT ; ask user for patient
 NEW DFN D KILL^AUPNPAT
 S DFN=+$$READ^BDGF("PO^2:EMQZ","Select Patient") Q:DFN<1
 ;
 ; set variable so all deficiencies are shown
 NEW BDGDFALL S BDGDFALL=1
 ;
 ; find all entries in IC file for patient (including deleted ones)
 NEW BDGN,COUNT,BDGA,I
 S BDGN=0
 F  S BDGN=$O(^BDGIC("B",DFN,BDGN)) Q:'BDGN  D
 . S COUNT=$G(COUNT)+1,BDGA(COUNT)=BDGN
 ;
 ; display results of search for patient IC entries
 I '$D(BDGA) D ADD,PAT Q
 ;
 W !!,"Incomplete Chart Entries for "_$$GET1^DIQ(2,DFN,.01)_":"
 F I=1:1 Q:'$D(BDGA(I))  D
 . W !,$J(I,3),?6,$$GET1^DIQ(9009016.1,BDGA(I),.02),$$GET1^DIQ(9009016.1,BDGA(I),.05)  ;discharge or surgery date
 . W ?30,$$GET1^DIQ(9009016.1,BDGA(I),.0392)                                           ;type of visit
 . I $$GET1^DIQ(9009016.1,BDGA(I),.14)]"" W "  **COMPLETED**"
 . I $$GET1^DIQ(9009016.1,BDGA(I),.17)]"" W "  **DELETED**"
 W !,$J(I,3),?6,"ADD NEW ENTRY"
 D ASK I '$G(BDGN) D PAT Q
 D EN,PAT
 Q
 ;
ASK ; process IC entry selection
 NEW PROMPT,Y
 S PROMPT="Select Discharge"_$S($$DSOKAY:"/Day Surgery",1:"")_" Date"
 S Y=$$READ^BDGF("NO^1:"_(COUNT+1),PROMPT) Q:Y<1
 I Y=(COUNT+1) D ADD Q
 S BDGN=BDGA(Y)
 I $$GET1^DIQ(9009016.1,BDGN,.17)]"",'$D(^XUSEC("DGZICE",DUZ)) W !!,"Only supervisors can access DELETED entries",! K BDGN D ASK Q
 Q
 ;
ADD ; -- add new entry
 NEW Y,DIC,DA,DR,X,DD,DO,DLAYGO
 S Y=1
 I $$DSOKAY S Y=$$READ^BDGF("SO^1:Inpatient/Observation;2:Day Surgery","Select TYPE of Visit to Add") Q:Y<1
 S DIC="^BDGIC(",DIC(0)="L",DLAYGO=9009016.1,X=DFN
 S APCDOVRR=1
 I Y=1 S DIC("DR")=".02R;.03R;.04R"   ;inpt/obser
 I Y=2 S DIC("DR")=".05R;.03R;.04R"   ;ds
 D FILE^DICN Q:Y<1
 K APCDOVRR
 ;
 S BDGN=+Y
 D EN
 Q
 ;
EN ;EP; -- main entry point for BDG IC EDIT
 ; called with DFN and BDGN set
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BDG IC EDIT")
 D CLEAR^VALM1
 Q
 ;
HDR ;EP; -- header code
 NEW X
 S X=$$PAD($G(IORVON)_$$GET1^DIQ(2,+$G(DFN),.01)_$G(IORVOFF),35)_"#"_$$HRCN^BDGF2(+$G(DFN),DUZ(2))
 S X=$$PAD(X,50)_"Insurance: "_$$GET1^DIQ(9009016.1,+$G(BDGN),.0391)
 S VALMHDR(1)=X
 ;
 S X="Category: "_$G(IORVON)_$$GET1^DIQ(9009016.1,+$G(BDGN),.0392)_$G(IORVOFF)
 S X=$$PAD(X,35)_"Service: "_$$GET1^DIQ(9009016.1,+$G(BDGN),.04)
 S VALMHDR(2)=X
 Q
 ;
INIT ;EP; -- init variables and list array
 NEW CATG,LINE,FIELD,ITEM,X
 S VALMCNT=0 K ^TMP("BDGICE",$J)
 S CATG=$$GET1^DIQ(9009016.1,BDGN,.0392)     ;service category
 S LINE=$$PAD($S(CATG="DAY SURGERY":"Visit",1:"Admit")_" Date/Time:",30)
 S LINE=LINE_$$GET1^DIQ(9009016.1,BDGN,.03)
 D SET(LINE,.VALMCNT)
 S LINE=$$PAD($S(CATG="DAY SURGERY":"Surgery",1:"Discharge")_" Date:",30)
 S LINE=LINE_$$GET1^DIQ(9009016.1,BDGN,$S(CATG="DAY SURGERY":.05,1:.02))
 D SET(LINE,.VALMCNT),SET("",.VALMCNT)
 ;
 F ITEM=202:1:208 D
 . I ITEM=207 D    ;display required date completed field
 . . S LINE=$$PAD($$LABEL(.14)_":",30)_$$GET1^DIQ(9009016.1,BDGN,.14)
 . . D SET(LINE,.VALMCNT)
 . ;
 . Q:$$GET1^DIQ(9009020.1,$$DIV^BSDU,ITEM)'="YES"  ;date not used
 . ;
 . S FIELD=$P($T(FIELDS+(ITEM-200)),";;",2)     ;get corresponding field number
 . S LINE=$$PAD($$LABEL(FIELD)_":",30)_$$GET1^DIQ(9009016.1,BDGN,FIELD)
 . I (ITEM=206)!(ITEM=207) S LINE=$$PAD(LINE,47)_"  By "_$$GET1^DIQ(9009016.1,BDGN,$S(ITEM=206:.22,1:.23))
 . D SET(LINE,.VALMCNT)
 ;
 ; if chart deleted, display deletion date
 S X=$$GET1^DIQ(9009016.1,BDGN,.17) I X]"" D
 . S LINE=$$PAD($$LABEL(.17)_":",30)_$$GET1^DIQ(9009016.1,BDGN,.17)
 . D SET(LINE,.VALMCNT)
 ;
 ; display comments
 S LINE=$$PAD($$LABEL(.18)_":",10)_$$GET1^DIQ(9009016.1,BDGN,.18)
 D SET("",.VALMCNT),SET(LINE,.VALMCNT),SET("",.VALMCNT)
 ;
 ; display pending provider deficiencies
 K ^TMP("BDGICE2",$J) NEW BDGN1,IENS,PROV,PROVN
 D SET($$PAD($$PAD("Provider",25)_"Deficiencies",60)_"Status",.VALMCNT)
 D SET($$REPEAT^XLFSTR("=",75),.VALMCNT)
 ;
 S BDGN1=0 F  S BDGN1=$O(^BDGIC(BDGN,1,BDGN1)) Q:'BDGN1  D
 . S IENS=BDGN1_","_BDGN
 . I '$G(BDGDFALL),$$GET1^DIQ(9009016.11,IENS,.03)]"" Q  ;skip if resolved & not displaying all
 . I '$G(BDGDFALL),$$GET1^DIQ(9009016.11,IENS,.04)]"" Q  ;skip if deleted & not displaying all
 . ;
 . S PROV=$$GET1^DIQ(9009016.11,IENS,.01,"I")             ;provider IEN
 . S PROVN=$$GET1^DIQ(9009016.11,IENS,.01)                ;provider name
 . ;
 . S LINE=$$PAD($E(PROVN,1,22),25)_$$GET1^DIQ(9009016.11,IENS,.02)   ;provider & deficiency
 . S LINE=$$PAD(LINE,60)_$$GET1^DIQ(9009016.11,IENS,.0393)           ;resolution status
 . S ^TMP("BDGICE2",$J,PROVN,PROV,BDGN1)=LINE
 . ;
 . S X=$$GET1^DIQ(9009016.11,IENS,.06) I X]"" S ^TMP("BDGICE2",$J,PROVN,PROV,BDGN1,"C")=$$SP(10)_"Comments: "_X  ;comments
 ;
 S PROVN=0 F  S PROVN=$O(^TMP("BDGICE2",$J,PROVN)) Q:PROVN=""  D
 . S PROV=0 F  S PROV=$O(^TMP("BDGICE2",$J,PROVN,PROV)) Q:'PROV  D
 . . S BDGN1=0 F  S BDGN1=$O(^TMP("BDGICE2",$J,PROVN,PROV,BDGN1)) Q:'BDGN1  D
 . . . D SET(^TMP("BDGICE2",$J,PROVN,PROV,BDGN1),.VALMCNT)
 . . . I $D(^TMP("BDGICE2",$J,PROVN,PROV,BDGN1,"C")) D SET(^TMP("BDGICE2",$J,PROVN,PROV,BDGN1,"C"),.VALMCNT)
 ;
 I '$D(^TMP("BDGICE2",$J)),'$G(BDGDFALL) D SET($$SP(5)_"NO PENDING DEFICIENCIES FOUND",.VALMCNT)
 I '$D(^TMP("BDGICE2",$J)),$G(BDGDFALL) D SET($$SP(5)_"NO DEFICIENCIES ON RECORD",.VALMCNT)
 D SET("",.VALMCNT)
 Q
 ;
SET(DATA,COUNT) ; stuff data into display lie
 S COUNT=COUNT+1
 S ^TMP("BDGICE",$J,COUNT,0)=DATA
 Q
 ;
HELP ;EP; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ;EP; -- exit code
 K ^TMP("BDGICE",$J),^TMP("BDGICE2",$J)
 K BDGDFALL,BDGN
 Q
 ;
EXPND ; -- expand code
 Q
 ;
REBUILD ; EP; rebuild display
 ; Called by BDG ICE VIEW ALL and BDG ICE VIEW PENDING protocols
 D TERM^VALM0
 D HDR,INIT
 S VALMBCK="R"
 Q
 ;
TDATES ; EP; edit tracking dates - called by BDG ICE DATES
 D FULL^VALM1 NEW ITEM,FIELD,DIE,DA,DR,Y
 S DIE="^BDGIC(",DA=BDGN
 L +^BDGIC(BDGN):1 I '$T D MSG^BDGF("Another person is editing this entry!",2,0) D PAUSE^BDGF,REBUILD Q
 F ITEM=202:1:208 D  Q:$D(Y)
 . I ITEM=207 D    ;edit date completed field only if already answered
 . . Q:$$GET1^DIQ(9009016.1,BDGN,.14)=""  S DR=".14" D ^DIE Q:$D(Y)
 . ;
 . Q:$$GET1^DIQ(9009020.1,$$DIV^BSDU,ITEM)'="YES"  ;date not used
 . S DR=$P($T(FIELDS+(ITEM-200)),";;",2)           ;get corresponding field number
 . I (ITEM=206)!(ITEM=207) S DR=DR_";"_$S(ITEM=206:.22,1:.23)   ;coded by/bill prepped by
 . D ^DIE
 ;
 I $$GET1^DIQ(9009016.1,BDGN,.17)]"" S DR=.17 D ^DIE
 ;
 L -^BDGIC(BDGN)
 D REBUILD
 Q
 ;
VDATE ; EP; fix visit link - called by BDG ICE FIX VISIT protocol
 NEW APCDOVRR,DIE,DA,DR
 D FULL^VALM1 S APCDOVRR=1
 S DIE="^BDGIC(",DR=".03",DA=BDGN
 ;
 ;IHS/OIT/LJF 07/05/2006 PATCH 1006
 NEW CATG S CATG=$$GET1^DIQ(9009016.1,BDGN,.0392)     ;service category
 S DR=DR_";"_$S(CATG="DAY SURGERY":.05,1:.02)
 ;
 D ^DIE,PAUSE^BDGF,REBUILD
 Q
 ;
COMMENT ; EP; edit comments - called by BDG ICE COMMENTS protocol
 D FULL^VALM1 NEW DIE,DA,DR
 S DIE="^BDGIC(",DR=".18",DA=BDGN
 D ^DIE,REBUILD
 Q
 ;
ADDDEF ; EP; add chart deficiences - called by BDG ICE ADD DEF protocol
 NEW PROV,BDGDEF,COUNT,ACTION,CHOICES,Y,DIE,DR,DA,I,SCREEN,DATE
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
 . . K BDGDEF D FINDDEF(BDGN,PROV)                                          ;build array of deficiencies for provider
 . . I '$D(BDGDEF) D ADDMORE(BDGN,PROV) S QUIT=1 Q                          ;if none yet, go to add mode
 . . ;
 . . D MSG^BDGF($$SP(5)_"*** "_$$GET1^DIQ(200,PROV,.01)_" Deficiencies ***",2,0)
 . . F COUNT=1:1 Q:'$D(BDGDEF(COUNT))  D MSG^BDGF($P(BDGDEF(COUNT),U),1,0)  ;display deficiencies
 . . ;
 . . D MSG^BDGF("",1,0)
 . . S ACTION(1)=" 1. ADD New Deficiencies"
 . . S ACTION(2)=" 2. EDIT Selected Deficiencies"
 . . S ACTION(3)=" 3. CLOSE Selected Deficiencies"
 . . S ACTION(4)=" 4. QUIT"
 . . S Y=$$READ^BDGF("NO^1:4","Select Action",4,"","",.ACTION) Q:Y<1
 . . I Y=4 S QUIT=1 Q
 . . I Y=1 D ADDMORE(BDGN,PROV) Q
 . . S ACTION=Y
 . . ;
 . . S CHOICES=$$READ^BDGF("LO^1:"_(COUNT-1),"Select Which Deficiencies to "_$S(ACTION=2:"EDIT",1:"CLOSE"))
 . . ;
 . . ; close multiple deficiencies
 . . I ACTION=3 D  Q
 . . . S DATE=$$READ^BDGF("DO^::EX","Enter DATE RESOLVED") Q:'DATE
 . . . S DIE="^BDGIC("_BDGN_",1,",DR=".03///"_DATE,DA(1)=BDGN
 . . . F I=1:1 S DA=$P(CHOICES,",",I) Q:DA=""  W !?3,"Closing "_$E($P(BDGDEF(DA),U),5,40) S DA=$P(BDGDEF(DA),U,2) D ^DIE
 . . ;
 . . ; else edit selected deficiencies
 . . S DIE="^BDGIC("_BDGN_",1,",DR=".02;.03;.06;.04;.05",DA(1)=BDGN
 . . F I=1:1 S DA=$P(CHOICES,",",I) Q:DA=""  D
 . . . D MSG^BDGF($P(BDGDEF(DA),U),2,0)
 . . . S DA=$P(BDGDEF(DA),U,2)
 . . . D ^DIE
 L -^BDGIC(BDGN)
 D REBUILD
 Q
 ;
FINDDEF(BDGN,PRV) ; return BDGDEF array with current deficiencies for provider PRV
 NEW COUNT,IEN,LINE,IENS
 S (IEN,COUNT)=0
 F  S IEN=$O(^BDGIC(BDGN,1,"B",PROV,IEN)) Q:'IEN  D
 . S IENS=IEN_","_BDGN
 . I '$G(BDGDFALL) Q:$$GET1^DIQ(9009016.11,IENS,.03)]""   ;if not view all mode, don't show resolved ones
 . I '$G(BDGDFALL) Q:$$GET1^DIQ(9009016.11,IENS,.04)]""   ;if not view all mode, don't show deleted ones
 . S COUNT=COUNT+1
 . S LINE=$$PAD($J(COUNT,3),5)_$$GET1^DIQ(9009016.11,IENS,.02)        ;def name
 . S LINE=$$PAD(LINE,40)_$$GET1^DIQ(9009016.11,IENS,.0393)            ;status
 . S BDGDEF(COUNT)=LINE_U_IEN
 Q
 ;
ADDMORE(BDGN,PRV) ; add new deficiencies for provider
 NEW DIE,DR,DA,QUIT,DIC,DEF,DLAYGO,Y
 I $$GET1^DIQ(9009016.1,BDGN,.14)]"" D MSG^BDGF("Cannot add deficiencies to a COMPLETED chart",1,1),PAUSE^BDGF Q
 D MSG^BDGF(" Add Mode for Deficiencies. . .",2,0)
 S QUIT=0 F  D  Q:QUIT
 . K DIC S DIC="^BDGCD(",DIC(0)="AEMQZ",DIC("S")="I $P(^BDGCD(+Y,0),U,4)'=""I"""
 . D ^DIC S DEF=+Y I Y<1 S QUIT=1 Q
 . I $$HAVEDEF(BDGN,PRV,DEF) Q:'$$READ^BDGF("Y","This deficiency already defined for this provider.  Do you really want to add it again","NO")
 . ;
 . Q:'$$READ^BDGF("Y","Okay to add "_Y(0,0)_" for this provider","YES")
 . K DIC,DA,DD,DO
 . S DIC="^BDGIC("_BDGN_",1,",DA(1)=BDGN,X=PRV,DIC(0)="L"
 . S DIC("P")=$P(^DD(9009016.1,1,0),U,2),DLAYGO=9009016.11
 . S DIC("DR")=".02///"_DEF
 . D FILE^DICN Q:Y=-1
 . ;
 . S DIE="^BDGIC("_BDGN_",1,",DA(1)=BDGN,DA=+Y,DR=".03;.06" D ^DIE
 Q
 ;
HAVEDEF(BDGN,PRV,DEF)  ;returns 1 if this record & this provider already have this deficincy defined
  NEW IEN,FOUND
  S (IEN,FOUND)=0 F  S IEN=$O(^BDGIC(BDGN,1,"B",PRV,IEN)) Q:'IEN  Q:FOUND  D
  . I $P(^BDGIC(BDGN,1,IEN,0),U,2)=DEF S FOUND=1
  Q FOUND
  ;
COMPLETE ; EP; mark chart as completed - called by BDG ICE COMPLETE protocol
 D FULL^VALM1 NEW DIE,DA,DR
 I $$PENDING(BDGN) D  Q
 . D MSG^BDGF("SORRY, you cannot complete this chart; there are pending deficiences",1,1)
 . D PAUSE^BDGF S VALMBCK="R"
 S DIE="^BDGIC(",DR=".14",DA=BDGN
 D ^DIE,REBUILD
 Q
 ;
DELETE ; EP; delete chart - in as a mistake - called by BDG ICE DELETE protocol
 D FULL^VALM1 NEW DIE,DA,DR
 I $$GET1^DIQ(9009016.1,BDGN,.17)="",'$$READ^BDGF("Y","Was this chart entered as a mistake or duplicate","NO") S VALMBCK="R" Q
 S DIE="^BDGIC(",DR=".17;.18",DA=BDGN
 D ^DIE,REBUILD
 Q
 ;
PAD(D,L) ; pad length of data
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
 S X=$$GET1^DID(9009016.1,FIELD,"","TITLE")
 I X="" S X=$$GET1^DID(9009016.1,FIELD,"","LABEL")
 Q X
 ;
PENDING(IEN) ; return 1 if chart has at least one pending deficiency
 NEW IEN2,FOUND,IENS
 S (IEN2,FOUND)=0 F  S IEN2=$O(^BDGIC(IEN,1,IEN2)) Q:'IEN2  Q:FOUND  D
 . S IENS=IEN2_","_IEN
 . I $$GET1^DIQ(9009016.11,IENS,.03)]"" Q    ;skip if resolved
 . I $$GET1^DIQ(9009016.11,IENS,.04)]"" Q    ;skip if deleted
 . S FOUND=1
 Q FOUND
 ;
FIELDS ;;
 ;;
 ;;.11;;date received;;
 ;;.19;;date tagged;;
 ;;.21;;insurance identified;;
 ;;.12;;ready to code;;
 ;;.13;;coded;;.22;;coded by;;
 ;;.15;;bill prep ready;;.23;;bill prep by;;
 ;;.16;;date billed;;
