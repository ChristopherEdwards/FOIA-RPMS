BTIUICL ; IHS/ITSC/LJF - AWAITING SIGNATURES REPORT ;
 ;;1.0;TEXT INTEGRATION UTILITIES;;NOV 04, 2004
 ;Requires PIMS version 5.3
 ;
EN ; -- main entry point for BTIU IC LISTING option
 D ^XBCLS D MSG^BTIUU($$SP(20)_"Awaiting Signature Listing",2,2,0)
 I '$L($T(^BDGF1)) D MSG^BTIUU("** Sorry, you must have ADT version 5.3 to run this report! **",2,2,0),PAUSE^BTIUU Q
 ;
 NEW TIUPROV S TIUPROV=+$$PROV Q:'TIUPROV
 NEW VALMCNT
 D TERM^VALM0
 D EN^VALM("BTIU IC SIG STATUS")
 Q
 ;
HDR ; -- header code
 Q
 ;
INIT ; -- init variables and list array
 NEW TIULN
 D GATHER(TIUPROV)
 S VALMCNT=TIULN
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K VALMCNT
 K ^TMP("BTIUICL",$J)
 Q
 ;
EXPND ; -- expand code
 Q
 ;
GATHER(PROV) ; -- create display array
 NEW X,TIUCNT,TIUCD,IEN,IEN2,CD,DATE,DATE2,LINE,TIUN,DFN
 D MSG^BTIUU("Building/Updating Display. . .Please wait.",2,0,0)
 K ^TMP("BTIUICL",$J)
 S (TIUCNT,TIULN)=0
 S IEN=0 F  S IEN=$O(^BDGIC("APRV",PROV,IEN)) Q:'IEN  D
 . Q:$$GET1^DIQ(9009016.1,IEN,.17)]""           ;deleted entry
 . S IEN2=0 F  S IEN2=$O(^BDGIC("APRV",PROV,IEN,IEN2)) Q:'IEN2  D
 .. S CD=$P($G(^BDGIC(IEN,1,IEN2,0)),U,2) Q:'CD
 .. S DFN=$$GET1^DIQ(9009016.1,IEN,.01,"I")                 ;patient ien
 .. Q:'$$SIG(CD)                                            ;deficiency not on list
 .. S DATE=$$GET1^DIQ(9009016.1,IEN,.02,"I")                ;discharge date
 .. S DATE2=$$GET1^DIQ(9009016.1,IEN,.05,"I")               ;surgery date
 .. I DATE S LINE=$$DATA(DFN,IEN,PROV,CD,DATE,0,.TIUN)      ;inpt line
 .. I DATE2 S LINE=$$DATA(DFN,IEN,PROV,CD,DATE2,1,.TIUN)    ;ds line
 .. ;
 .. ;code for partial entries
 .. I 'DATE,'DATE2 D                          ;if dates are missing
 ... S X=$$GET1^DIQ(9009016.1,IEN,.03,"I")    ;visit pointer
 ... S X=$$GET1^DIQ(9000010,+X,.01,"I")       ;visit date
 ... S LINE=$$DATA(DFN,IEN,PROV,CD,X,2,.TIUN)
 .. ;
 .. D SET(LINE,TIUCNT,IEN,$G(TIUN))           ;put line into array
 ;
 Q
 ;
SIG(CD) ; -- returns 1 if chart deficiency on list for report
 I '$D(TIUCD) D CDSET
 I $D(TIUCD(CD)) Q 1
 Q 0
 ;
CDSET ; -- returns TIUCD array with deficiencies linked to tiu
 NEW X,Y
 S X=0 F  S X=$O(^BDGCD(X)) Q:'X  D
 . S Y=$P($G(^BDGCD(X,"TIU")),U)
 . I Y S TIUCD(X)=Y
 Q
 ;
DATA(DFN,IEN,PROV,CD,DATE,DAY,TIUN) ; -- returns display line
 NEW X,LINE
 S TIUCNT=TIUCNT+1,LINE=$J(TIUCNT,3)
 S LINE=$$PAD(LINE,5)_$$PAD($E($$GET1^DIQ(200,PROV,.01),1,15),17)
 S LINE=LINE_$$PAD($$PAT(DFN),18)
 S LINE=LINE_$$PAD($J($$FMTE^XLFDT(DATE,"2D"),8),10)
 S LINE=LINE_$$PAD($E($$GET1^DIQ(9009016.4,CD,.01),1,10),12)
 ;
 ;code for partial entries
 I DAY=1 S LINE=LINE_"DS-"   ;day surgery entry
 I DAY=2 S LINE=LINE_"??-"   ;unknown type
 ;
 S LINE=LINE_$$DOCSTAT(CD,DFN,IEN,DATE,DAY,.TIUN)
 Q LINE
 ;
PAT(DFN) ; -- returns patient chart # and last name
 NEW X,Y
 S X=$P($G(^AUPNPAT(DFN,41,DUZ(2),0)),U,2)
 S Y=$P($P($G(^DPT(DFN,0)),U),",")
 Q $J(X,7)_" "_Y
 ;
DOCSTAT(CD,DFN,IEN,DATE,DAY,TIUN) ; -- returns status of doc tied to deficiency
 NEW CLASS,TIUST,VISIT,TIU,TYPE,TIUR,X,Y
 S VISIT=$$GET1^DIQ(9009016.1,IEN,.03,"I") I 'VISIT Q "?? No visit"
 S CLASS=TIUCD(CD)  ;get doc class
 ;
 ; find all documents for visit and chart deficiency
 S TIU=0 F  S TIU=$O(^TIU(8925,"V",VISIT,TIU)) Q:'TIU  D
 . S TYPE=+$G(^TIU(8925,TIU,0)) Q:'$$CLASS(CLASS,TYPE,TIU)
 . ;
 . ; get document status
 . K TIUR D ENP^XBDIQ1(8925,TIU,".05;1501;1507","TIUR(","I")
 . S X=TIUR(.05),Y=""
 . I X="COMPLETED" S Y=$S(TIUR(1507)]"":TIUR(1507,"I"),1:TIUR(1501,"I"))
 . I Y]"" S Y=$$FMTE^XLFDT(Y,"2D")
 . S TIUST=$G(TIUST)_X_" "_Y,TIUN=TIU
 ;
 Q $S($D(TIUST):TIUST,1:"?? Not in TIU")
 ;
CLASS(CLASS,TYPE,TIU) ; -- returns 1 if doc is in corect doc class
 I TYPE=CLASS Q 1
 I $$GET1^DIQ(8925.1,TYPE,.01)="ADDENDUM" S TYPE=$$GET1^DIQ(8925,TIU,.04,"I")
 I $$DOCCLASS^TIULC1(TYPE)=CLASS Q 1
 Q 0
 ;
SET(LINE,COUNT,IEN,TIU) ; -- sets ^tmp
 S TIULN=TIULN+1
 S ^TMP("BTIUICL",$J,TIULN,0)=LINE
 S ^TMP("BTIUICL",$J,"IDX",TIULN,COUNT)=IEN_U_TIU
 Q
 ;
 ;
GETIC ; -- select item from list
 NEW X,Y,Z,VALMY
 D FULL^VALM1
 S TIUICN=0
 D EN^VALM2(XQORNOD(0),"OS")
 I '$D(VALMY) Q
 S X=$O(VALMY(0))
 S Y=0 F  S Y=$O(^TMP("BTIUICL",$J,"IDX",Y)) Q:Y=""  Q:TIUICN>0  D
 . S Z=$O(^TMP("BTIUICL",$J,"IDX",Y,0))
 . Q:^TMP("BTIUICL",$J,"IDX",Y,Z)=""
 . I Z=X S TIUICN=^TMP("BTIUICL",$J,"IDX",Y,Z)
 Q
 ;
ICE ;EP; -- action to edit IC file
 NEW TIUICN,DDSFILE,DA,DR,VSTYP,BDGN
 D GETIC I 'TIUICN Q
 S VSTYP=$$GET1^DIQ(9000010,+$$GET1^DIQ(9009016.1,+TIUICN,.03,"I"),.07,"I")        ;visit service category
 S DDSFILE=9009016.1,(DA,BDGN)=+TIUICN
 S DR=$S(VSTYP="H":"[BDG INCOMPLETE EDIT]",1:"[BDG DAY SURGERY EDIT]")
 D ^DDS
 Q
 ;
ICP ;EP; -- action to print chart copy
 NEW TIUICN
 D GETIC Q:'TIUICN  S TIUDA=$P(TIUICN,U,2) I TIUDA="" Q
 D PRINT1^TIURA
 Q
 ;
RESET ;EP; -- action to rebuild display
 S TIUPROV=+$$PROV I TIUPROV<1 S VALMBCK="Q" Q
 D TERM^VALM0 S VALMBCK="R"
 D INIT,HDR Q
 ;
PAD(DATA,LENGTH) ; -- SUBRTN to pad length of data
 Q $E(DATA_$$REPEAT^XLFSTR(" ",LENGTH),1,LENGTH)
 ;
SP(NUM) ; -- SUBRTN to pad spaces
 Q $$PAD(" ",NUM)
 ;
PROV() ; -- ask for provider
 NEW Y,SCREEN
 S SCREEN="I $D(^XUSEC(""PROVIDER"",+Y))"
 S Y=$$READ^TIUU("PO^200:EMQZ","Select PROVIDER NAME","","",SCREEN)
 I Y<1 W !,"No provider selected" D RETURN^BTIUU Q 0
 ;
 ; does provider have incomplete charts?
 I '$O(^BDGIC("APRV",+Y,0)) W !!,"Provider does NOT have any incomplete charts.",! D RETURN^BTIUU Q 0
 Q +Y
