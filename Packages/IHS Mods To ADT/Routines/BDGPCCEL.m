BDGPCCEL ; IHS/ANMC/LJF - CODE PCC VISIT LISTING ;  [ 08/12/2002  10:14 AM ]
 ;;5.3;PIMS;**1005,1006,1010**;MAY 28, 2004
 ;IHS/OIT/LJF 03/16/2006 PATCH 1005 added HF & PED mnemonic choices
 ;                                  drops into ADD mode if nothing to MODIFY
 ;            04/06/2006 patch 1005 added trigger to stuff date coded in NICE
 ;                                  prevent ^DGPMEX from asking patient name again
 ;            07/07/2006 PATCH 1006 prevent error if no mnemonic is selected
 ;cmi/anch/maw 10/20/2008 PATCH 1010 changed date exported field from .14 to 1106
 ;
EN ; -- main entry point for BDG IC CODE
 ; Assumes DFN and BDGV are set
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BDG IC CODE")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 NEW X,Y,VH
 S VALMHDR(1)=$$SP(15)_$$CONF^BDGF
 ;
 S X=$$GET1^DIQ(2,DFN,.01)_$$SP(5)_"#"_$$HRCN^BDGF2(DFN,DUZ(2))
 S VALMHDR(2)=$$SP(79-$L(X)\2)_X
 ;
 S VH=$O(^AUPNVINP("AD",BDGV,0)) Q:'VH
 S X=$$GET1^DIQ(9000010.02,VH,.15)
 S Y="Coding Complete? "_$S(X="NO":"NO",1:"YES")
 ;S VALMHDR(3)=$$PAD(Y,30)_"Exported on "_$$GET1^DIQ(9000010,BDGV,.14)  ;cmi/maw 10/10/2008 PATCH 1010 orig line
 S VALMHDR(3)=$$PAD(Y,30)_"Exported on "_$$GET1^DIQ(9000010,BDGV,1106)  ;cmi/maw 10/10/2008 PATCH 1010 new export date
 Q
 ;
INIT ; -- init variables and list array
 K ^TMP("BDGPCCE",$J)
 S VALMCNT=0
 D MSG^BDGF("Please wait while I gather all visit data...",2,0)
 D ^BDGPCCE1   ;build display screens
 Q
 ;
ADMIT ;EP; called by Admission Data protocol
 D FULL^VALM1
 ;
 I '$O(^DGPM("AVISIT",BDGV,0)) D  Q
 . D MSG^BDGF("Visit NOT linked to ADT Admission",2,0)
 . D MSG^BDGF("Cannot continue.  Please advise your supervisor.",1,0)
 . D PAUSE^BDGF
 ;
 NEW BDGVH
 S BDGVH=$O(^AUPNVINP("AD",BDGV,0)) I 'BDGVH D  Q
 . D MSG^BDGF("No V Hospitalization linked with Visit!!!",2,0)
 . D MSG^BDGF("Cannot continue.  Please advise your supervisor.",1,0)
 . D PAUSE^BDGF
 ;
 ; add/edit # of consults and admitting dx
 L +^AUPNVINP(BDGVH):3 I '$T D  Q
 . D MSG^BDGF("Someone else is updating this hospitalization.",2,0)
 . D MSG^BDGF("Please try again later.",1,0),PAUSE^BDGF
 K DIE,DA,DR S DIE="^AUPNVINP(",DA=BDGVH,DR=".08;.12" D ^DIE,EDIT
 L -^AUPNVINP(BDGVH)
 ;
 ; add/edit DRG
 L +^AUPNVSIT(BDGV):3 I '$T D  Q
 . D MSG^BDGF("Someone else is updating this visit.",2,0)
 . D MSG^BDGF("Please try again later.",1,0),PAUSE^BDGF
 K DIE,DA,DR S DIE="^AUPNVSIT(",DA=BDGV,DR=".34" D ^DIE,EDIT
 L -^AUPNVSIT(BDGV)
 ;
 ; call ADT to edit common fields
 NEW DGPMCA,DGPMEX,DGPMAN,BDGDFN
 S DGPMCA=$O(^DGPM("AVISIT",BDGV,0)),DGPMEX=""
 S DGPMAN=$G(^DGPM(+DGPMCA,0)),BDGDFN=DFN
 S ^DISV(DUZ,"DGPMEX",DFN)=DGPMCA
 ;
 ;IHS/OIT/LJF 04/06/2006 PATCH 1005 set BDGCODE to prevent asking patient name again
 NEW BDGCODE S BDGCODE=1
 ;
 D ENEX^DGPMV20,ASK^DGPMEX,EDIT             ;call extended bed control
 S (DFN,AUPNPAT)=BDGDFN D SETPT^BDGF(DFN)   ;reset patient variables
 ;
 D RESET
 Q
 ;
ADD ;EP; called by Add/Modify PCC Data protocol
 NEW APCDCAT,APCDVSIT,APCDPAT,APCDLOC,APCDTYPE,APCDMODE,APCDPARM
 NEW APCDMNE,BDGMN,BDGA,Y,APCDVLDT,APCDVLK,BDGBL,DIC
 S APCDCAT="H",(APCDVSIT,APCDVLK)=BDGV,APCDPAT=DFN
 S APCDPARM=$G(^APCDSITE(DUZ(2),0))
 S (APCDDATE,APCDVLDT)=$$GET1^DIQ(9000010,BDGV,.01,"I")
 S APCDLOC=DUZ(2),APCDTYPE=$$GET1^DIQ(9000010,BDGV,.03,"I")
 ;
 D FULL^VALM1,^APCDEIN
ASK ;
 ;IHS/OIT/LJF 03/16/2006 PATCH 1005 rewrote subrtn to handle HF and PED
 K BDGA,APCDMNE W !!
 S BDGA(1)="  (1) DIAGNOSIS                (5) IMMUNIZATIONS"
 S BDGA(2)="  (2) PROCEDURES               (6) HEALTH FACTORS"
 S BDGA(3)="  (3) PROVIDERS                (7) PATIENT EDUCATION"
 S BDGA(4)="  (4) ADMITTING DX             (8) OTHER MNEMONICS"
 S BDGMN=$$READ^BDGF("NO^1:8","Select One","","","",.BDGA)
 I 'BDGMN D ENDADD Q
 ;
 ;IHS/OIT/LJF 07/07/2006 PATCH 1006 rewrote section
 ;I BDGMN=8 D  Q
 I BDGMN=8 D  D ASK Q
 . ;S Y=$$READ^BDGF("P^9001001:EMQZ","MNEMONIC")
 . S Y=$$READ^BDGF("P^9001001:EMQZ","MNEMONIC") Q:Y<1
 . S APCDMNE=+Y,APCDMNE("NAME")=$P(Y,U,2)
 . S APCDMODE=$$READ^BDGF("SO^A:ADD;M:MODIFY","Select MODE")
 . ;D ^APCDEA3,ASK
 . D ^APCDEA3
 ;
 E  S DIC=9001001,DIC(0)="",X=$P($T(MNE+BDGMN),";;",2) D ^DIC
 I Y<1 D ASK Q
 S APCDMNE=+Y,APCDMNE("NAME")=$P(Y,U,2)
 S BDGBL=$P($T(MNE+BDGMN),";;",3) I (BDGMN'=8),(BDGBL="") S APCDMODE="M"
 E  D
 . S Y=BDGBL_"(""AD"","_BDGV_",0)" I '$O(@Y) S APCDMODE="A" Q
 . S APCDMODE=$$READ^BDGF("SO^A:ADD;M:MODIFY","Select MODE")
 I (APCDMODE="")!(APCDMODE=U)
 ;
 D ^APCDEA3,ASK Q
 ;
 ; when done with coding, mark visit as edited and return to display
ENDADD D EDIT,RESET
 Q
 ;
LIST ;EP; Called by List I Visits protocol
 D EN^BDGPCCE2 S VALMBCK="R" Q
 ;
PROB ;EP; Called by Problem List Update protocol
 NEW VALMCNT
 D EN1^APCDPL   ;public entry point, assumes DFN is set
 S VALMBCK="R"
 Q
 ;
ALL ;EP; Called by Display All Data protocol (BDG IC PCC DISPLAY ALL)
 ; Also called by BDG VIEW PCC protocol
 NEW APCDPAT,APCDVSIT
 S APCDPAT=DFN,APCDVSIT=BDGV
 D ^APCDVD                      ;public entry point
 D EN^XBVK("APCD") S VALMBCK="R"
 Q
 ;
FASH ;EP; Called by Final A Sheet protocol
 NEW DGPMCA,BDGFIN
 D FULL^VALM1
 S DGPMCA=$O(^DGPM("AVISIT",BDGV,0))
 S BDGFIN=$$READ^BDGF("SO^1:A Sheet Only;2:A Sheet with CPT List;3:Medicare/Medicaid A Sheet","Select Report to Print",$$GET1^DIQ(9009020.1,$$DIV^BSDU,.07,"I"),"^D FINHLP^BDGCRB")
 I 'BDGFIN S VALMBCK="R" Q
 D PAT^BDGCRB(DFN,DGPMCA,BDGFIN,1,2)
 D PAUSE^BDGF S VALMBCK="R"
 Q
 ;
RESET ;EP; return from protocol & rebuild list
 S VALMBCK="R" D TERM^VALM0,HDR,INIT Q
 ;
EDIT ; update date last edited
 NEW AUPNVSIT S AUPNVSIT=BDGV D MOD^AUPNVSIT Q
 ;
CHECK(DATE) ;EP; run inpatient edit check
 ; DATE=1 if check to be run only if updated today
 ; DATE=0 run check anyway
 I DATE,$$GET1^DIQ(9000010,BDGV,.13,"I")'=DT Q
 ;
 NEW BDGVH,X,Y
 S BDGVH=$O(^AUPNVINP("AD",BDGV,0)) Q:'BDGVH
 D FULL^VALM1
 S X=$$GET1^DIQ(9000010.02,BDGVH,.15)
 S Y="Coding Complete? "_$S(X="NO":"NO",1:"YES")
 ;S X=$$GET1^DIQ(9000010,BDGV,.14)  ;cmi/maw 10/20/2008 PATCH 1010 orig line
 ;I X]"" S Y=$$PAD(Y,30)_"Exported on "_$$GET1^DIQ(9000010,BDGV,.14)  ;cmi/maw 10/20/2008 PATCH 1010 orig line
 S X=$$GET1^DIQ(9000010,BDGV,1106)  ;cmi/maw 10/20/2008 PATCH 1010 new export date
 I X]"" S Y=$$PAD(Y,30)_"Exported on "_$$GET1^DIQ(9000010,BDGV,1106)  ;cmi/maw 10/20/2008 PATCH 1010 new export date
 D MSG^BDGF(Y,2,0)
 ;
 NEW APCDPARM,APCDVSIT,APCDLVST,APCDDATE,APCDTYPE
 S APCDPARM=$G(^APCDSITE(DUZ(2),0))
 S APCDVSIT=BDGV,APCDLVST=BDGV,APCDPAT=DFN
 S (APCDVLDT,APCDDATE)=$$GET1^DIQ(9000010,BDGV,.01,"I")
 S APCDTYPE=$$GET1^DIQ(9000010,BDGV,.03,"I")
 D ^APCDVCHK,PAUSE^BDGF
 S VALMBCK="R"
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 D CHECK(1)
 ;
 ;IHS/OIT/LJF 04/06/2006 PATCH 1005 trigger date coded in NICE if coding complete
 NEW ICN,VH
 S ICN=$O(^BDGIC("AV",BDGV,0))     ;find IC entry based on visit
 S VH=$O(^AUPNVINP("AD",BDGV,0))   ;find v hosp entry
 I ICN,VH,$$GET1^DIQ(9000010.02,VH,.15)="",$$GET1^DIQ(9009016.1,ICN,.13)="" D
 . S DIE="^BDGIC(",DA=ICN,DR=".13///"_DT D ^DIE                  ;stuff date coded
 . I $$GET1^DIQ(9009016.1,ICN,.22)="" S DR=".22///`"_DUZ D ^DIE  ;stuff who coded chart
 ;end of PATCH 1005 code
 ;
 K ^TMP("BDGPCCE",$J) K BDGV,DFN D KILL^AUPNPAT
 Q
 ;
EXPND ; -- expand code
 Q
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
 ;
 ;IHS/OIT/LJF 03/16/2006 PATCH 1005 added HF & PED & global refs
MNE ;;     
 ;;PV;;^AUPNVPOV;;
 ;;OP;;^AUPNVPRC;;
 ;;PRV;;^AUPNVPRV;;
 ;;ADX;;
 ;;IM;;^AUPNVIMM;;
 ;;HF;;^AUPNVHF;;
 ;;PED;;^AUPNVPED;;
