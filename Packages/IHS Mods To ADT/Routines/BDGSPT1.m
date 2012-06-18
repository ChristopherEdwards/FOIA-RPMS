BDGSPT1 ; IHS/OIT/LJF - DISPLAY PATIENTS ACCESSED BY A USER
 ;;5.3;PIMS;**1005,1007**;MAY 28,2004
 ;IHS/OIT/LJF 01/20/2006 PATCH 1005 Added this routine
 ;
 NEW BDGUSR,BDGBD,BDGED,SCREEN,BDGSORT
 S SCREEN="I $P(^VA(200,+Y,0),U,11)="""""
 ;S BDGUSR=+$$READ^BDGF("PO^200:EMQZ","Select USER",,SCREEN) Q:BDGUSR<1  cmi/anch/maw 8/23/2007 orig line PATCH 1007
 S BDGUSR=+$$READ^BDGF("PO^200:EMQZ","Select USER",,,SCREEN) Q:BDGUSR<1  ;cmi/anch/maw 8/23/2007 mod per linda fels PATCH 1007
 S BDGBD=$$READ^BDGF("DO^::EPX","Select EARLIEST DATE") Q:'BDGBD
 S BDGED=$$READ^BDGF("DO^"_BDGBD_":"_DT_":EX","Select LATEST DATE") Q:'BDGED
 S BDGSORT=$$READ^BDGF("SO^1:BY DATE;2:BY PATIENT NAME;3:BY OPTION","Select How You Want the Report SORTED")
 ;
EN ; -- main entry point for BDG SECURITY USER LIST
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BDG SECURITY USER LIST")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 NEW X
 S X=$$GET1^DIQ(200,+$G(BDGUSR),.01)
 S VALMHDR(1)=$$PAD("User:",12)_X
 S VALMHDR(2)="Date Range: "_$$RANGE^BDGF(BDGBD,BDGED)
 Q
 ;
INIT ; -- init variables and list array
 S VALMCNT=0 K ^TMP("BDGSPT1",$J),^TMP("BDGSPT1A",$J)
 ;
 NEW DFN,RVDT,START,END,LINE,SORT,IENS,X
 S START=(9999999.9999-(BDGED+.24))-.0001,END=(9999999.9999-BDGBD)
 S DFN=0 F  S DFN=$O(^DGSL(38.1,"AU",DFN)) Q:'DFN  D
 . S RVDT=START F  S RVDT=$O(^DGSL(38.1,"AU",DFN,BDGUSR,RVDT)) Q:'RVDT  Q:(RVDT>END)  D
 . . S ^TMP("BDGSPT1A",$J,$$SORT(DFN,RVDT),DFN,RVDT)=""     ;put patients found in sorted order
 ;
 ; now take sorted list and place into display array
 S SORT=0 F  S SORT=$O(^TMP("BDGSPT1A",$J,SORT)) Q:SORT=""  D
 . S DFN=0 F  S DFN=$O(^TMP("BDGSPT1A",$J,SORT,DFN)) Q:'DFN  D
 . . S RVDT=0 F  S RVDT=$O(^TMP("BDGSPT1A",$J,SORT,DFN,RVDT)) Q:'RVDT  D
 . . . S IENS=RVDT_","_DFN
 . . . S LINE=$$PAD(" "_$E($$GET1^DIQ(2,DFN,.01),1,21),24)_$J($$HRCN^BDGF2(DFN,DUZ(2)),6)  ;patient/chart#
 . . . S LINE=$$PAD(LINE,34)_$E($$READRVD^BDGF(RVDT),1,18)                    ;date/time accessed
 . . . ;S LINE=$$PAD(LINE,54)_$E($$GET1^DIQ(38.11,IENS,3),1,15)               ;option accessed  cmi/anch/maw 9/12/2007 orig line
 . . . S LINE=$$PAD(LINE,54)_$E($$GET1^DIQ(38.11,IENS,3),1,22)                ;option accessed cmi/anch/maw 9/12/2007 per ljf email PATCH 1007
 . . . ;S X=$$SENS(DFN,RVDT) I X]"" S LINE=$$PAD(LINE,70)_"/ "_X              ;sensitivity level cmi/anch/maw 9/12/2007 orig line
 . . . S X=$$SENS(DFN,RVDT) I X]"" S LINE=$$PAD(LINE,77)_"/ "_$E(X,1,2)       ;sensitivity level cmi/anch/maw 9/12/2007 per ljf email PATCH 1007
 . . . S VALMCNT=VALMCNT+1 D SET^VALM10(VALMCNT,LINE)                         ;store in display array
 ;
 I '$D(^TMP("BDGSPT1",$J)) S VALMCNT=1 D SET^VALM10(1,$$SP(10)_"No data found")
 K ^TMP("BDGSPT1A",$J)
 Q
 ;
SORT(PAT,RVDT) ; returns sort value for entry
 I BDGSORT=1 Q RVDT
 I BDGSORT=2 Q $$GET1^DIQ(2,PAT,.01)
 NEW X S X=$$GET1^DIQ(38.11,RVDT_","_PAT,3)
 Q $S(X="":"UNKNOWN",1:X)
 ;
SENS(PAT,RVDT) ; returns patient's sensitivity level on date, if known
 ;status as to patinet being an inpatient or outpatient on date is returned too
 NEW DATE,STATUS
 S X=$$GET1^DIQ(38.11,RVDT_","_PAT,4),STATUS=$S(X="YES":"INPT",X="NO":"OUTPT",1:"")
 S DATE=9999999.9999-RVDT
 I DATE<($$GET1^DIQ(38.1,PAT,4,"I")) Q "UNK"_"-"_STATUS
 Q $E($$GET1^DIQ(38.1,PAT,2),1,3)_"-"_STATUS
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BDGSPT1",$J)
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
