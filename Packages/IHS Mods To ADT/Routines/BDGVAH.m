BDGVAH ; IHS/ANMC/LJF - VIEW ADMISSION HISTORY ; 
 ;;5.3;PIMS;;APR 26, 2002
 ;
EN ; list manager view of patient's admissions      
 NEW DFN,VALMCNT
 S DFN=+$$READ^BDGF("PO^2:EMQZ","Select PATIENT") Q:DFN<1
 D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BDG VIEW ADMIT HISTORY")
 D CLEAR^VALM1
 Q
 ;
HDR ;EP; -- header code
 S VALMHDR(1)=$$SP(16)_$$CONF^BDGF
 NEW X S X=$$GET1^DIQ(2,DFN,.01)_"  #"_$$HRCN^BDGF2(DFN,DUZ(2))
 S X=X_" DOB: "_$$GET1^DIQ(2,DFN,.03)                  ;date of birth
 S X=X_" ("_$$GET1^DIQ(9000001,DFN,1102.98)_")"        ;age
 S VALMHDR(2)=$$SP(79-$L(X)\2)_X
 S X="Inpatient Status: "_$$STATUS^BDGF2(DFN)
 S VALMHDR(3)=$$SP(79-$L(X)\2)_X
 Q
 ;
INIT ; -- init variables and list array
 NEW DATE,ADM,LINE,X
 S VALMCNT=0 K ^TMP("BDGVAH",$J)
 S DATE=0
 F  S DATE=$O(^DGPM("APTT1",DFN,DATE)) Q:'DATE  D
 . S ADM=0
 . F  S ADM=$O(^DGPM("APTT1",DFN,DATE,ADM)) Q:'ADM  D
 .. Q:'$D(^DGPM(ADM,0))    ;quit if bad xref
 .. S LINE=$$NUMDATE^BDGF(+^DGPM(ADM,0)\1)_" - "        ;admit date
 .. S X=$$GET1^DIQ(405,ADM,.17,"I")                   ;discharge node
 .. I X S LINE=LINE_$$NUMDATE^BDGF(+$G(^DGPM(X,0))\1)   ;discharge date
 .. S LINE=$$PAD(LINE,26)_$$WRDABRV2^BDGF1(ADM)       ;admit ward
 .. S LINE=$$PAD(LINE,36)_$$GET1^DIQ(405,ADM,.07)     ;admit room
 .. S LINE=$$PAD(LINE,45)_$$ADMSRVC^BDGF1(ADM,DFN)     ;admit service
 .. S LINE=$$PAD(LINE,56)_$$ADMPRV^BDGF1(ADM,DFN,"ADM")  ;admt prov
 .. D SET(LINE,.VALMCNT)
 ;
 I '$D(^TMP("BDGVAH",$J)) D SET("NO ADMISSIONS FOUND",.VALMCNT)
 Q
 ;
SET(DATA,NUM) ; put display line into array
 S NUM=NUM+1
 S ^TMP("BDGVAH",$J,NUM,0)=DATA
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BDGVAH",$J) D KILL^AUPNPAT
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
