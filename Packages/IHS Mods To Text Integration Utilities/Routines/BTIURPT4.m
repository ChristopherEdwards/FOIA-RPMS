BTIURPT4 ; IHS/ITSC/LJF - Review documents by Reference Date ;
 ;;1.0;TEXT INTEGRATION UTILITIES;;NOV 04, 2004
 ;Copy of ^TIURPTTL - IHS Browse document texts by visit date
 ;   -- used to set up view of all documents for a patient
 ;   -- added IHS fields to display in IHS order
 ;   -- added view check to screen out documents
 ;   -- commented out lines and changed loop to display ALL documents
 ;   -- removed question where user lists which types to display
 ;   -- changed begin date default to T-6M
 ;   -- added check for calls from other packages (tiuzihs)
 ;
MAKELIST(TIUCLASS) ; Get Search Criteria
 N TIUI,SCREEN,STATUS,TIUTYP,TIUSTAT,TIUEDFLT,TIUDCL,TIUQUIT
STATUS S STATUS=$$SELSTAT^TIULA(.TIUSTAT,"F","ALL")
 I +STATUS<0 S VALMQUIT=1 Q
PATIENT ; Select Patient
 ;S DFN=+$$PATIENT^TIULA               ;original VA
 K DFN I $G(TIUZIHS) S DFN=+TIUZIHS    ;check if called by other app
 E  S DFN=+$$PATIENT^TIULA             ;else use VA code
 I +DFN'>0 S VALMQUIT=1 Q
DOCTYPE ; Select Document Type(s)
 ;commented out VA code to search all documents
 ;N TIUDCL
 ;D TITLPICK^TIULA3(.TIUTYP,TIUCLASS)
 ;I +$D(TIUQUIT) S VALMQUIT=1 Q
 ;I +$G(TIUTYP)'>0,'$D(TIUQUIK) G STATUS
SCREEN ;
 N TIUNAME
 S TIUNAME=$P($G(^VA(200,+DUZ,0)),U)
 ;S SCREEN=1,SCREEN(1)="APT^"_DFN        ;original VA
 S SCREEN=1,SCREEN(1)="AIHS1^"_DFN       ;use IHS visit xref
 ;D CHECKADD(.TIUTYP)                    ;original VA - don't check addendums
ERLY ;S TIUEDFLT=$S(TIUCLASS=3:"T-2",TIUCLASS=244:"T-30",1:"T-7") ;original VA
 S TIUEDFLT="T-6M"                                            ;default is 6 months
 S TIUEDT=$S($D(TIUQUIK):1,1:$$EDATE^TIULA("Reference","",TIUEDFLT))
 I +$G(DIROUT) S VALMQUIT=1 Q
 I TIUEDT'>0 G SCREEN
 S TIULDT=$S($D(TIUQUIK):9999999,1:$$LDATE^TIULA("Reference"))
 I +$G(DIROUT) S VALMQUIT=1 Q
 I TIULDT'>0 G ERLY
 W !,"Searching for the documents."
 D BUILD(.TIUSTAT,.TIUTYP,.SCREEN,TIUEDT,TIULDT)
 Q
CHECKADD(TYPES) ; Checks whether Addendum is included in the list of types
 N TIUI,HIT S (TIUI,HIT)=0
 F  S TIUI=$O(TYPES(TIUI)) Q:+TIUI'>0!+HIT  I $$UP^XLFSTR(TYPES(TIUI))["ADDENDUM" S HIT=1
 I +HIT'>0 S TYPES(TYPES+1)=+TYPES(TYPES)+1_U_"81^Addendum^NOT PICKED",TYPES=TYPES+1
 Q
BUILD(STATUS,TYPES,SCREEN,EARLY,LATE) ; Build List
 N TIUCNT,TIUDT,TIUI,TIUJ,TIUK,TIUP,TIUQ,TIUIFN,TIUREC
 N TIUT,TIUTP,XREF,TIUS,TIUPREF
 S TIUPREF=$$PERSPRF^TIULE(DUZ),(TIUK,VALMCNT)=0
 K ^TMP("TIUR",$J),^TMP("TIURIDX",$J),^TMP("TIUI",$J)
 K ^TMP("TIURIHS",$J) S (TIUZLN,TIUZCNT)=0            ;added initialize of IHS variables
 I '$D(TIUPRM0)!'$D(TIUPRM0) D SETPARM^TIULE
 S EARLY=9999999-+$G(EARLY),LATE=9999999-$S(+$G(LATE):+$G(LATE),1:3333333)
 F  S TIUK=$O(SCREEN(TIUK)) Q:TIUK'>0  D
 . S XREF=$P(SCREEN(TIUK),U)
 . I XREF'="ASUB" D
 . . S TIUI=$S(XREF'="APRB":$P(SCREEN(TIUK),U,2),1:$$UPPER^TIULS($P(SCREEN(TIUK),U,3)))
 . . D GATHER(TIUI,TIUPREF,TIUCLASS)
 . I XREF="ASUB" D
 . . S TIUI=$O(^TIU(8925,XREF,$P(SCREEN(TIUK),U,2)),-1)
 . . F  S TIUI=$O(^TIU(8925,XREF,TIUI)) Q:TIUI=""!(TIUI'[$P(SCREEN(TIUK),U,2))  D GATHER(TIUI,TIUPREF,TIUCLASS)
 D PUTLIST(TIUPREF)
 S ^TMP("TIUR",$J,"RTN")="TIUROR"  ;rebuild routine
 Q
GATHER(TIUI,TIUPREF,CLASS) ; Find/sort records for the list
 N TIUT,TIUTP,TIUS,TIUSTAT,TIUSFLD,TIUD0,TIUD12,TIUD13,TIUD15
 N TIUSVAL
 ;S TIUSFLD=$P(TIUPREF,U,3)     ;original VA
 ;S TIUSFLD=$S(TIUSFLD="P":".02",TIUSFLD="D":".01",TIUSFLD="S":".05",TIUSFLD="C":"1507",TIUSFLD="A":"1202",TIUSFLD="E":"1208",1:"1301") ;original VA
 S TIUSFLD=".03"                ;sort by visit date
 ;
 ;S TIUT=0 F  S TIUT=$O(TYPES(TIUT)) Q:+TIUT'>0  D       ;original VA
 ;. S TIUTP=+$P($G(TYPES(TIUT)),U,2) Q:TIUTP'>0          ;original VA
 S TIUT=0 F  S TIUT=$O(^TIU(8925.1,TIUT)) Q:'TIUT  D     ;search thru all documents
 . S TIUTP=TIUT                                          ;set variable correctly
 . ;
 . S TIUS=0 F  S TIUS=$O(STATUS(TIUS)) Q:+TIUS'>0  D
 . . S TIUSTAT=$O(^TIU(8925.6,"B",$$UPPER^TIULS($P(STATUS(TIUS),U,3)),0))
 . . Q:+TIUSTAT'>0
 . . S TIUJ=LATE F  S TIUJ=$O(^TIU(8925,XREF,TIUI,TIUTP,TIUSTAT,TIUJ)) Q:+TIUJ'>0!(+TIUJ>EARLY)  D
 . . . S TIUIFN=0
 . . . F  S TIUIFN=$O(^TIU(8925,XREF,TIUI,TIUTP,TIUSTAT,TIUJ,TIUIFN)) Q:+TIUIFN'>0  D
 . . . . I TIUCLASS'=3,$$DOCCLASS^TIULC1(TIUT)'=TIUCLASS Q     ;added to screen out by doc class
 . . . . ;I TIUTP=81,(+TYPES>1),($P(TYPES(TIUT),U,4)="NOT PICKED"),'+$$DADINTYP(TIUIFN,.TYPES) Q ;original VA-addendums okay
 . . . . S TIUQ=$$RESOLVE(TIUIFN,TIUSFLD)
 . . . . S ^TMP("TIUI",$J,TIUQ,TIUJ,TIUIFN)=""
 Q
DADINTYP(TIUDA,TYPES) ; Evaluates whether addendum's parent belongs is among
 ;                 the selected types
 N TIUI,TIUDTYP,TIUY S (TIUI,TIUY)=0
 S TIUDTYP=+$G(^TIU(8925,+$P($G(^TIU(8925,+TIUDA,0)),U,6),0))
 F  S TIUI=$O(TYPES(TIUI)) Q:+TIUI'>0!+TIUY  D
 . I +$P(TYPES(TIUI),U,2)=TIUDTYP S TIUY=1
 Q TIUY
RESOLVE(DA,DR) ; Call DIQ1 to resolve field values
 Q $$GET1^DIQ(9000010,+$$GET1^DIQ(8925,DA,.03),.01,"I")_U_$$GET1^DIQ(8925,DA,DR,"I")_U_$$GET1^DIQ(8925,DA,1201,"I")  ;use IHS fields
 N DIC,DIQ,X,Y,TIUY S DIC=8925,DIQ="TIUY",DIQ(0)="IE"
 I DR=1507,($P($G(^TIU(8925,DA,0)),U,5)=7),(+$P($G(^TIU(8925,DA,15)),U,7)'>0) S DR=1501
 D EN^DIQ1
 I $D(TIUY) D
 . S TIUY=$S((DR=.05)!(DR=1301)!(DR=1501)!(DR=1507):$G(TIUY(8925,DA,DR,"I")),1:$G(TIUY(8925,DA,DR,"E")))
 I TIUY']"" S TIUY="ZZZZEMPTY"
 Q TIUY
PUTLIST(TIUPREF) ; Expands list elements for LM Template
 N TIUJ,TIUQ,TIUDA,TIUPICK,TIUORDER
 S TIUORDER=$S($P(TIUPREF,U,4)="D":-1,1:1)
 S TIUPICK=+$O(^ORD(101,"B","TIU ACTION SELECT LIST ELEMENT",0))
 S TIUQ="" F  S TIUQ=$O(^TMP("TIUI",$J,TIUQ),TIUORDER) Q:TIUQ']""  D
 . S TIUJ=0 F  S TIUJ=$O(^TMP("TIUI",$J,TIUQ,TIUJ)) Q:+TIUJ'>0  D
 . . S TIUDA=0 F  S TIUDA=$O(^TMP("TIUI",$J,TIUQ,TIUJ,TIUDA)) Q:+TIUDA'>0  D ADDELMNT(TIUDA,.TIUCNT)
 S TIUS=1,STATUS=$$UPPER^TIULS($P(STATUS(1),U,3))
 I +$G(STATUS(4))'>0 F  S TIUS=$O(STATUS(TIUS)) Q:+TIUS'>0  D
 . S STATUS=STATUS_$S(TIUS=+STATUS(1):" & ",1:", ")_$$UPPER^TIULS($P(STATUS(TIUS),U,3))
 I +$G(STATUS(4))>0 S STATUS=$S($P(STATUS(4),U,4)="ALL":"ALL",1:STATUS_" & OTHER")
 S ^TMP("TIUR",$J,0)=+$G(TIUCNT)_U_STATUS
 S TIUJ=0,SCREEN="" F  S TIUJ=$O(SCREEN(TIUJ)) Q:+TIUJ'>0  D
 . S SCREEN=$G(SCREEN)_$S(TIUJ>1:";",1:U)_SCREEN(TIUJ)
 S ^TMP("TIUR",$J,0)=^TMP("TIUR",$J,0)_$G(SCREEN)
 S ^TMP("TIUR",$J,"CLASS")=TIUCLASS
 S ^TMP("TIUR",$J,"#")=TIUPICK_"^1:"_+$G(TIUCNT)
 ;I $D(VALMHDR)>9 D HDR^TIURH       ;original VA
 I $D(VALMHDR)>9 D HDR^BTIURPT      ;use IHS header
 I +$G(TIUCNT)'>0 D
 . S ^TMP("TIUR",$J,1,0)="",VALMCNT=2
 . S ^TMP("TIUR",$J,2,0)="     No records found to satisfy search criteria."
 Q
ADDELMNT(DA,TIUCNT,APPEND) ; Add each element to the list
 N DIC,DIQ,DR,TIUR,PT,MOM,ADT,DDT,LCT,AUT,AMD,EDT,SDT,XDT,RMD,TIULST4
 I $G(^TMP("TIUR",$J,2,0))="     No records found to satisfy search criteria." D
 . S ^TMP("TIUR",$J,2,0)="",VALMCNT=0
 S DIQ="TIUR",DIC=8925,DIQ(0)="IE"
 S DR=".01;.02;.05;.07;.08;1202;1301;1204;1208;1501;1507" D EN^DIQ1
 S DOC=$$PNAME^TIULC1(+TIUR(8925,DA,.01,"I"))
 I DOC="Addendum" S DOC=DOC_" to "_$$PNAME^TIULC1(+$G(^TIU(8925,+$P(^TIU(8925,+DA,0),U,6),0)))
 S PT=$$NAME^TIULS(TIUR(8925,DA,.02,"E"),"LAST,FI MI")
 I +$O(^TIU(8925,"DAD",+DA,0)),$$HASADDEN^TIULC1(DA) S PT="+ "_PT
 S TIUP=$$URGENCY(+DA)
 S:TIUP=1 PT=$S(PT["+":"*",1:"* ")_PT
 S TIULST4=$E($P($G(^DPT(TIUR(8925,DA,.02,"I"),0)),U,9),6,9)
 S TIULST4="("_$E(TIUR(8925,DA,.02,"E"))_TIULST4_")"
 S ADT=$$DATE^TIULS(TIUR(8925,DA,.07,"I"),"MM/DD/YY")
 S DDT=$$DATE^TIULS(TIUR(8925,DA,.08,"I"),"MM/DD/YY")
 S AMD=$$NAME^TIULS(TIUR(8925,DA,1208,"E"),"LAST, FI MI")
 S AUT=$$NAME^TIULS(TIUR(8925,DA,1202,"E"),"LAST, FI MI")
 S EDT=$$DATE^TIULS(TIUR(8925,DA,1301,"I"),"MM/DD/YY")
 S SDT=$S(+TIUR(8925,DA,1507,"I"):TIUR(8925,DA,1507,"I"),TIUR(8925,DA,.05,"I")'<7:+TIUR(8925,DA,1501,"I"),1:"")
 S SDT=$$DATE^TIULS(SDT,"MM/DD/YY")
 S TIUCNT=+$G(TIUCNT)+1
 ;
 ;commented out code for VA fields
 ;S TIUREC=$$SETFLD^VALM1(TIUCNT,"","NUMBER")
 ;S TIUREC=$$SETFLD^VALM1($$LOWER^TIULS(TIUR(8925,DA,.05,"E")),TIUREC,"STATUS")
 ;S TIUREC=$$SETFLD^VALM1(TIULST4,TIUREC,"LAST I/LAST 4")
 ;S TIUREC=$$SETFLD^VALM1(PT,TIUREC,"PATIENT NAME")
 ;S TIUREC=$$SETFLD^VALM1(DOC,TIUREC,"DOCUMENT TYPE")
 ; S TIUREC=$$SETFLD^VALM1(ADT,TIUREC,"ADMISSION DATE")
 ;S TIUREC=$$SETFLD^VALM1(EDT,TIUREC,"REF DATE")
 ;S TIUREC=$$SETFLD^VALM1(SDT,TIUREC,"SIG DATE")
 ;S TIUREC=$$SETFLD^VALM1(AUT,TIUREC,"AUTHOR")
 ;S TIUREC=$$SETFLD^VALM1(AMD,TIUREC,"COSIGNER")
 ;
 D NOTES^BTIURPT(DA,"R")     ;IHS call to display document text
 ;
 ;S VALMCNT=+$G(VALMCNT)+1,^TMP("TIUR",$J,TIUCNT,0)=TIUREC  ;original VA
 S VALMCNT=+TIUZLN                                          ;set line # correctly
 ;S ^TMP("TIUR",$J,"IDX",VALMCNT,TIUCNT)="" W "."           ;original VA
 S ^TMP("TIURIDX",$J,TIUCNT)=VALMCNT_U_DA
 ;D FLDCTRL^VALM10(TIUCNT,"NUMBER",IOINHI,IOINORM)          ;original VA
 I +$G(APPEND) D
 . D RESTORE^VALM10(TIUCNT)
 . D CNTRL^VALM10(TIUCNT,1,$G(VALM("RM")),IOINHI,IOINORM),HDR^TIURH
 . S VALMSG="** Item #"_TIUCNT_" Added **"
 . S $P(^TMP("TIUR",$J,0),U)=+$G(TIUCNT)
 . S $P(^TMP("TIUR",$J,"#"),":",2)=+$G(TIUCNT)
 . I $D(VALMHDR)>9 D HDR^TIURH
 Q
CLEAN ; Clean up your mess!
 K ^TMP("TIUR",$J),^TMP("TIURIDX",$J) D CLEAN^VALM10
 K VALMY
 K TIUZCNT,TIUZLN ;IHS added
 Q
URGENCY(TIUDA) ; What is the urgency of the current document
 N TIUY,TIUD0,TIUDSTAT,TIUDURG
 S TIUD0=$G(^TIU(8925,+TIUDA,0)),TIUDSTAT=$P(TIUD0,U,5)
 S TIUDURG=$P(TIUD0,U,9)
 S TIUY=$S(TIUDSTAT<7:$S(TIUDURG="P":1,1:2),1:3)
 Q TIUY
DFLTSTAT(USER) ; Set default STATUS for current user
 N TIUMIS,TIUMD,TIUY,TIUDPRM D DOCPRM^TIULC1(244,.TIUDPRM)
 S TIUMIS=$$ISA^USRLM(DUZ,"MEDICAL INFORMATION SECTION")
 I +TIUMIS,+$P($G(TIUDPRM(0)),U,3) S TIUY="UNVERIFIED" G DFLTX
 I $$ISA^USRLM(DUZ,"PROVIDER") S TIUY="UNSIGNED" G DFLTX
 S TIUY="COMPLETED"
DFLTX Q TIUY
 ;
 ;IHS subrtns added
VSTDT() ; -- returns numdate of visit
 Q $$VSTDT^BTIURPT(DA)
 ;
VSTCAT() ; -- returns service category of visit
 Q $$VSTCAT^BTIURPT(DA)
 ;
VSTDX() ; -- returns prim dx for visit
 Q $$VSTDX^BTIURPT(DA)
