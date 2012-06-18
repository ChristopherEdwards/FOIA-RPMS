BDGICSET ;IHS/OIT/LJF - SET UP DATES FOR USE UNDER ICE;
 ;;5.3;PIMS;**1004,1005**;MAY 28, 2004
 ;IHS/OIT/LJF 09/08/2005 PATCH 1004 New routine
 ;IHS/OIT/LJF 04/20/2006 PATCH 1005 added STAFF subroutine
 ;                                  added display of medical staff
 ;
EN ; -- main entry point for BDG IC SETUP ICE
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BDG IC SETUP ICE")
 Q
 ;
HDR ; -- header code
 NEW X S X=$$GET1^DIQ(4,DUZ(2),.01)
 S VALMHDR(1)=$$SP(75-$L(X)\2)_X
 Q
 ;
INIT ; -- init variables and list array
 NEW FAC,LINE,FIELD
 S VALMCNT=0 K ^TMP("BDGICSET",$J)
 S FAC=$O(^BDGPAR("B",+$$DIV^BSDU,0)) I 'FAC D NONE Q
 ;
 F FIELD=.08,.12,201,.07,.13,202:1:208 D
 . S LINE=" "_$$PAD($$LABEL(FIELD)_":",50)_$$GET1^DIQ(9009020.1,FAC,FIELD)
 . D SET(LINE,.VALMCNT)
 . I FIELD=.13 D SET("",.VALMCNT)
 . I FIELD=206 D SET($$PAD(" DATE CHART COMPLETED USED IN ICE"_":",51)_"REQUIRED",.VALMCNT)
 ;
 ;IHS/OIT/LJF 04/20/2006 PATCH 1005 added display of medical staff for IC reports
 D SET("",.VALMCNT),SET("",.VALMCNT)
 D SET($$SP(10)_"*** MEDICAL STAFF INCLUDED ON SCREENED IC REPORTS ***",.VALMCNT)
 NEW IEN,CLASS,INACTIVE
 S IEN=0 F  S IEN=$O(^BDGPAR(FAC,3,IEN)) Q:'IEN  D
 . S PRV=$$GET1^DIQ(9009020.13,IEN_","_FAC,.01,"I")
 . S CLASS=$$PAD($E($$GET1^DIQ(200,PRV,53.5),1,20),23)
 . S INACTIVE=$$GET1^DIQ(200,PRV,53.4) I INACTIVE]"" S INACTIVE="Inactivated on "_INACTIVE
 . D SET($$PAD($E($$GET1^DIQ(200,PRV,.01),1,27),30)_CLASS_INACTIVE,.VALMCNT)
 ;end of PATCH 1005 new code
 ;
NONE ; if none found
 I '$D(^TMP("BDGICSET",$J)) D
 . S VALMCNT=1
 . S ^TMP("BDGICSET",$J,1,0)=$$SP(15)_"NO INFORMATION FOUND - CALL COMPUTER SUPPORT"
 Q
 ;
LABEL(FIELD) ; returns field's title or label
 NEW X
 S X=$$GET1^DID(9009020.1,FIELD,"","TITLE")
 I X="" S X=$$GET1^DID(9009020.1,FIELD,"","LABEL")
 Q X
 ;
SET(DATA,COUNT) ; put data into display line
 S COUNT=COUNT+1
 S ^TMP("BDGICSET",$J,COUNT,0)=DATA
 Q
 ;
EDIT ;EP; called by BDG IS SETUP EDIT protocol
 D FULL^VALM1
 NEW DIE,DA,DR
 S DA=$O(^BDGPAR("B",+$$DIV^BSDU,0))
 I DA S DIE="^BDGPAR(",DR=".08;.12;201;.07;.13;202:208" D ^DIE
 S VALMBCK="R" D TERM^VALM0,HDR,INIT
 Q
 ;
 ;IHS/OIT/LJF 04/20/2006 PATCH 1005 added this subroutine
STAFF ;EP; called by BDG IC MED STAFF protocol
 D FULL^VALM1
 S DA=$O(^BDGPAR("B",+$$DIV^BSDU,0))
 S DIE="^BDGPAR(",DR="3" D ^DIE
 S VALMBCK="R" D TERM^VALM0,HDR,INIT
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BDGICSET",$J)
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
