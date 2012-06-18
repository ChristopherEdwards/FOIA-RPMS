BDGPCCE2 ; IHS/ANMC/LJF - PULL UP ALL I VISITS ; 
 ;;5.3;PIMS;**1005**;MAY 28, 2004
 ;IHS/OIT/LJF 04/14/2006 PATCH 1005 added ;EP to EN - called by BDGPCCEL
 ;
EN ;EP -- main entry point for BDG IC I VISITS ;IHS/OIT/LJF 04/14/2006 PATCH 1005
 ; Assumes DFN and BDGV are set
 D MSG^BDGF("Please wait while I compile the list...",1,0)
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BDG IC I VISITS")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 NEW X,Y,VH
 S VALMHDR(1)=$$SP(15)_$$CONF^BDGF
 ;
 S X=$$GET1^DIQ(2,DFN,.01)_$$SP(5)_$$HRCN^BDGF2(DFN,DUZ(2))
 S VALMHDR(2)=$$SP(79-$L(X)\2)_X
 ;
 S X="Admitted on "_$$GET1^DIQ(9000010,BDGV,.01)
 S VALMHDR(3)=$$SP(79-$L(X)\2)_X
 Q
 ;
INIT ; -- init variables and list array
 K ^TMP("BDGPCCE2",$J)
 S VALMCNT=0
 NEW ADM,DSC,BEG,DATE,VST,COUNT,LINE
 S ADM=$$GET1^DIQ(9000010,BDGV,.01,"I")\1           ;admit date
 S BEG=$$FMADD^XLFDT(ADM,-3)                        ;72/24 rule
 S DSC=$$GET1^DIQ(9000010.02,+$O(^AUPNVINP("AD",BDGV,0)),.01,"I")
 I DSC="" S DSC=DT
 S BEG=(9999999-BEG)_".9999999",DATE=9999999-DSC
 ;
 F  S DATE=$O(^AUPNVSIT("AA",DFN,DATE)) Q:'DATE  Q:(DATE>BEG)  D
 . S VST=0 F  S VST=$O(^AUPNVSIT("AA",DFN,DATE,VST)) Q:'VST  D
 .. I "HCTE"[$$GET1^DIQ(9000010,VST,.07,"I") Q
 .. I $$GET1^DIQ(9000010,VST,.11)="DELETED" Q
 .. I $$GET1^DIQ(9000010,VST,.06,"I")'=DUZ(2) Q  ;wrong facility
 .. ;
 .. S COUNT=$G(COUNT)+1   ;number used to select visit for editing
 .. S LINE=$J(COUNT,3)_". "_$$GET1^DIQ(9000010,VST,.01)    ;vist date
 .. S LINE=$$PAD(LINE,30)_$$GET1^DIQ(9000010,VST,.07,"I")  ;ser categ
 .. ;
 .. ; find all llinks v files to this visit
 .. K BDGA D VFILES(VST,.BDGA)
 .. I '$D(BDGA) D  Q
 ... D SET($$PAD(LINE,40)_"No Dependent Entries",.VALMCNT,COUNT,VST)
 .. ;
 .. S FIRST=1,NAME=0 F  S NAME=$O(BDGA(NAME)) Q:NAME=""  D
 ... S LINE=$$PAD(LINE,40)_$S(FIRST:"Has ",1:$$SP(4))
 ... S LINE=LINE_$J(BDGA(NAME),4)_" "_NAME
 ... D SET(LINE,.VALMCNT,COUNT,VST) S LINE=$$SP(40)
 .. D SET("",.VALMCNT,COUNT,VST)
 ;
 I '$D(^TMP("BDGPCCE2",$J)) D SET("No Visits Found",.VALMCNT,1,0)
 Q
 ;
VFILES(V,ARRAY) ; find linked v files and counts
 NEW FILE,GLOBAL,IEN,NAME
 S FILE=9000010
 F  S FILE=$O(^DIC(FILE)) Q:'FILE  Q:(FILE>9000010.9999)  D
 . S GLOBAL=$G(^DIC(FILE,0,"GL")) Q:GLOBAL=""
 . S GLOBAL=$P(GLOBAL,"(")     ;strip off parens
 . S NAME=$P($P(^DIC(FILE,0),U),"V ",2)_"S"
 . ;
 . S IEN=0 F  S IEN=$O(@GLOBAL@("AD",V,IEN)) Q:'IEN  D
 .. S ARRAY(NAME)=$G(ARRAY(NAME))+1
 Q
 ;
SET(DATA,NUM,CNT,IEN) ; put display line into array
 S NUM=NUM+1
 S ^TMP("BDGPCCE2",$J,NUM,0)=DATA
 S ^TMP("BDGPCCE2",$J,"IDX",NUM,CNT)=IEN
 Q
 ;
EDITCAT ;EP; called by Edit Service Category protocol
 NEW BDGN,DIE,DA,DR,AUPNVSIT
 D GETVST I 'BDGN S VALMBCK="R" Q
 S DIE="^AUPNVSIT(",DA=BDGN,DR=".07" D ^DIE
 S AUPNVSIT=BDGN D MOD^AUPNVSIT
 D RESET
 Q
 ;
EDITVST ;EP; called by Edit Visit protocol
 NEW APCDVSIT,APCDPAT,BDGN
 D GETVST I 'BDGN S VALMBCK="R" Q
 S APCDPAT=DFN,APCDVSIT=BDGN
 D EN^APCDEL,^APCDEKL,RESET
 Q
 ;
VIEWVST ;EP; called by View Visit protocol
 NEW BDGN,APCDPAT,APCDVSIT
 D GETVST I 'BDGN S VALMBCK="R" Q
 S APCDPAT=DFN,APCDVSIT=BDGN
 D ^APCDVD                      ;public entry point
 D EN^XBVK("APCD") S VALMBCK="R"
 Q
 Q
 ;
RESET ;EP; return from protocol & rebuild list
 S VALMBCK="R" D TERM^VALM0,HDR,INIT Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BDGPCCE2",$J)
 Q
 ;
EXPND ; -- expand code
 Q
 ;
GETVST ;  select visit from list
 ; returns BDGN
 NEW X,Y,Z
 S BDGN=0 D FULL^VALM1
 D EN^VALM2(XQORNOD(0),"OS")
 I '$D(VALMY) Q
 S X=0 F  S X=$O(VALMY(X)) Q:X=""  D
 . S Y=0 F  S Y=$O(^TMP("BDGPCCE2",$J,"IDX",Y)) Q:Y=""  D
 .. S Z=$O(^TMP("BDGPCCE2",$J,"IDX",Y,0))
 .. Q:^TMP("BDGPCCE2",$J,"IDX",Y,Z)=""
 .. I Z=X S BDGN=^TMP("BDGPCCE2",$J,"IDX",Y,Z)
 Q
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
